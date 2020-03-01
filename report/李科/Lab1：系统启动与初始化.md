

# Lab1 系统启动与初始化

1. ## 实验内容

   借用bootloader 初始化OS，完成练习。而这lab1中的OS只是一个可以处理时钟中断和显示 字符的幼儿园级别OS。

2. ## 练习

   1. 练习1 理解通过make生成执行文件的过程

      列出本实验各练习中对应的OS原理的知识点，并说明本实验中的实现部分如何对应和体现了原理中的基本概念和关键知识点。

      在此练习中，大家需要通过静态分析代码来了解：

      1. lab1/Makefile，解释操作系统镜像文件ucore.img是如何一步一步生成的？ (需要比较详细地解释Makefile中每一条相关命令和命令参数的含义，以及说明命令导致的结果)
      2. [原：一个被系统认为是符合规范的硬盘主引导扇区的特征是什么？]（提示：查看`[riscv-pk/bbl/bbl.lds]`bbl的linkscript、`[src/lab1/tools/kernel.ld]`kernel的linkscript、`[src/lab1/tools/sign.c]`，装载位置(base address)和对其地址(align)）

   2. 练习2 使用qemu执行并调试lab1中的软件

      具体自行查阅gdb手册，与qemu联合调试步骤。
      
   3. 练习3 （原练习4） 分析bootloader加载ELF格式的OS的过程 
   
      - bootloader如何读取硬盘扇区的？
      - bootloader是如何加载ELF格式的OS？
      - 这里可能要解释一下bbl的payload：就是bootloader装载的东西,也就是我们的kernel。bbl编译前需要configure并在“--with-payload=”之后给出kernel二进制文件路径，在没有给出的情况下会默认是dummy_payload，payload的具体装载过程可以查看`[riscv-pk/bbl/payload.S]`,`[riscv-pk/bbl/]`以及`[riscv-pk/]`目录下的配置文件，也就是configure一系列。以上步骤在执行makefile文件时已经配置好，不需要单独指出--with-payload的路径。
   
