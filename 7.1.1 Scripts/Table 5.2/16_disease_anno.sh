#!/bin/bash -x

# this script is used to find variants that overlap with full length canonical transcripts

# set variables #
svpath=/home/neuro/Documents/Thuong/2017/Genomes/CNV_SV
pro=$1
diseaseref=/home/neuro/Documents/Thuong/2017/Ref/disease

# make disease directory #
for i in delly lumpy manta retro;
do
	cd ${svpath}/${i}/${pro}
	mkdir disease;
done

# annotate delly lumpy manta #
for i in delly lumpy manta retro;
do
	genepath=${svpath}/${i}/${pro}/gene
	outpath=${svpath}/${i}/${pro}/disease
	for a in ${genepath}/*
	do
		outname=$(basename "${a}" .gene)
		bedtools annotate -i "${a}" -files ${diseaseref}/* \
		-names haplo retnet clinvar ddd generev \
		-counts |\
		awk '{if (($8+$9+$10+$11+$12) != 0) print}' \
		> ${outpath}/${outname}.disease;
	done;
done

