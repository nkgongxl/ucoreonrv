# Lab7：同步互斥的设计与实现

## 实验内容

实验六完成了进程调度的方法与调度器，我们熟知当多个进程同时运行时，很有可能发生对同一资源的协同操作与访问。本次实验主要需要

1. 熟悉ucore进程同步机制，即信号量机制，以及基于信号量的经典问题，哲学家就餐问题的解决方案。
2. 利用管程的条件变量机制与基于条件变量来解决哲学家就餐问题。

## 等待队列

实验中还没有进程睡眠的机制，之前的调度器取进程都是在可执行态的链表里面取的，即`run_queue`。当进程为了等待某个事件时可以被转入等待状态不被调度器调度，当事件发生时，这些进程能够再次被唤醒，因此等待队列必须和每一个事件联系起来，当事件发生后，遍历该链表，唤醒进程，并加入可执行态链表，然后从等待队列中删除。

### 定义

等待队列的定义在`kern/sync/wait.h`中

```c
typedef struct {
    list_entry_t wait_head;
} wait_queue_t;//等待队列的头

struct proc_struct;//进程结构

typedef struct {
    struct proc_struct *proc;//等待进程的指针
    uint32_t wakeup_flags;//进入等待的原因/事件
    wait_queue_t *wait_queue;//指向该结构属于哪一队列
    list_entry_t wait_link;//组织队列中的节点的连接
} wait_t;
```

### 方法

等待队列的方法主要分为两层，底层是对等待队列本身的一些操作：

```c
void	wait_init(wait_t	*wait,	struct	proc_struct	*proc);//初始化wait结构 
bool	wait_in_queue(wait_t	*wait);//wait是否在wait	queue中 
void	wait_queue_init(wait_queue_t	*queue);//初始化wait_queue结构 
void	wait_queue_add(wait_queue_t	*queue,	wait_t	*wait);//把wait前插到wait	queue中 
void	wait_queue_del(wait_queue_t	*queue,	wait_t	*wait);//从wait	queue中删除wait 
wait_t	*wait_queue_next(wait_queue_t	*queue,	wait_t	*wait);//取得wait的后一个链接指针 
wait_t	*wait_queue_prev(wait_queue_t	*queue,	wait_t	*wait);//取得wait的前一个链接指针 
wait_t	*wait_queue_first(wait_queue_t	*queue);//取得wait	queue的第一个wait 
wait_t	*wait_queue_last(wait_queue_t	*queue);//取得wait	queue的最后一个wait
bool	wait_queue_empty(wait_queue_t	*queue);//wait	queue是否为空
```

高层函数主要针对的是进程，加入等待队列和唤醒进程

```c
void	wait_current_set(wait_queue_t	*queue,	wait_t	*wait,	uint32_t	wait_state);//让wait与进程关联，且让当前进程关联的wait进入等待队列queue，当前进程睡眠  
wait_current_del(queue,	wait);//把与当前进程关联的wait从等待队列queue中删除  
void	wakeup_wait(wait_queue_t	*queue,	wait_t	*wait,	uint32_t	wakeup_flags,	bool	del); //唤醒与wait关联的进程 
void	wakeup_first(wait_queue_t	*queue,	uint32_t	wakeup_flags,	bool	del); //唤醒等待队列上挂着的第一个wait所关联的进程 
void	wakeup_queue(wait_queue_t	*queue,	uint32_t	wakeup_flags,	bool	del);//唤醒等待队列上所有的等待的进程 
```

## 进程初始化

因为本次实验是进程相关的实验，所以在除了进程方面的实验代码与实验六的代码一致，因此实验的入口在`proc_init`。该函数的详解在实验四中有说明，该函数是初始化第一个内核线程，然后调用`init_main`来创建第二个，进而子子孙孙。在`init_main`函数里增加了`check_sync`的调用，这就是本次实验的总控函数，该函数的定义位于`kern/sync/check_sync.c`中

