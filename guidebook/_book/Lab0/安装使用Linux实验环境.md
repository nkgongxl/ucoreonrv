# 安装使用Linux实验环境

## 使用Linux

在实验过程中，我们需要了解基于命令行方式的编译、调试、运行操作系统的实验方法。为此，需要了解基本的Linux命令行使用。

## 命令模式的基本结构和概念

Ubuntu是图形界面友好和易操作的linux发行版，但有时只需执行几条简单的指令就可以完成繁琐的鼠标点击才能完成的操作。linux的命令行操作模式功能可以实现你需要的所有操作。简单的说，命令行就是基于字符命令的用户界面，也被称为文本操作模式。绝大多数情况下， 用户通过输入一行或多行命令直接与计算机互动，来实现对计算机的操作。

## 如何进入命令模式

假设使用默认的图形界面为GNOME的任意版本Ubuntu Linux。点击鼠标右键->终端，就可以启动名为terminal程序，从而可以在此软件界面中进行命令行操作。 打开terminal程序后你首先可能会注意到类似下面的界面：

```
kelee@ubuntu:~$ 
```

你所看到的这些被称为命令终端提示符，它表示计算机已就绪，正在等待着用户输入操作指令。以我的屏幕画面为例，“kelee"是当前所登录的用户名，“ubuntu”是这台计算机的主机名，“~”表示当前目录。此时输入任何指令按回车之后该指令将会提交到计算机运行，比如你可以输入命令：ls 再按下回车：

```
ls [ENTER]
```

*注意*：[ENTER]是指输入完ls后按下回车键，而不是叫你输入这个单词，ls这个命令将会列出你当前所在目录里的所有文件和子目录列表。

下面介绍bash shell程序的基本使用方法，它是ubuntu缺省的外壳程序。

## 常用指令

### 查询文件列表：(ls)

```
kelee@ubuntu:~$ ls
Desktop    Downloads         Music     Public  Templates
Documents  examples.desktop  Pictures  riscv   Videos
```

ls命令默认状态下将按首字母升序列出你当前文件夹下面的所有内容，但这样直接运行所得到的信息也是比较少的，通常它可以结合以下这些参数运行以查询更多的信息：

```
ls /        # 将列出根目录'/'下的文件清单.如果给定一个参数，则命令行会把该参数当作命令行的工作目录。换句话说，命令行不再以当前目录为工作目录。 
ls -l         # 将给你列出一个更详细的文件清单. 
ls -a        # 将列出包括隐藏文件(以.开头的文件)在内的所有文
```

件. ]ls -h # 将以KB/MB/GB的形式给出文件大小,而不是以纯粹的Bytes.

### 查询当前所在目录：(pwd)

```
kelee@ubuntu:~$ pwd
/home/kelee
```

###  进入其他目录：(cd) 

```
kelee@ubuntu:~$ cd riscv
kelee@ubuntu:~/riscv$ pwd
/home/kelee/riscv
kelee@ubuntu:~/riscv$ 
```

上面例子中，当前目录原来是/home/kelee,执行cd riscv之后再运行pwd可以发现，当前目录已经改为/riscv了。

### 在屏幕上输出字符： (echo)

```
kelee@ubuntu:~$ echo "Hello World"
Hello World
```

这是一个很有用的命令，它可以在屏幕上输入你指定的参数(""号中的内容)，当然这里举的这个例子中它没有多大的实际意义，但随着你对LINUX指令的不断深入，就会发现它的价值所在。

### 显示文件内容：cat

```
kelee@ubuntu:~$ cat tempfile.txt
Roses are red.
Violets are blue,
and you have the bird-flue!
```

也可以使用less或more来显示比较大的文本文件内容。

### 复制文件： cp

```
kelee@ubuntu:~$ cp tempfile.txt tempfile_copy.txt
kelee@ubuntu:~$ cat tempfile_copy.txt
Roses are red.
Violets are blue,
and you have the bird-flue!
```

### 移动文件：mv

