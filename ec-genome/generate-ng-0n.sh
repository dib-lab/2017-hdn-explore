#!/bin/sh

# generate node graphs of length equal to len for the 20 sub samples

len=$1
mkdir ng-0$len

for x in `seq $len 1 20`;
  do
  #get the files in chunks equal to len
  files=$(head -n $x sample-20-reads.txt |tail -n $len)
  filename=$(echo $files|sed -e 's/ /./g')
  read=$(echo $files|cut -f1 -d ' ')
  cd reads-noerr
  cat $files > ../tmp$len.fna
  cd ..
  load-graph.py ng-0$len/$read.ng tmp$len.fna -M 1e9 -k 31 --no-build-tagset
  python ../measure-reads.py ng-0$len/$read.ng reads-noerr/$read
  mv $read.ng.hdn.csv ng-0$len
done
