#!/bin/bash
#SBATCH --job-name=run_process_last_year_to_nc
#SBATCH --output=run_process_last_year_to_nc_%j.out
#SBATCH --error=run_process_last_year_to_nc_%j.err
#SBATCH --time=00:20:00        # 20 minutes is plenty
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=4G               # Enough to hold the largest file in RAM
#SBATCH --partition=standard

#1 modules
module purge
module load gcc/8.4.0
module load netcdf/4.7.3/gcc/8.4.0/openmpi/3.1.5/zen/
module load netcdf-cxx/gcc/8.4.0/openmpi/3.1.5/
module load openmpi/3.1.5/gcc/8.4.0/
module load netcdf-fortran/4.5.2/gcc/8.4.0/openmpi/3.1.5/

# 2. Run your bash script with the date input
./process_last_year_to_nc.sh $1
