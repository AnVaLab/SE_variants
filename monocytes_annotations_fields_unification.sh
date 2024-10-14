#!/bin/bash

##### как уйти от всех этих \t???

## 4. unifying bed file (so it all fields are the same as in other annotation files) 
awk -v OFS="\t" \
'{print $0 ".\t.\t.\t.\t.\t.\t.\t.\t.\t.\t.\t.\t.\t.\t.\t.\t.\t.\t.\t.\t.\t.\t.\t.\t.\t.\t.\t" "bg"}' /home/avasileva/project/genome_ann/bg/bg_all_chopped.bed > \
/home/avasileva/project/genome_ann/bg/bg_all_fields.bed


