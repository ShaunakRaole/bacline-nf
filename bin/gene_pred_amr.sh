#!/usr/bin/env bash
set -euo pipefail

# Usage: gene_pred_amr.sh <sample> <assembly.fna> <db_path>
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <sample> <assembly.fna> <db_path>"
    exit 1
fi

sample="$1"
assembly="$2"
db_path="$3"

mkdir -p "${db_path}"  # (This is optional if the DB is already there)

echo "Running Prodigal for gene prediction on ${sample}..."
prodigal -i "${assembly}" \
         -a "${sample}_proteins.faa" \
         -d "${sample}_cds.fna" \
         -f gff \
         -o "${sample}.gff" \
         -p meta

# echo "Running AMRFinderPlus for functional annotation on ${sample}..."
# amrfinder -n "${sample}_cds.fna" \
#           -o "${sample}_amrfinder.csv" \
#           -d "${db_path}"

echo "Gene prediction and AMR annotation completed for ${sample}."
