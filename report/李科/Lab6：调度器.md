# Lab6：调度器

## 实验内容

实验5我们实现了用户进程的管理，已经可以在用户态运行多个进程，但是目前进程调度的策略还是最简单的FIFO策略，最简单不一定最不好，但是性能及用户体验来说，有更好的调度算法，对于实验6来说，主要熟悉`时间片轮转算法(RR, Round-Robin)` 以及`Stride Scheduling`调度算法，下面对这两个算法进行简单的介绍：

1. `RR`：让所有处于可执行态的进程分时轮流使用CPU时间，调度器维护着一个有序队列，当进程的时间片用完就把进程加入队列尾部，按照FCFS原则接着运行下一个进程。
2. `Stride Scheduling`：在`RR`算法的基础上对每个处于可执行态的进程设置一个当前状态`stride`，表示该进程当前的调度权。另外定义其对应的`pass`值，表示对应进程在调度后，`stride`需要进行的累加值。每次需要调度时，从当前处于可执行态的的进程中选择`stride`最小的进程调度。对于获得调度的进程，将对应的`stride`加上其对应的步长`pass`（只与进程的优先权有关系）。在一段固定的时间之后，重新调度当前`stride`最小的进程。 

## 进程调度初始化

在`kern/init/init.c`中的`kern_init`函数中增加了一个`sched_init`函数来初始化调度器，该函数在`schedule/sched.c`中定义：

```c
void
sched_init(void) {
    list_init(&timer_list);
	//初始化一个timer链表
    sched_class = &default_sched_class;
	//绑定将要使用的调度器
    rq = &__rq;//可运行队列
    rq->max_time_slice = MAX_TIME_SLICE;//时间片十折为系统设置的最大时间片为5
    sched_class->init(rq);//

    cprintf("sched class: %s\n", sched_class->name);
}
```

### `sched_class`

该结构为调度类，在`schedule/sched.h`中定义，主要室调度器的接口，即所有的调度器都属于这个结构，主要的成员有：名字、可执行队列、把进程放入可执行队列的方法、取出进程的方法、选择下一个进程的方法、`timetick`处理函数。

```c
struct sched_class {
    // the name of sched_class
    const char *name;
    // Init the run queue
    void (*init)(struct run_queue *rq);
    // put the proc into runqueue, and this function must be called with rq_lock
    void (*enqueue)(struct run_queue *rq, struct proc_struct *proc);
    // get the proc out runqueue, and this function must be called with rq_lock
    void (*dequeue)(struct run_queue *rq, struct proc_struct *proc);
    // choose the next runnable task
    struct proc_struct *(*pick_next)(struct run_queue *rq);
    // dealer of the time-tick
    void (*proc_tick)(struct run_queue *rq, struct proc_struct *proc);
};
```

#### `run_queque`

该结构为可执行的进程队列，在`schedule/sched.h`中定义，里面存储的室当前可以调度的进程，因此只有状态为`runnable`的进程才能进入该队列，成员有：一个链表、链表中总的进程数、每个进程一轮占用的最多时间片、优先队列的形式的进程容器，只在该lab中使用，在使用优先队列的实现中表示当前优先队列的头元素，如果优先队列为空，则其指向空指针（NULL）。

```c
struct run_queue {
    list_entry_t run_list;
    unsigned int proc_num;
    int max_time_slice;
    // For LAB6 ONLY
    skew_heap_entry_t *lab6_run_pool;
};
```

#### `skew_heap`

这个结构是一个优先队列的实现，其在`libs/skew_heap.h`中定义

```c
static inline void skew_heap_init(skew_heap_entry_t *a) __attribute__((always_inline));
static inline skew_heap_entry_t *skew_heap_insert(
     skew_heap_entry_t *a, skew_heap_entry_t *b,
     compare_f comp) __attribute__((always_inline));
static inline skew_heap_entry_t *skew_heap_remove(
     skew_heap_entry_t *a, skew_heap_entry_t *b,
     compare_f comp) __attribute__((always_inline));

```

