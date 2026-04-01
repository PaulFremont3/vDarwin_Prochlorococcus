#!/bin/bash
types="mol ind"
scales="0 log10"

#refs="virus no_virus no_virus_shunt virus_shunt no_virus_shunt_all virus_shunt_all no_virus_misc virus_misc"
#refs="no_virus_shunt_all"
refs="no_virus"

for t in $types;
do
	for s in $scales;
	do
		for re in $refs;
		do	
			sbatch run_comparisons_transect.sbatch $s $t 0 40 180 180 oligotrophic_lat_transect 0 $re;
			sbatch run_comparisons_transect.sbatch $s $t 22.5 22.5 120 240 oligotrophic_lon_transect 0 $re;
		done
	done
done
