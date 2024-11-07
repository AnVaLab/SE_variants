#!/bin/bash

# Enhancer elements in SE were defined by intersecting SEA and ENCODE. 

## 1. creating a working folder
mkdir -p /home/avasileva/project/monocytes/se/enhancers
mkdir -p /home/avasileva/project/monocytes/combined_annotation
cd /home/avasileva/project/monocytes/combined_annotation

## 2. intersecting encode and sea annotations to determine SE enhancer elements
bedtools intersect \
-loj \
-a /home/avasileva/project/monocytes/enhancers/e.bed \
-b /home/avasileva/project/monocytes/se/se.bed > \
te_se_e.bed 
# this file contains information about SE enhancer elements and typical enhancers
# unexpected behaviour: adds -1 to columns 11,12 for records with no intersection!

# 3. Appending last column to te and se files
# based on condition add a value to a new column (TY/SE_E)
awk -v OFS='\t' \
'{if($(NF-1)=="SE") {print $0, "SE_E"} else {print $0, "TE"}}' te_se_e.bed > \
te_se_e_marked.bed

## 4. splitting information on TE and SE E elements into separate files
grep "SEA" te_se_e_marked.bed > /home/avasileva/project/monocytes/se/enhancers/se_e.bed;
grep -v "SEA" te_se_e_marked.bed > /home/avasileva/project/monocytes/enhancers/te.bed;
# Since enhancer coordinated differ in SEA and ENCODE inconcistencies were witnessed: in some SE start/end coordinates did not overlap enhancers,
# some SE concist only out of 1 ENCODE enhancer, which contradicts SE definition. We decided to exclude those SE.

## 5. counting number of enhancers in each SE
cd /home/avasileva/project/monocytes/se/enhancers

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

# 7. Removing unneeded files
rm -f /home/avasileva/project/monocytes/se/se_e.bed \
/home/avasileva/project/monocytes/se/enhancers/se_elem_numb.txt \
/home/avasileva/project/monocytes/combined_annotation/te_se_e.bed \
/home/avasileva/project/monocytes/combined_annotation/te_se_e_marked.bed

# 8. Readme file
touch readme.txt
printf "This Readme.txt contains description of files in /home/avasileva/project/monocytes/se/enhancers folder \n \
se_e_filtered.bed - file containing SE enhancer coordinates; \n \
Enhancer coordinates in SE were found by intersection of SE in monocytes with ENCODE enhancer coordinates in monocytes.\n \
Only records for SE with more than 1 enhancer were left.\n" > readme.txt

printf "te.bed - file contains only records for typical enhancers (SE enhancer elements are excluded from the file.\n \
Achieved by intersection of e.bed and se.bed file\n" \
>> /home/avasileva/project/monocytes/enhancers/readme.txt
