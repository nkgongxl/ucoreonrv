# Lab3：虚拟内存管理初始化

## 实验内容

借助于页表机制和实验一中涉及的中断异常处理机制，完成 Page	Fault异常处理和FIFO页替换算法的实现，结合磁盘提供的缓存空间，从而能够支持虚存管理，提供一个比实际物理内存空间“更大”的虚拟内存空间给系统使用。

通过内存地址虚拟化，可以使得软件在没有访问某虚拟内存地址时不分配具体的物理内存， 而只有在实际访问某虚拟内存地址时，操作系统再动态地分配物理内存，建立虚拟内存到物 理内存的页映射关系，这种技术称为按需分页（demand	paging）。把不经常访问的数据所占 的内存空间临时写到硬盘上，这样可以腾出更多的空闲内存空间给经常访问的数据；当CPU 访问到不经常访问的数据时，再把这些数据从硬盘读入到内存中，这种技术称为页换入换出 （page　swap in/out）。这种内存管理技术给了程序员更大的内存“空间”，从而可以让更多 的程序在内存中并发运行

lab3中多了3个新函数：数`vmm_init`、`ide_init`和 `swap_init`：

- `vmm_init`：为了表述不在物理内存中的“合法”虚拟页，需要有数据结构来描述这样 的页，为此ucore建立了`mm_struct`和`vma_struct`数据结构（接下来的小节中有进一步详细描述），假定我们已经描述好了这样的“合法”虚拟页，当ucore访问这些“合法”虚拟页时，会由于没有虚实地址映射而产生页访问异常。则`do_pgfault`函数会申请 一个空闲物理页，并建立好虚实映射关系，从而使得这样的“合法”虚拟页有实际的物理页帧对应。
-  `ide_init`： 完成对用于页换入换出的硬盘（简称swap硬盘）的初始化工作。完成`ide_init`函 数后，ucore就可以对这个swap硬盘进行读写操作了 。
- `swap_init`：首先建立`swap_manager`，`swap_manager`是完成页面替换过程的主要功能模块，其中包含了页面置换 算法的实现，然后会进一步调用执行`check_swap`函数在内核中分 配一些页，模拟对这些页的访问，这会产生页访问异常。然后可通 过`do_pgfault`来调用`swap_map_swappable`函数来查询这些页的访问情况并间接调用实现页面 置换算法的相关函数，把“不常用”的页换出到磁盘上。

 但目前RISCV并没有提供能够支持外设的工具链，硬盘自然不再能够帮助我们实现页换入换出，硬盘初始化相关的函数也没有必要了。所以在本实验中为了实现一个这种页面切换的机制，我们只有在已有的物理内存上对这种方法进行一种模拟：创建了一个char数组假装它是一块有几个扇区的硬盘。这样一来对“硬盘”进行读写的操作就变得十分简单，原本需要等待io端口来进行传输等操作都不需要了，一个memcpy就能够实现虚拟页面在物理页面和“硬盘”之前的移动。 

## Page Fault

一般应用程序的对虚拟内存的“需 求”与物理内存空间的“供给”没有直接的对应关系，ucore是通过`page	fault`异常处理来间接完成 这二者之间的衔接。为此ucore通过建立`mm_struct`和`vma_struct`数据结构，描述 了ucore模拟应用程序运行所需的合法内存空间。当访问内存产生`page	fault`异常时，可获得访 问的内存的方式（读或写）以及具体的虚拟内存地址，这样ucore就可以查询此地址，看是否 属于`vma_struct`数据结构中描述的合法地址范围中，如果在，则可根据具体情况进行请求调 页/页换入换出处理；如果不在，则报错。