```c
void check_sync(void){

    int i;

    //check semaphore
    sem_init(&mutex, 1);
    for(i=0;i<N;i++){
        sem_init(&s[i], 0);
        int pid = kernel_thread(philosopher_using_semaphore, (void *)i, 0);
        if (pid <= 0) {
            panic("create No.%d philosopher_using_semaphore failed.\n");
        }
        philosopher_proc_sema[i] = find_proc(pid);
        set_proc_name(philosopher_proc_sema[i], "philosopher_sema_proc");
    }

    //check condition variable
    monitor_init(&mt, N);
    for(i=0;i<N;i++){
        state_condvar[i]=THINKING;
        int pid = kernel_thread(philosopher_using_condvar, (void *)i, 0);
        if (pid <= 0) {
            panic("create No.%d philosopher_using_condvar failed.\n");
        }
        philosopher_proc_condvar[i] = find_proc(pid);
        set_proc_name(philosopher_proc_condvar[i], "philosopher_condvar_proc");
    }
}
```

该函数分为两个部分，首先初始化了一个互斥信号量，然后创建了对应5个哲学家行为的5个信号量，然后创建了5个内核线程代表5个哲学家。每个内核线程完成了基于信号量的哲学家吃饭睡觉思考行为实现。第二部分首先初始化了管程，然后又创建了5个内核线程代表5个哲学家，线程行为同上。

## 信号量方法

调用的是`philosopher_using_semaphore`方法，让哲学家思考，然后计时器到了以后就想获得叉子，结果为获得或阻塞，之后便继续思考。

```c
int philosopher_using_semaphore(void * arg) /* i：哲学家号码，从0到N-1 */
{
    int i, iter=0;
    i=(int)arg;
    cprintf("I am No.%d philosopher_sema\n",i);
    while(iter++<TIMES)
    { /* 无限循环 */
        cprintf("Iter %d, No.%d philosopher_sema is thinking\n",iter,i); /* 哲学家正在思考 */
        do_sleep(SLEEP_TIME);
        phi_take_forks_sema(i); 
        /* 需要两只叉子，或者阻塞 */
        cprintf("Iter %d, No.%d philosopher_sema is eating\n",iter,i); /* 进餐 */
        do_sleep(SLEEP_TIME);
        phi_put_forks_sema(i); 
        /* 把两把叉子同时放回桌子 */
    }
    cprintf("No.%d philosopher_sema quit\n",i);
    return 0;    
}
```

### 信号量

信号量的原理描述如下

```c
struct	semaphore	{ 
    int	count; 
    queueType	queue; 
}; 
void	semWait(semaphore	s) { 
    s.count--; 
    if	(s.count	<	0)	{ 
        /*	place	this	process	in	s.queue	*/;
        /*	block	this	process	*/; 
    } 
} 
void	semSignal(semaphore	s) { 
    s.count++; 
    if	(s.count<=	0)	{ 
        /*	remove	a	process	P	from	s.queue	*/; 
        /*	place	process	P	on	ready	list	*/; 
    } 
}
```

当多个进程可以进行互斥或者同步合作时，一个进程会由于无法满足信号量设置的某条件而停止，直到收到一个特定的信号，该信号就用叫做“信号量”的变量来描述，为通过信号量s传送信号，信号量的V操作采用进程可执行原语`semSignal(s)`；为通过信号量s接收信号，信号量的P操作采用进程可执行原语`semWait(s)`；如果相应的信号仍然没有发送，则进程被阻塞或睡眠，直到发送完为止。

#### 定义

信号量在ucore的代码中在`kern/sync/sem.h`中定义

```c
typedef struct {
    int value;//信号量的值
    wait_queue_t wait_queue;//等待队列
} semaphore_t;
```

一个等待的进程会挂在此等待队列上。

#### 方法

与信号量相关的方法如下，对信号量初始化，P操作与V操作，尝试V操作。

```c
void sem_init(semaphore_t *sem, int value);
void up(semaphore_t *sem);
void down(semaphore_t *sem);
bool try_down(semaphore_t *sem);
```

具体的定义在`kern/sync/sem.c`中的`__up`与`__down`来实现。

