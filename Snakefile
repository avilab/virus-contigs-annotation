PROTEINS = os.environ["RVDB_PROT"]
HMMS = os.environ["RVDB_HMMR"]

FILES_PATH = "."
RUNS,_ = glob_wildcards(FILES_PATH + "/{run}_{contigs}.fa")

rule all:
    input:
        expand("{run}/{run}.{ext}", run = set(RUNS), ext = ["faa", "gbk", "csv"])

rule prokka:
    input:
        "{run}_viral-contigs.fa"
    output:
        expand("{{run}}/{{run}}.{ext}", ext = ["faa", "gbk"])
    shadow: "full"
    params:
        extra = lambda wildcards: "--mincontiglen 1000 --metagenome --proteins {prot} --hmms {hmms} --kingdom Viruses --locustag {run} --prefix {run} --force".format(run = wildcards.run, prot = PROTEINS, hmms = HMMS)
    threads: 4
    wrapper:
        "https://raw.githubusercontent.com/avilab/virome-wrappers/blast5/prokka"

rule parse_prokka:
    input: 
        "{run}/{run}.gbk"
    output:
        "{run}/{run}.csv"
    conda:
        "https://raw.githubusercontent.com/avilab/virome-wrappers/master/blast/parse/environment.yaml"
    script:
        "scripts/parse_genebank.py"
