
import argparse
import os
import yaml

def get_args():

    parser = argparse.ArgumentParser(
        description='')

    parser.add_argument(
        '-c', '--configfile',
        dest='config',
        required=True,
        help='.'
        )

    parser.add_argument(
        '-j', '--njobs',
        dest="win_size",
        required=True, type=int, 
        help='Window size.'
        )

    parser.add_argument(
        '-t',
        dest='threads',
        type=int, default=0,
        help='Threads per job.'
        )

    args=parser.parse_args()
    return args


def main():    
    
    args = get_args()

    with open(args.config, 'r') as file:
        config = yaml.safe_load(file)

    
    # Infer pipeline location from path of run_assembly_pipeline.py
    



    cmd = [
        "snakemake",
        "--profile", "", 
        "--snakefile", "/scicore/home/gagneux/GROUP/PacbioSnake/assembly/workflow/Snakefile",
        "--directory", "/scicore/home/gagneux/GROUP/PacbioSnake/assembly",
        "--configfile", "/scicore/home/gagneux/stritt0001/TB/projects/pacbio_microscale/results/demo/config.yml",
        "--jobs", "4",
        "--latency-wait", "60", 
        "--cleanup-shadow",
        "--shadow-prefix", 
        "--verbose",
        "--use-singularity", "--singularity-args", "--bind /scicore/home/gagneux/GROUP/tbresearch/genomes/IN_PROGRESS/PacBio_genomes/Gagneux --bind /scicore/home/gagneux/stritt0001 --bind /scratch",
        "--cluster", "sbatch --job-name=pbassembly --cpus-per-task=4 --mem-per-cpu=4G --time=06:00:00 --qos=6hours --output=/scicore/home/gagneux/stritt0001/TB/projects/pacbio_microscale/results/demo/pbassembly.o%j --error=/scicore/home/gagneux/stritt0001/TB/projects/pacbio_microscale/results/demo/pbassembly.e%j"
    ]

    os.system(" ".join(cmd))
    
if __name__ == '__main__':
    main()
