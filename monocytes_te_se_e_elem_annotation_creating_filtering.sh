#!/bin/bash

# Enhancer elements in SE were defined by intersecting SEA and ENCODE. 

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

# Since enhancer coordinated differ in SEA and ENCODE inconcistencies were witnessed: in some SE start/end coordinates did not overlap enhancers,
# some SE concist only out of 1 ENCODE enhancer, which contradicts SE definition. We decided to exclude those SE.

## 4. creating working folder
mkdir -p /home/avasileva/project/monocytes/se
cd  /home/avasileva/project/monocytes/se

## 5. counting number of enhancers in each SE
# finding field number containing SE ids (they start with hg38)
string="hg38"
se_id_field="$(awk -v b="$string" '{for (i=1; i<=NF; i++) { if ($i ~ b) { print i; exit } }}' se_e.bed)"
echo "$se_id_field"
# 14
awk -F"\t" -v se_id_field="$se_id_field" '{print $se_id_field; exit}' se_e.bed
# hg38_CD14PM_chr1_1726914

# number of enhancers in a SE
awk -F"\t" -v se_id_field="$se_id_field" '{se[$se_id_field]++} END {for (s in se) print s, se[s]}' se_e.bed | sort -nk2 > se_elem_numb.txt

## 6. removing SE with only 1 enhancer
awk -F"\t" -v se_id_field="$se_id_field" '{
    count[$se_id_field]++
    records[NR] = $0  # Сохраняем каждую запись
    se_id[NR] = $se_id_field
} 
# here NR equals the total number of records
END {
    for (key in count) {
        if (count[key] > 1) {
            for (i = 1; i <= NR; i++) {
                if (se_id[i] == key) {
                    print records[i]  # Печатаем записи, которые соответствуют критерию
                }
            }
        }
    }
}' se_e.bed >  se_e_filtered.bed

# result veridication
awk -F"\t" -v se_id_field="$se_id_field" '{se[$se_id_field]++} END {for (s in se) print s, se[s]}' se_e_filtered.bed | sort -nk2 | head -10
