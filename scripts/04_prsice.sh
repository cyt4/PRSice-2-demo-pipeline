# !/usr/bin/env bash
set -euo pipefail

# Convert the files to bed/bim/fam
plink2 \
  --pfile data/processed/qc/target_qc1_uid \
  --make-bed \
  --out data/processed/qc/target_qc1_uid_prs

PRSICE_DIR="tools/PRSice"
BASE="data/processed/GIANT_BMI_for_PRSice.txt"
TARGET="data/processed/qc/target_chrpos_prs"

OUTDIR="results/prsice"
mkdir -p "${OUTDIR}"

# PRSice
Rscript "${PRSICE_DIR}/PRSice.R" \
--prsice "${PRSICE_DIR}/PRSice_mac" \
--base "${BASE}" \
--target "${TARGET}" \
--pheno data/processed/qc/pheno_dummy.txt \
--pheno-col BMI \
--stat BETA \
--beta \
--pvalue P \
--snp SNP \
--A1 A1 \
--A2 A2 \
--clump-kb 250 \
--clump-r2 0.1 \
--bar-levels 5e-8,1e-5,1e-3,1e-2,5e-2,1e-1,5e-1,1 \
--out "${OUTDIR}/BMI_prs"
