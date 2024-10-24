#!/bin/bash

#!/bin/bash

# разбить общую аннотацию на куски по 10 нуклеотидов
bedops --chop 10 /home/avasileva/project/genome_ann/bg/bg_sampled.bed > /home/avasileva/project/genome_ann/bg/bg_sampled_chopped.bed;
bedops --chop 10 /home/avasileva/project/monocytes/se/se_e_filtered.bed > /home/avasileva/project/monocytes/se/se_e_filtered_chopped.bed;
bedops --chop 10  /home/avasileva/project/monocytes/enhancers/te.bed >  /home/avasileva/project/monocytes/enhancers/te_chopped.bed

# counting number of variants per 10 np
mkdir -p /home/avasileva/project/variants/variant_distribution/bg
cd /home/avasileva/project/variants/vcf_1000_genomes_filtered_no_no_ref_fields_header
ls *.vcf |
parallel -j 100 "\
bedtools intersect \
-a /home/avasileva/project/genome_ann/bg/bg_sampled_chopped.bed \
-b {} \
-c > /home/avasileva/project/variants/variant_distribution/bg{}
"

mkdir mkdir -p /home/avasileva/project/variants/variant_distribution/se_e
ls *.vcf |
parallel -j 100 "\
bedtools intersect \
-a  /home/avasileva/project/monocytes/se/se_e_filtered_chopped.bed \
-b {} \
-c > /home/avasileva/project/variants/variant_distribution/se_e{}
"

mkdir mkdir -p /home/avasileva/project/variants/variant_distribution/te
ls *.vcf |
parallel -j 100 "\
bedtools intersect \
-a   /home/avasileva/project/monocytes/enhancers/te_chopped.bed \
-b {} \
-c > /home/avasileva/project/variants/variant_distribution/se_e{}
"



найти корреляцию спирмана по пациетам

