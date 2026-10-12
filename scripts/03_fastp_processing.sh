#!/bin/bash

# Define paths to sample files, list, table
SAMPLELIST=/path/to/sample_lists/fastp_list_p5.txt
SAMPLETABLE=/path/to/sample_lists/fastp_table_p5.tsv
RAWFASTQDIR=/path/to/trimmed_p5/

# Define suffix for forward and reverse files. This is anything in the file after what you defined as the "Prefix" in your sample table (Prefix + Suffix = total file name)
RAWFASTQSUFFIX1=_adapterclipped_qualitytrimmed_f_paired.fastq.gz
RAWFASTQSUFFIX2=_adapterclipped_qualitytrimmed_r_paired.fastq.gz

# Define fasta file containing overrepresented sequences.
# Created from the overrepresented sequences remaining in MultiQC after trimmomatic processing
ADAPTERS=/path/to/Files_Plate3/adapter_files/Overrepresented.fa

# Loop over each sample in SAMPLELIST
for SAMPLEFILE in $(cat "$SAMPLELIST"); do
    # Extract relevant values from the sample table
    SAMPLE_ID=$(grep -P "^${SAMPLEFILE}\t" "$SAMPLETABLE" | cut -f 4)
    POP_ID=$(grep -P "^${SAMPLEFILE}\t" "$SAMPLETABLE" | cut -f 5)
    SEQ_ID=$(grep -P "^${SAMPLEFILE}\t" "$SAMPLETABLE" | cut -f 3)
    LANE_ID=$(grep -P "^${SAMPLEFILE}\t" "$SAMPLETABLE" | cut -f 2)
    DATATYPE=$(grep -P "^${SAMPLEFILE}\t" "$SAMPLETABLE" | cut -f 6)

    # Construct unique ID and file paths
    SAMPLE_UNIQ_ID="${SAMPLE_ID}_${POP_ID}_${SEQ_ID}_${LANE_ID}"
    RAWFASTQ_ID="${RAWFASTQDIR}${SAMPLEFILE}"
    SAMPLEADAPT="/path/to/fastp_p5/${SAMPLE_UNIQ_ID}"

    # Running fastp over the defined loop to process files
    # Process paired-end reads
    # -c, --correction: enable base correction in overlapped regions (only for PE data), default is disabled
    # -g, --trim_poly_g: force polyG tail trimming, by default trimming is automatically enabled for Illumina NextSeq/NovaSeq data
    # -D, --dedup: enable deduplication to drop the duplicated reads/pairs
    # -w, --thread: specifies number of threads
    # -l, --length_required: reads shorter than length_required will be discarded, default is 15. (int [=15])
    #reporting file -j, --json: the json format report file name (string [=fastp.json])
    #reporting file  -h, --html: the html format report file name (string [=fastp.html])
    #reporting file -R, --report_title: should be quoted with ' or ", default is "fastp report" (string [=fastp report])
    if [ "$DATATYPE" = "pe" ]; then
        if ! /path/to/fastp --in1 "${RAWFASTQ_ID}${RAWFASTQSUFFIX1}" --in2 "${RAWFASTQ_ID}${RAWFASTQSUFFIX2}" \
            --out1 "${SAMPLEADAPT}_adapterclipped_qualitytrimmed_polygremoved_f_paired.fastq.gz" \
            --out2 "${SAMPLEADAPT}_adapterclipped_qualitytrimmed_polygremoved_r_paired.fastq.gz" \
            --adapter_fasta "$ADAPTERS" \
            -c -g -D -h "${SAMPLEADAPT}_polygremoved.html" -j "${SAMPLEADAPT}_polygremoved.json" \
            -R "${SAMPLEADAPT}_overrepresent_removed.report" -w 20 -l 30 --overlap_len_require 15 2> "${SAMPLEADAPT}_polygremoved.log"; then
            echo "Error processing $SAMPLEFILE. Check ${SAMPLEADAPT}_polygremoved.log for details."
            continue
        fi
    else
        echo "Warning: Unsupported DATATYPE $DATATYPE for $SAMPLEFILE. Skipping..."
        continue
    fi
done
