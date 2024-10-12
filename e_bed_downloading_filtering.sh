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

### exploring downloaded files
# types of tags
awk '{type[$NF]++} END{for (t in type) {print t, type[t]}}' ENCFF420VPZ.bed 
#PLS 47532
#CA-H3K4me3 79246
#CA-TF 26102
#CA 245985
#pELS 249464
#dELS 1469205
#CA-CTCF 126034
#TF 105286

# checking if elements in ENCFF900YFA.bed.gz and ENCFF420VPZ.bed.gz overlap exactly
# number of regulatory elements in ENCFF900YFA_classified.bed file
cat ENCFF900YFA_monocytes.bed | wc -l
bedops -e 100% ENCFF420VPZ_all.bed ENCFF900YFA_monocytes.bed | wc -l
# yes, all elements from file for monocytes exist in file for genome


## filtration
# filtering out unclassified regulatory elements
awk -F"\t" '$10!="Unclassified" {print $0}' ENCFF900YFA_monocytes.bed > ENCFF900YFA_monocytes_classified.bed
# leaving only enhancers (filtering out non-enhancers)
bedops -e 100% ENCFF420VPZ_all.bed ENCFF900YFA_monocytes_classified.bed | grep -E "dELS|pELS" > te_monocytes.bed
