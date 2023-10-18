rule longQC:
    input: lambda wildcards: samples[wildcards.sample].longread_fastq
    output: config["outdir"] + "/{sample}/longqc/QC_vals_longQC_sampleqc.json"
    params:
        threads = config["threads_per_job"],
        outfolder = config["outdir"] + "/{sample}/longqc/"

    shell:
        """
        rm -r {params.outfolder}
        python /LongQC/longQC.py sampleqc -x pb-sequel -o {params.outfolder}/ -p {params.threads} {input}

        """

