# 硬盘文件系统SFS

## 介绍

通常文件系统中，磁盘的使用是以扇区（Sector）为单位的，但是为了实现简便，SFS 中以 block （4K，与内存 page 大小相等）为基本单位。

SFS 文件系统的布局如下表所示。

| superblock | root-dir inode | freemap    | inode、File Data、Dir Data Blocks |
| ---------- | -------------- | ---------- | --------------------------------- |
| 超级块     | 根目录索引节点 | 空闲块映射 | 目录和文件的数据和索引节点        |

第 0 个块（4K）是超级块（superblock），它包含了关于文件系统的所有关键参数，当计算机被启动或文件系统被首次接触时，超级块的内容就会被装入内存。其定义如下：

```c
struct sfs_super {
    uint32_t magic;                                  /* magic number, should be SFS_MAGIC */
    uint32_t blocks;                                 /* # of blocks in fs */
    uint32_t unused_blocks;                         /* # of unused blocks in fs */
    char info[SFS_MAX_INFO_LEN + 1];                /* infomation for sfs  */
};
```

可以看到，包含一个成员变量魔数 magic，其值为 0x2f8dbe2a，内核通过它来检查磁盘镜像是否是合法的 SFS img；成员变量 blocks 记录了 SFS 中所有 block 的数量，即 img 的大小；成员变量 unused_block 记录了 SFS 中还没有被使用的 block 的数量；成员变量 info 包含了字符串"simple file system"。

第 1 个块放了一个 root-dir 的 inode，用来记录根目录的相关信息。有关 inode 还将在后续部分介绍。这里只要理解 root-dir 是 SFS 文件系统的根结点，通过这个 root-dir 的 inode 信息就可以定位并查找到根目录下的所有文件信息。

从第 2 个块开始，根据 SFS 中所有块的数量，用 1 个 bit 来表示一个块的占用和未被占用的情况。这个区域称为 SFS 的 freemap 区域，这将占用若干个块空间。为了更好地记录和管理 freemap 区域，专门提供了两个文件 kern/fs/sfs/bitmap.[ch]来完成根据一个块号查找或设置对应的 bit 位的值。

最后在剩余的磁盘空间中，存放了所有其他目录和文件的 inode 信息和内容数据信息。需要注意的是虽然 inode 的大小小于一个块的大小（4096B），但为了实现简单，每个 inode 都占用一个完整的 block。

在 sfs_fs.c 文件中的 sfs_do_mount 函数中，完成了加载位于硬盘上的 SFS 文件系统的超级块 superblock 和 freemap 的工作。这样，在内存中就有了 SFS 文件系统的全局信息。

