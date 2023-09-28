rule prokka:
    input: "results/{sample}/assembly.circularized.renamed.fasta"
    output: "results/{sample}/prokka/{sample}.gff"

    params:
        refgbf = config["ref"]["gbf"],
        asm = "{sample}",
        outdir = "results/{sample}/prokka"
    threads: config["threads"]
    envmodules: "prokka/1.14.5-gompi-2021a"
    shell:
        """
        prokka {input} \
          --force \
          --kingdom Bacteria \
          --genus Mycobacterium \
          --species tuberculosis \
          --strain {params.asm} \
          --addgenes \
          --proteins {params.refgbf} \
          --prefix {params.asm} \
          --locustag {params.asm} \
          --cpus {threads} \
          --outdir {params.outdir}

        """

