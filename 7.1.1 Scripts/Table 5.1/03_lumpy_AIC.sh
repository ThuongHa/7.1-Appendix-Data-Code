#!/usr/bin/env bash

#SBATCH -p batch
#SBATCH -J lumpy
#SBATCH --output=/fast/users/a1618617/slurm/Lumpy.%A_%a.out
#SBATCH --error=/fast/users/a1618617/slurm/Lumpy.%A_%a.error
#SBATCH -N 1
#SBATCH -n 16
#SBATCH --mem=20GB
#SBATCH --time=48:00:00

#SBATCH --array=0-16 # AIC WGS: 5 trios and 2 singletons

# Notification configuration 
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=thuong.ha@adelaide.edu.au

# Set Variables
export FASTDIR=/fast/users/a1618617
LUMDIR=${FASTDIR}/executables/lumpy-sv
REFFA=${FASTDIR}/references/ucsc.hg19.fasta
BAMDIR=/data/neurogenetics/alignments/Illumina/genomes/AIC/*
EXCLUDE=${FASTDIR}/references/delly2.hg19.ct.bed

# Load Modules
module load GCCcore/6.3.0
module load SAMtools/1.3.1-GCC-5.3.0-binutils-2.25
module load Pysam/0.10.0-foss-2016uofa-Python-2.7.12
module load Python/2.7.12-foss-2016uofa
module load R/3.3.0-foss-2016uofa

# Define query bam files
QUERIES=($(ls $BAMDIR/*.bam | xargs -n 1 basename))

### Extract the discordant paired-end alignments ###
#samtools view -b -F 1294 ${BAMDIR}/${QUERIES[$SLURM_ARRAY_TASK_ID]} > ${FASTDIR}/lumpy/${QUERIES[$SLURM_ARRAY_TASK_ID]}.pe.unsorted.bam

### Extract the split-read alignments ###
#samtools view -h ${BAMDIR}/${QUERIES[$SLURM_ARRAY_TASK_ID]} \
#	| ${LUMDIR}/scripts/extractSplitReads_BwaMem -i stdin \
#	| samtools view -Sb - \
#	> ${FASTDIR}/lumpy/${QUERIES[$SLURM_ARRAY_TASK_ID]}.sr.unsorted.bam

### Sort both alignments ###
#samtools sort ${FASTDIR}/lumpy/${QUERIES[$SLURM_ARRAY_TASK_ID]}.pe.unsorted.bam \
#	-o ${FASTDIR}/lumpy/${QUERIES[$SLURM_ARRAY_TASK_ID]}.pe.sorted.bam
#samtools sort ${FASTDIR}/lumpy/${QUERIES[$SLURM_ARRAY_TASK_ID]}.sr.unsorted.bam \
#	-o ${FASTDIR}/lumpy/${QUERIES[$SLURM_ARRAY_TASK_ID]}.sr.sorted.bam

### Run Lumpy Express on a single sample with pre-extracted splitters and discordants ###
#cd ${LUMDIR}/bin/
#./lumpyexpress \
#	-B ${BAMDIR}/${QUERIES[$SLURM_ARRAY_TASK_ID]} \
#	-S ${FASTDIR}/lumpy/${QUERIES[$SLURM_ARRAY_TASK_ID]}.sr.sorted.bam \
#	-D ${FASTDIR}/lumpy/${QUERIES[$SLURM_ARRAY_TASK_ID]}.pe.sorted.bam \
#	-x ${EXCLUDE} \
#	-o ${FASTDIR}/lumpy/${QUERIES[$SLURM_ARRAY_TASK_ID]}.lumpy.vcf

### Run SVTyper to create a JSON file with the essential metrics on a BAM file ###
cd ${FASTDIR}/executables/sayaka_svtyper/
./svtyper \
	-B ${BAMDIR}/${QUERIES[$SLURM_ARRAY_TASK_ID]} \
	-l ${FASTDIR}/lumpy/${QUERIES[$SLURM_ARRAY_TASK_ID]}.lumpy.json

### Run SVTyper to perform breakpoint genotyping of structural variants using WGS data ###
cd ${FASTDIR}/executables/sayaka_svtyper/
./svtyper \
	-i ${FASTDIR}/lumpy/${QUERIES[$SLURM_ARRAY_TASK_ID]}.lumpy.vcf \
	-B ${BAMDIR}/${QUERIES[$SLURM_ARRAY_TASK_ID]} \
	-l ${FASTDIR}/lumpy/${QUERIES[$SLURM_ARRAY_TASK_ID]}.lumpy.json \
	> ${FASTDIR}/lumpy/${QUERIES[$SLURM_ARRAY_TASK_ID]}.svtyper.vcf

