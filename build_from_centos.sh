#!/bin/bash -e

FAISS_HOME=/home/xtang
FAISS_REPO=https://github.com/intel-sandbox/xps-prc-ds-faiss-opt.git

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
wget https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh
chmod a+x Miniforge3-Linux-x86_64.sh
bash ./Miniforge3-Linux-x86_64.sh -b -u

# 安装 Linux 性能分析工具
yum install -y perf nmon htop
#yum update -y

# 下载 Faiss 源代码
url=$FAISS_REPO
FAISS_FOLDER=$(echo $url | sed 's|.*/||; s|.git$||')
echo $FAISS_FOLDER

rm -rf $FAISS_FOLDER
git clone $FAISS_REPO

# 添加自定义脚本并赋予执行权限
cp run_conda.sh $FAISS_FOLDER/
cp run_conda_env.sh $FAISS_FOLDER/
cp build_faiss.sh $FAISS_FOLDER/
chmod a+x $FAISS_FOLDER/run_conda.sh
chmod a+x $FAISS_FOLDER/run_conda_env.sh
chmod a+x $FAISS_FOLDER/build_faiss.sh

# 安装 SWIG
pip3 install swig

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
