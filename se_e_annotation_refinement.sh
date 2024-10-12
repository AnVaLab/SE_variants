#!/bin/bash

# filtering out unclassified enhancers
awk -F"\t" '$10!="Unclassified" {print $0}' ENCFF900YFA.bed > ENCFF900YFA_classified.bed

# adding information about enhancers belonging to SE
~/programs/bedtools2/bin/bedtools intersect -loj -a ~/project/enhancers/ENCFF900YFA_classified.bed \
-b ~/project/se/SE_only_cd14plus_monocyte_norownumb_SEA00101.bed > ~/project/enhancers_refined_se_e.bed 
