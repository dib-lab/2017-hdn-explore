#!/bin/sh
# use: generate-ng-shuffle-n.sh length iterations
# generate node graphs of length equal to len for the 20 sub samples

len=$1
iter=$2

mkdir ng-shuffle-$len

for x in `seq 1 1 $iter`;
  do
  #shuffle and get the files in chunks equal to len
  files=$(ls reads-noerr/ | gshuf | tail -n $len)
  #output files list to file
  echo $files > ng-shuffle-$len/files-$len-$x.list
  read=$(echo $files|cut -f1 -d ' ')
  cd reads-noerr
  cat $files > ../tmp$len.fna
  cd ..
  load-graph.py ng-shuffle-$len/out-$len-$x.ng tmp$len.fna -M 1e9 -k 31 --no-build-tagset
  python ../measure-reads.py ng-shuffle-$len/out-$len-$x.ng reads-noerr/$read
  mv $read.ng.hdn.csv ng-shuffle-$len
  rm tmp$len.fna
done
