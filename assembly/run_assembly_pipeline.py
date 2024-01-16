#!/usr/bin/env python3

import argparse
import os
import sys

def get_args():

    parser = argparse.ArgumentParser(description='Run PacBio HiFi assembly pipeline on sciCORE')

    # Parameter groups
    parser_io = parser.add_argument_group('INPUT/OUTPUT')

    parser_cluster = parser.add_argument_group('CLUSTER CONFIGURATION')

    # INPUT/OUTPUT
    parser_io.add_argument('-s', '--samples', required=True, help='Path to tab-separeted table, no header, with sample name and path to fastq with HiFi reads.')
    
    parser_io.add_argument('-o', '--outdir', required=True, help='Output directory for the results.')


    # CLUSTER CONFIG
    parser_cluster.add_argument('-j', '--njobs', default='4', help='Number of jobs to run in parallel. [4]')

    parser_cluster.add_argument('-t', '--threads', default='10', help='Threads per job. [10]' )

    args=parser.parse_args()

    return args


def main():    
    
    args = get_args()
   
    # Infer pipeline location from path of run_assembly_pipeline.py
    pl_path = os.path.dirname(os.path.abspath(sys.argv[0]))
    print(pl_path)

    # Directories for which singularity needs to be given access
    bind_dirs = [
        "/scicore/home/gagneux/GROUP/tbresearch/genomes/IN_PROGRESS/PacBio_genomes/Gagneux",
        "/scratch",
        "/scicore/home/gagneux/GROUP/PacbioSnake_resources",
        args.outdir,
        pl_path
        ]
    
    singularity_args = "--bind " + " --bind ".join(bind_dirs)

    cmd = [
        "snakemake",
        "--snakefile", pl_path + "/workflow/Snakefile",
        "--directory", pl_path,
        "--configfile", pl_path + "/config/config.yaml",
        "--profile", pl_path + "/config/cluster_config.yaml", 
        # Overwrite samples and outdir parameters
        "--config", "samples=" + args.samples,
        "--config", "outdir=" + args.outdir,
        "--jobs", args.njobs,
        "--cleanup-shadow",
        "--use-singularity", 
        "--singularity-args" + " \"" + singularity_args + "\""        
    ]

    #print(" ".join(cmd))
    os.system(" ".join(cmd))
    
if __name__ == '__main__':
    main()
