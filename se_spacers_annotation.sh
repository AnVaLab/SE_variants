#!/bin/bash

# sort file
~/programs/bedtools2/bin/bedtools sort -i /home/avasileva/project/combined_annotation/se_spacers.bed > /home/avasileva/project/combined_annotation/se_spacers_sorted.bed

bedtools  intersect  -b /home/avasileva/project/combined_annotation/se_spacers_sorted.bed -a /home/avasileva/project/hg38/genecode.v21.annotation.genes_sorted.bed > intersected_ann_spacers.bed

# intersecting spacers with regulatory regions
bedtools  intersect  -b /home/avasileva/project/combined_annotation/se_spacers_sorted.bed -a /home/avasileva/project/enhancers/all_regulatory/ENCFF420VPZ.bed > intersected_reg_spacers.bed

### add info about rest of spacers
### combine files
