To install vDarwin on your machine (openmpi HPC necessary):

dependencies (or equivalent):

gcc/8.4.0 (including gfortran/8.4.0)  
netcdf/4.7.3/gcc/8.4.0/openmpi/3.1.5/zen/  
netcdf-cxx/gcc/8.4.0/openmpi/3.1.5/  
openmpi/3.1.5/gcc/8.4.0/  
netcdf-fortran/4.5.2/gcc/8.4.0/openmpi/3.1.5/  

- Download the github repository: `git clone -b virus https://github.com/jahn/darwin3`
- enter the folder: `cd darwin3`
- create a folder where you will run the study: `mkdir dar12`, `cd dar12`  # You will run the whole study in this folder
- move the compile and code folder in the `dar12/` directory: `mv -r  ../../build_3D/` and `mv -r  ../../code_vdarwin_3P1V1Z_3D/`
- compile the code: `cd build_3D/`, run `./compile.sh 1` the output file is the executable `mitgcmuv_1` used to run simulations (note that this executable is already provided in each simulations folder)
- move all simulation folders in the `dar12` folder: `cd ../`, `mv -r ../../../Simulations/*/ .`
- move the Post_prcessing folder in the `dar12` folder: `mv -r ../../../Post_processing/ .`
- follow instructions from the `README.md` file from the `Simulations/` folder to run simulations
- follow instructions from the `README.md` file from the `Post_processing/` folder to post process model data and create figure panels (pdfs)
