# Another Great Paper

## Dependencies
- A TeX distribution (e.g., [TeXLive](https://tug.org/texlive/))
- The [IEEEtran](https://ctan.org/pkg/ieeetran) package
- [GNU Make](https://www.gnu.org/software/make/) (optionally, if you wish to use the
  [Makefile](./Makefile))
- [latexdiff](https://ctan.org/pkg/latexdiff) (optionally, if you wish to use
  [`build-diff.sh`](./scripts/build-diff.sh))
- [GNU sed](https://www.gnu.org/software/sed/) (optionally, if you wish to use
  [`build-diff.sh`](./scripts/build-diff.sh))

## How to use
You can build the paper using the [Makefile](./Makefile):
```console
$ make
$ make open  # on Linux/macOS
```
To auto-rebuild on any change made in the source code:
```console
$ make watch
```
To remove build artifacts (**including generated PDF(s)**):
```console
$ make clean
```

## Repo layout
- `assets/`: contains any assets used in the paper (experiment data, image files, ...).
- `build/`: contains the build artifact and the generated PDF(s). **This directory is
  auto-generated and can be removed via `make clean` - do not store anything intended to be
  persistent in it.**
- `scripts/`: contains useful scripts for the paper. See [_Scripts_](#scripts) below.
- `src/`: contains the source code (LaTeX) for the paper.

### Scripts
- `build-diff.sh`: builds a "PDF diff" between two versions of the paper. For example,
  `./script/build-diff.sh old-rev new-rev` builds a PDF diff between revisions `old-rev` and
  `new-rev`.
