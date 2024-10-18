#!/bin/bash

# downloading dbs


# SnpEff


# SnpSift
# последние версии gnomad, ClinVar, dnsnp.

java -jar SnpSift.jar annotate dbSnp132.vcf variants.vcf > variants_annotated.vcf

java -jar SnpSift.jar annotate db/dbSnp/dbSnp137.20120616.vcf test.chr22.vcf
