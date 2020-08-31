这个lab1的代码由张蔚学长的bbl-ucore的lab1代码修改得到. https://github.com/ring00/bbl-ucore/tree/master/labcodes/lab1

主要的修改: 修改了makefile里的配置, 生成riscv64目标代码, 修改的代码里的多处int(32位)为unsigned long long(64位)

如果希望正常make, 需要配置好riscv工具链(riscv64-unknown-elf-gcc, riscv64-unknown-elf-ld), 并把riscv-pk放对位置(相对这个lab1的路径为../../riscv-pk)

2020.4.3