3. ## 参考答案

   1. ### 解释makefile文档

      ```makefile
      #把lab1赋值给PROJ
      PROJ	:= lab1
      #EMPTY变量为空
      EMPTY	:=
      #SPACE变量为空
      SPACE	:= $(EMPTY) $(EMPTY)
      #斜杠用SLASH代替
      SLASH	:= /
      #@用V代替
      V       := @
      
      #定义GCC的安装的路径为riscv32-unknown-elf-文件夹
      ifndef GCCPREFIX
      GCCPREFIX := riscv32-unknown-elf-
      endif
      #定义QEMU为qemu-system-riscv32
      ifndef QEMU
      	QEMU := qemu-system-riscv32
      endif
      #定义SPIKE为spike
      ifndef SPIKE
      SPIKE := spike
      endif
      
      #更改默认后缀规则即可以识别.c .S .h文件
      # eliminate default suffix rules
      .SUFFIXES: .c .S .h
      #make在执行过程中，如果规则的命令执行错误，将删除已经被修改的目标文件
      # delete target files if there is an error (or make is interrupted)
      .DELETE_ON_ERROR:
      #定义编译器为gcc，开启所有常用警告，并在编译时使用O2优化
      # define compiler and flags
      HOSTCC		:= gcc
      HOSTCFLAGS	:= -Wall -O2
      #GDB为riscv32-unknown-elf文件夹下的gdb
      GDB		:= $(GCCPREFIX)gdb
      
      #选择编译器以及编译时候的一些配置
      ifdef USELLVM
      CC		:= clang
      CFLAGS	:= -mcmodel=medium -march=rv32ima -mabi=ilp32 -std=gnu99 -Wno-unused
      else
      CC		:= $(GCCPREFIX)gcc -g
      CFLAGS	:= -mcmodel=medany -std=gnu99 -Wno-unused
      Endif
      #通用的一些配置
      CFLAGS	+= -fno-builtin -Wall -O2 -nostdinc $(DEFS)
      CFLAGS	+= -fno-stack-protector -ffunction-sections -fdata-sections
      CTYPE	:= c S
      #指定链接器，与配置
      LD      := $(GCCPREFIX)ld
      LDFLAGS	:= -m elf32lriscv
      LDFLAGS	+= -nostdlib --gc-sections
      #定义命令
      OBJCOPY := $(GCCPREFIX)objcopy
      OBJDUMP := $(GCCPREFIX)objdump
      
      COPY	:= cp
      MKDIR   := mkdir -p
      MV		:= mv
      RM		:= rm -f
      AWK		:= awk
      SED		:= sed
      SH		:= sh
      TR		:= tr
      TOUCH	:= touch -c
      
      OBJDIR	:= obj
      BINDIR	:= bin
      
      ALLOBJS	:=
      ALLDEPS	:=
      TARGETS	:=
      #引用文件里的函数
      include tools/function.mk
      #把CC文件放在一些文件夹里
      listf_cc = $(call listf,$(1),$(CTYPE))
      #增加CC文件创建CC目标
      # for cc
      add_files_cc = $(call add_files,$(1),$(CC),$(CFLAGS) $(3),$(2),$(4))
      create_target_cc = $(call create_target,$(1),$(2),$(3),$(CC),$(CFLAGS))
      #增加GCC文件创建GCC目标
      # for hostcc
      add_files_host = $(call add_files,$(1),$(HOSTCC),$(HOSTCFLAGS),$(2),$(3))
      create_target_host = $(call create_target,$(1),$(2),$(3),$(HOSTCC),$(HOSTCFLAGS))
      #模式替换函数，把$(1)中以$(2)结尾的单词替换为以$(3)结尾的字符，返回值为替换后的$(1)
      cgtype = $(patsubst %.$(2),%.$(3),$(1))
      #给文件增加前缀后缀
      objfile = $(call toobj,$(1))
      asmfile = $(call cgtype,$(call toobj,$(1)),o,asm)
      outfile = $(call cgtype,$(call toobj,$(1)),o,out)
      symfile = $(call cgtype,$(call toobj,$(1)),o,sym)
      #对内容进行分析并作出相应
      # for match pattern
      match = $(shell echo $(2) | $(AWK) '{for(i=1;i<=NF;i++){if(match("$(1)","^"$$(i)"$$")){exit 1;}}}'; echo $$?)
      
      # >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
      # include kernel/user
      #引入libs文件夹
      INCLUDE	+= libs/
      
      CFLAGS	+= $(addprefix -I,$(INCLUDE))
      
      LIBDIR	+= libs
      #增加CC文件
      $(call add_files_cc,$(call listf_cc,$(LIBDIR)),libs,)
      
      # -------------------------------------------------------------------
      # kernel
      #引入kernel里面的文件夹和文件
      KINCLUDE	+= kern/debug/ \
      			   kern/driver/ \
      			   kern/trap/ \
      			   kern/mm/ \
      			   kern/arch/
      
      KSRCDIR		+= kern/init \
      			   kern/libs \
      			   kern/debug \
      			   kern/driver \
      			   kern/trap \
      			   kern/mm
      
      KCFLAGS		+= $(addprefix -I,$(KINCLUDE))
      
      $(call add_files_cc,$(call listf_cc,$(KSRCDIR)),kernel,$(KCFLAGS))
      #读入kernel包
      KOBJS	= $(call read_packet,kernel libs)
      #创建kernel目标
      # create kernel target
      kernel = $(call totarget,kernel)
      #kernel规则目标为$(kernel)，依赖文件为ld
      $(kernel): tools/kernel.ld
      
      #@控制回显
      $(kernel): $(KOBJS)
      #$@自动代表触发规则被执行的目标文件名，编译链接一些文件
      	@echo + ld $@
      	$(V)$(LD) $(LDFLAGS) -T tools/kernel.ld -o $@ $(KOBJS)
      	@$(OBJDUMP) -S $@ > $(call asmfile,kernel)
      	@$(OBJDUMP) -t $@ | $(SED) '1,/SYMBOL TABLE/d; s/ .* / /; /^$$/d' > $(call symfile,kernel)
      
      $(call create_target,kernel)
      
      # -------------------------------------------------------------------
      # create ucore.img
      #给镜像文件加前缀，也就是路径
      UCOREIMG	:= $(call totarget,ucore.img)
      #规则目标为镜像文件，依赖文件为前面编译的可kernel文件
      $(UCOREIMG): $(kernel)
      #进入riscv-pk文件夹
      	cd ../../riscv-pk && \
      #删除build子目录及子目录中所有档案删除,并且不用一一确认
      	rm -rf build && \
      #重新创建build文件夹
      	mkdir build && \
      #进入build文件夹下
      	cd build && \
      #配置，主机为riscv32-unknown-elf；负载为lab1中的kernel；关闭仿真；启用logo；然后进行编译
      	../configure \
      		--host=riscv32-unknown-elf \
      		--with-payload=../../src/$(PROJ)/$(kernel) \
      		--disable-fp-emulation \
      		--enable-logo && \
      	make && \
      #把bbl文件拷贝到后面文件夹下
      	cp bbl ../../src/$(PROJ)/$(UCOREIMG)
      #创建ucore.img到相应文件夹下
      $(call create_target,ucore.img)
      
      # >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
      
      $(call finish_all)
      #清洗中间文件
      IGNORE_ALLDEPS	= clean \
      				  dist-clean \
      				  grade \
      				  touch \
      				  print-.+ \
      				  handin
      
      ifeq ($(call match,$(MAKECMDGOALS),$(IGNORE_ALLDEPS)),0)
      -include $(ALLDEPS)
      endif
      
      # files for grade script
      
      TARGETS: $(TARGETS)
      
      .DEFAULT_GOAL := TARGETS
      
      #声明伪目标
      .PHONY: qemu spike
      #使用qemu虚拟
      qemu: $(UCOREIMG) $(SWAPIMG) $(SFSIMG)
      	$(V)$(QEMU) -machine virt -kernel $(UCOREIMG) -nographic
      #使用spike运行riscv
      spike: $(UCOREIMG) $(SWAPIMG) $(SFSIMG)
      	$(V)$(SPIKE) $(UCOREIMG)
      #声明伪目标
      .PHONY: grade touch
      #声明变量
      GRADE_GDB_IN	:= .gdb.in
      GRADE_QEMU_OUT	:= .qemu.out
      HANDIN			:= proj$(PROJ)-handin.tar.gz
      
      TOUCH_FILES		:= kern/trap/trap.c
      #编译选项
      MAKEOPTS		:= --quiet --no-print-directory
      #不回显执行grade.sh
      grade:
      	$(V)$(MAKE) $(MAKEOPTS) clean
      	$(V)$(SH) tools/grade.sh
      #更新时间戳
      touch:
      	$(V)$(foreach f,$(TOUCH_FILES),$(TOUCH) $(f))
      #替换并打印结果
      print-%:
      	@echo $($(shell echo $(patsubst print-%,%,$@) | $(TR) [a-z] [A-Z]))
      #声明多个伪目标
      .PHONY: clean dist-clean handin packall tags
      #删除一些文件夹GDB.IN和QEMU.OUT，下面所有的操作都在整理编译后的烂摊子
      clean:
      	$(V)$(RM) $(GRADE_GDB_IN) $(GRADE_QEMU_OUT) cscope* tags
      	-$(RM) -r $(OBJDIR) $(BINDIR)
      
      dist-clean: clean
      	-$(RM) $(HANDIN)
      
      handin: packall
      	@echo Please visit http://learn.tsinghua.edu.cn and upload $(HANDIN). Thanks!
      
      packall: clean
      	@$(RM) -f $(HANDIN)
      	@tar -czf $(HANDIN) `find . -type f -o -type d | grep -v '^\.*$$' | grep -vF '$(HANDIN)'`
      
      tags:
      	@echo TAGS ALL
      	$(V)rm -f cscope.files cscope.in.out cscope.out cscope.po.out tags
      	$(V)find . -type f -name "*.[chS]" >cscope.files
      	$(V)cscope -bq 
      	$(V)ctags -L cscope.files
      
      ```

   2. ### 解释bbl.lds文件

      ```c
      /*设置输出文件的体系结构为riscv*/
      
      OUTPUT_ARCH( "riscv" )
      
      /*把复位向量的地址设置成入口地址（进程执行的第一条用户空间的指令在进程地址空间的地址）*/
      
      ENTRY( reset_vector )
      
       
      
      SECTIONS
      
      {
      
       
      
       /*--------------------------------------------------------------------*/
      
       /* Code and read-only segment                     */
      
       /*--------------------------------------------------------------------*/
      
       
      
       /* Begining of code and text segment */
      
      /*定位器指向最小地址，并赋值给_ftext*/
      
       . = 0x80000000;
      
      
      
       _ftext = .;
      
      /*定义符号eprol为_ftext尾部的地址*/
      
       PROVIDE( eprol = . );
      
      /*定义一个输出节‘.text’地址设为eprol尾部地址，所有的输入文件中的‘.text.init’输入节都放入该输出节*/
      
       .text :
      
       {
      
        *(.text.init)
      
       }
      
       
      
       /* text: Program code section */
      
      /*定义一个输出节‘.text’，地址为上一个’.text’节尾部的地址，放入该输出节的输入节为输入文件中的‘.text’，‘.text.*’，以及处理内联函数*/
      
       .text : 
      
       {
      
        *(.text)
      
        *(.text.*)
      
        *(.gnu.linkonce.t.*)
      
       }
      
       
      
       /* rodata: Read-only data */
      
      /*定义一个输出节‘.rodata’，地址为上一个’.text’节尾部的地址，放入该输出节的输入节为输入文件中的‘.rdata’，‘.rodata’，‘.rodata.*’，以及处理内联只读数据*/
      
       .rodata : 
      
       {
      
        *(.rdata)
      
        *(.rodata)
      
        *(.rodata.*)
      
        *(.gnu.linkonce.r.*)
      
       }
      
       
      
       /* End of code and read-only segment */
      
      /*定义了一个符号etext，避免程序产生重定义错误，程序引用时但不定义，链接器会使用连接脚本中的定义，如果程序定义了一个'_etext'(带有一个前导下划线), 连接器会给出一个重定义错误.*/
      
       PROVIDE( etext = . );
      
       _etext = .;
      
       
      
       /*--------------------------------------------------------------------*/
      
       /* HTIF, isolated onto separate page                 */
      
       /*--------------------------------------------------------------------*/
      
      /*把节对齐对0x1000字节边界,这样就可以让低12字节的节地址值为零*/
      
       . = ALIGN(0x1000);
      
      /*定义一个输出节‘.htif’，地址为重定位符的地址，放入该输出节的输入节为输入文件中的‘.htif’ */
      
       
      
       .htif :
      
       {
      
      /*定义了一个变量为__htif_base*/
      
        PROVIDE( __htif_base = .);
      
        *(.htif)
      
       }
      
       . = ALIGN(0x1000);
      
       
      
       /*--------------------------------------------------------------------*/
      
       /* Initialized data segment                      */
      
       /*--------------------------------------------------------------------*/
      
       
      
       /* Start of initialized data segment */
      
      /*把节对齐对0x10字节边界,这样就可以让低4字节的节地址值为零，并赋值给_fdata*/
      
       . = ALIGN(16);
      
        _fdata = .;
      
       
      
       
      
       
      
       /* data: Writable data */
      
      /*定义一个输出节‘.data’，地址为_fdata的尾部地址，放入该输出节的输入节为输入文件中的‘.data’，‘.data.*’，‘.srodata*’，内联数据，注释*/
      
       .data : 
      
       {
      
        *(.data)
      
        *(.data.*)
      
        *(.srodata*)
      
        *(.gnu.linkonce.d.*)
      
        *(.comment)
      
       }
      
       
      
       /* End of initialized data segment */
      
      /*把节对齐对4字节边界,这样就可以让低2字节的节地址值为零*/
      
       . = ALIGN(4);
      
      /*定义了一个变量为edata*/
      
       PROVIDE( edata = . );
      
       _edata = .;
      
       
      
       /*--------------------------------------------------------------------*/
      
       /* Uninitialized data segment                     */
      
       /*--------------------------------------------------------------------*/
      
       
      
       /* Start of uninitialized data segment */
      
       . = .;
      
       _fbss = .;
      
       
      
       /* sbss: Uninitialized writeable small data section */
      
       . = .;
      
       
      
       /* bss: Uninitialized writeable data section */
      
       . = .;
      
       _bss_start = .;
      
      /*定义一个输出节‘.bss’，未初始化的可写变量，地址为_bss_start的尾部地址，放入该输出节的输入节为输入文件中的‘.bss’，‘.bss.*’，‘.sbss*’，内联的未初始化的可写变量，全局变量*/
      
       
      
       .bss : 
      
       {
      
        *(.bss)
      
        *(.bss.*)
      
        *(.sbss*)
      
        *(.gnu.linkonce.b.*)
      
        *(COMMON)
      
       }
      
      /*同一般输出节的定义*/
      
       .sbi :
      
       {
      
        *(.sbi)
      
       }
      
       
      
       .payload :
      
       {
      
        *(.payload)
      
       }
      
      /*结尾地址*/
      
       _end = .;
      
      }
      ```

   3. ### 解释kernel.ld文件

      与bbl.lds类似

      ```c
      /* Simple linker script for the ucore kernel.
         See the GNU ld 'info' manual ("info ld") to learn the syntax. */
      /*设置输出文件的体系结构为riscv*/
      OUTPUT_ARCH(riscv)
      /*把kern的入口地址设置成入口地址（进程执行的第一条用户空间的指令在进程地址空间的地址）*/
      ENTRY(kern_entry)
      /*设置基地址*/
      BASE_ADDRESS = 0xC0000000;
      
      SECTIONS
      {
          /* Load the kernel at this address: "." means the current address */
          . = BASE_ADDRESS;
      
          .text : {
              *(.text.kern_entry .text .stub .text.* .gnu.linkonce.t.*)
          }
      
          PROVIDE(etext = .); /* Define the 'etext' symbol to this value */
      
          .rodata : {
              *(.rodata .rodata.* .gnu.linkonce.r.*)
          }
      
          /* Adjust the address for the data segment to the next page */
          . = ALIGN(0x1000);
      
          /* The data segment */
          .data : {
              *(.data)
              *(.data.*)
          }
      
          .sdata : {
              *(.sdata)
              *(.sdata.*)
          }
      
          PROVIDE(edata = .);
      
          .bss : {
              *(.bss)
              *(.bss.*)
              *(.sbss*)
          }
      
          PROVIDE(end = .);
      
          /DISCARD/ : {
              *(.eh_frame .note.GNU-stack)
          }
      }
      
      ```

   4. ### 练习1.2答案

      - Bbl的装载位置为：. = 0x80000000;

        对齐地址： . = ALIGN(0x1000);     . = ALIGN(16);    . = ALIGN(4);

      - Kernel的装载位置：BASE_ADDRESS = 0xC0000000

        对齐地址： . = ALIGN(0x1000);     

      - 一个被系统认为是符合规范的硬盘主引导扇区的特征是什么?

        从sign.c的代码来看，一个磁盘主引导扇区只有512字节。且第510个（倒数第二个）字节是0x55，第511个（倒数第一个）字节是0xAA。

   5. ### 练习2自行使用gdb命令调试

   6. ### 练习3

      1. #### 未装载kernel的启动过程

         正常启动在这获得第一条指令：  `/home/kelee/riscv/qemu-3.1.0/target/riscv/cpu.c  ` 

      ```c
      static void riscv_cpu_reset(CPUState *cs)
      {
          RISCVCPU *cpu = RISCV_CPU(cs);
          RISCVCPUClass *mcc = RISCV_CPU_GET_CLASS(cpu);
          CPURISCVState *env = &cpu->env;
      
          mcc->parent_reset(cs);
      #ifndef CONFIG_USER_ONLY
          env->priv = PRV_M;
          env->mstatus &= ~(MSTATUS_MIE | MSTATUS_MPRV);
          env->mcause = 0;
          env->pc = env->resetvec;
      #endif
          cs->exception_index = EXCP_NONE;
          set_default_nan_mode(1, &env->fp_status);
      }
      
      ```

     	 首先PC取0x1000的代码  ：

      ![反汇编](https://github.com/KeLee5453/os_lab_ucore_riscv32/blob/master/picture/lab1_1.png)

      ```asm
      auipc t0,0x0  ;PC 不变，PC 地址放入t0,  t0=0x1000
      
      addi a1,t0,32 ;t0+32  a1=0x1020
      
      csrr a0,mhartid   ;把空置状态寄存器的值写入a0,a0=0；
      
      lw t0,24(t0)  t0       ;0x80000000   2147483648
      
      jr t0     
      ```

      以上代码在`/home/kelee/riscv/qemu-3.1.0/hw/riscv/spike.c`里面

      ```c
      /* reset vector */
          uint32_t reset_vec[8] = {
              0x00000297,                  /* 1:  auipc  t0, %pcrel_hi(dtb) */
              0x02028593,                  /*     addi   a1, t0, %pcrel_lo(1b) */
              0xf1402573,                  /*     csrr   a0, mhartid  */
      #if defined(TARGET_RISCV32)
              0x0182a283,                  /*     lw     t0, 24(t0) */
      #elif defined(TARGET_RISCV64)
              0x0182b283,                  /*     ld     t0, 24(t0) */
      #endif
              0x00028067,                  /*     jr     t0 */
              0x00000000,
              memmap[SPIKE_DRAM].base,     /* start: .dword DRAM_BASE */
              0x00000000,
                                           /* dtb: */
          };
      ```

      执行跳转指令钱的寄存器信息

      ```c
      (gdb) info registers
      ra             0x00000000	0
      sp             0x00000000	0
      gp             0x00000000	0
      tp             0x00000000	0
      t0             0x80000000	2147483648
      t1             0x00000000	0
      t2             0x00000000	0
      s0             0x00000000	0
      s1             0x00000000	0
      a0             0x00000000	0
      a1             0x00001020	4128
      a2             0x00000000	0
      a3             0x00000000	0
      a4             0x00000000	0
      a5             0x00000000	0
      a6             0x00000000	0
      a7             0x00000000	0
      s2             0x00000000	0
      s3             0x00000000	0
      s4             0x00000000	0
      s5             0x00000000	0
      s6             0x00000000	0
      s7             0x00000000	0
      ```

      0x80000000是链接的起始位置。在`riscv-pk/bbl/bbl.lds`中

      ```c
      SECTIONS
      {
      
        /*--------------------------------------------------------------------*/
        /* Code and read-only segment                                         */
        /*--------------------------------------------------------------------*/
      
        /* Begining of code and text segment */
        . = 0x80000000;
        _ftext = .;
        PROVIDE( eprol = . );
         .text :
        {
          *(.text.init)
        }
      
        /* text: Program code section */
        .text : 
        {
          *(.text)
          *(.text.*)
          *(.gnu.linkonce.t.*)
        }
      ```

      bbl通过将0x80000000地址reset_vector放置在链接到0x80000000的.text.init节的开头来为其分配地址。

      ```asm
        .option norvc
        .section .text.init,"ax",@progbits
        .globl reset_vector
      reset_vector:
        j do_reset
      ```

      以上代码来自`riscv-pk/machine/mentry.S`，最后是一条跳转指令，跳转到`do_rest`对寄存器进行初始化。

      ```asm
      do_reset:
        li x1, 0
        li x2, 0
        li x3, 0
        li x4, 0
        li x5, 0
        li x6, 0
        li x7, 0
        li x8, 0
        li x9, 0
      // save a0 and a1; arguments from previous boot loader stage:
      //  li x10, 0
      //  li x11, 0
        li x12, 0
        li x13, 0
        li x14, 0
        li x15, 0
        li x16, 0
        li x17, 0
        li x18, 0
        li x19, 0
        li x20, 0
        li x21, 0
        li x22, 0
        li x23, 0
        li x24, 0
        li x25, 0
        li x26, 0
        li x27, 0
        li x28, 0
        li x29, 0
        li x30, 0
        li x31, 0
        csrw mscratch, x0
        # write mtvec and make sure it sticks
        la t0, trap_vector
        csrw mtvec, t0
        csrr t1, mtvec
      
      ```

      之后执行

      ```asm
      # Boot on the first hart
        beqz a3, init_first_hart
      ```

      零时分支，跳转到init_first_hart函数，进行一系列的检查和初始化操作。

      ```c
      void init_first_hart(uintptr_t hartid, uintptr_t dtb)
      {
        // Confirm console as early as possible
        query_uart(dtb);
        query_uart16550(dtb);
        query_htif(dtb);
      
        hart_init();
        hls_init(0); // this might get called again from parse_config_string
      
        // Find the power button early as well so die() works
        query_finisher(dtb);
      
        query_mem(dtb);
        query_harts(dtb);
        query_clint(dtb);
        query_plic(dtb);
      
        wake_harts();
      
        plic_init();
        hart_plic_init();
        //prci_test();
        memory_init()
        boot_loader(dtb);
      }
      ```

      以上代码位于：`riscv-pk/machine/minit.c`

      然后执行`boot_loader`的功能。

      在`riscv-pk/bbl/bbl.c`中有`boot_loader`的定义

      ```c
      void boot_loader(uintptr_t dtb)
      {
        extern char _payload_start;
        filter_dtb(dtb);
      #ifdef PK_ENABLE_LOGO
        print_logo();
      #endif
      #ifdef PK_PRINT_DEVICE_TREE
        fdt_print(dtb_output());
      #endif
        mb();
        entry_point = &_payload_start;
        boot_other_hart(0);
      }
      ```

      Payload就是kernel。

      主要功能为打印logo，把设备树fdt传给kernel，接下来执行 `boot_other_hart`函数：

      ```c
      void boot_other_hart(uintptr_t unused __attribute__((unused)))
      {
        const void* entry;
        do {
          entry = entry_point;
          mb();
        } while (!entry);
      
        long hartid = read_csr(mhartid);
        if ((1 << hartid) & disabled_hart_mask) {
          while (1) {
            __asm__ volatile("wfi");
      #ifdef __riscv_div
            __asm__ volatile("div x0, x0, x0");
      #endif
          }
        }
      
        enter_supervisor_mode(entry, hartid, dtb_output());
      }
      
      ```

      进入`supervisor_mode` 然后跳转到kernel的`entry point`，也就是`lab1/kern/init/entry.s`。

      2. #### 装载kernel之后的启动过程

         由lab1的makefile可知，`with-payload`已经指定为lab1中的kernel。
         
         由kernel.ld可知在装载kernel之后运行的指令为`ENTRY(kern_entry)`
         
         `Kern_entry`在`lab1/kern/init/entry.S`中被定义
         
         ```asm
             .section .text,"ax",%progbits
             .globl kern_entry
         kern_entry:
             lla sp, bootstacktop
             tail kern_init
         ```
         
          第一条指令把`bootstacktop`的地址放入寄存器sp中，第二条指令是吧`kern_init`的地址放入pc，即执行`kern_init`函数，`kern_init`函数在`lab1/kern/init/init.c`中定义。 
         
         ```c
         int kern_init(void) {
             extern char edata[], end[];
             memset(edata, 0, end - edata);
         
             cons_init();  // init the console
         
             const char *message = "(THU.CST) os is loading .lab1..\n";
             cprintf("%s\n\n", message);
         
             print_kerninfo();
         
             // grade_backtrace();
         
             pmm_init();  // init physical memory management
         
             pic_init();  // init interrupt controller
             idt_init();  // init interrupt descriptor table
         
             // rdtime in mbare mode crashes
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
         
         这里主要介绍一下`idt_init`函数该函数在`kern/trap/trap.c`中定义:
         
         ```c
         /**
          * @brief      Load supervisor trap entry in RISC-V
          */
         void idt_init(void) {
             extern void __alltraps(void);
             /* Set sscratch register to 0, indicating to exception vector that we are
              * presently executing in the kernel */
             write_csr(sscratch, 0);
             /* Set the exception vector address */
             write_csr(stvec, &__alltraps);
         }
         
         ```
         
          这个函数主要是初始化相关的CSR，trap都由操作系统解决，而这的初始化，只初始化中断相关的CSR，主要是stvec，stevc中保留着中断处理函数的地址，在触发中断时，把地址传给PC，此处的函数为`__alltraps`，定义在`kern/trap/trapentry.S`中 
         
         ```asm
         
            .globl __alltraps
         __alltraps:
             SAVE_ALL
         
             move  a0, sp
             jal trap
             # sp should be the same as before "jal trap" 
         ```
         
         作用为保存所有的寄存器。Scause 中每一个可能的值对应的trap
         
         ![scause](https://github.com/KeLee5453/os_lab_ucore_riscv32/blob/master/picture/lab1_2.png)
         
         然后是`kern/trap/trap.c`中的`trap_in_kernel`函数
         
         ```c
         /* trap_in_kernel - test if trap happened in kernel */
         bool trap_in_kernel(struct trapframe *tf) {
             return (tf->status & SSTATUS_SPP) != 0;
         }
         ```
         
         查看参数，也就是trapframe结构，在`kern/trap/trap.h`中定义
         
         ```c
         struct trapframe {
             struct pushregs gpr;
             uintptr_t status;
             uintptr_t epc;
             uintptr_t badvaddr;
             uintptr_t cause;
         };
         ```
         
         中断相关的CSR都保存在了该结构中。
         
         之后通过判断cause是否为小于0就可以判断中断或异常了。
         
         ```c
         /* trap_dispatch - dispatch based on what type of trap occurred */
         static inline void trap_dispatch(struct trapframe *tf) {
             if ((intptr_t)tf->cause < 0) {
                 // interrupts
                 interrupt_handler(tf);
             } else {
                 // exceptions
                 exception_handler(tf);
             }
         }
         ```
         
         `clock_init()`函数
         
         mideleg（Machine Interrupt Delegation，机器中断委托）CSR 控制将哪些中断委托给 S 模式。与 mip 和 mie 一样，mideleg 中的每个位对应于图 中相同的异常。例如， mideleg[5]对应于 S 模式的时钟中断，如果把它置位，S 模式的时钟中断将会移交 S 模式 的异常处理程序，而不是 M 模式的异常处理程序。
         
         ![中断处理代码]( https://github.com/KeLee5453/os_lab_ucore_riscv32/blob/master/picture/lab1_3.png)
         
         S 模式不直接控制时钟中断和软件中断，而是 使用ecall指令请求 M 模式设置定时器或代表 它发送处理器间中断。 该软件约定是监管者二进制接口 (Supervisor Binary Interface)的一部分。代码见：`lab1/libs/sbi.h`
         
         ```c
         
         static inline void sbi_set_timer(uint64_t stime_value)
         {
         #if __riscv_xlen == 32
         	SBI_CALL_2(SBI_SET_TIMER, stime_value, stime_value >> 32);
         #else
         	SBI_CALL_1(SBI_SET_TIMER, stime_value);
         #endif
         }
         
         ```
         
         ```c
         /* Lazy implementations until SBI is finalized */
         #define SBI_CALL_0(which) SBI_CALL(which, 0, 0, 0)
         #define SBI_CALL_1(which, arg0) SBI_CALL(which, arg0, 0, 0)
         #define SBI_CALL_2(which, arg0, arg1) SBI_CALL(which, arg0, arg1, 0)
         
         ```
         
         ```c
         #define SBI_CALL(which, arg0, arg1, arg2) ({			\
         	register uintptr_t a0 asm ("a0") = (uintptr_t)(arg0);	\
         	register uintptr_t a1 asm ("a1") = (uintptr_t)(arg1);	\
         	register uintptr_t a2 asm ("a2") = (uintptr_t)(arg2);	\
         	register uintptr_t a7 asm ("a7") = (uintptr_t)(which);	\
         	asm volatile ("ecall"					\
         		      : "+r" (a0)				\
         		      : "r" (a1), "r" (a2), "r" (a7)		\
         		      : "memory");				\
         	a0;							\
         })
         ```
         
         利用它的中断处理函数`mcall_set_timer`来处理时钟中断。函数在`riscv-pk/machine/mtrap.c`中定义。
         
         ```c
         void mcall_trap(uintptr_t* regs, uintptr_t mcause, uintptr_t mepc)
         {
           write_csr(mepc, mepc + 4);
         
           uintptr_t n = regs[17], arg0 = regs[10], arg1 = regs[11], retval, ipi_type;
         
           switch (n)
           {
             case SBI_CONSOLE_PUTCHAR:
               retval = mcall_console_putchar(arg0);
               break;
             case SBI_CONSOLE_GETCHAR:
               retval = mcall_console_getchar();
               break;
             case SBI_SEND_IPI:
               ipi_type = IPI_SOFT;
               goto send_ipi;
             case SBI_REMOTE_SFENCE_VMA:
             case SBI_REMOTE_SFENCE_VMA_ASID:
               ipi_type = IPI_SFENCE_VMA;
               goto send_ipi;
             case SBI_REMOTE_FENCE_I:
               ipi_type = IPI_FENCE_I;
         send_ipi:
               send_ipi_many((uintptr_t*)arg0, ipi_type);
               retval = 0;
               break;
             case SBI_CLEAR_IPI:
               retval = mcall_clear_ipi();
               break;
             case SBI_SHUTDOWN:
               retval = mcall_shutdown();
               break;
             case SBI_SET_TIMER:
         #if __riscv_xlen == 32
               retval = mcall_set_timer(arg0 + ((uint64_t)arg1 << 32));
         #else
               retval = mcall_set_timer(arg0);
         #endif
               break;
             default:
               redirect_trap(read_csr(mepc), read_csr(mstatus), read_csr(mtval));
               retval = -ENOSYS;
               break;
           }
           regs[10] = retval;
         }
         ```
         
         ```c
         static uintptr_t mcall_set_timer(uint64_t when)
         {
           *HLS()->timecmp = when;
           clear_csr(mip, MIP_STIP);
           set_csr(mie, MIP_MTIP);
           return 0;
         }
         ```
         
         每个中断对应位在几个CSR中是相同的，所以mip中的STIP位也就对应着sie中的STIE位，也就是时间中断的使能位。在"mcall_set_timer"中该函数会清除mip中对应的STIP位，表示这个中中断已经被处理了；并为mie中的MTIP置位，让下一次时钟中断能够被触发。
   

