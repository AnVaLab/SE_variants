#!/bin/bash

# finding compliment 
bedops --complement /home/avasileva/project/combined_annotation/reg_elem_gene_ann_se_merged.bed > bg_all.bed

# number of elements
cat bg_all.bed | wc -l
254457

# making sample size equal to enhancer sample size
cat e.bed | wc -l
101634

# chopping compliment to pieces with length equal to average enhancer length
bedops --chop 268 --stagger 468 -x bg_all.bed > bg_chopped.bed

# select 101634 lines (make sample size equal to the one of enhancers)
shuf -n 101634  bg_chopped.bed >  bg_chopped_sampled.bed

# add file to annotation
# add extra columns
awk -v OFS="\t" '{print $0 ".\t.\t.\t.\t.\t.\t.\t.\t.\t.\t.\t.\t.\t.\t.\t.\t.\t.\t.\t.\t.\t.\t.\t.\t.\t.\t.\t" "bg"}' bg_chopped_sampled.bed > bg_chopped_sampled_all_fields.bed
