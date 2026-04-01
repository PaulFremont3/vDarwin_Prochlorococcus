This folder contains subfolders necessary to run all simulations of the manuscript, including model parameterization files, the executable (same `mitgcmuv_1` file, placed in each folder) and the `.sbatch` file to launch the simulation on a HPC.

To follow the steps in this folder you must have downloaded and compiled vDarwin (folder `run/`)  
  
dependencies: 

gcc/8.4.0 (including gfortran/8.4.0)  
netcdf/4.7.3/gcc/8.4.0/openmpi/3.1.5/zen/  
netcdf-cxx/gcc/8.4.0/openmpi/3.1.5/  
openmpi/3.1.5/gcc/8.4.0/  
netcdf-fortran/4.5.2/gcc/8.4.0/openmpi/3.1.5/ 

In each directory:
- run the simulation (on 96 cores, 3 to 6 hours): `sbatch run_3D_vDARWIN.sbatch *date*` => this runs the simulation and will store output data in the folder `diags_mds` and at the end of the simulation will place them in a new directory called `diags_mds_*date*/`
- after the simulation is over, convert binary output files to `.nc` files: `sbatch run_process_last_year_to_nc.sbatch *date*`, .nc files are also stored in `diags_mds_*date*/`

In each folder, the viral shunt parameter is in the file `data.traits`, output diagnostics that you choose to save are in the file `data.diagnostics`
