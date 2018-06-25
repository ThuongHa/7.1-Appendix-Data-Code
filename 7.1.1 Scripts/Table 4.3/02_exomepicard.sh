#!/bin/bash -x

#set variables
workdir=/home/neuro/Documents/Thuong/PICARD
reffile=/home/neuro/Public/RefSeqIndexAllPrograms/hg19_1stM_unmask_ran_all.fa
picarddir=/opt/picard-tools/picard-tools-2.6.0
baitintervals=/home/neuro/Documents/Sayaka/hg19All.picardinterval.files/hg19Allcoding.interval_list

#define variables
bamdir=$1
DNA=$2
infile=$bamdir/$DNA.realigned.recal.sorted.bwa.hg19_1stM_unmask_ran_all.bam


#run picard command
java -jar $picarddir/picard.jar CollectHsMetrics \
	I=$infile \
	O=${workdir}/$DNA.bamindextstats.txt \
	R=$reffile \
	MINIMUM_MAPPING_QUALITY=0 \
	MINIMUM_BASE_QUALITY=0 \
	NEAR_DISTANCE=0 \
	BAIT_INTERVALS=$baitintervals \
	TARGET_INTERVALS=$baitintervals

