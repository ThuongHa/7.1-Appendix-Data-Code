#!/bin/bash

#set variables#
svpath=/home/neuro/Documents/Thuong/2017/Genomes/CNV_SV
pro=$1

for i in delly lumpy manta retro;
do
	cd ${svpath}/${i}/${pro}
	mkdir inher
	outpath=${svpath}/${i}/${pro}/inher
	for a in ${svpath}/${i}/${pro}/mib/*;
	do
		outname=$(basename ${a} .mib)
		awk '{if ($4 == 1 && $6 == 1) print}' ${a} > ${outpath}/${outname}.dn
		awk '{if ($4 == 3 && $6 == 1) print}' ${a} > ${outpath}/${outname}.hr
		awk '{if ($4 == 2 && $6 == 1) print}' ${a} > ${outpath}/${outname}.ch;
	done;
done
