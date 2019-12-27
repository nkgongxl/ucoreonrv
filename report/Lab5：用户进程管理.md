# Lab5：用户进程管理

## 实验内容

实验四我们完成了内核线程的管理，但是这些线程只供操作系统自身运作，如果要在操作系统上添加应用程序，为了保证系统的安全，那就需要在用户态创建和执行进程。因为进程的执行空间扩展到了用户态空间，且出现了创建子进程执行应用程序，所以与内核进程不同的地方主要体现在进程管理与内存管理部分。

1. 内存管理：把部分物理内存映射为用户态虚拟内存；不同进程的虚拟内存空间不能相互直接访问；用户态空间与内核态空间之间的数据交换
2. 进程管理：建立进程的页表与维护进程可访问的空间；加载一个程序到进程控制块管理的内存中的方法；把父进程的内存空间拷贝到子进程内存空间；控制用户态进程生命周期。

## 应用程序的组成与编译

观察项目的目录就可以发现在结构上与Lab4不同的地方是增加了一个`user`文件夹，找到入口`user/libs/inicode.S`里面定义了所有应用程序的起始用户态执行地址`_start`然后调用了`umain`函数。`umian`函数是所有应用程序执行的第一个C函数，调用的是应用程序的`main`函数，结束后调用`exit`函数回收资源。在文件夹下的其他文件主要是为了保证能够实现基本的C程序的一些库和函数以及发出系统调用。

## 用户进程的虚拟地址空间

在用户与内核的链接文件中定义了入口虚拟地址：内核的为`0x80400000`，用户的为`0x800020`因此，用户进程的虚拟地址空间分为了两块，一块与内核线程一样，是所有用户进程都公用的虚拟地址空间，映射到相同的物理内存空间，另一块是用户虚拟地址空间，虽然虚拟地址的范围一致，但映射到不同且没有交集的物理内存空间中，确保进程间不会非法访问。

## 创建并执行用户进程

第一个用户进程是由实验四创建的第二个内核线程`initproc`通过把`hello`应用程序执行码覆盖到`initpro`的用户虚拟内存空间来创建的。

### `init_main`

因此首先是初始化`main`函数，`init_main`，位于`kern/process/proc.c`:

```c
// init_main - the second kernel thread used to create user_main kernel threads
static int
init_main(void *arg) {
    size_t nr_free_pages_store = nr_free_pages();//获取当前的空闲页的大小
    size_t kernel_allocated_store = kallocated();//进程块数量0；

    int pid = kernel_thread(user_main, NULL, 0);//用user_main创建一个新的进程
    if (pid <= 0) {
        panic("create user_main failed.\n");
    }

    while (do_wait(0, NULL) == 0) {
        schedule();
    }
    //检查进程的内存及关系
    cprintf("all user-mode processes have quit.\n");
    assert(initproc->cptr == NULL && initproc->yptr == NULL && initproc->optr == NULL);
    assert(nr_process == 2);
    assert(list_next(&proc_list) == &(initproc->list_link));
    assert(list_prev(&proc_list) == &(initproc->list_link));

    cprintf("init check memory pass.\n");
    return 0;
}
```

然后查看加载的`user_main`函数：

```c
// user_main - kernel thread used to exec a user program
static int
user_main(void *arg) {
#ifdef TEST
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
#else
    KERNEL_EXECVE(exit);
#endif
    panic("user_main execve failed.\n");
}

```

这个函数在缺省的情况下执行的是宏`KERNEL_EXECVE(exit)`，这个宏的定义最终是调用`kernel_execve`函数来发起`SYS_exec`的系统调用，

### `kernel_execve`

```c
// kernel_execve - do SYS_exec syscall to exec a user program called by user_main kernel_thread
static int
kernel_execve(const char *name, unsigned char *binary, size_t size) {
    uintptr_t len = strlen(name);

    register uintptr_t a0 asm ("a0") = (uintptr_t)(SYS_exec);
    register uintptr_t a1 asm ("a1") = (uintptr_t)(name);
    register uintptr_t a2 asm ("a2") = (uintptr_t)(len);
    register uintptr_t a3 asm ("a3") = (uintptr_t)(binary);
    register uintptr_t a4 asm ("a4") = (uintptr_t)(size);
    register uintptr_t a7 asm ("a7") = (uintptr_t)(20);
    asm volatile (
        "ecall"
        : "+r"(a0)
        : "r"(a1), "r"(a2), "r"(a3), "r"(a4), "r"(a7)
        : "memory"
    );

    return a0;
}

#define __KERNEL_EXECVE(name, binary, size) ({                          \
            cprintf("kernel_execve: pid = %d, name = \"%s\".\n",        \
                    current->pid, name);                                \
            kernel_execve(name, binary, (size_t)(size));                \
        })

#define KERNEL_EXECVE(x) ({                                             \
            extern unsigned char _binary_obj___user_##x##_out_start[],  \
                _binary_obj___user_##x##_out_size[];                    \
            __KERNEL_EXECVE(#x, _binary_obj___user_##x##_out_start,     \
                            _binary_obj___user_##x##_out_size);         \
        })

#define __KERNEL_EXECVE2(x, xstart, xsize) ({                           \
            extern unsigned char xstart[], xsize[];                     \
            __KERNEL_EXECVE(#x, xstart, (size_t)xsize);                 \
        })

#define KERNEL_EXECVE2(x, xstart, xsize) 
```

