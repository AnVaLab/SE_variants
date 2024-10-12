#!/bin/bash

# creating a working folder
mkdir ~/project/combined_annotation
cd ~/project/combined_annotation

# adding information about enhancers belonging to SE
bedtools intersect -loj -a ~/project/enhancers/te_monocytes.bed \
-b ~/project/se/SE_only_cd14plus_monocyte_norownumb_SEA00101.bed > enhancers_refined_se_e.bed 

# this will leave information about SE enhancer elements and typical enhancers

# разделяем энхансеры и СЭ в разные файлы, чтобы с ними было проще работать, по отдельности
awk '$(NF-1)=="SE" {print $0}' /home/avasileva/project/combined_annotation/enhancers_refined_se_e.bed > /home/avasileva/project/se/se_e_elements.bed;
awk '$(NF-1)!="SE" {print $0}' /home/avasileva/project/combined_annotation/enhancers_refined_se_e.bed > /home/avasileva/project/enhancers/te_only.bed;


# считаем число энхансеров в каждом СЭ
awk -F"\t" '{se[$(NF-15)]++} END {for (s in se) print s, se[s]}' /home/avasileva/project/combined_annotation/se_e.bed | sort -nk2 > se_elem_numb.txt

# removing SE with only 1 enhancer
# NR - номер текущей записи
awk -F"\t" '{
    count[$(NF-15)]++
    records[NR] = $0  # Сохраняем каждую запись
    se_id[NR] = $(NF-15)
} 
# здесь NR равно общему числу строк
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
}' /home/avasileva/project/combined_annotation/se_e.bed >  /home/avasileva/project/combined_annotation/se_e_filtered.bed

# проверяем результат
awk -F"\t" '{se[$(NF-15)]++} END {for (s in se) print s, se[s]}' /home/avasileva/project/combined_annotation/se_e_filtered.bed | sort -nk2 | head -10
