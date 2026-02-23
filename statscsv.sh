#!/bin/bash

DIR_INPUT="$1"
OUTPUTFILE="$2"

# Header
echo -e "FileName\tSampleName\tNumberOfLines\tMultipleOf4\tWeight(bytes)" > "$OUTPUTFILE"

declare -A sample_counts

for file in "$DIR_INPUT"/*.fastq.gz; do
    filename=$(basename "$file")

    # Extract sample name (before _S)
    sample=$(echo "$filename" | sed 's/_S.*//')

    # Count lines (compressed file)
    lines=$(gzip -cd "$file" | wc -l)

    # Check if multiple of 4
    if (( lines % 4 == 0 )); then
        multiple="YES"
    else
        multiple="NO"
    fi

    # File size in bytes
    size=$(stat -c%s "$file")

    # Write to output
    echo -e "${filename}\t${sample}\t${lines}\t${multiple}\t${size}" >> "$OUTPUTFILE"

    # Count files per sample
    ((sample_counts["$sample"]++))
done

echo -e "\nSample\tNumberOfFiles" >> "$OUTPUTFILE"
for s in "${!sample_counts[@]}"; do
    echo -e "${s}\t${sample_counts[$s]}" >> "$OUTPUTFILE"
done
