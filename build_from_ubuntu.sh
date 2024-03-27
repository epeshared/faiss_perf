#!/bin/bash -e

# Update packages
apt-get update -y
apt install -y build-essential wget git vim software-properties-common lsb-release

# Change working directory
#cd /home/

# Install Latest CMake
wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null
apt-add-repository "deb https://apt.kitware.com/ubuntu/ $(lsb_release -cs) main"
apt update -y
apt install kitware-archive-keyring -y
apt update -y
apt install cmake -y
apt install -y build-essential libtool autoconf unzip wget

# Install Miniconda
rm -rf /root/miniconda3
wget https://repo.anaconda.com/miniconda/Miniconda3-py310_23.5.2-0-Linux-x86_64.sh
chmod a+x Miniconda3-py310_23.5.2-0-Linux-x86_64.sh
bash ./Miniconda3-py310_23.5.2-0-Linux-x86_64.sh -b

# Install tools and libraries
apt-get install -y linux-tools-common linux-tools-generic swig python3-dev python3-numpy-dev python3-pip
apt install -y linux-tools-6.2.0-36-generic

# Download and prepare faiss
#wget https://github.com/facebookresearch/faiss/archive/refs/tags/v1.7.4.tar.gz
#tar -xvf v1.7.4.tar.gz
wget https://github.com/facebookresearch/faiss/archive/refs/tags/v1.8.0.tar.gz
tar -xvf v1.8.0.tar.gz
mv faiss-1.8.0 ../faiss

# Assuming you have 'run_conda.sh', 'run_conda_env.sh', and 'build_faiss.sh' in your current directory
cp run_conda.sh ../faiss/
cp run_conda_env.sh ../faiss/
chmod a+x ../faiss/run_conda.sh ../faiss/run_conda_env.sh

# Setup build for faiss
cp build_faiss.sh ../faiss/
chmod a+x ../faiss/build_faiss.sh

# Python package installations
pip3 install setuptools

# Clone necessary repositories
#git clone https://github.com/epeshared/faiss_perf.git
cd ../
git clone https://github.com/oneapi-src/oneDNN.git

rm -rf v1.8.0.tar.gz
rm -rf Miniconda3-py310_23.5.2-0-Linux-x86_64.sh

# Note: To run the scripts inside faiss directory, navigate to /home/faiss and execute them as needed.


