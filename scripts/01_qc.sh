#!/usr/bin/env bash
set -euo pipefail

IN="data/processed/1000G_chr22"
OUTDIR="data/processed/qc"
mkdir -p "${OUTDIR}"

# Basic sample/SNP missingness + MAF filter
plink2 \
  --pfile "${IN}" \
  --geno 0.02 \
  --mind 0.02 \
  --maf 0.01 \
  --make-pgen \
  --out "${OUTDIR}/target_qc1"

# Rename IDs for uniqueness
plink2 \
  --pfile data/processed/qc/target_qc1 \
  --set-all-var-ids @:#:\$r:\$a \
  --new-id-max-allele-len 50 missing \
  --make-pgen \
  --out data/processed/qc/target_qc1_uidtmp

plink2 \
  --pfile data/processed/qc/target_qc1_uidtmp \
  --rm-dup force-first \
  --set-missing-var-ids @:# \
  --make-pgen \
  --out data/processed/qc/target_qc1_uid

# LD prune for PCA
plink2 \
  --pfile data/processed/qc/target_qc1_uid \
  --indep-pairwise 200 50 0.2 \
  --out data/processed/qc/target_prune

# PCA on pruned set
plink2 \
  --pfile data/processed/qc/target_qc1_uid \
  --extract data/processed/qc/target_prune.prune.in \
  --pca approx 10 \
  --out data/processed/qc/target_pca

# Set IDs to CHR:POS for later harmonization
plink2 \
  --pfile data/processed/qc/target_qc1 \
  --set-missing-var-ids @:# \
  --rm-dup force-first \
  --make-pgen \
  --out data/processed/qc/target_qc1_chrpos

plink2 \
  --pfile data/processed/qc/target_qc1_chrpos \
  --make-bed \
  --out data/processed/qc/target_chrpos_prs

# Create a dummy phenotype file for this demo
awk 'BEGIN{print "FID IID BMI"; srand(1)} {print $1, $2, 20 + rand()*10}' \
  data/processed/qc/target_chrpos_prs.fam \
  > data/processed/qc/pheno_dummy.txt