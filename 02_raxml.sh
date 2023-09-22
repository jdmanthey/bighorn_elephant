#!/bin/bash
#SBATCH --chdir=./
#SBATCH --job-name=raxml
#SBATCH --partition quanah
#SBATCH --nodes=1 --ntasks=8
#SBATCH --time=48:00:00
#SBATCH --mem-per-cpu=8G

raxmlHPC-PTHREADS-SSE3 -T 8 -f a -x 50 -m ASC_GTRGAMMA --asc-corr=lewis -p 253 -N 100 \
-s /lustre/scratch/jmanthey/23_bighorn_elephant/02_phylo/phylo.fasta \
-n elephant.tre \
-w /lustre/scratch/jmanthey/23_bighorn_elephant/02_phylo/

