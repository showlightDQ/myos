#include <onix/memory.h>
#include <onix/types.h>
#include <onix/debug.h>
#include <onix/assert.h>
#include <onix/stdlib.h>
#include <onix/string.h>
#include <onix/bitmap.h>
#include <onix/multiboot2.h>
#include <onix/task.h>
#include <onix/syscall.h>
// #include <onix/fs.h>
#include <onix/printk.h>
#include <onix/io.h>
#include <onix/onix.h>

#define LOGK(fmt, args...) DEBUGK(fmt, ##args)
// #define LOGK(fmt, args...)

#ifdef ONIX_DEBUG
#define USER_MEMORY true
#else
#define USER_MEMORY false
#endif

#define ZONE_VALID 1    // ards 可用内存区域
#define ZONE_RESERVED 2 // ards 不可用区域

#define IDX(addr) ((u32)addr >> 12)            // 获取 addr 的页索引
#define DIDX(addr) (((u32)addr >> 22) & 0x3ff) // 获取 addr 的页目录索引
#define TIDX(addr) (((u32)addr >> 12) & 0x3ff) // 获取 addr 的页表索引
#define PAGE(idx) ((u32)idx << 12)             // 获取页索引 idx 对应的页开始的位置
#define ASSERT_PAGE(addr) assert((addr & 0xfff) == 0)

#define PDE_MASK 0xFFC00000

// 内核页表索引
static u32 KERNEL_PAGE_TABLE[] = {
    0x2000,
    0x3000,
    0x4000,
    0x5000,
};

#define KERNEL_MAP_BITS 0x6000

bitmap_t kernel_map;

typedef struct ards_t
{
    u64 base; // 内存基地址
    u64 size; // 内存长度
    u32 type; // 类型
} _packed ards_t;

static u32 memory_base = 0; // 可用内存基地址，应该等于 1M
static u32 memory_size = 0; // 可用内存大小
static u32 total_pages = 0; // 所有内存页数
static u32 free_pages = 0;  // 空闲内存页数

#define used_pages (total_pages - free_pages) // 已用页数

// 读取从loader.asm中传来的魔数并验证，读取在loader中用中断指令检测得来的内存公布数据，挑选最大的一块，用来初始化memery_base 和memery_base
void memory_init(u32 magic, u32 addr)
{
    u32 count = 0;

    // 如果是 onix loader 进入的内核
    if (magic == ONIX_MAGIC)
    {
        count = *(u32 *)addr;  //读取loader中扫描的可用内存分区数据中的 条数
        ards_t *ptr = (ards_t *)(addr + 4);  //跳过4字节后，读到的是每个条目的记录内容

        for (size_t i = 0; i < count; i++, ptr++)
        {
            LOGK("Memory base:0x%p size:0x%p type:%d\n",
                 (u32)ptr->base, (u32)ptr->size, (u32)ptr->type);
            if (ptr->type == ZONE_VALID && ptr->size > memory_size)  //挑选最大的一块来用
            {
                memory_base = (u32)ptr->base;
                memory_size = (u32)ptr->size;
            }
        }
    }
    else if (magic == MULTIBOOT2_MAGIC)
    {
        u32 size = *(unsigned int *)addr;
        multi_tag_t *tag = (multi_tag_t *)(addr + 8);

        LOGK("Announced mbi(multiboot information) size 0x%x byte.\n", size);
        /*       3.6.8 Memory map  ( https://www.gnu.org/software/grub/manual/multiboot2/multiboot.pdf ) P17
        This tag provides memory map.
                 +-------------------+  offset
        u32      | type = 6          |   0x00
        u32      | size              |   0x04
        u32      | entry_size        |   0x08
        u32      | entry_version     |   0x0c
        varies   | entries           |   0x10
                 +-------------------+
        ‘entry_size’ contains the size of one entry so that in future new fields may be added
        to it. It’s guaranteed to be a multiple of 8. ‘entry_version’ is currently set at ‘0’. Future
        versions will increment this field. Future version are guranteed to be backward compatible
        with older format. Each entry has the following structure:
        entry:   +-------------------+
        u64      | base_addr         |   0x10
        u64      | length            |   0x18
        u32      | type              |   0x20
        u32      | reserved          |   0x24
        next:    +-------------------+   0x28
          |                               |
        next:                            0x40                        */
        multi_tag_mmap_t *mtag;

        while (tag->type != MULTIBOOT_TAG_TYPE_END)
        {
            if (tag->type == MULTIBOOT_TAG_TYPE_MMAP)
            {
                mtag = (multi_tag_mmap_t *)tag;
                break;
            }    
            // 下一个 tag 对齐到了 8 字节
            tag = (multi_tag_t *)((u32)tag + ((tag->size + 7) & ~7));
        }
        
        multi_mmap_entry_t *entry = mtag->entries;
        while ((u32)entry < (u32)mtag + mtag->size)
        {
            LOGK("Memory base 0x%p size 0x%p type %d\n",
                 (u32)entry->addr, (u32)entry->len, (u32)entry->type);
            count++;
            if (entry->type == ZONE_VALID && entry->len > memory_size)
            {
                memory_base = (u32)entry->addr;
                memory_size = (u32)entry->len;
            }
            entry = (multi_mmap_entry_t *)((u32)entry + mtag->entry_size);
        }
    }
    else
    {
        panic("Memory init magic unknown 0x%p\n", magic);
    }
    int sizeM = memory_size >> 20;
    int sizeK = memory_size & 0xfffff;
        sizeK = sizeK >> 10;
    int sizeB = memory_size & 0b1111111111;
    
    LOGK("ARDS count %d\n", count);
    LOGK("Memory base 0x%p\n", (u32)memory_base);
    LOGK("Memory size 0x%p\n", (u32)memory_size);
    LOGK("Memory size %dM %dK %dB\n", sizeM,sizeK,sizeB);

    assert(memory_base == MEMORY_BASE); // 检测机器提供的内存起始位置与预测的是不是一致 从1M（0x100000）开始使用
    assert((memory_size & 0xfff) == 0); // 可用内存的大小是否为整页？

    total_pages = IDX(memory_size)/*可用的页*/ + IDX(MEMORY_BASE);//从0到基址占的页
    free_pages = IDX(memory_size);

    LOGK("Total pages %d\n", total_pages);
    LOGK("Free pages %d\n", free_pages);

    if (memory_size < KERNEL_MEMORY_SIZE) //检测是否小于内核最小内存大小16M
    {
        panic("System memory is %dM too small, at least %dM needed\n",
              memory_size / MEMORY_BASE, KERNEL_MEMORY_SIZE / MEMORY_BASE);
    }
}