> [!NOTE|style:flat|label: "魔数"是怎样工作的?]
>
> 我们经常需要检查某个文件/某块磁盘是否符合我们需要的格式。一般会按照这个文件的完整格式，进行一次全面的分析。
>
> 在一个较早的版本，UNIX的可执行文件格式最开头包含一条PDP-11平台上的跳转指令，使得在PDP-11硬件平台上能够正常运行，而在其他平台上，这条指令就是“魔数”（magic number)，只能用作文件类型的标识。
>
> Java类文件（编译到字节码）以十六进制0xCAFEBABE 开头
>
> JPEG图片文件以0xFFD8开头，0xFFD9结尾
>
> PDF文件以“%PDF"的ASCII码开头，十六进制25 50 44 46
>
> 进行这样的约定之后，我们发现，如果文件开头的”魔数“不符合要求，那么这个文件的格式一定不对。这让我们立刻发现文件损坏或者搞错文件类型的情况。由于不同类型的文件有不同的魔数，当你把JPEG文件当作PDF打开的时候，立即就会出现异常。
>
> 下面是一个摇滚乐队和巧克力豆的故事，有助于你理解魔数的作用。
>
> 美国著名重金属摇滚乐队Van Halen的演出合同中有此一条：演出后台必须提供M&M巧克力豆，但是绝对不许出现棕色豆。如有违反，根据合同，乐队可以取消演出。实际情形中乐队甚至会借此发飙，砸后台，主办方也只好承担所有经济损失。这一条款长期被媒体用来作为摇滚乐队耍大牌的典型例子，有传言指某次由于主唱在后台发现了棕色M&M豆，大发其飙地砸了后台，造成损失高达八万五千美元（当时是八十年代，八万五千还是不少钱）。Van Halen乐队对此从不回应。
>
> 多年以后，主唱David Lee Roth 在自传中揭示了这一无厘头条款的来由：Van Halen 乐队在当时是把大型摇滚现场演唱会推向高校及二／三线地区的先锋，由于常常会遇到没有处理过这种大场面的承办者，因此合同里有大量条款来确认演出承办者把场地，器材，工作人员安排等等细节都严格按要求准备好。合同里有成章成章的技术细节，包括场地的承重要求，各类出入口的宽度，电源要求，以至于插座的数量和插座之间的间隔。因此，乐队把棕色豆条款夹带在合同里，以确认承办方是否“仔仔细细阅读了所有条款”。David说：“如果我在后台的M&M里找到棕色豆，我就会立马知道承办方（十有八九）是没好好读完全部技术要求，我们肯定会碰上技术问题。某些技术问题绝对会毁了这场演出，甚至害死人。”
>
> 回到上文，八万五千美元的损失是怎么来的？某次在某大学体育场办演唱会，主唱来到后台，发现了棕色M&M豆，当即发飙，砸了后台化妆室，财物损坏大概值一万二。但实际上更糟糕的是，主办方没有细读演出演出场地的承重要求，结果整个舞台压垮（似乎是压穿）了体育场地面，损失高达八万多。
>
> 事后媒体的报道是，由于主唱看到棕色M&M豆后发飙砸了后台，造成高达八万五的损失...

## 索引节点

在 SFS 文件系统中，需要记录文件内容的存储位置以及文件名与文件内容的对应关系。sfs_disk_inode 记录了文件或目录的内容存储的索引信息，该数据结构在硬盘里储存，需要时读入内存（从磁盘读进来的是一段连续的字节，我们将这段连续的字节强制转换成sfs_disk_inode结构体；同样，写入的时候换一个方向强制转换）。sfs_disk_entry 表示一个目录中的一个文件或目录，包含该项所对应 inode 的位置和文件名，同样也在硬盘里储存，需要时读入内存。

### 磁盘索引节点

SFS 中的磁盘索引节点代表了一个实际位于磁盘上的文件。首先我们看看在硬盘上的索引节点的内容：

```c
// kern/fs/sfs/sfs.hc
/*inode (on disk)*/
struct sfs_disk_inode {
    uint32_t size;                              //如果inode表示常规文件，则size是文件大小
    uint16_t type;                              //inode的文件类型
    uint16_t nlinks;                            //此inode的硬链接数
    uint32_t blocks;                            //此inode的数据块数的个数
    uint32_t direct[SFS_NDIRECT];               //此inode的直接数据块索引值（有SFS_NDIRECT个）
    uint32_t indirect;                          //此inode的一级间接数据块索引值
};
```

通过上表可以看出，如果 inode 表示的是文件，则成员变量 direct[]直接指向了保存文件内容数据的数据块索引值。indirect 间接指向了保存文件内容数据的数据块，indirect 指向的是间接数据块（indirect block），此数据块实际存放的全部是数据块索引，这些数据块索引指向的数据块才被用来存放文件内容数据。

默认的，ucore 里 SFS_NDIRECT 是 12，即直接索引的数据页大小为 12  *4k = 48k；当使用一级间接数据块索引时，ucore 支持最大的文件大小为 12*  4k + 1024 * 4k = 48k + 4m。数据索引表内，0 表示一个无效的索引，inode 里 blocks 表示该文件或者目录占用的磁盘的 block 的个数。indiret 为 0 时，表示不使用一级索引块。（因为 block 0 用来保存 super block，它不可能被其他任何文件或目录使用，所以这么设计也是合理的）。