```
kelee@ubuntu:~$ ls
Desktop    Downloads         Music     Public  tempfile_copy.txt  Templates
Documents  examples.desktop  Pictures  riscv   tempfile.txt       Videos
kelee@ubuntu:~$ mv tempfile_copy.txt tempfile_mv.txt
kelee@ubuntu:~$ ls
Desktop    Downloads         Music     Public  tempfile_mv.txt  Templates
Documents  examples.desktop  Pictures  riscv   tempfile.txt     Videos
```

*注意*：在命令操作时系统基本上不会给你什么提示，当然，绝大多数的命令可以通过加上一个参数-v来要求系统给出执行命令的反馈信息；

```
kelee@ubuntu:~$ mv -v  tempfile_mv.txt tempfile_mv_v.txt
renamed 'tempfile_mv.txt' -> 'tempfile_mv_v.txt'
```

### 建立一个空文本文件：touch

```
kelee@ubuntu:~$ ls
Desktop    Downloads         Music     Public  tempfile_mv_v.txt  Templates
Documents  examples.desktop  Pictures  riscv   tempfile.txt       Videos
kelee@ubuntu:~$ touch file1.txt
kelee@ubuntu:~$ ls
Desktop    examples.desktop  Pictures  tempfile_mv_v.txt  Videos
Documents  file1.txt         Public    tempfile.txt
Downloads  Music             riscv     Templates

```

### 建立一个目录：mkdir

```
kelee@ubuntu:~$ ls
Desktop    examples.desktop  Pictures  tempfile_mv_v.txt  Videos
Documents  file1.txt         Public    tempfile.txt
Downloads  Music             riscv     Templates
kelee@ubuntu:~$ mkdir test_dir
kelee@ubuntu:~$ ls
Desktop    examples.desktop  Pictures  tempfile_mv_v.txt  test_dir
Documents  file1.txt         Public    tempfile.txt       Videos
Downloads  Music             riscv     Templates

```

### 删除文件/目录：rm

```
kelee@ubuntu:~$ ls
Desktop    examples.desktop  Pictures  tempfile_mv_v.txt  test_dir
Documents  file1.txt         Public    tempfile.txt       Videos
Downloads  Music             riscv     Templates
kelee@ubuntu:~$ rm tempfile_mv_v.txt
kelee@ubuntu:~$ ls -p
Desktop/    examples.desktop  Pictures/  tempfile.txt  Videos/
Documents/  file1.txt         Public/    Templates/
Downloads/  Music/            riscv/     test_dir/
kelee@ubuntu:~$ rm test_dir
rm: cannot remove 'test_dir': Is a directory
kelee@ubuntu:~$ rm -R  test_dir
kelee@ubuntu:~$ ls 
Desktop    Downloads         file1.txt  Pictures  riscv         Templates
Documents  examples.desktop  Music      Public    tempfile.txt  Videos

```

在上面的操作：首先我们通过ls命令查询可知当前目下有两个文件和一个文件夹；

```
[1] 你可以用参数 -p来让系统显示某一项的类型，比如是文件/文件夹/快捷链接等等；
[2] 接下来我们用rm -i尝试删除文件，-i参数是让系统在执行删除操作前输出一条确认提示；i(interactive)也就是交互性的意思； 
[3] 当我们尝试用上面的命令去删除一个文件夹时会得到错误的提示，因为删除文件夹必须使用-R(recursive,循环）参数
```

特别提示：在使用命令操作时，系统假设你很明确自己在做什么，它不会给你太多的提示，比如你执行rm -Rf /，它将会删除你硬盘上所有的东西，并且不会给你任何提示，所以，尽量在使用命令时加上-i的参数，以让系统在执行前进行一次确认，防止你干一些蠢事。如 果你觉得每次都要输入-i太麻烦，你可以执行以下的命令，让－i成为默认参数：

```
alias rm='rm -i'
```

### 查询当前进程：ps

