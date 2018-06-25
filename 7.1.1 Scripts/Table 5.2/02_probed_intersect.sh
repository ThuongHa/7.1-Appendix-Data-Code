#!/bin/bash -x

# This script will collate proband SVs that do not overlap with unrelated SVs #

# set variables #
svpath=/home/neuro/Documents/Thuong/2017/Genomes/CNV_SV
unpath=${svpath}/unrelated/key
pro=$1

# make unrelated directory #
for i in delly lumpy manta retro;
do
	cd ${svpath}/${i}/${pro}
	mkdir unrelated;
done

# intersect BND #
for a in delly lumpy manta retro;
do
	propath=${svpath}/${a}/${pro}
	profile=${propath}/probed/${pro}.${a}.BND.probed
	unfile=${unpath}/unrelated.BND.key
	outpath=${propath}/unrelated
	outname=$(basename ${profile} .probed)
	bedtools intersect -a ${profile} -b ${unfile} -v | uniq > ${outpath}/${outname}.uniq;
done

# intersect INS #
for a in delly manta;
do
        propath=${svpath}/${a}/${pro}
        profile=${propath}/probed/${pro}.${a}.INS.probed
        unfile=${unpath}/unrelated.INS.key
        outpath=${propath}/unrelated
	outname=$(basename ${profile} .probed)
        bedtools intersect -a ${profile} -b ${unfile} -v | uniq > ${outpath}/${outname}.uniq;
done

# intersect DEL, DUP and INV files #
for a in delly lumpy manta;
do
        for b in DEL DUP INV;
        do
		propath=${svpath}/${a}/${pro}
               	profile1=${propath}/probed/${pro}.${a}.${b}.1kb.probed
                unfile1=${unpath}/unrelated.${b}.1kb.key
               	profile2=${propath}/probed/${pro}.${a}.${b}.10kb.probed
                unfile2=${unpath}/unrelated.${b}.10kb.key
               	profile3=${propath}/probed/${pro}.${a}.${b}.100kb.probed
                unfile3=${unpath}/unrelated.${b}.100kb.key
		outpath=${propath}/unrelated
               	bedtools intersect -a ${profile1} -b ${unfile1} -v | uniq > ${outpath}/$(basename ${profile1} .probed).uniq
               	bedtools intersect -a ${profile2} -b ${unfile2} -v | uniq > ${outpath}/$(basename ${profile2} .probed).uniq
               	bedtools intersect -a ${profile3} -b ${unfile3} -v | uniq > ${outpath}/$(basename ${profile3} .probed).uniq;
	done;
done
