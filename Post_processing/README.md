This folder contains all codes and data to post process model output data and reproduce article figure panels.

Dependencies: R version 4.3.2, R libraries: ncdf4, viridis, matlab, pals, RColorBrewer, RANN, maps, vioplot

##1. Post process each simulation
YThis step is possible only if you ran simulations beforehand (follow steps in folders `run/` then `Simulations/`. Following steps can be done directly (`.rds` files are availble in the folder)  
For each simulations, run the post processing that will save outputs as `.rds` files (convenient for R)
