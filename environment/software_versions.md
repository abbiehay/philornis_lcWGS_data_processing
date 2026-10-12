# Software versions and references

Software versions used for *Philornis downsi* low-coverage whole-genome sequencing (lcWGS) processing. Most software was installed using Miniconda, except for Trimmomatic, which was installed directly on the HPC server.

## Software versions

- [FastQC](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/): 0.12.1 ([Andrews, 2010](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/))
- [MultiQC](https://github.com/MultiQC/MultiQC): 1.19 ([Ewels et al., 2016](https://doi.org/10.1093/bioinformatics/btw354))
- [Trimmomatic](https://github.com/usadellab/Trimmomatic): 0.39 ([Bolger et al., 2014](https://doi.org/10.1093/bioinformatics/btu170))
- [fastp](https://github.com/OpenGene/fastp): 0.24.0 ([Chen et al., 2018](https://doi.org/10.1093/bioinformatics/bty560))
- [NextGenMap](https://github.com/Cibiv/NextGenMap): 0.5.5 ([Sedlazeck et al., 2013](https://doi.org/10.1093/bioinformatics/btt468))
- [SAMtools](https://github.com/samtools/samtools): 1.19.2 ([Li et al., 2009](https://doi.org/10.1093/bioinformatics/btp352))
- [Picard](https://broadinstitute.github.io/picard/): 2.18.29
- [BamUtil](https://github.com/statgen/bamUtil): 1.0.15 ([Jun et al., 2015](https://doi.org/10.1101/gr.176552.114))
- [Java (OpenJDK)](https://openjdk.org/): 17.0.14-internal
- [R](https://www.r-project.org/): 4.3.3 ([R Core Team, 2024](https://www.r-project.org/))
- [Conda](https://github.com/conda/conda): 26.1.0

## References

Andrews, S. (2010). *FastQC: A Quality Control Tool for High Throughput Sequence Data*. Babraham Bioinformatics. https://www.bioinformatics.babraham.ac.uk/projects/fastqc/
Bolger, A. M., Lohse, M., & Usadel, B. (2014). Trimmomatic: A flexible trimmer for Illumina sequence data. *Bioinformatics*, 30(15), 2114–2120. https://doi.org/10.1093/bioinformatics/btu170
Broad Institute. *Picard Toolkit*. https://broadinstitute.github.io/picard/
Chen, S., Zhou, Y., Chen, Y., & Gu, J. (2018). fastp: An ultra-fast all-in-one FASTQ preprocessor. *Bioinformatics*, 34(17), i884–i890. https://doi.org/10.1093/bioinformatics/bty560
Ewels, P., Magnusson, M., Lundin, S., & Käller, M. (2016). MultiQC: Summarize analysis results for multiple tools and samples in a single report. *Bioinformatics*, 32(19), 3047–3048. https://doi.org/10.1093/bioinformatics/btw354
Jun, G., Wing, M. K., Abecasis, G. R., & Kang, H. M. (2015). An efficient and scalable analysis framework for variant extraction and refinement from population-scale DNA sequence data. *Genome Research*, 25(6), 918–925. https://doi.org/10.1101/gr.176552.114
Li, H., Handsaker, B., Wysoker, A., Fennell, T., Ruan, J., Homer, N., Marth, G., Abecasis, G., & Durbin, R. (2009). The Sequence Alignment/Map format and SAMtools. *Bioinformatics*, 25(16), 2078–2079. https://doi.org/10.1093/bioinformatics/btp352
R Core Team. (2024). *R: A Language and Environment for Statistical Computing*. R Foundation for Statistical Computing, Vienna, Austria. https://www.R-project.org/
Sedlazeck, F. J., Rescheneder, P., & von Haeseler, A. (2013). NextGenMap: Fast and accurate read mapping in highly polymorphic genomes. *Bioinformatics*, 29(21), 2790–2791. https://doi.org/10.1093/bioinformatics/btt468
