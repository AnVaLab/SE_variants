#!/bin/bash

### Preparing .vcf files for variant annotation: filtering (leaving only those falling into SE, TE or negative control regions and 
### those that are not <non_ref>) and formating files to fit .vcf format.

## 1. Leaving variants falling in SE enhancer/spacer elements, typical enhancers and negative control only.
# 1.1 Creating a working directory
mkdir -p ~/project/variants/vcf_1000_genomes_filtered
cd ~/project/variants/vcf_1000_genomes_filtered/

# 1.2 Intersecting regulatory elements annotation and vcf files for each sample
screen -S filtration 
ls *.vcf.gz | \
parallel -j 100 --plus '\
bedtools intersect -wa -wb \
-a ~/project/variants/vcf_1000_genomes/{} \
-b /home/avasileva/project/monocytes/combined_annotation/combined_annotation.bed > \
~/project/variants/vcf_1000_genomes_filtered/filtered_{.}'

# checking number of fields 
ls *.vcf | \
parallel -j 100 "\
cat {} | awk -F'\t' '{print NF}' | sort -n | uniq && echo {}"
# this step is needed to verify that all records contain the same number of columns (bedtools seems to have a bug, and reraly misses some fields)

# 1.3 Some records contain less fields than they should (presumably bf bedtools bug). Removing those records
#    (there were only 2-3 records like that all in all among all samples)
ls *.vcf | \
parallel -j 100 "\
cat {} | awk -F'\t' '{if (NF==40) print \$0}' >  ~/project/variants/vcf_1000_genomes_filtered/{} && echo {}"

## 2. Filtering out <ref only> records
mkdir -p ~/project/variants/vcf_1000_genomes_filtered_no_non_ref

screen -S filtration_ref
ls *.vcf |
parallel -j 100 "\
awk -F'\t' '{if (\$5!=\"<NON_REF>\") print \$0}' {} > \
~/project/variants/vcf_1000_genomes_filtered_no_non_ref/{} && echo {}"

## 3. Formatting .vcf files 
# 3.1 Leaving only first 10 fields to fit .vcf file format (i.e. removing regulatory elements information)
#    This is requared for SnpEff and SnpSift input
cd ~/project/variants/vcf_1000_genomes_filtered_no_non_ref/
mkdir ~/project/variants/vcf_1000_genomes_filtered_no_non_ref_fields

ls *.vcf | \
parallel -j 100 "\
awk -F'\t' -v OFS='\t' \
'{print \$1,\$2,\$3,\$4,\$5,\$6,\$7,\$8,\$9,\$10}' {} > \
~/project/variants/vcf_1000_genomes_filtered_no_non_ref_fields/{} && echo {}"

# 3.2 Adding headers (bedtools removed headers in the resulting file)
cd  ~/project/variants/vcf_1000_genomes_filtered_no_no_ref_fields
mkdir ~/project/variants/vcf_1000_genomes_filtered_no_non_ref_fields_header

ls *.vcf | \
parallel -j 100 --plus "\
zcat ~/project/variants/vcf_1000_genomes/{#filtered_} | \
awk '{if (\$0~/^#/) {print} else exit}' | \
cat - {} > ~/project/variants/vcf_1000_genomes_filtered_no_non_ref_fields_header/{} &&
echo '{} completed'"

# cat -
# стандартный поток ввода??

# Removing unneeded folders
mv  ~/project/variants/vcf_1000_genomes_filtered_no_non_ref ~/project/variants/vcf_1000_genomes_filtered_regulatory_reg_info_no_header
rm -rf ~/project/variants/vcf_1000_genomes/ \
~/project/variants/vcf_1000_genomes_filtered/ 

mv ~/project/variants/vcf_1000_genomes_filtered_no_no_ref_fields_header/ ~/project/variants/vcf_1000_genomes_filtered_prepared_for_annotation
rm -rf ~/project/variants/vcf_1000_genomes_filtered_no_non_ref_fields 

#====================
ls *.vcf.gz | \
parallel -j 100 "\
mv {} {.}"


