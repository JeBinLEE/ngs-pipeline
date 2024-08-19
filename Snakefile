singularity: "docker://continuumio/miniconda3"
include: "./rules/common.smk"

rule targets:
    input:
        expand("{ref_fasta}.{suffix}", ref_fasta=ref_fasta, suffix=file_suffixes),
        "mafs/variants.maf",
        "qc/multiqc_report.html",
#        "qc/depths.svg"
	"qc/depths.csv",
        expand("bams/{patient}.{sample_type}.bam", patient=patients, sample_type=sample_types)


include: "./rules/preprocessing.smk"
include: "./rules/calling.smk"
include: "./rules/pon.smk"
