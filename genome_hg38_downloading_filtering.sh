#!/bin/bash

### 1. downloading hg38 genome annotation
# creating a working folder
mkdir -p /home/avasileva/project/genome_ann/hg38
cd /home/avasileva/project/genome_ann/hg38

# downloading
wget https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_21/gencode.v21.annotation.gtf.gz
gzip -d gencode.v21.annotation.gtf.gz 

### 2. processing
## 2.1 converting gtf annotation to bed format
gtf2bed < gencode.v21.annotation.gtf > gencode.v21.annotation.bed

# exploring genome annotation
awk '{type[$8]++} END{for(t in type) print t, type[t]}' gencode.v21.annotation.bed
#exon 1162114
#CDS 696929
#UTR 275100
#gene 60155
#start_codon 81862
#Selenocysteine 114
#stop_codon 73993
#transcript 196327

## 2.2 filtering
# filtering genome annotaion, leaving only gene records
awk '{if ($8=="gene") {print $0}}' gencode.v21.annotation.bed > genecode.v21.annotation.genes.bed

## 2.3 sorting 
bedtools sort -i genecode.v21.annotation.genes.bed > genecode.v21.annotation.genes_sorted.bed
