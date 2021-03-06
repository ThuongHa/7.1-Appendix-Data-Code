#!/bin/bash -x

script=/home/neuro/Documents/Thuong/PICARD/genomepicard.sh
bamdir=/home/neuro/Documents/Thuong/mount/AGRF_KCCG_WGS/BAM

$script $bamdir/HNCK3CCXX_4_160129_FR07958885_Homo-sapiens__R/HNCK3CCXX_4_160129_FR07958885_Homo-sapiens__R_160129_MARCOR_M001.5.bam FR07958885
$script $bamdir/FR07958909/FR07958909_FR07958909_HHTTYCCXX-HNFYNCCXX_45.5.bam FR07958909
$script $bamdir/HNFYNCCXX_6_160129_FR07958917_Homo-sapiens__R/FR07958917_HNFYNCCXX_6.5.bam FR07958917
$script $bamdir/HHTTYCCXX_1_160129_FR07959023_Homo-sapiens__R/HHTTYCCXX_1_160129_FR07959023_Homo-sapiens__R_160129_MARCOR_M001.5.bam FR07959023
$script $bamdir/HHTTYCCXX_2_160129_FR07959030_Homo-sapiens__R/HHTTYCCXX_2_160129_FR07959030_Homo-sapiens__R_160129_MARCOR_M001.5.bam FR07959030
$script $bamdir/HNFYNCCXX_8_160129_FR07959033_Homo-sapiens__R/HNFYNCCXX_8_160129_FR07959033_Homo-sapiens__R_160129_MARCOR_M001.5.bam FR07959033

