# Lab1 
## 实验内容
借用bootloader初始化OS，完成本节内容后的OS只能处理时钟中断、显示字符。
## 练习
#### 练习1 理解通过make生成执行文件的过程 
列出本实验各练习中对应的OS原理的知识点，并说明本实验中的实现部分如何对应和体现了原理中的基本概念和关键知识点。

在此练习中，大家需要通过静态分析代码来了解：
1. lab1/Makefile，解释操作系统镜像文件ucore.img是如何一步一步生成的？
(需要比较详细地解释Makefile中每一条相关命令和命令参数的含义，以及说明命令导致的结果)

2. [原：一个被系统认为是符合规范的硬盘主引导扇区的特征是什么？]（提示：查看`[riscv-pk/bbl/bbl.lds]`bbl的linkscript和`[src/lab1/tools/kernel.ld]`kernel的linkscript，装载位置(base address)和对其地址(align)）

#### 练习2 使用qemu执行并调试lab1中的软件
插播一下[RISC-V中的gdb使用指南]()和[原ucore中的gdb指导](https://www.bookstack.cn/read/ucore_os_docs/lab0-lab0_2_3_3_gdb.md)以及[(如何利用gdb调试riscv代码)](https://github.com/antmicro/riscv-qemu-archived#using-qemu-to-debug-risc-v-code)。\
联系obj下的kernel.asm、kern/init/entry.S对启动顺序进行理解。


#### （原练习4）
分析bootloader加载ELF格式的OS的过程。（要求在报告中写出分析）

- bootloader如何读取硬盘扇区的？
- bootloader是如何加载ELF格式的OS？
  
- (这里可能要解释一下bbl的payload：就是bootloader装载的东西,也就是我们的kernel。bbl编译前需要configure并在“--with-payload=”之后给出kernel二进制文件路径，在没有给出的情况下会默认是dummy_payload，payload的具体装载过程可以查看`[riscv-pk/bbl/payload.S]`,`[riscv-pk/bbl/]`以及`[riscv-pk/]`目录下的配置文件，也就是configure一系列)

**参考答案**\
[参考1](https://github.com/slavaim/riscv-notes/blob/master/bbl/supervisor_vm_init.md)\
[参考2](https://github.com/slavaim/riscv-notes/blob/master/bbl/boot.md)\
一切从电脑启动开始说起。

通常情况下CPU会从DEFAULT_RSTVEC=0X00001000处获取第一条指令，我们的实验环境，也就是riscv-qemu中（`riscv-qemu/target-riscv/cpu.c: static void riscv_cpu_reset(CPUState *s)`）正常启动也是在这个地址获取第一条指令（PC指向该地址）：

```
#ifndef CONFIG_USER_ONLY
    tlb_flush(s, 1);
    env->priv = PRV_M;
    env->mtvec = DEFAULT_MTVEC;
#endif
    env->pc = DEFAULT_RSTVEC;
    cs->exception_index = EXCP_NONE;
```
利用gdb查看反汇编可以看到0x00001000 处指令：\

```
(gdb) x/2i 0x1000
   0x1000:	auipc	t0,0x7ffff
   0x1004:	jr	t0
```
参考ISA手册，AUIPC指令会将立即数左移12位与pc相加，结果放入目标寄存器。在这里 t0 = 0(x7ffff<<12)+ 0x1000 = 0x80000000。之后的JR是一条跳转指令，将t0的值传入PC。

0x80000000是bbl被链接到的起始位置。在`bbl.lds`中可以看到：
```
OUTPUT_ARCH( "riscv" )

ENTRY( reset_vector )

SECTIONS
{
  /*--------------------------------------------------------------------*/
  /* Code and read-only segment                                         */
  /*--------------------------------------------------------------------*/

  /* Begining of code and text segment */
  . = 0x80000000;
  _ftext = .;
  PROVIDE( eprol = . );

......
```
注意这里把sbi段也链接进来了。同样还有HTIF(Host-Target Interface)，这是一个为QEMU提供的console模拟，在[cons_init]部分会对此进行分析。还可以看到entry是`reset_vector`，在machine/mentry.S中定义。这里是一条跳转指令，跳转到"do_reset"处对一系列寄存器进行初始化操作，如果感兴趣可以自行查看，这里不再详细描述。

之后执行到`beqz a3, init_first_hart`(hart即hardware thread)，跳转到`machine/minit.c`中的该函数，在检查和初始化完成之后执行`boot_loader(dtb)`开始执行boot_loader的功能。

在整个riscv-pk中一共有两个boot_loader函数的定义，一个是bbl/bbl.c中定义，一个是pk/pk.c中定义。大体功能都差不多：打印riscv logo，将设备树fdt传给kernel(dtb)，进入supervisor mode然后跳转到kernel的entry point。在本实验中entry point应当在config中被设置为lab1/kern/init/entry.S

## 装载kernel之后的启动过程
[ld/linkscript文件结构解析参考1](https://blog.csdn.net/yuntongsf/article/details/50461467)\
[ld/linkescript文件结构解析参考2](https://www.cnblogs.com/tureno/articles/3741143.html)\
在上一个练习中我们查看了`tools/kern.ld`，其中`ENTRY(kern_entry)`表明装载之后运行的第一条指令是kern_entry中的。kern_entry这个label在entry.S中被定义，其中包含两条指令：
```
    lla sp, bootstacktop

    tail kern_init
```
参考riscv手册可以得知，第一条指令是把bootstacktop的地址放入寄存器sp中，第二条指令则是把kern_init的地址放入pc，也就是接着执行kern_init函数。
kern_init函数在`lab1/kern/init/init.c`中有定义，大致描述了整个kernel的启动过程：
```
int kern_init(void) {
    extern char edata[], end[];
    memset(edata, 0, end - edata);//将edata~end部分的内存清0

    cons_init();  // init the console

    const char *message = "(THU.CST) os is loading ...\n";
    cprintf("%s\n\n", message);

    print_kerninfo();//打印kern_info

    pmm_init();  // init physical memory management

    pic_init();  // init interrupt controller
    idt_init();  // init interrupt descriptor table

    // rdtime in mbare（v1.9.1-3.7） mode crashes
    clock_init();  // init clock interrupt

    intr_enable();  // enable irq interrupt

    // LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    // lab1_switch_test();
    /* do nothing */
    while (1)
        ;
}
```
- Consol Init \
    相关函数在cosole.c中实现。从riscv提供的文档看sbi已经提供了两个与console输入/输出有关的接口:
    函数声明|details
    -|-
    int sbi_console_putchar(uint8_t ch);| Write byte to debug console (blocking); returns 0 on success, else -1.
    int sbi_console_getchar(void);      | Read byte from debug console; returns the byte on success, or -1 for failure.

    （实际中qemu究竟实现了几个sbi可以查看libs下的riscv.h，想看具体实现去查riscv-pk/machine下的mtrap.c）\
- print kerninfo\
    函数在`kdebug.c`中定义，顾名思义是一个打印kernel相关信息的一个函数，
- pmm_init\
    在`kern/mm/pmm.c`中定义，是原本x86的bootloader从实模式开启并跳转到保护模式的代码，在本实验中不再使用。
- pic_init\
    对中断控制器8259A的初始化和使能操作，然而因为换到了RISCV平台我们不再有这个机制，所以这个函数也不需要实现了。（但是如果感兴趣的话还是可以去大概看一下，学过或者正在学接口的同学应该可以大概看懂原函数在干什么）。
- idt_init\
    函数在trap.c里定义。功能应当是中断（向量）初始化。（在接着往下看之前先看一下[这一节](https://github.com/rllly/ucore_on_riscv_recordings/blob/master/docs/About%20RISC-V.md#%E4%B8%AD%E6%96%AD%E5%92%8Ccsr)）。这个函数主要是初始化相关的CSR。显然在本实验中，如同在其他大多数PC中，由操作系统来解决所有trap，所以idt_init只需要考虑S-mode的相关CSR。与x86不同的是，RISC-V中的“中断向量表”实际上被内化在了CSR中，也就是说我们不需要像x86中那样自己初始化向量表了，只需要初始化中断相关CSR就可以了。

    需要初始化的CSR主要是stvec，这个CSR中应该放着中断处理函数的地址，在触发中断的时候将其中的值赋给PC。本实验中通用中断处理函数是“__alltraps”，该函数在trap.S中定义。可以看到__alltraps把所有寄存器都保存了，而不是遵循[函数调用规范](https://github.com/rllly/ucore_on_riscv_recordings/blob/master/docs/About%20RISC-V.md#%E5%B8%B8%E8%A7%84%E5%87%BD%E6%95%B0%E8%B0%83%E7%94%A8%E8%A7%84%E8%8C%83)只保存相关寄存器。（最初以为这个设置是为了偷懒干脆一并保存了，但是后来意识到中断处理函数和程序正常运行时的函数调用有所不同，中断处理函数是发生在函数运行过程中，原程序应当并不清楚，所以应当保存程序可能用到的所有寄存器）。

    sscratch寄存器这里是否置0其实并无影响，这个值并不会被用到。
    
    （RISCV中的LOAD和STORE可以理解为对应X86的push和pop）。

    接下来看一下trap函数。在中断一节有一个表格展示了scause中每一个可能值值和其对应的trap是什么，你可能已经意识到了如果该trap是同步异常，scause的最高位(Most Significant Bit)为0时；如果该trap是外部中断，对应位为1。查看传入的参数struct trapframe tf的定义，发现包括sscause的几个和中断相关的CSR都被保存在了trapframe中。（顺带提一下，gpr是之后print_trapframe中打印当时寄存器的值会用到的数据结构。）所以此时只要判断tf->cause的最高位是否为1就可以了。一种比较简单的判断方法是将原本cause的无符号数据类型转换位有符号数据类型，最高位变为符号位，之后只要判断该值是否小于0就可以了。

    ```
    struct trapframe {
    struct pushregs gpr;
    uintptr_t status;
    uintptr_t epc;
    uintptr_t badvaddr;
    uintptr_t cause;
    };
    ```
    判断是同步异常还是异步中断之后分别交给各自对应的函数进行处理。

    M-mode处理的一些trap，类似的，在riscv-pk/machine/mentry.S中实现。（相较而言mentry.S中ISR的实现比较标准，建议去看看）
    
- clock_init(); \
    S-mode下不会直接控制时钟中断和软件中断，而是会陷入M-mode设置定时器或代表它发送处理器间中断。所以在每次触发时钟中断的时候，我们都会通过ISR进入S-mode，在S-mode中调用"sbi_set_timer"通过调用"ecall"陷入M-mode（具体实现查看lab1/libs/sbi.h，该文件中实现了从sbi到ecall的转换，之后ecall进入mcall_trap函数，为各种trap切入对应细分的中断处理函数），利用它的中断处理函数"mcall_set_timer"来处理时钟中断。函数在riscv-pk/machine/mtrap.c中定义。

    时钟中断不可抢占，也就是说在处理时钟中断的时候不会开启中断使能。
    
    在[U-mode和S-mode下的时钟中断](https://github.com/rllly/ucore_on_riscv_recordings/blob/master/docs/About%20RISC-V.md#u-mode%E5%92%8Cs-mode%E4%B8%8B%E7%9A%84%E6%97%B6%E9%92%9F%E4%B8%AD%E6%96%AD)中我们曾经提到timer的功能被mtime取代，可以直接使用rdtime和rdtimeh来读取mtime中的值。mtime会根据机器的时钟频率依次增1，同时当mtime增加到等于mtimecmp时会触发中断。每次中断被触发的时候我们都会修改mtimecmp的值让它比现在的mtime中的值大timebase，这样在现在起经过timebase之后会触发下一次时钟中断。由此我们可以判断timebase的大小事实上就是每tick中时钟周期的个数。在QEMU中时钟频率为10MHz，这个值原本可以通过"sbi_timebase"得到，但是这个函数在本版本中没有实现，所以函数中我们直接用1e7给出。

    clock_set_next_event通过SBI设置了机器的timer之后需要为它开启在S-mode下可被触发的权限，也就是在sie中相应位置1。这里用到了一个宏"MIP_STIP"。这个宏在lab1/libs/riscv.h中定义。我们之前提到xip和xie寄存器的布局中，每个中断对应位在几个CSR中是相同的，所以mip中的STIP位也就对应着sie中的STIE位，也就是时间中断的使能位。在"mcall_set_timer"中该函数会清除mip中对应的STIP位，表示这个中中断已经被处理了；并为mie中的MTIP置位，让下一次时钟中断能够被触发。

    之后就是初始化ticks变量。这个变量在interrupt_handler对应的时钟中断处理中每次增1。此外，中断处理函数还会为mtimecmp更新下一次的中断值。

- intr_enable();\
  只需要为sstatus中的SIE置位就能开启中断使能了。

#### 附加练习（？）
***在consol功能正常启用之后可以通过输入函数名调用print_kerninfo等函数，本来除了console_init中初始化的两个函数之外其他功能与平台都无关了，但是在测试之后发现RISC-V提供的编译器貌似不能正常编译函数指针，于是该功能不能正常使用。同学们可以尝试使用别的结构让这部分正常工作。当然在这之前需要改一下脚本让kernel跳出grade mode运行在正常模式......***




