#!/bin/bash

## splitting SE to separate files
# creating a working dirrectory
mkdir -p /home/avasileva/temp
cd /home/avasileva/temp
rm -rf ./*

# getting a field number containing SE id
string="hg38"
se_id_field="$(awk -v b="$string" '{for (i=1; i<=NF; i++) { if ($i ~ b) { print i; exit } }}' /home/avasileva/project/monocytes/se/se_e_filtered.bed)"

# saving each SE to a separate file
sort -k"$se_id_field","$se_id_field" /home/avasileva/project/monocytes/se/se_e_filtered.bed | \
uniq -f $((se_id_field-1)) --group | \
awk -v RS="\n\n" '{
   filename = "/home/avasileva/temp/output_" ++count ".txt"
   print $0 > filename
}' 

## creating file with complement (SE spacers)

# creating a working directory
mkdir -p /home/avasileva/project/monocytes/se/spacers
cd /home/avasileva/project/monocytes/se/spacers

# finding complement
for filename in /home/avasileva/temp/*; \
do \
se_info=$(cat "$filename" | head -1 | sed 's/\(.*\t\)chr.*/\1/' | sed 's/\t*\t/.\t/'); echo "$se_info"; done

cat "$filename" | head -1 ; done
se_info=$(cat "$filename" | head -1 | sed 's/.*\t\(chr.*\)SE_E/\1SE_S/'); echo "$se_info"; done\
e_info=$(cat "$filename" | head -1 | sed 's/.*\t\(chr.*\)SE_E/\1SE_S/' ); \
bedops --complement  "$filename" | \

#### number of fields!!!
awk  -v var="$se_info" '{print $0 "\t.\t.\t.\t.\t.\t.\t.\t" se_info "SE_S"}' >> \
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