```
kelee@ubuntu:~$ ps
   PID TTY          TIME CMD
  3356 pts/0    00:00:00 bash
  3659 pts/0    00:00:00 ps
```

这条命令会例出你所启动的所有进程；

```
ps -a        #可以例出系统当前运行的所有进程，包括由其他用户启动的进程； 
ps auxww    #是一条相当人性化的命令，它会例出除一些很特殊进程以外的所有进程，并会以一个高可读的形式显示结果，每一个进程都会有较为详细的解释； 
```

基本命令的介绍就到此为止，你可以访问网络得到更加详细的Linux命令介绍。

## 控制流程

### 输入/输出

input用来读取你通过键盘（或其他标准输入设备）输入的信息，output用于在屏幕（或其他标准输出设备）上输出你指定的输出内容.另外还有一些标准的出错提示也是通过这个命令来实现的。通常在遇到操作错误时，系统会自动调用这个命令来输出标准错误提示；

我们能重定向命令中产生的输入和输出流的位置。

###  重定向

如果你想把命令产生的输出流指向一个文件而不是（默认的）终端，你可以使用如下的语句：

```
kelee@ubuntu:~$ ls >file2.txt
kelee@ubuntu:~$ cat file2.txt
Desktop
Documents
Downloads
examples.desktop
file1.txt
file2.txt
Music
Pictures
Public
riscv
tempfile.txt
Templates
Videos
```

以上例子将创建文件file2.txt如果file2.txt不存在的话。注意：如果file2.txt已经存在，那么上面的命令将复盖文件的内容。如果你想将内容添加到已存在的文件内容的最后，那你可以用下面这个语句：

```
command >> filename 
```

示例:

```
kelee@ubuntu:~$ ls >>file2.txt
kelee@ubuntu:~$ cat file2.txt
Desktop
Documents
Downloads
examples.desktop
file1.txt
file2.txt
Music
Pictures
Public
riscv
tempfile.txt
Templates
Videos
Desktop
Documents
Downloads
examples.desktop
file1.txt
file2.txt
Music
Pictures
Public
riscv
tempfile.txt
Templates
Videos
```

在这个例子中，你会发现原有的文件中添加了新的内容。接下来我们会见到另一种重定向方式：我们将把一个文件的内容作为将要执行的命令的输入。以下是这个语句：

```
command < filename 
```

示例:

```
kelee@ubuntu:~$ sort <file2.txt
Desktop
Desktop
Documents
Documents
Downloads
Downloads
examples.desktop
examples.desktop
file1.txt
file1.txt
file2.txt
file2.txt
Music
Music
Pictures
Pictures
Public
Public
riscv
riscv
tempfile.txt
tempfile.txt
Templates
Templates
Videos
Videos
```

### 管道

Linux的强大之处在于它能把几个简单的命令联合成为复杂的功能，通过键盘上的管道符号'|' 完成。现在，我们来排序上面的"grep"命令：

```
kelee@ubuntu:~$ grep -i 'D'  <file2.txt | sort > result.txt 
kelee@ubuntu:~$ cat result.txt
Desktop
Desktop
Documents
Documents
Downloads
Downloads
examples.desktop
examples.desktop
Videos
Videos

```

搜索 file2.txt 中的d字母，将输出分类并写入分类文件到 result.txt 。 有时候用ls列出很多命令的时候很不方便 这时“｜”就充分利用到了 ls -l | less 慢慢看吧.

### 后台进程

CLI 不是系统的串行接口。您可以在执行其他命令时给出系统命令。要启动一个进程到后台，追加一个“&”到命令后面。

```
sleep 60 &
ls
```

睡眠命令在后台运行，您依然可以与计算机交互。除了不同步启动命令以外，最好把 '&' 理解成 ';'。

如果您有一个命令将占用很多时间，您想把它放入后台运行，也很简单。只要在命令运行时按下ctrl-z，它就会停止。然后键入 bg使其转入后台。fg 命令可使其转回前台。

