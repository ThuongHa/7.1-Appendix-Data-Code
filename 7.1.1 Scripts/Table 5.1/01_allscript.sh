#!/usr/bin/env bash

# This is a wrapper script for the programs freebayes, lumpy, manta and strelka

### Set path to bam directories ###
BAMDIR=/data/neurogenetics/alignments/Illumina/genomes #nBAMs=63
BAMDIR1=${BAMDIR}/AIC #nBAMs=19
BAMDIR2=${BAMDIR}/newBAMs #nBAMs=33

### Define scripts ###
SCRIPT_DIR=/fast/users/a1618617/scripts
SCRIPT1=${SCRIPT_DIR}/freebayes.sh
SCRIPT2=${SCRIPT_DIR}/lumpy.sh
SCRIPT3=${SCRIPT_DIR}/manta.sh
SCRIPT4=${SCRIPT_DIR}/strelka.sh

### Define set variables ###
FASTDIR=/fast/users/$USER
REFFA=${FASTDIR}/references/ucsc.hg19.fasta

# This is a test script to make sure the commands below work #
### Run freebayes across all bams ###
#BAMDIR=${BAMDIR} REFFA=${REFFA} WORKDIR=${FASTDIR}/freebayes PROG=freebayes sbatch --array=0-1 ${SCRIPT1}
#BAMDIR=${BAMDIR1} REFFA=${REFFA} WORKDIR=${FASTDIR}/freebayes PROG=freebayes sbatch --array=0-1 ${SCRIPT1}
#BAMDIR=${BAMDIR2} REFFA=${REFFA} WORKDIR=${FASTDIR}/freebayes PROG=freebayes sbatch --array=0-1 ${SCRIPT1}

### Run lumpy across all bams ###
#BAMDIR=${BAMDIR} REFFA=${REFFA} WORKDIR=${FASTDIR}/lumpy PROG=lumpy sbatch --array=0-1 ${SCRIPT2}
#BAMDIR=${BAMDIR1} REFFA=${REFFA} WORKDIR=${FASTDIR}/lumpy PROG=lumpy sbatch --array=0-1 ${SCRIPT2}
#BAMDIR=${BAMDIR2} REFFA=${REFFA} WORKDIR=${FASTDIR}/lumpy PROG=lumpy sbatch --array=0-1 ${SCRIPT2}

### Run freebayes across all bams ###
BAMDIR=${BAMDIR} REFFA=${REFFA} WORKDIR=${FASTDIR}/freebayes PROG=freebayes sbatch --array=0-62%5 ${SCRIPT1} 
BAMDIR=${BAMDIR1} REFFA=${REFFA} WORKDIR=${FASTDIR}/freebayes PROG=freebayes sbatch --array=0-18%5 ${SCRIPT1}
BAMDIR=${BAMDIR2} REFFA=${REFFA} WORKDIR=${FASTDIR}/freebayes PROG=freebayes sbatch --array=0-32%5 ${SCRIPT1}

### Run lumpy across all bams ###
#BAMDIR=${BAMDIR} REFFA=${REFFA} WORKDIR=${FASTDIR}/lumpy PROG=lumpy sbatch --array=0-62 ${SCRIPT2}
#BAMDIR=${BAMDIR1} REFFA=${REFFA} WORKDIR=${FASTDIR}/lumpy PROG=lumpy sbatch --array=0-18 ${SCRIPT2}
#BAMDIR=${BAMDIR2} REFFA=${REFFA} WORKDIR=${FASTDIR}/lumpy PROG=lumpy sbatch --array=0-32 ${SCRIPT2}

### Run manta across all bams ###
#BAMDIR=${BAMDIR} REFFA=${REFFA} WORKDIR=${FASTDIR}/manta PROG=manta sbatch --array=0-62%5 ${SCRIPT3} 
#BAMDIR=${BAMDIR2} REFFA=${REFFA} WORKDIR=${FASTDIR}/manta PROG=manta sbatch --array=0-32%5 ${SCRIPT3}

### Run strelka across all bams ###
#BAMDIR=${BAMDIR} REFFA=${REFFA} WORKDIR=${FASTDIR}/strelka PROG=strelka sbatch --array=0-62%5 ${SCRIPT4} 
#BAMDIR=${BAMDIR2} REFFA=${REFFA} WORKDIR=${FASTDIR}/strelka PROG=strelka sbatch --array=0-32%5 ${SCRIPT4}


