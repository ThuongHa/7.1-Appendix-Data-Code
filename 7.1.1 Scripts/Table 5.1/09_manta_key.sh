# Making keys from Manta output files for resolved breakends and single breakends
# Creator: Thuong Ha (thuong.ha@adelaide.edu.au)
# Date: SEP 2017
# usage example:
#	./manta_key.sh ${outpath} ${path/vcf.gz} ${extension}

#variables#
path=$1
file=$2
suffix=$3
outname=$(basename ${file} .${suffix})
svtype=("BND" "DEL" "DUP" "INS" "INV")

#make a count test file#
touch ${path}/${outname}.txt
echo "Number of SV types for ${outname}" > ${path}/${outname}.txt
total=$(zcat ${file} | grep -v "#" | wc -l)
echo "Total number of SV ${total}" >> ${path}/${outname}.txt

for i in "${svtype[@]}"; do
	count=$(zcat ${file} | cut -f8 | grep -v "#" | grep "SVTYPE=${i}" | wc -l)
	echo "${i} ${count}" >> ${path}/${outname}.txt;
done

#make a manta key file#
#for resolved breakends#
for i in DEL DUP INV; do
	key=${outname}.${i}.key
	zcat ${file} | grep "SVTYPE=${i}" | cut -f 1,2,8 | sed 's/;/\t/g;s/END=//g' | cut -f 1,2,3 |\
	awk -v var="${i}" '{if ($3 <= $2) print $1,$2,$3+50,var,"Manta","50"; else print $1,$2,$3,var,"Manta",$3-$2}' |\
	sed 's/ /\t/g' | sort-bed - | uniq > ${path}/${key};
done

#for resolved and single breakend insertions; keep all insertions with resolved breakends, but add 50bp to insertions with single breakends#
for i in INS; do
        key=${outname}.${i}
	zcat ${file} | grep "SVTYPE=INS" | cut -f 1,2,8 | sed 's/;/\t/g' | cut -f 1,2,3,5 |\
	awk -v var="SVLEN" '{if ($4 ~ var) print $1,$2,$4; else print $1,$2,"50"}' | sed 's/SVLEN=//g' | awk '{print $1,$2,$2+$3,"INS","Manta",$3}' |\
	sed 's/ /\t/g' | sort-bed - | uniq > ${path}/${key}.key;
done

#for single breakends/complex variants/artifacts#
#extract single breakpoint position and add 50 buffer bases for the end position#
for i in BND; do
        key=${outname}.${i}.key
	zcat ${file} | grep "SVTYPE=${i}" | awk '{print $1,$2,$2+50,"BND","Manta","50"}' |\
	sed 's/ /\t/g' | sort-bed - | uniq > ${path}/${key};
done

#calculate a five number summary for each svtype#
mantakey=("BND" "DEL" "DUP" "INS" "INV")
echo -en '\n' >> ${path}/${outname}.txt
echo "Basic Stat Summary for each SV Type" >> ${path}/${outname}.txt
for i in "${mantakey[@]}"; do
        file=${path}/${outname}.${i}.key
	summary=$(awk '{print $6}' ${file} | Rscript -e 'summary (as.numeric (readLines ("stdin")))')
        echo "${i}">> ${path}/${outname}.txt
        echo "${summary}">> ${path}/${outname}.txt;

done

