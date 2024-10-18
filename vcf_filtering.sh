#!/bin/bash

mkdir -p ~/project/variants/vcf_1000_genomes_filtered
cd ~/project/variants/vcf_1000_genomes_filtered/

screen -S filtration 
ls *.vcf.gz | \
parallel -j 7 '\
bedtools intersect -wa -wb \
-a ~/project/variants/vcf_1000_genomes/{} \
-b /home/avasileva/project/monocytes/combined_annotation/combined_annotation.bed > \
~/project/variants/vcf_1000_genomes_filtered/filtered_{}'
# Ctrl+a+d # выйти из screen
# screen -ls
# screen -r 4833.DOWNLOAD_RAW # to come back to screen
# screen -X -S 13240.DOWNLOAD_raw quit  #удалить фоновое окно

# removing lines with <ref only>
screen -S filtration_ref
ls *.vcf |
parallel -j 100 "\
grep -ivP '\t<NON_REF>\t' {} > {}.temp && \
mv {}.temp {} && \
echo '{} completed'
"
cd ~/project/variants/vcf_1000_genomes_filtered/

# appending headers
screen -S adding_header
ls *.vcf |  parallel -j 100 --plus "\
zcat ~/project/variants/vcf_1000_genomes/{#filtered_}.gz | \
awk '{if (\$0~/^#/) {print} else exit}' | \
cat - {} > \
{}.temp && \
mv {}.temp {} && \
echo '{} completed'"
