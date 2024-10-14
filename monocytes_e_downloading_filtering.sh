#!/bin/bash

### 1. downloading
# crearing a working folder
mkdir -p /home/avasileva/project/monocytes/enhancers
cd  /home/avasileva/project/monocytes/enhancers

# downloading ENCODE annotation of putative regulatory elements in monocytes (pre not annotated, instead "High H3K27ac/Low H3K27ac)
wget https://www.encodeproject.org/files/ENCFF900YFA/@@download/ENCFF900YFA.bed.gz
gzip -d ENCFF900YFA.bed.gz
mv ENCFF900YFA.bed ENCFF900YFA_monocytes.bed

### 2. processing
## 2.1 sorting


## 2.2 filtering
# filtering out unclassified regulatory elements
awk -F"\t" '$10!="Unclassified" {print $0}' ENCFF900YFA_monocytes.bed > ENCFF900YFA_monocytes_classified.bed

# leaving only enhancers (filtering out non-enhancers)
# ENCFF900YFA.bed contains PRE without annotation, and therefore, aside from enhancers, it can include promoters, TE binding sites etc.
# to leave only enhancers, we will use ENCFF420VPZ_all.bed file containing annotated PRE of all human genome (where each PRE has a tag: dELS, pELS, CTCF etc)

# checking if ENCFF420VPZ_all.bed (annotation of all putative regulatory elements of human genome) contains PRE of ENCFF900YFA.bed (PRE in monocytes)
# number of regulatory elements in ENCFF900YFA_classified.bed file
cat ENCFF900YFA_monocytes.bed | wc -l
bedops -e 100% /home/avasileva/project/genome_ann/ENCFF420VPZ_all.bed ENCFF900YFA_monocytes.bed | wc -l
# yes, all elements from file for monocytes exist in file for genome

# leaving only distal and proximal enhancer like sites
bedops -e 100% /home/avasileva/project/genome_ann/ENCFF420VPZ_all.bed ENCFF900YFA_monocytes_classified.bed | grep -E "dELS|pELS" > e_monocytes.bed
