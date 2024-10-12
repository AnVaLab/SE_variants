#!/bin/bash

## crearing a working folder
mkdir ~/project/enhancers
cd  ~/project/enhancers

### downloading bed files with
# putative regulatory elements in monocytes (not annotated, instead "High H3K27ac/Low H3K27ac)
wget https://www.encodeproject.org/files/ENCFF900YFA/@@download/ENCFF900YFA.bed.gz
gzip -d ENCFF900YFA.bed.gz
mv ENCFF900YFA.bed ENCFF900YFA_monocytes.bed

# annotated putative regulatory elements in human genome
wget https://www.encodeproject.org/files/ENCFF420VPZ/@@download/ENCFF420VPZ.bed.gz
gzip -d ENCFF420VPZ.bed.gz
mv ENCFF420VPZ.bed ENCFF420VPZ_all.bed

## filtration
# filtering out unclassified regulatory elements
awk -F"\t" '$10!="Unclassified" {print $0}' ENCFF900YFA_monocytes.bed > ENCFF900YFA_monocytes_classified.bed

# filtering out non-enhancers
# checking if elements in ENCFF900YFA.bed.gz and ENCFF420VPZ.bed.gz overlap exactly
# number of regulatory elements in ENCFF900YFA_classified.bed file
cat ENCFF900YFA_monocytes_classified.bed | wc -l
# 149692

bedops -e 100% ENCFF420VPZ_all.bed ENCFF900YFA_monocytes_classified.bed | wc -l
# 149692

# yes, all elements from file for monocytes exist in file for genome

# leaving only enhancers
bedops -e 100% ENCFF420VPZ_all.bed ENCFF900YFA_monocytes_classified.bed | grep -E "dELS|pELS" > te_monocytes.bed
