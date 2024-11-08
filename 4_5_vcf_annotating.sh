#!/bin/bash

### Annotating variants in SE enhancer and spacer elements, typical enhancers and negative control 
### using SnpEff (hg38) and SnpSift (gnomad, clinvar, dbsnp) tools. 
### For SnpSift annotation gnomad, clinvar, dbsnp databases were downloaded separatly. 

## 1. SnpEff annotation
cd /home/avasileva/project/variants/vcf_1000_genomes_filtered_no_regulatory_elem_info_header
mkdir -p /home/avasileva/project/variants/vcf_1000_genomes_filtered_annotated_snpeff
screen -S annotation
ls *.vcf |
parallel -j 50 --plus "\
java -Xmx8g -jar /home/avasileva/programs/snpEff/snpEff.jar \
-c /home/avasileva/programs/snpEff/snpEff.config \
-stats snpeff_{.} \
-v hg38 {} > \
/home/avasileva/project/variants/vcf_1000_genomes_filtered_annotated_snpeff/snpeff_{.}.ann.vcf &&
"

## 2. SnpSift annotation
# 2.1 clinvar
cd /home/avasileva/project/variants/vcf_1000_genomes_filtered_annotated_snpeff
mkdir -p /home/avasileva/project/variants/vcf_1000_genomes_filtered_annotated_snpeff_snpsift_clinvar
screen -S annotation
ls *.vcf |
parallel -j 50 "\
java -jar /home/avasileva/programs/snpEff/SnpSift.jar annotate \
 /home/avasileva/project/variants/db/clinvar/clinvar.vcf {} > \
/home/avasileva/project/variants/vcf_1000_genomes_filtered_annotated_snpeff_snpsift_clinvar/clinvar_{}
"

# 2.2 dbsnp
cd /home/avasileva/project/variants/vcf_1000_genomes_filtered_annotated_snpeff_snpsift_clinvar
mkdir -p /home/avasileva/project/variants/vcf_1000_genomes_filtered_annotated_snpeff_snpsift_clinvar_dbsnp
screen -S annotation
ls *.vcf |
parallel -j 2 "\
java -jar /home/avasileva/programs/snpEff/SnpSift.jar annotate -v \
 /home/avasileva/project/variants/db/dbsnp/00-All.vcf {} > \
/home/avasileva/project/variants/vcf_1000_genomes_filtered_annotated_snpeff_snpsift_clinvar_dbsnp/dbsnp_{}"

# 2.3 gnomad
cd /home/avasileva/project/variants/vcf_1000_genomes_filtered_annotated_snpeff_snpsift_clinvar_dbsnp/
mkdir -p /home/avasileva/project/variants/vcf_1000_genomes_filtered_annotated_snpeff_snpsift_clinvar_dbsnp_gnomad
ls *.vcf |
parallel -j 2 "\
for i in {1..22};
do
java -jar /home/avasileva/programs/snpEff/SnpSift.jar annotate -v \
/home/avasileva/project/variants/db/gnomad/gnomad.genomes.v4.1.sites.chr${i}.vcf.gz {} > \
/home/avasileva/project/variants/vcf_1000_genomes_filtered_annotated_snpeff_snpsift_clinvar_dbsnp_gnomad/temp_{} && \
mv /home/avasileva/project/variants/vcf_1000_genomes_filtered_annotated_snpeff_snpsift_clinvar_dbsnp_gnomad/temp_{} /home/avasileva/project/variants/vcf_1000_genomes_filtered_annotated_snpeff_snpsift_clinvar_dbsnp_gnomad/{}
done

java -jar /home/avasileva/programs/snpEff/SnpSift.jar annotate -v \
/home/avasileva/project/variants/db/gnomad/gnomad.genomes.v4.1.sites.chrX.vcf.gz {} > \
/home/avasileva/project/variants/vcf_1000_genomes_filtered_annotated_snpeff_snpsift_clinvar_dbsnp_gnomad/temp_{} && \
mv /home/avasileva/project/variants/vcf_1000_genomes_filtered_annotated_snpeff_snpsift_clinvar_dbsnp_gnomad/temp_{} /home/avasileva/project/variants/vcf_1000_genomes_filtered_annotated_snpeff_snpsift_clinvar_dbsnp_gnomad/{}

java -jar /home/avasileva/programs/snpEff/SnpSift.jar annotate -v \
/home/avasileva/project/variants/db/gnomad/gnomad.genomes.v4.1.sites.chrX.vcf.gz {} > \
/home/avasileva/project/variants/vcf_1000_genomes_filtered_annotated_snpeff_snpsift_clinvar_dbsnp_gnomad/temp_{} && \
mv /home/avasileva/project/variants/vcf_1000_genomes_filtered_annotated_snpeff_snpsift_clinvar_dbsnp_gnomad/temp_{} /home/avasileva/project/variants/vcf_1000_genomes_filtered_annotated_snpeff_snpsift_clinvar_dbsnp_gnomad/{}
"

## 3. Removing unneeded folders
rm -rf /home/avasileva/project/variants/vcf_1000_genomes_filtered_annotated_snpeff \
/home/avasileva/project/variants/vcf_1000_genomes_filtered_annotated_snpeff_snpsift_clinvar
