import pandas as pd
import os

FILES_PATH = "."
RUNS,_ = glob_wildcards(FILES_PATH + "/{run}_{contigs}.fa")

rule all:
    input:
        expand("{run}.gff", run = set(RUNS))

rule prokka:
    input:
        "{run}_viral-contigs.fa"
    output:
        "{run}.gff"
    params:
        extra = lambda wildcards: "--metagenome --kingdom Viruses --gcode 1 --prefix {run}".format(run = wildcards.run)
    threads: 4
    wrapper:
        "file:../scripts/prokka/wrapper.py"
