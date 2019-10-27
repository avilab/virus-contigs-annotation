import pandas as pd
import os

FILES_PATH = "."
RUNS,_ = glob_wildcards(FILES_PATH + "/{run}_{contigs}.fa")

rule all:
    input:
        expand("{run}/{run}.{ext}", run = set(RUNS), ext = ["fna", "gff", "tsv", "err", "faa", "tbl", "gbk", "ffn", "sqn", "log", "fsa", "txt"])

rule prokka:
    input:
        "{run}_viral-contigs.fa"
    output:
        expand("{{run}}/{{run}}.{ext}", ext = ["fna", "gff", "tsv", "err", "faa", "tbl", "gbk", "ffn", "sqn", "log", "fsa", "txt"])
    params:
        extra = lambda wildcards: "--metagenome --kingdom Viruses --gcode 1 --norrna --notrna --prefix {run} --force".format(run = wildcards.run)
    threads: 4
    wrapper:
        "file:../scripts/prokka/wrapper.py"
