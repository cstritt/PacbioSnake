rule read_summary:
    input: expand("results/{sample}/longqc/QC_vals_longQC_sampleqc.json", sample = samples.keys())
    output: "results/read_summaries.tsv"
    run:
        import json

        sample_d = {}
        header = ["sample"]

        for FILE in input:

            sample = FILE.split("/")[1]

            d = json.load(open(FILE))
            d_flat = {}

            for a_id, a_info in d.items():
                
                if isinstance(a_info, dict):
                    for b_id, b_info in a_info.items():

                        if b_id == "gamma_params":
                            continue

                        d_flat[b_id] = b_info
                        if b_id not in header:
                            header.append(b_id)
                else:
                    d_flat[a_id] = a_info
                    if a_id not in header:
                            header.append(a_id)

            sample_d[sample] = d_flat


        with open(output[0], "w") as f:

            f.write('\t'.join(header) + '\n')

            for sample in sample_d:

                outline = [sample]

                for k in header[1:]:
                    if k in sample_d[sample]:
                        outline.append(str(sample_d[sample][k]))
                    else:
                        outline.append("NA")

                f.write('\t'.join(outline) + '\n')


rule assembly_summaries:
  input: expand("results/{sample}/assembly_info.txt", sample = samples.keys())
  output: "results/assembly_summaries.tsv"
  run:

    header = ""
    outfile = open(output[0], "w")

    outfile_single_contigs = open("results/single_contig_samples.txt", "w")

    for FILE in input:

      sample = FILE.split("/")[1]
      contig_count = 0

      with open(FILE) as f:
        if not header:
          header = "sample\t" + next(f)
          outfile.write(header)
        else:
          next(f)

        for line in f:
          outline = sample + "\t" + line
          outfile.write(outline)
          contig_count += 1

      if contig_count == 1:
        outfile_single_contigs.write(sample + '\n')

    outfile.close()
