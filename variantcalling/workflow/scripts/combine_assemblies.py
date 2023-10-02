#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import re
import sys
from Bio import SeqIO


assemblies = sys.argv[1:]

fasta_handle = open("results_sim/single_contig_assemblies.fasta", "w")
discarded = open("results_sim/discarded_assemblies.txt", "w")

for ASSEMBLY in assemblies:
                    
    records = [rec for rec in SeqIO.parse(ASSEMBLY, "fasta")]
    if len(records) > 1:
        discarded.write(ASSEMBLY + '\n')

    else:
        rec = records[0]
        SeqIO.write(rec, fasta_handle, "fasta")

fasta_handle.close()
discarded.close() 