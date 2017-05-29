#!/bin/sh

# generate short reads from e. coli genomes with error of 0.01; length of 100

base1=$(head -n 1 sample-20-reads.txt)
for fna in $(tail -n +2 sample-20-reads.txt)
  do
  cat reads-noerr/$base reads-noerr/$fna > tmp.fna
  load-graph.py ng-02/${fna}.${base}.ng tmp.fna -M 1e9 -k 31 --no-build-tagset
  python ../measure-reads.py ng-02/${fna}.${base}.ng reads-noerr/$base
  mv ${fna}.${base}.ng.hdn.csv ng-02
done
