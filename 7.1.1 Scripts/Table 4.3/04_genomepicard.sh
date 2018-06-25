#!/bin/bash -x

#set variables
workdir=/home/neuro/Documents/Thuong/PICARD
reffile=/home/neuro/Documents/Thuong/mount/RefSeqIndexAllPrograms/GATK/ucsc.hg19.fasta
picarddir=/opt/picard-tools/picard-tools-2.6.0
baitintervals=$workdir/hg19Allcoding.agrf.interval_list

#define variables
infile=$1 #$1=bamdir/bamfile
DNA=$2

#run picard command
for i in ${baitintervals}; do
	java -jar $picarddir/picard.jar CollectHsMetrics \
	INPUT=${infile} \
	OUTPUT=${workdir}/${DNA}.collecthsmetrics.txt \
	REFERENCE_SEQUENCE=${reffile} \
	MINIMUM_MAPPING_QUALITY=0 \
	MINIMUM_BASE_QUALITY=0 \
	NEAR_DISTANCE=0 \
	BAIT_INTERVALS=$i \
	TARGET_INTERVALS=$i
done

