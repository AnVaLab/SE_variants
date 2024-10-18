#!/bin/bash

mkdir -p ~/project/variants/vcf_1000_genomes_filtered
cd ~/project/variants/vcf_1000_genomes_filtered/

ls *.vcf.gz | \
parallel -j 7 '\
bedtools intersect -wa -wb \
-a ~/project/variants/vcf_1000_genomes/{} \
-b /home/avasileva/project/monocytes/combined_annotation/combined_annotation.bed > \
~/project/variants/vcf_1000_genomes_filtered/filtered_{}'

# removing lines with <ref only>
ls *.vcf |
parallel -j 7 "\
grep -ivP '\t<NON_REF>\t' {} > {}.temp; \
mv {}.tmp {}
"


mkdir -p ~/project/variants/vcf_1000_genomes_filtered/vcf_1000_genomes_filtered_header
cd ~/project/variants/vcf_1000_genomes_filtered/

# appending headers
ls *.vcf |  parallel -j 8 --plus "\
zcat ~/project/variants/vcf_1000_genomes/{#filtered_}.gz | \
awk '{if (\$0~/^#/) {print} else exit}' |
cat - ~/project/variants/vcf_1000_genomes_filtered/{}
> \
~/project/variants/vcf_1000_genomes_filtered_header/"vcf_1000_genomes_filtered_header/header_{}'
"




ls *.vcf | 
parallel -j 4 --plus "\
zcat ~/project/variants/vcf_1000_genomes/{#filtered_}.gz | \
awk '$0~/^#/ {print}'" |\
cat - ~/project/variants/vcf_1000_genomes_filtered/{}
> \
~/project/variants/vcf_1000_genomes_filtered/"vcf_1000_genomes_filtered_header/header_{}'






# intersecting vcf and bed files
# leaving only mutations in SE enhancer elements (taken from ENCODE)
for i in "${vcf_files[@]}"; \
do \
~/programs/bedtools2/bin/bedtools intersect -wa -wb \
-a ~/project/variants/vcf_1000_genomes/$i \
-b /home/avasileva/project/monocytes/combined_annotation/combined_annotation.bed > \
~/project/variants/vcf_1000_genomes_filtered/${i%.vcf*}_filtered.vcf; \
done;
