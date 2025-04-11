#!/usr/bin/env bash
set -euo pipefail

# Usage: assemble_skesa.sh <sample> <read1> <read2> <output_dir>
if [ "$#" -ne 4 ]; then
    echo "Usage: $0 <sample> <read1> <read2> <output_dir>"
    exit 1
fi

sample="$1"
read1="$2"
read2="$3"
output_dir="$4"

mkdir -p "${output_dir}"

echo "Running SKESA for sample '${sample}'..."
skesa --reads "${read1},${read2}" --cores 4 --min_contig 1000 --contigs_out "${output_dir}/${sample}.fna"
echo "SKESA assembly completed for sample '${sample}'."
