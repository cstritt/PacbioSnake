# Genome assembly workflow

The user needs to modify two things to run the workflow on her samples:

- the file config/samples.tsv, which contains the sample names and the corresponding paths to the HiFi consensus reads. 
- the file config/config.yaml, which contains global options for the analysis 


## container
Problem: 1.6 gb container on gitlab? Building or loading container requires sudo...


```
sudo singularity build assemblySMK.sif assemblySMK.def
```



## samples.tsv
This is a tab-separated table with a header and two colums (see example): the first containing the sample names, which will be used to name the assemblies; the second with the absolute paths to the fastq files. 

## config.yaml
In the file config/config.yaml some global parameters can be set:

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



## Dry-run
```
snakemake -n
```


## Run the workflow on scicore

Important: singularity containers most be given access to the file locations through the --bind argument. E.g. if the long reads are on /scicore/home/jean-jacques/reads/, add this location in the snakemake command (see also the full command below): 

```
--singularity-args "--bind /scicore/home/jean-jacques/reads/" 
```

It's convenient to run snakemake in a screen, so we can do other things on scicore while it's running and occasionally check the progress.

Important snakemake arguments:
    --jobs: 
    --cluster

```
screen -r assembly

snakemake \
 --jobs 4 
 -k \
 --latency-wait 60 \
 --use-singularity --singularity-args "--bind /scicore/home/gagneux/GROUP/tbresearch/genomes/IN_PROGRESS/PacBio_genomes/Gagneux --bind /scicore/home/gagneux/stritt0001/TB/projects/pacbio_microscale/ --bind /scratch" \
 --cluster "sbatch --job-name=hifi_simul --cpus-per-task=4 --mem-per-cpu=4G --time=06:00:00 --qos=6hours --output=hifi_simul.o%j --error=hifi_simul.e%j"

```

Leave the screen with CTRL+a+d.