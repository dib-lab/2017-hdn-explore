#!/bin/sh

# generate short reads from e. coli genomes with error of 0.01; length of 100
for fna in ../data/ecoli/ncbi-genomes-2017-05-29/*fna
  do
  sed -e '/^[^>]/s/[^ATGCatgc]/N/g' $fna > tmp.fna
  reads=${fna##*/}.reads.r100.c2.e0.fa
  python nullgraph/make-reads.py -r 100 -C 2 -e 0 -S 42 tmp.fna > reads-noerr/$reads
done
