#!/bin/bash

#to get exact start and end coordinates for lumpy DEL, DUP and INV#
zcat NA12878.lumpy_th.vcf.gz | grep -v -e "#" -e "BND" | sed 's/;/\t/g' | cut -f 1,2,10 | sed 's/=/\t/g' | cut -f 1,2,4 | sort-bed - > NA12878.lumpy_th.DelDupInv.bed

#to get exact start and end coordinates for lumpy INS#
zcat NA12878.lumpy_th.vcf.gz | grep "BND" | sed 's/\[/\t/g' | sed 's/\]/\t/g' | sed 's/:/\t/g' | cut -f 1,2,6,7 |\
	awk '{if ($1 == $3) print}' | cut -f 1,2,4 | awk '{if ($3 > $2) print}' | sort-bed - > NA12878.lumpy_th.InsLen.bed

#to get 50 base pair flanking left breakend for lumpy BND#
zcat NA12878.lumpy_th.vcf.gz | grep "BND" | sed 's/\[/\t/g' | sed 's/\]/\t/g' | sed 's/:/\t/g' |\
        cut -f 1,2,6,7 | awk '{if ($1 != $3) print}' | cut -f 1,2 | awk '{if ( $2 >= 50) print $1,$2 += 50; else print $1,$2}' |\
	awk '( $3 = $2 + 50 )' | sed 's/ /\t/g' > NA12878.lumpy_th.leftBND.bed
zcat NA12878.lumpy_th.vcf.gz | grep "BND" | sed 's/\[/\t/g' | sed 's/\]/\t/g' | sed 's/:/\t/g' |\
        cut -f 1,2,6,7 | awk '{if ($1 != $3) print}' | cut -f 3,4 | awk '{if ( $2 >= 50) print $1,$2 += 50; else print $1,$2}' |\
	awk '( $3 = $2 + 50 )' | sed 's/ /\t/g' > NA12878.lumpy_th.rightBND.bed
cat NA12878.lumpy_th.leftBND.bed NA12878.lumpy_th.rightBND.bed | sort-bed - | uniq > NA12878.lumpy_th.50Bnd50.bed
cat NA12878.lumpy_th.*.bed | sort-bed - | uniq > NA12878.lumpy_th.all.bed

#to get exact start and end coordinates for manta DEL, DUP and INV#
zcat NA12878.manta.vcf.gz | grep -v -e "#" -e "BND" -e "MantaINS" | cut -f 1,2,8 | sed 's/;/\t/g' | sed 's/=/\t/g' | cut -f 1,2,4 | sort-bed - > NA12878.manta.DelDupInv.bed

#to get exact start and end coordinates for manta INS (length known)#
zcat NA12878.manta.vcf.gz | grep -v "#" | grep "MantaINS" | grep "SVLEN" | cut -f 1,2,8 | sed 's/;/\t/g' | sed 's/SVLEN=//g' |\
	awk '{$3 = $2 + $5; print $1,$2,$3}' | sed 's/ /\t/g' | sort-bed - > NA12878.manta.InsLen.bed

#to get 50 base pair flanking left breakened of manta INS (length unknown)#
zcat NA12878.manta.vcf.gz | grep -v -e "#" -e "SVLEN" | grep "MantaINS" | sed 's/;/\t/g' | sed 's/=/\t/g' |\
	cut -f 1,2 | awk '{if ( $2 >= 50) print $1,$2 += 50; else print $1,$2}' | awk '( $3 = $2 + 50 )'| sed 's/ /\t/g' | sort-bed - > NA12878.manta.50Ins50.bed

#to get 50bp base pair flanking left and right end breakend for manta BND#
zcat NA12878.manta.vcf.gz | grep -v "#" | grep "MantaBND" | sed 's/\[/\t/g' | sed 's/\]/\t/g' | sed 's/\:/\t/g' |\
	cut -f 1,2 | awk '{if ( $2 >= 50) print $1,$2 += 50; else print $1,$2}' | awk '( $3 = $2 + 50 )' | sed 's/ /\t/g' > NA12878.manta.leftBND.bed
zcat NA12878.manta.vcf.gz | grep -v "#" | grep "MantaBND" | sed 's/\[/\t/g' | sed 's/\]/\t/g' | sed 's/\:/\t/g' |\
	cut -f 13,14 | awk '{if ( $2 >= 50) print $1,$2 += 50; else print $1,$2}' | awk '( $3 = $2 + 50 )' | sed 's/ /\t/g' > NA12878.manta.rightBND.bed
cat NA12878.manta.leftBND.bed NA12878.manta.rightBND.bed | sort-bed - > NA12878.manta.50Bnd50.bed
cat NA12878.manta.*.bed | sort-bed - | uniq > NA12878.manta.all.bed

#to get 50 base pair flanking left breakend of retroseq MEI#
zcat NA12878.retroseq.vcf.gz | vcf2bed | cut -f 1,2,3 |\
	awk '{if ( $2 >= 50) print $1,$2 += 50; else print $1,$2}' | awk '( $3 = $2 + 50 )' | sort-bed - | uniq > NA12878.retro.all.bed

#to get exact start and end coordinates for gridss INS#
zcat NA12878.gridss.vcf.gz | grep -v "#" | cut -f 1,2,5 | sed 's/\[/\t/g' | sed 's/\]/\t/g' | sed 's/:/\t/g' |\
	awk '{if ($1 == $4) print}' | cut -f 1,2,5 | awk '{if ($3 > $2) print}' | sort-bed - > NA12878.gridss.InsLen.bed

