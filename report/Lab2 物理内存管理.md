# Lab2 物理内存管理

## 实验内容

本节实验主要实现对物理内存的管理初始化以及物理内存向虚拟内存的最基本转换。

## 基于页面的虚拟内存

S 模式提供了一种传统的虚拟内存系统，它将内存划分为固定大小的页来进行地址转 换和对内存内容的保护。启用分页的时候，大多数地址（包括 load 和 store 的有效地址和 PC 中的地址）都是虚拟地址。要访问物理内存，它们必须被转换为真正的物理地址，这通 过遍历一种称为页表的高基数树实现。页表中的叶节点指示虚地址是否已经被映射到了真 正的物理页面，如果是，则指示了哪些权限模式和通过哪种类型的访问可以操作这个页。访问未被映射的页或访问权限不足会导致页错误例外（page fault exception）。

RV32 的分页方案 Sv32 支持 4GiB 的虚址空间，这些空间被划分为 210个 4 MiB 大小的巨 页。每个巨页被进一步划分为 210个 4 KiB 大小的基页（分页的基本单位）。因此，Sv32 的 页表是基数为 210的两级树结构。页表中每个项的大小是四个字节，因此页表本身的大小 是 4 KiB。页表的大小和每个页的大小完全相同，这样的设计简化了操作系统的内存分配。 

