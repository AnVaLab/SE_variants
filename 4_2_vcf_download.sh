#!/bin/bash

# Downloading .vcf files of previously selected samples (100 european males)

mkdir /home/avasileva/project/variants/vcf_1000_genomes && cd $_

# Create a file with vcf file download links for selected ids
awk '{print "https://ftp.1000genomes.ebi.ac.uk/vol1/ftp/data_collections/1000G_2504_high_coverage/working/20190425_NYGC_GATK/raw_calls_updated/" $1 ".haplotypeCalls.er.raw.vcf.gz"}' \
../samples_meta_male_eur_100_1000Genomes30xGRCh38.csv \
> download_links_vcf_1000Genomes30xGRCh38.csv

# downloading vcf files
wget -i download_links_vcf_1000Genomes30xGRCh38.csv

# exploring downloaded files
zcat HG00096.haplotypeCalls.er.raw.vcf.gz | head -10000

# readme
printf "download_links_vcf_1000Genomes30xGRCh38.csv - file containing download links for selected 100 EUR male samples \n" >> readme.txt
