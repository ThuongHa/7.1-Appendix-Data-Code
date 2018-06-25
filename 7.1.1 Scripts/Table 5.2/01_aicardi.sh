#!/bin/bash

# set variable #
scriptpath=/home/neuro/Documents/Thuong/2017/Genomes/scripts
intpath=${scriptpath}/intersect
probed=${intpath}/probed_intersect.sh
quality=${intpath}/quality_intersect.sh
benign=${intpath}/benign_intersect.sh
proanno=${scriptpath}/proanno.sh
sinanno=${scriptpath}/sinanno.sh
zeroanno=${scriptpath}/rm0bytes.sh
inherit=${scriptpath}/inherit.sh
#inhouse1=${scriptpath}/inhousecat.sh
#inhouse2=${scriptpath}/ihhousecat2.sh
#intersect=${scriptpath}/inhouse_intersect.sh
#pass=${scriptpath}/pass.sh
#inherit=${scriptpath}/mibinher.sh
#genotype=${scriptpath}/genotype.sh
#proanno=${scriptpath}/proanno.sh
#gene=${scriptpath}/gene_intersect.sh
#disease=${scriptpath}/disease_anno.sh
#catsv=${scriptpath}/catdisease.sh

# run commands for all proband-parent trio #
${inherit} FR07959033 FR07959032 FR07959031
${inherit} FR07959030 FR07959025 FR07958986
${inherit} FR07959023 FR07959022 FR07958994
${inherit} FR07958909 FR07958901 FR07958893
${inherit} FR07958885 FR07958877 FR07958869

# run commands for all singletons #
#for i in FR07958917 FR07958956;
#do
#       ${sinanno} ${i};
#done

# run commands for all probands #
#for i in FR07959033 FR07959030 FR07959023 FR07958909 FR07958885 FR07958917 FR07958956;
#do
#	${probed} ${i};
#	${pass} ${i}
#	${quality} ${i};
#	${benign} ${i};
#	${genotype} ${i};
#	${zeroanno} ${i};
#	${disease} ${i};
#done

# run commands for all proband trio #
#for i in FR07959033 FR07959030 FR07959023 FR07958909 FR07958885;
#do
#	${inherit} ${i};
#	${proanno} ${i};
#	${gene} ${i};
#	${catsv} ${i};
#done


