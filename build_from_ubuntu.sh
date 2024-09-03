#!/bin/bash -e

FAISS_REPO=https://github.com/intel-sandbox/xps-prc-ds-faiss-opt.git

# 更新系统软件包
apt-get update -y
apt-get upgrade -y

# 安装编译工具
apt-get install -y build-essential

# 安装 wget、git 和 vim
apt-get install -y wget git vim

# 安装软件包管理工具
apt-get install -y software-properties-common

# 安装 lsb-release
apt-get install -y lsb-release

# 添加 Kitware 仓库和 Key
wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null
apt-add-repository 'deb https://apt.kitware.com/ubuntu/ $(lsb_release -cs) main'
apt-get update -y

# 安装 CMake
apt-get install -y cmake

# 安装构建工具和依赖库
apt-get install -y libtool autoconf unzip wget

# 下载 Miniconda
wget https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh
chmod a+x Miniforge3-Linux-x86_64.sh
bash ./Miniforge3-Linux-x86_64.sh -b -u

echo 'export PATH=/root/miniforge3/bin:$PATH' >> ~/.bashrc
source ~/.bashrc

# 安装 Linux 性能分析工具
apt-get install -y linux-tools-common linux-tools-generic linux-tools-$(uname -r)
apt-get install -y nmon htop

# 下载 Faiss 源代码
# url=$FAISS_REPO
# FAISS_FOLDER=$(echo $url | sed 's|.*/||; s|.git$||')
# echo $FAISS_FOLDER

# rm -rf $FAISS_FOLDER
# git clone $FAISS_REPO

FAISS_FOLDER=/home/xtang/faiss-1.8.0/

# 添加自定义脚本并赋予执行权限
cp run_conda.sh $FAISS_FOLDER/
cp run_conda_env.sh $FAISS_FOLDER/
cp build_faiss_miniforge.sh $FAISS_FOLDER/
chmod a+x $FAISS_FOLDER/run_conda.sh
chmod a+x $FAISS_FOLDER/run_conda_env.sh
chmod a+x $FAISS_FOLDER/build_faiss_miniforge.sh

# 安装 SWIG
pip3 install swig==4.1.0
# 安装 Python 开发依赖
apt-get install -y python3-dev python3-pip
pip3 install numpy

# 安装 setuptools
pip3 install setuptools

# 克隆 oneDNN 库
rm -rf oneDNN
git clone https://github.com/oneapi-src/oneDNN.git
mv oneDNN ../oneDNN
cd ../oneDNN
mkdir -p build
cd build
cmake ..
make -j
make install
