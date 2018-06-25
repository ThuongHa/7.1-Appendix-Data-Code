#!/bin/bash -x

# this script is used to find variants that overlap with full length canonical transcripts

# set variables #
svpath=/home/neuro/Documents/Thuong/2017/Genomes/CNV_SV
pro=$1
ihfile=/home/neuro/Documents/Thuong/2017/Ref/gene/20170701_hg19hgnc_50bp.bed

# make benign directory #
for i in delly lumpy manta retro;
do
	cd ${svpath}/${i}/${pro}
	mkdir gene;
done

# intersect delly lumpy manta #
#for i in delly lumpy manta;
#do
#	annopath=${svpath}/${i}/${pro}/proanno
#	outpath=${svpath}/${i}/${pro}/gene
#	for a in ${annopath}/*
#	do
#		bedtools intersect -wa -wb -a ${a} -b ${ihfile} | cut -f 1,2,3,4,5,6,12 | uniq \
#		> ${outpath}/$(basename "${a}").gene;
#	done;
#done

for i in retro;
do
        annopath=${svpath}/${i}/${pro}/proanno
        outpath=${svpath}/${i}/${pro}/gene
        for a in ${annopath}/*
        do
                bedtools intersect -wa -wb -a ${a} -b ${ihfile} | cut -f 1,2,3,4,5,6,11 | uniq \
                > ${outpath}/$(basename "${a}").gene;
        done;
done

