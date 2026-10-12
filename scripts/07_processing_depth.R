# Process depth using R in a Conda environment on the HPC
# rather than RStudio on a local drive, as the files are large and memory is an issue.

# Install R in the conda environment if required:
# conda install r-essentials

# Run this script with:
# Rscript processing_depth.R

# R Script:

# Load packages
library(tidyverse)
library(parallel)

basedir <- "/path/to/Philornis"  # Base directory for the files below
bam_list <- read_lines("/path/to/sample_lists/All_Bams_P5_initial.txt") # List of BAM files to process

# Calculate depth statistics
output_list <- list()

for (i in 1:length(bam_list)) {
  bamfile <- bam_list[i]
  depth <- read_tsv(paste0(basedir, "/bam_historic/", bamfile, "_dedup_overlapclip.bam.depth.gz"), col_names = FALSE)$X1 # Include the full suffix after the name specified in the BAM list

  stats <- tibble(
    bamfile,
    mean_depth = mean(depth),
    sd_depth = sd(depth),
    mean_depth_nonzero = mean(depth[depth > 0]),
    mean_depth_within2sd = mean(depth[depth < mean_depth + 2 * sd_depth]),
    median = median(depth),
    proportion_of_reference_covered = mean(depth > 0)
  )

  output_list[[i]] <- stats
}

output <- bind_rows(output_list)
write.csv(output, "/path/to/depth_p5/depth_stats_p5.csv", row.names = FALSE)

# Export the output CSV for visualisation in RStudio
