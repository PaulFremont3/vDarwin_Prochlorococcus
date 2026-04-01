This folder contains all codes and data to post process model output data and reproduce article figure panels.

Dependencies: R version 4.3.2, R libraries: ncdf4, viridis, matlab, pals, RColorBrewer, RANN, maps, vioplot

## 1. Post process each simulation: script `3D_darwin_post_process.R`
This step is possible only if you ran simulations beforehand (follow steps in folders `run/` then `Simulations/`. Following steps can be done directly (`.rds` files are availble in the zenodo archive)  
For each simulations, run the post processing that will save outputs as `.rds` files (convenient for R): 
- change to the correct date of your simulation in each line in the file `run_post_process.sh`
- run: `./run_post_process.sh`, each post processing should take around 1 hour
- outputs:
  - `data_3D_darwin_10th_year_*suffix*.rds` where *suffix* is in (no_virus, virus_shunt-100, virus_shunt-90, virus_shunt-75, virus_shunt-60, virus_shunt-50, virus_shunt-25, virus_shunt-0, virus_shunt-100_no_I, virus_shunt-100_no_DON_transport, virus_shunt-100_I_growth) => this stores the data
  - `3D_darwin_maps_*suffix*.pdf`: maps of each tracers for each simulation

## 2. Run global scale maps model comparisons: script `comparisons_3D_analysis.R`
- run all comparisons: `./run_comparisons_save.sh` => this will run and save (as `.rds` files) all model comparisons necessary for figure generation (maximum run time should be around 2 hours). If plotting is necessary again, use `./run_comparisons_plot.sh` to only run plotting (20 minutes maximum run time)

## 3. Run transect comparisons: script `comparisons_transect.R`
- run transects comparisons: `./run_comparisons_transect_save.sh` => this will run and save (as `.rds` files) all model comparisons necessary for figure generation (maximum run time should be around 5 minutes). If plotting is necessary again, use `./run_comparisons_transect_plot.sh` to only run plotting (20 seconds maximum run time)

