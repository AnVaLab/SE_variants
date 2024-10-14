#!/bin/bash

## 1. creating a working folder
mkdir -p /home/avasileva/project/combined_annotation
cd /home/avasileva/project/combined_annotation

## 2. intersecting encode and sea annotations to determine SE enhancer elements
bedtools intersect \
-loj \
-a /home/avasileva/project/monocytes/enhancers/e_monocytes.bed \

# исправить на нужный файл
-b /home/avasileva/project/monocytes/SE_only_cd14plus_monocyte_norownumb_SEA00101.bed > \
enhancers_refined_se_e.bed 

# this will leave information about SE enhancer elements and typical enhancers

# разделяем энхансеры и СЭ в разные файлы, чтобы с ними было проще работать, по отдельности
awk '$(NF-1)=="SE" {print $0}' /home/avasileva/project/combined_annotation/enhancers_refined_se_e.bed > /home/avasileva/project/se/se_e_elements.bed;
awk '$(NF-1)!="SE" {print $0}' /home/avasileva/project/combined_annotation/enhancers_refined_se_e.bed > /home/avasileva/project/enhancers/te_only.bed;