![PTE](https://github.com/KeLee5453/os_lab_ucore_riscv32/blob/master/picture/PTE.png)

上图显示了 Sv32 页表项（page-table entry，PTE）的布局，从左到右分别包含如下 所述的域： 

- V 位决定了该页表项的其余部分是否有效（V = 1 时有效）。若 V = 0，则任何遍历 到此页表项的虚址转换操作都会导致页错误。 
- R、W 和 X 位分别表示此页是否可以读取、写入和执行。如果这三个位都是 0， 那么这个页表项是指向下一级页表的指针，否则它是页表树的一个叶节点。
- U 位表示该页是否是用户页面。若 U = 0，则 U 模式不能访问此页面，但 S 模式 可以。若 U = 1，则 U 模式下能访问这个页面，而 S 模式不能。
- G 位表示这个映射是否对所有虚址空间有效，硬件可以用这个信息来提高地址转 换的性能。这一位通常只用于属于操作系统的页面。
- A 位表示自从上次 A 位被清除以来，该页面是否被访问过。
- D 位表示自从上次清除 D 位以来页面是否被弄脏（例如被写入）。 
- RSW 域留给操作系统使用，它会被硬件忽略。
- PPN 域包含物理页号，这是物理地址的一部分。若这个页表项是一个叶节点，那 么 PPN 是转换后物理地址的一部分。否则 PPN 给出下一节页表的地址。（图 10.10 将 PPN 划分为两个子域，以简化地址转换算法的描述。） 

![satp](https://github.com/KeLee5453/os_lab_ucore_riscv32/blob/master/picture/satp.png)

一个叫 satp（Supervisor Address Translation and Protection，监管者地址转换和保护） 的 S 模式控制状态寄存器控制了分页系统。如上图 所示，satp 有三个域。MODE 域可 以开启分页并选择页表级数，下图展示了它的编码。ASID（Address Space Identifier， 地址空间标识符）域是可选的，它可以用来降低上下文切换的开销。最后，PPN 字段保存 了根页表的物理地址，它以 4 KiB 的页面大小为单位。通常 M 模式的程序在第一次进入 S 模式之前会把零写入 satp 以禁用分页，然后 S 模式的程序在初始化页表以后会再次进行 satp 寄存器的写操作。 

![MODE](https://github.com/KeLee5453/os_lab_ucore_riscv32/blob/master/picture/MODE.png)



当在 satp 寄存器中启用了分页时，S 模式和 U 模式中的虚拟地址会以从根部遍历页表 的方式转换为物理地址。下图描述了这个过程：

1. satp.PPN 给出了一级页表的基址，VA[31:22]给出了一级页号，因此处理器会读取 位于地址(satp.PPN × 4096 + VA[31:22] × 4)的页表项。 
2. 该 PTE 包含二级页表的基址，VA[21:12]给出了二级页号，因此处理器读取位于地 址(PTE.PPN × 4096 + VA[21:12] × 4)的叶节点页表项。 
3. 叶节点页表项的 PPN 字段和页内偏移（原始虚址的最低 12 个有效位）组成了最 终结果：物理地址就是(LeafPTE.PPN × 4096 + VA[11:0]) 

![地址映射过程](https://github.com/KeLee5453/os_lab_ucore_riscv32/blob/master/picture/地址映射过程.png) 

如果所有取指，load 和 store 操作都导致多次页表访问，那么分页会大大地降低性能！所有现代的处理器都用地 址转换缓存（通常称为 TLB，全称为 Translation Lookaside Buffer）来减少这种开销。为了 降低这个缓存本身的开销，大多数处理器不会让它时刻与页表保持一致。这意味着如果操 作系统修改了页表，那么这个缓存会变得陈旧而不可用。S 模式添加了另一条指令来解决 这个问题。这条 sfence.vma 会通知处理器，软件可能已经修改了页表，于是处理器可以 相应地刷新转换缓存。它需要两个可选的参数，这样可以缩小缓存刷新的范围。一个位于 rs1，它指示了页表哪个虚址对应的转换被修改了；另一个位于 rs2，它给出了被修改页表 的进程的地址空间标识符（ASID）。如果两者都是 x0，便会刷新整个转换缓存。 

## 基于页面的虚拟地址管理初始化流程

在启动kernel被qemu装载时，执行`kern_init`函数，其代码如下：

```c
int kern_init(void) {
    extern char edata[], end[];
    memset(edata, 0, end - edata);
    cons_init();  // init the console
    const char *message = "(THU.CST) os is loading ...";
    cprintf("%s\n\n", message);

    print_kerninfo();

    // grade_backtrace();
    idt_init();  // init interrupt descriptor table

    pmm_init();  // init physical memory management

    pic_init();  // init interrupt controller
    idt_init();  // init interrupt descriptor table

    clock_init();   // init clock interrupt
    intr_enable();  // enable irq interrupt

    // LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    // lab1_switch_test();

    /* do nothing */
    while (1)
        ;
}
```

因此首先初始化中断描述表，然后就是物理内存管理初始化。根据实验目录结构，我们可以很容易找到`pmm_init`函数的位置，即：`kern/mm/pmm.c`中，函数的代码如下：

```c
void pmm_init(void) {
    // We need to alloc/free the physical memory (granularity is 4KB or other
    // size).
    // So a framework of physical memory manager (struct pmm_manager)is defined
    // in pmm.h
    // First we should init a physical memory manager(pmm) based on the
    // framework.
    // Then pmm can alloc/free the physical memory.
    // Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();

    // use pmm->check to verify the correctness of the alloc/free function in a
    // pmm
    check_alloc_page();

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
    memset(boot_pgdir, 0, PGSIZE);
    boot_cr3 = PADDR(boot_pgdir);

    check_pgdir();

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = pte_create(PPN(boot_cr3), PAGE_TABLE_DIR);
    boot_pgdir[PDX(VPT) + 1] = pte_create(PPN(boot_cr3), READ_WRITE);

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    // But shouldn't use this map until enable_paging() & gdt_init() finished.
    // boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, PADDR(KERNBASE),
                     READ_WRITE_EXEC);

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

从代码的注释以及顺序可以看到：

1. 首先定义一个物理内存管理器，他可以分配和释放物理内存；
2. 然后探测物理内存大小，保留已经使用的内存，然后使用`pmm->init_memmap`来创建一个空闲页列表
3. 使用`pmm->check`检查pmm中分配和释放函数的正确性
4. 创建一个页目录表（PDT）
5. 然后检查页目录
6. 在虚拟地址VPT中巧妙的插入boot_pgdir以形成虚拟页表，也就是把自身作为一个页目录表项把自己填在了页目录表中VPT的位置。
7. 将物理内存0~KMEMSIZE的内存都线性映射在虚拟内存KERNBASE~KERBASE+KMEMSIZE上，但是这个映射只有在`enable_paging()`和`gbt_init()`两个函数执行后执行。 由于RISC-V下物理地址不再是从`0x00000000`开始，我们需要建立`KERNBASE~KERNBASE+KMEMSIZE => PADDR(KERNBASE)~PADDR(KERNBASE)+KMEMSIZE`的映射。
8. 开启页表
9. 检查映射的正确性

### 物理内存管理器

首先找到定义的`pmm_manager`结构，在`kern/mm/pmm.h`中定义：

```c
// pmm_manager is a physical memory management class. A special pmm manager -
// XXX_pmm_manager
// only needs to implement the methods in pmm_manager class, then
// XXX_pmm_manager can be used
// by ucore to manage the total physical memory space.
struct pmm_manager {
    const char *name;  // XXX_pmm_manager's name
    void (*init)(
        void);  // initialize internal description&management data structure
                // (free block list, number of free block) of XXX_pmm_manager
    void (*init_memmap)(
        struct Page *base,
        size_t n);  // setup description&management data structcure according to
                    // the initial free physical memory space
    struct Page *(*alloc_pages)(
        size_t n);  // allocate >=n pages, depend on the allocation algorithm
    void (*free_pages)(struct Page *base, size_t n);  // free >=n pages with
                                                      // "base" addr of Page
                                                      // descriptor
                                                      // structures(memlayout.h)
    size_t (*nr_free_pages)(void);  // return the number of free pages
    void (*check)(void);            // check the correctness of XXX_pmm_manager
};
```

该结构是管理物理内存的一个类，其中定义了一些物理内存的管理方法。

1. 第一个函数是初始化`XXX_pmm_manager`的内部描述和管理数据结构（空闲块列表以及数量）。
2. 第二个函数是根据初始化的空间物理内存空间设定相应的描述与管理的数据结构。
3. 第三个函数是分配页 
4. 第四个函数是释放页。
5. 第5个函数是计算空闲页的数目。
6. 检查`XXX_pmm_manager`的正确性。

本实验实例化了唯一一个`pmm_manager`即`default_pmm_manager`，该实例的实现函数在`kern/mm/default_pmm.c`中

```c
const struct pmm_manager default_pmm_manager = {
    .name = "default_pmm_manager",
    .init = default_init,
    .init_memmap = default_init_memmap,
    .alloc_pages = default_alloc_pages,
    .free_pages = default_free_pages,
    .nr_free_pages = default_nr_free_pages,
    .check = default_check,
};
```

#### default_init

```c
static void
default_init(void) {
    list_init(&free_list);
    nr_free = 0;
}
```

在此之前定义了`free_list`

```c
#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)
```

涉及的结构类型为`free_area_t`，其定义在`kern/mm/memlayout.h`中：

```c
/* free_area_t - maintains a doubly linked list to record free (unused) pages */
typedef struct {
    list_entry_t free_list;         // the list header
    unsigned int nr_free;           // # of free pages in this free list
} free_area_t;
```

`default_init`函数主要是在初始化一个管理空闲物理页的双向链表`free_list`，并把变量`nr_free`置为0。链表以及其相关函数的定义在`libs/list.h`中，这里不一一做介绍。

#### default_init_memmap

```c
static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);//判断n是否大于O
    struct Page *p = base;
    //初始化n块物理页
    for (; p != base + n; p ++) {
        assert(PageReserved(p));//检查此页是否为保留页
        p->flags = p->property = 0;//标志位清0
        set_page_ref(p, 0);//清除引用此页的虚拟页个数
    }
    base->property = n;//修改base的连续空页值为n
    SetPageProperty(base);//设置标志位为1
    nr_free += n;//计算空闲页总数
    //遍历整个空闲链表
    if (list_empty(&free_list)) {
        list_add(&free_list, &(base->page_link));
    } else {
        list_entry_t* le = &free_list;
        while ((le = list_next(le)) != &free_list) {
            struct Page* page = le2page(le, page_link);//转换为页结构
            if (base < page) {
                list_add_before(le, &(base->page_link));//按从小到大的顺序加入空闲链表
                break;
            } else if (list_next(le) == &free_list) {
                list_add(le, &(base->page_link));
            }
        }
    }
}
```

函数的参数是`Page`结构的指针，该结构在`kern/mm/memlayout.h`中定义：

```c
/* *
 * struct Page - Page descriptor structures. Each Page describes one
 * physical page. In kern/mm/pmm.h, you can find lots of useful functions
 * that convert Page to other data types, such as physical address.
 * */
struct Page {
    int ref;                        // page frame's reference counter
    uint32_t flags;                 // array of flags that describe the status of the page frame
    unsigned int property;          // the num of free block, used in first fit pm manager
    list_entry_t page_link;         // free list link
};
```

一个`Page`结构体就代表着一个物理页，一个页中包含4个变量

1. `ref` 表示 这个页被页表的引用记数，也就是映射此物理页的虚拟页个数。如果这个页被页表引用了，即在某页表中有一个页表项设置了一个虚拟页到这个Page管理的物理页的映射关系，就会把Page的ref加一；反之，若页表项取消，即映射关系解除，就会把Page的ref减一 。
2. `flags`是描述这个物理页的状态， 有两个标志位状态，为1的时候，代表这一页是free状态，可以被分配，但不能对它进行释放；如果为0，那么说明这个页已经分配了，不能被分配，但是可以被释放掉。。
3. `property` 用来记录某连续空闲页的数量，这里需要注意的是用到此成员变量的这个Page一定是连续内存块的开始地址（第一页的地址）。
4.  `page_link` 是便于把多个连续内存空闲块链接在一起的双向链表指针，连续内存空闲块利用这个页的成员变量page_link来链接比它地址小和大的其他连续内存空闲块，释放的时候只要将这个空间通过指针放回到双向链表中。 

函数执行时，判断n是否大于0，如果小于零终止，然后初始化n块物理页，先判断是不是保留页，如果不是则进行下一步，将标志位清0，连续空页个数清0，然后把标志位设置为1，计算空闲页总数，然后再加入空闲链表。

#### default_alloc_pages

```c
static struct Page *
default_alloc_pages(size_t n) {
    assert(n > 0);//判断n是否大于0
    if (n > nr_free) {//需要分配页的个数大于空闲页的总数，直接返回
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;//定义空闲链表的头部
    while ((le = list_next(le)) != &free_list) {//遍历整个空闲链表
        struct Page *p = le2page(le, page_link);//转换为页结构
        if (p->property >= n) {//找到合适的空闲页即连续的空闲页数量大于n，就可以分配
            page = p;
            break;
        }
    }
    if (page != NULL) {//如果分配成功
        list_entry_t* prev = list_prev(&(page->page_link));//找到前一个页
        list_del(&(page->page_link));//从free_list中删除当前页
        if (page->property > n) {//如果页的大小大于所需要的大小，分割页，即新建一个页
            struct Page *p = page + n;
            p->property = page->property - n;//页的连续空闲空间减小
            SetPageProperty(p);
            list_add(prev, &(p->page_link));//加在原来页的位置
        }
        nr_free -= n;//减去已经分配的页
        ClearPageProperty(page);//清除分配后的页的连续块的大小
    }
    return page;//返回分配页的页块地址。
}
```

 分配空闲页时首先判断空闲页的大小是否大于所需的页块大小。  如果需要分配的页面数量n，已经大于了空闲页的数量，那么直接`return NULL`分配失败。 过了这一个检查之后，遍历整个空闲链表。如果找到合适的空闲页，即`p->property >= n`（从该页开始，连续的空闲页数量大于n），即可认为可分配，从空闲链表里删除该页，重新设置标志位。具体操作是调用`ClearPageProperty(p)`，清空该页面的连续空闲页面数量值。 如果当前空闲页的大小大于所需大小。则分割页块。具体操作就是，刚刚分配了n个页，如果分配完了，还有连续的空间，则在最后分配的那个页的下一个页（未分配），更新它的连续空闲页值。如果正好合适，则不进行操作。 

#### default_free_pages

```c
static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {//从base开始遍历检查需要释放的页块是否被分配，如果被分配就把flags置为0，说明已经被分配，可以被释放，把引用次数改为0；
        assert(!PageReserved(p) && !PageProperty(p));
        p->flags = 0;
        set_page_ref(p, 0);
    }
    base->property = n;//设置连续大小为n
    SetPageProperty(base);
    nr_free += n;//把空闲链表里的数量加n

    if (list_empty(&free_list)) {//如果空闲列表是空的，直接把base加入
        list_add(&free_list, &(base->page_link));
    } else {
        list_entry_t* le = &free_list;//空闲列表头
        while ((le = list_next(le)) != &free_list) {
            struct Page* page = le2page(le, page_link);//转换为页结构
            if (base < page) {//如果base小于该页，则加在base之前
                list_add_before(le, &(base->page_link));
                break;
            } else if (list_next(le) == &free_list) {
                list_add(le, &(base->page_link));//否则就加在后面
            }
        }
    }
//获取基地址的前一个页
    list_entry_t* le = list_prev(&(base->page_link));
    if (le != &free_list) {//如果不是空闲链表的头部
        p = le2page(le, page_link)//转化为页结构
        if (p + p->property == base) {//如果这个页是空闲的，那么合并，并把p作为基地址
            p->property += base->property;
            ClearPageProperty(base);//清除base的连续空间大小
            list_del(&(base->page_link));//从空闲链表里删除base
            base = p;//新的base
        }
    }
//获取base后一页
    le = list_next(&(base->page_link));
    if (le != &free_list) {
        p = le2page(le, page_link);
        if (base + base->property == p) {//如果base+base的连续的空闲大小等于当前页
            base->property += p->property;//把p合并到base
            ClearPageProperty(p);
            list_del(&(p->page_link));//删除p;
        }
    }
}
```

#### default_nr_free_pages

```
default_nr_free_pages(void) {
    return nr_free;
}
```

返回列表里的空闲页

#### default_check

检查分配后的物理页。

### 初始化物理页面布局

```c
/* pmm_init - initialize the physical memory management */
static void page_init(void) {
    extern char kern_entry[];

    va_pa_offset = KERNBASE - (uint32_t)kern_entry;

    uint32_t mem_begin = (uint32_t)kern_entry;//内核起始地址为kern_entry的地址为0x80400000
    uint32_t mem_end = (8 << 20) + DRAM_BASE; // 8MB memory on qemu，RISCV整个内存的起始地址为0x80000000，得到最大的物理地址  
    uint32_t mem_size = mem_end - mem_begin;
//整个内存大小
    cprintf("physcial memory map:\n");
    cprintf("  memory: 0x%08lx, [0x%08lx, 0x%08lx].\n", mem_size, mem_begin,
            mem_end - 1);
//输出内存信息
    uint64_t maxpa = mem_end;
//得到的最大物理内存与支持的最大内核内存相比较
    if (maxpa > KERNTOP) {
        maxpa = KERNTOP;
    }
//所以能够使用的最大物理地址是：maxpa=min{KERNTOP,mem_end}
    extern char end[];

    npage = maxpa / PGSIZE;//获取最大页数，从0x00000000开始
    // BBL has put the initial page table at the first available page after the
    // kernel
    // so stay away from it by adding extra offset to end
    //向上取整
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
//把所有的物理页面都设为被保留的，因为从0x80000000开始，所以减去nbase
    for (size_t i = 0; i < npage - nbase; i++) {
        SetPageReserved(pages + i);
    }
//除去kernel外，我们还需要一片内存来放内存管理信息，也就是需要管理的物理页面数*struct Page。之后的地址就是可用的地址了。pages是第一个物理页的struct Page的地址，而总共有(maxpage-DRAM_BASE)个物理页，所以freemem从这之后的内存开始。
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
//对齐需要管理的空闲地址
    mem_begin = ROUNDUP(freemem, PGSIZE);
    mem_end = ROUNDDOWN(mem_end, PGSIZE);
    //把参数传给初始化的pmm_manager来管理进行分配和释放等操作。
    if (freemem < mem_end) {
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
    }
}
```

在RISCV的起始地址0x80000000与内核起始地址0x80400000之间的内存用来存放参数，即`bootloader`运行后的获取的硬件软件等信息的结果存放在该地方，然后便于下一次启动时候读取，节省时间。

其中`KERBASE`等定义在`memlayout.h`中：

```c
#define KERNBASE            0x80400000
#define KMEMSIZE            0x38000000                  // the maximum amount of physical memory
//UCORE支持的最大物理内存
#define KERNTOP             (KERNBASE + KMEMSIZE)
```

用到的`ROUNDUP`取整函数在`kern/init/init.c`中定义

```c
/* *
 * Rounding operations (efficient when n is a power of 2)
 * Round down to the nearest multiple of n
 * */
#define ROUNDDOWN(a, n) ({                                          \
            size_t __a = (size_t)(a);                               \
            (typeof(a))(__a - __a % (n));                           \
        })

