#!/bin/bash -x

# This script makes bed files for the following NA12878 truthsets:
# 	Complex_1ormoreindels_NIST2.19.vcf.gz
# 	Complex_noindels_NIST2.19.vcf.gz
# 	NA12878.sorted.vcf.gz
# 	NA12878.wgs.mergedSV.v8.20130502.svs.genotypes.vcf.gz
# This script also modifies bed files for the following NA12878 truthsets:
#	HG001_GRCh38_GIAB_highconf_CG-IllFB-IllGATKHC-Ion-10X-SOLID_CHROM1-X_v.3.3.2_highconf_nosomaticdel_noCENorHET7.bed
#	Personalis_1000_Genomes_deduplicated_deletions.bed
#	Spiral_Genetics_insertions.bed

# Set variables #
truthdir=/home/neuro/Documents/Thuong/NA12878/truthsets/vcfgz
in1=${truthdir}/Complex_1ormoreindels_NIST2.19.vcf.gz
in2=${truthdir}/Complex_noindels_NIST2.19.vcf.gz
in3=${truthdir}/NA12878.sorted.vcf.gz
in4=${truthdir}/NA12878.wgs.mergedSV.v8.20130502.svs.genotypes.vcf.gz
ogbeddir=/home/neuro/Documents/Thuong/NA12878/truthsets/bed/original
in5=${ogbeddir}/HG001_GRCh38_GIAB_highconf_CG-IllFB-IllGATKHC-Ion-10X-SOLID_CHROM1-X_v.3.3.2_highconf_nosomaticdel_noCENorHET7.bed
in6=${ogbeddir}/Personalis_1000_Genomes_deduplicated_deletions.bed
in7=${ogbeddir}/Spiral_Genetics_insertions.bed

# Make Complex SNP and Indel bed files #
#zcat ${in1} | grep -v "#" | awk '{print "chr"$1,$2,$2+1,"SNP","Complex","1"}' | sort-bed - | sed 's/ /\t/g' > Complex_SNP.bed

#zcat ${in2} | grep -v "#" |\
#awk '{if (length($4) >= 2)
#	print "chr"$1,$2,$2+length($4),"DEL","ZOOKCOM",length($4);
#else if (length($5) >= 2)
#	print "chr"$1,$2,$2+length($5),"INS","ZOOKCOM",length($5);
#else print "chr"$1,$2,$2+1,"SNP","ZOOKCOM","1"}' | sort-bed - | sed 's/ /\t/g' > Complex_INDEL.bed

# Make MtSinai Indel bed file #
#zcat ${in3} | grep -v "#" | cut -f1,2,8 | sed 's/;/\t/g;s/SVTYPE=//g;s/END=//g' |\
#awk '{if ($5 <= $2) print $1,$2,$5+1,$4,"MTSINAI","1"; else print $1,$2,$5,$4,"MTSINAI",$5-$2}' | sort-bed - | sed 's/ /\t/g' > MtSinai_INDEL.bed

# Make individual 1000G transposable element bed file #
# SVLEN column for MEI = $NF - 2 (third last column)
for i in ALU SVA LINE; do
	zcat ${in4} | cut -f 1,2,8 | sed 's/;/\t/g;s/SVLEN=//g' | grep "SVTYPE=${i}" |\
	awk -v var="${i}" '{print "chr"$1,$2,var,"1000G",$(NF-2)}' | sed 's/SVLEN=//g' |\
	awk '{if ($5 < 1) print $1,$2,$2+1,$3,$4,"1"; else print $1,$2,$2+$5,$3,$4,$5}' |\
	sort-bed - | sed 's/ /\t/g' > 1000G_${i}.bed;
done

cat 1000G_ALU* 1000G_SVA* 1000G_LINE* > 1000G_MEI.bed

# Make individual 1000G SV bed file #
# END column for INS & INV = $12
# END column for CNV & DUP = $10
# END column for DEL = $10 and $12

#for i in INS INV; do
#        zcat ${in4} | cut -f 1,2,8 | sed 's/;/\t/g;s/END=//g' | grep "SVTYPE=${i}" |\
#        awk -v var="${i}" '{if ($12-$2 < 1) print "chr"$1,$2,$2+1,var,"1000G","1"; else print "chr"$1,$2,$12,var,"1000G",$12-$2}' |\
#        sed 's/SVTYPE=//g;s/_\S*//g;s/ /\t/g' | sort-bed - > 1000G_${i}.bed;
#done

#for i in CNV DUP; do
#        zcat ${in4} | cut -f 1,2,8 | sed 's/;/\t/g;s/END=//g' | grep "SVTYPE=${i}" |\
#        awk -v var="${i}" '{if ($10-$2 < 1) print "chr"$1,$2,$2+1,var,"1000G","1"; else print "chr"$1,$2,$10,var,"1000G",$10-$2}' |\
#        sed 's/SVTYPE=//g;s/_\S*//g;s/ /\t/g' | sort-bed - > 1000G_${i}.bed;
#done

#cat 1000G_DUP* 1000G_CNV* > 1000G_DUP.tmp
#mv 1000G_DUP.tmp 1000G_DUP.bed

#zcat ${in4} | cut -f 1,2,8 | sed 's/;/\t/g' | grep "SVTYPE=DEL" |\
#awk -v var="END" '{ if ($10 ~ var) print "chr"$1,$2,$10,"DEL","1000G"; else if ($12 ~ var) print "chr"$1,$2,$12,"DEL","1000G"}' |\
#sed 's/END=//g' | awk '{if ($3-$2 !=1) print $1,$2,$3,$4,$5,$3-$2; else if ($3-$2 !=1) print $1,$2,$3,$4,$5,"1"}' |\
#sed 's/ /\t/g' | sort-bed - > 1000G_DEL.bed

# Modify the Zook, Personalis and Spiral bed files to include chr and svtype #

# Modify the Zook bed file #
#awk '{if ($3-$2 != 1) print $1,$2,$3,"INDEL","ZOOKHC",$3-$2}' ${in5} | sort-bed - | sed 's/ /\t/g'> Zook_INDEL.bed
#awk '{if ($3-$2 == 1) print $1,$2,$3,"SNP","ZOOKHC","1"}' ${in5} | sort-bed - | sed 's/ /\t/g'> Zook_SNP.bed

# Modify the Personalis & Spiral bed file #
#awk '{print "chr"$1,$2,$3,"DEL","PERSON",$3-$2}' ${in6} | sed '1d' | sort-bed - | sed 's/ /\t/g'> Personalis_DEL.bed
#awk '{print "chr"$1,$2,$3,"INS","SPIRAL",$3-$2}' ${in7} | sed '1d' | sort-bed - | sed 's/ /\t/g' > Spiral_INS.bed
