# Copyright (c) Facebook, Inc. and its affiliates.
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.

import time
import numpy as np
import faiss
from datasets import load_sift1M
from datasets import load_deep1B
from datasets import get_memory
from datasets import evaluate
import multiprocessing as mp

print("load data")

xb, xq, xt, gt = load_sift1M()
nq, d = xq.shape

k = 1
m = 32


nlist = 1024
coarse_quantizer = faiss.IndexFlatL2(d)
# index = faiss.IndexIVFPQ(coarse_quantizer, d, nlist, m, nbits)
index = faiss.index_factory(d, "IVF1024,PQ32x4fs")

faiss.omp_set_num_threads(mp.cpu_count())

t0 = time.time()
index.train(xt)
train_time = time.time() - t0
# print("[%.3f s] train" % (time.time() - t0))

print("----> add")
t0 = time.time()
index.add(xb)
add_time = time.time() - t0
# print("[%.3f s] add" % (time.time() - t0))            

print(f"----> search nq: {nq}")
print(
    f'nprobe, Recall@{k}, '
    f'speed(ms/query), search_time, qps, memory_size'
)

for nprobe in 1, 2, 4, 6, 8, 12, 16, 24, 32, 48, 64, 128:
    index.nprobe = nprobe
    t0 = time.time()
    for i in range(1, 5):
        D, I = index.search(xq, k)
    search_time = time.time() - t0

    ms = get_memory(index) / (1024 * 1024)

    speed = search_time * 1000 / nq
    qps = 1000 / speed

    corrects = (gt == I).sum()
    recall = corrects / nq
    # rank = k               
    # corrects = (gt[:, :rank] == I[:, :rank]).sum()
    # recall = corrects / nq    
    print(
        f'{index.nprobe:3d},'
        f'{recall:.6f}, {speed:.6f}, {search_time:.2f}, {qps:.2f}, {ms:.0f}'
    )    
    # print("[%.3f s] search" % (time.time() - t0))

    # print("[%.3f s] eval" % (time.time() - t0))
    # for rank in 1, 10, 100:
    #     n_ok = (I[:, :rank] == gt[:, :1]).sum()
    #     cb = (n_ok / float(nq))
    #     print(("%.4f" % cb), end=' ')
    # print()
