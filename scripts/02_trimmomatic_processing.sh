
#!/bin/bash

SAMPLELIST=/path/to/fastqlist.txt  # Path to a list of prefixes of the raw fastq files. Can be either a subset of column 1 of your sample table, or the whole list if you want to run all at once. Trimmomatic will only run the files in this list.
SAMPLETABLE=/path/to/fastqtable.tsv  # Path to a sample table where the 1st column is the prefix of the raw fastq files. The 4th column is the sample ID, the 2nd column is the lane number, and the 3rd column is sequencing ID.
RAWFASTQDIR=/path/to/raw/ # Path to raw fastq files.
RAWFASTQSUFFIX1=_R1.fastq.gz # Suffix to raw fastq files, forward reads for paired-end data.
RAWFASTQSUFFIX2=_R2.fastq.gz # Suffix to raw fastq files, reverse reads for paired-end data.
ADAPTERS=/path/to/AmpliSeq_PE.fa # Path to adapter/index sequences.
TRIMMOMATIC=/path/to/trimmomatic-0.39.jar # Path to Trimmomatic 0.39 JAR file.
OUTPUTDIR=/path/to/trimmed_p5/ # Path to output directory.


## Loop over each sample
for SAMPLEFILE in `cat $SAMPLELIST`; do
  
  ## Extract relevant values from a table of sample, sequencing, and lane ID (here in columns 4, 3, 2, respectively) for each sequenced library
  SAMPLE_ID=`grep -P "${SAMPLEFILE}\t" $SAMPLETABLE | cut -f 4`
  POP_ID=`grep -P "${SAMPLEFILE}\t" $SAMPLETABLE | cut -f 5`
  SEQ_ID=`grep -P "${SAMPLEFILE}\t" $SAMPLETABLE | cut -f 3`
  LANE_ID=`grep -P "${SAMPLEFILE}\t" $SAMPLETABLE | cut -f 2`
  SAMPLE_UNIQ_ID=$SAMPLE_ID'_'$POP_ID'_'$SEQ_ID'_'$LANE_ID  # When a sample has been sequenced in multiple lanes, we need to be able to identify the files from each run uniquely
  
  ## Extract data type from the sample table
  DATATYPE=$(grep -P "^${SAMPLEFILE}\t" "$SAMPLETABLE" | head -n 1 | cut -f 6 | tr -d '[:space:]')
  
  ## The input and output path and file prefix
  RAWFASTQ_ID=$RAWFASTQDIR$SAMPLEFILE
  SAMPLEADAPT=${OUTPUTDIR}${SAMPLE_UNIQ_ID}
  
  ## Adapter clip the reads with Trimmomatic
  # The options for ILLUMINACLIP are: ILLUMINACLIP:<fastaWithAdaptersEtc>:<seed mismatches>:<palindrome clip threshold>:<simple clip threshold>:<minAdapterLength>:<keepBothReads>
  # The MINLENGTH drops the read if it is below the specified length in bp
  # For definitions of these options, see http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/TrimmomaticManual_V0.32.pdf
  
# Debugging line (optional):
# echo "Processing $SAMPLEFILE with data type '$DATATYPE'"

 if [ "$DATATYPE" = "pe" ]; then
      java -jar "$TRIMMOMATIC" PE -threads 15 -phred33 "$RAWFASTQ_ID$RAWFASTQSUFFIX1" "$RAWFASTQ_ID$RAWFASTQSUFFIX2" \
      "${SAMPLEADAPT}_adapterclipped_qualitytrimmed_f_paired.fastq.gz" "${SAMPLEADAPT}_adapterclipped_qualitytrimmed_f_unpaired.fastq.gz" \
      "${SAMPLEADAPT}_adapterclipped_qualitytrimmed_r_paired.fastq.gz" "${SAMPLEADAPT}_adapterclipped_qualitytrimmed_r_unpaired.fastq.gz" \
      SLIDINGWINDOW:4:20 ILLUMINACLIP:$ADAPTERS:2:30:10:2:true MINLEN:40

  elif [ "$DATATYPE" = "se" ]; then
      java -jar "$TRIMMOMATIC" SE -threads 15 -phred33 "$RAWFASTQ_ID$RAWFASTQSUFFIX1" \
      "${SAMPLEADAPT}_adapterclipped_qualitytrimmed_se.fastq.gz" SLIDINGWINDOW:4:20 ILLUMINACLIP:$ADAPTERS:2:30:10 MINLEN:40
  fi
  
done
