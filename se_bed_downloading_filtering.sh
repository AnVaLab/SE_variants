#!/bin/bash
# in SEA SE for all cell lines and tissues for human are gathered in a single bed file
wget http://218.8.241.248:8080/SEA3/download/SEA00101.bed

# filtering records by the regulatory element type, saving SE to a separate file
awk -F”\t” '{if ($(NF-1)=="SE") print $0}' SEA00101.bed > SE_only_SEA00101.bed

# filtering SE only for CD14-positive_monocyte
awk -F"\t" '$7=="CD14-positive_monocyte" {print $0}' SE_only_SEA00101.bed > SE_only_cd14plus_monocyte_SEA00101.bed
