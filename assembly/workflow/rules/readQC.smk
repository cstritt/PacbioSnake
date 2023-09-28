rule longQC:
    input: lambda wildcards: samples[wildcards.sample].longread_fastq
    output: "results/{sample}/longqc/QC_vals_longQC_sampleqc.json"
    params:
        threads = config["threads"],
        outfolder = "results/{sample}/longqc/"

    shell:
        """
        rm -r {params.outfolder}
        python /LongQC/longQC.py sampleqc -x pb-sequel -o {params.outfolder}/ -p {params.threads} {input}

        """