在链接`hello`程序时定义了两个全局变量：

```c
_binary_obj___user_hello_out_start//hello执行码的起始位置 
_binary_obj___user_hello_out_size中//hello执行码的大小
```

### `do_execve`

因此在调用`kernel_execve`函数时就把这两个变量作为参数传入，作为`SYS_exec`的参数，来创建改该用户进程，这里需要注意的是`SYS_exec`是一个宏定义，函数的 对应关系，在`kern/syscall/syscall.c`中定义，然后调用的是`sys_exec`函数，`sys_exec`调用的是`do_execve`函数其定义如下：

```c
// do_execve - call exit_mmap(mm)&put_pgdir(mm) to reclaim memory space of current process
//           - call load_icode to setup new memory space accroding binary prog.
int
do_execve(const char *name, size_t len, unsigned char *binary, size_t size) {
    struct mm_struct *mm = current->mm;
    //对参数进行查验与修正
    if (!user_mem_check(mm, (uintptr_t)name, len, 0)) {
        return -E_INVAL;
    }
    if (len > PROC_NAME_LEN) {
        len = PROC_NAME_LEN;
    }

    char local_name[PROC_NAME_LEN + 1];
    memset(local_name, 0, sizeof(local_name));
    memcpy(local_name, name, len);
//为加载新的执行码做好用户态内存空间清空准备
    if (mm != NULL) {
        lcr3(boot_cr3);
        if (mm_count_dec(mm) == 0) {
            exit_mmap(mm);
            put_pgdir(mm);
            mm_destroy(mm);
        }
        current->mm = NULL;
    }
    int ret;
    if ((ret = load_icode(binary, size)) != 0) {
        goto execve_exit;
    }
    set_proc_name(current, local_name);
    return 0;

execve_exit:
    do_exit(ret);
    panic("already exit: %e.\n", ret);
}
```

把`mm`指向`initproc`的内存空间管理结构，如果`mm`不为NULL，则设置页表为内核空间页表，然后判断`mm`的引用计数减一后是否为0，如果为0，则表示没有进程再需要此进程所占用的内存空间，就释放进程所占用的用户空间内存和进程页表所占用的空间，把`mm`内存管理指针置为NULL，由于此处的 `initproc`是内核线程，所以mm为NULL，整个处理都不会做。

### `load_icode`

然后开始加载应用程序的执行码到当前进程新创建的用户态虚拟空间中，调用的是`load_icode`函数来完成读ELF格式的文件，申请内存空间，建立用户态虚存空间，加载应用程序执行码等。工作。

