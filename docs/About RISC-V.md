# 关于RISCV

## RISC-V的基本框架
![RISC-V几种基本框架](https://github.com/rllly/ucore_recordings/blob/master/pic/About%20RISC-V/1_RISC-V%E6%A1%86%E6%9E%B6.png)
（* EE指的是Execution Environment，BI指的是Binary Interface，本实验是第二种框架）
## RISC-V几个主要指令集
RISC-V的设计理念和Liunx比较相似，由一个基础指令集和若干标准/非标准拓展指令集共同构成一个完整的架构。
基础指令集有RV32I,RV64I（I表示整数指令集），RV32E（RV32I的删减版）。比较常用的构成是分别由RV32I和RV64I作为核心加上几个标准拓展的指令集，简写为RV32G和RV64G。本实验采用RV32G。


## Berkeley Bootloader
Berkeley Bootloader，简称bbl。本文所提到的bbl相关设定特指在本版本RISC-V社区提供的工具链以及qemu-system-riscv32中适用，其他环境可能会有所差异。
Bbl（Berkeley bootloader）是官方提供的工具包中riscv-pk中的一部分。Pk全称proxy kernel，是一个运行RISCV的ELF二进制文件的一个操作环境。Pk模拟了一个可以实现部分I/O功能的RISC-V实例，并将模拟kernel收到的I/O相关系统调用传给运行主机进行处理。本系统使用的平台可以借助pk实现键盘输入和kernel打印信息到屏幕上。
Bbl主要是为在RISC-V上运行的Linux操作系统设计的。
除了传统bootloader将系统引导到正确内存位置的工作，bbl还为操作系统系统了一系列软件接口SBI（Supervisor Binary Interface），其实现主要是通过机器模式（M-mode）的系统调用（Ecall）来满足操作系统的需求。

## Supervisor Binary Interface
Supervisor Binary Interface这个接口的存在让运行在操作系统模式下工作的软件可以在各种RISC-V的实例上运行。SBI的设计也遵从了整个RISC-V的设计理念，是由一个很小的核心和一系列可选性的拓展组成的。
所有的SBI函数都使用一种二进制编码，这让各种SBI拓展可以任意组合。RISC-V UNIX 系统调用ABI（Application Binary Interface）是基于由RSIC-V ELF psABI定义的函数调用规范的，SBI的编码标准与它是一致的。也就是说，除了以下几种区别，SBI调用和标准RISC-V函数是相同的：
1. SBI使用ecall指令作为控制转移指令，而不是call
2. a7寄存器（或者在RV32E中的对应寄存器t0）存放着SBI拓展ID，这个编码和标准UNIX系统调用ABI的编码是相同的。
许多SBI拓展也会选择在a6中编码一个额外的函数ID，这种设计与许多UNIX操作系统上的ioctl()系统调用相似。这个设计允许SBI拓展能够利用一个拓展空间中编码多种函数。
出于兼容性，SBI拓展ID和SBI函数ID都以单个32位整数编码。这些ID在寄存器间的传输符合RISC-V标准函数调用规则。
SBI函数通常会有一对返回值分别放在a0和a1中，a1中存放的是错误码（error code）。类比成一个C结构就是：
```
struct sbiret {
        long value;
        long error;
    };
```

## Ecall
在RISC-V中，ECALL指令用于向当前执行环境提出请求（通常是操作系统模式S-mode下），例如系统调用。
在本实验所用的qemu和bbl版本中，SBI是通过ECALL的形式实现的。操作系统所提供的ABI（Application
 Binary Interface）可以定义系统调用的参数是如何被传递的，通常情况下，这些参数会被传入整数寄存器中
 。在本移植系统提供的ABI里，参数的传递大体按照RVG的函数调用规范放入整数寄存器中。

 ## （常规）函数调用规范
常规规范在大多数情况下适用（包括本实验），但是对于部分拓展可能有细微差异。
### 几个通用寄存器的使用
![通用寄存器在调用规范中的使用](https://github.com/rllly/ucore_recordings/blob/master/pic/About%20RISC-V/2_calling_convention_register.png)

上图表明了各个整数寄存器和浮点型寄存器在函数调用中所扮演的角色。在RISC-V的汇编语言中，既可以使用通用寄存器原本的名字（如x0,x1等），也可以使用功能名（如zero,sp等）来调用。至于saver一栏若无法理解，可以联系之后的[函数返回值](#函数返回值)思考一下。

 ### 参数传入
 RISC-V中的函数调用会在可能的情况下用寄存器传值。有八个整数寄存器a0-a7和八个浮点寄存器fa0-fa7可供使用。
如果把一个函数的全部参数设想为一个指针对齐（pointer alignment）的C语言的struct，参数寄存器能映射到这个struct的前八个指针字（pointer-words）。如果第i个参数（i<8）（也就是说没有超过8个参数寄存器所能覆盖的范围）是一个浮点型的参数，这个参数就会被传到fai中，相应的，如果是整数型参数则会被传入到ai中。然而，如果浮点型变量是作为unions参数或者数组参数的一部分被传递的，它将会被放入整数寄存器进行传递。此外，可变参数函数中的浮点型参数（除了那些在参数列表中被明确命名了的）也都会被放入整数寄存器进行传递。
对于这个设想的struct中超出寄存器覆盖范围的参数会由栈(stack)传递，栈指针sp会指向首个未能被寄存器传递的参数。
RISCV是一个小端(little-endian)存储的系统，所以如果被传递的参数小于一个指针字(pointer word)，它会靠着参数寄存器的最小端存储；相应的，对于那些大小小于一个指针字且用stack来传递的参数，它们的值会靠着低地址存放。
 
如果一个原始数据类型(primitive type, 如int、double、boolean这种非对象的数据类型)的参数正好是两倍指针字的大小，它们在用栈传递的时候是自然对齐的。下图展示了几个C中原始数据类型在RV32和RV64中所占的大小。

![C中原始数据类型在RV32和RV64中的大小](https://github.com/rllly/ucore_recordings/blob/master/pic/About%20RISC-V/3_C_data_types.png)

如果用整数寄存器传递参数，所有的参数都会按顺序分别被放入一对奇偶寄存器，最低的几个位放在寄存器对的偶数寄存器中。以RV32为例，函数void foo(int, long long)第一个int参数会被放入寄存器a0传递，第二个参数long会被放入a2和a3，a1寄存器中没有被传入任何值。
如果参数比两个指针字还大，则会被以引用的形式传递。

### 函数返回值

函数返回值会放入整数寄存器a0和a2以及浮点寄存器fa0和fa1。浮点值只有在它们是原始参数(primiticves)或者是只有一两个浮点数的struct的一部分的时候会被放入浮点寄存器中返回。其他能够放入两个指针字的参数都会被放入a0和a1。更大的返回值会全部放入内存返回，调用者会提前申请好一片内存，指向这篇内存的指针会被当做一个隐式参数第一个传给被调用的函数。
对于标准的RISC-V调用规范来说，栈(stack)是向下扩散的，并且栈指针总会保证16-byte对齐。
除了传参寄存器，还有七个整数寄存器t0-t6和十二个浮点型寄存器ft0-ft11作为暂存寄存器，但是这些暂存寄存器在函数调用之间是不会被自动保存的，也就是说如果使用到了暂存寄存器，调用者自己需要手动保存它们的值。另外还有12个整数寄存器s0-s11和12个浮点寄存器fs0-fs11，它们在调用之间会被保存，也就是说如果用到了这些寄存器，被调用者一定会保存它们的内容。

## 中断和CSR
RISC-V中的中断大体可以分为三种：
1.	Exception: 一个同步事件(instruction)触发的异常\
2.	Traps: 一个同步时间触发的异常，会被同步转交给一个trap handlers。通常情况下这个trap handlers会运行在一个更高的特权级。
3.	Interrupt: 被一个异步的外部事件触发的中断。如果有一个必须被处理的Interrupt被出发了，会有一些指令去处理这个中断异常，然后以trap的形式解决它。

正常情况下在S-MODE和M-MODE下都有各自的中断异常处理，处理模式也非常相似。如果硬件线程触发了一个中断/异常并移交给了S-MODE，硬件会自动对S-MODE下的CSR进行一些处理（具体功能会在后面进行解释）：
1. 此时的PC存入sepc，PC则被设为stcev中的值，也就是切入通用中断处理函数
2. scause会根据异常类型存入相应的错误码
3. sstatus中的SIE位的值存入SPIE中后置0全局屏蔽中断
4. 异常触发时所在的特权级放入sstatus中的SPP域，然后把当前特权级设为S-MODE。

最终在处理完所有中断之后还要在回到原程序之前为其恢复环境。

1. 将sp和sscratch的值进行交换。（在看完异常和函数调用惯例后你可能就已经意识到，在中断那一章提到的与sscratch交换的那个整数寄存器事实上就是sp）。
2. 将所有会用到的整数寄存器和CSR的值保存起来。
3. 进入trap函数
4. 用之前保存的寄存器值恢复中断触发现场。

### RISC-V特权级设置
先了解一下RISCV特权级别的设置。RISCV一共定义了四个特权级别：
 
Level| Encoding| Name| Abbreviation
-|-|-|-
0 |00 |User/Application |U
1 |01 |Supervisor |S
2 |10 |Hypervisor |H
3 |11 |Machine |M

和其他架构一样，RISCV的特权级是为了保护软件栈上各个成员的安全，如果有违反当前的特权级的行为就会触发一个exception，而这种exception会导致一个更底层环境的trap。M-mode一般是用于管理一些与RISCV环境有关的安全操作，S-mode和U-mode分别是常规的操作系统模式和用户模式，H-mode则是为了支持虚拟机管理而存在的一个模式。
大部分的trap都会陷入M-mode，但是在有操作系统的情况下，部分中断的解决是可以移交给S-mode也就是操作系统来管理。显然这样会比较浪费时间，所以RISC-V中设计了一个机制，让一个寄存器记录所有操作系统可以自己处理的中断/异常而无需经由M-mode移交。这个机制与某些CSR有关。

### CSR简介
RISC-V ISA 中特权级指令可以分为两大类：CSRs控制的原子级指令和其他指令。RISC-V中为CSR预留了12位的CSR地址（也就是说CSR最多可以有4096个，但目前并没有这么多），[11:10]控制寄存器的读写权限，[9:8]控制了可访问该寄存器的最低权限。
CSR分为standard和non-standard，可以确定的是未来CSR不会将预留的non-standard寄存器地址分配给standard寄存器。此外，RISC-V还预留了一些shadow CSR地址来给拥有更高权限的用户修改那些只读的CSR寄存器。注意，只有在某个权限级别下已经被分配了一个read/write的shadow地址，更高权限的用户才可能用这个CSR地址以读写权限来访问这个只读寄存器。
如果访问了不存在的寄存器或非当前权限可以访问的寄存器会触发非法指令异常。详情可以翻阅preveledge specification v1.9.1 第2.2章，这一节对其他CSR不过多介绍。

### CSR相关操作指令
1.	CSRRW 原子操作的读写CSR (Atomic Read/Write CSR) 
交换(swap)CSR与整数寄存器的值，高位补0。指令会先将原先CSR中的值放入rd，原先rs1的值写入CSR。如果rd为x0（最低为的整数寄存器，永远保持0），指令不会读取CSR，也就不存在因为读取CSR而产生异常。
2.	CSRRS 原子操作的CSR读取和置位 (Atomic Read and Set Bits in CSR)
该指令会读取CSR中的值，高位填0写入整数寄存器rd。rs1中初值被当作一个bit mask，其中为1的位会在CSR对应位中被置1（如果该CSR可写的话），CSR中其他位不会受影响（这里没有考虑写CSR引起异常的情况）。
3.	CSRRC 原子操作的CSR读取和复位 (Atomic Read and Clear Bits in CSR) 
和CSRRS指令相似，只是功能不再是置位而是复位。
对于CSRRS和CSRRC指令而言，如果rs1=x0，则该指令根本不对写CSR，同样也不会因为写CSR产生任何副作用，比如说触发非法指令或者非法访问只读CSR的异常。但是如果rs1是任何一个除x0之外的值为0的寄存器，该指令仍然会尝试写CSR，也就可能导致异常
4.	CSRRWI CSRRSI CSRRCI 
这些变种指令分别都和原指令非常相似，不同的是它们会用一个立即数(zimm[4:0])取代原本的rs1作为放入CSR的值，高位补0。对于 CSRRSI和 CSRRCI，如果zimm[4:0]的值为0则不会写CSR。对于 CSRRWI，如果rd=x0则不会读CSR。
也就是说读CSR的指令是 CSRR rd,csr,x0，用寄存器写CSR的指令是CSRRW x0,csr,rs1，用立即数写CSR的指令是CSRRWI x0,csr,zimm。对应也可以推出只对CSR进行置位复位的指令，这里就不再给出了。


### 中断相关的CSR
这一节我们需要关注的是几个与异常处理相关的CSR。这些寄存器都有自己的名字，通常来说它们的命名是[特权级]+[功能名]。以ustatus为例，"u"指的是"user"用户级别，"status"表明它是一个状态寄存器。相应的，也有"sstatus"与"mstatus"。
目前已定义的user-level标准CSR只有timers，counters和floating-point。
 
Name    	|   Description 
-|-
sstatus/mstatus     |   各种状态信息
sie/mie 	        |   处理器目前能处理和必须忽略的中断
stvec/mtvec 	    |   PC被设置为stvec
sscratch/mscrach    | 	暂时存放一个字大小的数据
sepc/mepc           |   发生例外的指令被存入sepc
scause/mcause       |   表示异常类型
sbadaddr/mbadaddr 	|   出错地址（这个CSR的功能在Pv1.10中被合并到另外一个寄存器里）
sip/mip	            |   指出目前正准备处理(pending)的中断
sptbr 	            |   Page-table base register
medeleg 	        |   控制哪些异常（同步）委托给S模式
mideleg 	        |   控制哪些中断（异步）委托给S模式


- **mstatus & sstatus**\
	在S-mode的H-mode的下的sstauts和hstatus看上去就像是一个受限版本的mstatus[6] ，也就是说大体上它们的布局是一致的，只是sstatus/hstatus会比mstatus少一些控制位：


	![mstatus布局](https://github.com/rllly/ucore_recordings/blob/master/pic/About%20RISC-V/5_mstatus.png)

	![sstatus布局](https://github.com/rllly/ucore_recordings/blob/master/pic/About%20RISC-V/6_sstatus.png)

	mstatus寄存器记录和控制了当前hart（这个之前提到过是硬件线程）运行状态。MIE,HIE,SIE,UIE是每个相应模式下对应的interrupt-enable bits；在特权级x下运行时，xIE=1则代表该中断使能。这些位是为了保证interrupt handlers在当前特权级的原子性。为较低特权级设置的中断在更高的特权级下总是被屏蔽的，而为较高特权级设置的中断在更低特权级下总是被使能的。高特权级的代码在把控制权移交给低特权级之前可以先复位(reset)部分中断位来屏蔽一些中断。
	为了支持嵌套式的trap(nested traps)，每个特权级x都有两段stack中断使能位和特权级。xPIE中的值记录着这个trap被触发之前的中断使能位，xPP则记录之前的特权级。xPP域只能记录比自己特权级低(编码更小)的模式，所以MPP和HPP都有两位宽，SPP只有一位宽，UPP位宽为0（也就是事实上没有这个段）。（xPP是一个WLRL 域）当一个trap由原先的特权级y陷入了特权级c，xPIE的值就应该设为yIE的值，xIE被设为0，xPP设为y。通常情况下更高级别的特权级在处理来自低级别的trap时都会屏蔽中断，在处理完trap之后会根据stack里的内容返回到触发trap的上下文中；如果没有立刻返回原来的上下文，在重新开启中断使能之前也会保存privilege stack（包括xepc,xcause,xtval和xstatus这些控制寄存器的旧值）到内存栈，所以每个stack只要一个项就好了。（显然抢占了某个中断的中断处理程序也应当在退出之前禁用中断并把这些寄存器的值恢复。）
	恢复上下文使用的是MRET，HRET，SRET和URET这几个指令。对于S-mode和H-mode，只要实现了相应的特权级，对应的xRET就必须被实现。而URET只有在允许U-mode处理部分trap的时候才被要求实现。执行一个xRET指令后，假设xPP中的值为y，yIE的值会设为xPIE，特权级被切回y，xPIE被设为1，xPP被设为U（在没有用户模式的情况下则被设为M）。也就是说，当栈被弹出时，栈底会被设为最低权限的未屏蔽中断模式。这是为了避免产生栈弹出了一个无效值的错误。
	在一个高特权级下可以使用相较而言更低级别的xRET，此时低级别的xPIE和xPP栈被弹出。最终pc被设为xepc中的值。
	User-level的中断在RISCV中是一个可选项的ISA拓展(N)。如果user-level的中断没有被实现，UIE和UPIE位会被硬件接0。其他特权级的xIE,xPIE,xPP域都是必须实现的。
	mstatus中还有VM域(virtualization management)。其中它的编码代表着当前kernel运行在什么样的内存模式下。本实验中只涉及到两种内存模式：Mbare（编码）和Sv32（编码8）。Mbare是一种没有任何内存管理或者内存保护的模式，在这种模式下无论处于哪个特权级都可以直接访问到物理地址。在机器每一次reset的时候都直接进入Mbare模式。Sv32则是一种基于页面的虚拟内存模式，提供32位的虚拟地址来支持一些现代Supervisor-level的操作系统，其中包括Unix-based系统（我们的实验系统也是这一种）。同样，VM也是一个WARL域。
	MPRV位可以修改执行LOAD和STORE指令时的特权级。当MPRV=0时地址转换和内存保护照常进行，但当MPRV=1时，数据内存地址（data memory address）会和当前特权级的编码被写入MPP时的情况一样进行地址翻译和保护；指令地址的相关操作不会改变。MXR位则是管控着内存读取权限：如果MXR=0则只有PTE中R=1的位可以被执行LOAD指令，而MXR=1时R=1或者X=1的时候都可以被执行LOAD指令。这两个位是为了方便模拟M-mode下一些硬件上没有实现的特性，比如说对未对齐地址的LOAD和STORE指令。
	 PUM(Protected User Memeory)则影响了S-mode下的LOAD、STORE以及访问虚拟地址的取指操作。但PUM=0的时候，一切访问和内存保护照常进行，如果PUM=1，则S-mode下不可以访问U-mode（PTE中U=1）下可以访问的内存。PUM只有在基于页面的虚拟地址模式启用的时候起作用。

- **mie & mip**
	
	![Machine Interrupt-pending register (MIP)](https://github.com/rllly/ucore_recordings/blob/master/pic/About%20RISC-V/7_mip.png)

	![Machine Interrupt-enable register (mie)](https://github.com/rllly/ucore_recordings/blob/master/pic/About%20RISC-V/8_mie.png)
	    每个域中首字母H,E,S,U都很好理解，分别是代表四个特权级，后两个字母IP/IE的含义也与ip/ie相同，而第二个字母E,T,S则分别代表外部中断(external interrupts)，时间中断(timer interrupts)和软件中断(software interrupts)

- **mcause & scause**\
	mcause和scause中保留了触发中断/异常类型的编码。从图2-8可以看到mcause寄存器中最高位区分了同步软件异常和异步外部中断。具体每一类中断和异常的编码见图2-9。

	![Machine cause register (mcause)](https://github.com/rllly/ucore_recordings/blob/master/pic/About%20RISC-V/9_mcause.png)


	![mcause中的中断/异常编码](https://github.com/rllly/ucore_recordings/blob/master/pic/About%20RISC-V/10_mcause_encode.png)

	（RISCV中其实允许非对齐的LOAD/STORE指令，而上图中还会有指令不对齐的Exception主要有两个原因：1.原子内存操作要求地址对齐；2.非对其的LOAD/STORE指令对硬件有额外要求，如果用户没有实现这部分的硬件，RISCV会利用Exception以一些更小的LOAD/STORE来软件实现这个功能。）
	
- **mtvec & stvec**\
	mtvec和stvec中保留着触发异常/中断时pc需要跳转到的通用中断处理函数的地址，也就是中断向量。虽然mtvec是一个可读可写的函数，但是可以被处理成一个硬件设成的只读值。mtvec和stvec的功能相似，但是二者的值却并不相同。之前提到过在本实验中由于所有的SBI接口都由ECALL触发系统调用完成，而实上ECALL将会将pc设为mtvec的值；而操作系统自行处理的中断/异常都是supervisor-mode下的中断处理函数处理，所以stvec的值指向的是那个函数的入口地址。


	![Machine Trap-vector Base-address register (mtvec)](https://github.com/rllly/ucore_recordings/blob/master/pic/About%20RISC-V/11_mtvec.png)

- **medeleg & mideleg**\
    在默认情况下，所有异常处理都是移交给M-mode处理的，但如果读者对Unix系统比较熟悉的话会知道，在Unix系统下大多数异常触发的是操作系统的异常处理程序。这种情况下M-mode的异常处理程序可以选择将控制权移交给S-mode，但是显然这个代价会很大。所以RISC-V提供了一种委派机制，让某些异常处理跳过M-mode，直接交给S-mode进行处理。
    注意无论委派设置是怎样的，发生异常是控制权都不会移交给权限更低的模式。在M-mode下发生的异常只会由M-mode处理，S-mode下发生的异常根据委派设置可能由S-mode自己处理或者由M-mode直接处理。委派机制可以理解为S-mode触发异常后想要寻求M-mode的帮助，但是M-mode根据委派设置认为这个问题S-mode可以自行解决，所以看都没看一律让S-mode自己处理了。遇到异常可以尝试向高级别的特权级求助或者自行解决，但是绝不可能让更低的特权级去解决这件事情。
    和xip/xie一样，medeleg/mideleg中每一位对应一种中断。如果某个中断位为1，则代表S-mode下的该中断会直接 由S-mode下的中断处理程序直接处理。

- **mbadaddr/sbadaddr**\
	当触发一个硬件断点，或者在取址、读写地址没有对齐，又或者超权访问异常被触发时，这个出错的地址就会被写入xbadaddr。在其他异常情况下xbadaddr都不会被修改。
	之前我们提到过RISCV接受不对其的load/store指令，所以当所取指令地址是变长的，mbadaddr会指向指令的部分地址，mepc会指向这条指令的起始地址。
	这个寄存器在之后的v1.10中被合并到xtvalCSR中了。

- **mscratch/sscratch**\
	  在进入中断处理程序之前会xscratch会和u-mode下的某个整数寄存器的值进行交换（通常原先的值是一个指向一片临时分配内存的指针，中断处理程序运行中涉及到的整数寄存器的内容会保存在这片临时开辟出来的内存中），以免在中断处理程序运行时把原来通用寄存器的值覆盖了。中断处理程序处理完中断后会重新把xscratch和被交换的整数寄存器交换回来。MIPS指令集中有类似的设计。
	当一个线程触发异常/中断时，硬件会自动进行下列准备：
	    (1)	发生异常的地址（PC寄存器中的值）被保存在sepc中，此时PC被设为stvec准备进入中断通用处理程序
	    (2)	根据所触发的异常种类设置scause
	    (3)	将sstatus中的SIE位置0关中断，并将之前的xIE保存到SPIE中（x代表触发中断时的特权级）
	    (4)	将发生异常前的特权级编码保存在SPP中，将当前权限模式更改为S
	    (5)	中断处理程序将sscratch与保留了原本程序上下文的栈指针的寄存器的值交换。

### U-mode和S-mode下的时钟中断
S-mode并不直接时钟中断和软件中断，而是使用ecall指令请求M-mode设置定时器或者代表它发送处理期间中断。该软件约定是SBI的一部分。

在[中断相关的CSR](#中断相关的csr)一节中我们提到了mip和mie中的时钟中断和软件中断。除此之外，RISCV中还有两个与时间相关的寄存器mtime 和mtimecmp。

mtime是一个用内存地址访问的M-mode寄存器，会按照每个机器的时钟频率依次增一，所以对每个平台来说，我们必须提供为mtime提供一个timebase来统一频率。无论是在rv32，rv64还是rv128上，mtime都是64位的。mtimecmp则是另外一个用内存地址访问的时间比较寄存器。当mtime中的值大于等于mtimecmp时则会触发一个时钟中断。这个中断状态在再次写mtimecmp寄存器之前都不会被清除。此外，时钟中断只有在mie中的MTIE被置位的情况下才可以被触发。

在RISCV文档的设想中，平台应该实现了一个名为time的64位CSR，但是事实上在本平台的QEMU上我们并没有实现这个CSR，相应的功能也被mtime顶替了。
RISC-V提供了RDTIME来读取这个time寄存器。相应的RDTIMEH只会在RV32I中存在，它会读取同一个实时计数器的63-32位。由于这个CSR并不存在，相应的rdtime指令也没有被实现，所以一旦使用了这个指令我们就会触发一个非法指令的异常并陷入M-mode。相应的中断处理函数判断出来这是一个rdtime指令就会读取mtime寄存器中的值并返回。这种技巧同样也在不支持浮点指令集的环境中模拟浮点指令时被运用。

### WFI指令

讲到中断通常会提到'wfi'指令。如果看得比较仔细，你会发现在之前的boot_loader相关代码中这条指令曾经出现过。在这里我们可以简单把这条指令理解为'nop'指令，一般这条指令会和循环指令结合使用，意为等待一个中断信号将机器重新唤醒，提示机器此时只要保持低能耗状态就可以了。

### ECALL
在RISC-V中，ECALL指令用于向当前执行环境提出请求（通常是操作系统模式S-mode下），例如系统调用。在本实验所用的qemu和bbl版本中，SBI是通过ECALL的形式实现的。操作系统所提供的ABI（Application Binary Interface）可以定义系统调用的参数是如何被传递的，通常情况下，这些参数会被传入整数寄存器中。在本移植系统提供的ABI里，参数的传递大体按照RVG的函数调用规范放入整数寄存器中。

### 通用中断处理(trap handler)步骤
一个hart在S-mode和M-mode发生异常时硬件都会进行如下步骤：
    
- 触发trap时的PC值被存入xepc，PC被设为xtvec（如果是同步异常，xepc指向出错的指令；如果是中断，xepc指向中断处理后原先程序继续执行的位置）
- xcause按照之前mcause中的编码方式设置trap类型，xbadaddr被设置成出错的地址
- 把xstatusCSR中的xIE置0，屏蔽中断，且xIE之前的值被保存在xPIE中。
- 发生例外时的权限模式被保存在xstatus中的xPP域，然后设置当前模式为x-mode

除此之外，中断处理函数还需要手动（软件）进行一些处理工作：
- 整数寄存器和xscratch交换。中断处理程序处理完中断后两个寄存器交换回来
- 处理程序用xret指令返回，以前文中提到的方式恢复各寄存器的值。



## 虚拟内存映射机制SV32
RISC-V中根据内存位宽定义了几种虚拟内存格式，在本实验系统中只用到了SV32，也就是一个32位的虚拟地址模式。几种格式的命名规则中定义SV后的数字为虚拟内存地址长度。

在[上一节讲mstatus](#中断相关的csr)我们提到了本实验只有两种内存管理模式：Mbare和Sv32。机器刚启动的时候都是处于Mbare模式，当Sv32被写入mstatus的VM域后，操作系统就会在一个基于32bit页面的虚拟内存模式下工作了。

### 页表格式
Sv32支持32位的虚拟内存地址，一共被分成4KiB个页。一个Sv32的虚拟地址可以被分为虚拟页号(virtual page number VPN)和页内偏移。当mstatus确定现在工作在Sv32模式下，操作系统的虚拟地址就会被二级页表翻译成操作系统的物理地址。这20位的VPN就会被翻译成22位的物理页号(physical page number PPN)，页内偏移量不会改变。也就是说翻译得到的物理地址是22+12=34位。得到的操作系统级物理地址在直接转化成机器级别物理地址之前还需要通过某一种物理地址保护结构的检查。
	
事实上由于bbl只支持32位的物理地址，本实验中的物理地址也只有32位。
Sv32的页表一共有2^10个4字节的页表项(PTE, page-table entries)。一个页表的大小应当和一个页面的大小保持一致。根页表的物理页号会被放在sptbr寄存器中。
Sv32中PTE的格式。
 
![Sv32](https://github.com/rllly/ucore_recordings/blob/master/pic/About%20RISC-V/12_sv32.png)

V位代表这个页表项是否是有效的；如果它的值为0，则这个页中的其他位都失去意义，可以被任意软件随意使用。R，W，X是权限位，分别代表这个页面是可读，可写或可执行。当这三个值全为0时，这个PTE是一个指向下一级页表的指针；否则，他就是一个叶子PTE（直接指向某个页面）。可写的页面必须同时被标为可读的，所以违反了这一条的编码被保留为未来拓展使用。下图展示了PTE中权限位对应的编码：

![PTE中的X/W/R位编码](https://github.com/rllly/ucore_recordings/blob/master/pic/About%20RISC-V/13_pte_encode.png)

U位决定了该页是否可以被U-mode访问（只有在U=1下是可以的）。如果sstatus中的PUM位被设0，S-mode下的软件也可以访问U=1的页面。然而通常情况下操作系统都会在PUM被置位的情况下运行，在这种情况下操作系统访问U-mode的界面是错误的。
G位代表了这是一个全局map(global mapping)，也就是说对于所有地址空间而言这个页表项都是有效值。对于非叶子PTE，这个全局设置表明在这个页表项下级的所有页都是全局的。如果一个应当设为全局的页表没有被设为全局只会降低性能，但是把一个不该全局的页表设为全局则算一个错误。
每一个页表项都会分别保留一个A(accessed)和一个D(dirty)位。当一个虚拟页面被写了，对应的页表项会被置位。对于操作系统而言，如果它永远都不会用到这个PTE的A或者D位，则该位应该置1。这样可以避免其他内存访问后置位。
由于每个PTE都有可能是一个叶子PTE，所以在4KiB页之外，Sv32还支持4MiB个megapages。一个megapages无论在物理还是虚拟上都应该严格与4MiB对齐。

### sptbr寄存器
这个寄存器只在支持虚拟地址的系统中存在，相当于x86中的CR3，这个寄存器中保存着根页表(root page table)的物理页号(PPN, physical page number)，也就是它的操作系统物理地址数除以4KB（右移12位），以及一个为每个地址空间ID(ASID, address space identifier)，用以区分开各个地址空间。

 
![RV32 Supervisor Page-Table Base Register](https://github.com/rllly/ucore_recordings/blob/master/pic/About%20RISC-V/14_sptbr.png)

操作系统物理地址的位宽是具体实现决定的（在本实验中是32bit），任何没有被实现的地址位会在sptbr中被硬件接0。也ASID的位宽也是由具体实现决定的，它甚至可能为0。ASID具体实现了多少位也是由具体实现决定的。在本实验中，sptbr一共有32位，sptbr[21:0]是PPN，sptbr[31:22]是ASID。
之所以把ASID和PPN存在同一个CSR中是为了让这一对能够在上下文切换的时候原子性地一起改变。如果不原子性地对他们进行更改可能让切换之前的页面或者之后的页面受到污染。这种办法同样在一定程度上减少了上下文切换的代价。

### 虚拟地址向物理内存转换算法
设虚拟地址为va，物理地址为pa。
1.取sptbr的PPN并左移12位找到根页表的起始地址，令该地址为a，i=LEVELS-1（在Sv32中，PAGESIZE=2^12，LEVELS其页表级数，为2）
2.设pte为a+va.vpn[i]xPTESIZE（对于Sv32，PTESIZE=4，目的是为了让10位的vpn变为12位的pageoffset中的高10位）这个地址指向的PTE的值（vpn[i]的值左移两位后与当前地址a相加，即在当前页表中通过偏移量vpn[i]找到下一级页表的地址）
3.如果上一步找到的页表项中的r=0,x=0,w=1，根据之前对于pte权限位的说明，该页表项不是合法的，所以会触发一个访问异常
4.如果不符合3中的条件则说明该PTE是合法的，如果该页可读可写说明这是一个叶子页表项（指向的是一个可以直接转换位物理地址的页）；否则说明该页表项是一个指向下一级页表的指针，此时让a=pte.ppn x PAGESIZE并返回第二步。
5.找到一个叶子PTE之后查看该页是否可读/可写/可执行，如果不是，则触发一个访问异常；如果是，地址翻译完成。将pte.a设为1。如果当前访问是一个写操作，则设pte.d为1。

翻译前后的两个地址有如下几条规律：
1.	物理地址的offset等于虚拟地址的offset
2.	如果i>0，则这是一个超级页转换，并且pa.ppn[i-1:0]=va.vpn[i-1:0]，在SV32中就是pa.ppn[0]=va.vpn[0]
3.	pa.ppn[LEVELS-1:i]=pte.ppn[LEVELS-1:i].