```c
static __noinline uint32_t __down(semaphore_t *sem, uint32_t wait_state) {
    bool intr_flag;
    local_intr_save(intr_flag);
    if (sem->value > 0) {
        sem->value --;
        local_intr_restore(intr_flag);
        return 0;
    }
    wait_t __wait, *wait = &__wait;
    wait_current_set(&(sem->wait_queue), wait, wait_state);
    local_intr_restore(intr_flag);

    schedule();

    local_intr_save(intr_flag);
    wait_current_del(&(sem->wait_queue), wait);
    local_intr_restore(intr_flag);

    if (wait->wakeup_flags != wait_state) {
        return wait->wakeup_flags;
    }
    return 0;
}
```

该函数主要实现信号量操作的P操作，首先关掉中断，然后判断信号量的值是否大于0，

- 若大于，则可以获得信号量，令值减一，打开中断返回。
- 否则，表明不能获得信号量，则需要把进程放入等待队列中，并打开中断，通过调度器选择另一个进程执行，若被V操作唤醒，则把自身从等待队列删除，

```c
static __noinline void __up(semaphore_t *sem, uint32_t wait_state) {
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        wait_t *wait;
        if ((wait = wait_queue_first(&(sem->wait_queue))) == NULL) {
            sem->value ++;
        }
        else {
            assert(wait->proc->wait_state == wait_state);
            wakeup_wait(&(sem->wait_queue), wait, wait_state, 1);
        }
    }
    local_intr_restore(intr_flag);
}
```

该函数主要实现信号量的操作的V操作，首先关掉中断，然后看等待队列中是否有进程在等待，

- 若没有，则直接把信号量加一，然后打开中断返回。
- 若有，且等待原因是由`semophore`设置的，则调用`wakeup_wait`函数将第一个`wait`删除，并把关联的进程唤醒，打开中断。

### `do_sleep`

将当前进程状态设置为睡眠，并添加带有“时间”的计时器，然后调用调度程序。 如果进程再次运行，先删除计时器。

```c
int
do_sleep(unsigned int time) {
    if (time == 0) {
        return 0;
    }
    bool intr_flag;
    local_intr_save(intr_flag);//关闭中断
    timer_t __timer, *timer = timer_init(&__timer, current, time);
    current->state = PROC_SLEEPING;
    current->wait_state = WT_TIMER;//设置进程状态
    add_timer(timer);//增加定时器
    local_intr_restore(intr_flag);//打开中断

    schedule();//使用调度器调度进程

    del_timer(timer);//删除计时器
    return 0;
}
```

### 定时器

在ucore中，时钟中断给操作系统提供了又一定间隔的时间事件，操作系统将其作为基本的调度和计时单位。时钟的实现在`kern/schedule/sched.c`中。时钟对应的接口有：

1. `timer_t`：时钟的基本结构，`timer_init`函数对其进行初始化。
2. `timer_init`：对某定时器进行初始化，让它在时间片到达之后唤醒进程。
3. `add_timer`：向系统添加某个初始化过的`time_t`，定时器在指定时间后被激活，并把对应的进程唤醒到可执行态。
4. `del_timer`：取消某个定时器，该定时器将不会唤醒进程
5. `run_timer_list`：更新系统时间点，遍历在系统里的定时器，找到应该被激活的定时器然后激活。该过程只在每次定时器中断时被调用。还会调用调度器事件处理程序。

以上多数操作都是链表的操作，在此不做赘述

### `phi_take_forks_sema`

哲学家开始获取叉子，这里涉及信号量的操作了。

```c

void phi_take_forks_sema(int i) /* i：哲学家号码从0到N-1 */
{ 
        down(&mutex); /* 进入临界区 */
        state_sema[i]=HUNGRY; /* 记录下哲学家i饥饿的事实 */
        phi_test_sema(i); /* 试图得到两只叉子 */
        up(&mutex); /* 离开临界区 */
        down(&s[i]); /* 如果得不到叉子就阻塞 */
}

```

有几个变量声明如下

```c
int state_sema[N]; /* 记录每个人状态的数组 */
/* 信号量是一个特殊的整型变量 */
semaphore_t mutex; /* 临界区互斥 */
semaphore_t s[N]; /* 每个哲学家一个信号量 */
```

- 

### `phi_test_sema`

看一下左邻居和右邻居是否能进餐

