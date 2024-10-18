#!/bin/bash

mkdir -p /home/avasileva/project/variants/vcf_1000_genomes_filtered_annotated

cd /home/avasileva/project/variants/vcf_1000_genomes_filtered



# SnpEff
screen -S annotation
ls *.vcf |
parallel -j 50 "\
java -Xmx8g -jar /home/avasileva/programs/snpEff/snpEff.jar \
-c /home/avasileva/programs/snpEff/snpEff.config -v hg38 {} > \
/home/avasileva/project/variants/vcf_1000_genomes_filtered_annotated/{.}.ann.vcf"

# разнести доп поля и vcf файл в разные файлы во время аннотации а потом объединить



grep -ivP '\t<NON_REF>\t' {} > {}.temp && \
mv {}.temp {} && \
echo '{} completed'
"

java -Xmx8g -jar snpEff.jar GRCh37.75 examples/test.chr22.vcf > test.chr22.ann.vcf


# downloading dbs


# SnpSift
# последние версии gnomad, ClinVar, dnsnp.

java -jar SnpSift.jar annotate dbSnp132.vcf variants.vcf > variants_annotated.vcf

java -jar SnpSift.jar annotate db/dbSnp/dbSnp137.20120616.vcf test.chr22.vcf
