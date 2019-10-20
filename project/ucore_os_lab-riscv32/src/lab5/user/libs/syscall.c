#include <defs.h>
#include <unistd.h>
#include <stdarg.h>
#include <syscall.h>

#define MAX_ARGS            5

static inline int
syscall(int num, ...) {
    va_list ap;
    va_start(ap, num);
    uint32_t a[MAX_ARGS];
    for (int i = 0; i < MAX_ARGS; i++) {
        a[i] = va_arg(ap, uint32_t);
    }
    va_end(ap);

    register uintptr_t a0 asm ("a0") = (uintptr_t)(num);
    register uintptr_t a1 asm ("a1") = (uintptr_t)(a[0]);
    register uintptr_t a2 asm ("a2") = (uintptr_t)(a[1]);
    register uintptr_t a3 asm ("a3") = (uintptr_t)(a[2]);
    register uintptr_t a4 asm ("a4") = (uintptr_t)(a[3]);
    register uintptr_t a5 asm ("a5") = (uintptr_t)(a[4]);
    asm volatile (
        "ecall"
        : "+r"(a0)
        : "r"(a1), "r"(a2), "r"(a3), "r"(a4), "r"(a5)
        : "memory"
    );

    return a0;
}

int
sys_exit(int error_code) {
    return syscall(SYS_exit, error_code);
}

int
sys_fork(void) {
    return syscall(SYS_fork);
}

int
sys_wait(int pid, int *store) {
    return syscall(SYS_wait, pid, store);
}

int
sys_yield(void) {
    return syscall(SYS_yield);
}

int
sys_kill(int pid) {
    return syscall(SYS_kill, pid);
}

int
sys_getpid(void) {
    return syscall(SYS_getpid);
}

int
sys_putc(int c) {
    return syscall(SYS_putc, c);
}

int
sys_pgdir(void) {
    return syscall(SYS_pgdir);
}

