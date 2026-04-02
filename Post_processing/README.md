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
- run all comparisons: `./run_comparisons_save.sh` => this will run and save (as `.rds` files) all model comparisons necessary for figure generation (maximum run time should be around 2 hours). If plotting is necessary again, use `./run_comparisons_plot.sh` to only run plotting (20 minutes maximum run time and low memory)
- outputs:
  - `latitude_vs_mortality.pdf`: latitude vs mortality pdf
  - `latitude_vs_delta_mortality.pdf` latitude vs delta mortality pdf
  - `3D_darwin_maps_comparisons_bis_*sca*_*type*_ref-*ref_sim*.pdf`: pdfs of comparisons on the same scale
  - `3D_darwin_comparisons_correlations_PI_bis_ref-*ref_sim*.pdf`: pdfs of correltaion between percentage infected and other variables
  - `3D_darwin_comparisons_correlations_bis_ref-*ref_sim*.pdf`: pdfs of correlations between mortality types (%, rate and fluxes)
  - `3D_darwin_maps_comparisons_deltas_ZV_mort_bis_*sca*_*type*_ref-*ref_sim*.pdf`: pdfs of delta phytoplankton mortalities (Z and V)
  - `3D_darwin_maps_comparisons_ratios_ZV_bis_*sca*_*type*_ref-*ref_sim*.pdf`: pdfs of phytoplankton mortality ratios (Z and V)
  - `3D_darwin_maps_comparisons_deltas_bis_*sca*_*type*_ref-*ref_sim*.pdf'`: pdfs of model comparisons to the reference/control simulation (% change or log-ratios)
  - `3D_darwin_maps_comparisons_new-prod_regions_*sca*_*type*_ref-*ref_sim*.pdf`: pdfs of classification of increased productivity region, their sizes and productivity distriubtion according to changes in the DNR (>0 or <0)
  - `3D_darwin_maps_comparisons_new-prod_regions_bis_*sca*_*type*_ref-*ref_sim*.pdf`: pdfs of classification of increased productivity region, their sizes and productivity distriubtion according to changes in the DNR (more subclasses)
  - `3D_darwin_maps_comparisons_oligotrophic_regions_*reg*_*sca*_*type*_ref-*ref_sim*.pdf`: pdfs of region classification (oligotrophic and hyper-oligotrophic)
  - `npp_plot_stats_*ref_sim*.pdf'`: pdfs of changes in increased productivity area and tottal production
  PDFs are available for different input parameters to the simulation:
    - sca: 0 (linear) or log10 scale
    - type: ind or mol (unit of visualization and legend)
    - ref_sim: refers to the list of simulations that are being compared and to the reference/control simulation (last of the suffixes list, see code and `run_comparisons_save.sh` for code names)
    - *reg*: for the oligotrophic region classification: all (classified over the all ocean) or trop (classified between 40S and 40N)

## 3. Run transect comparisons: script `comparisons_transect.R`
- run transects comparisons: `./run_comparisons_transect_save.sh` => this will run and save (as `.rds` files) all model comparisons necessary for figure generation (maximum run time should be around 5 minutes). If plotting is necessary again, use `./run_comparisons_transect_plot.sh` to only run plotting (20 seconds maximum run time and low memory)
- outputs:
  - `transect_position_*name*.pdf'`: transect position
  - `*name*_darwin_maps_comparisons_*sca*_*type*_ref-*ref_sim*.pdf'`: pdfs of model comparisons on the same scale
  - `*name*_darwin_maps_comparisons_delta_*sca*_*type*_ref-*ref_sim*.pdf'`: pdfs of comparisons of model to the reference/control simulation (% change or log-ratios)
## 4. Figure data
- Figure 1
- Figure 2
- Figure 3
- Figure 4
- Figure 5
- Figure 6
- Figure 7
- Figure S1
- Figure S2
- Figure S3
- Figure S4
- Figure S5
- Figure S6
- Figure S7
- Figure S8
- Figure S9

