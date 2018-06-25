#!/bin/bash

# combine svs by inheritance #

# set variables #
svpath=/home/neuro/Documents/Thuong/2017/Genomes/CNV_SV
allpath=${svpath}/allsv
pro=$1
delpath=${svpath}/delly/${pro}/disease
lumpath=${svpath}/lumpy/${pro}/disease
manpath=${svpath}/manta/${pro}/disease
retpath=${svpath}/retro/${pro}/disease

# make directories #
cd ${allpath}
mkdir ${pro}
outpath=${allpath}/${pro}

# denovo #
cat ${delpath}/*dn* ${lumpath}/*dn* ${manpath}/*dn* ${retpath}/*dn* |\
sort -k1,1 -k2,2n > ${outpath}/${pro}.denovo
# homozygous recessive #
cat ${delpath}/*hr* ${lumpath}/*hr* ${manpath}/*hr* ${retpath}/*hr* |\
sort -k1,1 -k2,2n > ${outpath}/${pro}.homrec
# compound heterozygous #
cat ${delpath}/*ch* ${lumpath}/*ch* ${manpath}/*ch* ${retpath}/*ch* |\
sort -k1,1 -k2,2n > ${outpath}/${pro}.comhet

