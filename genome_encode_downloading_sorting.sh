#!/bin/bash

# ENCODE annotation contains annotated putative regulatory regions of the human genome

## 1. downloading
# creating a working folder
mkdir -p /home/avasileva/project/genome_ann/raw
cd /home/avasileva/project/genome_ann/raw

# downloading annotated putative regulatory elements in human genome from ENCODE
wget https://www.encodeproject.org/files/ENCFF420VPZ/@@download/ENCFF420VPZ.bed.gz
gzip -d ENCFF420VPZ.bed.gz
# renaming file
mv ENCFF420VPZ.bed ENCFF420VPZ_all.bed

# exploring downloaded files
awk '{type[$NF]++} END{for (t in type) {print t, type[t]}}' ENCFF420VPZ_all.bed 
#PLS 47532
#CA-H3K4me3 79246
#CA-TF 26102
#CA 245985
#pELS 249464
#dELS 1469205
#CA-CTCF 126034
#TF 105286

## 2. sorting 
# creating a working folder
mkdir -p /home/avasileva/project/genome_ann/sorted
cd /home/avasileva/project/genome_ann/sorted

# sorting
bedtools sort -i ENCFF420VPZ_all.bed > ENCFF420VPZ_all_sorted.bed
