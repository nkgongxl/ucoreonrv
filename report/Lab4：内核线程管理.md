# Lab4 内核线程的管理

## 实验内容

实验2、3完成了物理内存和虚拟内存的管理，在此基础上就可以创建内核线程，内核线程是一种特殊的进程。当一个程序加载到内存中运行时，首先通过操作系统的内存管理分配合适的内存供他运行。当多个程序同时运行时，它们不仅共享一块内存，还共享一个CPU轮流使用，因此要让每个程序感到它们各自拥有自己的CPU。

内核线程与用户进程有区别：

1. 内核线程只运行在内核态
2. 用户进程会在用户态和内核态之间交替运行
3. 所有的内核线程共用内核空间，不需要为每个内核线程维护单独的内存空间，并且这片内存仅内核模式及以上特权级可以访问。而用户进程的内存不共享，且在用户模式以及其他特权级别都可以访问。

## 内核线程的创建

在内核初始化函数里面新增加了一个`proc_init()`函数，这个函数的定义在`kern/process/proc.c`中定义，其主要作用就是首先自己创建一个一个`idle`进程然后创建第二个进程`init_main`。

```c
void
proc_init(void) {
    int i;

    list_init(&proc_list);//初始化进程链表
    for (i = 0; i < HASH_LIST_SIZE; i ++) {
        list_init(hash_list + i);
    }//初始化哈希表

    if ((idleproc = alloc_proc()) == NULL) {
        panic("cannot alloc idleproc.\n");
    }

    idleproc->pid = 0;
    idleproc->state = PROC_RUNNABLE;
    idleproc->kstack = (uintptr_t)bootstack;
    idleproc->need_resched = 1;
    set_proc_name(idleproc, "idle");
    nr_process ++;

    current = idleproc;

    int pid = kernel_thread(init_main, "Hello world!!", 0);
    if (pid <= 0) {
        panic("create init_main failed.\n");
    }

    initproc = find_proc(pid);
    set_proc_name(initproc, "init");

    assert(idleproc != NULL && idleproc->pid == 0);
    assert(initproc != NULL && initproc->pid == 1);
}
```

## 线程相关的结构体

```c
struct proc_struct {
    enum proc_state state;                      // Process state
    int pid;                                    // Process ID
    int runs;                                   // the running times of Proces
    uintptr_t kstack;                           // Process kernel stack内核进程栈
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

### `proc_state`

在线程的生存周期里，表示线程的状态的枚举类型

```c
// process's state in his life cycle
enum proc_state {
    PROC_UNINIT = 0,  // uninitialized
    PROC_SLEEPING,    // sleeping
    PROC_RUNNABLE,    // runnable(maybe running)
    PROC_ZOMBIE,      // almost dead, and wait parent proc to reclaim his resource
};
```

枚举值对应的含义为：

1. 0->线程被创建，但未初始化
2. 1->为挂起状态，CPU未进行处理
3. 2->可以开始运行，已经开始或者即将开始
4. 3->快死的进程，等待父进程回收资源

### `parent`

`parent`是一个同类型的指针，指向是创建该进/线程的父进程。因为第一个创建的进程`idleproc`是内恶化启动开始第一个被创建的，所以他是惟一一个没有父进程的进程。内核可以根据父子关系创建一个树形结构，用于维 护一些特殊的操作，例如确定某个进程是否可以对另外一个进程进行某种操作等等。

### `mm`

进程的内存管理信息，饱过内存映射列表、页表指针等。这个结构主要是为了`swap`机制存在的，而内核线程不需要考虑换页的问题，因此把之设置为空。但`mm_struct`结构中掌握了一个进程的根页表，因此创建了一个变量`cr3`来记录根页表。

### `context`

进程的上下文，是一个进程里需要保存的寄存器，用于进程的切换，切换的函数在`switch.S`中定义的`switch_to`。

### `tf`

中断帧的指针，指向内核栈的某个位置：当进程从用户空间跳到内核空间时，中断帧记录了进程在被中断前的状态。当内核需要跳回用户空间时，需要调整中断帧以恢复让进程继续执行的各寄存器值。

### `list_link`

会链接到全局链表`proc_list`，该链表会把所有的`pro_struct`连在一起的双向链表。

### `hash_link`

根据`pid`会加入全局哈希表`hash_list`，该链表是所有进程控制块的哈希表。

## 创建`idleproc`

调用`alloc_proc`函数来通过`kmolloc`获得`pro_struct`结构的一块内存块`proc`。然后对其成员进行初始化

```c
// alloc_proc - alloc a proc_struct and init all fields of proc_struct
static struct proc_struct *
alloc_proc(void) {
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
    if (proc != NULL) {
        proc->state = PROC_UNINIT;
        proc->pid = -1;
        proc->runs = 0;
        proc->kstack = 0;
        proc->need_resched = 0;
        proc->parent = NULL;
        proc->mm = NULL;
        memset(&(proc->context), 0, sizeof(struct context));
        proc->tf = NULL;
        proc->cr3 = boot_cr3;
        proc->flags = 0;
        memset(proc->name, 0, PROC_NAME_LEN);
    }
    return proc;
}
```

设为未初始化状态，未初始化时，把`pid`设为无效的-1，然后因为是内核线程，那么PDT就是内核的目录表，所以把`cr3`设置为`boot_cr3`，然后其他成员全部设为0或者NULL，以及对数组进行初始化。

## 初始化`idleproc`

返回到`proc_init`函数，在创建之后再对其进行初始化操作。`pid`设置为0，表明是第0个内核线程，也是它的身份证。然后改变进程的状态为可运行状态，在等待被加载。接着设置了内核栈的起始地址`bootstack`在`kern/mm/pmm.h`中声明的。

```c
	idleproc->pid = 0;
    idleproc->state = PROC_RUNNABLE;
    idleproc->kstack = (uintptr_t)bootstack;
    idleproc->need_resched = 1;
    set_proc_name(idleproc, "idle");
    nr_process ++;

    current = idleproc;

