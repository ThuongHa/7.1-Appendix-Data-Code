#!/bin/bash -x

# This script is used to filter out variants that did not pass the Illumina quality filter #

# set variables #
svpath=/home/neuro/Documents/Thuong/2017/Genomes/CNV_SV
pro=$1

# make intersect directory #
for i in delly lumpy manta retro;
do
	cd ${svpath}/${i}/${pro}
	mkdir quality;
done

# intersect BND #
for a in delly lumpy manta retro;
do

	propath=${svpath}/${a}/${pro}
	svfile=$(find ${propath}/unrelated -name "*BND*")
	ihfile=$(find ${propath}/propass -name "*BND*")
	outpath=${propath}/quality
	bedtools intersect -wa -a ${svfile} -b ${ihfile} | uniq > ${outpath}/$(basename ${svfile} .uniq).quality;
done

# intersect INS #
for a in delly manta;
do

        propath=${svpath}/${a}/${pro}
        svfile=$(find ${propath}/unrelated -name "*INS*")
        ihfile=$(find ${propath}/propass -name "*INS*")
        outpath=${propath}/quality
        bedtools intersect -wa -a ${svfile} -b ${ihfile} | uniq > ${outpath}/$(basename ${svfile} .uniq).quality;
done

# intersect DEL, DUP and INV files #
for a in delly lumpy manta;
do
        for b in DEL DUP INV;
	do
               propath=${svpath}/${a}/${pro}
               svfile1=$(find ${propath}/unrelated -name "*${b}.1kb*")
               ihfile1=$(find ${propath}/propass -name "*${b}.1kb*")
               svfile2=$(find ${propath}/unrelated -name "*${b}.10kb*")
               ihfile2=$(find ${propath}/propass -name "*${b}.10kb*")
               svfile3=$(find ${propath}/unrelated -name "*${b}.100kb*")
               ihfile3=$(find ${propath}/propass -name "*${b}.100kb*")
		outpath=${propath}/quality
               	bedtools intersect -wa -a ${svfile1} -b ${ihfile1} | uniq > ${outpath}/$(basename ${svfile1} .uniq).quality
               	bedtools intersect -wa -a ${svfile2} -b ${ihfile2} | uniq > ${outpath}/$(basename ${svfile2} .uniq).quality
               	bedtools intersect -wa -a ${svfile3} -b ${ihfile3} | uniq > ${outpath}/$(basename ${svfile3} .uniq).quality;
	done;
done
