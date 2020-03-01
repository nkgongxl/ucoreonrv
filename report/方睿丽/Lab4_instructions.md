# Lab4 内核线程的管理
## 实验内容
lab2和lab3中我们完成了一个基于页面的虚拟内存管理方法，在这个基础上我们现在能够实现内核线程的相关操作了。

内核线程可以被看作一个特殊的进程。当一个程序被加载到本实验系统中运行时，操作系统中的内存管理系统会为它分配一片内存供它运行时使用。当多个程序同时在一个系统中运行的时候，它们不仅共享同一片物理内存（这里的共用指的是整个机器的物理内存被划分为几块分别给各个程序单独使用），还会共享同一个CPU，轮流使用；而这一切对他们来说都是透明的。从每一个程序的角度出发都只能感觉到它们各自拥有一片完整的内存和一个只属于自己的CPU。

内核线程和用户进程的区别在于：
- 内核线程只在S-mode下运行，用户进程可能在U-mode和S-mode下交替进行。
- 所有的内核共用一片内存，并且这篇内存仅S-mode及以上特权级可以访问；每个用户进程的内存互不共享，无特殊情况在U-mode及以上特权级别都可以访问。

## 内核线程的创建及执行

### 线程相关结构体

在本实验系统中，每一个内核线程都对应一个proc_struct结构，这个结构里面保留了操作系统管理它所必要的一些信息。我们来看一下它们都是哪些变量：
```
struct proc_struct {
    enum proc_state state;                      // Process state
    int pid;                                    // Process ID
    int runs;                                   // the running times of Proces
    uintptr_t kstack;                           // Process kernel stack
    volatile bool need_resched;                 // bool value: need to be rescheduled to release CPU?
    struct proc_struct *parent;                 // the parent process
    struct mm_struct *mm;                       // Process's memory management field
    struct context context;                     // Switch here to run process
    struct trapframe *tf;                       // Trap frame for current interrupt
    uintptr_t cr3;                              // CR3 register: the base addr of Page Directroy Table(PDT)
    uint32_t flags;                             // Process flag
    char name[PROC_NAME_LEN + 1];               // Process name
    list_entry_t list_link;                     // Process link list 
    list_entry_t hash_link;                     // Process hash list
};
```
proc_state是一个枚举类型，它表示了一个进程/线程会有的几种状态：
```
enum proc_state {
    PROC_UNINIT = 0,  // 一个进程刚被创建但是还没有被初始化的状态
    PROC_SLEEPING,    // 此时进程会以为自己正在运行，但是处理器没有在处理，也叫做挂起状体
    PROC_RUNNABLE,    // 该进程可以开始运行了（下一步就开始运行或者正在运行）
    PROC_ZOMBIE,      // almost dead, and wait parent proc to reclaim his resource
};
```

上一个实验中提到了mm_struct管理着一个进程的根页表，每个进程都会拥有一个。但是由于这个结构主要是为了swap机制而存在，而内核进程作为一个操作系统运行的核心，在运行中是不应该被swap出去的，并不会用到这个结构，所以我们会将内核进程的指针设为NULL。但是mm_struct中掌握了一个进程的pdt也就是根页表，如果只因为这一个值而多创建一个mm_struct比较浪费内存，因此我们会为根页表再增加一个专门记录它的变量cr3。对于其他用户进程来说，这个变量也能节省查找根页表的时间。在原本的x86中，cr3寄存器存放着当前处理器运行的程序的根页表，虽然现在在RISC-V中PDT不会放在cr3里而是在sptbt中，但是名称不会对此产生影响所以没有改（大概主要因为麻烦）。相比内核进程和用户进程，内核进程的根页表是整个系统在建好虚拟地址时的那个根页表（也就是在那之后没有被换掉）。

parent是一个同类型的指针，指向的是当前进程/线程的父进程，也就是创建它的进程。因为idleproc是从内核启动开始第一个被创建的，所以它是唯一一个没有父进程的进程。这个指针可以将所有进程以一个树形结构联系起来，方便内核之后的一些管理。一个例子是内核可以利用这个树结构来判断一个进程是否有权对另一个进程做什么。

context就是我们常说的进程的“上下文”，是一个进程/线程中所有需要保存的寄存器（saved registers sx,ra,sp）。还有就是我们在lab1中已经被实现了的trapframe结构，用于内核处理这个进程相关的中断。kstack对于内核来说就是程序运行时使用的栈，对于用户进程来说，这个栈会用来保存在运行时特权级间切换需要保存的硬件信息。

list_link和hash_link是两个链表的链表项，它们会分别连接/填入到全局链表proc_link和全局哈希表hash_list[HASH_LIST_SIZE]中。proc_list是一个将所有proc_struct串在一起的双向链表，这个链表通过每个进程结构中的list_link连接起来。而hash_link则会通过同一个进程结构中的pid填入这个hash_list。**hash链表用来存放的是什么？作用是什么？**

