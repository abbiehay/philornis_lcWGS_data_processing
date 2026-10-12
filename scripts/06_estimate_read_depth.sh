#!/bin/bash

# Estimate depth of coverage for each individual.
# Output files are .depth.gz files.
# Process these files with 07_processing_depth.R to generate a CSV of depth statistics.

# Path to a list of deduplicated, overlap-clipped BAM files
BAMLIST=/path/to/sample_lists/All_Bams_P5_initial.txt

# Estimate read depth from sorted, deduplicated, overlap-clipped BAM files
# $SAMPLEBAM is the name specified in BAMLIST.
# The output filename adds .depth.gz to the existing BAM filename.
for SAMPLEBAM in `cat $BAMLIST`; do
  # Count per-position depth per sample
  samtools depth /path/to/bams/${SAMPLEBAM}_dedup_overlapclip.bam | cut -f 3 | gzip > /path/to/bams/${SAMPLEBAM}_dedup_overlapclip.bam.depth.gz
done
