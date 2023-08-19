// Buffer cache.
//
// The buffer cache is a linked list of buf structures holding
// cached copies of disk block contents.  Caching disk blocks
// in memory reduces the number of disk reads and also provides
// a synchronization point for disk blocks used by multiple processes.
//
// Interface:
// * To get a buffer for a particular disk block, call bread.
// * After changing buffer data, call bwrite to write it to disk.
// * When done with the buffer, call brelse.
// * Do not use the buffer after calling brelse.
// * Only one process at a time can use a buffer,
//     so do not keep them longer than necessary.


#include "types.h"
#include "param.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "riscv.h"
#include "defs.h"
#include "fs.h"
#include "buf.h"

#define NUM_BUCKET 13
#define HASH(x) ((x) % NUM_BUCKET)

struct {
  struct spinlock locks[NUM_BUCKET];
  struct buf buf[NBUF];

  // Linked list of all buffers, through prev/next.
  // Sorted by how recently the buffer was used.
  // head.next is most recent, head.prev is least.
  struct buf heads[NUM_BUCKET];
} bcache;

void
binit(void)
{
  struct buf* b;
  char* lockname = "bcache0";
  uint i;
  // 初始化锁和头节点
  for (i = 0; i < NUM_BUCKET; ++i) {
      initlock(bcache.locks + i, lockname);
      ++lockname[6];
      bcache.heads[i].prev = bcache.heads + i;
      bcache.heads[i].next = bcache.heads + i;
  }
  // 将buf放入哈希表中
  for (b = bcache.buf; b < bcache.buf + NBUF; ++b) {
      i = HASH(b->blockno);  
      b->next = bcache.heads[i].next;
      b->prev = bcache.heads + i;
      initsleeplock(&b->lock, "buffer");
      bcache.heads[i].next->prev = b;
      bcache.heads[i].next = b;
  }
}

// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf* b;
  uint jdx, idx = HASH(blockno);

  acquire(bcache.locks + idx); // 获取本桶的锁
  // Is the block already cached?
  for (b = bcache.heads[idx].next; b != bcache.heads + idx; b = b->next) {
      if (b->dev == dev && b->blockno == blockno) {
          b->refcnt++;
          release(bcache.locks + idx);
          acquiresleep(&b->lock);
          return b;  
      }
  }
  // 若没有缓存优先在本桶找引用计数为0的缓存
  for (b = bcache.heads[idx].prev; b != bcache.heads + idx; b = b->prev) {
      if (b->refcnt == 0) {
          b->dev = dev;
          b->blockno = blockno;
          b->valid = 0;
          b->refcnt = 1;
          release(bcache.locks + idx);
          acquiresleep(&b->lock);
          return b;  
      }
  }
  release(bcache.locks + idx);
  // 如果本桶没有引用计数为0的桶，就要找别的桶
  for (jdx = HASH(idx + 1); jdx != idx; jdx = (jdx + 1) % NUM_BUCKET) {
      acquire(bcache.locks + jdx);
      for (b = bcache.heads[jdx].prev; b != bcache.heads + jdx; b = b->prev) {
          if (b->refcnt == 0) {
              // 找到后替换
              b->dev = dev;
              b->blockno = blockno;
              b->valid = 0;
              b->refcnt = 1;
              // 然后在jdx桶中删去b
              b->next->prev = b->prev;
              b->prev->next = b->next;
              release(bcache.locks + jdx); // 释放jdx桶的锁
              // 最后把b放入本桶
              acquire(bcache.locks + idx);  // 重新获取idx桶的锁
              b->next = bcache.heads[idx].next;
              b->prev = bcache.heads + idx;
              bcache.heads[idx].next->prev = b;
              bcache.heads[idx].next = b;
              release(bcache.locks + idx);  // 操作后释放idx桶的锁
              acquiresleep(&b->lock);
              return b;
          }
      }
      release(bcache.locks + jdx);
  }
  panic("bget: no buffers");
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
  virtio_disk_rw(b, 1);
}

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
  uint idx = HASH(b->blockno);
  if (!holdingsleep(&b->lock)){
      panic("brelse");
  } 
  releasesleep(&b->lock);

  acquire(bcache.locks + idx);
  b->refcnt--;
  if (b->refcnt == 0) {
      // 将b从列表中删去
      b->next->prev = b->prev;
      b->prev->next = b->next;
      // 将b加入到本桶list head的左边
      b->prev = bcache.heads[idx].prev;
      b->next = bcache.heads + idx;
      bcache.heads[idx].prev->next = b;
      bcache.heads[idx].prev = b;
  }
  release(bcache.locks + idx);
}

void
bpin(struct buf *b) {
  uint idx = HASH(b->blockno);
  acquire(bcache.locks + idx);
  b->refcnt++;
  release(bcache.locks + idx);
}

void
bunpin(struct buf *b) {
  uint idx = HASH(b->blockno);
  acquire(bcache.locks + idx);
  b->refcnt--;
  release(bcache.locks + idx);
}


