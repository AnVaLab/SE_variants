#!/bin/bash

#!/bin/bash

# разбить общую аннотацию на куски по 10 нуклеотидов
bedops --chop 10 /home/avasileva/project/genome_ann/bg/bg_sampled.bed > /home/avasileva/project/genome_ann/bg/bg_sampled_chopped.bed;
bedops --chop 10 /home/avasileva/project/monocytes/se/se_e_filtered.bed > /home/avasileva/project/monocytes/se/se_e_filtered_chopped.bed;
bedops --chop 10  /home/avasileva/project/monocytes/enhancers/te.bed >  /home/avasileva/project/monocytes/enhancers/te_chopped.bed


ls *.vcf.gz |
parallel -j 100 "\
mv {} {.}
"

mkdir -p /home/avasileva/project/variant/variant_distribution
cd vcf_1000_genomes_filtered_no_no_ref_fields
ls *.vcf.gz |
parallel -j 100 "\
bedtools intersect \
-a /home/avasileva/project/genome_ann/bg/bg_sampled_chopped.bed \
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

 


потом использовать комманду интерсект

найти корреляцию спирмана по пациетам





$ bedtools intersect -a A.bed -b B.bed -c
