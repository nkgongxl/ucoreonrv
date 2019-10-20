# Lab0：实验环境配置

1. ## 环境准备

   下载安装VMware，Ubuntu 18.0镜像文件，根据VMware的指引创建虚拟机。[下载](https://github.com/ring00/ucore_os_lab/tree/riscv32)ucore_os_lab_riscv-32源码，并把之拖入到虚机的/home目录下。虚机配置如下，当然硬盘可以少一点。
   
   ![虚机配置](https://github.com/KeLee5453/os_lab_ucore_riscv32/blob/master/picture/1.png)
   
2. ## 安装必要的依赖包

   （源码里有直接部署的sh文件，但不建议此操作）

   打开终端，运行以下代码：

   ```sh
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
   ```

   接下来有两种方案可以选择：

   1. ### 内网下载编译好的包

      下载内网里的[包]( http://oslab.mobisys.cc/ucore/toolchain/_install.tar.bz2) ，并解压到_install文件夹下。

   2. ### 自行从源码编译

       gcc, binutils, newlib下载源码

      ```sh
      git clone --recursive https://github.com/riscv/riscv-gnu-toolchain
      pushd riscv-gnu-toolchain
      ```

      这三个工具链已经在内网里面。可以直接[下载]( http://oslab.mobisys.cc/ucore/toolchain/riscv-gnu-toolchain-src.tar )。

      下载完后进行配置：

      ```sh
      ./configure --prefix=$(pwd)/../_install --with-arch=rv32g --with-abi=ilp32
      ```
      
      然后开始正式编译
      
      ```sh
      make
      popd
      ```
      
   3. ### 设置环境变量

       两种方案都要设置环境变量，根据自己的路径添加
       
       在终端使用vim打开 /etc/bash.bashrc （该文件是每一个运行终端的用户都会读取此文件），然后追加以下命令：
       
       ```sh
       export PATH="$PATH:/home/kelee/riscv/_install/bin
       ```

3. ## 安装QEMU

   同样安装qemu有两个方案可以选择，从内网下载解压或者按如下方法：

   ```sh
   wget https://download.qemu.org/qemu-3.1.0.tar.xz
   tar -xf qemu-3.1.0.tar.xz
   pushd qemu-3.1.0
   ```

   然后继续运行（如果是内网下载的，cd到该文件夹，然后运行）：

   ```sh
   ./configure --prefix=`pwd`/../_install --target-list=riscv32-softmmu,riscv32-linux-user,riscv64-softmmu,riscv64-linux-user
   make -j`nproc` install
   popd
   ```

4. ## 使用GDB进行调试

   RISC-V toolchains里提供了相应的gdb工具，要使用gdb，就需要对脚本进行修改。

   1. ### 脚本的修改

      在源代码的文件夹中，找到src/lab1中的Makefile文件然后找到`CC              := $(GCCPREFIX)gcc ` 在后面添加-g。

   2. ### 使用GDB进行调试

      因为gdb和qemu是两个应用不能直接交流，比较常用的方法是以tcp进行通讯，也就是让qemu在localhost::1234端口上等待。

      在src/lab1文件夹下打开终端，运行`qemu-system-riscv32 -S -s -hda ./bin/ucore.img` ；然后在该文件夹下重新打开一个终端，运行`riscv32-unknown-elf-gdb ./bin/kernel` ；接着连接qemu：

      ```sh
      (gdb) target remote :1234
      ```

      连接成功输入si就可以进行运行下一条指令，gdb的简单使用可参考清华OS实验ucore[实验指导书](https://chyyuu.gitbooks.io/ucore_os_docs/content/) 或自行查阅手册等文档。

5. ## 成功表现

   ![成功界面1](https://github.com/KeLee5453/os_lab_ucore_riscv32/blob/master/picture/2.png)

   在lab1目录下运行`make qemu` 出现如下信息就证明配置成功

   ![成功界面2](https://github.com/KeLee5453/os_lab_ucore_riscv32/blob/master/picture/3.png)

   

6. ## 常见问题

   1. 首先不要断电与合上电脑，因为装在硬盘上，一不小心拔了就哦豁，全部重来
   2. Ubuntu18.0 比较好用的是，可以直接在目录下直接右键调出终端，不用去cd，而且样式也有ios/windows的影子。
   3. 重启可以解决很多问题
   4. 解决依赖关系（安装应用）的最好办法是使用 `sudo aptitude install` +库名/软件名。
   5. 配置环境时候有的步骤，下载速度会很慢，不要悲伤，不要心急，它总会下载完毕。电脑千万不要熄屏。
   6. 在每次移动电脑时一定要乖乖的关闭虚拟机。用硬盘的话弹出硬盘再进行移动。一切都小心一点。

   7. make qemu 或者 编译过程中提示缺少库文件 如 "error while loading shared libraries" 、"xxx is required to compile xxx" 。一般解决方法是缺少哪个库就安装哪个库，最好使用`sudo aptitude install` +库名；如果不能解决就只有自行搜索错误，然后解决。

   8. 在编译内核时我出现的问题如下：

      ![问题1]( https://github.com/KeLee5453/os_lab_ucore_riscv32/blob/master/picture/4.png)

      解决方法是：

      终端运行：

      `$ ls -ld $(locate -r libmpfr.*\.so.*)` 

      发现有：

      ![解决](https://github.com/KeLee5453/os_lab_ucore_riscv32/blob/master/picture/5.png)

      那么把libmpfr.so.6与libmpfr.so.4关联起来，

      也就是运行：

      ` sudo ln -s /usr/lib/x86_64-linux-gnu/libmpfr.so.6 /usr/lib/libmpfr.so.4` 

      就可以成功编译。如果遇到类似的版本过高的问题可以解决，或者使用Ubuntu14.0重新开始。

