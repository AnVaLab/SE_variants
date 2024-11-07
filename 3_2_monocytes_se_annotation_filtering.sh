#!/bin/bash

## 1. crearing a working folder
mkdir -p /home/avasileva/project/monocytes/se
cd  /home/avasileva/project/monocytes/se

## 2. filtering SE only for CD14-positive_monocyte
grep "CD14-positive_monocyte" /home/avasileva/project/genome_ann/sea/SE_only_SEA00101_sorted.bed > se.bed

# investigating the file
cat se.bed | wc -l
# 1168
