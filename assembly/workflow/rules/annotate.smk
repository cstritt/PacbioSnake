
rule bakta:
  input: config["outdir"] + "/{sample}/assembly.circularized.renamed.fasta"
  output: config["outdir"] + "/{sample}/bakta/{sample}.gff3"
  params:
    bakta_db = config["bakta_db"],
    refgbf = config["ref"]["gbf"],
    asm = "{sample}",
    outdir = config["outdir"] + "/{sample}/bakta",
    threads = config["threads_per_job"]

  shell:
    """
    bakta {input} \
    --db {params.bakta_db} \
    --output {params.outdir} \
    --prefix {params.asm} \
    --genus Mycobacterium \
    --species tuberculosis \
    --strain {params.asm} \
    --locus-tag {params.asm} \
    --complete --compliant --force \
    --proteins {params.refgbf} \
    --keep-contig-headers \
    --threads  {params.threads}

    """
