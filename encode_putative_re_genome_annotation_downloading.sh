#!/bin/bash

# creating a working folder
mkdir /home/avasileva/project/genome_ann
cd /home/avasileva/project/genome_ann

# downloading annotated putative regulatory elements in human genome from ENCODE
wget https://www.encodeproject.org/files/ENCFF420VPZ/@@download/ENCFF420VPZ.bed.gz
gzip -d ENCFF420VPZ.bed.gz
# renaming file
mv ENCFF420VPZ.bed ENCFF420VPZ_all.bed

# exploring downloaded files
awk '{type[$NF]++} END{for (t in type) {print t, type[t]}}' ENCFF420VPZ.bed 
#PLS 47532
#CA-H3K4me3 79246
#CA-TF 26102
#CA 245985
#pELS 249464
#dELS 1469205
#CA-CTCF 126034
#TF 105286
