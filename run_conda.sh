#!/bin/bash -e

if [ -d "benchs/deep1b" ]; then
    echo "deep1b exist"
else
    echo "deep1b does not exist"
    ln -s ../../deep1b benchs/deep1b
fi

if [ -d "benchs/sift1M" ]; then
    echo "sift1M exist"
else
    echo "sift1M does not exist"
    ln -s ../../sift1M benchs/sift1M
fi

/root/miniconda3/bin/conda init
bash
export PATH=/usr/lib/linux-tools/5.15.0-76-generic/:$PATH
conda install -c pytorch faiss-cpu=1.7.4 mkl=2023 blas=1.0=mkl

# python3 bench_polysemous_1bn.py Deep1B OPQ20_80,IMI2x14,PQ20 autotune
