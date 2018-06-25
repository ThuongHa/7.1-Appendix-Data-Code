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

# annotate inheritance and zygosity #
for i in delly manta;
do
	benign=${svpath}/${i}/${pro}/benign
	inherit=${svpath}/${i}/${pro}/inher
	genotype=${svpath}/${i}/${pro}/genotype
	outpath=${svpath}/${i}/${pro}/proanno
	for a in BND INS;
	do
		# denovo #
		bedtools annotate -i ${benign}/${pro}.${i}.${a}.benign \
		-files ${inherit}/${pro}.${i}.${a}.dn ${genotype}/${pro}.${i}.${a}.het \
		-names dn het \
		-counts |\
		awk '{if ($7 == 1 && $8 == 1) print}' \
		> ${outpath}/${pro}.${i}.${a}.annodn
		# homrec #
		bedtools annotate -i ${benign}/${pro}.${i}.${a}.benign \
                -files ${inherit}/${pro}.${i}.${a}.hr ${genotype}/${pro}.${i}.${a}.hom \
                -names hr hom \
                -counts |\
                awk '{if ($7 == 1 && $8 == 1) print}' \
                > ${outpath}/${pro}.${i}.${a}.annohr
		# comhet #
                bedtools annotate -i ${benign}/${pro}.${i}.${a}.benign \
                -files ${inherit}/${pro}.${i}.${a}.ch ${genotype}/${pro}.${i}.${a}.het \
                -names ch het \
                -counts |\
                awk '{if ($7 == 1 && $8 == 1) print}' \
                > ${outpath}/${pro}.${i}.${a}.annoch;
	done;
done

# for lumpy BND #
for i in lumpy;
do
	benign=${svpath}/${i}/${pro}/benign
        inherit=${svpath}/${i}/${pro}/inher
        genotype=${svpath}/${i}/${pro}/genotype
        outpath=${svpath}/${i}/${pro}/proanno
	for a in BND;
	do
		# denovo #
                bedtools annotate -i ${benign}/${pro}.${i}.${a}.benign \
                -files ${inherit}/${pro}.${i}.${a}.dn ${genotype}/${pro}.${i}.${a}.het \
                -names dn het \
                -counts |\
                awk '{if ($7 == 1 && $8 == 1) print}' \
                > ${outpath}/${pro}.${i}.${a}.annodn
                # homrec #
                bedtools annotate -i ${benign}/${pro}.${i}.${a}.benign \
                -files ${inherit}/${pro}.${i}.${a}.hr ${genotype}/${pro}.${i}.${a}.hom \
                -names hr hom \
                -counts |\
                awk '{if ($7 == 1 && $8 == 1) print}' \
                > ${outpath}/${pro}.${i}.${a}.annohr
                # comhet #
                bedtools annotate -i ${benign}/${pro}.${i}.${a}.benign \
                -files ${inherit}/${pro}.${i}.${a}.ch ${genotype}/${pro}.${i}.${a}.het \
                -names ch het \
                -counts |\
                awk '{if ($7 == 1 && $8 == 1) print}' \
                > ${outpath}/${pro}.${i}.${a}.annoch;
	done;
done

# for DEL DUP INV #
for i in delly lumpy manta;
do
        benign=${svpath}/${i}/${pro}/benign
        inherit=${svpath}/${i}/${pro}/inher
        genotype=${svpath}/${i}/${pro}/genotype
        outpath=${svpath}/${i}/${pro}/proanno
	for a in DEL DUP INV;
	do
		for b in 1kb 10kb 100kb;
		do
			# denovo #
                	bedtools annotate -i ${benign}/${pro}.${i}.${a}.${b}.benign \
                	-files ${inherit}/${pro}.${i}.${a}.${b}.dn ${genotype}/${pro}.${i}.${a}.${b}.het \
                	-names dn het \
                	-counts |\
                	awk '{if ($7 == 1 && $8 == 1) print}' \
               		> ${outpath}/${pro}.${i}.${a}.${b}.annodn
			# homrec #
        	        bedtools annotate -i ${benign}/${pro}.${i}.${a}.${b}.benign \
                	-files ${inherit}/${pro}.${i}.${a}.${b}.hr ${genotype}/${pro}.${i}.${a}.${b}.hom \
              		-names hr hom \
                	-counts |\
                	awk '{if ($7 == 1 && $8 == 1) print}' \
                	> ${outpath}/${pro}.${i}.${a}.${b}.annohr
			# comhet #
                	bedtools annotate -i ${benign}/${pro}.${i}.${a}.${b}.benign \
                	-files ${inherit}/${pro}.${i}.${a}.${b}.dn ${genotype}/${pro}.${i}.${a}.${b}.het \
                	-names dn het \
                	-counts |\
                	awk '{if ($7 == 1 && $8 == 1) print}' \
                	> ${outpath}/${pro}.${i}.${a}.${b}.annoch;
		done;
	done;
done

# retro #
for i in retro;
do
        benign=${svpath}/${i}/${pro}/benign
        inherit=${svpath}/${i}/${pro}/inher
        outpath=${svpath}/${i}/${pro}/proanno
        for a in BND;
        do
                # denovo #
                bedtools annotate -i ${benign}/${pro}.${i}.${a}.benign \
                -files ${inherit}/${pro}.${i}.${a}.dn \
                -names dn \
                -counts |\
                awk '{if ($7 == 1) print}' \
                > ${outpath}/${pro}.${i}.${a}.annodn
                # homrec #
                bedtools annotate -i ${benign}/${pro}.${i}.${a}.benign \
                -files ${inherit}/${pro}.${i}.${a}.hr \
                -names hr \
                -counts |\
                awk '{if ($7 == 1) print}' \
                > ${outpath}/${pro}.${i}.${a}.annohr
                # comhet #
                bedtools annotate -i ${benign}/${pro}.${i}.${a}.benign \
                -files ${inherit}/${pro}.${i}.${a}.ch \
                -names ch \
                -counts |\
                awk '{if ($7 == 1) print}' \
                > ${outpath}/${pro}.${i}.${a}.annoch;
        done;
done

