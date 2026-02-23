#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <directory_with_fastq_files>"
    exit 1
fi

INPUT_DIR="$1"
OUTPUT_FILE="samplesheet.csv"

if [ ! -d "$INPUT_DIR" ]; then
    echo "Error: Directory '$INPUT_DIR' does not exist."
    exit 1
fi

echo "patient,sample,lane,fastq_1,fastq_2" > "$OUTPUT_FILE"

for r1 in "${INPUT_DIR}"/*_R1_merged.fastq.gz
do
    [ -e "$r1" ] || continue

    r1_base=$(basename "$r1")
    sample="${r1_base%_R1_merged.fastq.gz}"

    r2="${INPUT_DIR}/${sample}_R2_merged.fastq.gz"

    if [[ -f "$r2" ]]; then
        r2_base=$(basename "$r2")
        echo "${sample},${sample},L001,${r1_base},${r2_base}" >> "$OUTPUT_FILE"
    fi
done

echo "Samplesheet created: $OUTPUT_FILE"