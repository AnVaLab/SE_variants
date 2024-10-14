#!/bin/bash

# Enhancer elements in SE were defined by intersecting SEA and ENCODE. 
# Since nhancer coordinated differ in SEA and ENCODE inconcistencies were witnessed: in some SE start/end coordinates did not overlap enhancers,
# some SE concist only out of 1 ENCODE enhancer, which contradicts SE definition. We decided to exclude those SE.

## 1. creating working folder
mkdir -p /home/avasileva/project/monocytes/se
cd  /home/avasileva/project/monocytes/se

## 2. counting number of enhancers in each SE
awk -F"\t" '{se[$(NF-15)]++} END {for (s in se) print s, se[s]}' se_e.bed | sort -nk2 > se_elem_numb.txt

## 3. removing SE with only 1 enhancer
awk -F"\t" '{
    count[$(NF-15)]++
    records[NR] = $0  # Сохраняем каждую запись
    se_id[NR] = $(NF-15)
} 
# here NR equals the total number of records
END {
    for (key in count) {
        if (count[key] > 1) {
            for (i = 1; i <= NR; i++) {
                if (se_id[i] == key) {
                    print records[i]  # Печатаем записи, которые соответствуют критерию
                }
            }
        }
    }
}' se_e.bed >  se_e_filtered.bed

# result veridication
awk -F"\t" '{se[$(NF-15)]++} END {for (s in se) print s, se[s]}' se_e_filtered.bed | sort -nk2 | head -10
