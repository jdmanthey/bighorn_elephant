########################################
######## prep files
########################################

interactive -p quanah -c 8 -m 8GB

# activate bcftools environment (includes bcftools and vcftools)
source activate bcftools

# set working directory
workdir=/lustre/scratch/jmanthey/23_bighorn_elephant

# rename header of vcfs
cd $workdir
cd 04_stairway_2000
bcftools reheader -s sample_rename.txt -o EM2000.vcf populationsEM2000.snps.vcf

cd ../05_stairway_2017/
bcftools reheader -s sample_rename.txt -o EM2017.vcf populationsEM2017.snps.vcf

cd ../06_stairway_2019/
bcftools reheader -s sample_rename.txt -o EM2019.vcf populationsEM2019.snps.vcf


########################################
######## prepare SFS for Stairway
########################################

conda activate easySFS

# 2000 time frame
cd $workdir/04_stairway_2000
grep -v "#" EM2000.vcf | wc -l		
# 56002 variant sites, 30161513 invariant sites from sumstats summary file

# estimate the SFS
~/easySFS/easySFS.py -i EM2000.vcf -p $workdir/04_stairway_2000/sfs_EM2000.txt -a -f --proj 18

# 2017 time frame
cd $workdir/05_stairway_2017
grep -v "#" EM2017.vcf | wc -l		
# 150526 variant sites, 27277100 invariant sites from sumstats summary file

# estimate the SFS
~/easySFS/easySFS.py -i EM2017.vcf -p $workdir/05_stairway_2017/sfs_EM2017.txt -a -f --proj 144

# 2019 time frame
cd $workdir/06_stairway_2019
grep -v "#" EM2019.vcf | wc -l		
# 91969 variant sites, 22609259 invariant sites from sumstats summary file

# estimate the SFS
~/easySFS/easySFS.py -i EM2019.vcf -p $workdir/06_stairway_2019/sfs_EM2019.txt -a -f --proj 132

########################################
######## manually make the blueprint files for Stairway
########################################


########################################
######## build scripts for Stairway
########################################

# build scripts for stairway
java -cp stairway_plot_es Stairbuilder EM2000.blueprint

java -cp stairway_plot_es Stairbuilder EM2017.blueprint

java -cp stairway_plot_es Stairbuilder EM2019.blueprint

# modify the scripts so they can be submitted to the cluster
# add the following bits, then submit
#!/bin/bash
#SBATCH --chdir=./
#SBATCH --job-name=stairway
#SBATCH --partition quanah
#SBATCH --nodes=1 --ntasks=2
#SBATCH --time=48:00:00
#SBATCH --mem-per-cpu=8G






