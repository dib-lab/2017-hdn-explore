#! /usr/bin/env python
import argparse
from collections import defaultdict
import os.path

import khmer
import screed


def run(args):

    print('loading nodegraph from:', args.graph)
    graph = khmer.load_nodegraph(args.graph)
    ksize = graph.ksize()
    hashsizes = graph.hashsizes()

    assert ksize % 2, "ksize must be odd"

    print('finding high degree nodes')
    n = 0
    hdn_per_reads = defaultdict(int)

    # walk across input sequences, counting high-degree nodes.
    for seqfile in args.seqfiles:
        fp = screed.open(seqfile)
        for record in fp:
            if len(record.sequence) < ksize: continue
            n += 1
            if n % 100000 == 0:
                print('...2', seqfile, n)
                if args.num_reads and n > args.num_reads:
                    break

            # walk across sequences, find all high degree nodes, count them.
            these_hdn = graph.find_high_degree_nodes(record.sequence)
            hdn_per_reads[len(these_hdn)] += 1

        if args.num_reads and n > args.num_reads:
            break
            

    hdn_file = os.path.basename(args.graph) + '.hdn.csv'
    print('saving hdn counts to {}'.format(hdn_file))
    with open(hdn_file, 'wt') as fp:
        fp.write('hdn_count,n_reads\n')
        for k, v in hdn_per_reads.items():
            fp.write('{},{}\n'.format(k, v))


if __name__ == '__main__':
    p = argparse.ArgumentParser()
    p.add_argument('graph')
    p.add_argument('seqfiles', nargs='+')
    p.add_argument('-n', '--num-reads', default=None, type=int)
    args = p.parse_args()
    run(args)
