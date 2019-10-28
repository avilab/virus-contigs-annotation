import os

PROTEINS = os.environ["RVDB_PROT"]
HMMS = os.environ["RVDB_HMMR"]

FILES_PATH = config["contigs"]
RUNS,_ = glob_wildcards(FILES_PATH + "{run}_{contigs}.fa")

rule all:
    input:
        expand(os.path.join(FILES_PATH.split("/")[0], "prokka/{run}.{ext}"), run = set(RUNS), ext = ["faa", "gbk", "csv"])

rule prokka:
    input:
        "{run}_viral-contigs.fa"
    output:
        expand(os.path.join(FILES_PATH.split("/")[0], "prokka/{{run}}.{ext}"), ext = ["faa", "gbk"])
    shadow: "full"
    group: "one"
    params:
        extra = lambda wildcards: "--mincontiglen 1000 --metagenome --proteins {prot} --hmms {hmms} --kingdom Viruses --locustag {run} --prefix {run} --force".format(run = wildcards.run, prot = PROTEINS, hmms = HMMS)
    threads: 4
    wrapper:
        "https://raw.githubusercontent.com/avilab/virome-wrappers/blast5/prokka"

rule parse_prokka:
    input: 
        "prokka/{run}.gbk"
    output:
        "prokka/{run}.csv"
    group: "one"
    conda:
        "https://raw.githubusercontent.com/avilab/virome-wrappers/master/blast/parse/environment.yaml"
    script:
        "scripts/parse_genebank.py"
