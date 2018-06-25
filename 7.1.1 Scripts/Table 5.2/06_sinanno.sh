#!/bin/bash

# set variables #
svpath=/home/neuro/Documents/Thuong/2017/Genomes/CNV_SV
pro=$1

# make directories #
for i in delly lumpy manta retro;
do
	cd ${svpath}/${i}/${pro}
	mkdir proanno;
done

# filter based on zygosity #
for i in delly manta;
do
	benign=${svpath}/${i}/${pro}/benign
	genotype=${svpath}/${i}/${pro}/genotype
	outpath=${svpath}/${i}/${pro}/proanno
	for a in BND INS;
	do
		# denovo #
		bedtools intersect -wa -a ${benign}/${pro}.${i}.${a}.benign \
		-b ${genotype}/${pro}.${i}.${a}.het | uniq \
		> ${outpath}/${pro}.${i}.${a}.annodn
		# homrec #
		bedtools intersect -wa -a ${benign}/${pro}.${i}.${a}.benign \
                -b ${genotype}/${pro}.${i}.${a}.hom | uniq \
                > ${outpath}/${pro}.${i}.${a}.annohr;
	done;
done

# for lumpy BND #
for i in lumpy;
do
	benign=${svpath}/${i}/${pro}/benign
        genotype=${svpath}/${i}/${pro}/genotype
        outpath=${svpath}/${i}/${pro}/proanno
	for a in BND;
	do
		# denovo #
                bedtools intersect -wa -a ${benign}/${pro}.${i}.${a}.benign \
                -b ${genotype}/${pro}.${i}.${a}.het | uniq \
                > ${outpath}/${pro}.${i}.${a}.annodn
                # homrec #
                bedtools intersect -wa -a ${benign}/${pro}.${i}.${a}.benign \
                -b ${genotype}/${pro}.${i}.${a}.hom | uniq \
                > ${outpath}/${pro}.${i}.${a}.annohr;
	done;
done

# for DEL DUP INV #
for i in delly lumpy manta;
do
        benign=${svpath}/${i}/${pro}/benign
        genotype=${svpath}/${i}/${pro}/genotype
        outpath=${svpath}/${i}/${pro}/proanno
	for a in DEL DUP INV;
	do
		for b in 1kb 10kb 100kb;
		do
			# denovo #
                	bedtools intersect -wa -a ${benign}/${pro}.${i}.${a}.${b}.benign \
                	-b ${genotype}/${pro}.${i}.${a}.${b}.het | uniq \
                	> ${outpath}/${pro}.${i}.${a}.${b}.annodn
                	# homrec #
                	bedtools intersect -wa -a ${benign}/${pro}.${i}.${a}.${b}.benign \
                	-b ${genotype}/${pro}.${i}.${a}.${b}.hom | uniq \
                	> ${outpath}/${pro}.${i}.${a}.${b}.annohr;
		done;
	done;
done

