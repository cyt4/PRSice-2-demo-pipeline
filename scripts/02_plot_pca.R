args <- commandArgs(trailingOnly = TRUE)
eig <- args[1]
outpng <- args[2]

pca <- read.table(eig, header = FALSE)
colnames(pca)[1:2] <- c("FID","IID")
colnames(pca)[3:4] <- c("PC1","PC2")

png(outpng, width=900, height=700)
plot(pca$PC1, pca$PC2, xlab="PC1", ylab="PC2", pch=19, cex=0.6)
dev.off()