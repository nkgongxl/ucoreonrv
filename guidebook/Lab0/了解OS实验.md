# 了解OS实验

写一个操作系统难吗？别被现在上百万行的Linux和Windows操作系统吓倒。当年Thompson趁他老婆带着小孩度假留他一人在家时，写了UNIX；当年Linus还是一个21岁大学生时完成了Linux雏形。站在这些巨人的肩膀上，我们能否也尝试一下做“巨人”的滋味呢？

MIT的Frans Kaashoek等在2006年参考PDP-11上的UNIX Version 6写了一个可在X86上跑的操作系统xv6（基于MIT License），用于学生学习操作系统。我们可以站在他们的肩膀上，基于xv6的设计，尝试着一步一步完成一个从“空空如也”到“五脏俱全”的“麻雀”操作系统——ucore，此“麻雀”包含虚存管理、进程管理、处理器调度、同步互斥、进程间通信、文件系统等主要内核功能，总的内核代码量（C+asm）不会超过5K行。充分体现了“小而全”的指导思想。

ucore的运行环境可以是真实的RISC-V计算机（小型，如智能手表），不过考虑到调试和开发的方便，我们可采用RISC-V硬件模拟器，比如QEMU、BOCHS、VirtualBox、VMware Player等。。ucore的开发环境主要是GCC中的gcc、gas、ld和MAKE等工具，在分析源代码上，可以采用Scitools提供的understand软件（跨平台）、VSCode（跨平台），windows环境上的source insight软件，或者基于emacs+ctags，vim+ctags等，都可以比较方便在在一堆文件中查找变量、函数定义、调用/访问关系等。软件开发的版本管理可以采用GIT、SVN等。比较文件和目录的不同可发现不同实验中的差异性和进行文件合并操作，可使用meld、kdiff3、UltraCompare等软件。调试（deubg）实验有助于发现设计中的错误，可采用gdb（配合qemu）等调试工具软件。并可整个实验的运行环境和开发环境在Linux环境中使用。

那我们准备如何一步一步来实现ucore呢？根据一个操作系统的设计实现过程，我们可以有如下的实验步骤：

1. 

