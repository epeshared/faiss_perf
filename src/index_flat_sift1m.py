# Copyright (c) Facebook, Inc. and its affiliates.
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.

import time
import numpy as np
import faiss

from datasets import load_sift1M
from datasets import get_memory
from datasets import load_deep1B

print("load data")

xb, xq, xt, gt = load_sift1M()
# xb, xq, xt, gt = load_deep1B()
nq, d = xq.shape
k = 10

ncent = 2048

# variants = [(name, getattr(faiss.ScalarQuantizer, name))
#             for name in dir(faiss.ScalarQuantizer)
#             if name.startswith('QT_')]

testname = ["flat","ivfflat"]
quantizer = faiss.IndexFlatL2(d)
# quantizer.add(np.zeros((1, d), dtype='float32'))

if True:
    for name in testname:
        print("============== test", name)
        
        print(
            f'ncent, probe, rank, Recall@, speed(ms/query), search_time, qps, memory size'
        )
        for nprobe in 1, 2, 4, 6, 8, 12, 16, 24, 32, 48, 64, 128:
            if name == 'flat':
                index = faiss.index_factory(d, "Flat")
            elif name == "ivfflat":
                index = faiss.IndexIVFFlat(quantizer, d, ncent, faiss.METRIC_L2)                       
                index.nprobe = nprobe  
            # print("----> train")       
            t0 = time.time()
            index.train(xt)
            train_time = time.time() - t0
            # print("[%.3f s] train" % (time.time() - t0))
            
            # print("----> add")
            t0 = time.time()
            index.add(xb)
            add_time = time.time() - t0
            # print("[%.3f s] add" % (time.time() - t0))            
            
            # print("----> search")
            t0 = time.time()
            for i in range(1, 5):
                D, I = index.search(xq, k)
            # print(f"I:{I}")
            search_time = time.time() - t0

            ms = get_memory(index) / (1024 * 1024)

            speed = search_time * 1000 / nq
            qps = 1000 / speed

            # for rank in 1: 
            rank = k               
            corrects = (gt[:, :1] == I[:, :rank]).sum()
            recall = corrects / nq
            print(
                f'{ncent}, {nprobe:3d}, Recall@{rank}, '
                f'{recall:.6f}, {speed:.6f}, {search_time:.2f}, {qps:.2f}, {ms:.0f}'
            )

            if recall == 1 :
                break                        

            # print("ncent[%.0f] probe[%.0f] train [%.3f s] add [%.3f s] search [%.3f s] memory size [%.3f M] " % (
            #     ncent,
            #     probe, 
            #     train_time, 
            #     add_time,
            #     search_time,
            #     ms
            # ))
            # # print("[%.3f s] search" % (time.time() - t0))

            # # print("[%.3f s] eval" % (time.time() - t0))
            # for rank in 1, 10, 100:
            #     n_ok = (I[:, :rank] == gt[:, :1]).sum()
            #     cb = (n_ok / float(nq))
            #     print(("%.4f" % cb), end=' ')
            # print()
            # if cb == 1 :
            #     break
            del index
            

if False:
    for name, qtype in variants:

        print("============== test", name)

        for rsname, vals in [('RS_minmax',
                              [-0.4, -0.2, -0.1, -0.05, 0.0, 0.1, 0.5]),
                             ('RS_meanstd', [0.8, 1.0, 1.5, 2.0, 3.0, 5.0, 10.0]),
                             ('RS_quantiles', [0.02, 0.05, 0.1, 0.15]),
                             ('RS_optim', [0.0])]:
            for val in vals:
                print("%-15s %5g    " % (rsname, val), end=' ')
                index = faiss.IndexIVFScalarQuantizer(quantizer, d, ncent,
                                                      qtype, faiss.METRIC_L2)
                index.nprobe = 16
                index.sq.rangestat = getattr(faiss.ScalarQuantizer,
                                          rsname)

                index.rangestat_arg = val

                index.train(xt)
                index.add(xb)
                t0 = time.time()
                D, I = index.search(xq, 100)
                t1 = time.time()

                for rank in 1, 10, 100:
                    n_ok = (I[:, :rank] == gt[:, :1]).sum()
                    print("%.4f" % (n_ok / float(nq)), end=' ')
                print("   %.3f s" % (t1 - t0))
