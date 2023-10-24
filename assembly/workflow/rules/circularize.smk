
rule circlator_mapreads:
    input: 
        assembly = config["outdir"] + "/{sample}/flye/assembly.fasta",
        reads = lambda wildcards: expand(samples[wildcards.sample].longread_fastq)
    output: config["outdir"] + "/{sample}/circlator/01.mapreads.bam"
    params:
        threads = config["threads_per_job"]

    shell:
        """
        circlator mapreads {input.assembly} {input.reads} {output} --threads {params.threads}

        """

rule circlator_bam2reads:
    input: config["outdir"] + "/{sample}/circlator/01.mapreads.bam"
    output: config["outdir"] +"/{sample}/circlator/02.bam2reads.fasta"
    params:
        output_pref = config["outdir"]+ "/{sample}/circlator/02.bam2reads"
    shell:
        """
        circlator bam2reads {input} {params.output_pref} --discard_unmapped

        """

rule circlator_localassembly:
    input: config["outdir"] + "/{sample}/circlator/02.bam2reads.fasta"
    output: config["outdir"] + "/{sample}/circlator/03.assemble/assembly.fasta"
    params:
        outdir = config["outdir"] + "/{sample}/circlator/03.assemble",
        threads = config["threads_per_job"]
    shell:
        """
        flye --pacbio-hifi {input} --out-dir {params.outdir} --genome-size 100k --threads {params.threads}

        """

rule circlator_merge:
    input: 
        assembly = config["outdir"]  + "/{sample}/flye/assembly.fasta",
        localassembly = config["outdir"] + "/{sample}/circlator/03.assemble/assembly.fasta"
    output: config["outdir"] + "/{sample}/circlator/04.merge.fasta"
    params:
        threads = config["threads_per_job"],
        output_pref = config["outdir"] + "/{sample}/circlator/04.merge"
    shell:
        """
        circlator merge {input.assembly} {input.localassembly} {params.output_pref} --threads {params.threads}

        """

rule circlator_clean:
    input: config["outdir"] + "/{sample}/circlator/04.merge.fasta"
    output: config["outdir"] + "/{sample}/circlator/05.clean.fasta"
    params:
        output_pref = config["outdir"] + "/{sample}/circlator/05.clean"
    shell:
        """
        circlator clean {input} {params.output_pref}

        """

rule circlator_fixstart:
    input: config["outdir"] + "/{sample}/circlator/05.clean.fasta"
    output: config["outdir"] + "/{sample}/circlator/06.fixstart.fasta"
    params:
        output_pref = config["outdir"] + "/{sample}/circlator/06.fixstart"
    shell:
        """
        circlator fixstart {input} {params.output_pref}

        """
        
rule rename:
    input: 
        assembly = config["outdir"] + "/{sample}/circlator/06.fixstart.fasta"
    params:
        prefix = "{sample}",
        keep_intermediate = config["keep_intermediate"]

    output: config["outdir"]  + "/{sample}/{sample}.fasta"
    
    run:

        import os
        import sys
        from Bio import SeqIO

        contig_NR = 1

        fasta_handle = open(output[0], "w")

        with open(input.assembly) as original:

            records = SeqIO.parse(original, 'fasta')

            for record in records:

                record.id = params.prefix + "_" + str(contig_NR)
                record.description = ""
                
                SeqIO.write(record, fasta_handle, 'fasta')
                
                contig_NR += 1

        fasta_handle.close()

