# Save each SE to a separate file
sort -k14,14 se_e_filtered.bed | uniq -f 13 --group | awk -v RS="\n\n" '{
   filename = "/home/avasileva/temp/output_" ++count ".txt"
   print $0 > filename
}' 

for filename in /home/avasileva/temp/*; \
do \
variable=$(awk 'NR==1 {for (i = 11; i <= NF; i++) {printf "%s\t ", $i}; printf "\n"}' "$filename");  \
bedops --complement  "$filename" | \
awk  -v var="$variable" '{print $0 "\t.\t.\t.\t.\t.\t.\t.\t" var "SE_S"}' >> \
se_spacers.bed; \
done 
