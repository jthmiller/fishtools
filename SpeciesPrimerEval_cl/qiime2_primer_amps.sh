## Qiime synthetic primer amplicons

## Mifish ############################################
fp <- DNAStringSet('GTCGGTAAAACTCGTGCCAGC')
rp <- DNAStringSet('CATAGTGGGGTATCTAATCCCAGTTTG')

conda activate qiime2-2021.11
qiime feature-classifier extract-reads \
  --i-sequences 12S-seqs-derep-uniq.qza \
  --p-f-primer GTCGGTAAAACTCGTGCCAGC \
  --p-r-primer CATAGTGGGGTATCTAATCCCAGTTTG \
  --p-identity 0.85 \
  --p-trunc-len 150 \
  --p-min-length 50 \
  --p-max-length 500 \
  --p-read-orientation both \
  --o-reads 12S-seqs-derep-mifish-seqs.qza \
  --p-n-jobs 18
################################################



#### Teleo ################################
conda activate qiime2-2021.11

fw: ACACCGCCCGTCACTCT
rv: CTTCCGGTACACTTACCATG

conda activate qiime2-2021.11
qiime feature-classifier extract-reads \
  --i-sequences 12S-seqs-derep-uniq.qza \
  --p-f-primer GTCGGTAAAACTCGTGCCAGC \
  --p-r-primer CATAGTGGGGTATCTAATCCCAGTTTG \
  --p-identity 0.85 \
  --p-trunc-len 85 \
  --p-min-length 40 \
  --p-max-length 300 \
  --p-read-orientation both \
  --o-reads 12S-seqs-derep-teleo-seqs.qza \
  --p-n-jobs 18
############################################



## Riaz 16S ############################################
fp ACTGGGATTAGATACCCC
rp TAGAACAGGCTCCTCTAG

conda activate qiime2-2021.11
qiime feature-classifier extract-reads \
  --i-sequences 12S-16S-18S-seqs.qza \
  --p-f-primer ACTGGGATTAGATACCCC \
  --p-r-primer TAGAACAGGCTCCTCTAG \
  --p-identity 0.85 \
  --p-trunc-len 110 \
  --p-min-length 50 \
  --p-max-length 300 \
  --p-read-orientation both \
  --o-reads 16S-seqs-derep-riaz-seqs.qza \
  --p-n-jobs 18
################################################



## Evans 16S ############################################
fp CCTTTTGCATCATGATTTAGC
rp CAGGTGGCTGCTTTTAGGC

conda activate qiime2-2021.11
qiime feature-classifier extract-reads \
  --i-sequences 12S-16S-18S-seqs.qza \
  --p-f-primer GTCGGTAAAACTCGTGCCAGC \
  --p-r-primer CATAGTGGGGTATCTAATCCCAGTTTG \
  --p-identity 0.85 \
  --p-trunc-len 330 \
  --p-min-length 50 \
  --p-max-length 500 \
  --p-read-orientation both \
  --o-reads 16S-seqs-derep-evans-seqs.qza \
  --p-n-jobs 18
################################################
