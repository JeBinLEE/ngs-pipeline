# ngs-pipeline
This project is a modified version of the original software by [Tomas Bencomo](https://github.com/tjbencomo/ngs-pipeline).

Somatic variant calling pipeline for whole exome and whole genome sequencing (WES & WGS). The pipeline uses Mutect2 to identify variants and mostly follows GATK Best Practices. SLURM execution functionality allows the workflow to run on Stanford's Sherlock computing cluster.

## Original License
This software is licensed under the MIT License (see LICENSE file for details).

# Prerequisites
# References
You'll need a reference genome. The GRCh38 (hg38) genome is available on the Broad's GATK [website](https://gatk.broadinstitute.org/hc/en-us/articles/360035890811-Resource-bundle) .
You can obtain a .BED file containing the necessary WES region information from [UCSC Table Browser](https://genome.ucsc.edu/cgi-bin/hgTables).

# Input Files
The pipeline takes paired end (PE) FASTQ files as input. Samples can be normal-tumor pairs or tumor-only individual sample. Samples can be divided into multiple read groups (see units.csv) or one pair of FASTQ files per sample.

You'll also need a BED file with a list of target regions. For WES this is usually the capture kit regions. For WGS this can be the entire genome or a whitelist file that excludes problematic regions. A WGS calling region file is available in the GATK Resource Bundle (it will need to be converted from interval_list format to BED format).

NOTE If you have WES and WGS samples to analyze, create two separate instances of the workflow and run the samples separately.

# Software
Snakemake is required to run the pipeline. It is recommended users have Singularity installed to take advantage of preconfigured Docker containers for full reproducibility. If you don't want to use Singularity, you should download all required software (see workflow files) and ensure they are in your path.

# Setup
Clone this repository or create a new repository using this workflow as a template
Edit patients.csv and units.csv with the details for your analysis. See the schemas/ directory for details about each file.
Configure config.yml. See schemas/config.schema.yaml for info about each required field. Multiplexed samples should be differentiated with the readgroup column. Sequencing data must be paired, so both fq1 and fq2 are required.

# Usage
After finishing the setup, inside the repo's base directory with Snakefile do a dry run to check for errors
```
snakemake -n
```
Once you're ready to run the analysis type
```
snakemake --use-singularity -j [cores]
```
This will run the workflow locally. It is recommended you have at least 20GB of storage available as the Singularity containers take up around 8GB and the output files can be very large depending on the number of samples and sequencing depth.

The pipeline produces two key files: mafs/variants.maf and qc/multiqc_report.html.

variants.maf includes somatic variants from all samples that passed Mutect2 filtering. They have been annotated with VEP and a single effect has been chosen by vcf2maf using the Ensembl database. Ensembl uses its canonical isoforms for effect selection. Other isoforms can be specified with the alternate_isoforms field in config.yaml. See the cBioPortal override isoforms for file formatting.

multiqc_report.html includes quality metrics like coverage for the fully processed BAM files. Individual VCF files for each sample prior VEP annotation are found as vcfs/{patient}.vcf. VEP annotated VCFs are found as vcfs/{patient}.vep.vcf.





# Citations
This pipeline is based on dna-seq-gatk-variant-calling by [Johannes Köster](https://github.com/snakemake-workflows/dna-seq-gatk-variant-calling). If you use ngs-pipeline, please use citations.md to cite the necessary software tools.
