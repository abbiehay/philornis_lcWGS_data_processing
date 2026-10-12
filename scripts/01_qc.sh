# FastQC and MultiQC on raw FASTQ files

# Install FastQC and MultiQC in the conda environment
conda install fastqc
conda install multiqc

# Run FastQC on raw forward and reverse reads
fastqc --threads 20 ./*R1.fastq.gz ./*R2.fastq.gz -o ./QC_raw/

# Summarise raw-read FastQC reports with MultiQC
multiqc ./QC_raw/ -o ./multiqc_raw_fastp/

# FastQC and MultiQC were also run on FASTQ files processed with Trimmomatic and fastp.