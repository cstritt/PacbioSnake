# Variant calling workflow

## assemblies.txt




## config.yaml
```yaml

samples: samples.inhouse.hifi.test.csv

results_directory: ./results
output_prefix: pb_bernese

ref:
  genome_size: 4.4m
  gbf: resources/H37Rv.gbf

threads: 4

keep_intermediate: "Yes"

```

## Dry run
snakemake -n

## Run
```
snakemake \
 --jobs 1 \
 --latency-wait 60 \
 --use-conda --use-envmodules \
 --use-singularity --singularity-args "--bind /scicore/home/gagneux/stritt0001/TB/projects/pacbio_microscale/workflows --bind /scratch" \
 --cluster "sbatch --job-name=bernese_variants --cpus-per-task=20 --mem-per-cpu=1G --time=06:00:00 --qos=6hours --output=bernese_variants.o%j --error=bernese_variants.e%j"
```
