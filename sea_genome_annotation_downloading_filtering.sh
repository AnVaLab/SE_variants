#!/bin/bash

# creating a working folder
mkdir -p /home/avasileva/project/genome_ann
cd /home/avasileva/project/genome_ann

# in SEA SE for all cell lines and tissues for human are gathered in a single bed file
wget http://218.8.241.248:8080/SEA3/download/SEA00101.bed

# removing first column containing record serial number
cut -f2- SEA00101.bed > SEA00101_no_record_numb.bed

# filtering records by the regulatory element type, saving SE to a separate file
awk -F”\t” '{if ($(NF-1)=="SE") print $0}' SEA00101_no_record_numb.bed > SE_only_SEA00101.bed