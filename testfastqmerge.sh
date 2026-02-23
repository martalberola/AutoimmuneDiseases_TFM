#!/bin/bash

DIR_INPUT="$1"
DIR_OUTPUT="$2"

mkdir -p "$DIR_OUTPUT"

# Get unique sample names (before _S)
samples=$(ls "$DIR_INPUT"/*.fastq.gz | \
          xargs -n1 basename | \
          sed 's/_S.*//' | \
          sort -u)

for sample in $samples; do
    echo "Processing $sample"

    # Merge R1
    cat "$DIR_INPUT"/${sample}_S*_R1_*.fastq.gz \
        > "$DIR_OUTPUT"/${sample}_R1_merged.fastq.gz

    # Merge R2
    cat "$DIR_INPUT"/${sample}_S*_R2_*.fastq.gz \
        > "$DIR_OUTPUT"/${sample}_R2_merged.fastq.gz
done
