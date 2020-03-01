# Lab2 物理内存管理
## 实验内容
本节实验主要实现了对物理内存的管理初始化以及从物理内存向虚拟内存的最基本转换。kernel现有功能的初始化顺序仍然可以通过kernel_init函数来查看。在完成本节实验前请先阅读[32位RISC-V的虚拟内存映射机制](https://github.com/rllly/ucore_on_riscv_recordings/blob/master/docs/About%20RISC-V.md#%E8%99%9A%E6%8B%9F%E5%86%85%E5%AD%98%E6%98%A0%E5%B0%84%E6%9C%BA%E5%88%B6sv32)。
## 基于页面的虚拟地址管理初始化流程
跟着pmm_init的调用顺序来看：
物理内存初始化过程可以在物理内存的总控函数pmm_init中观察到：

```
void pmm_init(void) {
    // 我们需要分配/释放物理内存 （通产来说是4KB的倍数大小）
    // 在pmm.h中已经定义一个物理内存管理器的框架
    // 首先我们需要利用这个框架实例化一个物理内存管理器(pmm)
    // 它具有分配/释放物理内存的功能。
    // 根据现有物理内存分配算法，我们可以有首个匹配、最佳匹配、最坏匹配、buddy system等pmm
    // (The buddy memory allocation technique is a memory allocation algorithm that divides
    //  memory into partitions to try to satisfy a memory request as suitably as possible. 
    //  This system makes use of splitting memory into halves to try to give a best fit.)
    init_pmm_manager();

    // 探测物理内存大小，保留已经使用了的内存（问题1 这些已经被使用了的内存都被在哪里了？）
    // 然后使用pmm->init_memmap来创建一个空闲页列表
    page_init();

    // 用pmm->check来测试pmm中分配和释放函数的正确性
    check_alloc_page();

    // 创造一个页目录表
    boot_pgdir = boot_alloc_page();
    memset(boot_pgdir, 0, PGSIZE);
    boot_cr3 = PADDR(boot_pgdir);

    check_pgdir();

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0); 

    // 这是原实验很有趣的一个设计（与JOS不同，可以找来对比一下两个实验）想要详细了解可以看后面
    // 目前只要这是将也目录表自身作为一个页目录表项把自己填在了页目录表中VPT的位置
    boot_pgdir[PDX(VPT)] = pte_create(PPN(boot_cr3), PAGE_TABLE_DIR);
    boot_pgdir[PDX(VPT) + 1] = pte_create(PPN(boot_cr3), READ_WRITE);

    // 将物理内存0~KMEMSIZE的内存都线性映射在虚拟内存KERNBASE~KERBASE+KMEMSIZE上
    // 这个映射只能在完成enable_paging()和gdt_init()两个函数之后执行。（gdt_init是在原本x86分段模式中使用的初始化函数
    // 而在本实验RISC-V的qemu中我们没有这个分段机制了，gdt_init）
    // boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, PADDR(KERNBASE), READ_WRITE_EXEC);

    // IMPORTANT !!!
    // Map last page to make SBI happy
    // pde_t *sptbr = KADDR(read_csr(sptbr) << PGSHIFT);
    // pte_t *sbi_pte = get_pte(sptbr, 0xFFFFFFFF, 0);
    // boot_map_segment(boot_pgdir, (uintptr_t)(-PGSIZE), PGSIZE,
    //                  PTE_ADDR(*sbi_pte), READ_EXEC);

    enable_paging();

    // now the basic virtual memory map(see memalyout.h) is established.
    // check the correctness of the basic virtual memory map.
    check_boot_pgdir();

    print_pgdir();
}
```
本实验中构建了几个数据结构来帮助管理物理页面：
-pmm_manager\
    在kern/mm/pmm.h中定义。一个pmm_manager的实例就是一套页面管理方法，其中包含了各种页面管理相关的函数指针。本实验系统实例化了唯一一个pmm_manager，即default_pmm_manager。该实例及其实现函数在kern/mm/default_pmm.c中定义。
- list_entry_t 等list相关结构\
  本实验中的pmm_manager利用一个双向链表list来管理空闲的物理页表。双向链表相关实现在lab2/libs/list.h中。

- Page\
    Page结构体在kern/mm/memlayout.h中定义。每一个Page结构体，顾名思义，代表一个物理页面。一个Page中包含四个变量：ref表示这个页被多少个页表指向了，当一个虚拟页和这个物理页进行了映射则该值增1；flags是这个物理页的状态，代表这个物理页是否能被内存管理机制动态分配或者释放，但是只有空闲块中的第一页会被设为0；property与空闲内存块有关，记录了这个块中一共有多少个空闲页，但是一个空闲块中只有地址最小的那一页会有这个属性；page_link是一个双向链表指针，一片连续的空闲物理页会用这个指针连续在一起。
- free_area_t\
  这个结构体是用于掌管所有空闲的物理内存块，其只有两个变量，一个是记录了所有空闲物理页的链表指针free_list，一个是nr_free，记录了当前空闲物理页数。

除此之外在mmh.h、memlayout.h中还定义了很多简化表达的宏，这里不一一介绍，自行查看即可。


### 页面管理结构实例初始化
init_pmm_manager调用了default_init函数。主要是初始化管理空闲物理页的双向链表free_list。此时链表为空，物理页面计数nr_free变量也被初始化为0.
### 物理页面布局初始化
（疑问：为什么RISCV的起始地址是从0x80000000开始？前面的地址是空着还是放了什么东西？）
接下来进入page_init函数。

既然要管理整个一块连续的物理内存，我们需要知道整个物理内存的起始地址和最大地址。

先来看起始地址。汇编文件里的标签名就相当于一个全局函数指针。如果还记得上个实验中在entry.S和kern.ld中的内容就知道kern_entry是整个内核的起始地址，这个标签可以被视作一个指向内核起始地址的一个指针变量。在page_init函数中这个地址被赋给了mem_begin，并在之后用cprintf打印了出来，可以看到其值为0x80400000，这个值页在kernel.ld链接脚本中被定义。本实验的qemu其实一共有8M的DRAM，同样，在上一节看过的bbl.ld中可以看到，bbl是被装载在0x80000000的地址上。这是RISCV中整个内存的起始地址。知道了物理内存的大小和它的起始地址，我们就可以得出最大的物理地址，这个值放入mem_end中。得到了内核的起始物理地址和最大物理地址，也就能得出整个内存的大小，值放入mem_size中。

知道了RISCV-QEMU给kernel提供的最大物理内存之后，我们还需要判断这个大小是否超过ucore的支持范围。ucore设定只支持896M的物理内存空间，这是一个设定值，可以根据情况改变。对应的KMEMSIZE值在memlayout.h中定义。同样我们可以得出ucore支持的最大内核地址为KERNTOP=KERNBASE+KMEMSIZE。 显然对于当前的操作系统来说能够使用的最大物理地址应该是maxpa=min{KERNTOP,mem_end}，这个值才是我们之后需要管理的最大物理地址。在之前x86平台上的实验中，起始地址从0开始，而在riscv上起始地址是从0x80000000，所以所有记录下的物理页数npages不再是maxpa/PGSIZE，而是(maxpage-DRAM_DRAMBASE)/PGSIZE。

由于此时非空闲的物理页都应当被保留，我们会先将所有物理页面都设为被保留的，再在之后的初始化里面对空闲的物理页重新设为可用的。对Page结构设置保留的宏SetPageReserved在pmm.h中定义。

除去kernel外，我们还需要一片内存来放内存管理信息，也就是需要管理的物理页面数*struct Page。之后的地址就是可用的地址了。pages是第一个物理页的struct Page的地址，而总共有(maxpage-DRAM_DRAMBASE)个物理页，所以freemem从这之后的内存开始。

在将这篇空闲地址页对其后将相应参数传递给pmm_manager来管理。接下来就跳转到了default_init_memmap函数中。在这个函数里会对每个空闲物理页对应的struct Page进行初始化。此时没有程序占用这些的物理内存，所以它们会被初始化为一整个空闲块(block)，被加入到free_list中。
### 分配和释放页面
在收集了所有空闲物理页面的信息后pmm_manager就可以做一些分配和释放的动作了。kernel分配和释放页面同样是通过pmm_manager来进行管理，只是在正式调用pmm_manager做相应动作之前需要先保留sstatus中的全局中断使能位，在调用完成后进行恢复。这里用到了一对函数intr_save和intr_restore，它们在kern/sync/sync.h中定义。
- **分配物理页面**\
    在分配之前显然需要先检查是否有足够多的空闲页，如果没有的话直接返回一个空指针。

    之后，遍历free_list中的每一个空闲块，查看这个块中的页是否满足要求，如果满足的话则将当前块的起始页设置为返回值，并将这个块从freelist中删除，并把块中多余页回收进free_list中，修改空闲页数。在返回这个正好是n页的空闲块指针之前把起始页的flag设为不可分配的。\

- **释放物理页面**\
    回收物理页面需要为每个页的flags和ref清零，首个被清零的物理页修改flag和这个空闲块的页数。之后这个空闲块被重新按照地址大小排序被放进free_list中，再分别查看这个空闲块是否能和前面的和后面的空闲块合并，能则合并。

(pmm.h中定义了一个宏，alloc_page就相当于调用了alloc_pages(1).)


### 初始化根页表
在收集了所有物理内存之后就可以初始化根页表了。首先它需要一个被分配一个物理页，清0后为它之上的页表项初始化相应值。

这里先介绍几个函数/宏/变量。
- boot_cr3是根页表的物理地址。
- PDX(va)是va这个虚拟地址的第一级VPN。
- 在根页表中，PDX[VPT]项放的是一个指向它自己的指针。这里可以参照ucore实验书中的自映射机制。
- pte_create是一个页表项初始化函数，它会将传入的PPN和之后的几个标志位组合成一个完整的32位页表项内容。
- get_pte会为内核的物理地址返回相应的虚拟地址所在的页表的地址。如果这个页表不存在，情况允许时则会为它分配一页内存创建一个页表。

根页表首先会将自己填入相应的页表项，这样就在虚拟地址VPT上形成了一个虚拟页表。在VPT对应的页表项之后的一个项根页表`ADDR(PDX[VPT]+1)`还会插入一个相同的值，不同的是这个页被标记为可读可写的。

之后所有内核地址被map在相应的物理地址上并被标记为可读可写的。此时相应的第二级页表也会被创建。

### 启用页表模式
因为在进入kernel的时候已经启动了虚拟内存模式，现在只需将boot_cr3也就是刚才初始化过根页表所在的地址写入satp（就是我们之前提到的sptbr），正式启用我们定义的这个虚拟内存管理模式。




