#!/bin/bash -x

#This script generates picard collecthsmetrics from exomes processed by the neurogenetics pipeline

script=/home/neuro/Documents/Thuong/PICARD/exomepicard.sh
bamdir1=/home/neuro/Documents/Thuong/mount/alignments/WES/Illumina/ExomesMarch2014
bamdir2=/home/neuro/Documents/Thuong/mount/alignments/WES/Illumina/ExomesJune2015
bamdir3=/home/neuro/Documents/Thuong/mount/alignments/WES/Illumina

#$script $bamdir1 T22842
#$script $bamdir2 T25217
#$script $bamdir1 T22101
#$script $bamdir1 T2846
#$script $bamdir2 T25752
#$script $bamdir2 43774
#$script $bamdir1 T22352
#$script $bamdir1 T17262
$script $bamdir3 sqc0025f8
#$script $bamdir1 T25387
#$script $bamdir2 T25820
