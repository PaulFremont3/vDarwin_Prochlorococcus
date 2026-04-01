This folder contains all codes and data to post process model output data and reproduce article figure panels.

Dependencies: R version 4.3.2, R libraries: ncdf4, viridis, matlab, pals, RColorBrewer, RANN, maps, vioplot

## 1. Post process each simulation: script `3D_darwin_post_process.R`
This step is possible only if you ran simulations beforehand (follow steps in folders `run/` then `Simulations/`. Following steps can be done directly (`.rds` files are availble in the folder)  
For each simulations, run the post processing that will save outputs as `.rds` files (convenient for R): 
- change to the correct date of your simulation in each line in the file `run_post_process.sh`
- run: `./run_post_process.sh`, each post processing should take around 1 hour

## 2. Run global scale maps model comparisons

