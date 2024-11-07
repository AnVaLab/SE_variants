#!/bin/bash

# SEA db bed file contains information on SE and E in a number of cell lines, found based on H3K27ac signal

## 1. creating a working folder
mkdir -p /home/avasileva/project/genome_ann/sea
cd /home/avasileva/project/genome_ann/sea

## 2. downloading
# in SEA SE for all cell lines and tissues for human are gathered in a single bed file
wget http://218.8.241.248:8080/SEA3/download/SEA00101.bed

## 3. removing first column containing record serial number
cut -f2- SEA00101.bed > SEA00101_no_record_numb.bed

## 4 filtering 
# filtering records by the regulatory element type, saving SE to a separate file
awk -F"\t" '{if ($(NF-1)=="SE") print $0}' SEA00101_no_record_numb.bed > SE_only_SEA00101.bed
# SEA only provides infortmation on start and end coordinates of SEs and does not provide infortmation on SE elements 

# filtering records by the regulatory element type, saving E to a separate file
awk -F"\t" '{if ($(NF-1)=="E") print $0}' SEA00101_no_record_numb.bed > TE_only_SEA00101.bed
# this file further will be used only to compare it with ENCODE elements to veriry E coordinates

## 5 sorting
bedtools sort -i SEA00101_no_record_numb.bed > SEA00101_sorted.bed
bedtools sort -i SE_only_SEA00101.bed > SE_only_SEA00101_sorted.bed
bedtools sort -i TE_only_SEA00101.bed > TE_only_SEA00101_sorted.bed

## 6 remove unneeded files
rm -f SEA00101.bed SEA00101_no_record_numb.bed SE_only_SEA00101.bed TE_only_SEA00101.bed

## 7 readme
touch readme.txt
printf "This Readme.txt contains description of files in  /home/avasileva/project/genome_ann/sea folder \n \
SEA00101_sorted.bed - original SEA db annotation for SE and enhancers in a range cell lines and tissues. 1st column was removed to fit standart .bed file format \n \
SE_only_SEA00101_sorted.bed - SEA db annotation for SE only in a range cell lines and tissues; \n \
TE_only_SEA00101_sorted.bed  - SEA db annotation for TE only in a range cell lines and tissues \n" > readme.txt