#to get exact start and end coordinates for gridss DEL, DUP, INV#
zcat NA12878.gridss.vcf.gz | grep -v "#" | cut -f 1,2,5 | sed 's/\[/\t/g' | sed 's/\]/\t/g' | sed 's/:/\t/g' |\
        awk '{if ($1 == $4) print}' | cut -f 1,2,5 | awk '{if ($3 < $2) print}' |\
	awk '($4 = $2 - $3) ($5 = $2 + $4) {print $1,$2,$5}' | sed 's/ /\t/g' | sort-bed - > NA12878.gridss.DelDupInv.bed

#to get 50 base pair flanking left and right breakend for gridss BND#
zcat NA12878.gridss.vcf.gz | grep -v "#" | cut -f 1,2,5 | sed 's/\[/\t/g' | sed 's/\]/\t/g' | sed 's/:/\t/g' | cut -f 1,2,4,5 | awk '{if ($1 != $3) print}' |\
	cut -f 1,2 | awk '{if ( $2 >= 50) print $1,$2 += 50; else print $1,$2}' | awk '( $3 = $2 + 50 )' | sed 's/ /\t/g' > NA12878.gridss.leftBND.bed
zcat NA12878.gridss.vcf.gz | grep -v "#" | cut -f 1,2,5 | sed 's/\[/\t/g' | sed 's/\]/\t/g' | sed 's/:/\t/g' | cut -f 1,2,4,5 | awk '{if ($1 != $3) print}' |\
        cut -f 3,4 | awk '{if ( $2 >= 50) print $1,$2 += 50; else print $1,$2}' | awk '( $3 = $2 + 50 )' | sed 's/ /\t/g' > NA12878.gridss.rightBND.bed
cat NA12878.gridss.leftBND.bed NA12878.gridss.rightBND.bed | sort-bed - > NA12878.gridss.50Bnd50.bed
cat NA12878.gridss*.bed | sort-bed - | uniq > NA12878.gridss.all.bed

#to get exact start and end coordinates for delly DEL, DUP, INV#
zcat NA12878.delly.vcf.gz | grep -e "SVTYPE\=\DEL" -e "SVTYPE\=\DUP" -e "SVTYPE\=\INV" | cut -f 1,2,8 | sed 's/;/\t/g' |\
	 cut -f 1,2,7 | sed 's/END=//g' | sort-bed - > NA12878.delly.DelDupInv.bed

#to get exact start and end coordinates for delly INS#
zcat NA12878.delly.vcf.gz | grep -e "SVTYPE\=\INS" | cut -f 1,2,8 | sed 's/;/\t/g' | cut -f 1,2,13 | sed 's/INSLEN=//g' |\
	awk '{$4 = $2 + $3; print $1,$2,$4}' | sort-bed - > NA12878.delly.INS.bed

#to get 50 base pair flanking left and right breakened for delly BND#
zcat NA12878.delly.vcf.gz | grep -v "#" | grep -e "BND" | cut -f 1,2,5 | sed 's/\[/\t/g' | sed 's/\]/\t/g' | sed 's/:/\t/g' | cut -f 1,2,4,5 | awk '{if ($1 != $3) print}' |\
        cut -f 1,2 | awk '{if ( $2 >= 50) print $1,$2 += 50; else print $1,$2}' | awk '( $3 = $2 + 50 )' | sed 's/ /\t/g' > NA12878.delly.leftBND.bed
zcat NA12878.delly.vcf.gz | grep -v "#" | grep -e "BND" | cut -f 1,2,5 | sed 's/\[/\t/g' | sed 's/\]/\t/g' | sed 's/:/\t/g' | cut -f 1,2,4,5 | awk '{if ($1 != $3) print}' |\
        cut -f 3,4 | awk '{if ( $2 >= 50) print $1,$2 += 50; else print $1,$2}' | awk '( $3 = $2 + 50 )' | sed 's/ /\t/g' > NA12878.delly.rightBND.bed
cat NA12878.delly.leftBND.bed NA12878.delly.rightBND.bed | sort-bed - > NA12878.delly.50Bnd50.bed
cat NA12878.delly*.bed | sort-bed - | uniq > NA12878.delly.all.bed

#to get exact start and end coordinates for freebayes SNV and INDEL#
zcat NA12878.freebayes.snv.vcf.gz | vcf2bed --snvs | cut -f 1,2,3 > NA12878.freeb.Snv.bed
zcat NA12878.freebayes.indel.vcf.gz | vcf2bed --insertions | cut -f 1,2,3 > NA12878.freeb.Ins.bed
zcat NA12878.freebayes.indel.vcf.gz | vcf2bed --deletions | cut -f 1,2,3 > NA12878.freeb.Del.bed
cat NA12878.freeb*.bed | sort-bed - | uniq > NA12878.freeb.all.bed

#to get exact start and end coordinates for strelka SNV and INDEL#
zcat NA12878.strelka.vcf.gz | vcf2bed --snvs | cut -f 1,2,3 > NA12878.strelka.Snv.bed
zcat NA12878.strelka.vcf.gz | vcf2bed --insertions | cut -f 1,2,3 > NA12878.strelka.Ins.bed
zcat NA12878.strelka.vcf.gz | vcf2bed --deletions | cut -f 1,2,3 > NA12878.strelka.Del.bed
cat NA12878.strelka*.bed | sort-bed - | uniq > NA12878.strelka.all.bed

