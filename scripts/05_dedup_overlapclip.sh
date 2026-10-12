#!/bin/bash

BAMLIST=/path/to/sample_lists/All_Bams_P5_initial.txt # Path to a list of bam files.

## Loop over each sample
for SAMPLEBAM in `cat $BAMLIST`; do
  echo "Starting processing for sample: $SAMPLEBAM"

  ## Remove duplicates and print dupstat file
  picard MarkDuplicates \
    I=/path/to/bam_historic${SAMPLEBAM}.bam \
    O=/path/to/bam_historic${SAMPLEBAM}_dedup.bam \
    M=/path/to/bam_historic${SAMPLEBAM}_dupstat.txt \
    REMOVE_DUPLICATES=true \
    TMP_DIR=/path/to/tmp \
    VERBOSITY=INFO \
    QUIET=false \
    VALIDATION_STRINGENCY=STRICT \
    COMPRESSION_LEVEL=5 \
    MAX_RECORDS_IN_RAM=1000000 \
    -XX:ParallelGCThreads=20 \
    -Xmx16g  ## Allocate 16GB of heap memory for Picard
  
  # Check if picard command was successful
  if [ $? -eq 0 ]; then
    echo "Successfully removed duplicates for sample: $SAMPLEBAM"
  else
    echo "Error occurred while removing duplicates for sample: $SAMPLEBAM"
    continue  ## Skip this sample and move to the next one
  fi

  ## Clip overlapping paired-end reads (only necessary for paired-end data, so if you're only running SE samples, you can comment this step out)
  bam clipOverlap \
    --in /path/to/bam_historic${SAMPLEBAM}_dedup.bam \
    --out /path/to/bam_historic${SAMPLEBAM}_dedup_overlapclip.bam \
    --stats 
    
  # Check if bam clipOverlap was successful
  if [ $? -eq 0 ]; then
    echo "Successfully clipped overlapping reads for sample: $SAMPLEBAM"

    # Remove the intermediate deduplicated BAM file
    rm /path/to/bam_historic${SAMPLEBAM}_dedup.bam
    echo "Removed intermediate dedup BAM for sample: $SAMPLEBAM"
  else
    echo "Error occurred while clipping overlapping reads for sample: $SAMPLEBAM"
    continue  ## Skip this sample and move to the next one
  fi  

  echo "Processing completed for sample: $SAMPLEBAM"
done