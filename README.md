# bighorn_elephant

Steps to analyze a bighorn sheep RAD-seq dataset for assessing the diversity and origins of the population on Elephant Mountain. Steps here start with a VCF output from STACKS.

1. Further process and filter the VCF for various analyses and run PCA analyses.
2. Run RAxML for phylogenetic relationships.
3. Prepare SFS for Stairway analyses.
4. Calculate kinship among all Elephant Mountain individuals.
5. Plot the kinship values.
6. Calculate genetic diversity and missingness from the VCF.
7. Plot PCA.
8. Plot Stairway results.
9. Calculate current population sizes.
10. Revisions round 1: Calculate Fst, redo PCA analyses, run ADMIXTURE and ABBA/BABA stats, and run TreeMix.
11. Revisions round 2: Run 100 replicates of ADMIXTURE where we subsample 5 individuals per replicate from Elephant Mountain (to keep sample sizes similar in all populations while testing for different effects when including different individuals).

All other files (not numbered) are helper or mapping files used in various analysis steps.

