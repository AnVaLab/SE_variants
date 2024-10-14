#!/bin/bash

## 1. entring working folder
cd /home/avasileva/project/monocytes/combined_annotation

## 2. sub-sampling (making bg sample size equal to typical enhancer sample size)
# checking number of sample elements for TE and bg

# number of bg elements
cat /home/avasileva/project/genome_ann/bg/bg_all_fields.bed | wc -l
# 254457

# TE sample size
te_sample_size="$(cat /home/avasileva/project/monocytes/enhancers/te.bed | wc -l)"
echo "${te_sample_size}"

# select 101634 lines (make sample size equal to the one of enhancers)
shuf -n "${te_sample_size}"  /home/avasileva/project/genome_ann/bg/bg_all_fields.bed >  /home/avasileva/project/genome_ann/bg/bg_sampled.bed

## 3. combining annotations
cat /home/avasileva/project/genome_ann/bg/bg_sampled.bed > combined_annotation.bed
cat /home/avasileva/project/monocytes/se/se_e_filtered.bed >> combined_annotation.bed
cat /home/avasileva/project/monocytes/se/se_spacers.bed >> combined_annotation.bed ####### этого файла сейчас нет!!!!!
cat /home/avasileva/project/monocytes/enhancers/te.bed >> combined_annotation.bed

# где унифицируются поля????????????????????????????????????

## 4. sorting file
bedtools sort -i combined_annotation.bed > combined_annotation_sorted.bed

# visualizing
# scp -i '/home/anastasia/Downloads/avasileva.txt' avasileva@51.250.11.65:/home/avasileva/project/hg38/gencode.v21.annotation.bed /home/anastasia/Documents/SE;
