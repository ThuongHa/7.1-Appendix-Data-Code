#!/bin/bash -x

# this script is used to filter out variants present in published benign variants

# set variables #
svpath=/home/neuro/Documents/Thuong/2017/Genomes/CNV_SV
pro=$1
benfile=/home/neuro/Documents/Thuong/2017/Ref/benign/benign.bed

# make benign directory #
for i in delly lumpy manta retro;
do
	cd ${svpath}/${i}/${pro}
	mkdir benign;
done

# intersect BND #
for a in delly lumpy manta retro;
do
	propath=${svpath}/${a}/${pro}
	profile=$(find ${propath}/quality -name "*.BND.quality")
	outpath=${propath}/benign
	bedtools intersect -a ${profile} -b ${benfile} -v -f 0.10 -r | uniq > ${outpath}/$(basename ${profile} .quality).benign;
done

# intersect INS #
for a in delly manta;
do
        propath=${svpath}/${a}/${pro}
	profile=$(find ${propath}/quality -name "*.INS.quality")
        outpath=${propath}/benign
        bedtools intersect -a ${profile} -b ${benfile} -v -f 0.10 -r | uniq > ${outpath}/$(basename ${profile} .quality).benign;
done

# intersect DEL, DUP and INV files #
for a in delly lumpy manta;
do
        for b in DEL DUP INV;
	do
               	propath=${svpath}/${a}/${pro}
		profile1=$(find ${propath}/quality -name "*.${b}.1kb.quality")
		profile2=$(find ${propath}/quality -name "*.${b}.10kb.quality")
		profile3=$(find ${propath}/quality -name "*.${b}.100kb.quality")
		outpath=${propath}/benign
               	bedtools intersect -a ${profile1} -b ${benfile} -v -f 0.10 -r | uniq > ${outpath}/$(basename ${profile1} .quality).benign
               	bedtools intersect -a ${profile2} -b ${benfile} -v -f 0.10 -r | uniq > ${outpath}/$(basename ${profile2} .quality).benign
               	bedtools intersect -a ${profile3} -b ${benfile} -v -f 0.10 -r | uniq > ${outpath}/$(basename ${profile3} .quality).benign;
	done;
done
