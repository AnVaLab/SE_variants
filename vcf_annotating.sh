#!/bin/bash

### Annotating variants in SE enhancer and spacer elements, typical enhancers and negative control 
### using SnpEff (hg38) and SnpSift (gnomad, clinvar, dbsnp) tools. 
### For SnpSift annotation gnomad, clinvar, dbsnp databases were downloaded separatly. 

# Creating a working directory 
mkdir -p /home/avasileva/project/variants/vcf_1000_genomes_filtered_annotated_snpeff
cd /home/avasileva/project/variants/vcf_1000_genomes_filtered_formatted

# SnpEff annotation
screen -S annotation
ls *.vcf |
parallel -j 50 --plus "\
java -Xmx8g -jar /home/avasileva/programs/snpEff/snpEff.jar \
-c /home/avasileva/programs/snpEff/snpEff.config \
-stats snpeff_{.} \
-v hg38 {} > \
/home/avasileva/project/variants/vcf_1000_genomes_filtered_annotated/{.}.ann.vcf &&
"

# SnpSift
mkdir -p /home/avasileva/project/variants/vcf_1000_genomes_filtered_annotated_snpsift_clinvar
screen -S annotation
ls *.vcf |
parallel -j 50 "\
java -jar /home/avasileva/programs/snpEff/SnpSift.jar annotate \
 /home/avasileva/project/variants/db/clinvar/clinvar.vcf {} > \
/home/avasileva/project/variants/vcf_1000_genomes_filtered_annotated_snpsift_clinvar/clinvar_{.}.ann.vcf
"

mkdir -p /home/avasileva/project/variants/vcf_1000_genomes_filtered_annotated_snpsift_clinvar_dbsnp
screen -S annotation
ls *.vcf |
parallel -j 2 "\
java -jar /home/avasileva/programs/snpEff/SnpSift.jar annotate -v \
 /home/avasileva/project/variants/db/dbsnp/00-All.vcf {} > \
/home/avasileva/project/variants/vcf_1000_genomes_filtered_annotated_snpsift_clinvar_dbsnp/dbsnp_{}
"

mkdir -p /home/avasileva/project/variants/vcf_1000_genomes_filtered_annotated_snpsift_clinvar_dbsnp_gnomad

ls *.vcf |
parallel -j 2 "\
for i in {1..22};
do
java -jar /home/avasileva/programs/snpEff/SnpSift.jar annotate -v \
/home/avasileva/project/variants/db/gnomad/gnomad.genomes.v4.1.sites.chr${i}.vcf.gz {} > \
/home/avasileva/project/variants/vcf_1000_genomes_filtered_annotated_snpsift_clinvar_dbsnp_gnomad/temp
mv /home/avasileva/project/variants/vcf_1000_genomes_filtered_annotated_snpsift_clinvar_dbsnp_gnomad/temp /home/avasileva/project/variants/vcf_1000_genomes_filtered_annotated_snpsift_clinvar_dbsnp_gnomad/{}
done

java -jar /home/avasileva/programs/snpEff/SnpSift.jar annotate -v \
/home/avasileva/project/variants/db/gnomad/gnomad.genomes.v4.1.sites.chrX.vcf.gz {} > \
/home/avasileva/project/variants/vcf_1000_genomes_filtered_annotated_snpsift_clinvar_dbsnp_gnomad/temp
mv /home/avasileva/project/variants/vcf_1000_genomes_filtered_annotated_snpsift_clinvar_dbsnp_gnomad/temp /home/avasileva/project/variants/vcf_1000_genomes_filtered_annotated_snpsift_clinvar_dbsnp_gnomad/{}

java -jar /home/avasileva/programs/snpEff/SnpSift.jar annotate -v \
/home/avasileva/project/variants/db/gnomad/gnomad.genomes.v4.1.sites.chrX.vcf.gz {} > \
/home/avasileva/project/variants/vcf_1000_genomes_filtered_annotated_snpsift_clinvar_dbsnp_gnomad/temp
mv /home/avasileva/project/variants/vcf_1000_genomes_filtered_annotated_snpsift_clinvar_dbsnp_gnomad/temp /home/avasileva/project/variants/vcf_1000_genomes_filtered_annotated_snpsift_clinvar_dbsnp_gnomad/{}
"

