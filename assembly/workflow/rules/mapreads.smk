
rule map_SR:
    input:
        reads = lambda wildcards: samples[wildcards.sample].shortread_fastq, 
        assembly = "results/{sample}/assembly.circularized.renamed.fasta"
    output: "results/{sample}/remapping/shortreads.bam"
    params:
        intermediate = "results/{sample}/remapping/shortreads.raw.bam"
    threads: config["threads"]
    shell:
        """
        minimap2 -ax sr {input.assembly} {input.reads} | samtools view -hu > {params.intermediate}
        samtools sort -@ {threads} {params.intermediate} -o {output}
        samtools index {output}
        rm {params.intermediate}

        """

rule map_LR:
    input:
        reads = lambda wildcards: samples[wildcards.sample].longread_fastq,  
        assembly = "results/{sample}/assembly.circularized.renamed.fasta"
    output: "results/{sample}/remapping/longreads.bam"
    params:
        intermediate = "results/{sample}/remapping/longreads.raw.bam"
    threads: config["threads"]
    shell:
        """
        minimap2 -ax map-hifi {input.assembly} {input.reads} | samtools view -hu > {params.intermediate}
        samtools sort -@ {threads} {params.intermediate} -o {output}
        samtools index {output}
        rm {params.intermediate}

        """