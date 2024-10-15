#!/bin/bash

## splitting SE to separate files
# creating a working dirrectory
mkdir -p /home/avasileva/project/temp
cd /home/avasileva/project/temp
rm -rf ./*

# getting a field number containing SE id
string="hg38"
se_id_field="$(awk -v b="$string" '{for (i=1; i<=NF; i++) { if ($i ~ b) { print i; exit } }}' /home/avasileva/project/monocytes/se/se_e_filtered.bed)"

# saving each SE to a separate file
sort -k"$se_id_field","$se_id_field" /home/avasileva/project/monocytes/se/se_e_filtered.bed | \
uniq -f $((se_id_field-1)) --group | \
awk -v RS="\n\n" '{
   filename = "/home/avasileva/project/temp/output_" ++count ".txt"
   print $0 > filename
}' 

## creating file with complement (SE spacers)

# creating a working directory
mkdir /home/avasileva/project/se/spacers
cd /home/avasileva/project/se/spacers

# finding complement
for filename in /home/avasileva/project/temp/*; \
do cat "$filename" | head -1 | sed 's/.*\t\(chr.*\)SE_E/\1SE_S/'; done


variable=$(cat "$filename" | head -1 | sed 's/.*\t\(chr.*\)SE_E/\1SE_S/'); \
bedops --complement  "$filename" | \
awk  -v var="$variable" '{print $0 "\t.\t.\t.\t.\t.\t.\t.\t" var "SE_S"}' >> \
se_spacers.bed; \
done 
# variable here is meta info about SE, to which spacers belong

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
