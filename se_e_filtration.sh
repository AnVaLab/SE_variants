#!/bin/bash

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
