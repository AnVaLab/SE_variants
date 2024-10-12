#!/bin/bash

mkdir ~/project/variants/vcf_1000_genomes_filtered

cd ~/project/variants/vcf_1000_genomes/
vcf_files=(*)
echo ${vcf_files[@]}

# intersecting vcf and bed files
# leaving only mutations in SE enhancer elements (taken from ENCODE)
for i in "${vcf_files[@]}"; \
do \
~/programs/bedtools2/bin/bedtools intersect -wa -wb \
-a ~/project/variants/vcf_1000_genomes/$i \
-b ~/project/enhancers_refined_se_e.bed > \
~/project/variants/vcf_1000_genomes_filtered/vcf_1000_genomes_filtered_se/${i%.vcf*}_filtered_se.vcf; \
done;
