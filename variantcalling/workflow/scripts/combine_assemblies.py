#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import re
import sys
from Bio import SeqIO


outdir = sys.argv[1]
assemblies = sys.argv[2:]

fasta_handle = open(outdir + "/single_contig_assemblies.fasta", "w")
discarded = open(outdir + "/discarded_assemblies.txt", "w")

for ASSEMBLY in assemblies:
                    
    records = [rec for rec in SeqIO.parse(ASSEMBLY, "fasta")]
    if len(records) > 1:
        discarded.write(ASSEMBLY + '\n')

    else:
        rec = records[0]
        SeqIO.write(rec, fasta_handle, "fasta")

fasta_handle.close()
discarded.close() 