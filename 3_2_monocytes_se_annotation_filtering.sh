#!/bin/bash

## 1. crearing a working folder
mkdir -p /home/avasileva/project/monocytes/se
cd  /home/avasileva/project/monocytes/se

## 2. filtering SE only for CD14-positive_monocyte
grep "CD14-positive_monocyte" /home/avasileva/project/genome_ann/sea/SE_only_SEA00101_sorted.bed > se.bed

# investigating the file
cat se.bed | wc -l
# 1168

# Readme file
touch readme.txt
printf "This Readme.txt contains description of files in /home/avasileva/project/monocytes/se folder \n \
se.bed - file containing SE coordinates for monocyte cell type (achieved by SEA filtration)\n" > readme.txt
