
conda create --name qiime2R --file qiime2R.list.txt
conda activate qiime2R

chmod +x SpeciesPrimerEval_cl/SpeciesPrimerEval.R

## install R packages listed in SpeciesPrimerEval_cl_packages.R

ex: Rscript SpeciesPrimerEval.R 'mifish' 12S-seqs-derep-teleo-seqs.qza 12S-tax-derep-uniq.qza 'herring' fish.txt