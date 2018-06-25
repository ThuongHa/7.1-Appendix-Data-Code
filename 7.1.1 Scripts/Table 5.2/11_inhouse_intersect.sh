#!/bin/bash -x

# this script is used to filter out variants present in unrelated inhouse genomes

# set variables #
svpath=/home/neuro/Documents/Thuong/2017/Genomes/CNV_SV
pro=$1

# make intersect directory #
for i in delly lumpy manta retro;
do
	cd ${svpath}/${i}/${pro}
	mkdir intersect;
done

# intersect BND #
for a in delly lumpy manta retro;
do
	svfile=${svpath}/${a}/${pro}/probed/${pro}.${a}.BND.probed
	ihfile=${svpath}/${a}/${pro}/inhouse/inhouse.${a}.BND.inhouse
	outpath=${svpath}/${a}/${pro}/intersect
	bedtools intersect -wa -a ${svfile} -b ${ihfile} -v | uniq > ${outpath}/$(basename ${svfile} .probed).intersect;
done

# intersect INS #
for a in delly manta;
do

        svfile=${svpath}/${a}/${pro}/probed/${pro}.${a}.INS.probed
        ihfile=${svpath}/${a}/${pro}/inhouse/inhouse.${a}.INS.inhouse
        outpath=${svpath}/${a}/${pro}/intersect
        bedtools intersect -wa -a ${svfile} -b ${ihfile} -v | uniq > ${outpath}/$(basename ${svfile} .probed).intersect;
done

# intersect DEL, DUP and INV files #
for a in delly lumpy manta;
do
        for b in DEL DUP INV;
	do
               svfile1=${svpath}/${a}/${pro}/probed/${pro}.${a}.${b}.1kb.probed
               ihfile1=${svpath}/${a}/${pro}/inhouse/inhouse.${a}.${b}.1kb.inhouse
               svfile2=${svpath}/${a}/${pro}/probed/${pro}.${a}.${b}.10kb.probed
               ihfile2=${svpath}/${a}/${pro}/inhouse/inhouse.${a}.${b}.10kb.inhouse
               svfile3=${svpath}/${a}/${pro}/probed/${pro}.${a}.${b}.100kb.probed
               ihfile3=${svpath}/${a}/${pro}/inhouse/inhouse.${a}.${b}.100kb.inhouse
		outpath=${svpath}/${a}/${pro}/intersect
               	bedtools intersect -wa -a ${svfile1} -b ${ihfile1} -v | uniq > ${outpath}/$(basename ${svfile1} .probed).intersect
               	bedtools intersect -wa -a ${svfile2} -b ${ihfile2} -v | uniq > ${outpath}/$(basename ${svfile2} .probed).intersect
               	bedtools intersect -wa -a ${svfile3} -b ${ihfile3} -v | uniq > ${outpath}/$(basename ${svfile3} .probed).intersect;
	done;
done
