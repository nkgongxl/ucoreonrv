# 实验一：系统软件启动过程

## 练习一

### ucore.img的生成

运行`make "V="`后输出类似如下内容可分为四个部分

#### 第一部分

```shell
- cc kern/init/init.c
  gcc -Ikern/init/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Ikern/debug/ -Ikern/driver/ -Ikern/trap/ -Ikern/mm/ -c kern/init/init.c -o obj/kern/init/init.o
- cc kern/libs/stdio.c
  gcc -Ikern/libs/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Ikern/debug/ -Ikern/driver/ -Ikern/trap/ -Ikern/mm/ -c kern/libs/stdio.c -o obj/kern/libs/stdio.o
- cc kern/libs/readline.c
  gcc -Ikern/libs/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Ikern/debug/ -Ikern/driver/ -Ikern/trap/ -Ikern/mm/ -c kern/libs/readline.c -o obj/kern/libs/readline.o
......
```

该部分将各个C文件编译为obj文件，主要编译选项有：

* `-m32` 生成32位环境下的目标
* `-ggdb`,`-gsatbs` 提供调试信息
* `-nostdinc` 不搜索当前环境下的标准头文件
* `-Ikern/libs`等 将文件夹加入头文件搜索路径

#### 第二部分

```shell
ld bin/kernel

ld -m    elf_i386 -nostdlib -T tools/kernel.ld -o bin/kernel  obj/kern/init/init.o obj/kern/libs/stdio.o obj/kern/libs/readline.o obj/kern/debug/panic.o obj/kern/debug/kdebug.o obj/kern/debug/kmonitor.o obj/kern/driver/clock.o obj/kern/driver/console.o obj/kern/driver/picirq.o obj/kern/driver/intr.o obj/kern/trap/trap.o obj/kern/trap/vectors.o obj/kern/trap/trapentry.o obj/kern/mm/pmm.o  obj/libs/string.o obj/libs/printfmt.o
```

该部分将上一步生成的obj文件链接到一起，产生`bin/kernel`文件

* `-m elf_i386` 模拟elf_i386连接器
* `-nostdlib` 不使用标准库
* `-T tools/kernel.ld` 使用kernel.ld中的配置链接文件

#### 第三部分

```shell
- cc boot/bootasm.S
  gcc -Iboot/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Os -nostdinc -c boot/bootasm.S -o obj/boot/bootasm.o
- cc boot/bootmain.c
  gcc -Iboot/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Os -nostdinc -c boot/bootmain.c -o obj/boot/bootmain.o
- cc tools/sign.c
  gcc -Itools/ -g -Wall -O2 -c tools/sign.c -o obj/sign/tools/sign.o
  gcc -g -Wall -O2 obj/sign/tools/sign.o -o bin/sign
```

编译BootLoader，并生成将BootLoader补齐到512字节的工具`bin/sign`

* `-Os` 提示编译器尽量减小目标码的体积

#### 第四部分

```shell
+ ld bin/bootblock
ld -m    elf_i386 -nostdlib -N -e start -Ttext 0x7C00 obj/boot/bootasm.o obj/boot/bootmain.o -o obj/bootblock.o
'obj/bootblock.out' size: 488 bytes
build 512 bytes boot sector: 'bin/bootblock' success!
dd if=/dev/zero of=bin/ucore.img count=10000
dd if=bin/bootblock of=bin/ucore.img conv=notrunc
dd if=bin/kernel of=bin/ucore.img seek=1 conv=notrunc
```

* 将`bootasm.o`和`bootmain.o`链接到一起
    * `-N` 设置text和data部分可读可写，并且不对数据段进行对齐
    * `-e start` 将entry point设为start
    * `-Ttext 0x7C00` 将代码段的起始地址设为0x7C00
* 执行`bin/sign obj/bootblock.out bin/bootblock`生成512字节的bootblock
    * 不足510字节的部分补0
    * 最后两个字节设为`0x55 0xAA`作为signature
* 用dd生成一个空镜像，然后将bootblock和kernel按次序写入
    * `if=FILE` 从FILE读入数据
    * `of=FILE` 输出到FILE
    * `conv=notrunc` 不截断输出文件
    * `seek=1` 跳过输出开头的512个字节

### 主引导扇区

标准的MBR分区表结构为前466字节为代码段，紧跟64字节的分区表，最后两个字节为Boot Signature

实际上第511和512个字节分别为0x55和0xAA即可被BIOS读入内存中，实验过程如下

```shell
dd if=/dev/zero of=bootloader count=1
echo -ne "\x55\xaa" | dd seek=510 bs=1 of=bootloader
qemu-system-i386 bootloader
```

## 练习二

直接`make debug`或手动在terminal中输入如下

```shell
qemu-system-i386 -S -s -parallel stdio -hda ucore.img
gdb -q -tui -x /tools/gdbinit
```

即可进行单步调试

## 练习三

### 保护模式的进入

从BootLoader进入保护模式可分为三个部分

#### 第一部分

* 进行基本设置
    * `cli` (clear interrupt flag) 使CPU不再接受外部中断
    * `cld` (clear direction flag) 使CPU按从低地址到高地址处理字符串
    * 将若干寄存器置0
* 打开A20 Gate
    * 等待直到8042芯片的输入缓存为空
    * 向0x64端口发送0xD1，意为对P2端口写数据
    * 等待直到8042芯片的输入缓存为空
    * 向0x64端口发送0xDF，打开A20 Gate

#### 第二部分

* `lgdt gdtdesc` 将gdtdesc所指向的6个字节内容读入GDTR
    * 低2位的0x17表明表的大小为24
    * 高4位为表的起始地址
