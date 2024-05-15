# run with up to three migration edges:
src/treemix -i input/bighorn.treemix.gz -root Outgroup -o output/bighorn.treemix
src/treemix -i input/bighorn.treemix.gz -m 1 -g output/bighorn.treemix.vertices.gz output/bighorn.treemix.edges.gz -o output/bighorn_m1.treemix
src/treemix -i input/bighorn.treemix.gz -m 1 -g output/bighorn_m1.treemix.vertices.gz output/bighorn_m1.treemix.edges.gz -o output/bighorn_m2.treemix
src/treemix -i input/bighorn.treemix.gz -m 1 -g output/bighorn_m2.treemix.vertices.gz output/bighorn_m2.treemix.edges.gz -o output/bighorn_m3.treemix
src/treemix -i input/bighorn.treemix.gz -m 1 -g output/bighorn_m3.treemix.vertices.gz output/bighorn_m3.treemix.edges.gz -o output/bighorn_m4.treemix
src/treemix -i input/bighorn.treemix.gz -m 1 -g output/bighorn_m4.treemix.vertices.gz output/bighorn_m4.treemix.edges.gz -o output/bighorn_m5.treemix


#bootstraps over 200s snps with migration edges
for i in {1..100}; do
    src/treemix -i input/bighorn.treemix.gz -m 1 -g output/bighorn_m2.treemix.vertices.gz output/bighorn_m2.treemix.edges.gz -bootstrap \
    -k 20 -o output/$i.treemix
done;

# unzip the tree files
for i in { ls *treeout.gz }; do
    gzip -d $i
done;

# in R:
#summarize bootstraps
x <- list.files(pattern="*treeout")
for(a in 1:length(x)) {
if (a==1) {
output <- scan(x[a], what="character")[1]
} else {
output <- c(output, scan(x[a], what="character")[1])
}
}
write(output, file="bighorn_bootstraps.trees", ncolumns=1)

# in bash
# summarize bootstraps
sumtrees.py --output=bighorn_bootstraps.tre --min-clade-freq=0.05 bighorn_bootstraps.trees
