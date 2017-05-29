#!/bin/sh

# generate short reads from e. coli genomes with error of 0.01; length of 100

for fna in $(cat sample-20-reads.txt)
  do
  load-graph.py ng-01/$fna.ng reads-noerr/$fna -M 1e9 -k 31 --no-build-tagset
  python ../measure-reads.py ng-01/$fna.ng reads-noerr/$fna
  mv $fna.ng.hdn.csv $ng-01
done
