# Making keys from Delly output files for resolved breakends and single breakends
# Creator: Thuong Ha (thuong.ha@adelaide.edu.au)
# Date: SEP 2017
# usage example:
#	./delly_key.sh ${file} .vcf.gz

#variables#
path=$1
file=$2
suffix=$3
outname=$(basename ${file} .${suffix})
svtype=("BND" "DEL" "DUP" "INS" "INV")
svtype2=("DEL" "DUP" "INV")

#make a count test file#
touch ${path}/${outname}.txt
echo "Number of SV types for ${outname}" > ${path}/${outname}.txt
total=$(zcat ${file} | grep -v "#" | wc -l)
echo "Total number of SV ${total}" >> ${path}/${outname}.txt

for i in "${svtype[@]}"; do
	count=$(zcat ${file} | cut -f8 | grep -v "#" | grep "SVTYPE=${i}" | wc -l)
	echo "${i} ${count}" >> ${path}/${outname}.txt;
done

#make a delly key file#
#for resolved breakends#
for i in "${svtype2[@]}"; do
	key=${outname}.${i}.key
	zcat ${file} | grep -v "#" | awk -v var="SVTYPE=${i}" '{if ( $8 ~ var ) print $1,$2,var,"Delly"}' | sed 's/ /\t/g' | sed 's/SVTYPE=//g' > ${outname}.${i}.chrpos
	zcat ${file} | grep -v "#" | awk -v var="SVTYPE=${i}" '{if ( $8 ~ var ) print $8}' | sed 's/;/\t/g' | cut -f5 | sed 's/END=//g' > ${outname}.${i}.end
		paste ${path}/${outname}.${i}.chrpos ${path}/${outname}.${i}.end | awk '{print $1,$2,$5,$3,$4}' | awk '( $6 = $3 - $2)' | sort-bed - | sed 's/ /\t/g' | uniq > ${path}/${key}
			rm ${outname}.${i}.chrpos ${outname}.${i}.end;
done

for i in INS; do
key=${outname}.${i}.key
        zcat ${file} | grep -v "#" | awk -v var="SVTYPE=${i}" '{if ( $8 ~ var ) print $1,$2,var,"Delly"}' | sed 's/ /\t/g' | sed 's/SVTYPE=//g' > ${outname}.${i}.chrpos
        zcat ${file} | grep -v "#" | grep "SVTYPE=${i}" | sed 's/;/\t/g' | cut -f18 | sed 's/INSLEN=//g' > ${outname}.${i}.diff
                paste ${path}/${outname}.${i}.chrpos ${path}/${outname}.${i}.diff | awk '($6 = $2 + $5)' | awk '{print $1,$2,$6,$3,$4,$5}' | sort-bed - | sed 's/ /\t/g' | uniq > ${path}/${key}
                        rm ${outname}.${i}.chrpos ${outname}.${i}.diff;
done

#for single breakends/complex variants/artifacts#
#extract single breakpoint position and add 50 buffer bases for the end position#
for i in BND; do
        key=${outname}.${i}.key
	zcat ${file} | grep -v "#" | awk -v var="SVTYPE=${i}" '{if ( $8 ~ var ) print $1,$2,var,"Delly"}' | sed 's/ /\t/g' | sed 's/SVTYPE=//g' > ${outname}.${i}.chrpos
	awk '( $5 = $2 + 50 )' ${outname}.${i}.chrpos | awk '{print $1,$2,$5,$3,$4}' | awk '( $6 = $3 - $2)' | sort-bed - | sed 's/ /\t/g' | uniq > ${path}/${key}
	rm ${outname}.${i}.chrpos;
done

#calculate a five number summary for each svtype#
dellykey=("BND" "DEL" "DUP" "INS" "INV")
echo -en '\n' >> ${path}/${outname}.txt
echo "Basic Stat Summary for each SV Type" >> ${path}/${outname}.txt
for i in "${dellykey[@]}"; do
        file=${path}/${outname}.${i}.key
	summary=$(awk '{print $6}' ${file} | Rscript -e 'summary (as.numeric (readLines ("stdin")))')
        echo "${i}">> ${path}/${outname}.txt
        echo "${summary}">> ${path}/${outname}.txt;
done

