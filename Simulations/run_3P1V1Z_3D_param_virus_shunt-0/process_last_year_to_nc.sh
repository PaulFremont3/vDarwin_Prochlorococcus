#!/bin/bash

# Check if date argument is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <date_string>"
    echo "Example: $0 20240101"
    exit 1
fi

DATE_STR=$1
TARGET_DIR="diags_mds_${DATE_STR}"

# Dimensions (Verify these match your SIZE.h)
NX=360
NY=160
NR=23

# List of prefixes and their field counts
# Format: "Prefix:NumFields"
targets=("biomass_c:25" "chl:3" "PP:3" "GR:5" "Mort:5" "VL:5")

# Sequence for the last year
iterations=$(seq 26160 240 28800)

if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: Directory $TARGET_DIR does not exist."
    exit 1
fi

echo "Moving into $TARGET_DIR..."
cd "$TARGET_DIR"

# Loop through targets
for entry in "${targets[@]}"; do
    prefix="${entry%%:*}"
    nfields="${entry##*:}"
    echo $entry
    for iter in $iterations; do
        iter_padded=$(printf "%010d" $iter)
        filename="${prefix}.${iter_padded}"

        if [ -f "${filename}.data" ]; then
            # Assuming the 'convert' executable is one level up
            ../convert_to_nc.exe "$filename" $NX $NY $NR $nfields
        else
            echo "Skipping: ${filename}.data not found."
        fi
    done
done

echo "Conversion for $DATE_STR complete."
