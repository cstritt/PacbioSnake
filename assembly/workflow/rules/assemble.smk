
rule flye:
  input: lambda wildcards: samples[wildcards.sample].longread_fastq
  output: 
    config["outdir"] + "/{sample}/flye/assembly.fasta", 
    config["outdir"] + "/{sample}/flye/assembly_info.txt"
  threads: config["threads_per_job"]
  params:
    genome_size = config["ref"]["genome_size"],
    outdir = config["outdir"] + "/{sample}/flye",
    iterations = config["assembly_iterations"]

  shell:
    """
    flye \
      --pacbio-hifi {input} \
      --genome-size {params.genome_size} \
      --iterations {params.iterations} \
      --threads {threads} \
      --out-dir {params.outdir}
    """
