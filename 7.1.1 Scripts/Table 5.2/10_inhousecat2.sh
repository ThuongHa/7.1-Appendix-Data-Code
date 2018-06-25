#!/bin/bash -x

# This script uses the bedtools merge module to combine SVs within 500bp distance

# Usage:   bedtools merge [OPTIONS] -i <bed/gff/vcf>

# Set variables #
svpath=/home/neuro/Documents/Thuong/2017/Genomes/CNV_SV
svtype=("DEL" "DUP" "INV")
pro=$1

# Make merge directory for all svcallers #
for i in ${svpath}/delly ${svpath}/lumpy ${svpath}/manta ${svpath}/retro;
do
	cd ${i}
	echo "making merge directory in ${i}"
	mkdir ${pro}
	mkdir ${pro}/inhouse;
done

# Merge BND features within 500bp distance across all SVcaller #
# output:
# $1 chr
# $2 start
# $3 end
for i in ${svpath}/delly ${svpath}/lumpy ${svpath}/manta ${svpath}/retro;
do
	outpath=${i}/${pro}/inhouse
	prog=$(basename ${i})
	outname=inhouse.${prog}.BND.inhouse
	echo "merging BND files in ${i}/bed"
	cat $(ls ${i}/bed/*.BND.key | grep -v "${pro}") | sort-bed - | uniq > ${outpath}/${outname};
done

# Merge INS features within 500bp distance across all SVcaller  #
for i in ${svpath}/delly ${svpath}/manta;
do
        outpath=${i}/${pro}/inhouse
        prog=$(basename ${i})
        outname=inhouse.${prog}.INS.inhouse
        echo "merging INS files in ${i}/bed"
        cat $(ls ${i}/bed/*.INS.key | grep -v "${pro}") | sort-bed - | uniq > ${outpath}/${outname};
done

# Merge DEL, DUP and INV with resolved breakends and similar SVlength within 500bp distance across all SVcaller  #
# groups: 1kb, 10kb, 100kb
for a in ${svpath}/delly ${svpath}/lumpy ${svpath}/manta;
do
	for b in DEL DUP INV;
	do
		outpath=${a}/${pro}/inhouse
		prog=$(basename ${a})
		outname=inhouse.${prog}.${b}
		echo "merging ${b} files in ${b}/bed"
		cat $(ls ${i}/bed/*.${b}.key | grep -v "${pro}") | sort-bed - | uniq > ${outpath}/${outname}.catsort
		awk '{if ($6 <= 1000) print}' ${outpath}/${outname}.catsort | sort-bed - | uniq > ${outpath}/${outname}.1kb.inhouse
		awk '{if ($6 >= 1001 && $6 <= 10000) print}' ${outpath}/${outname}.catsort | sort-bed - | uniq > ${outpath}/${outname}.10kb.inhouse
		awk '{if ($6 >= 10001) print}' ${outpath}/${outname}.catsort | sort-bed - | uniq > ${outpath}/${outname}.100kb.inhouse
		rm ${outpath}/${outname}.catsort;
	done;
done

