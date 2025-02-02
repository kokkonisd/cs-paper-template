#!/usr/bin/env bash

## Generate a diff of two versions of the paper using latexdiff.
##
## Usage: ./scripts/build-diff.sh <OLD COMMIT> <NEW COMMIT [default: main]>
##
## Examples:
## * Compare the current `main` to the `conf25/submission-1` tag:
##   ./scripts/build-diff.sh conf25/submission-1


if [ $# -lt 1 ]
then
    echo "Usage: $0 <OLD COMMIT/TAG/BRANCH> <NEW COMMIT/TAG/BRANCH [default=HEAD]>" 1>&2
    exit 1
fi


old_commit="$1"
new_commit="${2:-HEAD}"
tmp_dir="${TMPDIR:-/tmp}"
old_repo_dir=$tmp_dir/paper-old
new_repo_dir=$tmp_dir/paper-new
temp_file=$tmp_dir/diff_temp.tex


## Print an error message and exit.
##
## Parameters:
## * `message` - The message to print.
error_message() {
    local message

    if [[ $# -ne 1 ]]
    then
        1>&2 echo -e "\e[1m[build-diff]\e[0m  \e[31mERROR: (INTERNAL) incorrect arguments to" \
                     "``error_message(message)``.\e[0m"
        exit 1
    fi

    message=$1

    echo -e "\e[1m[build-diff]\e[0m  \e[31mERROR: $message\e[0m" 1>&2
    exit 1
}

## Print an info message.
##
## Parameters:
## * `message` - The message to print.
info_message() {
    local message

    if [[ $# -ne 1 ]]
    then
        error_message "(INTERNAL) incorrect arguments to ``info_message(message)``."
    fi

    message=$1

    echo -e "\e[1m[build-diff]\e[0m  \e[32m$message\e[0m" 1>&2
}


## Prepare a directory containing a specific version of the paper to be used in the diff.
##
## Parameters:
## * `source_dir` - An up-to-date clone of the paper repo.
## * `target_dir` - A temporary directory where we can store this version of the paper.
## * `commit` - The commit to checkout for this version of the paper.
prepare_paper_dir() {
    local source_dir target_dir commit

    if [[ $# -ne 3 ]]
    then
        error_message "(INTERNAL) incorrect arguments to" \
                      "``prepare_paper_dir(source_dir, target_dir, commit)``."
    fi

    source_dir=$1
    target_dir=$2
    commit=$3

    rm -rf $target_dir/

    info_message "Copying $source_dir -> $target_dir..."
    cp -r $source_dir/ $target_dir/

    pushd . >/dev/null 2>&1
        cd $target_dir/
        info_message "$target_dir: checking out $commit..."
        git checkout --force $commit >/dev/null 2>&1 \
            || error_message "failed to check out $commit." \

        info_message "$target_dir: patching (DIFnomarkup)..."
        # We need to "escape" any figures before calling latexdiff, just in case they contain
        # tikzpictures (which latexdiff will most likely mess up).
        #
        # First, we need to define the `DIFnomarkup` environment.
        sed -i 's/\(\\title{\)/\\newenvironment{DIFnomarkup}{}{}\n\1/g' src/main.tex
        # Then we need to protect all figures with it.
        sed -i 's/\(\\begin{figure[*]\?}\)/\\begin{DIFnomarkup}\n\1/g' src/*.tex src/**/*.tex
        sed -i 's/\(\\end{figure[*]\?}\)/\1\n\\end{DIFnomarkup}/g' src/*.tex src/**/*.tex

        info_message "$target_dir: building..."
        # Build the paper to get the .bbl file.
        # `make all` is a fallback for older versions of the Makefile.
        make clean >/dev/null 2>&1 \
            && make paper >/dev/null 2>&1 \
            || make all >/dev/null 2>&1 \
            || error_message "failed to build. See $target_dir/build/main.log."
        cp build/main.bbl src/

        # Unfortunately, .bbl files use `\hskip`, which can heavily mess up the diff. In order to
        # avoid that, we can convert `\hskip` to `\hspace` and wrap its contents in `{}`.
        # The `\hskip` command is expected to have the syntax
        # `\hskip X plus X minus X\relax`, where X is a number (integer or float) and a unit (e.g.,
        # "em"). However, since it's legal to have newlines where the spaces are in the syntax, we
        # need to tell sed to replace newlines with NUL bytes and take that into account in the
        # pattern.
        spaces="[ \t\r\n\0]\+"
        length="[0-9.]\+\(pt\|mm\|cm\|in\|ex\|em\|mu\|sp\)"
        hskip_pattern="$length\($spaces\(plus\|minus\)$spaces$length\)*"
        sed -zi "s/\\hskip \($hskip_pattern\)/\\hspace{\1}/g" src/main.bbl
    popd >/dev/null 2>&1
}

prepare_paper_dir $PWD $old_repo_dir $old_commit
prepare_paper_dir $PWD $new_repo_dir $new_commit

info_message "Computing diff..."
# Compute the diff.
latexdiff --flatten \
    $old_repo_dir/src/main.tex $new_repo_dir/src/main.tex \
    >$temp_file 2>/dev/null \
    || error_message "failed to compute diff. Inspect {$old_repo_dir,$new_repo_dir}/src/main.tex."

info_message "Building diff..."
# Build the diff.
cp $temp_file $new_repo_dir/src/main.tex
pushd . >/dev/null 2>&1
    cd $new_repo_dir/
    make paper >/dev/null 2>&1 \
        || error_message "failed to build. See $new_repo_dir/build/main.log."
popd >/dev/null 2>&1

# Copy the diff to the current directory.
diff_dest=$PWD/build/diff.pdf
cp $new_repo_dir/build/main.pdf $diff_dest
info_message "Done! Diff can be found at $diff_dest."
