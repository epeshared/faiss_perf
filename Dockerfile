FROM ubuntu:22.04

RUN apt-get update -y
RUN apt install -y build-essential libopenblas-dev libaio-dev python3-dev python3-pip
RUN pip3 install conan==1.59.0 --user
RUN apt install -y git cmake
RUN apt-get install -y apt-transport-https ca-certificates gnupg software-properties-common wget
WORKDIR /home/
RUN git clone https://github.com/epeshared/faiss.git

RUN wget -O- https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB | gpg --dearmor | tee /usr/share/keyrings/oneapi-archive-keyring.gpg > /dev/null
RUN echo "deb [signed-by=/usr/share/keyrings/oneapi-archive-keyring.gpg] https://apt.repos.intel.com/oneapi all main" | tee /etc/apt/sources.list.d/oneAPI.list
RUN apt update -y
RUN apt install -y intel-oneapi-mkl

# RUN wget https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB
# RUN apt-key add GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB
# RUN sh -c 'echo deb https://apt.repos.intel.com/mkl all main > /etc/apt/sources.list.d/intel-mkl.list'
# RUN apt update -y

RUN wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor -o /usr/share/keyrings/kitware-archive-keyring.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/kitware.list
RUN apt update -y
RUN apt install -y cmake swig
RUN pip3 install numpy

# RUN /opt/intel/oneapi/./modulefiles-setup.sh
# RUN . /opt/intel/oneapi/setvars.sh 
# WORKDIR /home/faiss
# RUN cmake -B build . -DFAISS_ENABLE_GPU=OFF -DBUILD_TESTING=OFF -DFAISS_ENABLE_PYTHON=ON -DPython_EXECUTABLE=/usr/bin/python3 -DPython_LIBRARIES=/usr/lib/python3.10 -DCMAKE_BUILD_TYPE=Release \
#     -DFAISS_OPT_LEVEL=avx512 -DFAISS_ENABLE_C_API=ON -DPython_INCLUDE_DIRS=/usr/include/python3.10 -DFAISS_ENABLE_MKL=ON -DBLA_VENDOR=Intel10_64lp_seq -DMKL_LIBRARIES=/opt/intel/oneapi/mkl/latest/lib/intel64/libmkl_rt.so

# RUN cmake -B build . -DFAISS_ENABLE_GPU=OFF -DBUILD_TESTING=ON -DFAISS_ENABLE_PYTHON=ON -DPython_EXECUTABLE=/usr/bin/python3 -DPython_LIBRARIES=/usr/lib/python3.10 
#   -DPython_INCLUDE_DIRS=/usr/include/python3.10 -DCMAKE_BUILD_TYPE=Release  -DFAISS_OPT_LEVEL=avx512
# RUN make -C build -j faiss 
# RUN make -C build -j install
# RUN make -C build -j swigfaiss
# RUN cd build/faiss/python && python3 setup.py install

RUN apt-get install -y linux-tools-common linux-tools-generic
RUN apt install -y vim
ADD run.sh /home/faiss/
RUN chmod a+x /home/faiss/run.sh

WORKDIR /home/
RUN git clone https://github.com/milvus-io/knowhere.git

WORKDIR /home/faiss/
