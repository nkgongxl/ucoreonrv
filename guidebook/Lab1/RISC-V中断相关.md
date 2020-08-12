# RISC-V中断相关

## 寄存器

除了32个通用寄存器之外，RISCV架构还有大量的 **控制状态寄存器** **Control and Status Registers**(CSRs)。其中有几个重要的寄存器和中断机制有关。

有些时候，禁止CPU产生中断很有用。（就像你在做重要的事情，如操作系统lab的时候，并不想被打断）。所以，`sstatus`寄存器(Supervisor Status Register)里面有一个二进制位`SIE`(supervisor interrupt enable，在RISCV标准里是2^1 对应的二进制位)，数值为0的时候，如果当程序在S态运行，将禁用全部中断。（对于在U态运行的程序，SIE这个二进制位的数值没有任何意义），`sstatus`还有一个二进制位`UIE`(user interrupt enable)可以在置零的时候禁止用户态程序产生中断。

在中断产生后，应该有个**中断处理程序**来处理中断。CPU怎么知道中断处理程序在哪？实际上，RISCV架构有个CSR叫做`stvec`(Supervisor Trap Vector Base Address Register)，即所谓的”中断向量表基址”。中断向量表的作用就是把不同种类的中断映射到对应的中断处理程序。如果只有一个中断处理程序，那么可以让`stvec`直接指向那个中断处理程序的地址。

对于RISCV架构，`stvec`会把最低位的两个二进制位用来编码一个“模式”，如果是“00”就说明更高的SXLEN-2个二进制位存储的是唯一的中断处理程序的地址(SXLEN是`stval`寄存器的位数)，如果是“01”说明更高的SXLEN-2个二进制位存储的是中断向量表基址，通过不同的异常原因来索引中断向量表。但是怎样用62个二进制位编码一个64位的地址？RISCV架构要求这个地址是四字节对齐的，总是在较高的62位后补两个0。

> [!NOTE|style:flat]
>
> 手册P110
>
> 机器和监管者自陷向量（trap-vector）基地址寄存器（ mtvec和 stvec) CSR。他们是位宽为
> XLEN的读 /写寄存器，用于保存自陷向量的配置，包括向量基址（ BASE）和向量模式 （MODE）。
> BASE域中的值必须按 4字节对齐。 MODE = 0表示所有异常都把 PC设置为 BASE。 MODE = 1会在一部中断时将 PC设置为 (𝑩𝑨𝑺𝑬+(𝟒×𝒄𝒂𝒖𝒔𝒆))。

当我们触发中断进入 S 态进行处理时，以下寄存器会被硬件自动设置，将一些信息提供给中断处理程序：

**sepc**(supervisor exception program counter)，它会记录触发中断的那条指令的地址；

**scause**，它会记录中断发生的原因，还会记录该中断是不是一个外部中断；

**stval**，它会记录一些中断处理所需要的辅助信息，比如指令获取(instruction fetch)、访存、缺页异常，它会把发生问题的目标地址或者出错的指令记录下来，这样我们在中断处理程序中就知道处理目标了。

## 特权指令

RISCV支持以下和中断相关的特权指令：

**ecall**(environment call)，当我们在 S 态执行这条指令时，会触发一个 ecall-from-s-mode-exception，从而进入 M 模式中的中断处理流程（如设置定时器等）；当我们在 U 态执行这条指令时，会触发一个 ecall-from-u-mode-exception，从而进入 S 模式中的中断处理流程（常用来进行系统调用）。

**sret**，用于 S 态中断返回到 U 态，实际作用为pc←sepc，回顾**sepc**定义，返回到通过中断进入 S 态之前的地址。

**ebreak**(environment break)，执行这条指令会触发一个断点中断从而进入中断处理流程。

**mret**，用于 M 态中断返回到 S 态或 U 态，实际作用为pc←mepc，回顾**sepc**定义，返回到通过中断进入 M 态之前的地址。（一般不用涉及）

> [!TIP|style:flat]
>
> 关于上面提及的内容，要去手册里找相关内容，然后看明白！