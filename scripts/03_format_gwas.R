infile <- "data/raw/GIANT_BMI.txt"
outfile <- "data/processed/GIANT_BMI_for_PRSice.txt"

g <- read.table(infile, header=TRUE, sep="\t", quote="", comment.char="", stringsAsFactors=FALSE)

print(colnames(g))

# Standardize the columns
out <- data.frame(
  SNP = paste0(g$CHR, ":", g$POS),
  A1  = g$Tested_Allele,
  A2  = g$Other_Allele,
  BETA = g$BETA,
  P   = g$P
)

# Remove missing / weird rows
nrow(out)
out <- out[complete.cases(out), ]
nrow(out)

# If duplicates exist, keep the row with the smallest p-value
out <- out[order(out$SNP, out$P), ]
out <- out[!duplicated(out$SNP), ]
nrow(out)

write.table(out, outfile, quote=FALSE, row.names=FALSE, sep="\t")