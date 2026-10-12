#!/bin/bash

# Variables
SAMPLELIST=/path/to/sample_lists/fastp_list_p5.txt
SAMPLETABLE=/path/to/sample_lists/fastp_table_p5.tsv
FASTQDIR=/path/to/fastp_p5/
FASTQSUFFIX1=_adapterclipped_qualitytrimmed_polygremoved_f_paired.fastq.gz
FASTQSUFFIX2=_adapterclipped_qualitytrimmed_polygremoved_r_paired.fastq.gz
REFERENCE=/path/to/reference_genome/GCA_019455685.1_ASM1945568v1_genomic.fna
LOGFILE=/path/to/logs/NGM_P5_log.txt

# Start logging
exec > >(tee -i "$LOGFILE") 2>&1
echo "Mapping Script Started at $(date)"

# Loop over samples
for SAMPLEFILE in `cat $SAMPLELIST`; do
  # Extract information from the sample table
  SAMPLE_ID=`grep -P "${SAMPLEFILE}\t" $SAMPLETABLE | cut -f 4`
  POP_ID=`grep -P "${SAMPLEFILE}\t" $SAMPLETABLE | cut -f 5`
  SEQ_ID=`grep -P "${SAMPLEFILE}\t" $SAMPLETABLE | cut -f 3`
  LANE_ID=`grep -P "${SAMPLEFILE}\t" $SAMPLETABLE | cut -f 2`
  SAMPLE_UNIQ_ID=$SAMPLE_ID'_'$POP_ID'_'$SEQ_ID'_'$LANE_ID
  DATATYPE=`grep -P "${SAMPLEFILE}\t" $SAMPLETABLE | cut -f 6`
  PU=$LANE_ID

  # Define input file path
  SAMPLETOMAP=$FASTQDIR$SAMPLE_UNIQ_ID
  
  # Define output file path
  SAMPLEBAM=/path/to/bam_plate5/$SAMPLE_UNIQ_ID

  # Log progress
  echo "Processing sample: $SAMPLE_UNIQ_ID"

  # Map reads using NextGenMap
  if [ $DATATYPE = pe ]; then
    ngm -r $REFERENCE -1 $SAMPLETOMAP$FASTQSUFFIX1 -2 $SAMPLETOMAP$FASTQSUFFIX2 -o $SAMPLEBAM'_'$DATATYPE'_ngm.sam' \
        -t 20 --rg-id $SAMPLE_UNIQ_ID --rg-sm $SAMPLE_ID --rg-lb $SAMPLE_ID --rg-pu $PU --rg-pl ILLUMINA

  elif [ $DATATYPE = se ]; then
    ngm -r $REFERENCE -q $SAMPLETOMAP$FASTQSUFFIX1 -o $SAMPLEBAM'_'$DATATYPE'_ngm.sam' \
        -t 20 --rg-id $SAMPLE_UNIQ_ID --rg-sm $SAMPLE_ID --rg-lb $SAMPLE_ID --rg-pu $PU --rg-pl ILLUMINA
  fi

  # Convert SAM to BAM, remove SAM file
  samtools view -bS -F 4 $SAMPLEBAM'_'$DATATYPE'_ngm.sam' > $SAMPLEBAM'_'$DATATYPE'_ngm.bam'
  rm -f $SAMPLEBAM'_'$DATATYPE'_ngm.sam'
  
  # Filter mapped reads to retain high mapping-quality reads
  # Remove poorly mapped reads (non-unique mappings and mapping quality < 20)
  samtools view -h -q 20 $SAMPLEBAM'_'$DATATYPE'_ngm.bam' | \
  samtools view -buS - | \
  samtools sort -o $SAMPLEBAM'_'$DATATYPE'_ngm_minq20_sorted.bam'

done
