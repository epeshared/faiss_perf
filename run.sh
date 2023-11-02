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

# setup oneAPI environment
/opt/intel/oneapi/./modulefiles-setup.sh
. /opt/intel/oneapi/setvars.sh
export INTEL_ROOT=/opt/intel/oneapi/

# specify the intel mkl library path
export LDFLAGS="-L${INTEL_ROOT}/mkl/latest/lib/intel64“

# specify the intel optimized omp and other libraries
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${INTEL_ROOT}/mkl/latest/lib/intel64:${INTEL_ROOT}/compiler/latest/linux/lib:/usr/local/lib64/“
export LIBS="-lmkl_rt -lpthread -lm -ldl -L${INTEL_ROOT}/compiler/latest/linux/compiler/lib/intel64“
# specify intel oneAPI compiler
# export CXX="icpx“ 


export MKLROOT=/opt/intel/oneapi/mkl/latest/lib/intel64/
# cp FindMKL.cmake /home/faiss/cmake/FindMKL.cmake

cmake -B build . -DFAISS_ENABLE_GPU=OFF -DBUILD_TESTING=OFF -DFAISS_ENABLE_PYTHON=ON -DPython_EXECUTABLE=/usr/bin/python3 -DPython_LIBRARIES=/usr/lib/python3.10 -DCMAKE_BUILD_TYPE=Release \
     -DFAISS_OPT_LEVEL=avx2 -DFAISS_ENABLE_C_API=ON -DPython_INCLUDE_DIRS=/usr/include/python3.10 -DBLA_VENDOR=Intel10_64ilp

# RUN cmake -B build . -DFAISS_ENABLE_GPU=OFF -DBUILD_TESTING=ON -DFAISS_ENABLE_PYTHON=ON -DPython_EXECUTABLE=/usr/bin/python3 -DPython_LIBRARIES=/usr/lib/python3.10 -DPython_INCLUDE_DIRS=/usr/include/python3.10 -DCMAKE_BUILD_TYPE=Release  -DFAISS_OPT_LEVEL=avx512
make -C build -j faiss 
make -C build -j install
make -C build -j swigfaiss
cd build/faiss/python && python3 setup.py install

export PATH=/usr/lib/linux-tools/5.15.0-76-generic/:$PATH

echo "ldd /usr/local/lib/python3.10/dist-packages/faiss-1.7.4-py3.10.egg/faiss/_swigfaiss_avx2.so"

ldd /usr/local/lib/python3.10/dist-packages/faiss-1.7.4-py3.10.egg/faiss/_swigfaiss_avx2.so

# cp ../FindMKL.cmake /home/faiss/cmake/FindMKL.cmake
# conda install -c pytorch faiss-cpu=1.7.4 mkl=2021 blas=1.0=mkl
# python3 bench_polysemous_1bn.py Deep1B OPQ20_80,IMI2x14,PQ20 autotune

#docker exec -it faiss_perf