/* Round up to the nearest multiple of n */
#define ROUNDUP(a, n) ({                                            \
            size_t __n = (size_t)(n);                               \
            (typeof(a))(ROUNDDOWN((size_t)(a) + __n - 1, __n));     \
        })
```

`nbase`是RISC v起始地址所计算出的页，定义在`kern/mm/pmm.c`中

```c
const size_t nbase = DRAM_BASE / PGSIZE;
```

`PADDR`的宏定义在`kern/mm/pmm.h`中定义，把内核虚拟地址转化为物理地址。

```c
/* *
 * PADDR - takes a kernel virtual address (an address that points above
 * KERNBASE),
 * where the machine's maximum 256MB of physical memory is mapped and returns
 * the
 * corresponding physical address.  It panics if you pass it a non-kernel
 * virtual address.
 * */
#define PADDR(kva)                                                 \
    ({                                                             \
        uintptr_t __m_kva = (uintptr_t)(kva);                      \
        if (__m_kva < KERNBASE) {                                  \
            panic("PADDR called with invalid kva %08lx", __m_kva); \
        }                                                          \
        __m_kva - va_pa_offset;                                    \
    })
```

### 检查pmm中分配和释放函数的正确性

调用的是`pmm—>check`函数，实例化以后就调用的是`default_check`函数

### 初始化根页表

```c
// create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();//创建一个物理页
    memset(boot_pgdir, 0, PGSIZE);//清零
    boot_cr3 = PADDR(boot_pgdir);//获取根页表物理地址

    check_pgdir();//检查根页表的正确性

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);//判断对齐

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = pte_create(PPN(boot_cr3), PAGE_TABLE_DIR);
    boot_pgdir[PDX(VPT) + 1] = pte_create(PPN(boot_cr3), READ_WRITE);

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    // But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, PADDR(KERNBASE),
                     READ_WRITE_EXEC);
