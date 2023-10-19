configfile: "config/config.yaml"

class sample:
    def __init__(self, fields):
        self.id = fields[0]
        self.longread_fastq = fields[1]        

samples = {}

with open(config["samples"]) as f:
    for line in f:
        fields = line.strip().split("\t")
        samples[fields[0]] = sample(fields) 
