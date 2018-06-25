#!/bin/bash

# A script to set off a series of parallel mapping and calling from a folder of fastq files.
usage()
{
echo "# A script to set off a series of parallel mapping and calling from a folder of fastq files.
# Requires: BWA-GATKHC.sub and dependencies.  
#
# Usage $0 -s /path/to/sequences [ -o /path/to/output] | [ - h | --help ]
#
# Options
# -s	Path to the sequence files
# -o	Path to where you want to find your file output (if not specified current directory is used)
# -h or --help	Prints this message.  Or if you got one of the options above wrong you'll be reading this too!
# 
# Original: Mark Corbett, 27/03/2014
# Modified: (Date; Name; Description)
# 
"
}
## Set Variables ##
while [ "$1" != "" ]; do
	case $1 in
		-s )			shift
					SEQPATH=$1
					;;
		-o )			shift
					WORKDIR=$1
					;;
		-h | --help )		usage
					exit 1
					;;
		* )			usage
					exit 1
	esac
	shift
done

if [ -z "$SEQPATH" ]; then # If path to sequences not specified then do not proceed
	usage
	echo "#ERROR: You need to specify the path to your sequence files"
	exit 1
fi
if [ -z "$WORKDIR" ]; then # If no output directory then use current directory
	WORKDIR=$(pwd)
	echo "Using current directory as the working directory"
fi

prefixList=$(ls $SEQPATH | awk -F "_" '{print $1}' | uniq | sort)

for p in $prefixList
do
	~/Documents/Scripts/local/Illumina-Phred33-PE-BWA-Picard-GATKv3.x.Local.sh -p $p -s $SEQPATH -o $WORKDIR
done
