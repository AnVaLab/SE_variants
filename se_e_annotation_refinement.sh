#!/bin/bash

# adding information about enhancers belonging to SE
~/programs/bedtools2/bin/bedtools intersect -loj -a ~/project/enhancers/monocytes_e_only.bed \
-b ~/project/se/SE_only_cd14plus_monocyte_norownumb_SEA00101.bed > ~/project/combined_annotation/enhancers_refined_se_e.bed 
