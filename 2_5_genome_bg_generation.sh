#!/bin/bash

# Generating background sequences. 

## 1. creating a working folder
mkdir -p /home/avasileva/project/genome_ann/bg
cd /home/avasileva/project/genome_ann/bg

## 2. finding compliment 
bedops --complement /home/avasileva/project/genome_ann/merged/hg38_encode_sea_ann_merged.bed > bg_all.bed

## 3. chopping compliment to pieces with length equal to average typical enhancer length
bedops --chop 268 --stagger 468 -x bg_all.bed > bg_all_chopped.bed

# Removing unneeded files
rm -f bg_all.bed
