#!/bin/bash

# ENCODE annotation contains annotated putative regulatory regions of the human genome

## 1. creating a working folder
mkdir -p /home/avasileva/project/genome_ann/encode
cd /home/avasileva/project/genome_ann/encode

## 2. downloading
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

## 3 sorting 
bedtools sort -i ENCFF420VPZ_all.bed > ENCFF420VPZ_all_sorted.bed

# file beginning
cat ENCFF420VPZ_all_sorted.bed | head

## 4 remove unneeded files
rm -f ENCFF420VPZ_all.bed 

## 7 readme
touch readme.txt
printf "This Readme.txt contains description of files in  /home/avasileva/project/genome_ann/encode folder \n \
ENCFF420VPZ_all_sorted.bed - original ENCODE db v.4 annotation for hg38 (sorted) (source https://www.encodeproject.org/annotations/ENCSR800VNX/)\n" > readme.txt
