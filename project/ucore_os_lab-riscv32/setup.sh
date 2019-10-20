#!/bin/bash

sudo apt-get update
sudo apt-get -y install \
  binutils build-essential libtool texinfo \
  gzip zip unzip patchutils curl git \
  make cmake ninja-build automake bison flex gperf \
  grep sed gawk python bc \
  zlib1g-dev libexpat1-dev libmpc-dev \
  libglib2.0-dev libfdt-dev libpixman-1-dev 

mkdir riscv
cd riscv

mkdir _install
export PATH=`pwd`/_install/bin:$PATH

# gcc, binutils, newlib
git clone --recursive https://github.com/riscv/riscv-gnu-toolchain
pushd riscv-gnu-toolchain
./configure --prefix=`pwd`/../_install --with-arch=rv32g --with-abi=ilp32
make -j`nproc`
popd

# qemu
wget https://download.qemu.org/qemu-3.1.0.tar.xz
tar -xf qemu-3.1.0.tar.xz
pushd qemu-3.1.0
./configure --prefix=`pwd`/../_install --target-list=riscv32-softmmu,riscv32-linux-user,riscv64-softmmu,riscv64-linux-user
make -j`nproc` install
popd

# LLVM
git clone https://mirrors.tuna.tsinghua.edu.cn/git/llvm/llvm.git
cd llvm/tools
git clone https://mirrors.tuna.tsinghua.edu.cn/git/llvm/clang.git
cd ..
# [RISCV] Generate address sequences suitable for mcmodel=medium: https://reviews.llvm.org/D54143
# wget https://reviews.llvm.org/file/data/khhutlamvitbtmkst5vr/PHID-FILE-z5rasjekyqodswys6m6p/D54143.diff
# patch -p0 < D54143.diff
mkdir build
cd build
cmake -G Ninja -DCMAKE_BUILD_TYPE="Release" \
  -DBUILD_SHARED_LIBS=True -DLLVM_USE_SPLIT_DWARF=True \
  -DCMAKE_INSTALL_PREFIX="../../_install" \
  -DLLVM_OPTIMIZED_TABLEGEN=True -DLLVM_BUILD_TESTS=False \
  -DDEFAULT_SYSROOT="../../_install/riscv32-unknown-elf" \
  -DLLVM_DEFAULT_TARGET_TRIPLE="riscv32-unknown-elf" \
  -DLLVM_TARGETS_TO_BUILD="" \
  -DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD="RISCV" ..
cmake --build . --target install
cd ../..

