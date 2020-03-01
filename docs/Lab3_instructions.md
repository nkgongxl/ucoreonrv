# Lab3
## 实验内容
在这个实验里我们会进一步完善内存管理，主要是完成对Page Fault异常的处理和先进先出的页面替换。

通过之前对虚拟内存和物理内存的了解，我们很容易意识到要同时让所用运行在这个系统上的用户（程序）拥有的虚拟页都能有一个物理页与之对应是不现实的，这就有了替换机制的产生。操作系统会将一些不经常访问到的虚拟页装入硬盘，这样就可以腾出一部分内存空间来给一些经常被访问到的虚拟页，等到访问到这些被换入硬盘中的页时操作系统会把它们重新换回到内存中。这种机制让更多程序能够在内存中并发进行（注意这不代表着多进程或者多线程同步运行，那些同步与CPU有关）。

kern_init中增加了3个新函数：vmm_init，ide_init和swap_init。

- vmm_init中由一系列check函数组成，检查的是do_pgfault是否能够正确处理缺页异常；如果某一个合法的虚拟页没有一个物理页与之对应的话，do_pgfault能够为这个虚拟页申请一个空闲的物理页与之建立映射。

- ide_init的功能是对硬盘的初始化，在这个函数执行完后，kernel就可以将暂时用不到的一些物理页放到swap硬盘上了。

- swap_init函数利用了一个swap_manager结构来实现页面替换的一个算法，与上一节实验中的pmm_manager角色相似。之后调用（where？）check_swap在内核中分配

但目前RISCV并没有提供能够支持外设的工具链，硬盘自然不再能够帮助我们实现页换入换出，硬盘初始化相关的函数也没有必要了。所以在本实验中为了实现一个这种页面切换的机制，我们只有在已有的物理内存上对这种方法进行一种模拟：创建了一个char数组假装它是一块有几个扇区的硬盘。这样一来对“硬盘”进行读写的操作就变得十分简单，原本需要等待io端口来进行传输等操作都不需要了，一个memcpy就能够实现虚拟页面在物理页面和“硬盘”之前的移动。

接下来就是对通用中断处理函数进行修改，让它能够识别出缺页异常然后把这个异常交给do_pgfault进行处理。

## Page Fault 异常处理
Page Fault指的是页面访问异常，通常有两种：一种是缺页异常，一种是非法访问异常。（如何判断？）

在通用异常处理函数中加一个case，引导至do_pgfault中处理。

do_pgfault是处理page fault的异常处理函数。这个函数的主要工作就是把被换进'硬盘'里的数据再换回来，所以除去对读取'硬盘'部分的，其他与x86上的处理并无太大区别。

在了解它如何处理异常之前我们先来了解一下在这个函数之外系统还需要做哪些准备。

首先，Page结构体对比上一个实验多了两个成员：pra_page_link和pra_page_vaddr。pra的意思是page replace algorithm，也就是说这两个变量都是为页面替换算法而新添加的。pra_page_link是一个双向链表的节点，它可以用来构建一个记录了整个内存从第一次某个页被访问开始被访问过的一系列页，链表头是最近被访问的一个页，链表的尾部是最远也就是第一次被访问的地址。pra_vaddr则被用来记录这个页面的首个虚拟地址。

ucore中有两种描述“不存在于物理内存中的”虚拟页的数据结构：vma_struct和mm_struct。

