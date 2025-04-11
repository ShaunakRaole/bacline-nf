# Bacline-NF: A Modular and Parallel Genomic Annotation Workflow

**Author:** Shaunak Raole  
**Course:** BIOL7210 - Computational Genomics  
**Assignment:** Workflow Exercise  
**Version:** 1.0  
**Nextflow Version:** v24.10.5  
**OS/Arch Used:** macOS 14 (Apple Silicon, M1 Pro)  
**Package Manager:** Conda  
**Conda Environment File:** `env/bacline.yaml`

---

## Objective

To create a portable and reproducible Nextflow workflow that demonstrates:

- **Sequential execution** — one step’s output is passed as input to the next.
- **Parallel execution** — independent steps run simultaneously.
- **Reproducibility** via version control, environment specification, and modular execution.

---

## Workflow Overview

This workflow performs the following:

1. **Trimming**: Clean raw FASTQ files using Trimmomatic.
2. **Assembly**: Assemble the cleaned reads using SKESA.
3. **Gene Prediction**: Predict genes from assemblies using Prodigal.
4. **Annotation**: Annotate assembled genomes using Prokka.

**Execution Flow:**

