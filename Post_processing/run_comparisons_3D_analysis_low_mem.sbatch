#!/bin/bash
#SBATCH -J comparisons_3D_analysis                           # Job name
#SBATCH -N1 --ntasks-per-node=1                # Number of nodes and cores per node required
#SBATCH --mem-per-cpu=1G                        # Memory per core
#SBATCH  --time=01:00:00                        # Duration of the job (Ex: 10 mins)
#SBATCH -o run_comparisons_3D_analysis-%j.out                        # Combined output and error messages file

Rscript comparisons_3D_analysis.R $1 $2 $3 $4 $5 $6
