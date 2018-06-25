#!/bin/bash -x

#set variables
svpath=/home/neuro/Documents/Thuong/2017/Genomes/CNV_SV
pro=$1

#generate pass bed for delly and manta#
#output: chr start end svtype filter_pass
for i in delly manta;
do
	cd ${svpath}/${i}/${pro}
	mkdir propass
	outpath=${svpath}/${i}/${pro}/propass

	zcat ${svpath}/${i}/vcfgz/${pro}.${i}.vcf.gz | grep -v "#" | awk -v var="PASS" '{if ($7 == var) print}' |\
	cut -f 1,2,7,8 | sed 's/;/\t/g;s/SVTYPE=//g' | awk '{print $1,$2,$2+125,$5,$3}' | sed 's/ /\t/g' \
	> ${outpath}/${pro}.${i}.propass.tmp;
done

#generate pass bed for lumpy#
#output: chr start end svtype sample_quality allele_balance
cd ${svpath}/lumpy/${pro}
mkdir propass
outlumpy=${svpath}/lumpy/${pro}/propass

zcat ${svpath}/lumpy/vcfgz/${pro}.lumpy.vcf.gz | grep -v "#" | cut -f 1,2,6,8,10 | awk '{if ($3 >= 90) print}' |\
sed 's/;/\t/g;s/SVTYPE=//g;s/:/\t/g' | awk '{if ($NF >= .30) print $1,$2,$2+125,$4,$3,$NF}' | sed 's/ /\t/g' \
> ${outlumpy}/${pro}.lumpy.propass.tmp

#generate pass bed for retro#
#output: chr start end svtype called_status
cd ${svpath}/retro/${pro}
mkdir propass
outretro=${svpath}/retro/${pro}/propass

zcat ${svpath}/retro/vcfgz/${pro}.retro.vcf.gz | grep -v "#" | sed 's/:/\t/g' | awk '{if ($18 >= 5) print}' |\
awk '{print $1,$2,$2+125,"MEI",$18}' | sed 's/ /\t/g' \
> ${outretro}/${pro}.retro.BND.propass

#extract different svtypes from passbed file#
for a in delly manta;
do
	outpath=${svpath}/${a}/${pro}/propass
	cd ${outpath}
	for i in BND INS;
	do
		grep "${i}" ${pro}.${a}.propass.tmp > ${outpath}/${pro}.${a}.${i}.propass;
	done

	for i in DEL DUP INV;
	do
		grep "${i}" ${pro}.${a}.propass.tmp | awk '{print $1,$2,$3+1000,$4,$5}'| sed 's/ /\t/g' \
		> ${outpath}/${pro}.${a}.${i}.1kb.propass
		grep "${i}" ${pro}.${a}.propass.tmp | awk '{print $1,$2,$3+10000,$4,$5}'| sed 's/ /\t/g' \
        	> ${outpath}/${pro}.${a}.${i}.10kb.propass
		grep "${i}" ${pro}.${a}.propass.tmp | awk '{print $1,$2,$3+100000,$4,$5}'| sed 's/ /\t/g' \
        	> ${outpath}/${pro}.${a}.${i}.100kb.propass;
	done
	rm ${outpath}/${pro}.${a}.propass.tmp;
done

for a in lumpy;
do
	outpath=${svpath}/${a}/${pro}/propass
        cd ${outpath}
	grep "BND" ${pro}.${a}.propass.tmp > ${outpath}/${pro}.${a}.BND.propass
        for i in DEL DUP INV;
        do
                grep "${i}" ${pro}.${a}.propass.tmp | awk '{print $1,$2,$3+1000,$4,$5}'| sed 's/ /\t/g' \
                > ${outpath}/${pro}.${a}.${i}.1kb.propass
                grep "${i}" ${pro}.${a}.propass.tmp | awk '{print $1,$2,$3+10000,$4,$5}'| sed 's/ /\t/g' \
                > ${outpath}/${pro}.${a}.${i}.10kb.propass
                grep "${i}" ${pro}.${a}.propass.tmp | awk '{print $1,$2,$3+100000,$4,$5}'| sed 's/ /\t/g' \
                > ${outpath}/${pro}.${a}.${i}.100kb.propass;
        done
	rm ${outpath}/${pro}.${a}.propass.tmp;
done
