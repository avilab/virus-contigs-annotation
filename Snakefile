PROTEINS = os.environ["RVDB_PROT"]
HMMS = os.environ["RVDB_HMMR"]

FILES_PATH = "."
RUNS,_ = glob_wildcards(FILES_PATH + "/{run}_{contigs}.fa")

rule all:
    input:
        expand("{run}/{run}.{ext}", run = set(RUNS), ext = ["fna", "gff", "tsv", "err", "faa", "tbl", "gbk", "ffn", "sqn", "log", "fsa", "txt", "hmmer"])

rule prokka:
    input:
        "{run}_viral-contigs.fa"
    output:
        expand("{{run}}/{{run}}.{ext}", ext = ["fna", "gff", "tsv", "err", "faa", "tbl", "gbk", "ffn", "sqn", "log", "fsa", "txt"])
    shadow: "full"
    params:
        extra = lambda wildcards: "--mincontiglen 1000 --metagenome --proteins {prot} --hmms {hmms} --kingdom Viruses --locustag {run} --prefix {run} --force".format(run = wildcards.run, prot = PROTEINS, hmms = HMMS)
    threads: 4
    wrapper:
        "https://raw.githubusercontent.com/avilab/virome-wrappers/blast5/prokka"

rule hmmer:
    input: 
        "{run}/{run}.faa"
    output:
        "{run}/{run}.hmmer"
    params:
        hmmdb = HMMS,
        extra = "--noali --notextw --qformat fasta"
    threads: 4
    conda:
        "scripts/hmmer/environment.yaml"
    shell:
        "hmmscan {params.extra} --cpu {threads} {params.hmmdb} {input} > {output}"
    