```

因为uCore希望当前CPU应该做更有用的工作，而不是运行`idleproc`这个“无所事 事”的内核线程，所以把`idleproc->need_resched`设置为“1”，结合`idleproc`的执行主体`cpu_idle`函数的实现，可以清楚看出如果当前`idleproc`在执行，则只要此标志为1，马上就调用 `schedule`函数要求调度器切换其他进程执行。然后给他名字叫"idle"，目前的进程数加一，当前的进程指针指向`idle`。第0个内核线程主要工作是完成内核中各个子系统的初始化，然后就通过执行`cpu_idle`函数开 始过退休生活了。

```c
// cpu_idle - at the end of kern_init, the first kernel thread idleproc will do below works
void
cpu_idle(void) {
    while (1) {
        if (current->need_resched) {
            schedule();
        }
    }
}
```

## 创建第二个进程`init_main`

```c
	int pid = kernel_thread(init_main, "Hello world!!", 0);
    if (pid <= 0) {
        panic("create init_main failed.\n");
    }
```

### `kernel_thread`

通过`kernel_thread`函数来创建：

```c
int
kernel_thread(int (*fn)(void *), void *arg, uint32_t clone_flags) {
    struct trapframe tf;
    memset(&tf, 0, sizeof(struct trapframe));

    tf.gpr.s0 = (uintptr_t)fn;
    tf.gpr.s1 = (uintptr_t)arg;
    tf.status = (read_csr(sstatus) | SSTATUS_SPP | SSTATUS_SPIE) & ~SSTATUS_SIE;
    tf.epc = (uintptr_t)kernel_thread_entry;
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
}
```

第一个参数是一个指向该进程要运行的函数的指针，第二个参数是指向该函数的参数列表指针，第三个参数是设置这个新创建的进程是否与父进程共用一篇内存还是赋值一份完全一样的内存，当其值为0则会复制一片内存，为1 则共享内存。采用了一个局部变量`tf`来保存内核线程的中断帧并清零初始化，函数指针和参数指针放入s0、s1寄存器。发生中断的指令的 PC 被存入 `epc` ，把 `status CSR `中的 SIE 置零，屏蔽中断，且 `SIE `之前的值被保存在` SPIE `中。 发生例外时的权限模式被保存在 `SPP` 域，然后设置当前模式为 S 模 式。设置好后调用`do_fork`函数来为父线程创建子线程。

### `do_fork`

```c
int
do_fork(uint32_t clone_flags, uintptr_t stack, struct trapframe *tf) {
    int ret = -E_NO_FREE_PROC;
    struct proc_struct *proc;
    if (nr_process >= MAX_PROCESS) {
        goto fork_out;
    }//检查进程数
    
    ret = -E_NO_MEM;
    if ((proc = alloc_proc()) == NULL) {
        goto fork_out;
    }
    if ((ret = setup_kstack(proc)) == -E_NO_MEM) {
        goto bad_fork_cleanup_proc;
    }
    copy_mm(clone_flags, proc);

    copy_thread(proc, stack, tf);

    const int pid = get_pid();
    proc->pid = pid;
    list_add(hash_list + pid_hashfn(pid), &(proc->hash_link));
    list_add(&proc_list, &(proc->list_link));
    nr_process++;

    wakeup_proc(proc);
    ret = pid;
fork_out:
    return ret;

bad_fork_cleanup_kstack:
    put_kstack(proc);
bad_fork_cleanup_proc:
    kfree(proc);
    goto fork_out;
}
```

1. 首先声明一个临时变量来表示内核的错误编码，` E_NO_FREE_PROC  `在`libs/error.h`中定义，表示不能创建一个新的进程。

2. 然后检查目前的进程数是否达到了最大值，如果达到了就不再创建，`ret`就记录着错误原因。

3. 接着把`ret`修改为`E_NO_MEM`表示没有足够的内存。然后分配并初始化一个进程控制块

4. 分配并初始化内核栈

5. 因为是内核线程所以`copy_mm`只是把`mm`设置为NULL。

6. `copy_thread`会在内核栈顶设置中断帧、内核入口和进程栈。

   ```c
   // copy_thread - setup the trapframe on the  process's kernel stack top and
   //             - setup the kernel entry point and stack of process
   static void
   copy_thread(struct proc_struct *proc, uintptr_t esp, struct trapframe *tf) {
       proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE - sizeof(struct trapframe));
       *(proc->tf) = *tf;
   
       // Set a0 to 0 so a child process knows it's just forked
       proc->tf->gpr.a0 = 0;
       proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
   
       proc->context.ra = (uintptr_t)forkret;
       proc->context.sp = (uintptr_t)(proc->tf);
   }
   ```

   函数首先在内核堆栈的顶部设置中断帧大小的一块栈空间，并在此空间中拷贝在父线程函数建立的临时中断帧的初始值，然年设置a0寄存器为0，因为a0寄存器保存的是函数返回值，设为0，就可以知道其是刚创建的子线程。然后子线程的栈会根据传进来的`esp`的值确定是使用传入的`esp`还是`tf`结构所在的栈。因为创建的是内核线程，父子线程使用的栈一样,`sp`也一样，都指向当前`tf`所在的首地址。目前的`context`是父线程的上下文，而`tf`是接下来要跳转到的子线程的上下文。父线程的返回值是`forkret`，这个函数在`trap.S`中定义；子线程的返回值是0，也就是说它不会再跳到`forkret`中再创建一个子进程。

7. 分配一个新的`pid`给新创建的线程

8. 把它加入两个表

9. 进程数+1

10. 唤醒该进程，返回`pid`

然后给该线程取名为“init”。进程的初始化结束

## 内核线程的调度和切换

在创建了线程之后，线程都是处于`runnable`状态，在初始换函数下面还有个函数来调度，`idleproc`通过该函数就可以让出CPU给其他线程执行。通过判断`need_resched`是否为1，如果为1就找其他线程来执行

```c
// cpu_idle - at the end of kern_init, the first kernel thread idleproc will do below works
void
cpu_idle(void) {
    while (1) {
        if (current->need_resched) {
            schedule();
        }
    }
}

