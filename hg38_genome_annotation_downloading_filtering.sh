#!/bin/bash

# downloading hg38 genome annotation
wget https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_21/gencode.v21.annotation.gtf.gz
gzip -d gencode.v21.annotation.gtf.gz 

# convert gtf annotation to bed format
/home/avasileva/programs/bin/gtf2bed < gencode.v21.annotation.gtf > gencode.v21.annotation.bed

# exploring genome annotation
awk '{type[$8]++} END{for(t in type) print t, type[t]}' gencode.v21.annotation.bed

exon 1162114
CDS 696929
UTR 275100
gene 60155
start_codon 81862
Selenocysteine 114
stop_codon 73993
transcript 196327

# filtering genome annotaion
# leaving only gene records
awk '{if ($8=="gene") {print $0}}' gencode.v21.annotation.bed > genecode.v21.annotation.genes.bed

# merging genome annotation and encode annotation
bedops --merge /home/avasileva/project/enhancers/all_regulatory/ENCFF420VPZ.bed /home/avasileva/project/hg38/genecode.v21.annotation.genes.bed > reg_elem_gene_ann_merged.bed
