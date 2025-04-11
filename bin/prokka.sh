#!/usr/bin/env bash
set -euo pipefail

# # Activate conda env
# echo "Activating conda environment 'bacline_nf'..."
# eval "$(conda shell.bash hook)"
# conda activate bacline_nf

# Usage: run_prokka.sh <sample> <assembly.fna> <output_dir>
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <sample> <assembly.fna> <output_dir>"
    exit 1
fi

sample="$1"
assembly="$2"
output_dir="$3"

# Create output directory if it doesn't exist
mkdir -p "${output_dir}"

# Check if Prokka is available
if ! command -v prokka &>/dev/null; then
    echo "Error: Prokka is not available in the environment."
    exit 1
fi

echo "Running Prokka for sample '${sample}'..."

prokka \
    --outdir "${output_dir}" \
    --prefix "${sample}" \
    --force \
    --cpus 4 \
    "${assembly}"

echo "Prokka annotation completed for sample '${sample}'. Output in ${output_dir}"
