#!/bin/bash

## 1. crearing a working folder
mkdir -p /home/avasileva/project/monocytes/enhancers
cd  /home/avasileva/project/monocytes/enhancers

## 2. downloading
# downloading ENCODE annotation of putative regulatory elements in monocytes (pre not annotated, instead "High H3K27ac/Low H3K27ac)
wget https://www.encodeproject.org/files/ENCFF900YFA/@@download/ENCFF900YFA.bed.gz
gzip -d ENCFF900YFA.bed.gz
mv ENCFF900YFA.bed ENCFF900YFA_monocytes.bed

## 2.1 sorting
bedtools sort -i ENCFF900YFA_monocytes.bed > ENCFF900YFA_monocytes_sorted.bed

## 2.2 filtering
# filtering out unclassified regulatory elements
awk -F"\t" '$10!="Unclassified" {print $0}' ENCFF900YFA_monocytes_sorted.bed > ENCFF900YFA_monocytes_sorted_classified.bed

# leaving only enhancers (filtering out non-enhancers)
# ENCFF900YFA.bed contains PRE without annotation, and therefore, aside from enhancers, it can include promoters, TE binding sites etc.
# to leave only enhancers, we will use ENCFF420VPZ_all.bed file containing annotated PRE of all human genome (where each PRE has a tag: dELS, pELS, CTCF etc)

# checking if ENCFF420VPZ_all.bed (annotation of all putative regulatory elements of human genome) contains PRE of ENCFF900YFA.bed (PRE in monocytes)
# number of regulatory elements in ENCFF900YFA_classified.bed file
cat ENCFF900YFA_monocytes_sorted_classified.bed | wc -l
# 149692
bedops -e 100% /home/avasileva/project/genome_ann/encode/ENCFF420VPZ_all_sorted.bed ENCFF900YFA_monocytes_sorted_classified.bed | wc -l
# 149692
# yes, all elements from file for monocytes exist in file for genome

# leaving only distal and proximal enhancer like sites
bedops -e 100% \
/home/avasileva/project/genome_ann/encode/ENCFF420VPZ_all_sorted.bed \
ENCFF900YFA_monocytes_sorted_classified.bed | \
grep -E "dELS|pELS" > \
e.bed
# the output file is sorted

# Removing unneeded files
rm -f ENCFF900YFA_monocytes.bed ENCFF900YFA_monocytes_sorted_classified.bed
