#!/bin/bash
#SBATCH -J comparisons_3D_analysis                           # Job name
#SBATCH -N1 --ntasks-per-node=1                # Number of nodes and cores per node required
#SBATCH --mem-per-cpu=1G                        # Memory per core
#SBATCH  --time=01:00:00                        # Duration of the job (Ex: 10 mins)
#SBATCH -o run_comparisons_3D_analysis-%j.out                        # Combined output and error messages file

#SBATCH --exclude=compute-b5-[1-2,18],compute-b6-[4-7,9-10,13,15-17,20,49,51],compute-b7-[9,21-22,24-25,28-34,37,39,43-49,51,53-54,57,59],compute-b8-[5,7,22-25,28-31,47],compute-b8-60,compute-b8-[57-59],compute-b7-36,compute-b7-[41-42],compute-b6-[50,53-54,56],compute-b6-[4,9,13,16-17,20],compute-b7-[21-22,32-34,37,39,43-48,51],compute-b8-[5,7,22-24,28-31],compute-b5-[1-2,18,51,53-54],compute-b6-[5-7,11,15,18,25,39,47-48],compute-b7-[9,15,35,38,58],compute-b8-[11,19,21,25-26,43,47,49],compute-b5-[3-17,19-20],compute-b6-[1-3,12,19,34,41,45-46,52,58-59],compute-b7-[1-8,10-14,16,18-19,50,55],compute-b8-[2-4,6,13-14,16-17,20,27,32-42,44-45,50-52,60],compute-b5-[21-50,52,55-60],compute-b6-[8,10,14,21-24,26-33,35-38,40,42-44,49,51,55,57,60],compute-b7-[17,20,23-31,40,49,52-54,56-57,59-60],compute-b8-[1,8-10,12,15,18,46,54-59],compute-b7-36,compute-b7-[41-42],compute-b6-50,compute-b6-[4,9,13,16-17,20],compute-b7-[21-22,32-34,37,39,43-48,51],compute-b8-[5,7,22-24,28-31],compute-b5-[1-2,18,51,53-54],compute-b6-[5-7,11,15,18,25,39,47-48],compute-b7-[9,15,35,38,58],compute-b8-[11,19,21,25-26,43,47,49],compute-b6-[1-3,12,19,34,41,45-46,52],compute-b7-[1-8,10-14,16,18-19,50,55],compute-b8-[2-4,6,13-14,16-17,20,27,32-42,44-45,50-52],compute-b5-[21-50,52,55-60],compute-b6-[8,10,14,21-24,26-33,35-38,40,42-44,49,51],compute-b7-[17,20,23-31,40,49,52-54,56-57,59-60],compute-b8-[1,8-10,12,15,18,46,54-56],compute-b6-[53-54,56],compute-b6-[58-59],compute-b6-[55,57,60],compute-b8-48




Rscript comparisons_3D_analysis.R $1 $2 $3 $4 $5 $6
