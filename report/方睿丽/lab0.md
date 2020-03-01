# Lab0 实验环境配置

## 1. 安装必要的依赖包
```
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
```
以下有[1.1](https://github.com/rllly/ucore-on-riscv/new/master#11-%E4%B8%8B%E8%BD%BD%E7%BC%96%E8%AF%91%E5%A5%BD%E7%9A%84%E5%8C%85)、
[1.2](https://github.com/rllly/ucore-on-riscv/new/master#12-%E8%87%AA%E8%A1%8C%E4%BB%8E%E6%BA%90%E4%BB%A3%E7%A0%81%E7%BC%96%E8%AF%91)
两种方案，一种是直接下载编译好的安装包，两个方案选择任何一种均可
### 1.1 下载编译好的包
[下载](http://oslab.mobisys.cc/ucore/toolchain/_install.tar.bz2
)，把它解压到刚刚建立的_install目录下

### 1.2 自行从源代码编译

gcc, binutils, newlib
下载源码
```
git clone --recursive https://github.com/riscv/riscv-gnu-toolchain
pushd riscv-gnu-toolchain
```
注意，上面这部分已经[内网搬运了](http://oslab.mobisys.cc/ucore/toolchain/riscv-gnu-toolchain-src.tar)
```
./configure --prefix=$(pwd)/../_install --with-arch=rv32g --with-abi=ilp32
```
'-jx'是一个并行编译flag，‘nporc’代表同时编译的数目。这里不能使用并行编译，只能由系统按照顺序自己编（也就是说别跑下面这一条）
```
make -j`nproc` 
```
正式开始编译
```
make
popd
```

### 1.3 设置环境变量
```
export PATH=$(pwd)/_install/bin:$PATH
```
（这里需要注意的是，export语句设置环境变量的有效期只限于执行这个命令的terminal，如果想要一劳永逸地解决环境变量问题可以修改bash.rc文件：
“/etc/bashrc或/etc/bash.bashrc:为每一个运行bash shell的用户执行此文件.当bash shell被打开时,该文件被读取。如果你想对所有的使用bash的用户修改某个配置并在以后打开的bash都生效的话可以修改这个文件，修改这个文件不用重启，重新打开一个bash即可生效。”）


## 2 安装qemu （[已搬运内网](http://oslab.mobisys.cc/ucore/toolchain/qemu-3.1.0.tar.xz)）
下载（如果直接从内网下载请忽略这一条）
```
wget https://download.qemu.org/qemu-3.1.0.tar.xz
```
解压安装
```
tar -xf qemu-3.1.0.tar.xz
pushd qemu-3.1.0
./configure --prefix=`pwd`/../_install --target-list=riscv32-softmmu,riscv32-linux-user,riscv64-softmmu,riscv64-linux-user
make -j`nproc` install
popd
```
## 3 使用gdb进行调试
作为一个操作系统实验怎么能没有gdb！RISC-V toolchains中提供了相应的gdb工具，但是移植后实验的编译脚本并没有gdb选项，如果要进行相应调试的话需要自己在脚本中添加一些flag。\
### 3.1 脚本的修改
1. gdb所调试的文件是需要有debug info的，所以我们需要在编译选项中加-g（jos中加的是-gstab）。为了方便可以直接在`CC:= $(GCCPREFIX)gcc`之后挂上，但是这个不是makefile的规范写法，好孩子不要学。\
2. gdb可以和qemu是两个应用程序所以不能直接交流，比较常用的方法是以tcp进行通信。在编译好内核之后我们运行qemu，告诉它这回我们需要它和gdb进行通信，让它在localhost的1234端口上等着：`-gdb tcp::1234`，同时加上`-S`，告诉qemu等待gdb发出了`continue`指令之后在运行。同样这两个flag可以挂在`QEMU := qemu-system-riscv32`之后。\
### 3.2 使用gdb进行调试
1. 在成功启动了qemu之后打开另一个终端启动gdb。注意这里我们使用的gdb版本不是默认的"x86_64-linux-gnu"而是toolchains中的gdb，所以我们要输入riscv gdb的全称。打开相应lab中bin文件夹下的kernel文件。
（也就是说运行指令`riscv32-unknown-elf-gdb kernel`）\
2. 连接qemu。
```
(gdb) target remote :1234
```
连接成功，输入`continue`kernel就会接着运行了。具体gdb的使用可以[参考](https://pdos.csail.mit.edu/6.828/2017/labguide.html)其中QEMU一节（或者自行百度）。


## 4 常见问题
### 4.1 如何验证交叉编译器工作正常
```
echo -e '#include <stdio.h>\n int main(void) { printf("Hello world!\\n"); return 0; }' > hello.c
riscv32-unknown-elf-gcc hello.c -o hello
```
运行之后 ***能够生成 hello 文件没有报错*** 就代表成功。

这里需要提醒一下，用编译好的编译器编译出来的hello文件并不能直接运行，因为编译出来的二进制文件是在riscv架构下运行的二进制文件，
和你的电脑的架构是不一样的......欲知详情请自行搜索“交叉编译”或者“体系结构”

### 4.2 如何验证交叉编译器和qemu配合正常
进入ucore_os_lab/src/lab1 目录下，运行make qemu 后显示“R”型LOGO代表配置成功（如下图）
```
              vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
                  vvvvvvvvvvvvvvvvvvvvvvvvvvvv
rrrrrrrrrrrrr       vvvvvvvvvvvvvvvvvvvvvvvvvv
rrrrrrrrrrrrrrrr      vvvvvvvvvvvvvvvvvvvvvvvv
rrrrrrrrrrrrrrrrrr    vvvvvvvvvvvvvvvvvvvvvvvv
rrrrrrrrrrrrrrrrrr    vvvvvvvvvvvvvvvvvvvvvvvv
rrrrrrrrrrrrrrrrrr    vvvvvvvvvvvvvvvvvvvvvvvv
rrrrrrrrrrrrrrrr      vvvvvvvvvvvvvvvvvvvvvv  
rrrrrrrrrrrrr       vvvvvvvvvvvvvvvvvvvvvv    
rr                vvvvvvvvvvvvvvvvvvvvvv      
rr            vvvvvvvvvvvvvvvvvvvvvvvv      rr
rrrr      vvvvvvvvvvvvvvvvvvvvvvvvvv      rrrr
rrrrrr      vvvvvvvvvvvvvvvvvvvvvv      rrrrrr
rrrrrrrr      vvvvvvvvvvvvvvvvvv      rrrrrrrr
rrrrrrrrrr      vvvvvvvvvvvvvv      rrrrrrrrrr
rrrrrrrrrrrr      vvvvvvvvvv      rrrrrrrrrrrr
rrrrrrrrrrrrrr      vvvvvv      rrrrrrrrrrrrrr
rrrrrrrrrrrrrrrr      vv      rrrrrrrrrrrrrrrr
rrrrrrrrrrrrrrrrrr          rrrrrrrrrrrrrrrrrr
rrrrrrrrrrrrrrrrrrrr      rrrrrrrrrrrrrrrrrrrr
rrrrrrrrrrrrrrrrrrrrrr  rrrrrrrrrrrrrrrrrrrrrr
```

### 4.3 编译或运行时提示缺少库文件
make qemu 或者 编译过程中提示缺少库文件
如 "error while loading shared libraries" 、"xxx is required to compile xxx" 

- 自助解决办法是百度缺少的库文件是在哪个package里，然后 sudo apt-get install [package 名]。大多数情况下是报错里提到的名字或者加"-dev"但是非绝对，还是搜一下比较保险。（推荐先自己根据报错安装，因为每个人的环境多少有些不同，文档不太可能列举所有情况）

- 如果是直接使用解压的tools（_install），在make qemu后可能会提示 不能运行，因为缺少libxxx.so文件。
目前出现过的提示有 libsdl2-2.0，libaio和libpng12-0，运行 sudo apt-get install libsdl2-2.0 libaio-dev libpng12-0即可。
ubuntu在14以上的版本中取消了对libpng12-0的支持，所以需要一些特殊的方法进行安装。
```
sudo vim /etc/apt/source.list 
```
（当然如果你比较习惯图形化界面其实可以把vim 换成 gedit）

在文件最后一行加上：
```
deb http://cz.archive.ubuntu.com/ubuntu xenial main
```
保存,更新package list
```
sudo apt-get update
sudo apt-get install libpng12-0
```

### 3.4 安装工具包（_install）失败之后再次自行编译源码失败
在 make之后没有反应。 原因是原先解压或者安装后的_install文件夹没有删除，脚本运行的时候默认已经安装好了，所以会提示“没有什么可做的为‘install’”。这个时候把原先的文件夹删掉或者先移动到别的地方再进行编译吧。

### 3.5 玄学问题
出现:
error: riscv32-known-elf-gcc: ...ELF... not found
原因可能是你用的虚拟机是32位的......少年你重新装个虚拟机吧......