```c
/* load_icode - load the content of binary program(ELF format) as the new content of current process
 * @binary:  the memory addr of the content of binary program
 * @size:  the size of the content of binary program
 */
static int
load_icode(unsigned char *binary, size_t size) {
    if (current->mm != NULL) {
        panic("load_icode: current->mm must be empty.\n");
    }

    int ret = -E_NO_MEM;
    struct mm_struct *mm;
    //(1) create a new mm for current process
    if ((mm = mm_create()) == NULL) {
        goto bad_mm;
    }
    //(2) create a new PDT, and mm->pgdir= kernel virtual addr of PDT
    if (setup_pgdir(mm) != 0) {
        goto bad_pgdir_cleanup_mm;
    }
    //(3) copy TEXT/DATA section, build BSS parts in binary to memory space of process
    struct Page *page;
    //(3.1) get the file header of the bianry program (ELF format)
    struct elfhdr *elf = (struct elfhdr *)binary;
    //(3.2) get the entry of the program section headers of the bianry program (ELF format)
    struct proghdr *ph = (struct proghdr *)(binary + elf->e_phoff);
    //(3.3) This program is valid?
    if (elf->e_magic != ELF_MAGIC) {
        ret = -E_INVAL_ELF;
        goto bad_elf_cleanup_pgdir;
    }

    uint32_t vm_flags, perm;
    struct proghdr *ph_end = ph + elf->e_phnum;
    for (; ph < ph_end; ph ++) {
    //(3.4) find every program section headers
        if (ph->p_type != ELF_PT_LOAD) {
            continue ;
        }
        if (ph->p_filesz > ph->p_memsz) {
            ret = -E_INVAL_ELF;
            goto bad_cleanup_mmap;
        }
        if (ph->p_filesz == 0) {
            // continue ;
        }
    //(3.5) call mm_map fun to setup the new vma ( ph->p_va, ph->p_memsz)
        vm_flags = 0, perm = PTE_U | PTE_V;
        if (ph->p_flags & ELF_PF_X) vm_flags |= VM_EXEC;
        if (ph->p_flags & ELF_PF_W) vm_flags |= VM_WRITE;
        if (ph->p_flags & ELF_PF_R) vm_flags |= VM_READ;
        // modify the perm bits here for RISC-V
        if (vm_flags & VM_READ) perm |= PTE_R;
        if (vm_flags & VM_WRITE) perm |= (PTE_W | PTE_R);
        if (vm_flags & VM_EXEC) perm |= PTE_X;
        if ((ret = mm_map(mm, ph->p_va, ph->p_memsz, vm_flags, NULL)) != 0) {
            goto bad_cleanup_mmap;
        }
        unsigned char *from = binary + ph->p_offset;
        size_t off, size;
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);

        ret = -E_NO_MEM;

     //(3.6) alloc memory, and  copy the contents of every program section (from, from+end) to process's memory (la, la+end)
        end = ph->p_va + ph->p_filesz;
     //(3.6.1) copy TEXT/DATA section of bianry program
        while (start < end) {
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL) {
                goto bad_cleanup_mmap;
            }
            off = start - la, size = PGSIZE - off, la += PGSIZE;
            if (end < la) {
                size -= la - end;
            }
            memcpy(page2kva(page) + off, from, size);
            start += size, from += size;
        }

      //(3.6.2) build BSS section of binary program
        end = ph->p_va + ph->p_memsz;
        if (start < la) {
            /* ph->p_memsz == ph->p_filesz */
            if (start == end) {
                continue ;
            }
            off = start + PGSIZE - la, size = PGSIZE - off;
            if (end < la) {
                size -= la - end;
            }
            memset(page2kva(page) + off, 0, size);
            start += size;
            assert((end < la && start == end) || (end >= la && start == la));
        }
        while (start < end) {
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL) {
                goto bad_cleanup_mmap;
            }
            off = start - la, size = PGSIZE - off, la += PGSIZE;
            if (end < la) {
                size -= la - end;
            }
            memset(page2kva(page) + off, 0, size);
            start += size;
        }
    }
    //(4) build user stack memory
    vm_flags = VM_READ | VM_WRITE | VM_STACK;
    if ((ret = mm_map(mm, USTACKTOP - USTACKSIZE, USTACKSIZE, vm_flags, NULL)) != 0) {
        goto bad_cleanup_mmap;
    }
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-PGSIZE , PTE_USER) != NULL);
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-2*PGSIZE , PTE_USER) != NULL);
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-3*PGSIZE , PTE_USER) != NULL);
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-4*PGSIZE , PTE_USER) != NULL);
    
    //(5) set current process's mm, sr3, and set CR3 reg = physical addr of Page Directory
    mm_count_inc(mm);
    current->mm = mm;
    current->cr3 = PADDR(mm->pgdir);
    lcr3(PADDR(mm->pgdir));

    //(6) setup trapframe for user environment
    struct trapframe *tf = current->tf;
    // Keep sstatus
    uintptr_t sstatus = tf->status;
    memset(tf, 0, sizeof(struct trapframe));
    tf->gpr.sp = USTACKTOP;
    tf->epc = elf->e_entry;
    tf->status = sstatus & ~(SSTATUS_SPP | SSTATUS_SPIE);

    ret = 0;
out:
    return ret;
bad_cleanup_mmap:
    exit_mmap(mm);
bad_elf_cleanup_pgdir:
    put_pgdir(mm);
bad_pgdir_cleanup_mm:
    mm_destroy(mm);
bad_mm:
    goto out;
}
```

