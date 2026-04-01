#!/bin/bash
#SBATCH -J comparisons_transect                           # Job name
#SBATCH -N1 --ntasks-per-node=1                # Number of nodes and cores per node required
#SBATCH --mem-per-cpu=1G                        # Memory per core
#SBATCH  --time=01:00:00                        # Duration of the job (Ex: 10 mins)
#SBATCH -o run_comparisons_transect-%j.out                        # Combined output and error messages file

Rscript comparisons_transect.R $1 $2 $3 $4 $5 $6 $7 $8 $9


# $1 scale 0 or log10
# $2 type ind or mol
# $3 lat0
# $4 lat1 
# $5 lon0
# $6 lon1
# $7 name
# $8 save 0 or 1
# $9 ref_sim

#lon transect: 22.5 22.5 120 240
#lat transect: 0 40 190 190 
