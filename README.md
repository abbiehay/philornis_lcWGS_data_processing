# philornis_lcWGS_data_processing

## Overview
This repository contains scripts for processing low-coverage whole-genome sequencing (lcWGS) data from Philornis downsi, adapted from the [Physalia lcWGS pipeline](https://github.com/nt246/physalia-lcwgs/tree/main), with modifications to accommodate the sequencing data and processing requirements of this study.

The workflow includes read quality control, adapter and quality trimming, read mapping, duplicate removal, overlap clipping, and depth-of-coverage calculations. These scripts support genomic analyses across multiple research projects, with paper-specific statistical analyses maintained in separate repositories.

## Sample lists and metadata tables

The workflow uses two input files:

fastq_list.txt contains one sample file prefix per line, without a header. Each prefix corresponds to a sample's paired-end FASTQ files and must match the prefix in fastq_table.tsv. The list can be modified to process all samples or a selected subset.

Example:
FL08_22NT3LLT3_TTACTCCACA-GACACCGATG_L005
FL103_22NT3LLT3_CATTAGTGCG-TGACTACATA_L005
FL113_22NT3LLT3_ATGGTTGACT-GGCCTGTCCT_L005
FL117_22NT3LLT3_ATTCCATAAG-TGCCTGGTGG_L005
FL124_22NT3LLT3_AGTCAGACGA-ACCAGCGACA_L005

fastq_table.tsv contains tab-separated sample metadata, including the sample prefix (prefix), sequencing lane (lane_number), sequencing library or batch (seq_id), sample identifier (sample_id), population, and sequencing type (data_type; paired-end or single-end). The table includes a header row.

Example:
| prefix | lane_number | seq_id | sample_id | population | data_type |
|---|---|---|---|---|---|
| FL08_22NT3LLT3_TTACTCCACA-GACACCGATG_L005 | lane5 | 1 | FL08 | Floreana | pe |
| FL103_22NT3LLT3_CATTAGTGCG-TGACTACATA_L005 | lane5 | 1 | FL103 | Floreana | pe |
| FL113_22NT3LLT3_ATGGTTGACT-GGCCTGTCCT_L005 | lane5 | 1 | FL113 | Floreana | pe |
| FL117_22NT3LLT3_ATTCCATAAG-TGCCTGGTGG_L005 | lane5 | 1 | FL117 | Floreana | pe |
| FL124_22NT3LLT3_AGTCAGACGA-ACCAGCGACA_L005 | lane5 | 1 | FL124 | Floreana | pe |


Prefixes must match between the two files and be updated as filenames change during processing. Associated sample metadata can be retained, provided the sample identifiers and metadata remain consistent.

## Workflow

The processing workflow comprises the following steps:

1. Read quality control

FastQC and MultiQC to assess raw read quality and summarise quality-control reports.

2. Read trimming

Trimmomatic for adapter and quality trimming, followed by fastp for poly-G tail removal where required.

3. Read mapping

NextGenMap to align reads to the reference genome.

4. BAM processing

SAMtools for SAM/BAM conversion, mapping-quality filtering, and sorting; Picard for duplicate removal; and BamUtil for clipping overlapping paired-end reads.

5. Depth of coverage

SAMtools to calculate per-position read depth, followed by R scripts to summarise depth statistics.

Repository contents

scripts/ — Bash and R scripts for genomic data processing.

sample_lists/ — Sample lists and tables used to specify samples and their associated metadata.

See the individual scripts for input requirements, output locations, and processing parameters.

## Reference genome

Reads were mapped to the female Philornis downsi reference genome (GCA_019455685.1; Romine et al., 2022).

Reference genome citation:

Romine, M. G., Knutie, S. A., Crow, C. M., Vaziri, G. J., Chaves, J. A., Koop, J. A. H., & Lamichhaney, S. (2022). The genome sequence of the avian vampire fly (Philornis downsi), an invasive nest parasite of Darwin’s finches in Galápagos. G3 Genes|Genomes|Genetics, 12, jkab414. https://doi.org/10.1093/g3journal/jkab414

## Data availability

Raw sequencing data are available through the NCBI Sequence Read Archive (SRA) under BioProject PRJNA1468418. BioSample accession numbers are SAMN60281468–SAMN60281636 and SAMN60394944–SAMN60394967.

Raw sequencing reads and large intermediate files (e.g. BAM files) are not distributed in this repository.

## Software

The workflow uses FastQC, MultiQC, Trimmomatic, fastp, NextGenMap, SAMtools, Picard, BamUtil, Java, and R. Software versions and dependencies should be recorded alongside the scripts or in an accompanying environment information file.

## Citation

If you use these scripts, please cite this repository and the associated publication where appropriate.

Repository citation: (Add the repository citation or DOI here).

Related pipeline: [Physalia lcWGS pipeline](https://github.com/nt246/physalia-lcwgs/tree/main)

Licence

See the LICENSE file for the terms governing reuse and redistribution of the code.
