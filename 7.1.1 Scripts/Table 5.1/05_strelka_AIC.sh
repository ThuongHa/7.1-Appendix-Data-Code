#!/usr/bin/env bash

#SBATCH -p batch
#SBATCH -N 1
#SBATCH -n 16
#SBATCH --mem=25GB
#SBATCH --time=5:00:00

#SBATCH --array=0-16 # AIC WGS: 5 trios and 2 singletons

# Notification configuration 
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=thuong.ha@adelaide.edu.au

# Set Variables
export FASTDIR=/fast/users/a1618617
WORKDIR=${FASTDIR}/strelka
SDIR=${FASTDIR}/executables/strelka-2.7.1.centos5_x86_64/bin
STRELKA=configureStrelkaGermlineWorkflow.py
REFFA=${FASTDIR}/references/ucsc.hg19.fasta
BAMDIR=/data/neurogenetics/alignments/Illumina/genomes/AIC

# Load Modules
module load GNU/4.9.3-2.25
module load foss/2017a

# Define query bam files
QUERIES=($(ls $BAMDIR/*.bam | xargs -n 1 basename))
mkdir ${WORKDIR}/${QUERIES[$SLURM_ARRAY_TASK_ID]}
export RUNDIR=${WORKDIR}/${QUERIES[$SLURM_ARRAY_TASK_ID]}

### Generate a germline configure workflow for single diploid sample analysis ###
cd ${SDIR}
./${STRELKA} \
--bam=${BAMDIR}/${QUERIES[$SLURM_ARRAY_TASK_ID]} \
--referenceFasta=${REFFA} \
--runDir=${RUNDIR}/

cd ${RUNDIR}
./runWorkflow.py -m local -j 16

###rename output files to include DNA ID###
cd ${BAMDIR}/strelka/results/variants/
for file in genome*; do mv "$file" "${file/genome/${QUERIES[$SLURM_ARRAY_TASK_ID]}.genome}"; done
for file in variants*; do mv "$file" "${file/variants/${QUERIES[$SLURM_ARRAY_TASK_ID]}.variants}"; done
