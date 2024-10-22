#!/bin/bash

mkdir -p ~/project/variants/vcf_1000_genomes_filtered
cd ~/project/variants/vcf_1000_genomes_filtered/

mkdir ~/project/variants/vcf_1000_genomes_filtered_new

screen -S filtration 
ls *.vcf.gz | \
parallel -j 100 '\
bedtools intersect -wa -wb \
-a ~/project/variants/vcf_1000_genomes/{} \
-b /home/avasileva/project/monocytes/combined_annotation/combined_annotation.bed > \
~/project/variants/vcf_1000_genomes_filtered_new/filtered_{}'
# Ctrl+a+d # выйти из screen
# screen -ls
# screen -r 4833.DOWNLOAD_RAW # to come back to screen
# screen -X -S 13240.DOWNLOAD_raw quit  #удалить фоновое окно

# checking number of fields
ls *.vcf.gz | \
parallel -j 100 "\
cat {} | awk -F'\t' '{print NF}' | sort -n | uniq && echo {}"

mkdir ~/project/variants/vcf_1000_genomes_filtered_no_no_ref
# removing lines with <ref only>
screen -S filtration_ref
ls *.vcf.gz |
parallel -j 100 "\
awk -F'\t' '{if (\$5!=\"<NON_REF>\") print \$0}' {} > \
~/project/variants/vcf_1000_genomes_filtered_no_no_ref/{} && echo {}"

# checking number of fields
ls *.vcf.gz | \
parallel -j 100 "\
cat {} | awk -F'\t' '{print NF}' | sort -n | uniq && echo {}"

cd ~/project/variants/vcf_1000_genomes_filtered_no_no_ref
mkdir ~/project/variants/vcf_1000_genomes_filtered_no_no_ref_fields
# removing records with NF less than 40
ls *.vcf.gz | \
parallel -j 100 "\
cat {} | awk -F'\t' '{if (NF==40) print \$0}' >  ~/project/variants/vcf_1000_genomes_filtered_no_no_ref_fields/{} && echo {}"

mkdir ~/project/variants/vcf_1000_genomes_filtered_no_no_ref_fields_fields
cd  ~/project/variants/vcf_1000_genomes_filtered_no_no_ref_fields
ls *.vcf.gz | \
parallel -j 100 "\
awk -F'\t' -v OFS='\t' \
'{print \$1,\$2,\$3,\$4,\$5,\$6,\$7,\$8,\$9,\$10}' {} > \
~/project/variants/vcf_1000_genomes_filtered_no_no_ref_fields_fields/{} && echo {}"


mkdir ~/project/variants/vcf_1000_genomes_filtered_no_no_ref_fields_header
cd  ~/project/variants/vcf_1000_genomes_filtered_no_no_ref_fields_fields
ls *.vcf.gz | \
parallel -j 100 --plus "\
zcat ~/project/variants/vcf_1000_genomes/{#filtered_} | \
awk '{if (\$0~/^#/) {print} else exit}' | \
cat - {} > ~/project/variants/vcf_1000_genomes_filtered_no_no_ref_fields_header/{} &&
echo '{} completed'"

ls *.vcf.gz | \
parallel -j 100 "\
mv {} {.}"


