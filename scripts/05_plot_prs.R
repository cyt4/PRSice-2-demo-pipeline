
score_file <- "results/prsice/BMI_prs.best"
pca_file   <- "data/processed/qc/target_pca.eigenvec"

out_hist <- "results/figures/prs_hist.png"
out_scatter <- "results/figures/prs_vs_pc1.png"

prs <- read.table(score_file, header=TRUE)
pca <- read.table(pca_file, header=FALSE)
colnames(pca)[1] <- c("IID")
colnames(pca)[2] <- c("PC1")

m <- merge(prs, pca, by=c("IID"))

prs_col <- "PRS"

png(out_hist, width=900, height=700)
hist(m[[prs_col]], breaks=40, main="PRS distribution", xlab="PRS")
dev.off()

png(out_scatter, width=900, height=700)
plot(m$PC1, m[[prs_col]], pch=19, cex=0.6, xlab="PC1", ylab="PRS", main="PRS vs PC1")
dev.off()