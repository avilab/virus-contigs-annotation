import os
from Bio.Seq import Seq
from Bio.SeqRecord import SeqRecord
from Bio.SeqFeature import SeqFeature, FeatureLocation
from Bio import SeqIO
from collections import OrderedDict
import pandas as pd


def parse_prokka_gbk(input, output):

    # get all sequence records for the specified genbank file
    recs = [rec for rec in SeqIO.parse(input, "genbank")]

    # print annotations for each sequence record
    contigs = []
    for rec in recs:
        feats = [feat for feat in rec.features if feat.type == "CDS"]
        feats_list = []
        for feat in feats:
            q = {k: ';'.join(v) for k,v in dict(feat.qualifiers).items() if k != 'translation'}
            q.update({"location": feat.location})
            feats_list.append(pd.DataFrame(q, index = [rec.id]))
        if len(feats_list) == 0:
            feats_list.append(pd.DataFrame({"locus_tag": "NA", "inference": "NA", "codon_start": "NA", "product": "NA", "location": "NA"}, index = [rec.id]))
        contigs.append(pd.concat(feats_list))
    pd.concat(contigs).to_csv(output, index_label = "ID")

if __name__ == "__main__":
    parse_prokka_gbk(snakemake.input, snakemake.output)


    