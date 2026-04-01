#!/bin/bash
make clean
../../tools/genmake2 -mpi -optfile=../../tools/build_options/linux_amd64_gfortran -mods=../code_vdarwin_3P1V1Z_3D/
make depend
make
