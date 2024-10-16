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
> se_spacers.bed

# finding complement
for filename in /home/avasileva/temp/*; \
do \
se_info=$(cat "$filename" | head -1 | sed 's/.*\t\(chr.*\)SE_E/\1SE_S/'); \
te_field_numb=$(cat "$filename" | head -1 | sed 's/\(.*\)\tchr.*/\1/' | awk -F"\t" '{print (NF-3)}') ; \
te_info=$( printf ".\t"'%.0s' $(seq 1 "$te_field_numb")); \
bedops --complement  "$filename" | \
awk  -F"\t" -v te="$te_info" -v se="$se_info" '{print $0 "\t" te se}' >> \
se_spacers.bed; \
done 
# variable here is meta info about SE, to which spacers belong

## 4. annotating spacers (SE spacers overlap with genes and regulatory elements, this information is important to consider in variation alalysis)

# sort file
bedtools sort -i se_spacers.bed > se_spacers_sorted.bed

# intersecting spacers with regulatory regions
bedtools intersect \
-a se_spacers_sorted.bed \
-b /home/avasileva/project/genome_ann/encode/ENCFF420VPZ_all.bed /home/avasileva/project/genome_ann/hg38/genecode.v21.annotation.genes_sorted.bed |
awk -F"\t" -v OFS="\t" '{$4="gene_or_pre"; print}' > \
se_spacers_gene_pre.bed

# sort file
bedtools sort -i se_spacers_gene_pre.bed > se_spacers_gene_pre_sorted.bed

# find only generegions
bedtools subtract -a se_spacers_sorted.bed -b se_spacers_gene_pre_sorted.bed > se_spacers_nothing.bed

# combining
cat se_spacers_gene_pre_sorted.bed > se_spacers_annotated.bed
cat se_spacers_nothing.bed >> se_spacers_annotated.bed

# sort file
bedtools sort -i se_spacers_annotated.bed > se_spacers_annotated_sorted.bed


# checking the result in igv (on local pc)
scp -i '/home/anastasia/Downloads/avasileva.txt' avasileva@51.250.11.65:/home/avasileva/project/monocytes/se/spacers/se_spacers_annotated_sorted.bed ~/Documents/SE;
scp -i '/home/anastasia/Downloads/avasileva.txt' avasileva@51.250.11.65:/home/avasileva/project/monocytes/se/spacers/se_spacers_gene_pre_sorted.bed ~/Documents/SE;
scp -i '/home/anastasia/Downloads/avasileva.txt' avasileva@51.250.11.65:/home/avasileva/project/monocytes/se/spacers/se_spacers_nothing.bed ~/Documents/SE;
scp -i '/home/anastasia/Downloads/avasileva.txt' avasileva@51.250.11.65:/home/avasileva/project/monocytes/se/se_e_filtered.bed ~/Documents/SE;
