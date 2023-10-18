# Genome assembly and variant calling from PacBio HiFi reads

This folder contains two Snakemake workflows:
  - [*assembly*](assembly/README.md): from PacBio HiFi consensus reads to annotated genome assemblies
  - [*variantcalling*](variantcalling/README.md): combine assemblies into a pangenome graph and call variants from the graph

This is ongoing work, some things will change.


## Requirements
On the sciCORE cluster, the pipeline is installed in the GROUP folder (**/scicore/home/gagneux/GROUP/PacbioSnake**) and ready to run. 

In other contexts, four things need to be set up before the pipeline can be run: 
  
  1. Install Snakemake and Singularity
  2. Build the singularity container for the assembly pipeline
  3. Download the bakta database for genome annotation
  4. Pull the singularity container for the variant calling pipeline

These steps are detailed below. 


### 1. Install Snakemake and Singularity
As described on the [Snakemake](https://snakemake.readthedocs.io) and the [Singularity](https://docs.sylabs.io/guides/latest/user-guide/) sites. 


### 2. Build the singularity container for the assembly pipeline
```
cd assembly/container
sudo singularity build assemblySC.sif assemblySC.def
```


### 3. Download the bakta database for genome annotation
Light-weight (1.3 Gb) and full (33.1 Gb) databases for the *bakta* annotation tool can be downloaded from https://zenodo.org/records/7669534.
The extracted folder should be located at assembly/resources/bakta_db/. Otherwise the path to the database can be modified in the assembly config file.


### 4. Pull the singularity container for the variant calling pipeline
```
singularity pull docker://ghcr.io/pangenome/pggb:latest
```


