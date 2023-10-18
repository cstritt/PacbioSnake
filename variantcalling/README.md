# Variant calling workflow




## container
```
singularity pull docker://ghcr.io/pangenome/pggb:latest
```

## assemblies.txt


## config/config.yaml
```yaml

reference: 

threads: 4

output_dir: ./results

pggb:
  p: 99
  s: 5k

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
