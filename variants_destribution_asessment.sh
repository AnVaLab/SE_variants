#!/bin/bash

mkdir -p /home/avasileva/project/variant/variant_distribution
ls *.vcf |
parallel -j 50 "\
bedtools intersect \
-a /home/avasileva/project/genome_ann/bg/bg_sampled.bed \
-b {} \
-c > /home/avasileva/project/variant/variant_distribution/{}
"

bedtools intersect \
-a /home/avasileva/project/genome_ann/bg/bg_sampled.bed \
-b {} \
-c > /home/avasileva/project/variant/variant_distribution/{}


 /home/avasileva/project/genome_ann/bg/bg_sampled.bed
 /home/avasileva/project/monocytes/se/se_e_filtered.bed
 /home/avasileva/project/monocytes/enhancers/te.bed
