#!/bin/bash

# creating a working folder
mkdir /home/avasileva/project/genome_ann
cd /home/avasileva/project/genome_ann

# downloading annotated putative regulatory elements in human genome from ENCODE
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

# downloading hg38 annotation of human genome
wget https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_21/gencode.v21.annotation.gtf.gz
gzip -d gencode.v21.annotation.gtf.gz 

# convert gtf annotation to bed format
/home/avasileva/programs/bin/gtf2bed < gencode.v21.annotation.gtf > gencode.v21.annotation.bed

# filtering annotation
awk '{type[$8]++} END{for(t in type) print t, type[t]}' gencode.v21.annotation.bed

exon 1162114
CDS 696929
UTR 275100
gene 60155
start_codon 81862
Selenocysteine 114
stop_codon 73993
transcript 196327

# leaving only gene records
# gene coordinates include other elements (exons, CDS, UTR etc)
awk '{if ($8=="gene") {print $0}}' gencode.v21.annotation.bed > genecode.v21.annotation.genes.bed