对于普通文件，索引值指向的 block 中保存的是文件中的数据。而对于目录，索引值指向的数据保存的是目录下所有的文件名以及对应的索引节点所在的索引块（磁盘块）所形成的数组。数据结构如下：

```c
// kern/fs/sfs/sfs.h
/* file entry (on disk) */
struct sfs_disk_entry {
    uint32_t ino;                                   //索引节点所占数据块索引值
    char name[SFS_MAX_FNAME_LEN + 1];               //文件名
};
```

操作系统中，每个文件系统下的 inode 都应该分配唯一的 inode 编号。SFS 下，为了实现的简便（偷懒），每个 inode 直接用他所在的磁盘 block 的编号作为 inode 编号。比如，root block 的 inode 编号为 1；每个 sfs_disk_entry 数据结构中，name 表示目录下文件或文件夹的名称，ino 表示磁盘 block 编号，通过读取该 block 的数据，能够得到相应的文件或文件夹的 inode。ino 为 0 时，表示一个无效的 entry。

此外，和 inode 相似，每个 `sfs_disk_entry`也占用一个 block。

### 内存中的索引节点

```c
// kern/fs/sfs/sfs.h
/* inode for sfs */
struct sfs_inode {
    struct sfs_disk_inode *din;                /* on-disk inode */
    uint32_t ino;                              /* inode number */
    uint32_t flags;                            /* inode flags */
    bool dirty;                                /* true if inode modified */
    int reclaim_count;                         /* kill inode if it hits zero */
    semaphore_t sem;                           /* semaphore for din */
    list_entry_t inode_link;                   /* entry for linked-list in sfs_fs */
    list_entry_t hash_link;                    /* entry for hash linked-list in sfs_fs */
};
```

可以看到 SFS 中的内存 inode 包含了 SFS 的硬盘 inode 信息，而且还增加了其他一些信息，这属于是便于进行是判断否改写、互斥操作、回收和快速地定位等作用。需要注意，一个内存 inode 是在打开一个文件后才创建的，如果关机则相关信息都会消失。而硬盘 inode 的内容是保存在硬盘中的，只是在进程需要时才被读入到内存中，用于访问文件或目录的具体内容数据

为了方便实现上面提到的多级数据的访问以及目录中 entry 的操作，对 inode SFS 实现了一些辅助的函数：

（在`kern/fs/sfs/sfs_inode.c`实现）

1. sfs_bmap_load_nolock：将对应 sfs_inode 的第 index 个索引指向的 block 的索引值取出存到相应的指针指向的单元（ino_store）。该函数只接受 index <= inode->blocks 的参数。当 index == inode->blocks 时，该函数理解为需要为 inode 增长一个 block。并标记 inode 为 dirty（所有对 inode 数据的修改都要做这样的操作，这样，当 inode 不再使用的时候，sfs 能够保证 inode 数据能够被写回到磁盘）。sfs_bmap_load_nolock 调用的 sfs_bmap_get_nolock 来完成相应的操作，阅读 sfs_bmap_get_nolock，了解他是如何工作的。（sfs_bmap_get_nolock 只由 sfs_bmap_load_nolock 调用）
2. sfs_bmap_truncate_nolock：将多级数据索引表的最后一个 entry 释放掉。他可以认为是 sfs_bmap_load_nolock 中，index == inode->blocks 的逆操作。当一个文件或目录被删除时，sfs 会循环调用该函数直到 inode->blocks 减为 0，释放所有的数据页。函数通过 sfs_bmap_free_nolock 来实现，他应该是 sfs_bmap_get_nolock 的逆操作。和 sfs_bmap_get_nolock 一样，调用 sfs_bmap_free_nolock 也要格外小心。
3. sfs_dirent_read_nolock：将目录的第 slot 个 entry 读取到指定的内存空间。他通过上面提到的函数来完成。
4. sfs_dirent_search_nolock：是常用的查找函数。他在目录下查找 name，并且返回相应的搜索结果（文件或文件夹）的 inode 的编号（也是磁盘编号），和相应的 entry 在该目录的 index 编号以及目录下的数据页是否有空闲的 entry。（SFS 实现里文件的数据页是连续的，不存在任何空洞；而对于目录，数据页不是连续的，当某个 entry 删除的时候，SFS 通过设置 entry->ino 为 0 将该 entry 所在的 block 标记为 free，在需要添加新 entry 的时候，SFS 优先使用这些 free 的 entry，其次才会去在数据页尾追加新的 entry。

