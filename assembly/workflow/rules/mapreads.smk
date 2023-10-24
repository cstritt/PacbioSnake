

rule map_LR:
    input:
        reads = lambda wildcards: samples[wildcards.sample].longread_fastq,  
        assembly = config["outdir"] + "/{sample}/{sample}.fasta"
    output: config["outdir"] + "/{sample}/remapping/longreads.bam"
    params:
        intermediate = config["outdir"] + "/{sample}/remapping/longreads.raw.bam"
    threads: config["threads_per_job"]
    shell:
        """
        minimap2 -ax map-hifi {input.assembly} {input.reads} | samtools view -hu > {params.intermediate}
        samtools sort -@ {threads} {params.intermediate} -o {output}
        samtools index {output}
        rm {params.intermediate}

        """