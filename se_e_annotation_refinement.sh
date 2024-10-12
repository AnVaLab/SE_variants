#!/bin/bash

# creating a working folder
mkdir ~/project/combined_annotation
cd ~/project/combined_annotation

# adding information about enhancers belonging to SE
bedtools intersect -loj -a ~/project/enhancers/te_monocytes.bed \
-b ~/project/se/SE_only_cd14plus_monocyte_norownumb_SEA00101.bed > enhancers_refined_se_e.bed 

# this will leave information about SE enhancer elements and typical enhancers

te_monocytes.bed
