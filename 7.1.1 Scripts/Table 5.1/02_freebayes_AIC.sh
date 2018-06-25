#!/usr/bin/env bash

#SBATCH -J aic_fb
#SBATCH -p batch
#SBATCH --nodes 1
#SBATCH --ntasks-per-node 32 
#SBATCH --mem=20GB
#SBATCH --time=24:00:00

#SBATCH --array=13-16 # AIC WGS = 5 trios and 2 singletons

# Notification configuration 
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=thuong.ha@adelaide.edu.au

# Set Variables
export FASTDIR=/fast/users/a1618617
FGR=${FASTDIR}/executables/freebayes-1.1.0/scripts/fasta_generate_regions.py
REFFA=${FASTDIR}/references/ucsc.hg19.fasta
WORKDIR=${FASTDIR}/freebayes
FB_PARALLEL=${FASTDIR}/executables/freebayes-1.1.0/scripts
BAMDIR=/data/neurogenetics/alignments/Illumina/genomes/AIC/*

# Load Modules
module load foss/2016uofa
module load gnu-parallel/2016-01-23-foss-2015b
module load GCC/6.3.0-2.27

# Define query bam files
QUERIES=($(ls $BAMDIR/*.bam | xargs -n 1 basename))

### Generate regions of equal data size ###
${FGR} ${REFFA} 100000 > ${WORKDIR}/${QUERIES[$SLURM_ARRAY_TASK_ID]}.hg19_1stM_unmask_ran_100000.txt

### Run freebayes to call SNPs ###
cd ${FB_PARALLEL}
echo "Hello, I'm calling snps using freebayes now"
./freebayes-parallel ${WORKDIR}/${QUERIES[$SLURM_ARRAY_TASK_ID]}.hg19_1stM_unmask_ran_100000.txt 32 \ 
	-f ${REFFA} \
	-b ${BAMDIR}/${QUERIES[$SLURM_ARRAY_TASK_ID]} \
	-i -X -u \
	> ${WORKDIR}/${QUERIES[$SLURM_ARRAY_TASK_ID]}.FBsnv.vcf
echo "Bye, I have finished calling snps xx fingers crossed xx"

### Run freebayes to call INDELs ###
cd ${FB_PARALLEL} 
echo "Hello, I'm calling indels using freebayes now"
./freebayes-parallel ${WORKDIR}/${QUERIES[$SLURM_ARRAY_TASK_ID]}.hg19_1stM_unmask_ran_100000.txt 32 \
        -f ${REFFA} \
        -b ${BAMDIR}/${QUERIES[$SLURM_ARRAY_TASK_ID]} \
        -I -X -u \
        > ${WORKDIR}/${QUERIES[$SLURM_ARRAY_TASK_ID]}.FBindel.vcf
echo "Bye, I have finished calling indels xx fingers crossed xx"
