PRSice-2 demo pipeline (1000G chr22 + GIANT BMI)
================

## Aim

This repository demonstrates an end-to-end **polygenic score (PRS)**
workflow using public data:

- **Target genotype QC**: Filtering samples and variants using PLINK2.
- **Population Structure**: LD pruning and Principal Component Analysis
  (PCA).
- **PRS Construction**: Using PRSice-2 (Clumping + Thresholding method).
- **Visualizations**: Including PCA clusters, PRS distribution, and
  score-ancestry correlation.

## Data Sources

- **Target Data (Genotype)**: `1000 Genomes Project` Phase 3 (Chromosome
  22).
  - File:
    `ALL.chr22.phase3_shapeit2_mvncall_integrated_v5b.20130502.genotypes.vcf.gz`
- **Base Data (Summary Statistics)**: GIANT + UK Biobank BMI
  Meta-analysis (2018).
  - File: `Meta-analysis_Locke_et_al+UKBiobank_2018_UPDATED.txt.gz`

> **Technical Note on Harmonization**: Since the source VCF lacks
> standard rsID identifiers (`ID=.`), variants were harmonized using
> **CHR:POS** (Chromosome:Position) coordinates to ensure accurate
> matching between the Base and Target datasets.

## Software

| Software   | Version       | Build/Date |
|:-----------|:--------------|:-----------|
| **PLINK2** | v2.00a5.12 M1 | 2024-06-25 |
| **PRSice** | v2.3.5        | 2021-09-20 |
| **R**      | v4.5.1        | 2025-06-13 |

## Repository Structure

``` text
.
├── scripts/          # Bash and R scripts
├── data/
│   ├── raw/          # Raw downloaded files (not committed)
│   └── processed/    # Derived files (not committed)
├── results/
│   ├── figures/      # Generated plots
│   └── prsice/       # PRSice-2 output files (excluding files >100MB)
└── logs/             # Run logs (not committed)
```

## How to Run (Mac/Linux)

### 1) QC and PCA

``` bash
bash scripts/01_qc.sh | tee logs/01_qc.log
Rscript scripts/02_plot_pca.R
```

### 2) Format GWAS summary stats

``` bash
Rscript scripts/03_format_gwas.R | tee logs/03_format_gwas.log
```

### 3) PRSice-2

``` bash
bash scripts/04_prsice.sh | tee logs/04_prsice.log
```

### 4) Plot PRS outputs

``` bash
Rscript scripts/05_plot_prs.R | tee logs/05_plot_prs.log
```

## Notes / key Implementation Details

- PCA is computed on LD-pruned variants..
- PRS is computed by PRSice-2 using clumping + thresholding across
  multiple p-value thresholds.
- A **dummy continuous phenotype** was used to allow PRSice-2 to
  complete an end-to-end run in this demonstration.
