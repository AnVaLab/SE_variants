#!/bin/bash

# crearing a working folder
mkdir -p /home/avasileva/project/monocytes/se
cd  /home/avasileva/project/monocytes/se

# filtering SE only for CD14-positive_monocyte
awk -F"\t" '$7=="CD14-positive_monocyte" {print $0}' /home/avasileva/project/genome_ann/SE_only_SEA00101.bed > SE_only_cd14plus_monocyte_SEA00101.bed