static u32 start_page = 0;   // 可分配物理内存起始位置
static u8 *memory_map;       // 用于标记物理内存的位图
static u32 memory_map_pages; // 物理内存数组占用的页数

void memory_map_init()
{
    // 初始化物理内存数组
    memory_map = (u8 *)memory_base;//用可用base开始存储位图   其实 应该把它放在1M以前的可用内存中

    // 计算物理内存位图占用的页数
    memory_map_pages = div_round_up(total_pages, PAGE_SIZE);
    LOGK("Memory map page count %d\n", memory_map_pages);

    free_pages -= memory_map_pages;

    // 0x100000起始的 8K 空间用来标记 页使用情况，设0表示标记为未使用    
    memset((void *)memory_map, 0, memory_map_pages * PAGE_SIZE);//memory_map 是字节数组，每字节表示1页的使用情况，为1为已使用，清理8K字节空间，可标记32M的物理内存

    // 前 1M 的内存位置 以及 物理内存map数组已占用的2页，标记为已被占用
    start_page = IDX(MEMORY_BASE) + memory_map_pages;  //从0地址算起，MEMORY_BASE前面的页（1024）加页目录用掉的页，等于起始页（在整个内存从零开始的第start_page页）
    for (size_t i = 0; i < start_page; i++)
    {
        memory_map[i] = 1; // 0x100000后的每一个字节作为一个页的标志，把0到free_page前的页的标志设为1（已使用）
    }

    LOGK("memory_map_pages=%d start address(memory_map)=%x\n", memory_map_pages, memory_map);
    LOGK("Total pages %d free pages %d\n", total_pages, free_pages);
    LOGK("start page=%d address=%x\n", start_page,start_page<<12);

    // 初始化内核虚拟内存位图，内核内存位图存于0x6000 以位来标记， 0~16M 用来存储kernel map
    u32 length = (IDX(KERNEL_MEMORY_SIZE) - IDX(MEMORY_BASE)) / 8; //计算内核需要的内存（16M）减去Memory_base以前的1M（算是给内核用了），1位标记1页（/8），需要多少字节来标记。 BUG这里没有roundup可能会不够
    bitmap_init(&kernel_map, (u8 *)KERNEL_MAP_BITS, length, IDX(MEMORY_BASE)); //把map数据设置存储在0x6000，长度是内核需要的页标记空间，设置偏移量是1M以前的空间256位（不占标记字节位）
    bitmap_scan(&kernel_map, memory_map_pages); //为memory_map安排两页
}

