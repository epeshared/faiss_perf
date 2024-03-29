#!/bin/bash -e

FAISS_HOME=/home/xtang

# 更新系统软件包
yum update -y

# 安装编译工具
yum install -y make automake gcc gcc-c++ kernel-devel

# 安装 wget、git 和 vim
yum install -y wget git vim

# 安装软件包管理工具
yum install -y epel-release

# 安装 lsb-release 和 software-properties-common
yum install -y lsb-release

# 添加 Kitware 仓库和 Key
#wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null
#yum-config-manager --add-repo https://apt.kitware.com/ubuntu/$(lsb_release -cs)/main
yum update -y
#yum install -y kitware-archive-keyring

# 安装 CMake
yum install -y cmake

# 安装构建工具和依赖库
yum groupinstall -y "Development Tools"
yum install -y libtool autoconf unzip wget

# 下载 Miniconda
wget https://repo.anaconda.com/miniconda/Miniconda3-py310_23.5.2-0-Linux-x86_64.sh
chmod a+x Miniconda3-py310_23.5.2-0-Linux-x86_64.sh
bash ./Miniconda3-py310_23.5.2-0-Linux-x86_64.sh -b

# 安装 Linux 性能分析工具
yum install -y perf nmon htop
#yum update -y

# 下载 Faiss 源代码
rm -rf faiss
rm -rf ${FAISS_HOME}/faiss
wget https://github.com/facebookresearch/faiss/archive/refs/tags/v1.7.4.tar.gz
tar -xvf v1.7.4.tar.gz
mv faiss-1.7.4 faiss

# 添加自定义脚本并赋予执行权限
cp run_conda.sh faiss/
cp run_conda_env.sh faiss/
cp build_faiss.sh faiss/
chmod a+x faiss/run_conda.sh
chmod a+x faiss/run_conda_env.sh
chmod a+x faiss/build_faiss.sh
mv faiss ${FAISS_HOME}/

# 安装 SWIG
yum install -y swig

# 安装 Python 开发依赖
yum install -y python3-devel
#yum install -y python3-numpy-devel
yum install -y python3-pip
pip3 install numpy

# 安装 setuptools
pip3 install setuptools

# 克隆 Faiss 性能测试库
#git clone https://github.com/epeshared/faiss_perf.git

# 安装 Linux 性能工具包
#yum install -y linux-tools-6.2.0-36-generic

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
