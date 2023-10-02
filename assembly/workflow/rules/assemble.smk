
rule flye:
  input: lambda wildcards: samples[wildcards.sample].longread_fastq
  output: "results/{sample}/assembly.fasta", "results/{sample}/assembly_info.txt"
  threads: config["threads"]
  params:
    genome_size = config["ref"]["genome_size"],
    outdir = "results/{sample}"

  shell:
    """
    flye \
      --pacbio-hifi {input} \
      --genome-size {params.genome_size} \
      --threads {threads} \
      --out-dir {params.outdir}
    """

