#!/bin/bash
#SBATCH -J 3D_vDARWIN                           # Job name
#SBATCH -N1 --ntasks-per-node=96                 # Number of nodes and cores per node required
#SBATCH --mem-per-cpu=4G                        # Memory per core
#SBATCH  --time=10:00:00                        # Duration of the job (Ex: 10 mins)
#SBATCH -o run_3D_vDARWIN-%j.out                        # Combined output and error messages file

module load gcc/8.4.0
module load netcdf/4.7.3/gcc/8.4.0/openmpi/3.1.5/zen/
module load netcdf-cxx/gcc/8.4.0/openmpi/3.1.5/
module load openmpi/3.1.5/gcc/8.4.0/
module load netcdf-fortran/4.5.2/gcc/8.4.0/openmpi/3.1.5/

mkdir params_$1
cp data* params_$1/

ulimit -n 4096
ulimit -s unlimited

mkdir -p diags_mds

mpirun -np 96 ./mitgcmuv_1 > out.dat 

mkdir -p diags_mds_$1

mv *.data diags_mds_$1/
mv *.meta diags_mds_$1/
