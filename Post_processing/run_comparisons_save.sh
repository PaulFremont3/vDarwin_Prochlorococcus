#!/bin/bash
types="mol ind"
scales="0 log10"

refs="virus no_virus no_virus_shunt virus_shunt no_virus_shunt_all virus_shunt_all no_virus_misc virus_misc no_virus_I virus_I"
#refs="no_virus_shunt_all"
#refs="no_virus_I virus_I"

for t in $types;
do
	for s in $scales;
	do
		for re in $refs;
		do	
			sbatch run_comparisons_3D_analysis.sbatch $s $t int world $re 1;
		done
	done
done
