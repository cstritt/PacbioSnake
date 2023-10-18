
rule bakta:
  input: config["outdir"] + "/{sample}/assembly.circularized.renamed.fasta"
  output: config["outdir"] + "/{sample}/{sample}.gff"
  params:
    bakta_db = config["bakta_db"],
    refgbf = config["ref"]["gbf"],
    asm = "{sample}",
    outdir = config["outdir"] + "/{sample}/",
    threads = config["threads_per_job"]

  shell:
    """
    bakta {input} \
    --db {params.bakta_db} \
    --prefix {params.asm} \
    --genus Mycobacterium \
    --species tuberculosis \
    --strain {params.sample} \
    --locus-tag {params.sample} \
    --complete --compatible \
    --proteins {params.refgbf} \
    --keep-contig-headers \
    --threads  {params.threads}

    """
