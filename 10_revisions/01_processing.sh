# interactive session

source activate bcftools

workdir=/lustre/scratch/jmanthey/13_bighorn_revision

cd ${workdir}

########################################
######## filter
########################################

# filter for pca (only elephant mountain)
vcftools --vcf ${workdir}/phylo.recode.vcf --keep keep_elephant.txt \
--max-missing 0.9 --minGQ 20 --minDP 8 --max-meanDP 100 \
--min-alleles 2 --max-alleles 2 --mac 3 --thin 10000 --max-maf 0.49 \
--recode --recode-INFO-all --out ${workdir}/pca_elephant


# filter for pca and admixture (subset of elephant mountain)
vcftools --vcf ${workdir}/phylo.recode.vcf --keep keep_admixture.txt \
--max-missing 0.9 --minGQ 20 --minDP 8 --max-meanDP 100 \
--min-alleles 2 --max-alleles 2 --mac 3 --thin 10000 --max-maf 0.49 \
--recode --recode-INFO-all --out ${workdir}/pca


# filter for fst and abba baba
vcftools --vcf ${workdir}/phylo.recode.vcf --keep keep_fst.txt \
--max-missing 0.9 --minGQ 20 --minDP 8 --max-meanDP 100 \
--min-alleles 2 --max-alleles 2 --max-maf 0.49 \
--recode --recode-INFO-all --out ${workdir}/fst

########################################
######## fst
########################################

# get population 'keep' files for vcftools fst
grep "KofaMtns_AZ__" keep_fst.txt > KofaMtns_fst_.txt
grep "GabbsValley_NV__" keep_fst.txt | head -n5 > GabbsValley1_fst_.txt
grep "GabbsValley_NV__" keep_fst.txt | tail -n5 > GabbsValley2_fst_.txt
grep "MuddyMtns_NV__" keep_fst.txt > MuddyMtns_fst_.txt
grep "BlackMtns_AZ__" keep_fst.txt > BlackMtns_fst_.txt
grep "Sonora_MEX__" keep_fst.txt > Sonora_fst_.txt
grep "Elephant2000__" keep_fst.txt > Elephant2000_fst_.txt
grep "Elephant2017__" keep_fst.txt > Elephant2017_fst_.txt
grep "Elephant2019__" keep_fst.txt > Elephant2019_fst_.txt
grep "FishCreek_CA__" keep_fst.txt > FishCreek_fst_.txt
grep "RockyMountain_NM__" keep_fst.txt > RockyMountain_fst_.txt


# nested loop for pairwise comparisons to get fst
echo "pop1 pop2 fst" > fst_output.txt
for i in *_fst_.txt
do
  for j in *_fst_.txt
  do
    if [ "$i" \< "$j" ]
    then
     vcftools --vcf ${workdir}/fst.recode.vcf --weir-fst-pop $i --weir-fst-pop $j \
     --out ${i%_fst_.txt}__${j%_fst_.txt}
     fst=$( grep "mean" ${i%_fst_.txt}__${j%_fst_.txt}.log | cut -d ' ' -f 7 )
     pop1=${i%_fst_.txt}
     pop2=${j%_fst_.txt}
     echo "$pop1 $pop2 $fst" >> fst_output.txt
    fi
  done
done

# remove unneeded files
rm *_fst_.txt
rm *.weir.fst
rm *log

########################################
######## admixture and pca
########################################

# pca for elephant mountain
# make chromosome map for the vcf
grep -v "#" pca_elephant.recode.vcf | cut -f 1 | uniq | awk '{print $0"\t"$0}' > chrom_map.txt

# run vcftools for the vcf intended for PCA with plink output
vcftools --vcf pca_elephant.recode.vcf --plink --chrom-map chrom_map.txt --out pca_elephant

# convert with plink for pca dataset
plink --file pca_elephant --recode12 --allow-extra-chr --out pca_elephant_plink

# run  dataset for pca
plink --file pca_elephant_plink --pca --allow-extra-chr --out elephant_plink_pca


# pca for all populations
# make chromosome map for the vcf
grep -v "#" pca.recode.vcf | cut -f 1 | uniq | awk '{print $0"\t"$0}' > chrom_map.txt

# run vcftools for the vcf intended for PCA with plink output
vcftools --vcf pca.recode.vcf --plink --chrom-map chrom_map.txt --out pca

# convert with plink for pca dataset
plink --file pca --recode12 --allow-extra-chr --out pca_plink

# run  dataset for pca
plink --file pca_plink --pca --allow-extra-chr --out plink_pca




# admixture
# run vcftools for the vcf intended for admixture with plink output
vcftools --vcf pca.recode.vcf --plink --chrom-map chrom_map.txt --out admixture

# convert with plink for admixture dataset
plink --file admixture --recode12 --allow-extra-chr --out admixture_plink


# run admixture
for K in 1 2 3 4 5 6 7 8; do admixture --cv admixture_plink.ped $K  | tee log_${K}.out; done





########################################
######## introgression stats
########################################

~/Dsuite/Build/Dsuite Dtrios fst.recode.vcf dsuite_popmap.txt