// 分配一页物理内存
static u32 get_page()
{
    for (size_t i = start_page; i < total_pages; i++)
    {
        // 如果物理内存没有占用
        if (!memory_map[i])
        {
            memory_map[i] = 1;
            assert(free_pages > 0);
            free_pages--;
            u32 page = PAGE(i);
            LOGK("GET page 0x%p\n", page);
            return page;
        }
    }
    panic("Out of Memory!!!");
}

// 释放一页物理内存
static void put_page(u32 addr)
{
    ASSERT_PAGE(addr);

    u32 idx = IDX(addr);

    // idx 大于 1M 并且 小于 总页面数
    assert(idx >= start_page && idx < total_pages);

    // 保证只有一个引用
    assert(memory_map[idx] >= 1);

    // 物理引用减一
    memory_map[idx]--;

    // 若为 0，则空闲页加一
    if (!memory_map[idx])
    {
        free_pages++;
    }

    assert(free_pages > 0 && free_pages < total_pages);
    LOGK("PUT page 0x%p\n", addr);
}

// 得到 cr2 寄存器
u32 get_cr2()
{
    // 直接将 mov eax, cr2，返回值在 eax 中
    asm volatile("movl %cr2, %eax\n");
}

// 得到 cr3 寄存器
u32 get_cr3()
{
    // 直接将 mov eax, cr3，返回值在 eax 中
    asm volatile("movl %cr3, %eax\n");
}

// 设置 cr3 寄存器，参数是页目录的地址
void set_cr3(u32 pde)
{
    ASSERT_PAGE(pde);
    asm volatile("movl %%eax, %%cr3\n" ::"a"(pde));
}

// 将 cr0 寄存器最高位 PG 置为 1，启用分页
static _inline void enable_page()
{
    // 0b1000_0000_0000_0000_0000_0000_0000_0000
    // 0x80000000
    asm volatile(
        "movl %cr0, %eax\n"
        "orl $0x80000000, %eax\n"
        "movl %eax, %cr0\n");
}

// 初始化页表项
static void entry_init(page_entry_t *entry, u32 index)
{
    *(u32 *)entry = 0;
    entry->present = 1;
    entry->write = 1;
    entry->user = 1;
    entry->index = index;
}

// 初始化内存映射
void mapping_init()
{
    page_entry_t *pde = (page_entry_t *)KERNEL_PAGE_DIR;
    memset(pde, 0, PAGE_SIZE);

    idx_t index = 0;

    for (idx_t didx = 0; didx < (sizeof(KERNEL_PAGE_TABLE) / 4); didx++)
    {
        page_entry_t *pte = (page_entry_t *)KERNEL_PAGE_TABLE[didx];  //PTE指向 4字节结构体， 值为0x 2000，3000，4000 ，5000
        memset(pte, 0, PAGE_SIZE);  //把整个页表都清零了

        page_entry_t *dentry = &pde[didx]; //dentry指向 PDE的 4个字节  ，pde[0] = 0x1000 pde[1]=0x1004
        entry_init(dentry, IDX((u32)pte));  // 让每个PDE结构指向一个 pte4K空间的起始位置 0x2000~0x5000
        dentry->user = USER_MEMORY; // 只能被内核访问

        for (idx_t tidx = 0; tidx < 1024; tidx++, index++)
        {
            // 第 0 页不映射，为造成空指针访问，缺页异常，便于排错
            if (index == 0)
                continue;

            page_entry_t *tentry = &pte[tidx];
            entry_init(tentry, index);
            tentry->user = USER_MEMORY; // 只能被内核访问
            memory_map[index] = 1;      // 设置物理内存数组，该页被占用
        }
    }

    // 将最后一个页表指向页目录自己，方便修改
    page_entry_t *entry = &pde[1023];
    entry_init(entry, IDX(KERNEL_PAGE_DIR));

    // 设置 cr3 寄存器
    set_cr3((u32)pde);
    
    // 分页有效
    enable_page();
}

// 获取页目录
static page_entry_t *get_pde()
{
    return (page_entry_t *)(0xfffff000); //该地址经过转换后就是 0x00001ffc
}



