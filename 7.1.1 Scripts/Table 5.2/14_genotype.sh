#!/bin/bash

# set variables #
svpath=/home/neuro/Documents/Thuong/2017/Genomes/CNV_SV
pro=$1


# make directories #
for i in delly lumpy manta;
do
	cd ${svpath}/${i}/${pro}
	mkdir genotype;
done

# extract BND #

for i in delly lumpy manta;
do
	# het #
        outpath=${svpath}/${i}/${pro}/genotype
        zcat ${svpath}/${i}/vcfgz/${pro}.${i}.vcf.gz | grep "SVTYPE=BND" | grep "0/1" |\
        awk '{print $1,$2,$2+125,"BND","0/1"}' | sed 's/ /\t/g' > ${outpath}/${pro}.${i}.BND.het
	# hom #
        zcat ${svpath}/${i}/vcfgz/${pro}.${i}.vcf.gz | grep "SVTYPE=BND" | grep "1/1" |\
        awk '{print $1,$2,$2+125,"BND","1/1"}' | sed 's/ /\t/g' > ${outpath}/${pro}.${i}.BND.hom;
done

# extract INS #

for i in delly manta;
do
	# het #
	outpath=${svpath}/${i}/${pro}/genotype
	zcat ${svpath}/${i}/vcfgz/${pro}.${i}.vcf.gz | grep "SVTYPE=INS" | grep "0/1" |\
	awk '{print $1,$2,$2+125,"INS","0/1"}' | sed 's/ /\t/g' > ${outpath}/${pro}.${i}.INS.het
	# hom #
	zcat ${svpath}/${i}/vcfgz/${pro}.${i}.vcf.gz | grep "SVTYPE=INS" | grep "1/1" |\
        awk '{print $1,$2,$2+125,"INS","1/1"}' | sed 's/ /\t/g' > ${outpath}/${pro}.${i}.INS.hom;
done

# extract DEL DUP INV #
for i in delly lumpy manta;
do
	outpath=${svpath}/${i}/${pro}/genotype
	for a in DEL DUP INV;
	do
		# 1kb #
		zcat ${svpath}/${i}/vcfgz/${pro}.${i}.vcf.gz | grep "SVTYPE=${a}" | grep "0/1" |\
                awk -v var="${a}" '{print $1,$2,$2+1000,var,"0/1"}' | sed 's/ /\t/g' \
                > ${outpath}/${pro}.${i}.${a}.1kb.het
                zcat ${svpath}/${i}/vcfgz/${pro}.${i}.vcf.gz | grep "SVTYPE=${a}" | grep "1/1" |\
                awk -v var="${a}" '{print $1,$2,$2+1000,var,"1/1"}' | sed 's/ /\t/g' \
                > ${outpath}/${pro}.${i}.${a}.1kb.hom
		# 10kb #
		zcat ${svpath}/${i}/vcfgz/${pro}.${i}.vcf.gz | grep "SVTYPE=${a}" | grep "0/1" |\
		awk -v var="${a}" '{print $1,$2,$2+10000,var,"0/1"}' | sed 's/ /\t/g' \
                > ${outpath}/${pro}.${i}.${a}.10kb.het
                zcat ${svpath}/${i}/vcfgz/${pro}.${i}.vcf.gz | grep "SVTYPE=${a}" | grep "1/1" |\
                awk -v var="${a}" '{print $1,$2,$2+10000,var,"1/1"}' | sed 's/ /\t/g' \
                > ${outpath}/${pro}.${i}.${a}.10kb.hom
		# 100kb #
		zcat ${svpath}/${i}/vcfgz/${pro}.${i}.vcf.gz | grep "SVTYPE=${a}" | grep "0/1" |\
		awk -v var="${a}" '{print $1,$2,$2+100000,var,"0/1"}' | sed 's/ /\t/g' \
                > ${outpath}/${pro}.${i}.${a}.100kb.het
                zcat ${svpath}/${i}/vcfgz/${pro}.${i}.vcf.gz | grep "SVTYPE=${a}" | grep "1/1" |\
                awk -v var="${a}" '{print $1,$2,$2+100000,var,"1/1"}' | sed 's/ /\t/g' \
                > ${outpath}/${pro}.${i}.${a}.100kb.hom;
	done;
done