```c
void phi_test_sema(int i) /* i：哲学家号码从0到N-1 */
{ 
    if(state_sema[i]==HUNGRY&&state_sema[LEFT]!=EATING
            &&state_sema[RIGHT]!=EATING)
    {
        state_sema[i]=EATING;
        up(&s[i]);
    }
}
```

### `phi_put_forks_sema`

哲学家放回叉子，并唤起邻居

```c
void phi_put_forks_sema(int i) /* i：哲学家号码从0到N-1 */
{ 
        down(&mutex); /* 进入临界区 */
        state_sema[i]=THINKING; /* 哲学家进餐结束 */
        phi_test_sema(LEFT); /* 看一下左邻居现在是否能进餐 */
        phi_test_sema(RIGHT); /* 看一下右邻居现在是否能进餐 */
        up(&mutex); /* 离开临界区 */
}
```

## 管程方法

对于哲学家来说，这两种方法没有什么区别，所以结构和信号量方法一致，只是调用的函数变化，为`phi_take_forks_condvar`。

```c
int philosopher_using_condvar(void * arg) { /* arg is the No. of philosopher 0~N-1*/
  
    int i, iter=0;
    i=(int)arg;
    cprintf("I am No.%d philosopher_condvar\n",i);
    while(iter++<TIMES)
    { /* iterate*/
        cprintf("Iter %d, No.%d philosopher_condvar is thinking\n",iter,i); /* thinking*/
        do_sleep(SLEEP_TIME);
        phi_take_forks_condvar(i); 
        /* need two forks, maybe blocked */
        cprintf("Iter %d, No.%d philosopher_condvar is eating\n",iter,i); /* eating*/
        do_sleep(SLEEP_TIME);
        phi_put_forks_condvar(i); 
        /* return two forks back*/
    }
    cprintf("No.%d philosopher_condvar quit\n",i);
    return 0;    
}
```

### 管程和条件变量

管程由四部分组成：管程内部的共享变量、管程内部的条件变量、管程内部并发执行的进程、对局部于管程内部的共享数据设置初始值的语句。管程相当于一个隔离区，所有进入管程要访问临界区资源时，必须经过管程才能进入，管程每次只允许一个进程进入。若采用忙等待的方式，则容易引发死锁，因此引入了条件变量`CV`。一个条件变量CV可理解为一个进程的等待队列，队列中的进程正等待某个条件Cond变为真。每个条件变量关联着一个条件，如果条件Cond不为真，则进程需要等待，如果条件Cond为真，则进程可以进一步在管程中执行。

#### 定义

在`kern/sync/monitor.h`中定义

```c
typedef struct condvar{//条件变量
    semaphore_t sem;        // the sem semaphore  is used to down the waiting proc, and the signaling proc should up the waiting proc
    int count;              // the number of waiters on condvar
    monitor_t * owner;      // the owner(monitor) of this condvar
} condvar_t;

typedef struct monitor{//管程结构
    semaphore_t mutex;      // the mutex lock for going into the routines in monitor, should be initialized to 1
    semaphore_t next;       // the next semaphore is used to down the signaling proc itself, and the other OR wakeuped waiting proc should wake up the sleeped signaling proc.
    int next_count;         // the number of of sleeped signaling proc
    condvar_t *cv;          // the condvars in monitor
} monitor_t;
```

#### 方法

需要注意当一个进程等待一个条件变量CV（即等待Cond为真），该进程需要退出管程，这样才能让其它进程可以进入该管程执行，并进行相关操作，比如设置条件Cond为真，改变条件变量的状态，并唤醒等待在此条件变量CV上的进程。因此对条件 变量CV有两种主要操作：

```c
// Initialize variables in monitor.
void     monitor_init (monitor_t *cvp, size_t num_cv);
// Unlock one of threads waiting on the condition variable. 
void     cond_signal (condvar_t *cvp);
// Suspend calling thread on a condition variable waiting for condition atomically unlock mutex in monitor,
// and suspends calling thread on conditional variable after waking up locks mutex.
void     cond_wait (condvar_t *cvp);
```

`cond_wait`：被一个进程调用，以等待断言Pc被满足后该进程可恢复执行.进程挂在该条件变量上等待时，不被认为是占用了管程。 