// pde是page directory entry(0x1000)只是一个入口地址，
// pdt（page directory table）是pde为始地址的表，把它当作数组则可找到到应的表项，其傎在1000~1fff之间&0xfffffffc
//pte (page table entry)  页表入口，值存放在PDT（PDE[i]）的index里面，=index<<12
//pti (page table item暂且这么叫) 是pte[i]下的表项，i由线性地址0x0000_0000_00xx_xxxx_xxxx_0000_0000_0000中的x决定，结构体中的index（20位）<<12指出该线性地址的物理地址页，线性地址的低12位（4K）用来确定具体在页内的哪个字节

// 获取虚拟地址 vaddr 对应的一级页表结构体。也就是vaddr地址前面4M空间所在的页表结果体，vddr的4K页结果结构体地址是(get_pte()->index)<<12 | (vaddr>>12&0x3ff)*4
static page_entry_t *get_pte(u32 vaddr, bool create)
{    
    page_entry_t *pde = get_pde(); 
    u32 idx = DIDX(vaddr); //取线性地址的高10位，index表示 寻找vaddr时先要找到pde数组中的第几个结构体，该结构体管理指向1024个pte表，管理4M内存
    page_entry_t *entry = &pde[idx]; //entry是已经经过地址映射后的PDE表项地址，值为0x1000~0x1fff

    assert(create || (!create && entry->present)); //如果要创建或者 不是创建但该页表存在

    page_entry_t *table = (page_entry_t *)(PDE_MASK | (idx << 12));

    if (!entry->present)
    {
        LOGK("Get and create page table entry for 0x%p\n", vaddr);
        u32 page = get_page();
        entry_init(entry, IDX(page));
        memset(table, 0, PAGE_SIZE);
    }

    return table;
}

page_entry_t *get_entry(u32 vaddr, bool create)
{
    page_entry_t *pte = get_pte(vaddr, create);
    return &pte[TIDX(vaddr)];
}

// 刷新虚拟地址 vaddr 的 块表 TLB
void flush_tlb(u32 vaddr)
{
    asm volatile("invlpg (%0)" ::"r"(vaddr)
                 : "memory");
}

// 从位图中扫描 count 个连续的页,在们图中标记为1，返回count个页的起始业的 物理地址
static u32 scan_page(bitmap_t *map, u32 count)
{
    assert(count > 0);
    int32 index = bitmap_scan(map, count); //vf寻找并返回连续的count页的起始页位置，返回值是加上offset（1M的页值256）的数

    if (index == EOF)
    {
        panic("Scan page fail!!!");
    }

    u32 addr = PAGE(index);
    LOGK("Scan page 0x%p count %d\n", addr, count);
    return addr;
}

// 与 scan_page 相对，重置相应的页
static void reset_page(bitmap_t *map, u32 addr, u32 count)
{
    ASSERT_PAGE(addr);
    assert(count > 0);
    u32 index = IDX(addr);

    for (size_t i = 0; i < count; i++)
    {
        assert(bitmap_test(map, index + i));
        bitmap_set(map, index + i, 0);
    }
}

// 分配 count 个连续的内核页，返回起始业的物理地址
u32 alloc_kpage(u32 count)
{
    assert(count > 0);
    u32 vaddr = scan_page(&kernel_map, count);
    LOGK("ALLOC kernel pages,start at 0x%p count=%d\n", vaddr, count);
    return vaddr;
}

// 释放 count 个连续的内核页
void free_kpage(u32 vaddr, u32 count)
{
    ASSERT_PAGE(vaddr);
    assert(count > 0);
    reset_page(&kernel_map, vaddr, count);
    LOGK("FREE  kernel pages 0x%p count %d\n", vaddr, count);
}

// 将 vaddr 映射物理内存
void link_page(u32 vaddr)
{
    ASSERT_PAGE(vaddr);

    page_entry_t *entry = get_entry(vaddr, true);

    u32 index = IDX(vaddr);

    // 如果页面已存在，则直接返回
    if (entry->present)
    {
        return;
    }

    u32 paddr = get_page();
    entry_init(entry, IDX(paddr));
    flush_tlb(vaddr);

    LOGK("LINK from 0x%p to 0x%p\n", vaddr, paddr);
}

