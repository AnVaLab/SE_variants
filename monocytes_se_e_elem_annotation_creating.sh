#!/bin/bash

## 1. creating a working folder
mkdir -p /home/avasileva/project/monocytes/combined_annotation
cd /home/avasileva/project/monocytes/combined_annotation

## 2. intersecting encode and sea annotations to determine SE enhancer elements
bedtools intersect \
-loj \
-a /home/avasileva/project/monocytes/enhancers/e.bed \
-b /home/avasileva/project/monocytes/se/se.bed > \
te_se_e.bed 
# this file contains information about SE enhancer elements and typical enhancers

## 3. splitting information on TE and SE E elements into separate files
awk '$(NF-1)=="SE" {print $0}' te_se_e.bed > /home/avasileva/project/monocytes/se/se_e.bed;
awk '$(NF-1)!="SE" {print $0}' te_se_e.bed > /home/avasileva/project/monocytes/enhancers/te.bed;
