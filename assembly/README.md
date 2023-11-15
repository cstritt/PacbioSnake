# Genome assembly workflow

The genome assembly workflow includes the following tools/steps:
  - [LongQC](https://doi.org/10.1534/g3.119.400864): Get some read summary statistics. The reads are not modified in any way before assembly, 
  - [Flye](https://doi.org/10.1038/s41587-019-0072-8): Assembly.
  - [circlator](https://doi.org/10.1186/s13059-015-0849-0): Reorient the assembly such that it begins with dnaA.
  - [bakta](https://doi.org/10.1099/mgen.0.000685): Annotate the reoriented assembly.
  - [minimap2](https://doi.org/10.1093/bioinformatics/bty191): Map the long reads back against the assembly. The resulting alignments can be used to check for inconsistencies between reads and assemblies.  


# Run the pipeline on sciCORE
The user needs to provide two things to run the workflow on her samples:
- a config file with some global options for the analysis
- a tab separate table, without header, that contains the sample names and the corresponding paths to the HiFi consensus reads. 

## config.yml
In the file config/config.yaml some global parameters can be set:

```yaml
# REQUIRED
samples: config/samples.tsv # Path to sample table, no header, tab-separated
outdir: ./results # Path to output directory

# OPTIONAL
annotate: "Yes" # Annotate assembly with bakta Yes/No

ref:
  genome_size: 4.4m # 
  gbf: resources/H37Rv.gbf # Used for bakta annotation step

bakta_db: resources/bakta_db # Used for bakta annotation step
container: containers/assemblySMK.sif # Singularity container containing all reuquired software

threads_per_job: 4 # Should match cpus-per-task in the snakemake command
 
keep_intermediate: "Yes" # Not implemented yet...

```

## samples.tsv
This is a tab-separated table with no header and two colums (see example): the first containing the sample names, which will be used to name the assemblies; the second with the absolute paths to the fastq files. 



## Snakemake dry run

```
snakemake -n --configfile /path/to/config.yml
```

## Run the workflow on sciCORE

Important: singularity containers most be given access to the file locations through the --bind argument. E.g. if the long reads are on /scicore/home/jean-jacques/reads/, add this location in the snakemake command (see also the full command below): 

```
--singularity-args "--bind /scicore/home/jean-jacques/reads/" 
```

It's convenient to run snakemake in a screen, so we can do other things on scicore while it's running and occasionally check the progress.


```
# Open screen 
screen -R assembly

# Load Snakemake module
ml snakemake/6.6.1-foss-2021a 

# Dry run 
snakemake -n \
 --configfile /scicore/home/gagneux/stritt0001/TB/projects/pacbio_microscale/results/demo/config.yml


# Real run 
snakemake \
 --configfile /scicore/home/gagneux/stritt0001/TB/projects/pacbio_microscale/results/demo/config.yml \
 --jobs 4 \
 --keep-going \
 --latency-wait 60 \
 --use-singularity --singularity-args "--bind /scicore/home/gagneux/GROUP/tbresearch/genomes/IN_PROGRESS/PacBio_genomes/Gagneux --bind /scicore/home/gagneux/stritt0001 --bind /scratch" \
 --cluster "sbatch --job-name=pbassembly --cpus-per-task=4 --mem-per-cpu=4G --time=06:00:00 --qos=6hours --output=/scicore/home/gagneux/stritt0001/TB/projects/pacbio_microscale/results/demo/pbassembly.o%j --error=/scicore/home/gagneux/stritt0001/TB/projects/pacbio_microscale/results/demo/pbassembly.e%j"


# Leave the screen: CTRL+a+d

# Return to the screen 
screen -r assembly

```

# Output
For each sample defined in the samples table, a folder is generated in the output directory. It contains: 

```
assembly.circularized.renamed.fasta
bakta/
circlator/
flye/
longqc/
remapping/

```
