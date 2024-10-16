#!/bin/bash

mkdir -p ~/project/variants/vcf_1000_genomes_filtered
cd ~/project/variants/vcf_1000_genomes/

ls *.vcf.gz | parallel -j 7 'bedtools intersect -wa -wb \
-a ~/project/variants/vcf_1000_genomes/{} \
-b /home/avasileva/project/monocytes/combined_annotation/combined_annotation.bed > \
~/project/variants/vcf_1000_genomes_filtered/filtered_{}'






# intersecting vcf and bed files
# leaving only mutations in SE enhancer elements (taken from ENCODE)
for i in "${vcf_files[@]}"; \
do \
~/programs/bedtools2/bin/bedtools intersect -wa -wb \
-a ~/project/variants/vcf_1000_genomes/$i \
-b /home/avasileva/project/monocytes/combined_annotation/combined_annotation.bed > \
~/project/variants/vcf_1000_genomes_filtered/${i%.vcf*}_filtered.vcf; \
done;