```c
void
cond_wait (condvar_t *cvp) {
    //LAB7 EXERCISE1: YOUR CODE
    cprintf("cond_wait begin:  cvp %x, cvp->count %d, cvp->owner->next_count %d\n", cvp, cvp->count, cvp->owner->next_count);
    cvp->count++;
    monitor_t* const mtp = cvp->owner;
    if (mtp->next_count > 0) {
        up(&(mtp->next));
    } else {
        up(&(mtp->mutex));
    }
    down(&(cvp->sem));
    cvp->count--;
    cprintf("cond_wait end:  cvp %x, cvp->count %d, cvp->owner->next_count %d\n", cvp, cvp->count, cvp->owner->next_count);
}

```

`cond_signal`：被一个进程调用，以指出断言Pc现在为真，从而可以唤醒等待断言Pc被满足的进程继续执行。

```c
void 
cond_signal (condvar_t *cvp) {
   //LAB7 EXERCISE1: YOUR CODE
   cprintf("cond_signal begin: cvp %x, cvp->count %d, cvp->owner->next_count %d\n", cvp, cvp->count, cvp->owner->next_count);  
    if (cvp->count > 0) {
        monitor_t* const mtp = cvp->owner;
        mtp->next_count++;
        up(&(cvp->sem));
        down(&(mtp->next));
        mtp->next_count--;
    }
   cprintf("cond_signal end: cvp %x, cvp->count %d, cvp->owner->next_count %d\n", cvp, cvp->count, cvp->owner->next_count);
}
```

### `phi_take_forks_condvar`

首先通过互斥变量，看是否能进入管程，进入管程就可以开始拿叉子吃东西了。如果拿不到叉子，那么就进入等待队列，最后离开管程。

```c
void phi_take_forks_condvar(int i) {
     down(&(mtp->mutex));
//--------into routine in monitor--------------
    state_condvar[i] = HUNGRY;
    phi_test_condvar(i);
    if (state_condvar[i] == HUNGRY) {
        cond_wait(&mtp->cv[i]);
    }
//--------leave routine in monitor--------------
      if(mtp->next_count>0)
         up(&(mtp->next));
      else
         up(&(mtp->mutex));
}
```

### `phi_test_condvar`

看左右邻居的状态然后是否获取叉子

```c
void phi_test_condvar (int i) { 
    if(state_condvar[i]==HUNGRY&&state_condvar[LEFT]!=EATING
            &&state_condvar[RIGHT]!=EATING) {
        cprintf("phi_test_condvar: state_condvar[%d] will eating\n",i);
        state_condvar[i] = EATING ;
        cprintf("phi_test_condvar: signal self_cv[%d] \n",i);
        cond_signal(&mtp->cv[i]) ;
    }
}
```

### `phi_put_forks_condvar`

放下叉子时候还是需要递归看左右邻居的状态看是否叫醒他们。然后离开管程。

```c
void phi_put_forks_condvar(int i) {
     down(&(mtp->mutex));

//--------into routine in monitor--------------
     // LAB7 EXERCISE1: YOUR CODE
     // I ate over
     // test left and right neighbors
    state_condvar[i] = THINKING;
    phi_test_condvar(LEFT);
    phi_test_condvar(RIGHT);
//--------leave routine in monitor--------------
     if(mtp->next_count>0)
        up(&(mtp->next));
     else
        up(&(mtp->mutex));
}
```

### 入口出口

发现在进入管程与退出管程的时候都有几个步骤这样的作用是：

1. 只有一个进程在执行管程中的函数。
2. 避免由于执行了`cond_signal`函数而睡眠的进程无法被唤醒。

对于第二点，如果进程A由于执行了`cond_signal `函数而睡眠（这会让`monitor.next_count`大于0，且执行`sem_wait(monitor.next)）`，则其他进程在执行管程中的函数的出口，会判断`monitor.next_count`是否大于0，如果大于0，则执行`sem_signal(monitor.next)`，从而执行了`cond_signal`函数而睡眠的进程被唤醒。上诉措施将使 得管程正常执行。

## 实验结果

