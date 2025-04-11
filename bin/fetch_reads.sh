#!/usr/bin/env bash
set -euo pipefail

# Usage: fetch_reads.sh <work_directory> <accessions_file>
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <work_directory> <accessions_file>"
    exit 1
fi

WORKDIR="$1"
ACCESSIONS_FILE="$(realpath "$2")"

# Create the raw_fastqs directory if it doesn't exist
mkdir -p "${WORKDIR}"
mkdir -p "${WORKDIR}/raw_fastqs"
cd "${WORKDIR}/raw_fastqs"

# # Activate conda env
# echo "Activating conda environment 'bacline_nf'..."
# eval "$(conda shell.bash hook)"
# conda activate bacline_nf

echo "Reading accession IDs from ${ACCESSIONS_FILE}..."
while IFS= read -r accession || [ -n "$accession" ]; do
    # Skip empty lines
    if [[ -z "$accession" ]]; then
        continue
    fi

    echo ">>> Prefetching accession: ${accession}..."
    prefetch "${accession}"

    echo ">>> Converting ${accession} to FASTQ..."
    fasterq-dump "${accession}" --outdir . --split-files --skip-technical
done < "$ACCESSIONS_FILE"

echo ">>> Compressing FASTQ files with pigz..."
pigz -9 *.fastq

echo "Finished processing accessions."
