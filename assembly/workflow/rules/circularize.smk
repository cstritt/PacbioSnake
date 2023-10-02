
rule circlator_mapreads:
    input: 
        assembly = 'results/{sample}/assembly.fasta',
        reads = lambda wildcards: expand(samples[wildcards.sample].longread_fastq)
    output: "results/{sample}/circlator/01.mapreads.bam"
    params:
        threads = config["threads"]

    shell:
        """
        circlator mapreads {input.assembly} {input.reads} {output} --threads {params.threads}

        """

rule circlator_bam2reads:
    input: "results/{sample}/circlator/01.mapreads.bam"
    output: "results/{sample}/circlator/02.bam2reads.fasta"
    params:
        output_pref = "results/{sample}/circlator/02.bam2reads"
    shell:
        """
        circlator bam2reads {input} {params.output_pref} --discard_unmapped

        """

rule circlator_localassembly:
    input: "results/{sample}/circlator/02.bam2reads.fasta"
    output: "results/{sample}/circlator/03.assemble/assembly.fasta"
    params:
        outdir = "results/{sample}/circlator/03.assemble",
        threads = config["threads"]
    shell:
        """
        flye --pacbio-hifi {input} --out-dir {params.outdir} --genome-size 100k --threads {params.threads}

        """

rule circlator_merge:
    input: 
        assembly = 'results/{sample}/assembly.fasta',
        localassembly = "results/{sample}/circlator/03.assemble/assembly.fasta"
    output: "results/{sample}/circlator/04.merge.fasta"
    params:
        threads = config["threads"],
        output_pref = "results/{sample}/circlator/04.merge"
    shell:
        """
        circlator merge {input.assembly} {input.localassembly} {params.output_pref} --threads {params.threads}

        """

rule circlator_clean:
    input: "results/{sample}/circlator/04.merge.fasta"
    output: "results/{sample}/circlator/05.clean.fasta"
    params:
        output_pref = "results/{sample}/circlator/05.clean"
    shell:
        """
        circlator clean {input} {params.output_pref}

        """

rule circlator_fixstart:
    input: "results/{sample}/circlator/05.clean.fasta"
    output: "results/{sample}/circlator/06.fixstart.fasta"
    params:
        output_pref = "results/{sample}/circlator/06.fixstart"
    shell:
        """
        circlator fixstart {input} {params.output_pref}

        """
        
rule rename:
    input: 
        assembly = "results/{sample}/circlator/06.fixstart.fasta"
    params:
        prefix = "{sample}",
        keep_intermediate = config["keep_intermediate"]

    output: "results/{sample}/assembly.circularized.renamed.fasta"
    
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

