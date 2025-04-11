#!/usr/bin/env bash
set -euo pipefail

# Usage: trim_reads.sh <sample> <read1> <read2> <output_dir> <adapter_file>
if [ "$#" -ne 5 ]; then
    echo "Usage: $0 <sample> <read1> <read2> <output_dir> <adapter_file>"
    exit 1
fi

sample="$1"
read1="$2"
read2="$3"
output_dir="$4"
adapters="$5"

mkdir -p "${output_dir}"

echo "Running Trimmomatic for sample '${sample}'..."
trimmomatic PE -threads 4 \
  "${read1}" "${read2}" \
  "${output_dir}/${sample}_R1_paired.fq.gz" "${output_dir}/${sample}_R1_unpaired.fq.gz" \
  "${output_dir}/${sample}_R2_paired.fq.gz" "${output_dir}/${sample}_R2_unpaired.fq.gz" \
  ILLUMINACLIP:"${adapters}":2:30:10 \
  LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
