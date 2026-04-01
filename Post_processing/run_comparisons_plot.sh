#!/bin/bash
types="mol ind"
scales="0 log10"
#refs="all_no_virus all_virus no_virus virus virus_shuttle no_virus_shuttle"
#refs="virus_shuttle no_virus_shuttle"
#refs="virus no_virus no_virus_shunt virus_shunt"
refs="virus no_virus no_virus_shunt virus_shunt no_virus_shunt_all virus_shunt_all no_virus_misc virus_misc virus_I no_virus_I"
#refs="no_virus_shunt no_virus_shunt_all"
for t in $types;
do
	for s in $scales;
	do
		for re in $refs;
		do	
			sbatch run_comparisons_3D_analysis_low_mem.sbatch $s $t int world $re 0;
		done
	done
done
