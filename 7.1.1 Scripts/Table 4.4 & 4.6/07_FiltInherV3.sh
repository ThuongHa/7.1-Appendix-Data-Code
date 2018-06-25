#!/bin/bash -x
# FiltInherV2.sh
# modified:
# thuong ha; 30/09/2014; changed input files for homozygous variants to ensure parents are heterozygous for the mutation
# thuong ha; 10/11/2014; modify script to include compound heterozygous variants with only one hit i.e. incase sequencing/lack of coverage missed the second hit

GenomeFile=$1
MumFile=$2
DadFile=$3
FreqFile=$4
OutPrefix=$5

#extract denovo variants
awk -F"\t" 'FNR==NR{ a[$67]=$0;next } !($94 in a)' $MumFile $FreqFile > $OutPrefix.tmp1.txt #var in proband, absent in mum
awk -F"\t" 'FNR==NR{ a[$67]=$0;next } !($94 in a)' $DadFile $FreqFile > $OutPrefix.tmp2.txt #var in dad, not proband
cat $OutPrefix.tmp1.txt $OutPrefix.tmp2.txt | sort | uniq -d > $OutPrefix.tmp3.txt #var in proband, absent in dad
rm $OutPrefix.tmp1.txt $OutPrefix.tmp2.txt

#extract X-linked denovo variants
grep ^chrX $OutPrefix.tmp3.txt > $OutPrefix.tmp4.txt
cat $OutPrefix.head.txt $OutPrefix.tmp4.txt > ChrXFilt.$OutPrefix.txt
rm $OutPrefix.tmp4.txt

#extract autosomal denovo variants
grep -v ^chrX $OutPrefix.tmp3.txt > $OutPrefix.tmp5.txt
cat $OutPrefix.head.txt $OutPrefix.tmp5.txt > AutoFilt.$OutPrefix.txt
rm $OutPrefix.tmp3.txt $OutPrefix.tmp5.txt

#extract heterozygous variants from parents
grep -v 1/1 $MumFile > $OutPrefix.mum.txt
grep -v 1/1 $DadFile > $OutPrefix.dad.txt

#extract homozygous variants
awk -F"\t" 'FNR==NR{ a[$67]=$0;next } ($67 in a)' $OutPrefix.mum.txt $FreqFile > $OutPrefix.tmp6.txt #variant in proband, in mum
awk -F"\t" 'FNR==NR{ a[$67]=$0;next } ($67 in a)' $OutPrefix.dad.txt $FreqFile > $OutPrefix.tmp7.txt #variant in proband, in dad
awk -F"\t" 'FNR==NR{ a[$67]=$0;next } ($67 in a)' $OutPrefix.tmp6.txt $OutPrefix.tmp7.txt > $OutPrefix.tmp8.txt #variant in proband, in mum, in dad
grep 1/1 $OutPrefix.tmp8.txt | grep -v ^chrX > $OutPrefix.tmp9.txt
cat $OutPrefix.head.txt $OutPrefix.tmp9.txt > HomoRec.$OutPrefix.txt
rm $OutPrefix.tmp6.txt $OutPrefix.tmp7.txt $OutPrefix.tmp8.txt $OutPrefix.tmp9.txt

#extract  heterozygous variants from AF
cut -f 7 $GenomeFile | uniq -d > $OutPrefix.tmp10.txt #compile genes with  two or more  hits
awk -F"\t" 'FNR==NR{ a[$1]=$0;next } ($7 in a)' $OutPrefix.tmp10.txt $GenomeFile > $OutPrefix.tmp11.txt #extract lines with gene list
grep 0/1 $OutPrefix.tmp11.txt | grep -v ^chrX > $OutPrefix.tmp12.txt #extract heterozygous variants
rm $OutPrefix.tmp10.txt $OutPrefix.tmp11.txt

#compare filtered hets with parents
awk -F"\t" 'FNR==NR{ a[$67]=$0;next } ($94 in a)' $OutPrefix.mum.txt $OutPrefix.tmp12.txt > $OutPrefix.tmp13.txt #var in both proband and mum
awk -F"\t" 'FNR==NR{ a[$67]=$0;next } !($94 in a)' $OutPrefix.mum.txt $OutPrefix.tmp12.txt > $OutPrefix.tmp14.txt #var in proband, absent in mum
awk -F"\t" 'FNR==NR{ a[$67]=$0;next } ($94 in a)' $OutPrefix.dad.txt $OutPrefix.tmp12.txt > $OutPrefix.tmp15.txt #var in both proband and dad
awk -F"\t" 'FNR==NR{ a[$67]=$0;next } !($94 in a)' $OutPrefix.dad.txt $OutPrefix.tmp12.txt > $OutPrefix.tmp16.txt #var in proband, absent in dad
rm $OutPrefix.mum.txt $OutPrefix.dad.txt $OutPrefix.tmp12.txt

#combine filtered hets
cat $OutPrefix.tmp13.txt $OutPrefix.tmp16.txt | sort | uniq -d > $OutPrefix.tmp17.txt #var in proband, in mum, not dad
cat $OutPrefix.tmp14.txt $OutPrefix.tmp15.txt | sort | uniq -d > $OutPrefix.tmp18.txt #var in proband, not mum, in dad
cat $OutPrefix.tmp14.txt $OutPrefix.tmp16.txt | sort | uniq -d > $OutPrefix.tmp19.txt #var in proband, not mum, not dad
cat $OutPrefix.tmp17.txt $OutPrefix.tmp18.txt $OutPrefix.tmp19.txt | sort > $OutPrefix.tmp20.txt
rm $OutPrefix.tmp13.txt $OutPrefix.tmp14.txt $OutPrefix.tmp15.txt $OutPrefix.tmp16.txt $OutPrefix.tmp17.txt $OutPrefix.tmp18.txt $OutPrefix.tmp19.txt

#extract compound heterozygous variants from AF
grep exonic $OutPrefix.tmp20.txt > $OutPrefix.tmp21.txt
cat $OutPrefix.tmp21.txt | awk -F"\t" '$13<0.01' | awk -F"\t" '$14<0.001' | awk -F"\t" '$15<0.001' | awk -F"\t" '$16<0.001' | awk -F"\t" '$17<0.01' | awk -F"\t" '$18<0.01' > $OutPrefix.tmp22.txt
cut -f 7 $OutPrefix.tmp22.txt | uniq -d > $OutPrefix.tmp23.txt #compile genes with  two or more  hits
awk -F"\t" 'FNR==NR{ a[$1]=$0;next } ($7 in a)' $OutPrefix.tmp23.txt $OutPrefix.tmp22.txt > $OutPrefix.tmp24.txt
awk -F"\t" 'FNR==NR{ a[$1]=$0;next } !($7 in a)' $OutPrefix.tmp23.txt $OutPrefix.tmp22.txt > $OutPrefix.tmp25.txt
cat $OutPrefix.head.txt $OutPrefix.tmp24.txt > CompHet2.$OutPrefix.txt
cat $OutPrefix.head.txt $OutPrefix.tmp25.txt > CompHet1.$OutPrefix.txt
rm $OutPrefix.tmp20.txt $OutPrefix.tmp21.txt $OutPrefix.tmp22.txt $OutPrefix.tmp23.txt $OutPrefix.tmp24.txt $OutPrefix.tmp25.txt $OutPrefix.head.txt

