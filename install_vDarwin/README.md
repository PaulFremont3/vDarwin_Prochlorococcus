To install vDarwin on your machine (HPC necessary):

dependencies (or equivalent):

gcc/8.4.0 (including gfortran/8.4.0)
netcdf/4.7.3/gcc/8.4.0/openmpi/3.1.5/zen/
netcdf-cxx/gcc/8.4.0/openmpi/3.1.5/
openmpi/3.1.5/gcc/8.4.0/
netcdf-fortran/4.5.2/gcc/8.4.0/openmpi/3.1.5/

- Download the github repository: `git clone -b virus https://github.com/jahn/darwin3`
- compile the code: `cd build_3D/`, run `./compile.sh`