主要包括这几个方法，初始化一个队列节点，把节点b插入到以节点a为开头的队列中去，返回插入后的队列。把节点b从以节点a开头的队列中删除，返回删除后的队列。其中优先队列的顺序是由比较函数`comp`决定的，`sched_stride.c`中提供了`proc_stride_comp_f`比较器用来比较两个stride的大小。

#### `pro_struct`

该结构在lab4中有部分描述，在这里仅对增加的部分进行描述。首先是一个返回给父进程的退出码，然后是描述等待状态，接着是进程间的关系有孩子进程兄弟进程，包含进程的`rq`及入口，该进程剩余的时间片，只对该进程有效，然后是实现`stride `算法用到的变量。

```c
   int exit_code;                              // exit code (be sent to parent proc)
    uint32_t wait_state;                        // waiting state
    struct proc_struct *cptr, *yptr, *optr;     // relations between processes
    struct run_queue *rq;                       // running queue contains Process
    list_entry_t run_link;                      // the entry linked in run queue
    int time_slice;                             // time slice for occupying the CPU
    skew_heap_entry_t lab6_run_pool;            // FOR LAB6 ONLY: the entry in the run pool，表示当前进程对应的优先队列节点
    uint32_t lab6_stride;                       // FOR LAB6 ONLY: the current stride of the process 
    uint32_t lab6_priority;  
```

#### 方法

```c
static inline void
sched_class_enqueue(struct proc_struct *proc) {
    if (proc != idleproc) {
        sched_class->enqueue(rq, proc);
    }
}

static inline void
sched_class_dequeue(struct proc_struct *proc) {
    sched_class->dequeue(rq, proc);
}

static inline struct proc_struct *
sched_class_pick_next(void) {
    return sched_class->pick_next(rq);
}

static void
sched_class_proc_tick(struct proc_struct *proc) {
    if (proc != idleproc) {
        sched_class->proc_tick(rq, proc);
    }
    else {
        proc->need_resched = 1;
    }
}

static struct run_queue __rq;
```

这四个方法通过封装来做为接口，当需要调用比如加入队列的函数时，不用管具体的进程调度器是什么，直接调用`sched_class_enqueue`就可以了。因为在`default_sched_stride.c`中已经绑定了调度器：

```c
struct sched_class default_sched_class = {
     .name = "stride_scheduler",
     .init = stride_init,
     .enqueue = stride_enqueue,
     .dequeue = stride_dequeue,
     .pick_next = stride_pick_next,
     .proc_tick = stride_proc_tick,
};

```

方法具体的实现在调度器的实现中，也就是`default_sched_stride.c`中。这样封装为接口的思路非常重要，尤其是在以后合作完成项目的时候。

## 调度器

因为`Stride`调度器是在`RR`调度器的基础上增加的内容，因此这里只讨论`stride`调度器的实现，调度器的实现在`default_sched_stride.c`中。

### `stride_init`

在接口处，也就是进程调度初始化的时候的入口通常都是`init`函数，所以首先分析这个函数。

```c
static void
stride_init(struct run_queue *rq) {
     /* LAB6: YOUR CODE 
      * (1) init the ready process list: rq->run_list
      * (2) init the run pool: rq->lab6_run_pool
      * (3) set number of process: rq->proc_num to 0       
      */
    list_init(&(rq->run_list));
    rq->lab6_run_pool = NULL;
    rq->proc_num = 0;

```

一开始就是初始化，初始化的含义当然就是把原来就不应该有的东西置为空，那么就把`rq`里的链表置为空，运行容器置空，链表里的进程数置为0。

### `stride_enqueue`

