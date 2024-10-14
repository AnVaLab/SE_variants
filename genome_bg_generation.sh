#!/bin/bash

## 1. creating a working folder
mkdir -p /home/avasileva/project/genome_ann/bg
cd /home/avasileva/project/genome_ann/bg

## 2. finding compliment 
bedops --complement /home/avasileva/project/genome_ann/merged/hg38_encode_sea_ann_merged.bed > bg_all.bed

## 3. chopping compliment to pieces with length equal to average typical enhancer length
bedops --chop 268 --stagger 468 -x bg_all.bed > bg_all_chopped.bed

## 4. sub-sampling (making bg sample size equal to typical enhancer sample size)
# checking number of sample elements for TE and bg

# number of elements
cat bg_all.bed | wc -l
# 254457

# TE sample size
cat /home/avasileva/project/monocytes/enhancers/e.bed | wc -l
# 101634

# select 101634 lines (make sample size equal to the one of enhancers)
shuf -n 101634  bg_all_chopped.bed >  bg_sampled.bed

## 5. unifying bed file (so it all fields are the same as in other annotation files) 
awk -v OFS="\t" \
'{print $0 ".\t.\t.\t.\t.\t.\t.\t.\t.\t.\t.\t.\t.\t.\t.\t.\t.\t.\t.\t.\t.\t.\t.\t.\t.\t.\t.\t" "bg"}' bg_sampled.bed > \
bg_sampled_all_fields.bed