注意，这些后缀为 nolock 的函数，只能在已经获得相应 inode 的 semaphore 才能调用。

### Inode 的文件操作函数

```c
// kern/fs/sfs/sfs_inode.c
static const struct inode_ops sfs_node_fileops = {
    .vop_magic                      = VOP_MAGIC,
    .vop_open                       = sfs_openfile,
    .vop_close                      = sfs_close,
    .vop_read                       = sfs_read,
    .vop_write                      = sfs_write,
    ……
};
```

上述 sfs_openfile、sfs_close、sfs_read 和 sfs_write 分别对应用户进程发出的 open、close、read、write 操作。其中 sfs_openfile 不用做什么事；sfs_close 需要把对文件的修改内容写回到硬盘上，这样确保硬盘上的文件内容数据是最新的；sfs_read 和 sfs_write 函数都调用了一个函数 sfs_io，并最终通过访问硬盘驱动来完成对文件内容数据的读写。

### Inode 的目录操作函数

```c
// kern/fs/sfs/sfs_inode.c
static const struct inode_ops sfs_node_dirops = {
    .vop_magic                      = VOP_MAGIC,
    .vop_open                       = sfs_opendir,
    .vop_close                      = sfs_close,
    .vop_getdirentry                = sfs_getdirentry,
    .vop_lookup                     = sfs_lookup,
    ……
};
```

对于目录操作而言，由于目录也是一种文件，所以 sfs_opendir、sys_close 对应户进程发出的 open、close 函数。相对于 sfs_open，sfs_opendir 只是完成一些 open 函数传递的参数判断，没做其他更多的事情。目录的 close 操作与文件的 close 操作完全一致。由于目录的内容数据与文件的内容数据不同，所以读出目录的内容数据的函数是 `sfs_getdirentry()`，其主要工作是获取目录下的文件 inode 信息。

这里用到的`inode_ops`结构体，在`kern/fs/vfs/inode.h`定义，作用是：把关于`inode`的操作接口，集中在一个结构体里， 通过这个结构体，我们可以把Simple File System的接口（如`sfs_openfile()`)提供给上层的VFS使用。可以想象我们除了Simple File System, 还在另一块磁盘上使用完全不同的文件系统Complex File System，显然`vop_open(),vop_read()`这些接口的实现都要不一样了。对于同一个文件系统这些接口都是一样的，所以我们可以提供”属于SFS的文件的inode_ops结构体", “属于CFS的文件的inode_ops结构体"。

下面的注释里详细解释了每个接口的用途。当然，不必现在就详细了解每一个接口。

