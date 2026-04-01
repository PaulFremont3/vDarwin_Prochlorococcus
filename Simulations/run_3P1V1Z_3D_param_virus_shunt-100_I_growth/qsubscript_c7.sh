#!/bin/sh
#SBATCH -J dar9_v
#SBATCH -p sched_mit_darwin2    # which queue ("partition")
#SBATCH -N 6                    # number of nodes to use (each has 16 cores)
#SBATCH --constraint=centos7
#SBATCH --ntasks-per-node 16    # total number of cores to run on
#SBATCH --mem 0      # memory per core needed (16-core nodes have 64GB)
#SBATCH --time 12:00:00         # run no longer than 16 hours
#SBATCH -x node[665-672]

module load intel/2020-04
module load impi/2020-04
module use /orcd/data/mick/007/jahn/software/modulefiles
module load jahn/netcdf-fortran/4.5.3_intel-2020-04

mpirun ./mitgcmuv_dar10_3P1Z1V_3d_newcode