1. 首先调用`mm_create`函数来申请进程的内存管理数据结构`mm`所需要的空间，并初始化。
2. 然后调用`setup_pgdir`来申请一个页目录表所需要的一个页大小的内存空间。并把内核虚拟空间映射的内核页表的内容拷贝到此目录表中，最后让`mm->pgdir`指向此页目录表，这就是进程新的页目录表，并且能够映射内核虚拟空间。
3. 然后对应用程序进行解析，调用`mm_map`函数根据解析的结果（包括代码段、数据段、BSS段的起始位置和大小）建立对应的`vma`结构，并把`vma`插入到`mm`结构中，从而表明了用户进程的合法用户态虚拟地址空间。调用根据执行程序各个段的大小分配物理内存空间，并根据执行程序各个段的起始位置 确定虚拟地址，并在页表中建立好物理地址和虚拟地址的映射关系，然后把执行程序各 个段的内容拷贝到相应的内核虚拟地址中，至此应用程序执行码和数据已经根据编译时 设定地址放置到虚拟内存中了。
4. 给用户进程设置用户栈，又调用`mm_map`函数建立用户栈的`vma`结构，确定用户栈的位置在用户虚拟空间的顶部，大小为256个页，1MB，并分配一定数量的物理内存建立好映射关系。
5. `mm`的引用计数加一，把页目录表赋值到`cr3`寄存器中，就更新了用户进程的虚拟内存空间，并加载。此时的`initproc`已经被`hello`的代码和数据覆盖，成为了第一个用户进程。
6. 为用户环境设置中断帧，首先清空中断帧，然后重新设置，使得在执行中断以后，可以让CPU转到用户态特权级，并回到用户态内存空间，使用用户态的代码段、数据段和堆栈，且能够跳转到用户进程的第一条指令执行，并确保在用户态能够响应中断；因为RISCV中的中断寄存器有差别，`gpr.sp`保存的是用户栈顶，`epc`保存的是发生中断时的入口地址，`status`保存的是中断前的状态，`SPP`是权限模式，`SPIE`是之前的`SIE`值。
7. 此时用户进程的用户环境已经搭建完毕，此时`initproc`将按产生系统调用的函数调用路径原路返回，执行中断返回指令后，将切换为用户进程`hello`的第一条语句位置`_start`处开始执行。

## 进程退出和等待进程

在进程执行完工作后，需要退出，释放资源，正我们在`do_execve`函数末尾看到的一样，退出进程是调用`do_exit`函数来实现的。

```c
execve_exit:
    do_exit(ret);
    panic("already exit: %e.\n", ret);
```

### `do_exit`

```c
// do_exit - called by sys_exit
//   1. call exit_mmap & put_pgdir & mm_destroy to free the almost all memory space of process
//   2. set process' state as PROC_ZOMBIE, then call wakeup_proc(parent) to ask parent reclaim itself.
//   3. call scheduler to switch to other process
int
do_exit(int error_code) {
    if (current == idleproc) {
        panic("idleproc exit.\n");
    }
    if (current == initproc) {
        panic("initproc exit.\n");
    }
    struct mm_struct *mm = current->mm;
    if (mm != NULL) {
        lcr3(boot_cr3);
        if (mm_count_dec(mm) == 0) {
            exit_mmap(mm);
            put_pgdir(mm);
            mm_destroy(mm);
        }
        current->mm = NULL;
    }
    current->state = PROC_ZOMBIE;
    current->exit_code = error_code;
    bool intr_flag;
    struct proc_struct *proc;
    local_intr_save(intr_flag);
    {
        proc = current->parent;
        if (proc->wait_state == WT_CHILD) {
            wakeup_proc(proc);
        }
        while (current->cptr != NULL) {
            proc = current->cptr;
            current->cptr = proc->optr;
    
            proc->yptr = NULL;
            if ((proc->optr = initproc->cptr) != NULL) {
                initproc->cptr->yptr = proc;
            }
            proc->parent = initproc;
            initproc->cptr = proc;
            if (proc->state == PROC_ZOMBIE) {
                if (initproc->wait_state == WT_CHILD) {
                    wakeup_proc(initproc);
                }
            }
        }
    }
    local_intr_restore(intr_flag);
    schedule();
    panic("do_exit will not return!! %d.\n", current->pid);
}

```

1. 如果是内核线程则不需要回收空间
2. 如果是用户进程，就开始回收，首先执行` lcr3(boot_cr3);`切换到内核的页表上，这样用户进程就只能在内核的虚拟地址空间上执行，因为内核权限高。如果当前进程的被调用数减一后等于0，那么就没有其他进程在使用了，就可以进行回收，先回收内存资源，调用`exit_mmap`函数释放`mm`中的`vma`描述的进程合法空间中实际分配的内存，然后把对应的页表项内容清空，最后把页表项和页目录表清空。然后调用`put_pgdir`函数释放页目录表所占用的内存。最后调用`mm_destroy`释放`vma`与`mm`的内存。把`mm`置为NULL，表示与当前进程相关的用户虚拟内存空间和对应的内存管 理成员变量所占的内核虚拟内存空间已经回收完毕；
3. 设置进程的状态为`PROC_ZOMBIE`表示该进程要死了，等待父进程来回收资源，回收内核栈和进程控制块。当前进程的退出码为`error_code`表示该进程已经不能被调度。
4. 