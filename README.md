This repository contains all code and data needed to reproduce the figures and tables in the paper:

Frémont *et al.*, *Viral impacts on plankton standing stocks, primary productivity, and biogeochemistry in a model ocean*.

### Download
`git clone https://github.com/PaulFremont3/vDarwin_productivity/`

### Tutorial
The folder `run/` contains a tutorial on how to install and compile vDarwin. The folder `Simulations/` contain 1 subfolder per simulation that contain parameterization files for each simulations of the study. The folder `Post_processing/` contains scripts to post process model outputs data and create figure panels from the manuscript (pdf outputs). Each folder contains its own tutorial.

Subfolders `Simulations/` and `Post_processing/` contains a `README.md` that:

1. Describes relevant files
2. Explain how to run the codes
3. Explain where the figure panels are in the generated pdfs (for `Post_processing/`)

The steps from each folder can be performed independently except the `Post_processing/3D_darwin_post_process.R` step that post process raw model outputs in R. To run this step, you will have to run simulations (follow steps in `run/` then `Simulations/` folders). For following steps in  `Post_processing/`, required data to visualize model outputs are provided. The code from `Post_processing/` generates additional outputs beyond those presented in the paper.

If you wish to run the whole study, the tutorial is written so that all the study is done in the folder `run/` (you will move folders `Simulations/` and `Post_processing/` inside this folder at some point, see `README.md` in `run/`).


