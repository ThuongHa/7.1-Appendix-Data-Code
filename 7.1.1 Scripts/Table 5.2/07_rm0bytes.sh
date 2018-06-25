#!/bin/bash

# This script is written to move files with zero names

# set variables #
path=$1

wc -l ${path}/* | awk '{if ($1 == 0) print $NF}' > ${path}/rmlist.txt
while read i in;
do
	rm ${i};
done < ${path}/rmlist.txt
rm ${path}/rmlist.txt