vma_struct控制的是一片地址范围是[vm_start,vm_end)的连续内存，这两个地址的值都是PGSIZE的整数倍。这种变量会在整个操作系统运行中生成。list_link是一个双向链表，它会像上一个实验中free_pages的链表一样将一些vma_struct串在一起，而这个链表中所有的vma_struct都不会有重叠的地址。
```
struct vma_struct {
    struct mm_struct *vm_mm; // the set of vma using the same PDT 
    uintptr_t vm_start;      // start addr of vma      
    uintptr_t vm_end;        // end addr of vma, not include the vm_end itself
    uint32_t vm_flags;       // flags of vma
    list_entry_t list_link;  // linear list link which sorted by start addr of vma
};
```
flag是这片内存都具有的标志位，目前只有三个位：
```
#define VM_READ                 0x00000001
#define VM_WRITE                0x00000002
#define VM_EXEC                 0x00000004
```
除此之外vma_struct中还有一个变量，是struct mm_struct类型的一个指针。这个结构表示的是一片拥有同一个一级页表(PDT)的内存（也就是整个操作系统里的所有内存。如果对进程已经有一些了解我们会知道，操作系统会假装给所有的进程一个大约实际物理内存大小的空间，每一个进程手中都会有一个mm_struct实例来管理它们的所有虚拟内存的根页表。本实验中还没有进程，所以我们会在vmm_check中初始化一个mm_struct来测试是否完成相关功能）。这片内存中存在的所有vma结构都会按照从小到大的顺序被一个双向链表mmap_list串在一起，map_count中记录了这个链表中vma结构的个数。在一个vma_struct被初始化的时候，它会被插入到这个mm_struct中的mmap_list里。pgdir就是这片地址共用的页表的地址。mmap_cache会指向当前进程访问到的内存块vma结构【**mmap_cache什么时候更新的？？？**】。因为程序使用的内存通常是连续的，所以如果之后需要查找vma的话(find_vma函数中，根据虚拟地址addr找其对应的vma)从这个变量开始找一般会更快。
```
struct mm_struct {
    list_entry_t mmap_list;        // linear list link which sorted by start addr of vma
    struct vma_struct *mmap_cache; // current accessed vma, used for speed purpose
    pde_t *pgdir;                  // the PDT of these vma
    int map_count;                 // the count of these vma
    void *sm_priv;                   // the private data for swap manager
};
```
mm_struct中还有一个变量sm_priv。这个指针指向了一个记录着页访问记录的双向链表的表头。mm_struct主要会被swap_manager调用。掌握了整个系统的mm结构就能知道页访问情况，因此fifo的swap管理员就能够得知之后应该交换哪一个页了。

对vma_struct结构进行操作的函数主要是创建、插入和查询。
对mm_struct结构的管理只有创建和删除，但是注意在一个有关vma_struct结构被创建的时候它会被插入到mmap_list中，所以在删除mm_struct的时候也要清除相应vma_struct。
这些函数都比较简单，源码也很直白，这里就不进行解释了。

接下来直接来看pg_fault函数。显然缺页中断也是一个软件中断，所以根据RISC-V的中断异常机制，在缺页中断的时候硬件会自动触发同步异常，为相关的CSR写入需要的值，跳转置通用中断处理函数trap.S中。之后会根据scause中的编码将这个中断交由pgfault_handler函数处理。在x86中，page fault中断可能有三种可能：

- 要访问的虚拟页面没有一个真实存在的物理页面与之对应
- 要访问的虚拟页面所对应的物理页面被替换到了硬盘中
- 低特权级试图访问只有更高特权级才能访问的虚拟页面

上面的每一种情况都有一个错误码与之对应，CPU会在页面异常发生的时候自动将访问出错的地址放入一个特殊的寄存器CR2，之后将这个错误码errorCode保存在中断栈（也就是trapframe）中。在将这个异常交给页面异常处理函数的时候会将这个值传入。这里用到的errorCode主要是后三位：第0位表示这个虚拟页面没有一个物理页面与之对应(0)还是写了这个用户不能写的页(1)（可以是违反了权限级别或者是写了只读页）；第1位表示这个引发错误的指令是一个读指令(0)还是写指令(1)；第2位表示处理器当前处于用户级(1)还是操作系统级(1)。

