#!/bin/bash
#SBATCH --chdir=./
#SBATCH --job-name=admixture
#SBATCH --partition nocona
#SBATCH --nodes=1 --ntasks=2
#SBATCH --time=48:00:00
#SBATCH --mem-per-cpu=8G
#SBATCH --array=1-100

source activate bcftools

# define main working directory
workdir=/lustre/scratch/jmanthey/17_bighorn_revision2/admixture_random

cd ${workdir}


########################################
######## filter
########################################


# filter for pca and admixture (subset of elephant mountain)
vcftools --vcf ${workdir}/phylo.recode.vcf --keep keep_admixture_${SLURM_ARRAY_TASK_ID}.txt \
--max-missing 0.9 --minGQ 20 --minDP 8 --max-meanDP 100 \
--min-alleles 2 --max-alleles 2 --mac 3 --thin 10000 --max-maf 0.49 \
--recode --recode-INFO-all --out ${workdir}/pca_${SLURM_ARRAY_TASK_ID}


########################################
######## admixture 
########################################


# admixture
# run vcftools for the vcf intended for admixture with plink output
vcftools --vcf pca_${SLURM_ARRAY_TASK_ID}.recode.vcf --plink --chrom-map chrom_map.txt --out admixture_${SLURM_ARRAY_TASK_ID}

# convert with plink for admixture dataset
plink --file admixture_${SLURM_ARRAY_TASK_ID} --recode12 --allow-extra-chr --out admixture_plink_${SLURM_ARRAY_TASK_ID}

# run admixture
admixture --cv admixture_plink_${SLURM_ARRAY_TASK_ID}.ped 8




