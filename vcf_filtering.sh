#!/bin/bash

mkdir -p ~/project/variants/vcf_1000_genomes_filtered
cd ~/project/variants/vcf_1000_genomes_filtered/

mkdir ~/project/variants/vcf_1000_genomes_filtered_new

screen -S filtration 
ls *.vcf.gz | \
parallel -j 100 '\
bedtools intersect -wa -wb \
-a ~/project/variants/vcf_1000_genomes/{} \
-b /home/avasileva/project/monocytes/combined_annotation/combined_annotation.bed > \
~/project/variants/vcf_1000_genomes_filtered_new/filtered_{}'
# Ctrl+a+d # выйти из screen
# screen -ls
# screen -r 4833.DOWNLOAD_RAW # to come back to screen
# screen -X -S 13240.DOWNLOAD_raw quit  #удалить фоновое окно

# checking number of fields
ls *.vcf.gz | \
parallel -j 100 "\
cat {} | awk -F'\t' '{print NF}' | sort -n | uniq && echo {}"

mkdir ~/project/variants/vcf_1000_genomes_filtered_no_no_ref
# removing lines with <ref only>
screen -S filtration_ref
ls *.vcf.gz |
parallel -j 100 "\
awk -F'\t' '{if (\$5!=\"<NON_REF>\") print \$0}' {} > \
~/project/variants/vcf_1000_genomes_filtered_no_no_ref/{} && echo {}"

# checking number of fields
ls *.vcf.gz | \
parallel -j 100 "\
cat {} | awk -F'\t' '{print NF}' | sort -n | uniq && echo {}"

cd ~/project/variants/vcf_1000_genomes_filtered_no_no_ref
mkdir ~/project/variants/vcf_1000_genomes_filtered_no_no_ref_fields
# removing records with NF less than 40
ls *.vcf.gz | \
parallel -j 100 "\
cat {} | awk -F'\t' '{if (NF==40) print \$0}' >  ~/project/variants/vcf_1000_genomes_filtered_no_no_ref_fields/{} && echo {}"

mkdir ~/project/variants/vcf_1000_genomes_filtered_no_no_ref_fields_fields
cd  ~/project/variants/vcf_1000_genomes_filtered_no_no_ref_fields
ls *.vcf.gz | \
parallel -j 100 "\
awk -F'\t' -v OFS='\t' \
'{print \$1,\$2,\$3,\$5,\$6,\$7,\$8,\$9,\$10,\$11,\$12,\$13,\$14,\$20,\$21,\$22,\$23,\$24,\$25,\$26,\$29,\$35,\$39,\$40}' > \
~/project/variants/vcf_1000_genomes_filtered_no_no_ref_fields_fields/{} && echo {}"

не работает


mkdir ~/project/variants/vcf_1000_genomes_filtered_no_no_ref_fields_header
cd  ~/project/variants/vcf_1000_genomes_filtered_no_no_ref_fields
ls *.vcf.gz | \
parallel -j 100 --plus "\
zcat ~/project/variants/vcf_1000_genomes/{#filtered_} | \
awk '{if (\$0~/^#/) {print} else exit}' | \
cat - {} > ~/project/variants/vcf_1000_genomes_filtered_no_no_ref_fields_header/{} &&
echo '{} completed'"


# naming last columns



sed 's/^#//'

"#CHROM	POS	ID	REF	ALT	QUAL	FILTER	INFO	FORMAT	HG00096	eleven twenlve thirteen fourteen fifteen sixteen, (17) seventeen, (18) eighteen, (19) nineteen, and (20) twenty.
After this set, the third set of 21 to 30 becomes easier to learn because it has numbers starting from twenty followed by a suffix of one, two, three, and so on. For example, (21) twenty-one, (22) twenty-two, (23) twenty-three, (24) twenty-four, (25) twenty-five, (26) twenty-six, (27) twenty-seven, (28) twenty-eight, (29) twenty-nine, (30) thirty.
The next set follows the same kind of series and starts from (31) thirty-one, (32) thirty-two, (33) thirty-three, (34) thirty-four, (35) thirty-five, (36) thirty-six, (37) thirty-seven, (38) thirty-eight, (39) thirty-nine, (40) forty


el_chr
el_start
el_end
el_name
el_known
el_unknown_2
el_start
el_end
el_colours
reg_el_type
se_chr
se_start
se_end
se_id
se_length
se_cell_type
se_unknown_1
se_unknown_2
se_db
se_unknown_3
se_unknown_4
se_unknown_5
se_unknown_6
se_db_2
se_gene
se_gene_assignment_method
se_detection_method
se_se 
se_gene_type
se_element_type

awk -F"\t" '{print $1,$2,$3,$5,$6,$7,$8,$9, $10,$11, $12, $13, $14, $20, $21, $22, $23, $24, $25,$26, $29, $35,$39, $40}'



chr1	182149469	.	G	A,<NON_REF>	1118.77	.	DP=35;ExcessHet=3.0103;MLEAC=2,0;MLEAF=1.00,0.00;MQ0=0;RAW_MQ=126000.00	GT:AD:DP:GQ:PL:SB
1/1:0,33,0:33:99:1147,99,0,1147,99,1147:0,0,13,20	
chr1	182149412	182149761	gene_or_pre	.	.	.	.	.	.chr1	182143036	182154083	hg38_CD14PM_chr1_182143036	11047	CD14-positive_monocyte	-	-	SEA	0	0	0	0	SEA	ZNF648	proximal	h3k27ac	SE	coding	SE_S


# removing last columns with reg element annotation
mkdir -p ~/project/variants/vcf_1000_genomes_filtered_formatted
screen -S formatting
ls *.vcf |
parallel -j 100 "\
cat {} | sed 's/\(.*\)\tchr.*/\1/') > ~/project/variants/vcf_1000_genomes_filtered_formatted/{}.temp && \
mv ~/project/variants/vcf_1000_genomes_filtered_formatted/{}.temp ~/project/variants/vcf_1000_genomes_filtered_formatted/{} && \
echo '{} completed'"

ls *.vcf |
parallel -j 100 "\
grep 'SEA' {} && echo {}
"
cd ~/project/variants/vcf_1000_genomes_filtered/


