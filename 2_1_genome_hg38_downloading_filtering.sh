#!/bin/bash

## 1. creating a working folder
mkdir -p /home/avasileva/project/genome_ann/hg38
cd /home/avasileva/project/genome_ann/hg38

## 2. downloading hg38 genome annotation
wget https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_21/gencode.v21.annotation.gtf.gz
gzip -d gencode.v21.annotation.gtf.gz 

## 3. converting gtf annotation to bed format
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

## 4 filtering
# filtering genome annotaion, leaving only gene records
awk '{if ($8=="gene") {print $0}}' gencode.v21.annotation.bed > genecode.v21.annotation.genes.bed

## 5 sorting 
bedtools sort -i genecode.v21.annotation.genes.bed > genecode.v21.annotation.genes_sorted.bed

## 6 removing unneeded files
rm -f gencode.v21.annotation.bed genecode.v21.annotation.genes.bed