```c
static void
stride_enqueue(struct run_queue *rq, struct proc_struct *proc) {
     /* LAB6: YOUR CODE 
      * (1) insert the proc into rq correctly
      * NOTICE: you can use skew_heap or list. Important functions
      *         skew_heap_insert: insert a entry into skew_heap
      *         list_add_before: insert  a entry into the last of list   
      * (2) recalculate proc->time_slice
      * (3) set proc->rq pointer to rq
      * (4) increase rq->proc_num
      */
    rq->lab6_run_pool = skew_heap_insert(rq->lab6_run_pool, &(proc->lab6_run_pool), proc_stride_comp_f);

    if (proc->time_slice == 0 || proc->time_slice > rq->max_time_slice) {
        proc->time_slice = rq->max_time_slice;
    }

    proc->rq = rq;
    rq->proc_num++;
}
```

该方法是把一个进程加入调度器中，由前面的`skew_heap`的介绍，这段代码就很容易看懂了，第二节是把进程的时间片初始化为`rq`的时间片也就是5。把`rq`的进程数加一，然后修改进程里的`rq`指针为现在的`rq`。

### `stride_dequeque`

```c
static void
stride_dequeue(struct run_queue *rq, struct proc_struct *proc) {
     /* LAB6: YOUR CODE 
      * (1) remove the proc from rq correctly
      * NOTICE: you can use skew_heap or list. Important functions
      *         skew_heap_remove: remove a entry from skew_heap
      *         list_del_init: remove a entry from the  list
      */
    assert(proc->rq == rq && rq->proc_num > 0);
    rq->lab6_run_pool = skew_heap_remove(rq->lab6_run_pool, &(proc->lab6_run_pool), proc_stride_comp_f);
    rq->proc_num--;
}
```

该方法是把一个进程从调度器里删除，代码很简单，只是注意在开始需要判定`rq`的状态。

### `stride_pick_next`

```c
static struct proc_struct *
stride_pick_next(struct run_queue *rq) {
     /* LAB6: YOUR CODE 
      * (1) get a  proc_struct pointer p  with the minimum value of stride
             (1.1) If using skew_heap, we can use le2proc get the p from rq->lab6_run_poll
             (1.2) If using list, we have to search list to find the p with minimum stride value
      * (2) update p;s stride value: p->lab6_stride
      * (3) return p
      */
    if (rq->lab6_run_pool == NULL) {
        return NULL;
    }
    struct proc_struct* proc = le2proc(rq->lab6_run_pool, lab6_run_pool);
    proc->lab6_stride += proc->lab6_priority ? BIG_STRIDE / proc->lab6_priority : BIG_STRIDE;
    return proc;
}
```

该方法是从优先队列里面选择优先级最高的进程，也就是选择`stride`最小的进程，在选出来后更新其值，即`pass=BIG_STRIDE/P->priority;	P->stride+=pass`，而`BIG_STRIDE`是32位无符号整数取`1 << 30`。

### `stride_proc_tick`

```c
static void
stride_proc_tick(struct run_queue *rq, struct proc_struct *proc) {
     /* LAB6: YOUR CODE */
    if (proc->time_slice > 0) {
        proc->time_slice--;
    }
    if (proc->time_slice == 0) {
        proc->need_resched = 1;
    }
}
```

该方法是进程在运行的时候时间片的消耗，当进程还有时间片时则-1，减为0后就把`need_resched`标识为1，这样在下一次中断来后执行trap函数时，会由于当前进程程成员变量`need_resched`标识为1而执行`schedule`函数，从而把当前执行进程放到优先队列后面。

## 结尾

```c
void
schedule(void) {
    bool intr_flag;
    struct proc_struct *next;
    local_intr_save(intr_flag);
    {
        current->need_resched = 0;
        if (current->state == PROC_RUNNABLE) {
            sched_class_enqueue(current);
        }
        if ((next = sched_class_pick_next()) != NULL) {
            sched_class_dequeue(next);
        }
        if (next == NULL) {
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

最后进程的调度就是通过`schedule`函数进行调度，调度的过程就是，如果当前状态为可执行，就把加入调度器的`rq`里面，找到下一个执行的进程，如果找不到则一直运行`idle`进程，如果找到了且不是当前进程，则运行找到的进程。

## 实验结果