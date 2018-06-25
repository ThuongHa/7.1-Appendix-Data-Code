#!/bin/bash

# This script is used to filter for potential denovo, compound hets and hom recessive variants in Aicardi trios #

# set variables #
svpath=/home/neuro/Documents/Thuong/2017/Genomes/CNV_SV
dnscript=/home/neuro/Documents/Thuong/2017/Genomes/scripts/denovo.sh
hrscript=/home/neuro/Documents/Thuong/2017/Genomes/scripts/homrec.sh
chscript=/home/neuro/Documents/Thuong/2017/Genomes/scripts/comhet.sh
rmscript=/home/neuro/Documents/Thuong/2017/Genomes/scripts/rm0bytes.sh
pro=$1
mum=$2
dad=$3

# make inherited directories #
for i in delly lumpy manta retro;
do
	cd ${svpath}/${i}/${pro}
	mkdir inherited
	cd inherited
	mkdir denovo
	mkdir comhet
	mkdir homrec;
done

# extract inherited BND variants #
for i in delly lumpy manta;
do
	aicbed=${svpath}/${i}/bed/aicardi
	proben=${svpath}/${i}/${pro}/benign
	progen=${svpath}/${i}/${pro}/genotype
	outpath=${svpath}/${i}/${pro}/inherited
	${dnscript} ${proben}/*.BND.benign ${progen}/*.BND.het ${aicbed}/${mum}.BND.key ${aicbed}/${dad}.BND.key ${outpath}/denovo/ ${pro}.BND.denovo
	${hrscript} ${proben}/*.BND.benign ${progen}/*.BND.hom ${aicbed}/${mum}.BND.key ${aicbed}/${dad}.BND.key ${outpath}/homrec/ ${pro}.BND.homrec
	${chscript} ${proben}/*.BND.benign ${progen}/*.BND.het ${aicbed}/${mum}.BND.key ${aicbed}/${dad}.BND.key ${outpath}/comhet/ ${pro}.BND.comhet;
done

# extract inherited INS variants #
for i in delly manta;
do
        aicbed=${svpath}/${i}/bed/aicardi
        proben=${svpath}/${i}/${pro}/benign
        progen=${svpath}/${i}/${pro}/genotype
        outpath=${svpath}/${i}/${pro}/inherited
	${dnscript} ${proben}/*.INS.benign ${progen}/*.INS.het ${aicbed}/${mum}.INS.key ${aicbed}/${dad}.INS.key ${outpath}/denovo/ ${pro}.INS.denovo
        ${hrscript} ${proben}/*.INS.benign ${progen}/*.INS.hom ${aicbed}/${mum}.INS.key ${aicbed}/${dad}.INS.key ${outpath}/homrec/ ${pro}.INS.homrec
        ${chscript} ${proben}/*.INS.benign ${progen}/*.INS.het ${aicbed}/${mum}.INS.key ${aicbed}/${dad}.INS.key ${outpath}/comhet/ ${pro}.INS.comhet;
done

# extract DEL DUP INV variants #
for i in delly lumpy manta;
do
	aicbed=${svpath}/${i}/bed/aicardi
        proben=${svpath}/${i}/${pro}/benign
        progen=${svpath}/${i}/${pro}/genotype
        outpath=${svpath}/${i}/${pro}/inherited
	for a in DEL DUP INV;
	do
		for b in ${a}.1kb ${a}.10kb ${a}.100kb;
		do
			${dnscript} ${proben}/*.${b}.benign ${progen}/*.${b}.het ${aicbed}/${mum}.${a}.key ${aicbed}/${dad}.${a}.key ${outpath}/denovo/ ${pro}.${b}.denovo
        		${hrscript} ${proben}/*.${b}.benign ${progen}/*.${b}.hom ${aicbed}/${mum}.${a}.key ${aicbed}/${dad}.${a}.key ${outpath}/homrec/ ${pro}.${b}.homrec
        		${chscript} ${proben}/*.${b}.benign ${progen}/*.${b}.het ${aicbed}/${mum}.${a}.key ${aicbed}/${dad}.${a}.key ${outpath}/comhet/ ${pro}.${b}.comhet;
		done;
	done;
done

# extract MEI variants #
# note: retroseq does not genotype variants thus filtering based on presence/absence from parents #
for i in retro;
do
	aicbed=${svpath}/${i}/bed/aicardi
        proben=${svpath}/${i}/${pro}/benign
        outpath=${svpath}/${i}/${pro}/inherited
	${dnscript} ${proben}/*.BND.benign ${proben}/*.BND.benign ${aicbed}/${mum}.BND.key ${aicbed}/${dad}.BND.key ${outpath}/denovo/ ${pro}.BND.denovo
        ${chscript} ${proben}/*.BND.benign ${proben}/*.BND.benign ${aicbed}/${mum}.BND.key ${aicbed}/${dad}.BND.key ${outpath}/comhet/ ${pro}.BND.comhet;
done

# remove files with zero lines #
for i in delly lumpy manta retro;
do
	for a in denovo homrec comhet;
	do
		path=${svpath}/${i}/${pro}/inherited/${a}
		${rmscript} ${path};
	done;
done