而在RISC-V中情况有所不同。如同[ABOUT_RISCV]我们所提到的，RISC-V有一些xcause寄存器来对应x86中的中断向量（因为缺页中断在本实验中交由操作系统Supervisor处理，所以这里应该是scause）。scause的中断异常编码是mcause的子集，mcause的异常编码见下图：
![mcause](https://github.com/rllly/ucore_on_riscv_recordings/blob/master/pic/About%20RISC-V/10_mcause_encode.png)。

图中可以看到与地址访问相关的异常有load/store/AMO access fault。AMO（atomic memory operations）也是一种内存访问指令。可以判断在RISC-V中，对应的页面异常应该是这三种。但是这三种内存访问异常可能同样包括上面提出的三种情况。在Specification中只提到了这些操作会引发异常，但是具体是哪一种异常并没有明确指出，所以我们只能猜测这三种情况都存在。并且RISC-V中并没有相应errorCode的机制，但是我们依旧可以利用中断栈(tf)中的信息和scause中的编码(load/store)对此进行判断。在这里我们假设只有物理页面被置换到硬盘中的情况。

这里顺带提一下sstatus中的PUM位。在x86中操作系统可以访问所有用户特权级别的页面，而在RISC-V中，如果PUM被置1，则操作系统的程序访问到用户地址的时候会引发异常。

进入缺页处理函数，我们首先会判断这个地址是否是程序会访问到的地址，也就是是否在一个记录过的vma的范围内。如果是的话，我们会获取这个地址对应的页表。如果这个页表目前不在物理内存中则会分配一片物理内存。因为我们在这个函数里面主要解决的是因为物理页面被切到了硬盘而产生的页面异常，而这种异常一定发生在swap机制被初始化完成之后。我们这里假设已经通过前面的判断成功到达这一步的异常只有这一种可能，所以通过了swap_init_ok，我们就会将这个被访问到的页从硬盘上置换回来。之后利用page_insert重新为这个物理页面和虚拟页面之间建立连接。至此do_pgfault的工作就完成了。

## Swap out algorithm

对于SWAP，RISC-V也为操作系统提供了更加方便的页面置换，操作系统可以借助PTE中的A D位来判断哪些页面可以被换出去。复习一下，A位在这个页面每次被读/写/取址后都会置1。D位则在它被写入后被置1。这两个位会被操作系统在合适的时候清零，之后再在某一个时间读取，这样就可以判断期间这个页面有没有被访问或者被弄脏。这种PTE的修改是即时的。当然如果操作系统永远都不可能用到某个页面的A、D位的时候（例如这个操作系统没有SWAP机制或者这些页面被map在了I/O空间的地址上），这两个位永远被置1。A位可以帮助找出最少使用的页面进行换出，D位则告诉操作系统哪些页面被置换出去。

在本实验中的页面替换算法是FIFO(First In First Out)，所以并没有利用到RISC-V提供的这个设计。

swap相关的几个文件的职能：swap.[ch]为所有的swap_manager搭建了一个框架，在swap_init中全局的swap_manager指针sm被定为指向swap_manager_fifo这个实例。swap_fifo.[ch]中定义和实现了这个实例以及它的各个成员函数。swapfs.[ch]则可以视为swap硬盘面向操作系统的各个接口函数，提供了对swap硬盘的初始化、写页、读页的框架，通过调用ide.[ch]中的各个函数进行实现。虽然由于本实验中没有真正实现与swap硬盘进行交互的机制，ide中的函数也不会真正访问一个硬盘，但是移植后的实验还是保留了这个层级结构。

来看一下struct swap_manager的成员:
```
struct swap_manager
{
     const char *name;
     /* Global initialization for the swap manager */
     int (*init)            (void);
     /* Initialize the priv data inside mm_struct */
     int (*init_mm)         (struct mm_struct *mm);
     /* Called when tick interrupt occured */
     int (*tick_event)      (struct mm_struct *mm);
     /* Called when map a swappable page into the mm_struct */
     int (*map_swappable)   (struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in);
     /* When a page is marked as shared, this routine is called to
      * delete the addr entry from the swap manager */
     int (*set_unswappable) (struct mm_struct *mm, uintptr_t addr);
     /* Try to swap out a page, return then victim */
     int (*swap_out_victim) (struct mm_struct *mm, struct Page **ptr_page, int in_tick);
     /* check the page relpacement algorithm */
     int (*check_swap)(void);     
};

```
在整个系统的swap_init之前，我们需要对swap硬盘进行初始化，检查这个硬盘是否能正常运行。确定了全局的swap_manager之后调用这个实例的初始化函数，这里主要是为了初始化。如果初始化正常，swap_init_ok置为1.

当系统被要求要有一个页面换出的时候，首先会调用到fifo管理员的swap_out_victim来选择一个目前记录在链表中最早被访问的那个页面。这里就会用到mm_struct中的sm_priv变量，再把这个页从访问链表中删除。之后这个函数会找到这个页然后返回给swap_out，我们也就能够找到它对应的页表项的地址。接着系统会尝试将这个页面写入硬盘，如果成功则将这个页释放并加入free_page链表，如果不成功则会把这个页重新加入访问页表中。

当系统被要求要有一个页面被换入的时候，首先会为这个页分配内存。之后通过这个虚拟地址的pte找到它在swap硬盘中的位置，从而将这个页读取到虚拟地址对应的物理地址上。

### 问题1.如果实验系统当前正在执行一个缺页异常的处理程序，这个程序在执行过程中访问内存，又触发了一个page fault。（什么时候会发生这种情况？读取pte的时候。）此时硬件需要做什么？（此时的SIE全局中断使能是否开启？scause等中断CSR如何保存？都可以在第一节中关于中断的介绍中得到答案）

### 实现extended clock 页替换算法 的设计，现有swap_manager足够实现？
    - 需要被换出的页的特征？
    - 如何判断具有这样特征的页
    - 何时进入换入换出？