```

### `schedule`

```c
void
schedule(void) {
    bool intr_flag;
    list_entry_t *le, *last;
    struct proc_struct *next = NULL;
    local_intr_save(intr_flag);
    {
        current->need_resched = 0;
        last = (current == idleproc) ? &proc_list : &(current->list_link);
        le = last;
        do {
            if ((le = list_next(le)) != &proc_list) {
                next = le2proc(le, list_link);
                if (next->state == PROC_RUNNABLE) {
                    break;
                }
            }
        } while (le != last);
        if (next == NULL || next->state != PROC_RUNNABLE) {
            next = idleproc;
        }
        next->runs ++;
        if (next != current) {
            proc_run(next);
        }
    }
    local_intr_restore(intr_flag);
}
```

1. 进程切换是一个原子操作，所以首先关闭中断

2. 然后设置当前的内核线程的`need_resched`为0

3. 然后在`proc_list`中查找下一个处于`runnable`状态的进程

4. 如果找到了就调用`proc_run`函数来运行下一个进程，保存当前进程的进程上下文，恢复新进程的进程上下文，完成进程切换。

   ```c
   // proc_run - make process "proc" running on cpu
   // NOTE: before call switch_to, should load  base addr of "proc"'s new PDT
   void
   proc_run(struct proc_struct *proc) {
       if (proc != current) {
           bool intr_flag;
           struct proc_struct *prev = current, *next = proc;
           local_intr_save(intr_flag);
           {
               current = proc;
               lcr3(next->cr3);
               switch_to(&(prev->context), &(next->context));
           }
           local_intr_restore(intr_flag);
       }
   }
   ```

   让`current`指向`next`；设置`lcr3`寄存器的值为`next`的页目录表的起始地址，即完成页表的切换；然后交换执行现场，即切换各个寄存器，再用`ret`返回到新进程了。

