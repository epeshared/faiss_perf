export MKL_PATH=/root/miniconda3/lib
cmake -B build -DFAISS_ENABLE_GPU=OFF -DFAISS_ENABLE_PYTHON=ON -DBUILD_SHARED_LIBS=ON  \
    -DCMAKE_BUILD_TYPE=Release -DFAISS_OPT_LEVEL=avx2 -DBLA_VENDOR=Intel10_64lp_dyn \
    "-DMKL_LIBRARIES=-Wl,--start-group;${MKL_PATH}/libmkl_intel_lp64.so;${MKL_PATH}/libmkl_gnu_thread.so;${MKL_PATH}/libmkl_core.so;-Wl,--end-group" \
    -DPython_EXECUTABLE=/usr/bin/python3 \
    -DPython_INCLUDE_DIRS=/usr/include/python3.10/ \
    -DPython_LIBRARIES=/usr/lib/python3.10/ \
    -DPython_NumPy_INCLUDE_DIRS=/usr/include/python3.10/numpy/ \
    . 

make -C build -j faiss
make -C build -j swigfaiss
(cd build/faiss/python && python3 setup.py install)
 make -C build install