![虚拟地址空间和物理地址空间映射图](https://github.com/KeLee5453/os_lab_ucore_riscv32/blob/master/picture/虚拟地址空间和物理地址空间映射图.jpg)

### `vma_struct`

首先找到`vma_struct`，在`kern/mm/vmm.h`中定义：

```c
// the virtual continuous memory area(vma), [vm_start, vm_end), 
// addr belong to a vma means  vma.vm_start<= addr <vma.vm_end 
struct vma_struct {
    struct mm_struct *vm_mm; // the set of vma using the same PDT 
    uintptr_t vm_start;      // start addr of vma      
    uintptr_t vm_end;        // end addr of vma, not include the vm_end itself
    uint32_t vm_flags;       // flags of vma
    list_entry_t list_link;  // linear list link which sorted by start addr of vma
};
```

 `vma_struct`控制的是一片地址范围是`[vm_start,vm_end)`的连续内存，这两个地址的值都是PGSIZE的整数倍。这种变量会在整个操作系统运行中生成。`list_link`是一个双向链表，它会像上一个实验中`free_pages`的链表一样将一些`vma_struct`串在一起，而这个链表中所有的`vma_struct`都不会有重叠的地址。 

`vm_flags`有三个值，也就是权限设置：

```c
#define VM_READ                 0x00000001
#define VM_WRITE                0x00000002
#define VM_EXEC                 0x00000004
```

vm_mm是一个指针，指向一个比vma_struct更高的抽象层次的数据结构mm_struct，这里把 一个mm_struct结构的变量简称为mm变量。

### `mm_struct`

这个数据结构表示了包含所有虚拟内存空间的共 同属性，具体定义如下：

```c
// the control struct for a set of vma using the same PDT
struct mm_struct {
    list_entry_t mmap_list;        // linear list link which sorted by start addr of vma
    struct vma_struct *mmap_cache; // current accessed vma, used for speed purpose
    pde_t *pgdir;                  // the PDT of these vma
    int map_count;                 // the count of these vma
    void *sm_priv;                   // the private data for swap manager
};
```

`mmap_list`是双向链表头，链接了所有属于同一页目录表的虚拟内存空间

`mmap_cache`是指 向当前正在使用的虚拟内存空间，由于操作系统执行的“局部性”原理，当前正在用到的虚拟内 存空间在接下来的操作中可能还会用到，这时就不需要查链表，而是直接使用此指针就可找 到下一次要用到的虚拟内存空间。由于`mmap_cache`的引入，可使得`mm_struct`数据结构的 查询加速30%以上。在`find_vma`中赋值。

`pgdir`所指向的就是`mm_struct`数据结构所维护的页表。通过访问`pgdir`可以查找某虚拟地址对应的页表项是否存在以及页表项的属性。

`map_count`记录`mmap_list `里面链接的`vma_struct`的个数。

`sm_priv`指向用来链接记录页访问情况的链表头，这建立了 `mm_struct`和后续要讲到的`swap_manager`之间的联系。

### `do_pgfault`

 在缺页中断的时候硬件会自动触发同步异常，为相关的CSR写入需要的值，跳转置通用中断处理函数`trap.S`中。之后会根据`scause`中的编码将这个中断交由`pgfault_handler`函数处理。 在RISC-V中有一些寄存器来对应中断向量，`scause`中断异常编码试`mcause`的子集。

![](https://github.com/KeLee5453/os_lab_ucore_riscv32/blob/master/picture/lab1_2.png)

图中与地址访问相关的异常猜测都与其有关，RISC-V中有中断寄存器、机器和监管者自陷向量基地址寄存器与机器和监管者cause CSR一同来定位发生异常的原因和地点，来处理异常。

当异常发生时，函数调用顺序是`trap--> trap_dispatch-->pgfault_handler-->do_pgfault`，`do_pgfault`的代码如下：

```c
int do_pgfault(struct mm_struct *mm, uint32_t error_code, uintptr_t addr) {
    int ret = -E_INVAL;
    //try to find a vma which include addr
    struct vma_struct *vma = find_vma(mm, addr);
    pgfault_num++;
    //If the addr is in the range of a mm's vma?
    if (vma == NULL || vma->vm_start > addr) {
        cprintf("not valid addr %x, and  can not find it in vma\n", addr);
        goto failed;
    }
    
    /* IF (write an existed addr ) OR
     *    (write an non_existed addr && addr is writable) OR
     *    (read  an non_existed addr && addr is readable)
     * THEN
     *    continue process
     */
      uint32_t perm = PTE_U;
    if (vma->vm_flags & VM_WRITE) {
        perm |= (PTE_R | PTE_W);
    }
    addr = ROUNDDOWN(addr, PGSIZE);

    ret = -E_NO_MEM;
//获取该地址对应的页表，如果页表不在物理内存中，则分配一片物理内存。
    pte_t *ptep=NULL;
    ptep = get_pte(mm->pgdir, addr, 1);  //(1) try to find a pte, if pte's
                                         //PT(Page Table) isn't existed, then
                                         //create a PT.
    if (*ptep == 0) {
        if (pgdir_alloc_page(mm->pgdir, addr, perm) == NULL) {
            cprintf("pgdir_alloc_page in do_pgfault failed\n");
            goto failed;
        }
    } else {
        //物理页被切换到了硬盘
    if (swap_init_ok) {
            struct Page *page = NULL;
            swap_in(mm, addr, &page);  //(according to the mm AND addr, try
                                       //to load the content of right disk page
                                       //    into the memory which page managed.
        //假设已经通过前面的判断成功到达这一步的异常只有这一种可能，所以通过了swap_init_ok，我们就会将这个被访问到的页从硬盘上置换回来。之后利用page_insert重新为这个物理页面和虚拟页面之间建立连接。至此do_pgfault的工作就完成了。
            page_insert(mm->pgdir, page, addr, perm);  //(2) According to the mm,
                                                   //addr AND page, setup the
                                                   //map of phy addr <--->
                                                   //logical addr
            swap_map_swappable(mm, addr, page,1);  //(3) make the page swappable.
            page->pra_vaddr = addr;
        } else {
            cprintf("no swap_init_ok but ptep is %x, failed\n", *ptep);
            goto failed;
        }
   }

   ret = 0;
failed:
    return ret;
}
```



## 启动时候初始化

```c
ern_init(void) {
    extern char edata[], end[];
    memset(edata, 0, end - edata);

    cons_init();                // init the console

    const char *message = "(THU.CST) os is loading ...";
    cprintf("%s\n\n", message);

    print_kerninfo();

    // grade_backtrace();

    pmm_init();                 // init physical memory management

    pic_init();                 // init interrupt controller
    idt_init();                 // init interrupt descriptor table

    vmm_init();                 // init virtual memory management

    ide_init();                 // init ide devices
    swap_init();                // init swap

    clock_init();               // init clock interrupt
    intr_enable();              // enable irq interrupt

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
}
```

在之前的练习中已经分析了部分函数的运行机制。现在就分析新增加的函数。

### `vmm_init()`

此函数的定义在`kern/mm/vmm.c`中定义，该函数主要是初始化虚存管理，然后调用的是检查虚拟内存函数`check_vmm`，这个函数当然就是检查虚拟内存的正确性。

```c
// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void
vmm_init(void) {
    check_vmm();
}
```

`check_vmm` 的定义如下：

```c
// check_vmm - check correctness of vmm
static void
check_vmm(void) {
    size_t nr_free_pages_store = nr_free_pages();
    
    check_vma_struct();
    check_pgfault();

    assert(nr_free_pages_store == nr_free_pages());

    cprintf("check_vmm() succeeded.\n");
}
```

看其调用:

#### 获取空闲内存大小

首先把函数`nr_free_pages()`的返回值作为` nr_free_pages_store`定义在`kern/mm/vmm.c`中，他调用的是物理内存管理器的`nr_free_pages`函数来获取空闲的内存大小，以便控制映射的虚存的大小。

```c
// nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE)
// of current free memory
size_t nr_free_pages(void) {
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);//保护进程切换不会被中断，以免进程切换时其他进程再进行调度。
    {
        ret = pmm_manager->nr_free_pages();
    }
    local_intr_restore(intr_flag);
    return ret;
}
```

#### 检查虚拟连续内存区结构

```c
static void
check_vma_struct(void) {
    size_t nr_free_pages_store = nr_free_pages();//获取空闲内存大小。
    struct mm_struct *mm = mm_create();//分配一个mm_truct然后初始化。
    assert(mm != NULL);

    int step1 = 10, step2 = step1 * 10;

    int i;
    for (i = step1; i >= 1; i --) {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);//分配一个vma_struct结构，并初始化，地址范围为：i*5~i*5+2,权限为0；
        assert(vma != NULL);
        insert_vma_struct(mm, vma);//把创建的vm_struct结构插入到刚建立的mm_struct结构里面。用链表连接
    }

    for (i = step1 + 1; i <= step2; i ++) {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }
//对整个mm_struct链表进行检查
    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i ++) {
        assert(le != &(mm->mmap_list));
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
        struct vma_struct *vma1 = find_vma(mm, i);
        assert(vma1 != NULL);
        struct vma_struct *vma2 = find_vma(mm, i+1);
        assert(vma2 != NULL);
        struct vma_struct *vma3 = find_vma(mm, i+2);
        assert(vma3 == NULL);
        struct vma_struct *vma4 = find_vma(mm, i+3);
        assert(vma4 == NULL);
        struct vma_struct *vma5 = find_vma(mm, i+4);
        assert(vma5 == NULL);
//不能有重叠
        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
    }

    for (i =4; i>=0; i--) {
        struct vma_struct *vma_below_5= find_vma(mm,i);
        if (vma_below_5 != NULL ) {
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
        }
        assert(vma_below_5 == NULL);
    }
//释放指针
    mm_destroy(mm);

    assert(nr_free_pages_store == nr_free_pages());

    cprintf("check_vma_struct() succeeded!\n");
}
```

#### 检查异常处理程序

```c
// check_pgfault - check correctness of pgfault handler
static void
check_pgfault(void) {
    size_t nr_free_pages_store = nr_free_pages();
//创建一个mm_struct来检查。
    check_mm_struct = mm_create();
    assert(check_mm_struct != NULL);
    struct mm_struct *mm = check_mm_struct;
    //创建一个指针来指向虚拟地址的页目录地址
    pde_t *pgdir = mm->pgdir = boot_pgdir;
    assert(pgdir[0] == 0);
//创建一整个结构的vma_struct，PTSIZE=页面大小乘页表项大小2^24，返回应该试NULL
    struct vma_struct *vma = vma_create(0, PTSIZE, VM_WRITE);
    assert(vma != NULL);
//插入到mm_struct结构
    insert_vma_struct(mm, vma);
//再次确保这样的vma不存在
    uintptr_t addr = 0x100;
    assert(find_vma(mm, addr) == vma);

    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
        *(char *)(addr + i) = i;
        sum += i;
    }
    for (i = 0; i < 100; i ++) {
        sum -= *(char *)(addr + i);
    }
    assert(sum == 0);
//把创建的这个页删除
    page_remove(pgdir, ROUNDDOWN(addr, PGSIZE));
    free_page(pde2page(pgdir[0]));
    pgdir[0] = 0;
//销毁check_mm_struct
    mm->pgdir = NULL;
    mm_destroy(mm);
    check_mm_struct = NULL;

    assert(nr_free_pages_store == nr_free_pages());

    cprintf("check_pgfault() succeeded!\n");
}
```

调用关系如下图：

![Butterfly-do_pgfault](https://github.com/KeLee5453/os_lab_ucore_riscv32/blob/master/picture/Butterfly-do_pgfault.png)

### `swap_init()`

初始化函数在`kern/init/init.c`中定义，使用的页面替换算法是先进先出。

```c
int
swap_init(void)
{
     swapfs_init();

     // Since the IDE is faked, it can only store 7 pages at most to pass the test
     if (!(7 <= max_swap_offset &&
        max_swap_offset < MAX_SWAP_OFFSET_LIMIT)) {
        panic("bad max_swap_offset %08x.\n", max_swap_offset);
     }

     sm = &swap_manager_fifo;
     int r = sm->init();
     
     if (r == 0)
     {
          swap_init_ok = 1;
          cprintf("SWAP: manager = %s\n", sm->name);
          check_swap();
     }

     return r;
}

```

里面使用到了实例`swap_manager_fifo`，在`kern/mm/swap_fifo.c`中定义

```c
struct swap_manager swap_manager_fifo =
{
     .name            = "fifo swap manager",
     .init            = &_fifo_init,
     .init_mm         = &_fifo_init_mm,
     .tick_event      = &_fifo_tick_event,
     .map_swappable   = &_fifo_map_swappable,
     .set_unswappable = &_fifo_set_unswappable,
     .swap_out_victim = &_fifo_swap_out_victim,
     .check_swap      = &_fifo_check_swap,
};
```

进而，交换管理器里主要是为swap硬盘面向操作系统的各个接口函数。

```c
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

首先是对交换管理器的全局初始化，正常的话，`swap_init_ok`为1；

`map_swappable`用来记录页访问情况相关属性。根据FIFO PRA，我们应该在`pra_list_head`队列的后面链接最新到达页面

`swap_out_victim`用于挑选需要换出的页。也就是最早被访问的页，根据FIFO PRA，我们应该取消链接pra list_head队列前面的最早到达页面，然后将该页面的addr设置为ptr_page。

#### `swap_out`

`swap_out`调用`swap_out_victim`我们也就能够找到它对应的页表项的地址。接着系统会尝试将这个页面写入硬盘，如果成功则将这个页释放并加入`free_page`链表，如果不成功则会把这个页重新加入访问页表中。

```c
int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
     int i;
     for (i = 0; i != n; ++ i)
     {
          uintptr_t v;
          //struct Page **ptr_page=NULL;
          struct Page *page;
          // cprintf("i %d, SWAP: call swap_out_victim\n",i);
          int r = sm->swap_out_victim(mm, &page, in_tick);
          if (r != 0) {
                    cprintf("i %d, swap_out: call swap_out_victim failed\n",i);
                  break;
          }          
          //assert(!PageReserved(page));

          //cprintf("SWAP: choose victim page 0x%08x\n", page);
          
          v=page->pra_vaddr; 
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
          assert((*ptep & PTE_V) != 0);

          if (swapfs_write( (page->pra_vaddr/PGSIZE+1)<<8, page) != 0) {
                    cprintf("SWAP: failed to save\n");
                    sm->map_swappable(mm, v, page, 0);
                    continue;
          }
          else {
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
                    *ptep = (page->pra_vaddr/PGSIZE+1)<<8;
                    free_page(page);
          }
          
          tlb_invalidate(mm->pgdir, v);
     }
     return i;
}
```

#### `swap_in`

首先会为这个页分配内存。之后通过这个虚拟地址的pte找到它在swap硬盘中的位置，从而将这个页读取到虚拟地址对应的物理地址上。

```c
int
swap_in(struct mm_struct *mm, uintptr_t addr, struct Page **ptr_result)
{
     struct Page *result = alloc_page();
     assert(result!=NULL);

     pte_t *ptep = get_pte(mm->pgdir, addr, 0);
     // cprintf("SWAP: load ptep %x swap entry %d to vaddr 0x%08x, page %x, No %d\n", ptep, (*ptep)>>8, addr, result, (result-pages));
    
     int r;
     if ((r = swapfs_read((*ptep), result)) != 0)
     {
        assert(r!=0);
     }
     cprintf("swap_in: load disk swap entry %d with swap_page in vadr 0x%x\n", (*ptep)>>8, addr);
     *ptr_result=result;
     return 0;
}
```

## 运行结果

![结果1](https://github.com/KeLee5453/os_lab_ucore_riscv32/blob/master/picture/lab3运行结果.jpg)

![结果2](https://github.com/KeLee5453/os_lab_ucore_riscv32/blob/master/picture/lab3运行结果2.jpg)