```c
// kern/fs/vfs/inode.h
struct inode_ops {
    unsigned long vop_magic;
    int (*vop_open)(struct inode *node, uint32_t open_flags);
    int (*vop_close)(struct inode *node);
    int (*vop_read)(struct inode *node, struct iobuf *iob);
    int (*vop_write)(struct inode *node, struct iobuf *iob);
    int (*vop_fstat)(struct inode *node, struct stat *stat);
    int (*vop_fsync)(struct inode *node);
    int (*vop_namefile)(struct inode *node, struct iobuf *iob);
    int (*vop_getdirentry)(struct inode *node, struct iobuf *iob);
    int (*vop_reclaim)(struct inode *node);
    int (*vop_gettype)(struct inode *node, uint32_t *type_store);
    int (*vop_tryseek)(struct inode *node, off_t pos);
    int (*vop_truncate)(struct inode *node, off_t len);
    int (*vop_create)(struct inode *node, const char *name, bool excl, struct inode **node_store);
    int (*vop_lookup)(struct inode *node, char *path, struct inode **node_store);
    int (*vop_ioctl)(struct inode *node, int op, void *data);
};

/*
 * Abstract operations on a inode.
 *
 * These are used in the form VOP_FOO(inode, args), which are macros
 * that expands to inode->inode_ops->vop_foo(inode, args). The operations
 * "foo" are:
 *
 *    vop_open        - Called on open() of a file. Can be used to
 *                      reject illegal or undesired open modes. Note that
 *                      various operations can be performed without the
 *                      file actually being opened.
 *                      The inode need not look at O_CREAT, O_EXCL, or 
 *                      O_TRUNC, as these are handled in the VFS layer.
 *
 *                      VOP_EACHOPEN should not be called directly from
 *                      above the VFS layer - use vfs_open() to open inodes.
 *                      This maintains the open count so VOP_LASTCLOSE can
 *                      be called at the right time.
 *
 *    vop_close       - To be called on *last* close() of a file.
 *
 *                      VOP_LASTCLOSE should not be called directly from
 *                      above the VFS layer - use vfs_close() to close
 *                      inodes opened with vfs_open().
 *
 *    vop_reclaim     - Called when inode is no longer in use. Note that
 *                      this may be substantially after vop_lastclose is
 *                      called.
 *
 *****************************************
 *
 *    vop_read        - Read data from file to uio, at offset specified
 *                      in the uio, updating uio_resid to reflect the
 *                      amount read, and updating uio_offset to match.
 *                      Not allowed on directories or symlinks.
 *
 *    vop_getdirentry - Read a single filename from a directory into a
 *                      uio, choosing what name based on the offset
 *                      field in the uio, and updating that field.
 *                      Unlike with I/O on regular files, the value of
 *                      the offset field is not interpreted outside
 *                      the filesystem and thus need not be a byte
 *                      count. However, the uio_resid field should be
 *                      handled in the normal fashion.
 *                      On non-directory objects, return ENOTDIR.
 *
 *    vop_write       - Write data from uio to file at offset specified
 *                      in the uio, updating uio_resid to reflect the
 *                      amount written, and updating uio_offset to match.
 *                      Not allowed on directories or symlinks.
 *
 *    vop_ioctl       - Perform ioctl operation OP on file using data
 *                      DATA. The interpretation of the data is specific
 *                      to each ioctl.
 *
 *    vop_fstat        -Return info about a file. The pointer is a 
 *                      pointer to struct stat; see stat.h.
 *
 *    vop_gettype     - Return type of file. The values for file types
 *                      are in sfs.h.
 *
 *    vop_tryseek     - Check if seeking to the specified position within
 *                      the file is legal. (For instance, all seeks
 *                      are illegal on serial port devices, and seeks
 *                      past EOF on files whose sizes are fixed may be
 *                      as well.)
 *
 *    vop_fsync       - Force any dirty buffers associated with this file
 *                      to stable storage.
 *
 *    vop_truncate    - Forcibly set size of file to the length passed
 *                      in, discarding any excess blocks.
 *
 *    vop_namefile    - Compute pathname relative to filesystem root
 *                      of the file and copy to the specified io buffer. 
 *                      Need not work on objects that are not
 *                      directories.
 *
 *****************************************
 *
 *    vop_creat       - Create a regular file named NAME in the passed
 *                      directory DIR. If boolean EXCL is true, fail if
 *                      the file already exists; otherwise, use the
 *                      existing file if there is one. Hand back the
 *                      inode for the file as per vop_lookup.
 *
 *****************************************
 *
 *    vop_lookup      - Parse PATHNAME relative to the passed directory
 *                      DIR, and hand back the inode for the file it
 *                      refers to. May destroy PATHNAME. Should increment
 *                      refcount on inode handed back.
 */
```

