# Bacline-NF: A Modular and Parallel Genomic Annotation Workflow

**Author:** Shaunak Raole  
**Course:** BIOL7210 - Computational Genomics  
**Assignment:** Workflow Exercise  
**Version:** 1.0  
**Nextflow Version:** v24.10.5  
**OS/Arch Used:** macOS 14 (Apple Silicon, M2 Pro)  
**Package Manager:** Conda  
**Conda Environment File:** `bacline.yaml`

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

[workflow_diagram](!workflow-nf.png)

## 🧪 Test Dataset

Test FASTQ files are provided in `data/raw_fastqs/`. These are **subsetted versions (~40,000 lines)** of:

- SRR33066375  
- SRR33066376  
- SRR33066377

## Usage

### 1. Clone the Repository

```bash
git clone https://github.com/ShaunakRaole/bacline-nf
cd bacline-nf
```

### 2. Create and Activate the Conda Environment

> This environment includes all required tools and Nextflow itself.

```bash
CONDA_SUBDIR=osx-64 conda env create -f bacline.yaml
conda activate bacline
```

### 3. Run the Workflow

> Make sure you are in the root directory (`bacline-nf`) when running this command:

```bash
nextflow run main.nf
```

## 📁 Directory Structure

```
bacline-nf/
├── bin/                      # Shell scripts
├── bacline.yaml              # Conda env YAML
├── data/raw_fastqs/          # Subsampled test data
├── main.nf                   # Nextflow DSL2 script
├── results/                  # Published results
├── resources/                # For future implementation of AMRFinder
└── README.md
```

---

## 🔧 Tools Used

| Tool         | Function                  | Source    |
|--------------|---------------------------|-----------|
| Trimmomatic  | Adapter/quality trimming  | bioconda  |
| SKESA        | Genome assembly           | bioconda  |
| Prodigal     | Gene prediction           | bioconda  |
| Prokka       | Functional annotation     | bioconda  |

---

## ✅ Features Demonstrated

- ✅ Sequential flow: `trimReads → assembleSkesa → genePredAmr`
- ✅ Parallel flow: `assembleSkesa → [ genePredAmr + runProkka ]`
- ✅ Reproducibility using Conda environments
- ✅ All outputs published to `results/`
- ✅ Test data and pipeline <30 min runtime

---
