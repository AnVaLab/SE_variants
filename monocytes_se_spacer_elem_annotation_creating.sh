#!/bin/bash

## splitting SE to separate files
# creating a working dirrectory
mkdir /home/avasileva/project/temp
cd /home/avasileva/project/temp
rm -r *

# getting a field number containing SE id
string="hg38"
se_id_field="$(awk -v b="$string" '{for (i=1; i<=NF; i++) { if ($i ~ b) { print i; exit } }}' se_e.bed)"

# saving each SE to a separate file
sort -k"$se_id_field","$se_id_field" se_e_filtered.bed | \
uniq -f $((se_id_field-1)) --group | \
awk -v RS="\n\n" '{
   filename = "/home/avasileva/temp/output_" ++count ".txt"
   print $0 > filename
}' 

## creating file with complement (SE spacers)

# creating a working directory
mkdir /home/avasileva/project/se/spacers
cd /home/avasileva/project/se/spacers

# что такое i=11?
for filename in /home/avasileva/temp/*; \
do \
variable=$(awk 'NR==1 {for (i = 11; i <= NF; i++) {printf "%s\t ", $i}; printf "\n"}' "$filename");  \
bedops --complement  "$filename" | \
awk  -v var="$variable" '{print $0 "\t.\t.\t.\t.\t.\t.\t.\t" var "SE_S"}' >> \
se_spacers.bed; \
done 

## 4. annotating spacers (SE spacers overlap with genes and regulatory elements, this information is important to consider in variation alalysis)

# sort file
bedtools sort \
-i /home/avasileva/project/combined_annotation/se_spacers.bed > \
/home/avasileva/project/combined_annotation/se_spacers_sorted.bed

bedtools intersect \
-b /home/avasileva/project/combined_annotation/se_spacers_sorted.bed \
-a /home/avasileva/project/hg38/genecode.v21.annotation.genes_sorted.bed > \
intersected_ann_spacers.bed

# intersecting spacers with regulatory regions
bedtools intersect \
-b /home/avasileva/project/combined_annotation/se_spacers_sorted.bed \
-a /home/avasileva/project/enhancers/all_regulatory/ENCFF420VPZ.bed > \
intersected_reg_spacers.bed

####### finish and check the result in igv
