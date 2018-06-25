# Making keys from Lumpy output files for resolved breakends and single breakends
# Creator: Thuong Ha (thuong.ha@adelaide.edu.au)
# Date: SEP 2017
# usage example:
#	./lumpy_key.sh ${file} .lumpy.vcf.gz


#variables#
path=$1
file=$2
suffix=$3
outname=$(basename ${file} .${suffix})
svtype=("BND" "DEL" "DUP" "INV")
svtype2=("DEL" "DUP" "INV")

#make a count test file#
touch ${path}/${outname}.txt
echo "Number of SV types for ${outname}" > ${path}/${outname}.txt
total=$(zcat ${file} | grep -v "#" | wc -l)
echo "Total number of SV ${total}" >> ${path}/${outname}.txt

for i in "${svtype[@]}"; do
	count=$(zcat ${file} | cut -f8 | grep -v "#" | grep "${i}" | wc -l)
	echo "${i} ${count}" >> ${path}/${outname}.txt;
done

#make a lumpy key file#
#for resolved breakends#
for i in "${svtype2[@]}"; do
	key=${outname}.${i}.key
	zcat ${file} | grep -v "#" | awk -v var="SVTYPE=${i}" '{if ( $8 ~ var ) print $1,$2,var,"Lumpy"}' | sed 's/ /\t/g' | sed 's/SVTYPE=//g' > ${path}/${outname}.${i}.chrpos
	zcat ${file} | grep -v "#" | awk -v var="SVTYPE=${i}" '{if ( $8 ~ var ) print $8}' | sed 's/;/\t/g' | cut -f3 | sed 's/END=//g' > ${path}/${outname}.${i}.end
		paste ${path}/${outname}.${i}.chrpos ${path}/${outname}.${i}.end | awk '{print $1,$2,$5,$3,$4}' | awk '( $6 = $3 - $2)' | sort-bed - | sed 's/ /\t/g' | uniq > ${path}/${key}
		rm ${outname}.${i}.chrpos ${outname}.${i}.end;
done

#for single breakends/complex variants/artifacts#
zcat ${file} | grep -v "#" | awk -v var="SVTYPE=BND" '{if ( $8 ~ var ) print $1,$2,var,"Lumpy"}' | sed 's/ /\t/g' | sed 's/SVTYPE=//g' > ${path}/${outname}.BND.chrpos
awk '( $5 = $2 + 50 )' ${path}/${outname}.BND.chrpos | awk '{print $1,$2,$5,$3,$4}' | awk '( $6 = $3 - $2)' | sort-bed - | sed 's/ /\t/g' | uniq > ${path}/${outname}.BND.key
	rm ${outname}.BND.chrpos

#calculate a five number summary for each svtype#
lumpykey=("BND" "DEL" "DUP" "INV")
echo -en '\n' >> ${path}/${outname}.txt
echo "Basic Stat Summary for each SV Type" >> ${path}/${outname}.txt
for i in "${lumpykey[@]}"; do
        file=${path}/${outname}.${i}.key
	summary=$(awk '{print $6}' ${file} | Rscript -e 'summary (as.numeric (readLines ("stdin")))')
        echo "${i}">> ${path}/${outname}.txt
        echo "${summary}">> ${path}/${outname}.txt;

done

