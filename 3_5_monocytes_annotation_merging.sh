#!/bin/bash

## 1. entring working folder
cd /home/avasileva/project/monocytes/combined_annotation

## 4. unifying bed file (so it all fields are the same as in other annotation files) 
awk -v OFS="\t" \
'{print $0 "\t.\t.\t.\t.\t.\t.\t.\t.\t.\t.\t.\t.\t.\t.\t.\t.\t.\t.\t.\t.\t.\t.\t.\t.\t.\t.\t" "bg"}' /home/avasileva/project/genome_ann/bg/bg_all_chopped.bed > \
/home/avasileva/project/genome_ann/bg/bg_all_fields.bed

## 2. sub-sampling (making bg sample size equal to typical enhancer sample size)
# checking number of sample elements for TE and bg

# number of bg elements
cat /home/avasileva/project/genome_ann/bg/bg_all_fields.bed | wc -l
# 1222507

# TE sample size
te_sample_size="$(cat /home/avasileva/project/monocytes/enhancers/te.bed | wc -l)"
echo "${te_sample_size}"
# 101634

# select 101634 lines (make sample size equal to the one of enhancers)
shuf -n "${te_sample_size}"  /home/avasileva/project/genome_ann/bg/bg_all_fields.bed >  /home/avasileva/project/genome_ann/bg/bg_sampled.bed

## 3. combining annotations
cat /home/avasileva/project/genome_ann/bg/bg_sampled.bed > combined_annotation.bed
cat /home/avasileva/project/monocytes/se/enhancers/se_e_filtered.bed >> combined_annotation.bed
cat /home/avasileva/project/monocytes/se/spacers/se_spacers_annotated_sorted.bed >> combined_annotation.bed
cat /home/avasileva/project/monocytes/enhancers/te.bed >> combined_annotation.bed

## 4. sorting file
bedtools sort -i combined_annotation.bed > combined_annotation_sorted.bed

## 5. removing unneeded files
rm -f combined_annotation.bed

## 6. readme
touch readme.txt
printf "This Readme.txt contains description of files in /home/avasileva/project/monocytes/combined_annotation folder \n \
combined_annotation_sorted.bed - is a combined element annotation (final), containing records for typical enhancers, SE elements (enhancers and spacers) \n \
and negative control regions. " > readme.txt

# visualizing
scp -i '/home/anastasia/Downloads/avasileva.txt' avasileva@51.250.11.65:/home/avasileva/project/monocytes/combined_annotation/combined_annotation_sorted.bed /home/anastasia/Documents/SE;