* 将控制寄存器CR0的PE (Protection Enable, bit 0)设为1
* `ljmp $PROT_MODE_CSEG, $protcseg` 将cs寄存器设为$PROT_MODE_CSEG，将eip设为protcseg所指地址

其中GDT由asm.h中提供的宏展开生成，一般描述符的结构如下

```
  31                23                15                7               0
 +-----------------+-+-+-+-+---------+-+-----+-+-----+-+-----------------+
 |                 | | | |A|         | |     | |     | |                 |
 |   BASE 31..24   |G|X|O|V| LIMIT   |P| DPL |1| TYPE|A|  BASE 23..16    | 4
 |                 | | | |L| 19..16  | |     | |     | |                 |
 |-----------------+-+-+-+-+---------+-+-----+-+-----+-+-----------------|
 |                                   |                                   |
 |        SEGMENT BASE 15..0         |       SEGMENT LIMIT 15..0         | 0
 |                                   |                                   |
 +-----------------+-----------------+-----------------+-----------------+
```

`SEG_NULLASM`会产生一个空描述符，SEG_ASM(type,base,lim)会根据参数生成所需的描述符，注意这里取了lim的高20位作为LIMIT。

此处描述符定义的代码段和数据段都是从0x0开始，容量4GB的段。

#### 第三部分

除了cs外的段寄存器都指向数据段，将epb置0，将栈顶指向BootLoader起始处(0x7c00)，调用bootmain

## 练习四

### 读硬盘扇区

BootLoader中读取硬盘的功能是基于`static void readsect(void *dst, uint32_t secno)`函数实现的，该函数可以实现读一个扇区，反复调用可以将kernel完整读入内存。大致过程如下

* 等待磁盘准备好
  * 从0x1F7读入状态码，检查BSY和RDY两个bit
* 向0x1F2端口发送读取的扇区数
* 传送LBA的各个位，发送读取命令
* 等待磁盘准备好
* 读入数据

### 加载ELF格式OS

* 首先读入8个扇区，将ELF文件头读入；
* 上一步从硬盘读入内存的起始地址为0x10000，因此该地址也是ELF文件头的地址；
* 根据文件头提供的信息将kernel读入正确的内存地址
* 调用kernel的入口函数

## 练习五

输出如下

```shell
epb:0x00007b38 eip:0x00100967 arg: 0x00010074 0x00010074 0x00007b68 0x0010007f
    kern/debug/kdebug.c:306: print_stackframe+21
epb:0x00007b48 eip:0x00100c41 arg: 0x00000000 0x00000000 0x00000000 0x00007bb8
    kern/debug/kmonitor.c:125: mon_backtrace+10
epb:0x00007b68 eip:0x0010007f arg: 0x00000000 0x00007b90 0xffff0000 0x00007b94
    kern/init/init.c:48: grade_backtrace2+19
epb:0x00007b88 eip:0x001000a1 arg: 0x00000000 0xffff0000 0x00007bb4 0x00000029
    kern/init/init.c:53: grade_backtrace1+27
epb:0x00007ba8 eip:0x001000be arg: 0x00000000 0x00100000 0xffff0000 0x00100043
    kern/init/init.c:58: grade_backtrace0+19
epb:0x00007bc8 eip:0x001000df arg: 0x00000000 0x00000000 0x0010fd20 0x00103300
    kern/init/init.c:63: grade_backtrace+26
epb:0x00007be8 eip:0x00100050 arg: 0x00000000 0x00000000 0x00000000 0x00007c4f
    kern/init/init.c:28: kern_init+79
epb:0x00007bf8 eip:0x00007d6e arg: 0xc031fcfa 0xc08ed88e 0x64e4d08e 0xfa7502a8
    <unknow>: -- 0x00007d6d --
```

最后一行的0x7d6d = 0x7d6c + 1，而打开bootblock.asm可以看到0x7d6c为调用kernel入口的最后一句指令，所以0x7d6d实际上是调用call指令后压栈的返回地址

## 练习六

### 中断描述符

每个终端描述符占8个字节空间，其中16-31位的bits为段选择子，0-15和48-63位的bits分别为偏移地址的两个字，大致结构如下

```
   31                23                15                7                0
  +-----------------+-----------------+---+---+---------+-----+-----------+
  |           OFFSET 31..16           | P |DPL|0 1 1 1 0|0 0 0|(NOT USED) |4
  |-----------------------------------+---+---+---------+-----+-----------|
  |             SELECTOR              |           OFFSET 15..0            |0
  +-----------------+-----------------+-----------------+-----------------+
```

### 初始化中断描述符表

对idt数组中的每一个终端描述符调用SETGATE进行设置，要注意段描述符应该与`voidpmm_init(void)`中设置的内核代码段描述符地址(0x8)一致。

由于要支持应用程序发出软中断`int 0x80`，需特别将T_SYSCALL的DPL设为3。

### 时钟中断处理

在`static void trap_dispatch(struct trapframe *tf)`中处理时钟中断部分添加如下代码

```c
if (++ticks % TICK_NUM == 0) {
    print_ticks();
}
```

每次收到中断即将全局变量ticks加1，当为100整数倍时调用`print_ticks`。

## 总结

### 实现与参考答案的区别

参考答案限制了print_stackframe的最大深度

### 知识点

* BIOS启动过程：加电后，CPU执行物理地址0xFFFFFFF0处的跳转指令，开始执行BIOS程序
* 保护模式的进入：打开A20地址线->设置全局描述符表->打开保护模式
* 分段机制：逻辑地址可分为段选择子和偏移量，通过段选择子可以找到段描述符，从中取出段基址加上偏移量可得到线性地址，未启用分页机制时即为物理地址
* ELF文件格式：ucore中的`struct elfhdr`和`struct proghdr`表示了ELF文件头的结构
