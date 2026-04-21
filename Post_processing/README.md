This folder contains all codes and data to post process model output data and reproduce article figure panels.

Dependencies: R version 4.3.2 or equivalent, R libraries: ncdf4, viridis, matlab, pals, RColorBrewer, RANN, maps, vioplot

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
## 4. Figure panels
- Figure 1
  - 1a: run `Rscript template_map.R`, output is `template_map.pdf`, used for figure 1a. Currents and the rest of the figure were done manually in Inkscape
- Figure 2
  - 2a,b,c,d,e,g,h: pages 6,5,19,27,26,76,75 of `3D_darwin_maps_comparisons_bis_0_mol_ref-no_virus.pdf`
  - 2f,i: pages 10 and 7 of `3D_darwin_maps_virus_shunt-100.pdf`
- Figure 3
  - 3a-f: pages 14, 8, 2, 46, 40 and 34 of `3D_darwin_maps_comparisons_deltas_bis_log10_mol_ref-no_virus_shunt.pdf`
- Figure 4
  - 4a and b: pages 5 and 8 of `npp_plot_stats_no_virus_shunt_all.pdf`
  - 4c-h: pages 130, 124, 121, 118, 115 and 112 of `3D_darwin_maps_comparisons_deltas_bis_log10_mol_ref-no_virus_shunt_all.pdf`
- Figure 5
  - 5a-i: pages 126, 120, 114, 302, 296, 290, 158, 152 and 146 of `3D_darwin_maps_comparisons_deltas_bis_log10_mol_ref-no_virus_shunt.pdf`
- Figure 6
  - 6a: page 65 of `3D_darwin_maps_no_virus.pdf`
  - 6b,d,f: page 11, 7, 1 of `3D_darwin_maps_comparisons_oligotrophic_regions_trop_0_ind_ref-no_virus_shunt.pdf`
  - 6c,e: page 190 and 178 of `3D_darwin_maps_comparisons_deltas_bis_log10_ind_ref-no_virus_shunt.pdf`
  - 6g,h: page 19 and 22 of `3D_darwin_maps_comparisons_oligotrophic_regions_trop_0_ind_ref-no_virus_shunt_all.pdf`
- Figure 7
  - 7a: page 1 of `transect_position_oligotrophic_lat_transect.pdf`
  - 7b,c,d: page 71, 113, 70, 112, 67, 109 of `oligotrophic_lat_transect_darwin_maps_comparisons_log10_mol_ref-no_virus_shunt.pdf`
  - 7e: page 1 of `transect_position_oligotrophic_lon_transect.pdf`
  - 7f,g,h: page 71, 113, 70, 112, 67, 109 of `oligotrophic_lon_transect_darwin_maps_comparisons_log10_mol_ref-no_virus_shunt.pdf`
- Figure S1
  - S1a-h: pages 2,5,23,26,30,33,72,75 of `3D_darwin_maps_comparisons_deltas_bis_log10_mol_ref-virus_I.pdf`
- Figure S2
  - S2a-c: pages 62,57,54 of `3D_darwin_maps_comparisons_deltas_bis_log10_mol_ref-virus.pdf` 
- Figure S3
  - S3a-j: pages 90, 89, 231, 230, 104,103,145,144,138,137 of `3D_darwin_maps_comparisons_bis_0_mol_ref-no_virus.pdf` 
- Figure S4: page 73 of `3D_darwin_maps_comparisons_deltas_bis_log10_mol_ref-no_virus_misc.pdf`
- Figure S5
  - S5a,b: pages 9 and 10 of `3D_darwin_maps_comparisons_new-prod_regions_log10_mol_ref-no_virus.pdf` 
- Figure S6
  - S6a-c: 206, 200, 194 of `3D_darwin_maps_comparisons_deltas_bis_log10_mol_ref-no_virus_shunt.pdf` 
- Figure S7
  - S7a-d: pages 20, 12, 8, 4 of `3D_darwin_maps_comparisons_new-prod_regions_bis_log10_mol_ref-no_virus.pdf` 
- Figure S8
  - S8a,b: pages 21 and 22 of `3D_darwin_maps_comparisons_oligotrophic_regions_trop_0_mol_ref-no_virus_shunt.pdf` 
- Figure S9
  - S9a: same as 7a
  - 6b,c: pages 59, 94, 56, 91 of `oligotrophic_lat_transect_darwin_maps_comparisons_delta_log10_mol_ref-no_virus_shunt.pdf` 
  - S9d: same as 7e
  - 6e,f: pages 59, 94, 56, 91 of `oligotrophic_lon_transect_darwin_maps_comparisons_delta_log10_mol_ref-no_virus_shunt.pdf` 

Note 1: color legends gradients are available after maps of all simualtions for all tracers
Note 2: for log-ratios, CDF and PDF plots are availbale in the next page of the given map