```

#### boot_alloc_page

`boot_alloc_page`函数定义在`kern/mm/pmm.c`中，功能是分配一个物理页

```c
// boot_alloc_page - allocate one page using pmm->alloc_pages(1)
// return value: the kernel virtual address of this allocated page
// note: this function is used to get the memory for PDT(Page Directory
// Table)&PT(Page Table)
static void *boot_alloc_page(void) {
    struct Page *p = alloc_page();
    if (p == NULL) {
        panic("boot_alloc_page failed.\n");
    }
    return page2kva(p);
}
```

然后一次往回查找，`pmm.h`中

```
#define alloc_page() alloc_pages(1)
```

返回到`pmm.c`中,调用`pmm->alloc_pages`来分配这一个页面，实例化后其实也就是调用`default_alloc_pages`。

```c
// alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE
// memory
struct Page *alloc_pages(size_t n) {
    struct Page *page = NULL;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        page = pmm_manager->alloc_pages(n);
    }
    local_intr_restore(intr_flag);
    return page;
}
```

然后就是初始化该页。获取根页表的物理地址，赋值给`boot_cr3`

检查根页表的正确性。

#### pte_create

PDX（VPT）项放的是一个指向它自己的指针，也就是实现自映射机制，可参考基于X86的ucore实验指导书的[自映射部分](https://chyyuu.gitbooks.io/ucore_os_docs/content/lab2/lab2_3_3_6_self_mapping.html)理解。

 `pte_create`是一个页表项初始化函数，它会将传入的PPN和之后的几个标志位组合成一个完整的32位页表项内容。 

 根页表首先会将自己填入相应的页表项，这样就在虚拟地址VPT上形成了一个虚拟页表。在VPT对应的页表项之后的一个根页表项` boot_pgdir[PDX(VPT) + 1] `还会插入一个相同的值，不同的是这个页被标记为可读可写的。 

####  boot_map_segment

```c
// boot_map_segment - setup&enable the paging mechanism
// parameters
//  la:   linear address of this memory need to map 
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory
static void boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size,
                             uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n--, la += PGSIZE, pa += PGSIZE) {
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pte_create(pa >> PGSHIFT, PTE_V | perm);
    }
}
```

该函数就是在建立与启用分页机制。 之后所有内核地址被映射在相应的物理地址上并被标记为可读可写的。此时相应的第二级页表也会被创建。 

### 启用页表模式

 因为在进入kernel的时候已经启动了虚拟内存模式，现在只需将`boot_cr3`也就是刚才初始化过根页表所在的地址写入satp，正式启用我们定义的这个虚拟内存管理模式。 

```c
static void enable_paging(void) {
    // set page table
    write_csr(satp, 0x80000000 | (boot_cr3 >> RISCV_PGSHIFT));
}
```

## 最终运行结果

![运行结果](https://github.com/KeLee5453/os_lab_ucore_riscv32/blob/master/picture/%E8%BF%90%E8%A1%8C%E7%BB%93%E6%9E%9C.jpg)

