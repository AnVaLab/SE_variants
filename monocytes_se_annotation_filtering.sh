#!/bin/bash

## 1. crearing a working folder
mkdir -p /home/avasileva/project/monocytes/se
cd  /home/avasileva/project/monocytes/se

## 2. filtering SE only for CD14-positive_monocyte
awk -F"\t" '$7=="CD14-positive_monocyte" {print $0}' /home/avasileva/project/genome_ann/sea/SE_only_SEA00101_sorted.bed > se.bed
