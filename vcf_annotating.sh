#!/bin/bash

mkdir -p /home/avasileva/project/variants/vcf_1000_genomes_filtered_annotated_snpeff
cd /home/avasileva/project/variants/vcf_1000_genomes_filtered_formatted


# SnpEff
screen -S annotation
ls *.vcf |
parallel -j 50 "\
java -Xmx8g -jar /home/avasileva/programs/snpEff/snpEff.jar \
-c /home/avasileva/programs/snpEff/snpEff.config \
-stats snpeff_{.} \
-v hg38 {} > \
/home/avasileva/project/variants/vcf_1000_genomes_filtered_annotated/{.}.ann.vcf &&
"
# разнести доп поля и vcf файл в разные файлы во время аннотации а потом объединить


# downloading dbs
# gnomad
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

for i in {1..22};
do
mv /home/avasileva/project/variants/db/gnomad/gnomad.genomes.v4.1.sites.chr${i}.vcf.gbz /home/avasileva/project/variants/db/gnomad/gnomad.genomes.v4.1.sites.chr${i}.vcf.gz
gunzip /home/avasileva/project/variants/db/gnomad/gnomad.genomes.v4.1.sites.chr${i}.vcf.gz; done

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
/home/avasileva/project/variants/vcf_1000_genomes_filtered_annotated_snpsift_clinvar_dbsnp/dbsnp_{.}.ann.vcf
"

mkdir -p /home/avasileva/project/variants/vcf_1000_genomes_filtered_annotated_snpsift_clinvar_dbsnp_gnomad

ls *.vcf |
parallel -j 2 "\
for i in {1..22};
do
java -jar /home/avasileva/programs/snpEff/SnpSift.jar annotate -v \
/home/avasileva/project/variants/db/gnomad/gnomad.genomes.v4.1.sites.chr${i}.vcf {} > \
/home/avasileva/project/variants/vcf_1000_genomes_filtered_annotated_snpsift_clinvar_dbsnp_gnomad/temp
mv /home/avasileva/project/variants/vcf_1000_genomes_filtered_annotated_snpsift_clinvar_dbsnp_gnomad/temp /home/avasileva/project/variants/vcf_1000_genomes_filtered_annotated_snpsift_clinvar_dbsnp_gnomad/{}
done

java -jar /home/avasileva/programs/snpEff/SnpSift.jar annotate -v \
/home/avasileva/project/variants/db/gnomad/gnomad.genomes.v4.1.sites.chrX.vcf {} > \
/home/avasileva/project/variants/vcf_1000_genomes_filtered_annotated_snpsift_clinvar_dbsnp_gnomad/temp
mv /home/avasileva/project/variants/vcf_1000_genomes_filtered_annotated_snpsift_clinvar_dbsnp_gnomad/temp /home/avasileva/project/variants/vcf_1000_genomes_filtered_annotated_snpsift_clinvar_dbsnp_gnomad/{}

java -jar /home/avasileva/programs/snpEff/SnpSift.jar annotate -v \
/home/avasileva/project/variants/db/gnomad/gnomad.genomes.v4.1.sites.chrX.vcf {} > \
/home/avasileva/project/variants/vcf_1000_genomes_filtered_annotated_snpsift_clinvar_dbsnp_gnomad/temp
mv /home/avasileva/project/variants/vcf_1000_genomes_filtered_annotated_snpsift_clinvar_dbsnp_gnomad/temp /home/avasileva/project/variants/vcf_1000_genomes_filtered_annotated_snpsift_clinvar_dbsnp_gnomad/{}
"

java -jar /home/avasileva/programs/snpEff/SnpSift.jar annotate \
dbSnp132.vcf \
variants.vcf > \
variants_annotated.vcf



# последние версии gnomad, ClinVar, dnsnp.
java -jar SnpSift.jar annotate dbSnp132.vcf variants.vcf > variants_annotated.vcf
java -jar SnpSift.jar annotate db/dbSnp/dbSnp137.20120616.vcf test.chr22.vcf


