#!/bin/bash

mkdir -p /home/avasileva/project/variants/vcf_1000_genomes_filtered_annotated

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


# SnpSift
# последние версии gnomad, ClinVar, dnsnp.

java -jar SnpSift.jar annotate dbSnp132.vcf variants.vcf > variants_annotated.vcf

java -jar SnpSift.jar annotate db/dbSnp/dbSnp137.20120616.vcf test.chr22.vcf
