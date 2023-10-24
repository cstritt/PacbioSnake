# Variant calling workflow




## container
```
singularity pull docker://ghcr.io/pangenome/pggb:latest
```

## assemblies.txt


## config/config.yaml
```yaml
outdir: /home/cristobal/TB/projects/pacbio_microscale/results/variants/assembly
samples: /home/cristobal/TB/projects/pacbio_microscale/results/variants/assembly/samples.tsv
reference: N1426
threads: 20
```

## Dry run
```
snakemake -n --configfile 
```

## Run
```
snakemake \
 --jobs 1 \
 --configfile ~/TB/projects/pacbio_microscale/results/variants/assembly/config.yml \
 --latency-wait 60 \
 --use-conda --use-envmodules \
 --use-singularity --singularity-args "--bind /scicore/home/gagneux/stritt0001 --bind /scratch" \
 --cluster "sbatch --job-name=pggb --cpus-per-task=20 --mem-per-cpu=1G --time=06:00:00 --qos=6hours --output=pggb.o%j --error=pggb.e%j"
```
