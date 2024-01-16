#!/usr/bin/env python3

import argparse
import os
import sys

def get_args():

    parser = argparse.ArgumentParser(description='Run PacBio HiFi assembly pipeline on sciCORE')

    # Parameter groups
    parser_io = parser.add_argument_group('INPUT/OUTPUT')

    parser_cluster = parser.add_argument_group('CLUSTER CONFIGURATION (not implemented yet)')

    # INPUT/OUTPUT
    parser_io.add_argument('-s', '--samples', required=True, help='Absolute path to tab-separated table, no header, with sample name and path to fastq with HiFi reads.')
    
    parser_io.add_argument('-o', '--outdir', required=True, help='Absolute path to output directory.')

    parser_io.add_argument('-n', '--dry_run', action='store_true', help='Do snakemake dry run.')


    # CLUSTER CONFIG (not implemented, would have to temper with the cluster config file)
    parser_cluster.add_argument('-j', '--njobs', default='4', help='Number of jobs to run in parallel. [4]')

    parser_cluster.add_argument('-t', '--threads', default='10', help='Threads per job. [10]' )

    args=parser.parse_args()

    return args


def main():    
    
    args = get_args()
   
    # Infer pipeline location from path of run_assembly_pipeline.py
    pl_path = os.path.dirname(os.path.abspath(sys.argv[0]))
    
    # Directories for which singularity needs to be given access
    bind_dirs = [
        "/scicore/home/gagneux/GROUP/tbresearch/genomes/IN_PROGRESS/PacBio_genomes/Gagneux",
        "/scratch",
        "/scicore/home/gagneux/GROUP/PacbioSnake_resources",
        args.outdir,
        pl_path
        ]
    
    # Infer folders with samples, to add them to bind_dirs
    sample_dirs = set()
    with open(args.samples) as f:
        for line in f:
            fields = line.strip().split()
            fastq_path = fields[1]
            fastq_dir = os.path.dirname(os.path.realpath(fastq_path))
            sample_dirs.add(fastq_dir)

    bind_dirs = bind_dirs + list(sample_dirs)

    singularity_args = "--bind " + " --bind ".join(bind_dirs)

    if args.dry_run:

        cmd = [
            "snakemake -n",
            "--snakefile", pl_path + "/workflow/Snakefile",
            "--directory", pl_path,
            "--configfile", pl_path + "/config/config.yaml",
            "--config", "samples=\"" + args.samples + "\"" + " outdir=\"" + args.outdir + "\""
        ]

    else:
        cmd = [
            "snakemake",
            "--snakefile", pl_path + "/workflow/Snakefile",
            "--directory", pl_path,
            "--configfile", pl_path + "/config/config.yaml",
            "--profile", pl_path + "/cluster", 
            "--use-singularity", 
            "--singularity-args" + " \"" + singularity_args + "\"",
            # Overwrite samples and outdir parameters in configfile
            "--config", "samples=\"" + args.samples + "\"" + " outdir=\"" + args.outdir + "\""
        ]

    print("\n" + " ".join(cmd) + "\n")
    os.system(" ".join(cmd))
    
if __name__ == '__main__':
    main()