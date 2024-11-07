# Plotting SE and enhancer length distribution

layout(mat = matrix(c(1,2), ncol=1))

se_bed <- as.data.frame(read.table("/home/an/Documents/Work/SE/SE_only_cd14plus_monocyte_norownumb_SEA00101.bed",header = FALSE, sep="\t",stringsAsFactors=FALSE, quote=""))
h=hist(se_bed$V5, 
     main = "SE length distribution in CD14+ monocyte cells (SEA db)",
     xlab = "length, bp")
abline(v = median(se_bed$V5), col = "red", lwd = 2)
text(median(se_bed$V5)+(h$mids[2]-h$mids[1])/2, max(h$counts), paste0(median(se_bed$V5)))


e_bed <- as.data.frame(read.table("/home/an/Documents/Work/SE/ENCFF900YFA_classified.bed",header = FALSE, sep="\t",stringsAsFactors=FALSE, quote=""))
e_bed$V12 = e_bed$V3-e_bed$V2
h=hist(e_bed$V12, 
     main = "Hight H3K27ac TE length distribution in CD14+ monocyte cells (ENCODE)",
     xlab = "length, bp")
abline(v = median(e_bed$V12), col = "red", lwd = 2)
text(median(e_bed$V12)+(h$mids[2]-h$mids[1])/2, max(h$counts), paste0(median(e_bed$V12)))
