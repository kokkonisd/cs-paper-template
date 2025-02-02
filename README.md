# CS paper template
This repo contains a template for Computer Science papers written in LaTeX. It might not cover all
aspects of all fields of CS, but it should be a good start for most people (it is tuned to my
personal preference).

## How to use
The two main LaTeX templates used by CS conferences are [`IEEEtran`](https://ctan.org/pkg/ieeetran)
and [`acmart`](https://ctan.org/pkg/acmart). In order to best adapt to each of them, there are two
directories (named [`ieeetran`](./ieeetran) and [`acmart`](./acmart)) on this repo; you should use
the one which corresponds to your target conference's template.

You should follow these steps to adapt the template to your needs:
1. Clone this repo:
   ```console
   $ git clone https://github.com/kokkonisd/cs-paper-template.git
   ```
2. (Optionally) checkout a specific version:
   ```console
   $ git checkout 0.1.0
   ```
3. Copy the template directory of your choosing (e.g., `ieeetran/`):
   ```console
   $ cp -r ieeetran/ /path/to/my-paper/
   ```
4. Initialize the Git repository of your paper in the directory you just copied.
   ```console
   $ git init
   ```
5. In `README.md` (the template README), replace `# Another Great Paper` with the actual title of
   the paper.
6. In `src/main.tex`, change `\title{Another Great Paper}` to the actual title of your paper.
   Change the author list (under `\author{...}`). Note that you can use the
   `\cameraready{true,false}` macro to switch between review mode (anonymous) and camera-ready
   mode. There might also be other metadata (such as `\acmConference` in the `acmart` template)
   that you need to edit or add to the existing code.
7. If you add more scripts under `scripts/` or need to note more dependencies, make sure to update
   the appropriate sections in `README.md`.

## License
The license found in [`LICENSE`](./LICENSE) is the [Creative Commons Attribution-ShareAlike 4.0
International](https://creativecommons.org/licenses/by-sa/4.0/?ref=chooser-v1) and it applies to
the _template_ (i.e., the contents of this repo), not your paper. Both the `IEEEtran` and `acmart`
LaTeX templates are licensed under [the LaTeX Project Public License 1.3
(LPPL-1.3c)](https://ctan.org/license/lppl1.3).