// 去掉 vaddr 对应的物理内存映射
void unlink_page(u32 vaddr)
{
    ASSERT_PAGE(vaddr);

    page_entry_t *pde = get_pde();
    page_entry_t *entry = &pde[DIDX(vaddr)];
    if (!entry->present)
        return;

    entry = get_entry(vaddr, false);
    if (!entry->present)
    {
        return;
    }

    entry->present = false;

    u32 paddr = PAGE(entry->index);

    DEBUGK("UNLINK from 0x%p to 0x%p\n", vaddr, paddr);
    put_page(paddr);

    flush_tlb(vaddr);
}

// 拷贝一页，返回拷贝后的物理地址
static u32 copy_page(void *page)
{
    u32 paddr = get_page();
    u32 vaddr = 0;

    page_entry_t *entry = get_pte(vaddr, false);
    entry_init(entry, IDX(paddr));
    flush_tlb(vaddr);

    memcpy((void *)vaddr, (void *)page, PAGE_SIZE);

    entry->present = false;
    flush_tlb(vaddr);

    return paddr;
}

// 拷贝当前页目录
// page_entry_t *copy_pde()
// {
//     task_t *task = running_task();

//     page_entry_t *pde = (page_entry_t *)alloc_kpage(1);
//     memcpy(pde, (void *)task->pde, PAGE_SIZE);

//     // 将最后一个页表指向页目录自己，方便修改
//     page_entry_t *entry = &pde[1023];
//     entry_init(entry, IDX(pde));

//     page_entry_t *dentry;

//     for (size_t didx = (sizeof(KERNEL_PAGE_TABLE) / 4); didx < 1023; didx++)
//     {
//         dentry = &pde[didx];
//         if (!dentry->present)
//             continue;

//         page_entry_t *pte = (page_entry_t *)(PDE_MASK | (didx << 12));

//         for (size_t tidx = 0; tidx < 1024; tidx++)
//         {
//             entry = &pte[tidx];
//             if (!entry->present)
//                 continue;

//             // 对应物理内存引用大于 0
//             assert(memory_map[entry->index] > 0);

//             // 若不是共享内存，则置为只读
//             if (!entry->shared)
//             {
//                 entry->write = false;
//             }
//             // 对应物理页引用加 1
//             memory_map[entry->index]++;

//             assert(memory_map[entry->index] < 255);
//         }

//         u32 paddr = copy_page(pte);
//         dentry->index = IDX(paddr);
//     }

//     set_cr3(task->pde);

//     return pde;
// }

// 释放当前页目录
// void free_pde()
// {
//     task_t *task = running_task();
//     assert(task->uid != KERNEL_USER);

//     page_entry_t *pde = get_pde();

//     for (size_t didx = (sizeof(KERNEL_PAGE_TABLE) / 4); didx < 1023; didx++)
//     {
//         page_entry_t *dentry = &pde[didx];
//         if (!dentry->present)
//         {
//             continue;
//         }

//         page_entry_t *pte = (page_entry_t *)(PDE_MASK | (didx << 12));

//         for (size_t tidx = 0; tidx < 1024; tidx++)
//         {
//             page_entry_t *entry = &pte[tidx];
//             if (!entry->present)
//             {
//                 continue;
//             }

//             assert(memory_map[entry->index] > 0);
//             put_page(PAGE(entry->index));
//         }

//         // 释放页表
//         put_page(PAGE(dentry->index));
//     }

//     // 释放页目录
//     free_kpage(task->pde, 1);
//     LOGK("free pages %d\n", free_pages);
// }

// int32 sys_brk(void *addr)
// {
//     LOGK("task brk 0x%p\n", addr);
//     u32 brk = (u32)addr;
//     ASSERT_PAGE(brk);

//     task_t *task = running_task();
//     assert(task->uid != KERNEL_USER);

//     assert(task->end <= brk && brk <= USER_MMAP_ADDR);

//     u32 old_brk = task->brk;

//     if (old_brk > brk)
//     {
//         for (u32 page = brk; page < old_brk; page += PAGE_SIZE)
//         {
//             unlink_page(page);
//         }
//     }
//     else if (IDX(brk - old_brk) > free_pages)
//     {
//         // out of memory
//         return -1;
//     }

//     task->brk = brk;
//     return 0;
// }

// void *sys_mmap(void *addr, size_t length, int prot, int flags, int fd, off_t offset)
// {
//     ASSERT_PAGE((u32)addr);

//     u32 count = div_round_up(length, PAGE_SIZE);
//     u32 vaddr = (u32)addr;