```
sleep 60
<ctrl-z> # 这表示敲入Ctrl+Z键
bg
fg
```

最后，您可以使用 ctrl-c 来杀死一个前台进程。

## 环境变量

特殊变量。PATH, PS1, ...

### 不显示中文

可通过执行如下命令避免显示乱码中文。在一个shell中，执行：

```
export LANG=””
```

这样在这个shell中，output信息缺省时英文。

## 获得软件包

### 命令行获取软件包

Ubuntu 下可以使用 apt-get 命令，apt-get 是一条 Linux 命令行命令，适用于 deb 包管理式的操作系统，主要用于自动从互联网软件库中搜索、安装、升级以及卸载软件或者操作系统。一般需要 root 执行权限，所以一般跟随 sudo 命令，如：

```
sudo apt-get install gcc [ENTER]
```

常见的以及常用的 apt 命令有：

```
apt-get install <package>
    下载 <package> 以及所依赖的软件包，同时进行软件包的安装或者升级。
apt-get remove <package>
    移除 <package> 以及所有依赖的软件包。
apt-cache search <pattern>
    搜索满足 <pattern> 的软件包。
apt-cache show/showpkg <package>
    显示软件包 <package> 的完整描述。
```

例如：

```
kelee@ubuntu:~$ apt-cache search aptitude
aptitude - terminal-based package manager
aptitude-common - architecture independent files for the aptitude package manager
aptitude-doc-en - English manual for aptitude, a terminal-based package manager
libcwidget-dev - high-level terminal interface library for C++ (development files)
apt-cacher - Caching proxy server for Debian/Ubuntu software repositories
apticron - Simple tool to mail about pending package updates - cron version
apticron-systemd - Simple tool to mail about pending package updates - systemd version
aptitude-doc-cs - Czech manual for aptitude, a terminal-based package manager
aptitude-doc-es - Spanish manual for aptitude, a terminal-based package manager
aptitude-doc-fi - Finnish manual for aptitude, a terminal-based package manager
aptitude-doc-fr - French manual for aptitude, a terminal-based package manager
aptitude-doc-it - Italian manual for aptitude, a terminal-based package manager
aptitude-doc-ja - Japanese manual for aptitude, a terminal-based package manager
aptitude-doc-nl - Dutch manual for aptitude, a terminal-based package manager
aptitude-doc-ru - Russian manual for aptitude, a terminal-based package manager
aptitude-robot - Automate package choice management
cron-apt - automatic update of packages using apt-get
cupt - flexible package manager -- console interface
gbrainy - brain teaser game and trainer to have fun and to keep your brain trained
pkgsync - automated package list synchronization
wajig - unified package management front-end for Debian
kelee@ubuntu:~$ 
```

### 配置升级源

Ubuntu的软件包获取依赖升级源，通过Software&Updates->Ubuntu Software->Download from:->Other:->China->mirrors.aliyun.com->Choose Server

## 查找帮助文件

Ubuntu 下提供 man 命令以完成帮助手册得查询。man 是 manual 的缩写，通过 man 命令可以对 Linux 下常用命令、安装软件、以及C语言常用函数等进行查询，获得相关帮助。

例如：

```
kelee@ubuntu:~$ man printf
PRINTF(1)                        User Commands                       PRINTF(1)

NAME
       printf - format and print data

SYNOPSIS
       printf FORMAT [ARGUMENT]...
       printf OPTION

DESCRIPTION
       Print ARGUMENT(s) according to FORMAT, or execute according to OPTION:

       --help display this help and exit

       --version
              output version information and exit

       FORMAT controls the output as in C printf.  Interpreted sequences are:

       \"     double quote

       \\     backslash

 Manual page printf(1) line 1 (press h for help or q to quit)

```

通常可能会用到的帮助文件例如：

```
gcc-doc cpp-doc glibc-doc
```

上述帮助文件可以通过 apt-get 命令或者软件包管理器获得。获得以后可以通过 man 命令进行命令或者参数查询。