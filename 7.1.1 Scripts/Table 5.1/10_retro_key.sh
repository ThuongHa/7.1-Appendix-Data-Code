# Making keys from Retroseq output files for resolved breakends and single breakends
# Creator: Thuong Ha (thuong.ha@adelaide.edu.au)
# Date: SEP 2017
# usage example:
#	./retrokey.sh ${path} ${file} retro.vcf.gz

#variables#
path=$1
file=$2
suffix=$3
outname=$(basename ${file} .${suffix})

#make a count test file#
touch ${path}/${outname}.txt
echo "Number of SV types for ${outname}" > ${path}/${outname}.txt
total=$(zcat ${file} | grep -v "#" | wc -l)
echo "Total number of SV ${total}" >> ${path}/${outname}.txt
	echo "MEI ${total}" >> ${path}/${outname}.txt

#for single breakends/complex variants/artifacts#
zcat ${file} | grep -v "#" | cut -f 1,2 | awk '($3 = $2 + 50) && ($4 = "MEI") && ($5 = "Retro") && ($6 = $3 - $2)' | sort-bed - | sed 's/ /\t/g' | uniq > ${path}/${outname}.BND.key
