// Physical memory allocator, for user processes,
// kernel stacks, page-table pages,
// and pipe buffers. Allocates whole 4096-byte pages.

#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "riscv.h"
#include "defs.h"

void freerange(void *pa_start, void *pa_end);

extern char end[]; // first address after kernel.
                   // defined by kernel.ld.

struct run {
  struct run *next;
};

struct {
  struct spinlock lock;
  struct run *freelist;
} kmem[NCPU];

void
kinit()
{
  //initlock(&kmem.lock, "kmem");
  //freerange(end, (void*)PHYSTOP);
  int i;
  char* name = "kmem0"; 
  for (i = 0; i < NCPU; ++i) {
      initlock(&kmem[i].lock, name);
      ++name[4];  // 通过递增序号位改变锁的名称
  }
  freerange(end, (void*)PHYSTOP);
}

void
freerange(void *pa_start, void *pa_end)
{
  char *p;
  p = (char*)PGROUNDUP((uint64)pa_start);
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    kfree(p);
}

// Free the page of physical memory pointed at by v,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
  struct run *r;
  int cid;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);

  r = (struct run*)pa;

  push_off();  // 关闭中断
  cid = cpuid();  // 获取cid

  acquire(&kmem[cid].lock);
  // 将要释放的空间放入当前CPU的空闲列表中
  r->next = kmem[cid].freelist;
  kmem[cid].freelist = r;
  release(&kmem[cid].lock);

  pop_off();  // 恢复中断
}

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
  struct run* r;
  int cid, i;

  push_off();
  cid = cpuid();  // 获取cid
  acquire(&kmem[cid].lock);
  r = kmem[cid].freelist;
  // 如果有空间则直接分配
  if(r) {
      kmem[cid].freelist = r->next;
  }
  release(&kmem[cid].lock);
  // 如果无空闲内存则窃取其它cpu的空闲列表
  if (!r) { 
      for (i = 0; i < NCPU - 1; ++i) {
          if (++cid == NCPU){
              cid = 0;  // 下一个cpu的id
          }   
          acquire(&kmem[cid].lock);  // 要借的cpu的锁
          // 如果该cpu有空闲内存，则窃取空间，然后跳出循环
          if (kmem[cid].freelist) {
              r = kmem[cid].freelist;
              kmem[cid].freelist = r->next;
              release(&kmem[cid].lock);
              break;
          } 
          else {  
              release(&kmem[cid].lock);
          }
      }
  }
  pop_off();
  if (r) {
    memset((char*)r, 5, PGSIZE);  // fill with junk
  }
  return (void*)r;
}
