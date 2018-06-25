#!/bin/bash -x

# This script calculates the overlap between a callset and truthset
# Usage example: ./intersect_sh > NA12878_intersect.txt

# Set variables #
calldir=/home/neuro/Documents/Thuong/NA12878/callsets
truthdir=/home/neuro/Documents/Thuong/NA12878/truthsets/bed
truth1=${truthdir}/1000G_DEL.bed
truth2=${truthdir}/Personalis_DEL.bed
truth3=${truthdir}/1000G_DUP.bed
truth4=${truthdir}/1000G_INS.bed
truth5=${truthdir}/Spiral_INS.bed
truth6=${truthdir}/1000G_INV.bed
truth7=${truthdir}/1000G_MEI.bed

# Run bedtools intersect
# -wa	write the original entry in A for each overlap
# -a	each feature in A is compared to B in search of overlaps
# -b	one or more files

for i in ${calldir}/DEL/*key; do
	file=$(basename ${i} .key)
	echo "${file} overlap with 1000G_DEL"
	wc -l ${i} | sed 's/ /\t/g' | cut -f1
	wc -l ${truth1} | sed 's/ /\t/g' | cut -f1
	bedtools intersect -wa -a ${truth1} -b ${i} | uniq | wc -l
	echo "${file} overlap with Person_DEL"
	wc -l ${i} | sed 's/ /\t/g' | cut -f1
	wc -l ${truth2} | sed 's/ /\t/g' | cut -f1
	bedtools intersect -wa -a ${truth2} -b ${i} | uniq | wc -l;
done

for i in ${calldir}/DUP/*key; do
	file=$(basename ${i} .key)
        echo "${file} overlap with 1000G_DUP"
	wc -l ${i} | sed 's/ /\t/g' | cut -f1
	wc -l ${truth3} | sed 's/ /\t/g' | cut -f1
        bedtools intersect -wa -a ${truth3} -b ${i} | uniq | wc -l;
done

for i in ${calldir}/BND/*key ${calldir}/INS/*key; do
	file=$(basename ${i} .key)
        echo "${file} overlap with 1000G_INS"
	wc -l ${i} | sed 's/ /\t/g' | cut -f1
	wc -l ${truth4} | sed 's/ /\t/g' | cut -f1
        bedtools intersect -wa -a ${truth4} -b ${i} | uniq | wc -l
        echo "${file} overlap with Spiral_INS"
	wc -l ${i} | sed 's/ /\t/g' | cut -f1
	wc -l ${truth5} | sed 's/ /\t/g' | cut -f1
        bedtools intersect -wa -a ${truth5} -b ${i} | uniq | wc -l;
done

for i in ${calldir}/INV/*key; do
	file=$(basename ${i} .key)
	echo "${file} overlap with 1000G_INV"
	wc -l ${i} | sed 's/ /\t/g' | cut -f1
	wc -l ${truth6} | sed 's/ /\t/g' | cut -f1
        bedtools intersect -wa -a ${truth6} -b ${i} | uniq | wc -l;
done

for i in ${calldir}/BND/*key ${calldir}/INS/*key ${calldir}/MEI/*key; do
	file=$(basename ${i} .key)
        echo "${file} overlap with 1000G_MEI"
	wc -l ${i} | sed 's/ /\t/g' | cut -f1
	wc -l ${truth7} | sed 's/ /\t/g' | cut -f1
        bedtools intersect -wa -a ${truth7} -b ${i} | uniq | wc -l;
done
