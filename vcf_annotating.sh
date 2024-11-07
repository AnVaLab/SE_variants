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


# Downloading dbs
mkdir -p /home/avasileva/project/variants/db

## dbsnp
# https://ftp.ncbi.nih.gov/snp/organisms/human_9606/VCF/ file 00-All.vcf.gz 
mkdir -p /home/avasileva/project/variants/db/dbsnp
cd  /home/avasileva/project/variants/db/dbsnp
wget https://ftp.ncbi.nih.gov/snp/organisms/human_9606/VCF/00-All.vcf.gz

## clinvar
# https://ftp.ncbi.nlm.nih.gov/pub/clinvar/vcf_GRCh38/ file clinvar.vcf.gz  
mkdir -p /home/avasileva/project/variants/db/clinvar
cd /home/avasileva/project/variants/db/clinvar
wget https://ftp.ncbi.nlm.nih.gov/pub/clinvar/vcf_GRCh38/clinvar.vcf.gz

## gnomad
# https://gnomad.broadinstitute.org/data Genomes
mkdir -p /home/avasileva/project/variants/db/gnomad
cd /home/avasileva/project/variants/db/gnomad

screen -S gnomad
wget https://storage.googleapis.com/gcp-public-data--gnomad/release/4.1/vcf/genomes/gnomad.genomes.v4.1.sites.chr1.vcf.bgz;
wget https://storage.googleapis.com/gcp-public-data--gnomad/release/4.1/vcf/genomes/gnomad.genomes.v4.1.sites.chr2.vcf.bgz;
wget https://storage.googleapis.com/gcp-public-data--gnomad/release/4.1/vcf/genomes/gnomad.genomes.v4.1.sites.chr3.vcf.bgz;
wget https://storage.googleapis.com/gcp-public-data--gnomad/release/4.1/vcf/genomes/gnomad.genomes.v4.1.sites.chr4.vcf.bgz;
wget https://storage.googleapis.com/gcp-public-data--gnomad/release/4.1/vcf/genomes/gnomad.genomes.v4.1.sites.chr5.vcf.bgz;
wget https://storage.googleapis.com/gcp-public-data--gnomad/release/4.1/vcf/genomes/gnomad.genomes.v4.1.sites.chr6.vcf.bgz;
wget https://storage.googleapis.com/gcp-public-data--gnomad/release/4.1/vcf/genomes/gnomad.genomes.v4.1.sites.chr7.vcf.bgz;
wget https://storage.googleapis.com/gcp-public-data--gnomad/release/4.1/vcf/genomes/gnomad.genomes.v4.1.sites.chr8.vcf.bgz;
wget https://storage.googleapis.com/gcp-public-data--gnomad/release/4.1/vcf/genomes/gnomad.genomes.v4.1.sites.chr9.vcf.bgz;
wget https://storage.googleapis.com/gcp-public-data--gnomad/release/4.1/vcf/genomes/gnomad.genomes.v4.1.sites.chr10.vcf.bgz;
wget https://storage.googleapis.com/gcp-public-data--gnomad/release/4.1/vcf/genomes/gnomad.genomes.v4.1.sites.chr11.vcf.bgz;
wget https://storage.googleapis.com/gcp-public-data--gnomad/release/4.1/vcf/genomes/gnomad.genomes.v4.1.sites.chr12.vcf.bgz;
wget https://storage.googleapis.com/gcp-public-data--gnomad/release/4.1/vcf/genomes/gnomad.genomes.v4.1.sites.chr13.vcf.bgz;
wget https://storage.googleapis.com/gcp-public-data--gnomad/release/4.1/vcf/genomes/gnomad.genomes.v4.1.sites.chr14.vcf.bgz;
wget https://storage.googleapis.com/gcp-public-data--gnomad/release/4.1/vcf/genomes/gnomad.genomes.v4.1.sites.chr15.vcf.bgz;
wget https://storage.googleapis.com/gcp-public-data--gnomad/release/4.1/vcf/genomes/gnomad.genomes.v4.1.sites.chr16.vcf.bgz;
wget https://storage.googleapis.com/gcp-public-data--gnomad/release/4.1/vcf/genomes/gnomad.genomes.v4.1.sites.chr17.vcf.bgz;
wget https://storage.googleapis.com/gcp-public-data--gnomad/release/4.1/vcf/genomes/gnomad.genomes.v4.1.sites.chr18.vcf.bgz;
wget https://storage.googleapis.com/gcp-public-data--gnomad/release/4.1/vcf/genomes/gnomad.genomes.v4.1.sites.chr19.vcf.bgz;
wget https://storage.googleapis.com/gcp-public-data--gnomad/release/4.1/vcf/genomes/gnomad.genomes.v4.1.sites.chr20.vcf.bgz;
wget https://storage.googleapis.com/gcp-public-data--gnomad/release/4.1/vcf/genomes/gnomad.genomes.v4.1.sites.chr21.vcf.bgz;
wget https://storage.googleapis.com/gcp-public-data--gnomad/release/4.1/vcf/genomes/gnomad.genomes.v4.1.sites.chr22.vcf.bgz;
wget https://storage.googleapis.com/gcp-public-data--gnomad/release/4.1/vcf/genomes/gnomad.genomes.v4.1.sites.chrX.vcf.bgz;
wget https://storage.googleapis.com/gcp-public-data--gnomad/release/4.1/vcf/genomes/gnomad.genomes.v4.1.sites.chrY.vcf.bgz

# Indexing gnomad files
ls *.gz |
parallel -j 10 "\
bcftools index -t --threads 9 {}"


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

