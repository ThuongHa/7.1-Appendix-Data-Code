#!/bin/bash -x
# FiltFreqV2.sh

#Set variables
GenomeFile=$1
OutPrefix=$2

#Filter variants based on frequency threshold given
#inputfiles created by annovarv3.sh script
#columns 13-18: evs,ExAC,1000genomes,10KUK,cg69,wellderly
cat $GenomeFile | \
awk -F"\t" '$13<0.01' |awk -F"\t" '$14<0.001' | awk -F"\t" '$14<0.001' | awk -F"\t" '$15<0.001' | awk -F"\t" '$16<0.01' | awk -F"\t" '$17<0.01' \
> $OutPrefix.tmp1.txt

#Add header to files
sort -k1,1 $GenomeFile | head -n 1 > $OutPrefix.head.txt
cat $OutPrefix.head.txt $OutPrefix.tmp1.txt > FreqFilt.$OutPrefix.txt
rm $OutPrefix.tmp1.txt
