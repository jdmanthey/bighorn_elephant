# interactive session
interactive -p quanah

module load gnu7/7.3.0

# set working directory
workdir=/lustre/scratch/jmanthey/23_bighorn_elephant/08_ne
cd $workdir

########################################
######## filtering
########################################

# run vcftools to filter for the currentNe program for elephant 2017 and elephant 2019 with thinning
# 2017
vcftools --vcf ${workdir}/elephant.vcf --keep keep_elephant2017.txt --max-missing 1.0 --minGQ 20 --minDP 8 --max-meanDP 100 --min-alleles 2 --max-alleles 2 --mac 3 --thin 100000 --max-maf 0.49 --recode --recode-INFO-all --out ${workdir}/elephant2017

# 2019
vcftools --vcf ${workdir}/elephant.vcf --keep keep_elephant2019.txt --max-missing 1.0 --minGQ 20 --minDP 8 --max-meanDP 100 --min-alleles 2 --max-alleles 2 --mac 3 --thin 100000 --max-maf 0.49 --recode --recode-INFO-all --out ${workdir}/elephant2019

# number of chromosomes in files
grep -v "#" elephant2017.recode.vcf | cut -f 1 | uniq | awk '{print $0"\t"$0}' > chrom_map2017.txt
grep -v "#" elephant2019.recode.vcf | cut -f 1 | uniq | awk '{print $0"\t"$0}' > chrom_map2019.txt

wc -l chrom_map2017.txt  # 30
wc -l chrom_map2019.txt  # 29

# run the program
/home/jmanthey/currentNe/currentNe elephant2017.recode.vcf 30

/home/jmanthey/currentNe/currentNe elephant2019.recode.vcf 29