//     task_t *task = running_task();
//     if (!vaddr)
//     {
//         vaddr = scan_page(task->vmap, count);
//     }

//     assert(vaddr >= USER_MMAP_ADDR && vaddr < USER_STACK_BOTTOM);

//     for (size_t i = 0; i < count; i++)
//     {
//         u32 page = vaddr + PAGE_SIZE * i;
//         link_page(page);
//         bitmap_set(task->vmap, IDX(page), true);

//         page_entry_t *entry = get_entry(page, false);
//         entry->user = true;
//         entry->write = false;
//         entry->readonly = true;

//         if (prot & PROT_WRITE)
//         {
//             entry->readonly = false;
//             entry->write = true;
//         }
//         if (flags & MAP_SHARED)
//         {
//             entry->shared = true;
//         }
//         if (flags & MAP_PRIVATE)
//         {
//             entry->privat = true;
//         }
//         flush_tlb(page);
//     }

//     if (fd != EOF)
//     {
//         lseek(fd, offset, SEEK_SET);
//         read(fd, (char *)vaddr, length);
//     }

//     return (void *)vaddr;
// }

// int sys_munmap(void *addr, size_t length)
// {
//     task_t *task = running_task();
//     u32 vaddr = (u32)addr;
//     assert(vaddr >= USER_MMAP_ADDR && vaddr < USER_STACK_BOTTOM);

//     ASSERT_PAGE(vaddr);
//     u32 count = div_round_up(length, PAGE_SIZE);

//     for (size_t i = 0; i < count; i++)
//     {
//         u32 page = vaddr + PAGE_SIZE * i;
//         unlink_page(page);
//         assert(bitmap_test(task->vmap, IDX(page)));
//         bitmap_set(task->vmap, IDX(page), false);
//     }

//     return 0;
// }

// typedef struct page_error_code_t
// {
//     u8 present : 1;
//     u8 write : 1;
//     u8 user : 1;
//     u8 reserved0 : 1;
//     u8 fetch : 1;
//     u8 protection : 1;
//     u8 shadow : 1;
//     u16 reserved1 : 8;
//     u8 sgx : 1;
//     u16 reserved2;
// } _packed page_error_code_t;

// void page_fault(
//     u32 vector,
//     u32 edi, u32 esi, u32 ebp, u32 esp,
//     u32 ebx, u32 edx, u32 ecx, u32 eax,
//     u32 gs, u32 fs, u32 es, u32 ds,
//     u32 vector0, u32 error, u32 eip, u32 cs, u32 eflags)
// {
//     assert(vector == 0xe);
//     u32 vaddr = get_cr2();
//     LOGK("fault address 0x%p\n", vaddr);

//     page_error_code_t *code = (page_error_code_t *)&error;
//     task_t *task = running_task();

//     // assert(KERNEL_MEMORY_SIZE <= vaddr && vaddr < USER_STACK_TOP);

//     // 如果用户程序访问了不该访问的内存
//     if (vaddr < USER_EXEC_ADDR || vaddr >= USER_STACK_TOP)
//     {
//         assert(task->uid);
//         printk("Segmentation Fault!!!\n");
//         task_exit(-1);
//     }

//     if (code->present)
//     {
//         assert(code->write);

//         page_entry_t *entry = get_entry(vaddr, false);

//         assert(entry->present);   // 目前写内存应该是存在的
//         assert(!entry->shared);   // 共享内存页，不应该引发缺页
//         assert(!entry->readonly); // 只读内存页，不应该被写

//         assert(memory_map[entry->index] > 0);
//         if (memory_map[entry->index] == 1)
//         {
//             entry->write = true;
//             LOGK("WRITE page for 0x%p\n", vaddr);
//         }
//         else
//         {
//             void *page = (void *)PAGE(IDX(vaddr));
//             u32 paddr = copy_page(page);
//             memory_map[entry->index]--;
//             entry_init(entry, IDX(paddr));
//             flush_tlb(vaddr);
//             LOGK("COPY page for 0x%p\n", vaddr);
//         }
//         return;
//     }

//     if (!code->present && (vaddr < task->brk || vaddr >= USER_STACK_BOTTOM))
//     {
//         u32 page = PAGE(IDX(vaddr));
//         link_page(page);
//         // BMB;
//         return;
//     }

//     LOGK("task 0x%p name %s brk 0x%p page fault\n", task, task->name, task->brk);
//     panic("page fault!!!");
// }

