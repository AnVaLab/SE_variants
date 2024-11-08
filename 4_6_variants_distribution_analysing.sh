#!/bin/bash

## Preparing files for variants destribution analysis in SE enhancer elements, typical enhancers and negative control for each sample.
## For this, 3 files were generated for each element type, containing number of variants per 10 np (or less, considering flanking regions)

# 1. Chopping SE enhancer elements, typical enhancer and negative control elements into pieces of 10 np
# Warning! This can leave flanking regions of < 10 np, which should be considered in further analysis
bedops --chop 10 /home/avasileva/project/genome_ann/bg/bg_sampled.bed > /home/avasileva/project/genome_ann/bg/bg_sampled_chopped.bed;
bedops --chop 10 /home/avasileva/project/monocytes/se/se_e_filtered.bed > /home/avasileva/project/monocytes/se/se_e_filtered_chopped.bed;
bedops --chop 10  /home/avasileva/project/monocytes/enhancers/te.bed >  /home/avasileva/project/monocytes/enhancers/te_chopped.bed

# 2. Сounting number of variants per chopped region
mkdir -p /home/avasileva/project/variants/variant_distribution/
cd /home/avasileva/project/variants/vcf_1000_genomes_filtered_no_regulatory_elem_info_header

# 2.1 bg
ls *.vcf |
parallel -j 100 --plus "\
mkdir -p /home/avasileva/project/variants/variant_distribution/{.}
bedtools intersect \
-a /home/avasileva/project/genome_ann/bg/bg_sampled_chopped.bed \
-b {} \
-c > /home/avasileva/project/variants/variant_distribution/{.}/bg_{.}.bed
"

# 2.2 se_e
ls *.vcf |
parallel -j 100 --plus "\
mkdir -p /home/avasileva/project/variants/variant_distribution/{.}
bedtools intersect \
-a  /home/avasileva/project/monocytes/se/se_e_filtered_chopped.bed \
-b {} \
-c > /home/avasileva/project/variants/variant_distribution/{.}/se_e_{.}.bed
"

# 2.3 te
ls *.vcf |
parallel -j 100 --plus "\
mkdir -p /home/avasileva/project/variants/variant_distribution/{.}
bedtools intersect \
-a   /home/avasileva/project/monocytes/enhancers/te_chopped.bed \
-b {} \
-c > /home/avasileva/project/variants/variant_distribution/{.}/te_e_{.}.bed
"

# 3. transferring files from server to a local pc
scp -i '/home/anastasia/Downloads/avasileva.txt' \
-r avasileva@51.250.11.65:~/project/variants/variant_distribution/ '/home/anastasia/Documents/SE'

#======================================================================================================
### Alternative (not to consider flanking regions) - calculating the number of variants per enhancer element (in SE/TE/negative control)
### On 07.11.24 files in the directory generated this way.
#======================================================================================================
# bg
ls *.vcf |
parallel -j 100 --plus "\
mkdir -p /home/avasileva/project/variants/variant_distribution/{.}
bedtools intersect \
-a /home/avasileva/project/genome_ann/bg/bg_sampled.bed \
-b {} \
-c > /home/avasileva/project/variants/variant_distribution/{.}/bg_{.}.bed
"

# se_e
ls *.vcf |
parallel -j 100 --plus "\
mkdir -p /home/avasileva/project/variants/variant_distribution/{.}
bedtools intersect \
-a  /home/avasileva/project/monocytes/se/se_e_filtered.bed \
-b {} \
-c > /home/avasileva/project/variants/variant_distribution/{.}/se_e_{.}.bed
"

# te
ls *.vcf |
parallel -j 100 --plus "\
mkdir -p /home/avasileva/project/variants/variant_distribution/{.}
bedtools intersect \
-a   /home/avasileva/project/monocytes/enhancers/te.bed \
-b {} \
-c > /home/avasileva/project/variants/variant_distribution/{.}/te_e_{.}.bed
"

