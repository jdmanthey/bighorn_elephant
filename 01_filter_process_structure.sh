########################################
######## prep
########################################

# move to working directory
cd /lustre/scratch/jmanthey/23_bighorn_elephant

# make different organizational directories
mkdir 01_structure
mkdir 02_phylo
mkdir 03_kinship
mkdir 04_stairway_2000
mkdir 05_stairway_2017
mkdir 06_stairway_2019
mkdir 07_stairway_all

# copy the snps file for the entire dataset
cp populations.snps.vcf .

# copy the snps files for the different time periods for elephant mountain
# these were run in separate STACKS analyses
cp populationsEM20*snps.vcf .
cd 04_stairway_2000
mv ../populationsEM2000.snps.vcf .
cd ../05_stairway_2017
mv ../populationsEM2017.snps.vcf .
cd ../06_stairway_2019
mv ../populationsEM2019.snps.vcf .
cd ..

# interactive session
interactive -p quanah

# set working directory
workdir=/lustre/scratch/jmanthey/23_bighorn_elephant

# activate bcftools environment (includes bcftools and vcftools)
source activate bcftools

# rename header of vcf
bcftools reheader -s sample_rename.txt -o elephant.vcf populations.snps.vcf

########################################
######## filtering
########################################

# run vcftools to filter for the 3 non-stairway datasets
# filter for pca
vcftools --vcf ${workdir}/elephant.vcf --keep keep_structure.txt --max-missing 0.9 --minGQ 20 --minDP 8 --max-meanDP 100 --min-alleles 2 --max-alleles 2 --mac 3 --thin 10000 --max-maf 0.49 --recode --recode-INFO-all --out ${workdir}/01_structure/structure

# filter for admixture (only subset of elephant mountain individuals)
vcftools --vcf ${workdir}/elephant.vcf --keep keep_admixture.txt --max-missing 0.9 --minGQ 20 --minDP 8 --max-meanDP 100 --min-alleles 2 --max-alleles 2 --mac 3 --thin 10000 --max-maf 0.49 --recode --recode-INFO-all --out ${workdir}/01_structure/admixture

# filter for phylo, diversity
vcftools --vcf ${workdir}/elephant.vcf --keep keep_phylo.txt --max-missing 0.9 --minGQ 20 --minDP 8 --max-meanDP 100 --min-alleles 2 --max-alleles 2 --max-maf 0.49 --recode --recode-INFO-all --out ${workdir}/02_phylo/phylo

# filter for kinship
vcftools --vcf ${workdir}/elephant.vcf --keep keep_kinship.txt --max-missing 0.9 --minGQ 20 --minDP 8 --max-meanDP 100 --min-alleles 2 --max-alleles 2 --max-maf 0.49 --recode --recode-INFO-all --out ${workdir}/03_kinship/kinship

########################################
######## input file prep 
########################################

cd 02_phylo/

cp ../keep_phylo.txt .

# get vcf header from all filtered vcf files (to keep track) (use these header files to reorder popmaps if necessary so individuals are in same order as vcf)
grep "#C" phylo.recode.vcf > header_phylo.txt

# sort the file
bcftools sort phylo.recode.vcf -o phylo.sorted.vcf

# bgzip and index the vcf file
bgzip -c phylo.sorted.vcf > phylo.sorted.vcf.gz

tabix -p vcf phylo.sorted.vcf.gz

# run bcftools to simplify the vcftools output
bcftools query -f '%CHROM\t%POS\t%REF\t%ALT[\t%GT]\n ' phylo.sorted.vcf.gz > phylo.simple.vcf

# load R
module load intel R

R

# convert to aligned fasta for raxml

source("create_fasta_from_vcf.r")

create_fasta_from_vcf("phylo.simple.vcf", "keep_phylo.txt", "phylo.fasta", 1)

q()

cd ..

cd 03_kinship/

cp ../keep_kinship.txt .

# get vcf header from all filtered vcf files (to keep track) (use these header files to reorder popmaps if necessary so individuals are in same order as vcf)
grep "#C" kinship.recode.vcf > header_kinship.txt

# sort the file
bcftools sort kinship.recode.vcf -o kinship.sorted.vcf

# bgzip and index the vcf file
bgzip -c kinship.sorted.vcf > kinship.sorted.vcf.gz

tabix -p vcf kinship.sorted.vcf.gz

# run bcftools to simplify the vcftools output
bcftools query -f '%CHROM\t%POS\t%REF\t%ALT[\t%GT]\n ' kinship.sorted.vcf.gz > kinship.simple.vcf

# load R
module load intel R

R

source("vcf_to_related.r")

vcf_to_related("kinship.simple.vcf", "kinship.related", "keep_kinship.txt")

q()

cd ..


########################################
######## admixture and pca
########################################

cd 01_structure/

# make chromosome map for the vcf
grep -v "#" structure.recode.vcf | cut -f 1 | uniq | awk '{print $0"\t"$0}' > chrom_map.txt

# run vcftools for the vcf intended for PCA with plink output
vcftools --vcf structure.recode.vcf --plink --chrom-map chrom_map.txt --out structure

# convert with plink for pca dataset
plink --file structure --recode12 --allow-extra-chr --out structure_plink

# run  dataset for pca
plink --file structure_plink --pca --allow-extra-chr --out structure_plink_pca

# run vcftools for the vcf intended for admixture with plink output
vcftools --vcf structure.recode.vcf --plink --chrom-map chrom_map.txt --out admixture

# convert with plink for admixture dataset
plink --file admixture --recode12 --allow-extra-chr --out admixture_plink


# run each dataset for admixture
# all bighorn 
for K in 1 2 3 4 5 6 7; do admixture --cv admixture_plink.ped $K  | tee log_elephant_${K}.out; done

cd ..







