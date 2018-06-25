#!/bin/bash -x

# This script is used to remove strings from AGRF bam file names
# Run this script in the directory containing all the files
# Usage example:
#	for i in *; do *./rename.sh ${i}; done
#	rename 's/old/new/' ${file}.old
#	output: ${file}.new

# Run commands #
for i in H*; do
        rename 's/_Homo-sapiens__R_160129_MARCOR_M001//' ${i}
done

for i in H*; do
	rename 's/_Homo-sapiens__R_160411_MARSHA_DNA_M001//' ${i}
done

for i in H* N*; do
	rename 's/.realigned.recal.sorted.bwa.hg19_1stM_unmask_ran_all//' ${i}
done

for i in H*; do
	rename 's/^...................//' ${i};
done
