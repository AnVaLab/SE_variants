#!/bin/bash

# разбить общую аннотацию на куски по 10 нуклеотидов
bedops --chop 10 /home/avasileva/project/genome_ann/bg/bg_sampled.bed > /home/avasileva/project/genome_ann/bg/bg_sampled_chopped.bed;
bedops --chop 10 /home/avasileva/project/monocytes/se/se_e_filtered.bed > /home/avasileva/project/monocytes/se/se_e_filtered_chopped.bed;
bedops --chop 10  /home/avasileva/project/monocytes/enhancers/te.bed >  /home/avasileva/project/monocytes/enhancers/te_chopped.bed

# Сounting number of variants per chopped region
mkdir -p /home/avasileva/project/variants/variant_distribution/
cd /home/avasileva/project/variants/vcf_1000_genomes_filtered_no_no_ref_fields_header
ls *.vcf |
parallel -j 100 --plus "\
mkdir -p /home/avasileva/project/variants/variant_distribution/{.}
bedtools intersect \
-a /home/avasileva/project/genome_ann/bg/bg_sampled_chopped.bed \
-b {} \
-c > /home/avasileva/project/variants/variant_distribution/{.}/bg_{.}.bed
"

ls *.vcf |
parallel -j 100 --plus "\
mkdir -p /home/avasileva/project/variants/variant_distribution/{.}
bedtools intersect \
-a  /home/avasileva/project/monocytes/se/se_e_filtered_chopped.bed \
-b {} \
-c > /home/avasileva/project/variants/variant_distribution/{.}/se_e_{.}.bed
"

ls *.vcf |
parallel -j 100 --plus "\
mkdir -p /home/avasileva/project/variants/variant_distribution/{.}
bedtools intersect \
-a   /home/avasileva/project/monocytes/enhancers/te_chopped.bed \
-b {} \
-c > /home/avasileva/project/variants/variant_distribution/{.}/te_e_{.}.bed
"

# transferring files from server to a local pc
scp -i '/home/anastasia/Downloads/avasileva.txt' \
-r avasileva@51.250.11.65:~/project/variants/variant_distribution/ '/home/anastasia/Documents/SE'