除了proc_link和hash_list还有几个与进程相关的全局变量： struct proc *current是当前处理器正在运行的进程，struct proc *initproc指向内核中第一个用户进程，但是由于本节实验还只实现了内核进线程，所以暂时指向一个内核线程。nr_process表明当前参与争抢处理器的进程的个数。


#### 问题1
    struct context contex和 struct trapframe *tf成员变量的含义和在本节实验中的作用

### 内核的线程管理需要做的初始化工作
观察kern_init函数，发现多了一个proc_init。这个函数一共会创建两个进程，之后内核会为后面那个进程创建线程。由于相关的中断和内存管理在之前的实验中已经完成了，此时在真正创建进程之前的准备工作实际非常简单，只要初始化proc_link进程链表和hash_list哈希表就好了。

### 分配、初始化一个进程结构
接着我们开始创建我们的第一个进程。在一个进程创建之前，内核会调用alloc_proc函数来给这个进程结构分配一片内存，并为这个实例的各个成员赋一个表明它还没有被初始化的初始值。
proc_init为idleproc初始化后将它赋给current指针，代表内核将idleproc作为当前运行的进程。这里内核将idle_proc的need_resched设为了1。如果这个参数被设为1，

接下来调用kernel_thread创建第二个进程init_main。kernel_thread有三个参数，第一参数是一个指向这个进程要运行的函数的指针，第二个参数是指向该的参数列表的指针，第三个参数是设置这个新创建的进程是否会与当前current指向的线程共用内存还是需要为新线程复制另外一份完全一样的内存。如果CLONE_VM位为1则代表会共享内存，如果为0则代表会复制一片内存。线程/进程之间的切换是利用S-mode的软件中断实现的，在为线程设置好相应的寄存器和tf值后调用SRET指令来实现上下文的切换。kernel_thread会先为这个新创建的线程一个trapframe，函数指针和参数指针会分别放入这个trapframe中的s0和s1寄存器。tf中sstatus的值也会设置为从S-mode陷入S-mode后sstatus的状态：陷入中断前的特权级是S-mode，所以SPP置位，原本中断位是开启的，所以SPIE置位，之后全局中断会关闭，所以SIE位清零。spec寄存器中写入从中断返回后的地址。设置好后会调用do_fork函数来为父线程创建一个子线程。

在do_fork正式创建子线程之前会检查当前系统中线程数是否达到了最大值，如果是则不创建。如果可以创建则为新线程创建一个进程结构，分配一片栈的内存。如果这是一个用户进程在创建线程的话还会将mm_struct复制过去，但是由于我们之前提到的原因，这里copy_mm会将mm设为NULL。在copy_thread中会将刚设好的tf赋给父线程的进程结构，并将这片tf放在这个线程的栈顶（栈是从大地址到小地址，而栈的大小为KSTACKSIZE，kstack是栈的最小地址，所以得到的tf是最小地址）。

这里可能对进程结构中的tf中的sp和context中的sp感到迷惑所以再解释一下。之前提到我们会利用SRET在两个线程之间切换，所以目前的context是父线程的上下文，而tf是接下来要跳转到的子线程的上下文。父线程的返回值是forkret，这个函数在trap.S中定义，我们之后会进行分析；子线程的返回值是0，也就是说它不会再跳到forkret中再创建一个子进程。根据RISC-V的函数调用规范，函数的返回值会放在寄存器a0中，所以将tf中的a0设为0。子线程的栈会根据传入esp的值来确定是使用传入的esp还是tf结构所在的栈。因为这里我们创建的是内核线程，所以子线程和父线程的栈一样，sp也一样，都指向当前tf所在的首地址。

之后从copy_thread返回到do_fork。剩下的都是一些善后工作：为新创建的进程分配一个新的pid，然后把这个进程加入proc_list和hash_list，nr_process数增1，唤醒这个新创建的会fork的进程，最终函数返回pid。

接下来我们又从kenrel_thread返回了proc_init，为这个会fork的进程起名叫"init"，进程的初始化就结束了。

## 内核线程的切换和调度
接着看kern_init我们会发现还新增了一个函数cpu_idle，这个函数也在proc.c中定义，我们接着往下看。
### 进线程切换中的函数调用与寄存器的保存

cpu_idle是一个一直循环的函数。在这里我们会看到如果当前正在运行的程序的need_resched值为1时就会被cpu切出去。看一下sched.c文件中的schedule作了什么。

进程切换是一个原子操作，所以会先关闭中断，再用块把相关语句圈起来。之后我们会在proc_list中挨个寻找下一个处于runnable状态的进程，如果找到了一个下一个可以运行的进程则会调用proc_run来运行下一个进程。

让一个进程运行起来同样是一个原子操作。内核会先将proc赋给current指针，然后改变sptr（这里riscv.h中还是沿用这lcr3这个名称）。最后调用switch.S中的switch_to函数根据函数调用规范更新寄存器的值。做完这一系列操作再用SRET返回，最终就“回到”了被切换进来的新进程。


