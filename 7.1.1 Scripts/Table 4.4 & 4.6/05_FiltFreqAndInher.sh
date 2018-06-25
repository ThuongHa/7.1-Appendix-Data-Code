#!/bin/bash -x


usage ()
{
echo "# FiltFreqAndInher.sh -f HAPPY -i ~/MyVCF/Folder -a DNA1 -m DNA2 -d DNA3 | [-h | --help]
# A script to filter Annovar combo files based on allele frequency and inheritance models
#
# Options:
# -f FAMILY		Family name of proband
# -i /path/to/input_dir		Path to where files are stored
# -g GenomeFile		Annovar genome_summary_combo file
# -a AFFECTED		DNA number of proband
# -m MUM		DNA number of mother
# -d DAD		DNA number of father
# -h | --help		Prints this message
#
# History:
# Original: 	Thuong Ha; 18/09/2014; thuong.ha@adelaide.edu.au
# Modified:
#		Thuong Ha; 01/10/2014; Added a textfile containing a summary of variant numbers per filtered dataset
#
# Set variables
"
}

# Set variables
while [ "$1" != "" ]; do
	case $1 in
		-f )			shift
						Family=$1
						;;
		-i )			shift
						InputDir=$1
						;;
		-g)			shift
						GenomeFile=$1
						;;
		-a )			shift
						Affected=$1
						;;
		-m )			shift
						Mum=$1
						;;
		-d )			shift
						Dad=$1
						;;

		-h | --help )	usage
						exit 1
						;;
		* )				usage
						exit 1
	esac
	shift
done
if [ -z "$Family" ]; then #If no family specified then do not proceed
	usage
	echo "#ERROR: You need to specify a family name to test."
	exit 1
fi
if [ -z "$InputDir" ]; then #If no input directory specified then do not proceed
	usage
	echo "#ERROR: You need to tell me where to find your VCF file."
	exit 1
fi
if [ -z "$GenomeFile" ]; then #if no input directory specified then do not proceed
	usage
	echo "ERROR: You need to tell me the name of the combo file."
fi
if [ -z "$Affected" ]; then #If DNA of affected is not specified then do not proceed
	usage
	echo "#ERROR: You need to tell me which DNA ID to test as affected."
	exit 1
fi
if [ -z "$Mum" ]; then #If DNA of mother is not specified then do not proceed
	usage
	echo "#ERROR: You need to tell me which DNA ID to test as mother."
	exit 1
fi
if [ -z "$Dad" ]; then #If DNA of father is not specified then do not proceed
	usage
	echo "#ERROR: You need to tell me which DNA ID to test as father."
	exit 1
fi

## Start script ##

FamDir=$InputDir/$Family
CombFile=GenomeAnnotationsCombined
GenomeFile=$Family.$CombFile.$Affected.txt
OutPrefix=$Family.$Affected

cd $FamDir
~/Documents/Pipelines/Thuong/FiltFreqV3.sh $GenomeFile $OutPrefix

MumFile=$Mum.$Family.common.vcf.$CombFile.txt
DadFile=$Dad.$Family.common.vcf.$CombFile.txt

cd $FamDir
cp $FamDir/$Mum/$MumFile $Family.$CombFile.$Mum.txt
mv $FamDir/$Mum/$Family.$CombFile.$Mum.txt $FamDir

cd $FamDir
cp $FamDir/$Dad/$DadFile $Family.$CombFile.$Dad.txt
mv $FamDir/$Dad/$Family.$CombFile.$Dad.txt $FamDir

FreqFile=FreqFilt.$OutPrefix.txt

cd $FamDir
~/Documents/Pipelines/Thuong/FiltInherV3.sh $GenomeFile $Family.$CombFile.$Mum.txt $Family.$CombFile.$Dad.txt $FreqFile $OutPrefix

cd $FamDir
~/Documents/Pipelines/Thuong/FiltStats.sh $OutPrefix
