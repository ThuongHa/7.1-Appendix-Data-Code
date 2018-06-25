#!/usr/bin/env bash

#SBATCH -p batch
#SBATCH -N 1
#SBATCH -n 16
#SBATCH --mem=5GB
#SBATCH --time=5:00:00

#SBATCH --array=0-16 # AIC WGS: 5 trios and 2 singletons

# Notification configuration 
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=thuong.ha@adelaide.edu.au

# Set Variables
export FASTDIR=/fast/users/a1618617
WORKDIR=${FASTDIR}/manta
MANTA=${FASTDIR}/executables/manta-1.1.0.centos5_x86_64/bin/configManta.py
REFFA=${FASTDIR}/references/ucsc.hg19.fasta
BAMDIR=/data/neurogenetics/alignments/Illumina/genomes/AIC

# Load Modules
module load GNU/4.9.3-2.25
module load foss/2017a

# Define query bam files
QUERIES=($(ls $BAMDIR/*.bam | xargs -n 1 basename))

### Generate a configure workflow for single diploid sample analysis ###
mkdir ${WORKDIR}/${QUERIES[$SLURM_ARRAY_TASK_ID]}
export RUNDIR=${WORKDIR}/${QUERIES[$SLURM_ARRAY_TASK_ID]}
${MANTA} \
--bam ${BAMDIR}/${QUERIES[$SLURM_ARRAY_TASK_ID]} \
--referenceFasta ${REFFA} \
--runDir ${RUNDIR}/

### Run the workflow script in parallel compute mode ###
cd ${RUNDIR}  
./runWorkflow.py -m local -j 16

###include DNA_ID in output files###
cd ${RUNDIR}/results/variants
for file in candidate*; do mv "$file" "${file/candidate/${QUERIES[$SLURM_ARRAY_TASK_ID]}.}"; done
for file in diploid*; do mv "$file" "${file/diploid/${QUERIES[$SLURM_ARRAY_TASK_ID]}.diploid}"; done
