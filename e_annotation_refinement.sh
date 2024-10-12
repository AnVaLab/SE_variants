#!/bin/bash

# filtering out unclassified regulatory elements
awk -F"\t" '$10!="Unclassified" {print $0}' ENCFF900YFA.bed > ENCFF900YFA_classified.bed

# leaving only enhancers
# checking that regulatory elements found for monocytes overlap exactly regulatory elements with annotated regulatory elements for the entire genome
# number of regulatory elements in ENCFF900YFA_classified.bed file
cat ENCFF900YFA_classified.bed | wc -l
# 149692

bedops -e 100% ./all_regulatory/ENCFF420VPZ.bed ./ENCFF900YFA_classified.bed | wc -l
# 149692

# yes, all elements from file for monocytes exist in file for genome

# leaving only enhancers
bedops -e 100% ./all_regulatory/ENCFF420VPZ.bed ./ENCFF900YFA_classified.bed | grep -E "dELS|pELS" > monocytes_e_only.bed
