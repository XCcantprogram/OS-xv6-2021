
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	92013103          	ld	sp,-1760(sp) # 80008920 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	451050ef          	jal	ra,80005c66 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	7139                	addi	sp,sp,-64
    8000001e:	fc06                	sd	ra,56(sp)
    80000020:	f822                	sd	s0,48(sp)
    80000022:	f426                	sd	s1,40(sp)
    80000024:	f04a                	sd	s2,32(sp)
    80000026:	ec4e                	sd	s3,24(sp)
    80000028:	e852                	sd	s4,16(sp)
    8000002a:	e456                	sd	s5,8(sp)
    8000002c:	0080                	addi	s0,sp,64
  struct run *r;
  int cid;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    8000002e:	03451793          	slli	a5,a0,0x34
    80000032:	e3c1                	bnez	a5,800000b2 <kfree+0x96>
    80000034:	84aa                	mv	s1,a0
    80000036:	0002b797          	auipc	a5,0x2b
    8000003a:	21278793          	addi	a5,a5,530 # 8002b248 <end>
    8000003e:	06f56a63          	bltu	a0,a5,800000b2 <kfree+0x96>
    80000042:	47c5                	li	a5,17
    80000044:	07ee                	slli	a5,a5,0x1b
    80000046:	06f57663          	bgeu	a0,a5,800000b2 <kfree+0x96>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    8000004a:	6605                	lui	a2,0x1
    8000004c:	4585                	li	a1,1
    8000004e:	00000097          	auipc	ra,0x0
    80000052:	230080e7          	jalr	560(ra) # 8000027e <memset>

  r = (struct run*)pa;

  push_off();  // 关闭中断
    80000056:	00006097          	auipc	ra,0x6
    8000005a:	594080e7          	jalr	1428(ra) # 800065ea <push_off>
  cid = cpuid();  // 获取cid
    8000005e:	00001097          	auipc	ra,0x1
    80000062:	ece080e7          	jalr	-306(ra) # 80000f2c <cpuid>

  acquire(&kmem[cid].lock);
    80000066:	00009a97          	auipc	s5,0x9
    8000006a:	fcaa8a93          	addi	s5,s5,-54 # 80009030 <kmem>
    8000006e:	00251993          	slli	s3,a0,0x2
    80000072:	00a98933          	add	s2,s3,a0
    80000076:	090e                	slli	s2,s2,0x3
    80000078:	9956                	add	s2,s2,s5
    8000007a:	854a                	mv	a0,s2
    8000007c:	00006097          	auipc	ra,0x6
    80000080:	5ba080e7          	jalr	1466(ra) # 80006636 <acquire>
  // 将要释放的空间放入当前CPU的空闲列表中
  r->next = kmem[cid].freelist;
    80000084:	02093783          	ld	a5,32(s2)
    80000088:	e09c                	sd	a5,0(s1)
  kmem[cid].freelist = r;
    8000008a:	02993023          	sd	s1,32(s2)
  release(&kmem[cid].lock);
    8000008e:	854a                	mv	a0,s2
    80000090:	00006097          	auipc	ra,0x6
    80000094:	676080e7          	jalr	1654(ra) # 80006706 <release>

  pop_off();  // 恢复中断
    80000098:	00006097          	auipc	ra,0x6
    8000009c:	60e080e7          	jalr	1550(ra) # 800066a6 <pop_off>
}
    800000a0:	70e2                	ld	ra,56(sp)
    800000a2:	7442                	ld	s0,48(sp)
    800000a4:	74a2                	ld	s1,40(sp)
    800000a6:	7902                	ld	s2,32(sp)
    800000a8:	69e2                	ld	s3,24(sp)
    800000aa:	6a42                	ld	s4,16(sp)
    800000ac:	6aa2                	ld	s5,8(sp)
    800000ae:	6121                	addi	sp,sp,64
    800000b0:	8082                	ret
    panic("kfree");
    800000b2:	00008517          	auipc	a0,0x8
    800000b6:	f5e50513          	addi	a0,a0,-162 # 80008010 <etext+0x10>
    800000ba:	00006097          	auipc	ra,0x6
    800000be:	05a080e7          	jalr	90(ra) # 80006114 <panic>

00000000800000c2 <freerange>:
{
    800000c2:	7179                	addi	sp,sp,-48
    800000c4:	f406                	sd	ra,40(sp)
    800000c6:	f022                	sd	s0,32(sp)
    800000c8:	ec26                	sd	s1,24(sp)
    800000ca:	e84a                	sd	s2,16(sp)
    800000cc:	e44e                	sd	s3,8(sp)
    800000ce:	e052                	sd	s4,0(sp)
    800000d0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000d2:	6785                	lui	a5,0x1
    800000d4:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    800000d8:	00e504b3          	add	s1,a0,a4
    800000dc:	777d                	lui	a4,0xfffff
    800000de:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000e0:	94be                	add	s1,s1,a5
    800000e2:	0095ee63          	bltu	a1,s1,800000fe <freerange+0x3c>
    800000e6:	892e                	mv	s2,a1
    kfree(p);
    800000e8:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ea:	6985                	lui	s3,0x1
    kfree(p);
    800000ec:	01448533          	add	a0,s1,s4
    800000f0:	00000097          	auipc	ra,0x0
    800000f4:	f2c080e7          	jalr	-212(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000f8:	94ce                	add	s1,s1,s3
    800000fa:	fe9979e3          	bgeu	s2,s1,800000ec <freerange+0x2a>
}
    800000fe:	70a2                	ld	ra,40(sp)
    80000100:	7402                	ld	s0,32(sp)
    80000102:	64e2                	ld	s1,24(sp)
    80000104:	6942                	ld	s2,16(sp)
    80000106:	69a2                	ld	s3,8(sp)
    80000108:	6a02                	ld	s4,0(sp)
    8000010a:	6145                	addi	sp,sp,48
    8000010c:	8082                	ret

000000008000010e <kinit>:
{
    8000010e:	7179                	addi	sp,sp,-48
    80000110:	f406                	sd	ra,40(sp)
    80000112:	f022                	sd	s0,32(sp)
    80000114:	ec26                	sd	s1,24(sp)
    80000116:	e84a                	sd	s2,16(sp)
    80000118:	e44e                	sd	s3,8(sp)
    8000011a:	e052                	sd	s4,0(sp)
    8000011c:	1800                	addi	s0,sp,48
  for (i = 0; i < NCPU; ++i) {
    8000011e:	00009497          	auipc	s1,0x9
    80000122:	f1248493          	addi	s1,s1,-238 # 80009030 <kmem>
    80000126:	00009a17          	auipc	s4,0x9
    8000012a:	04aa0a13          	addi	s4,s4,74 # 80009170 <pid_lock>
      initlock(&kmem[i].lock, name);
    8000012e:	00008917          	auipc	s2,0x8
    80000132:	eea90913          	addi	s2,s2,-278 # 80008018 <etext+0x18>
      ++name[4];  // 通过递增序号位改变锁的名称
    80000136:	03100993          	li	s3,49
      initlock(&kmem[i].lock, name);
    8000013a:	85ca                	mv	a1,s2
    8000013c:	8526                	mv	a0,s1
    8000013e:	00006097          	auipc	ra,0x6
    80000142:	674080e7          	jalr	1652(ra) # 800067b2 <initlock>
      ++name[4];  // 通过递增序号位改变锁的名称
    80000146:	01390223          	sb	s3,4(s2)
  for (i = 0; i < NCPU; ++i) {
    8000014a:	02848493          	addi	s1,s1,40
    8000014e:	ff4496e3          	bne	s1,s4,8000013a <kinit+0x2c>
  freerange(end, (void*)PHYSTOP);
    80000152:	45c5                	li	a1,17
    80000154:	05ee                	slli	a1,a1,0x1b
    80000156:	0002b517          	auipc	a0,0x2b
    8000015a:	0f250513          	addi	a0,a0,242 # 8002b248 <end>
    8000015e:	00000097          	auipc	ra,0x0
    80000162:	f64080e7          	jalr	-156(ra) # 800000c2 <freerange>
}
    80000166:	70a2                	ld	ra,40(sp)
    80000168:	7402                	ld	s0,32(sp)
    8000016a:	64e2                	ld	s1,24(sp)
    8000016c:	6942                	ld	s2,16(sp)
    8000016e:	69a2                	ld	s3,8(sp)
    80000170:	6a02                	ld	s4,0(sp)
    80000172:	6145                	addi	sp,sp,48
    80000174:	8082                	ret

0000000080000176 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000176:	715d                	addi	sp,sp,-80
    80000178:	e486                	sd	ra,72(sp)
    8000017a:	e0a2                	sd	s0,64(sp)
    8000017c:	fc26                	sd	s1,56(sp)
    8000017e:	f84a                	sd	s2,48(sp)
    80000180:	f44e                	sd	s3,40(sp)
    80000182:	f052                	sd	s4,32(sp)
    80000184:	ec56                	sd	s5,24(sp)
    80000186:	e85a                	sd	s6,16(sp)
    80000188:	e45e                	sd	s7,8(sp)
    8000018a:	0880                	addi	s0,sp,80
  struct run* r;
  int cid, i;

  push_off();
    8000018c:	00006097          	auipc	ra,0x6
    80000190:	45e080e7          	jalr	1118(ra) # 800065ea <push_off>
  cid = cpuid();  // 获取cid
    80000194:	00001097          	auipc	ra,0x1
    80000198:	d98080e7          	jalr	-616(ra) # 80000f2c <cpuid>
    8000019c:	892a                	mv	s2,a0
  acquire(&kmem[cid].lock);
    8000019e:	00251793          	slli	a5,a0,0x2
    800001a2:	97aa                	add	a5,a5,a0
    800001a4:	078e                	slli	a5,a5,0x3
    800001a6:	00009497          	auipc	s1,0x9
    800001aa:	e8a48493          	addi	s1,s1,-374 # 80009030 <kmem>
    800001ae:	94be                	add	s1,s1,a5
    800001b0:	8526                	mv	a0,s1
    800001b2:	00006097          	auipc	ra,0x6
    800001b6:	484080e7          	jalr	1156(ra) # 80006636 <acquire>
  r = kmem[cid].freelist;
    800001ba:	0204b983          	ld	s3,32(s1)
  // 如果有空间则直接分配
  if(r) {
    800001be:	0a098363          	beqz	s3,80000264 <kalloc+0xee>
      kmem[cid].freelist = r->next;
    800001c2:	0009b683          	ld	a3,0(s3) # 1000 <_entry-0x7ffff000>
    800001c6:	f094                	sd	a3,32(s1)
  }
  release(&kmem[cid].lock);
    800001c8:	8526                	mv	a0,s1
    800001ca:	00006097          	auipc	ra,0x6
    800001ce:	53c080e7          	jalr	1340(ra) # 80006706 <release>
          else {  
              release(&kmem[cid].lock);
          }
      }
  }
  pop_off();
    800001d2:	00006097          	auipc	ra,0x6
    800001d6:	4d4080e7          	jalr	1236(ra) # 800066a6 <pop_off>
  if (r) {
    memset((char*)r, 5, PGSIZE);  // fill with junk
    800001da:	6605                	lui	a2,0x1
    800001dc:	4595                	li	a1,5
    800001de:	854e                	mv	a0,s3
    800001e0:	00000097          	auipc	ra,0x0
    800001e4:	09e080e7          	jalr	158(ra) # 8000027e <memset>
  }
  return (void*)r;
}
    800001e8:	854e                	mv	a0,s3
    800001ea:	60a6                	ld	ra,72(sp)
    800001ec:	6406                	ld	s0,64(sp)
    800001ee:	74e2                	ld	s1,56(sp)
    800001f0:	7942                	ld	s2,48(sp)
    800001f2:	79a2                	ld	s3,40(sp)
    800001f4:	7a02                	ld	s4,32(sp)
    800001f6:	6ae2                	ld	s5,24(sp)
    800001f8:	6b42                	ld	s6,16(sp)
    800001fa:	6ba2                	ld	s7,8(sp)
    800001fc:	6161                	addi	sp,sp,80
    800001fe:	8082                	ret
          acquire(&kmem[cid].lock);  // 要借的cpu的锁
    80000200:	00291493          	slli	s1,s2,0x2
    80000204:	94ca                	add	s1,s1,s2
    80000206:	048e                	slli	s1,s1,0x3
    80000208:	94d6                	add	s1,s1,s5
    8000020a:	8526                	mv	a0,s1
    8000020c:	00006097          	auipc	ra,0x6
    80000210:	42a080e7          	jalr	1066(ra) # 80006636 <acquire>
          if (kmem[cid].freelist) {
    80000214:	0204b983          	ld	s3,32(s1)
    80000218:	00099f63          	bnez	s3,80000236 <kalloc+0xc0>
              release(&kmem[cid].lock);
    8000021c:	8526                	mv	a0,s1
    8000021e:	00006097          	auipc	ra,0x6
    80000222:	4e8080e7          	jalr	1256(ra) # 80006706 <release>
      for (i = 0; i < NCPU - 1; ++i) {
    80000226:	3a7d                	addiw	s4,s4,-1
    80000228:	020a0963          	beqz	s4,8000025a <kalloc+0xe4>
          if (++cid == NCPU){
    8000022c:	2905                	addiw	s2,s2,1
    8000022e:	fd6919e3          	bne	s2,s6,80000200 <kalloc+0x8a>
              cid = 0;  // 下一个cpu的id
    80000232:	895e                	mv	s2,s7
    80000234:	b7f1                	j	80000200 <kalloc+0x8a>
              kmem[cid].freelist = r->next;
    80000236:	0009b683          	ld	a3,0(s3)
    8000023a:	00291793          	slli	a5,s2,0x2
    8000023e:	97ca                	add	a5,a5,s2
    80000240:	078e                	slli	a5,a5,0x3
    80000242:	00009717          	auipc	a4,0x9
    80000246:	dee70713          	addi	a4,a4,-530 # 80009030 <kmem>
    8000024a:	97ba                	add	a5,a5,a4
    8000024c:	f394                	sd	a3,32(a5)
              release(&kmem[cid].lock);
    8000024e:	8526                	mv	a0,s1
    80000250:	00006097          	auipc	ra,0x6
    80000254:	4b6080e7          	jalr	1206(ra) # 80006706 <release>
              break;
    80000258:	bfad                	j	800001d2 <kalloc+0x5c>
  pop_off();
    8000025a:	00006097          	auipc	ra,0x6
    8000025e:	44c080e7          	jalr	1100(ra) # 800066a6 <pop_off>
  if (r) {
    80000262:	b759                	j	800001e8 <kalloc+0x72>
  release(&kmem[cid].lock);
    80000264:	8526                	mv	a0,s1
    80000266:	00006097          	auipc	ra,0x6
    8000026a:	4a0080e7          	jalr	1184(ra) # 80006706 <release>
    8000026e:	4a1d                	li	s4,7
          if (++cid == NCPU){
    80000270:	4b21                	li	s6,8
              cid = 0;  // 下一个cpu的id
    80000272:	4b81                	li	s7,0
          acquire(&kmem[cid].lock);  // 要借的cpu的锁
    80000274:	00009a97          	auipc	s5,0x9
    80000278:	dbca8a93          	addi	s5,s5,-580 # 80009030 <kmem>
    8000027c:	bf45                	j	8000022c <kalloc+0xb6>

000000008000027e <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000027e:	1141                	addi	sp,sp,-16
    80000280:	e422                	sd	s0,8(sp)
    80000282:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000284:	ca19                	beqz	a2,8000029a <memset+0x1c>
    80000286:	87aa                	mv	a5,a0
    80000288:	1602                	slli	a2,a2,0x20
    8000028a:	9201                	srli	a2,a2,0x20
    8000028c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000290:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000294:	0785                	addi	a5,a5,1
    80000296:	fee79de3          	bne	a5,a4,80000290 <memset+0x12>
  }
  return dst;
}
    8000029a:	6422                	ld	s0,8(sp)
    8000029c:	0141                	addi	sp,sp,16
    8000029e:	8082                	ret

00000000800002a0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    800002a0:	1141                	addi	sp,sp,-16
    800002a2:	e422                	sd	s0,8(sp)
    800002a4:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800002a6:	ca05                	beqz	a2,800002d6 <memcmp+0x36>
    800002a8:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800002ac:	1682                	slli	a3,a3,0x20
    800002ae:	9281                	srli	a3,a3,0x20
    800002b0:	0685                	addi	a3,a3,1
    800002b2:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800002b4:	00054783          	lbu	a5,0(a0)
    800002b8:	0005c703          	lbu	a4,0(a1)
    800002bc:	00e79863          	bne	a5,a4,800002cc <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800002c0:	0505                	addi	a0,a0,1
    800002c2:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800002c4:	fed518e3          	bne	a0,a3,800002b4 <memcmp+0x14>
  }

  return 0;
    800002c8:	4501                	li	a0,0
    800002ca:	a019                	j	800002d0 <memcmp+0x30>
      return *s1 - *s2;
    800002cc:	40e7853b          	subw	a0,a5,a4
}
    800002d0:	6422                	ld	s0,8(sp)
    800002d2:	0141                	addi	sp,sp,16
    800002d4:	8082                	ret
  return 0;
    800002d6:	4501                	li	a0,0
    800002d8:	bfe5                	j	800002d0 <memcmp+0x30>

00000000800002da <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800002da:	1141                	addi	sp,sp,-16
    800002dc:	e422                	sd	s0,8(sp)
    800002de:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800002e0:	c205                	beqz	a2,80000300 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800002e2:	02a5e263          	bltu	a1,a0,80000306 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800002e6:	1602                	slli	a2,a2,0x20
    800002e8:	9201                	srli	a2,a2,0x20
    800002ea:	00c587b3          	add	a5,a1,a2
{
    800002ee:	872a                	mv	a4,a0
      *d++ = *s++;
    800002f0:	0585                	addi	a1,a1,1
    800002f2:	0705                	addi	a4,a4,1
    800002f4:	fff5c683          	lbu	a3,-1(a1)
    800002f8:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800002fc:	fef59ae3          	bne	a1,a5,800002f0 <memmove+0x16>

  return dst;
}
    80000300:	6422                	ld	s0,8(sp)
    80000302:	0141                	addi	sp,sp,16
    80000304:	8082                	ret
  if(s < d && s + n > d){
    80000306:	02061693          	slli	a3,a2,0x20
    8000030a:	9281                	srli	a3,a3,0x20
    8000030c:	00d58733          	add	a4,a1,a3
    80000310:	fce57be3          	bgeu	a0,a4,800002e6 <memmove+0xc>
    d += n;
    80000314:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000316:	fff6079b          	addiw	a5,a2,-1
    8000031a:	1782                	slli	a5,a5,0x20
    8000031c:	9381                	srli	a5,a5,0x20
    8000031e:	fff7c793          	not	a5,a5
    80000322:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000324:	177d                	addi	a4,a4,-1
    80000326:	16fd                	addi	a3,a3,-1
    80000328:	00074603          	lbu	a2,0(a4)
    8000032c:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000330:	fee79ae3          	bne	a5,a4,80000324 <memmove+0x4a>
    80000334:	b7f1                	j	80000300 <memmove+0x26>

0000000080000336 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000336:	1141                	addi	sp,sp,-16
    80000338:	e406                	sd	ra,8(sp)
    8000033a:	e022                	sd	s0,0(sp)
    8000033c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000033e:	00000097          	auipc	ra,0x0
    80000342:	f9c080e7          	jalr	-100(ra) # 800002da <memmove>
}
    80000346:	60a2                	ld	ra,8(sp)
    80000348:	6402                	ld	s0,0(sp)
    8000034a:	0141                	addi	sp,sp,16
    8000034c:	8082                	ret

000000008000034e <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000034e:	1141                	addi	sp,sp,-16
    80000350:	e422                	sd	s0,8(sp)
    80000352:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000354:	ce11                	beqz	a2,80000370 <strncmp+0x22>
    80000356:	00054783          	lbu	a5,0(a0)
    8000035a:	cf89                	beqz	a5,80000374 <strncmp+0x26>
    8000035c:	0005c703          	lbu	a4,0(a1)
    80000360:	00f71a63          	bne	a4,a5,80000374 <strncmp+0x26>
    n--, p++, q++;
    80000364:	367d                	addiw	a2,a2,-1
    80000366:	0505                	addi	a0,a0,1
    80000368:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    8000036a:	f675                	bnez	a2,80000356 <strncmp+0x8>
  if(n == 0)
    return 0;
    8000036c:	4501                	li	a0,0
    8000036e:	a809                	j	80000380 <strncmp+0x32>
    80000370:	4501                	li	a0,0
    80000372:	a039                	j	80000380 <strncmp+0x32>
  if(n == 0)
    80000374:	ca09                	beqz	a2,80000386 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000376:	00054503          	lbu	a0,0(a0)
    8000037a:	0005c783          	lbu	a5,0(a1)
    8000037e:	9d1d                	subw	a0,a0,a5
}
    80000380:	6422                	ld	s0,8(sp)
    80000382:	0141                	addi	sp,sp,16
    80000384:	8082                	ret
    return 0;
    80000386:	4501                	li	a0,0
    80000388:	bfe5                	j	80000380 <strncmp+0x32>

000000008000038a <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    8000038a:	1141                	addi	sp,sp,-16
    8000038c:	e422                	sd	s0,8(sp)
    8000038e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000390:	872a                	mv	a4,a0
    80000392:	8832                	mv	a6,a2
    80000394:	367d                	addiw	a2,a2,-1
    80000396:	01005963          	blez	a6,800003a8 <strncpy+0x1e>
    8000039a:	0705                	addi	a4,a4,1
    8000039c:	0005c783          	lbu	a5,0(a1)
    800003a0:	fef70fa3          	sb	a5,-1(a4)
    800003a4:	0585                	addi	a1,a1,1
    800003a6:	f7f5                	bnez	a5,80000392 <strncpy+0x8>
    ;
  while(n-- > 0)
    800003a8:	86ba                	mv	a3,a4
    800003aa:	00c05c63          	blez	a2,800003c2 <strncpy+0x38>
    *s++ = 0;
    800003ae:	0685                	addi	a3,a3,1
    800003b0:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800003b4:	40d707bb          	subw	a5,a4,a3
    800003b8:	37fd                	addiw	a5,a5,-1
    800003ba:	010787bb          	addw	a5,a5,a6
    800003be:	fef048e3          	bgtz	a5,800003ae <strncpy+0x24>
  return os;
}
    800003c2:	6422                	ld	s0,8(sp)
    800003c4:	0141                	addi	sp,sp,16
    800003c6:	8082                	ret

00000000800003c8 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800003c8:	1141                	addi	sp,sp,-16
    800003ca:	e422                	sd	s0,8(sp)
    800003cc:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800003ce:	02c05363          	blez	a2,800003f4 <safestrcpy+0x2c>
    800003d2:	fff6069b          	addiw	a3,a2,-1
    800003d6:	1682                	slli	a3,a3,0x20
    800003d8:	9281                	srli	a3,a3,0x20
    800003da:	96ae                	add	a3,a3,a1
    800003dc:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800003de:	00d58963          	beq	a1,a3,800003f0 <safestrcpy+0x28>
    800003e2:	0585                	addi	a1,a1,1
    800003e4:	0785                	addi	a5,a5,1
    800003e6:	fff5c703          	lbu	a4,-1(a1)
    800003ea:	fee78fa3          	sb	a4,-1(a5)
    800003ee:	fb65                	bnez	a4,800003de <safestrcpy+0x16>
    ;
  *s = 0;
    800003f0:	00078023          	sb	zero,0(a5)
  return os;
}
    800003f4:	6422                	ld	s0,8(sp)
    800003f6:	0141                	addi	sp,sp,16
    800003f8:	8082                	ret

00000000800003fa <strlen>:

int
strlen(const char *s)
{
    800003fa:	1141                	addi	sp,sp,-16
    800003fc:	e422                	sd	s0,8(sp)
    800003fe:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000400:	00054783          	lbu	a5,0(a0)
    80000404:	cf91                	beqz	a5,80000420 <strlen+0x26>
    80000406:	0505                	addi	a0,a0,1
    80000408:	87aa                	mv	a5,a0
    8000040a:	4685                	li	a3,1
    8000040c:	9e89                	subw	a3,a3,a0
    8000040e:	00f6853b          	addw	a0,a3,a5
    80000412:	0785                	addi	a5,a5,1
    80000414:	fff7c703          	lbu	a4,-1(a5)
    80000418:	fb7d                	bnez	a4,8000040e <strlen+0x14>
    ;
  return n;
}
    8000041a:	6422                	ld	s0,8(sp)
    8000041c:	0141                	addi	sp,sp,16
    8000041e:	8082                	ret
  for(n = 0; s[n]; n++)
    80000420:	4501                	li	a0,0
    80000422:	bfe5                	j	8000041a <strlen+0x20>

0000000080000424 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000424:	1101                	addi	sp,sp,-32
    80000426:	ec06                	sd	ra,24(sp)
    80000428:	e822                	sd	s0,16(sp)
    8000042a:	e426                	sd	s1,8(sp)
    8000042c:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    8000042e:	00001097          	auipc	ra,0x1
    80000432:	afe080e7          	jalr	-1282(ra) # 80000f2c <cpuid>
    kcsaninit();
#endif
    __sync_synchronize();
    started = 1;
  } else {
    while(lockfree_read4((int *) &started) == 0)
    80000436:	00009497          	auipc	s1,0x9
    8000043a:	bca48493          	addi	s1,s1,-1078 # 80009000 <started>
  if(cpuid() == 0){
    8000043e:	c531                	beqz	a0,8000048a <main+0x66>
    while(lockfree_read4((int *) &started) == 0)
    80000440:	8526                	mv	a0,s1
    80000442:	00006097          	auipc	ra,0x6
    80000446:	406080e7          	jalr	1030(ra) # 80006848 <lockfree_read4>
    8000044a:	d97d                	beqz	a0,80000440 <main+0x1c>
      ;
    __sync_synchronize();
    8000044c:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000450:	00001097          	auipc	ra,0x1
    80000454:	adc080e7          	jalr	-1316(ra) # 80000f2c <cpuid>
    80000458:	85aa                	mv	a1,a0
    8000045a:	00008517          	auipc	a0,0x8
    8000045e:	bde50513          	addi	a0,a0,-1058 # 80008038 <etext+0x38>
    80000462:	00006097          	auipc	ra,0x6
    80000466:	cfc080e7          	jalr	-772(ra) # 8000615e <printf>
    kvminithart();    // turn on paging
    8000046a:	00000097          	auipc	ra,0x0
    8000046e:	0e0080e7          	jalr	224(ra) # 8000054a <kvminithart>
    trapinithart();   // install kernel trap vector
    80000472:	00001097          	auipc	ra,0x1
    80000476:	73c080e7          	jalr	1852(ra) # 80001bae <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000047a:	00005097          	auipc	ra,0x5
    8000047e:	e96080e7          	jalr	-362(ra) # 80005310 <plicinithart>
  }

  scheduler();        
    80000482:	00001097          	auipc	ra,0x1
    80000486:	fe8080e7          	jalr	-24(ra) # 8000146a <scheduler>
    consoleinit();
    8000048a:	00006097          	auipc	ra,0x6
    8000048e:	b9a080e7          	jalr	-1126(ra) # 80006024 <consoleinit>
    statsinit();
    80000492:	00005097          	auipc	ra,0x5
    80000496:	510080e7          	jalr	1296(ra) # 800059a2 <statsinit>
    printfinit();
    8000049a:	00006097          	auipc	ra,0x6
    8000049e:	ea4080e7          	jalr	-348(ra) # 8000633e <printfinit>
    printf("\n");
    800004a2:	00008517          	auipc	a0,0x8
    800004a6:	3c650513          	addi	a0,a0,966 # 80008868 <digits+0x88>
    800004aa:	00006097          	auipc	ra,0x6
    800004ae:	cb4080e7          	jalr	-844(ra) # 8000615e <printf>
    printf("xv6 kernel is booting\n");
    800004b2:	00008517          	auipc	a0,0x8
    800004b6:	b6e50513          	addi	a0,a0,-1170 # 80008020 <etext+0x20>
    800004ba:	00006097          	auipc	ra,0x6
    800004be:	ca4080e7          	jalr	-860(ra) # 8000615e <printf>
    printf("\n");
    800004c2:	00008517          	auipc	a0,0x8
    800004c6:	3a650513          	addi	a0,a0,934 # 80008868 <digits+0x88>
    800004ca:	00006097          	auipc	ra,0x6
    800004ce:	c94080e7          	jalr	-876(ra) # 8000615e <printf>
    kinit();         // physical page allocator
    800004d2:	00000097          	auipc	ra,0x0
    800004d6:	c3c080e7          	jalr	-964(ra) # 8000010e <kinit>
    kvminit();       // create kernel page table
    800004da:	00000097          	auipc	ra,0x0
    800004de:	322080e7          	jalr	802(ra) # 800007fc <kvminit>
    kvminithart();   // turn on paging
    800004e2:	00000097          	auipc	ra,0x0
    800004e6:	068080e7          	jalr	104(ra) # 8000054a <kvminithart>
    procinit();      // process table
    800004ea:	00001097          	auipc	ra,0x1
    800004ee:	992080e7          	jalr	-1646(ra) # 80000e7c <procinit>
    trapinit();      // trap vectors
    800004f2:	00001097          	auipc	ra,0x1
    800004f6:	694080e7          	jalr	1684(ra) # 80001b86 <trapinit>
    trapinithart();  // install kernel trap vector
    800004fa:	00001097          	auipc	ra,0x1
    800004fe:	6b4080e7          	jalr	1716(ra) # 80001bae <trapinithart>
    plicinit();      // set up interrupt controller
    80000502:	00005097          	auipc	ra,0x5
    80000506:	df8080e7          	jalr	-520(ra) # 800052fa <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    8000050a:	00005097          	auipc	ra,0x5
    8000050e:	e06080e7          	jalr	-506(ra) # 80005310 <plicinithart>
    binit();         // buffer cache
    80000512:	00002097          	auipc	ra,0x2
    80000516:	dde080e7          	jalr	-546(ra) # 800022f0 <binit>
    iinit();         // inode table
    8000051a:	00002097          	auipc	ra,0x2
    8000051e:	646080e7          	jalr	1606(ra) # 80002b60 <iinit>
    fileinit();      // file table
    80000522:	00003097          	auipc	ra,0x3
    80000526:	5f8080e7          	jalr	1528(ra) # 80003b1a <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000052a:	00005097          	auipc	ra,0x5
    8000052e:	f06080e7          	jalr	-250(ra) # 80005430 <virtio_disk_init>
    userinit();      // first user process
    80000532:	00001097          	auipc	ra,0x1
    80000536:	cfe080e7          	jalr	-770(ra) # 80001230 <userinit>
    __sync_synchronize();
    8000053a:	0ff0000f          	fence
    started = 1;
    8000053e:	4785                	li	a5,1
    80000540:	00009717          	auipc	a4,0x9
    80000544:	acf72023          	sw	a5,-1344(a4) # 80009000 <started>
    80000548:	bf2d                	j	80000482 <main+0x5e>

000000008000054a <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000054a:	1141                	addi	sp,sp,-16
    8000054c:	e422                	sd	s0,8(sp)
    8000054e:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80000550:	00009797          	auipc	a5,0x9
    80000554:	ab87b783          	ld	a5,-1352(a5) # 80009008 <kernel_pagetable>
    80000558:	83b1                	srli	a5,a5,0xc
    8000055a:	577d                	li	a4,-1
    8000055c:	177e                	slli	a4,a4,0x3f
    8000055e:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    80000560:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000564:	12000073          	sfence.vma
  sfence_vma();
}
    80000568:	6422                	ld	s0,8(sp)
    8000056a:	0141                	addi	sp,sp,16
    8000056c:	8082                	ret

000000008000056e <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    8000056e:	7139                	addi	sp,sp,-64
    80000570:	fc06                	sd	ra,56(sp)
    80000572:	f822                	sd	s0,48(sp)
    80000574:	f426                	sd	s1,40(sp)
    80000576:	f04a                	sd	s2,32(sp)
    80000578:	ec4e                	sd	s3,24(sp)
    8000057a:	e852                	sd	s4,16(sp)
    8000057c:	e456                	sd	s5,8(sp)
    8000057e:	e05a                	sd	s6,0(sp)
    80000580:	0080                	addi	s0,sp,64
    80000582:	84aa                	mv	s1,a0
    80000584:	89ae                	mv	s3,a1
    80000586:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000588:	57fd                	li	a5,-1
    8000058a:	83e9                	srli	a5,a5,0x1a
    8000058c:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    8000058e:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000590:	04b7f263          	bgeu	a5,a1,800005d4 <walk+0x66>
    panic("walk");
    80000594:	00008517          	auipc	a0,0x8
    80000598:	abc50513          	addi	a0,a0,-1348 # 80008050 <etext+0x50>
    8000059c:	00006097          	auipc	ra,0x6
    800005a0:	b78080e7          	jalr	-1160(ra) # 80006114 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800005a4:	060a8663          	beqz	s5,80000610 <walk+0xa2>
    800005a8:	00000097          	auipc	ra,0x0
    800005ac:	bce080e7          	jalr	-1074(ra) # 80000176 <kalloc>
    800005b0:	84aa                	mv	s1,a0
    800005b2:	c529                	beqz	a0,800005fc <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800005b4:	6605                	lui	a2,0x1
    800005b6:	4581                	li	a1,0
    800005b8:	00000097          	auipc	ra,0x0
    800005bc:	cc6080e7          	jalr	-826(ra) # 8000027e <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800005c0:	00c4d793          	srli	a5,s1,0xc
    800005c4:	07aa                	slli	a5,a5,0xa
    800005c6:	0017e793          	ori	a5,a5,1
    800005ca:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800005ce:	3a5d                	addiw	s4,s4,-9
    800005d0:	036a0063          	beq	s4,s6,800005f0 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800005d4:	0149d933          	srl	s2,s3,s4
    800005d8:	1ff97913          	andi	s2,s2,511
    800005dc:	090e                	slli	s2,s2,0x3
    800005de:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800005e0:	00093483          	ld	s1,0(s2)
    800005e4:	0014f793          	andi	a5,s1,1
    800005e8:	dfd5                	beqz	a5,800005a4 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800005ea:	80a9                	srli	s1,s1,0xa
    800005ec:	04b2                	slli	s1,s1,0xc
    800005ee:	b7c5                	j	800005ce <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800005f0:	00c9d513          	srli	a0,s3,0xc
    800005f4:	1ff57513          	andi	a0,a0,511
    800005f8:	050e                	slli	a0,a0,0x3
    800005fa:	9526                	add	a0,a0,s1
}
    800005fc:	70e2                	ld	ra,56(sp)
    800005fe:	7442                	ld	s0,48(sp)
    80000600:	74a2                	ld	s1,40(sp)
    80000602:	7902                	ld	s2,32(sp)
    80000604:	69e2                	ld	s3,24(sp)
    80000606:	6a42                	ld	s4,16(sp)
    80000608:	6aa2                	ld	s5,8(sp)
    8000060a:	6b02                	ld	s6,0(sp)
    8000060c:	6121                	addi	sp,sp,64
    8000060e:	8082                	ret
        return 0;
    80000610:	4501                	li	a0,0
    80000612:	b7ed                	j	800005fc <walk+0x8e>

0000000080000614 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000614:	57fd                	li	a5,-1
    80000616:	83e9                	srli	a5,a5,0x1a
    80000618:	00b7f463          	bgeu	a5,a1,80000620 <walkaddr+0xc>
    return 0;
    8000061c:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000061e:	8082                	ret
{
    80000620:	1141                	addi	sp,sp,-16
    80000622:	e406                	sd	ra,8(sp)
    80000624:	e022                	sd	s0,0(sp)
    80000626:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000628:	4601                	li	a2,0
    8000062a:	00000097          	auipc	ra,0x0
    8000062e:	f44080e7          	jalr	-188(ra) # 8000056e <walk>
  if(pte == 0)
    80000632:	c105                	beqz	a0,80000652 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000634:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000636:	0117f693          	andi	a3,a5,17
    8000063a:	4745                	li	a4,17
    return 0;
    8000063c:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000063e:	00e68663          	beq	a3,a4,8000064a <walkaddr+0x36>
}
    80000642:	60a2                	ld	ra,8(sp)
    80000644:	6402                	ld	s0,0(sp)
    80000646:	0141                	addi	sp,sp,16
    80000648:	8082                	ret
  pa = PTE2PA(*pte);
    8000064a:	83a9                	srli	a5,a5,0xa
    8000064c:	00c79513          	slli	a0,a5,0xc
  return pa;
    80000650:	bfcd                	j	80000642 <walkaddr+0x2e>
    return 0;
    80000652:	4501                	li	a0,0
    80000654:	b7fd                	j	80000642 <walkaddr+0x2e>

0000000080000656 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000656:	715d                	addi	sp,sp,-80
    80000658:	e486                	sd	ra,72(sp)
    8000065a:	e0a2                	sd	s0,64(sp)
    8000065c:	fc26                	sd	s1,56(sp)
    8000065e:	f84a                	sd	s2,48(sp)
    80000660:	f44e                	sd	s3,40(sp)
    80000662:	f052                	sd	s4,32(sp)
    80000664:	ec56                	sd	s5,24(sp)
    80000666:	e85a                	sd	s6,16(sp)
    80000668:	e45e                	sd	s7,8(sp)
    8000066a:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    8000066c:	c639                	beqz	a2,800006ba <mappages+0x64>
    8000066e:	8aaa                	mv	s5,a0
    80000670:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80000672:	777d                	lui	a4,0xfffff
    80000674:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    80000678:	fff58993          	addi	s3,a1,-1
    8000067c:	99b2                	add	s3,s3,a2
    8000067e:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    80000682:	893e                	mv	s2,a5
    80000684:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000688:	6b85                	lui	s7,0x1
    8000068a:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    8000068e:	4605                	li	a2,1
    80000690:	85ca                	mv	a1,s2
    80000692:	8556                	mv	a0,s5
    80000694:	00000097          	auipc	ra,0x0
    80000698:	eda080e7          	jalr	-294(ra) # 8000056e <walk>
    8000069c:	cd1d                	beqz	a0,800006da <mappages+0x84>
    if(*pte & PTE_V)
    8000069e:	611c                	ld	a5,0(a0)
    800006a0:	8b85                	andi	a5,a5,1
    800006a2:	e785                	bnez	a5,800006ca <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800006a4:	80b1                	srli	s1,s1,0xc
    800006a6:	04aa                	slli	s1,s1,0xa
    800006a8:	0164e4b3          	or	s1,s1,s6
    800006ac:	0014e493          	ori	s1,s1,1
    800006b0:	e104                	sd	s1,0(a0)
    if(a == last)
    800006b2:	05390063          	beq	s2,s3,800006f2 <mappages+0x9c>
    a += PGSIZE;
    800006b6:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800006b8:	bfc9                	j	8000068a <mappages+0x34>
    panic("mappages: size");
    800006ba:	00008517          	auipc	a0,0x8
    800006be:	99e50513          	addi	a0,a0,-1634 # 80008058 <etext+0x58>
    800006c2:	00006097          	auipc	ra,0x6
    800006c6:	a52080e7          	jalr	-1454(ra) # 80006114 <panic>
      panic("mappages: remap");
    800006ca:	00008517          	auipc	a0,0x8
    800006ce:	99e50513          	addi	a0,a0,-1634 # 80008068 <etext+0x68>
    800006d2:	00006097          	auipc	ra,0x6
    800006d6:	a42080e7          	jalr	-1470(ra) # 80006114 <panic>
      return -1;
    800006da:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800006dc:	60a6                	ld	ra,72(sp)
    800006de:	6406                	ld	s0,64(sp)
    800006e0:	74e2                	ld	s1,56(sp)
    800006e2:	7942                	ld	s2,48(sp)
    800006e4:	79a2                	ld	s3,40(sp)
    800006e6:	7a02                	ld	s4,32(sp)
    800006e8:	6ae2                	ld	s5,24(sp)
    800006ea:	6b42                	ld	s6,16(sp)
    800006ec:	6ba2                	ld	s7,8(sp)
    800006ee:	6161                	addi	sp,sp,80
    800006f0:	8082                	ret
  return 0;
    800006f2:	4501                	li	a0,0
    800006f4:	b7e5                	j	800006dc <mappages+0x86>

00000000800006f6 <kvmmap>:
{
    800006f6:	1141                	addi	sp,sp,-16
    800006f8:	e406                	sd	ra,8(sp)
    800006fa:	e022                	sd	s0,0(sp)
    800006fc:	0800                	addi	s0,sp,16
    800006fe:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80000700:	86b2                	mv	a3,a2
    80000702:	863e                	mv	a2,a5
    80000704:	00000097          	auipc	ra,0x0
    80000708:	f52080e7          	jalr	-174(ra) # 80000656 <mappages>
    8000070c:	e509                	bnez	a0,80000716 <kvmmap+0x20>
}
    8000070e:	60a2                	ld	ra,8(sp)
    80000710:	6402                	ld	s0,0(sp)
    80000712:	0141                	addi	sp,sp,16
    80000714:	8082                	ret
    panic("kvmmap");
    80000716:	00008517          	auipc	a0,0x8
    8000071a:	96250513          	addi	a0,a0,-1694 # 80008078 <etext+0x78>
    8000071e:	00006097          	auipc	ra,0x6
    80000722:	9f6080e7          	jalr	-1546(ra) # 80006114 <panic>

0000000080000726 <kvmmake>:
{
    80000726:	1101                	addi	sp,sp,-32
    80000728:	ec06                	sd	ra,24(sp)
    8000072a:	e822                	sd	s0,16(sp)
    8000072c:	e426                	sd	s1,8(sp)
    8000072e:	e04a                	sd	s2,0(sp)
    80000730:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000732:	00000097          	auipc	ra,0x0
    80000736:	a44080e7          	jalr	-1468(ra) # 80000176 <kalloc>
    8000073a:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000073c:	6605                	lui	a2,0x1
    8000073e:	4581                	li	a1,0
    80000740:	00000097          	auipc	ra,0x0
    80000744:	b3e080e7          	jalr	-1218(ra) # 8000027e <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000748:	4719                	li	a4,6
    8000074a:	6685                	lui	a3,0x1
    8000074c:	10000637          	lui	a2,0x10000
    80000750:	100005b7          	lui	a1,0x10000
    80000754:	8526                	mv	a0,s1
    80000756:	00000097          	auipc	ra,0x0
    8000075a:	fa0080e7          	jalr	-96(ra) # 800006f6 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000075e:	4719                	li	a4,6
    80000760:	6685                	lui	a3,0x1
    80000762:	10001637          	lui	a2,0x10001
    80000766:	100015b7          	lui	a1,0x10001
    8000076a:	8526                	mv	a0,s1
    8000076c:	00000097          	auipc	ra,0x0
    80000770:	f8a080e7          	jalr	-118(ra) # 800006f6 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000774:	4719                	li	a4,6
    80000776:	004006b7          	lui	a3,0x400
    8000077a:	0c000637          	lui	a2,0xc000
    8000077e:	0c0005b7          	lui	a1,0xc000
    80000782:	8526                	mv	a0,s1
    80000784:	00000097          	auipc	ra,0x0
    80000788:	f72080e7          	jalr	-142(ra) # 800006f6 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000078c:	00008917          	auipc	s2,0x8
    80000790:	87490913          	addi	s2,s2,-1932 # 80008000 <etext>
    80000794:	4729                	li	a4,10
    80000796:	80008697          	auipc	a3,0x80008
    8000079a:	86a68693          	addi	a3,a3,-1942 # 8000 <_entry-0x7fff8000>
    8000079e:	4605                	li	a2,1
    800007a0:	067e                	slli	a2,a2,0x1f
    800007a2:	85b2                	mv	a1,a2
    800007a4:	8526                	mv	a0,s1
    800007a6:	00000097          	auipc	ra,0x0
    800007aa:	f50080e7          	jalr	-176(ra) # 800006f6 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800007ae:	4719                	li	a4,6
    800007b0:	46c5                	li	a3,17
    800007b2:	06ee                	slli	a3,a3,0x1b
    800007b4:	412686b3          	sub	a3,a3,s2
    800007b8:	864a                	mv	a2,s2
    800007ba:	85ca                	mv	a1,s2
    800007bc:	8526                	mv	a0,s1
    800007be:	00000097          	auipc	ra,0x0
    800007c2:	f38080e7          	jalr	-200(ra) # 800006f6 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800007c6:	4729                	li	a4,10
    800007c8:	6685                	lui	a3,0x1
    800007ca:	00007617          	auipc	a2,0x7
    800007ce:	83660613          	addi	a2,a2,-1994 # 80007000 <_trampoline>
    800007d2:	040005b7          	lui	a1,0x4000
    800007d6:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800007d8:	05b2                	slli	a1,a1,0xc
    800007da:	8526                	mv	a0,s1
    800007dc:	00000097          	auipc	ra,0x0
    800007e0:	f1a080e7          	jalr	-230(ra) # 800006f6 <kvmmap>
  proc_mapstacks(kpgtbl);
    800007e4:	8526                	mv	a0,s1
    800007e6:	00000097          	auipc	ra,0x0
    800007ea:	600080e7          	jalr	1536(ra) # 80000de6 <proc_mapstacks>
}
    800007ee:	8526                	mv	a0,s1
    800007f0:	60e2                	ld	ra,24(sp)
    800007f2:	6442                	ld	s0,16(sp)
    800007f4:	64a2                	ld	s1,8(sp)
    800007f6:	6902                	ld	s2,0(sp)
    800007f8:	6105                	addi	sp,sp,32
    800007fa:	8082                	ret

00000000800007fc <kvminit>:
{
    800007fc:	1141                	addi	sp,sp,-16
    800007fe:	e406                	sd	ra,8(sp)
    80000800:	e022                	sd	s0,0(sp)
    80000802:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80000804:	00000097          	auipc	ra,0x0
    80000808:	f22080e7          	jalr	-222(ra) # 80000726 <kvmmake>
    8000080c:	00008797          	auipc	a5,0x8
    80000810:	7ea7be23          	sd	a0,2044(a5) # 80009008 <kernel_pagetable>
}
    80000814:	60a2                	ld	ra,8(sp)
    80000816:	6402                	ld	s0,0(sp)
    80000818:	0141                	addi	sp,sp,16
    8000081a:	8082                	ret

000000008000081c <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000081c:	715d                	addi	sp,sp,-80
    8000081e:	e486                	sd	ra,72(sp)
    80000820:	e0a2                	sd	s0,64(sp)
    80000822:	fc26                	sd	s1,56(sp)
    80000824:	f84a                	sd	s2,48(sp)
    80000826:	f44e                	sd	s3,40(sp)
    80000828:	f052                	sd	s4,32(sp)
    8000082a:	ec56                	sd	s5,24(sp)
    8000082c:	e85a                	sd	s6,16(sp)
    8000082e:	e45e                	sd	s7,8(sp)
    80000830:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000832:	03459793          	slli	a5,a1,0x34
    80000836:	e795                	bnez	a5,80000862 <uvmunmap+0x46>
    80000838:	8a2a                	mv	s4,a0
    8000083a:	892e                	mv	s2,a1
    8000083c:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000083e:	0632                	slli	a2,a2,0xc
    80000840:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000844:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000846:	6b05                	lui	s6,0x1
    80000848:	0735e263          	bltu	a1,s3,800008ac <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    8000084c:	60a6                	ld	ra,72(sp)
    8000084e:	6406                	ld	s0,64(sp)
    80000850:	74e2                	ld	s1,56(sp)
    80000852:	7942                	ld	s2,48(sp)
    80000854:	79a2                	ld	s3,40(sp)
    80000856:	7a02                	ld	s4,32(sp)
    80000858:	6ae2                	ld	s5,24(sp)
    8000085a:	6b42                	ld	s6,16(sp)
    8000085c:	6ba2                	ld	s7,8(sp)
    8000085e:	6161                	addi	sp,sp,80
    80000860:	8082                	ret
    panic("uvmunmap: not aligned");
    80000862:	00008517          	auipc	a0,0x8
    80000866:	81e50513          	addi	a0,a0,-2018 # 80008080 <etext+0x80>
    8000086a:	00006097          	auipc	ra,0x6
    8000086e:	8aa080e7          	jalr	-1878(ra) # 80006114 <panic>
      panic("uvmunmap: walk");
    80000872:	00008517          	auipc	a0,0x8
    80000876:	82650513          	addi	a0,a0,-2010 # 80008098 <etext+0x98>
    8000087a:	00006097          	auipc	ra,0x6
    8000087e:	89a080e7          	jalr	-1894(ra) # 80006114 <panic>
      panic("uvmunmap: not mapped");
    80000882:	00008517          	auipc	a0,0x8
    80000886:	82650513          	addi	a0,a0,-2010 # 800080a8 <etext+0xa8>
    8000088a:	00006097          	auipc	ra,0x6
    8000088e:	88a080e7          	jalr	-1910(ra) # 80006114 <panic>
      panic("uvmunmap: not a leaf");
    80000892:	00008517          	auipc	a0,0x8
    80000896:	82e50513          	addi	a0,a0,-2002 # 800080c0 <etext+0xc0>
    8000089a:	00006097          	auipc	ra,0x6
    8000089e:	87a080e7          	jalr	-1926(ra) # 80006114 <panic>
    *pte = 0;
    800008a2:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800008a6:	995a                	add	s2,s2,s6
    800008a8:	fb3972e3          	bgeu	s2,s3,8000084c <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800008ac:	4601                	li	a2,0
    800008ae:	85ca                	mv	a1,s2
    800008b0:	8552                	mv	a0,s4
    800008b2:	00000097          	auipc	ra,0x0
    800008b6:	cbc080e7          	jalr	-836(ra) # 8000056e <walk>
    800008ba:	84aa                	mv	s1,a0
    800008bc:	d95d                	beqz	a0,80000872 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800008be:	6108                	ld	a0,0(a0)
    800008c0:	00157793          	andi	a5,a0,1
    800008c4:	dfdd                	beqz	a5,80000882 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800008c6:	3ff57793          	andi	a5,a0,1023
    800008ca:	fd7784e3          	beq	a5,s7,80000892 <uvmunmap+0x76>
    if(do_free){
    800008ce:	fc0a8ae3          	beqz	s5,800008a2 <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    800008d2:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800008d4:	0532                	slli	a0,a0,0xc
    800008d6:	fffff097          	auipc	ra,0xfffff
    800008da:	746080e7          	jalr	1862(ra) # 8000001c <kfree>
    800008de:	b7d1                	j	800008a2 <uvmunmap+0x86>

00000000800008e0 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800008e0:	1101                	addi	sp,sp,-32
    800008e2:	ec06                	sd	ra,24(sp)
    800008e4:	e822                	sd	s0,16(sp)
    800008e6:	e426                	sd	s1,8(sp)
    800008e8:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800008ea:	00000097          	auipc	ra,0x0
    800008ee:	88c080e7          	jalr	-1908(ra) # 80000176 <kalloc>
    800008f2:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800008f4:	c519                	beqz	a0,80000902 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800008f6:	6605                	lui	a2,0x1
    800008f8:	4581                	li	a1,0
    800008fa:	00000097          	auipc	ra,0x0
    800008fe:	984080e7          	jalr	-1660(ra) # 8000027e <memset>
  return pagetable;
}
    80000902:	8526                	mv	a0,s1
    80000904:	60e2                	ld	ra,24(sp)
    80000906:	6442                	ld	s0,16(sp)
    80000908:	64a2                	ld	s1,8(sp)
    8000090a:	6105                	addi	sp,sp,32
    8000090c:	8082                	ret

000000008000090e <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    8000090e:	7179                	addi	sp,sp,-48
    80000910:	f406                	sd	ra,40(sp)
    80000912:	f022                	sd	s0,32(sp)
    80000914:	ec26                	sd	s1,24(sp)
    80000916:	e84a                	sd	s2,16(sp)
    80000918:	e44e                	sd	s3,8(sp)
    8000091a:	e052                	sd	s4,0(sp)
    8000091c:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000091e:	6785                	lui	a5,0x1
    80000920:	04f67863          	bgeu	a2,a5,80000970 <uvminit+0x62>
    80000924:	8a2a                	mv	s4,a0
    80000926:	89ae                	mv	s3,a1
    80000928:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    8000092a:	00000097          	auipc	ra,0x0
    8000092e:	84c080e7          	jalr	-1972(ra) # 80000176 <kalloc>
    80000932:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000934:	6605                	lui	a2,0x1
    80000936:	4581                	li	a1,0
    80000938:	00000097          	auipc	ra,0x0
    8000093c:	946080e7          	jalr	-1722(ra) # 8000027e <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000940:	4779                	li	a4,30
    80000942:	86ca                	mv	a3,s2
    80000944:	6605                	lui	a2,0x1
    80000946:	4581                	li	a1,0
    80000948:	8552                	mv	a0,s4
    8000094a:	00000097          	auipc	ra,0x0
    8000094e:	d0c080e7          	jalr	-756(ra) # 80000656 <mappages>
  memmove(mem, src, sz);
    80000952:	8626                	mv	a2,s1
    80000954:	85ce                	mv	a1,s3
    80000956:	854a                	mv	a0,s2
    80000958:	00000097          	auipc	ra,0x0
    8000095c:	982080e7          	jalr	-1662(ra) # 800002da <memmove>
}
    80000960:	70a2                	ld	ra,40(sp)
    80000962:	7402                	ld	s0,32(sp)
    80000964:	64e2                	ld	s1,24(sp)
    80000966:	6942                	ld	s2,16(sp)
    80000968:	69a2                	ld	s3,8(sp)
    8000096a:	6a02                	ld	s4,0(sp)
    8000096c:	6145                	addi	sp,sp,48
    8000096e:	8082                	ret
    panic("inituvm: more than a page");
    80000970:	00007517          	auipc	a0,0x7
    80000974:	76850513          	addi	a0,a0,1896 # 800080d8 <etext+0xd8>
    80000978:	00005097          	auipc	ra,0x5
    8000097c:	79c080e7          	jalr	1948(ra) # 80006114 <panic>

0000000080000980 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000980:	1101                	addi	sp,sp,-32
    80000982:	ec06                	sd	ra,24(sp)
    80000984:	e822                	sd	s0,16(sp)
    80000986:	e426                	sd	s1,8(sp)
    80000988:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000098a:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000098c:	00b67d63          	bgeu	a2,a1,800009a6 <uvmdealloc+0x26>
    80000990:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000992:	6785                	lui	a5,0x1
    80000994:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000996:	00f60733          	add	a4,a2,a5
    8000099a:	76fd                	lui	a3,0xfffff
    8000099c:	8f75                	and	a4,a4,a3
    8000099e:	97ae                	add	a5,a5,a1
    800009a0:	8ff5                	and	a5,a5,a3
    800009a2:	00f76863          	bltu	a4,a5,800009b2 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800009a6:	8526                	mv	a0,s1
    800009a8:	60e2                	ld	ra,24(sp)
    800009aa:	6442                	ld	s0,16(sp)
    800009ac:	64a2                	ld	s1,8(sp)
    800009ae:	6105                	addi	sp,sp,32
    800009b0:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800009b2:	8f99                	sub	a5,a5,a4
    800009b4:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800009b6:	4685                	li	a3,1
    800009b8:	0007861b          	sext.w	a2,a5
    800009bc:	85ba                	mv	a1,a4
    800009be:	00000097          	auipc	ra,0x0
    800009c2:	e5e080e7          	jalr	-418(ra) # 8000081c <uvmunmap>
    800009c6:	b7c5                	j	800009a6 <uvmdealloc+0x26>

00000000800009c8 <uvmalloc>:
  if(newsz < oldsz)
    800009c8:	0ab66163          	bltu	a2,a1,80000a6a <uvmalloc+0xa2>
{
    800009cc:	7139                	addi	sp,sp,-64
    800009ce:	fc06                	sd	ra,56(sp)
    800009d0:	f822                	sd	s0,48(sp)
    800009d2:	f426                	sd	s1,40(sp)
    800009d4:	f04a                	sd	s2,32(sp)
    800009d6:	ec4e                	sd	s3,24(sp)
    800009d8:	e852                	sd	s4,16(sp)
    800009da:	e456                	sd	s5,8(sp)
    800009dc:	0080                	addi	s0,sp,64
    800009de:	8aaa                	mv	s5,a0
    800009e0:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800009e2:	6785                	lui	a5,0x1
    800009e4:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800009e6:	95be                	add	a1,a1,a5
    800009e8:	77fd                	lui	a5,0xfffff
    800009ea:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    800009ee:	08c9f063          	bgeu	s3,a2,80000a6e <uvmalloc+0xa6>
    800009f2:	894e                	mv	s2,s3
    mem = kalloc();
    800009f4:	fffff097          	auipc	ra,0xfffff
    800009f8:	782080e7          	jalr	1922(ra) # 80000176 <kalloc>
    800009fc:	84aa                	mv	s1,a0
    if(mem == 0){
    800009fe:	c51d                	beqz	a0,80000a2c <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    80000a00:	6605                	lui	a2,0x1
    80000a02:	4581                	li	a1,0
    80000a04:	00000097          	auipc	ra,0x0
    80000a08:	87a080e7          	jalr	-1926(ra) # 8000027e <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    80000a0c:	4779                	li	a4,30
    80000a0e:	86a6                	mv	a3,s1
    80000a10:	6605                	lui	a2,0x1
    80000a12:	85ca                	mv	a1,s2
    80000a14:	8556                	mv	a0,s5
    80000a16:	00000097          	auipc	ra,0x0
    80000a1a:	c40080e7          	jalr	-960(ra) # 80000656 <mappages>
    80000a1e:	e905                	bnez	a0,80000a4e <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000a20:	6785                	lui	a5,0x1
    80000a22:	993e                	add	s2,s2,a5
    80000a24:	fd4968e3          	bltu	s2,s4,800009f4 <uvmalloc+0x2c>
  return newsz;
    80000a28:	8552                	mv	a0,s4
    80000a2a:	a809                	j	80000a3c <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80000a2c:	864e                	mv	a2,s3
    80000a2e:	85ca                	mv	a1,s2
    80000a30:	8556                	mv	a0,s5
    80000a32:	00000097          	auipc	ra,0x0
    80000a36:	f4e080e7          	jalr	-178(ra) # 80000980 <uvmdealloc>
      return 0;
    80000a3a:	4501                	li	a0,0
}
    80000a3c:	70e2                	ld	ra,56(sp)
    80000a3e:	7442                	ld	s0,48(sp)
    80000a40:	74a2                	ld	s1,40(sp)
    80000a42:	7902                	ld	s2,32(sp)
    80000a44:	69e2                	ld	s3,24(sp)
    80000a46:	6a42                	ld	s4,16(sp)
    80000a48:	6aa2                	ld	s5,8(sp)
    80000a4a:	6121                	addi	sp,sp,64
    80000a4c:	8082                	ret
      kfree(mem);
    80000a4e:	8526                	mv	a0,s1
    80000a50:	fffff097          	auipc	ra,0xfffff
    80000a54:	5cc080e7          	jalr	1484(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000a58:	864e                	mv	a2,s3
    80000a5a:	85ca                	mv	a1,s2
    80000a5c:	8556                	mv	a0,s5
    80000a5e:	00000097          	auipc	ra,0x0
    80000a62:	f22080e7          	jalr	-222(ra) # 80000980 <uvmdealloc>
      return 0;
    80000a66:	4501                	li	a0,0
    80000a68:	bfd1                	j	80000a3c <uvmalloc+0x74>
    return oldsz;
    80000a6a:	852e                	mv	a0,a1
}
    80000a6c:	8082                	ret
  return newsz;
    80000a6e:	8532                	mv	a0,a2
    80000a70:	b7f1                	j	80000a3c <uvmalloc+0x74>

0000000080000a72 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000a72:	7179                	addi	sp,sp,-48
    80000a74:	f406                	sd	ra,40(sp)
    80000a76:	f022                	sd	s0,32(sp)
    80000a78:	ec26                	sd	s1,24(sp)
    80000a7a:	e84a                	sd	s2,16(sp)
    80000a7c:	e44e                	sd	s3,8(sp)
    80000a7e:	e052                	sd	s4,0(sp)
    80000a80:	1800                	addi	s0,sp,48
    80000a82:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000a84:	84aa                	mv	s1,a0
    80000a86:	6905                	lui	s2,0x1
    80000a88:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000a8a:	4985                	li	s3,1
    80000a8c:	a829                	j	80000aa6 <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000a8e:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80000a90:	00c79513          	slli	a0,a5,0xc
    80000a94:	00000097          	auipc	ra,0x0
    80000a98:	fde080e7          	jalr	-34(ra) # 80000a72 <freewalk>
      pagetable[i] = 0;
    80000a9c:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000aa0:	04a1                	addi	s1,s1,8
    80000aa2:	03248163          	beq	s1,s2,80000ac4 <freewalk+0x52>
    pte_t pte = pagetable[i];
    80000aa6:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000aa8:	00f7f713          	andi	a4,a5,15
    80000aac:	ff3701e3          	beq	a4,s3,80000a8e <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000ab0:	8b85                	andi	a5,a5,1
    80000ab2:	d7fd                	beqz	a5,80000aa0 <freewalk+0x2e>
      panic("freewalk: leaf");
    80000ab4:	00007517          	auipc	a0,0x7
    80000ab8:	64450513          	addi	a0,a0,1604 # 800080f8 <etext+0xf8>
    80000abc:	00005097          	auipc	ra,0x5
    80000ac0:	658080e7          	jalr	1624(ra) # 80006114 <panic>
    }
  }
  kfree((void*)pagetable);
    80000ac4:	8552                	mv	a0,s4
    80000ac6:	fffff097          	auipc	ra,0xfffff
    80000aca:	556080e7          	jalr	1366(ra) # 8000001c <kfree>
}
    80000ace:	70a2                	ld	ra,40(sp)
    80000ad0:	7402                	ld	s0,32(sp)
    80000ad2:	64e2                	ld	s1,24(sp)
    80000ad4:	6942                	ld	s2,16(sp)
    80000ad6:	69a2                	ld	s3,8(sp)
    80000ad8:	6a02                	ld	s4,0(sp)
    80000ada:	6145                	addi	sp,sp,48
    80000adc:	8082                	ret

0000000080000ade <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000ade:	1101                	addi	sp,sp,-32
    80000ae0:	ec06                	sd	ra,24(sp)
    80000ae2:	e822                	sd	s0,16(sp)
    80000ae4:	e426                	sd	s1,8(sp)
    80000ae6:	1000                	addi	s0,sp,32
    80000ae8:	84aa                	mv	s1,a0
  if(sz > 0)
    80000aea:	e999                	bnez	a1,80000b00 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000aec:	8526                	mv	a0,s1
    80000aee:	00000097          	auipc	ra,0x0
    80000af2:	f84080e7          	jalr	-124(ra) # 80000a72 <freewalk>
}
    80000af6:	60e2                	ld	ra,24(sp)
    80000af8:	6442                	ld	s0,16(sp)
    80000afa:	64a2                	ld	s1,8(sp)
    80000afc:	6105                	addi	sp,sp,32
    80000afe:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000b00:	6785                	lui	a5,0x1
    80000b02:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000b04:	95be                	add	a1,a1,a5
    80000b06:	4685                	li	a3,1
    80000b08:	00c5d613          	srli	a2,a1,0xc
    80000b0c:	4581                	li	a1,0
    80000b0e:	00000097          	auipc	ra,0x0
    80000b12:	d0e080e7          	jalr	-754(ra) # 8000081c <uvmunmap>
    80000b16:	bfd9                	j	80000aec <uvmfree+0xe>

0000000080000b18 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000b18:	c679                	beqz	a2,80000be6 <uvmcopy+0xce>
{
    80000b1a:	715d                	addi	sp,sp,-80
    80000b1c:	e486                	sd	ra,72(sp)
    80000b1e:	e0a2                	sd	s0,64(sp)
    80000b20:	fc26                	sd	s1,56(sp)
    80000b22:	f84a                	sd	s2,48(sp)
    80000b24:	f44e                	sd	s3,40(sp)
    80000b26:	f052                	sd	s4,32(sp)
    80000b28:	ec56                	sd	s5,24(sp)
    80000b2a:	e85a                	sd	s6,16(sp)
    80000b2c:	e45e                	sd	s7,8(sp)
    80000b2e:	0880                	addi	s0,sp,80
    80000b30:	8b2a                	mv	s6,a0
    80000b32:	8aae                	mv	s5,a1
    80000b34:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000b36:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000b38:	4601                	li	a2,0
    80000b3a:	85ce                	mv	a1,s3
    80000b3c:	855a                	mv	a0,s6
    80000b3e:	00000097          	auipc	ra,0x0
    80000b42:	a30080e7          	jalr	-1488(ra) # 8000056e <walk>
    80000b46:	c531                	beqz	a0,80000b92 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000b48:	6118                	ld	a4,0(a0)
    80000b4a:	00177793          	andi	a5,a4,1
    80000b4e:	cbb1                	beqz	a5,80000ba2 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000b50:	00a75593          	srli	a1,a4,0xa
    80000b54:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000b58:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000b5c:	fffff097          	auipc	ra,0xfffff
    80000b60:	61a080e7          	jalr	1562(ra) # 80000176 <kalloc>
    80000b64:	892a                	mv	s2,a0
    80000b66:	c939                	beqz	a0,80000bbc <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000b68:	6605                	lui	a2,0x1
    80000b6a:	85de                	mv	a1,s7
    80000b6c:	fffff097          	auipc	ra,0xfffff
    80000b70:	76e080e7          	jalr	1902(ra) # 800002da <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000b74:	8726                	mv	a4,s1
    80000b76:	86ca                	mv	a3,s2
    80000b78:	6605                	lui	a2,0x1
    80000b7a:	85ce                	mv	a1,s3
    80000b7c:	8556                	mv	a0,s5
    80000b7e:	00000097          	auipc	ra,0x0
    80000b82:	ad8080e7          	jalr	-1320(ra) # 80000656 <mappages>
    80000b86:	e515                	bnez	a0,80000bb2 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000b88:	6785                	lui	a5,0x1
    80000b8a:	99be                	add	s3,s3,a5
    80000b8c:	fb49e6e3          	bltu	s3,s4,80000b38 <uvmcopy+0x20>
    80000b90:	a081                	j	80000bd0 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000b92:	00007517          	auipc	a0,0x7
    80000b96:	57650513          	addi	a0,a0,1398 # 80008108 <etext+0x108>
    80000b9a:	00005097          	auipc	ra,0x5
    80000b9e:	57a080e7          	jalr	1402(ra) # 80006114 <panic>
      panic("uvmcopy: page not present");
    80000ba2:	00007517          	auipc	a0,0x7
    80000ba6:	58650513          	addi	a0,a0,1414 # 80008128 <etext+0x128>
    80000baa:	00005097          	auipc	ra,0x5
    80000bae:	56a080e7          	jalr	1386(ra) # 80006114 <panic>
      kfree(mem);
    80000bb2:	854a                	mv	a0,s2
    80000bb4:	fffff097          	auipc	ra,0xfffff
    80000bb8:	468080e7          	jalr	1128(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000bbc:	4685                	li	a3,1
    80000bbe:	00c9d613          	srli	a2,s3,0xc
    80000bc2:	4581                	li	a1,0
    80000bc4:	8556                	mv	a0,s5
    80000bc6:	00000097          	auipc	ra,0x0
    80000bca:	c56080e7          	jalr	-938(ra) # 8000081c <uvmunmap>
  return -1;
    80000bce:	557d                	li	a0,-1
}
    80000bd0:	60a6                	ld	ra,72(sp)
    80000bd2:	6406                	ld	s0,64(sp)
    80000bd4:	74e2                	ld	s1,56(sp)
    80000bd6:	7942                	ld	s2,48(sp)
    80000bd8:	79a2                	ld	s3,40(sp)
    80000bda:	7a02                	ld	s4,32(sp)
    80000bdc:	6ae2                	ld	s5,24(sp)
    80000bde:	6b42                	ld	s6,16(sp)
    80000be0:	6ba2                	ld	s7,8(sp)
    80000be2:	6161                	addi	sp,sp,80
    80000be4:	8082                	ret
  return 0;
    80000be6:	4501                	li	a0,0
}
    80000be8:	8082                	ret

0000000080000bea <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000bea:	1141                	addi	sp,sp,-16
    80000bec:	e406                	sd	ra,8(sp)
    80000bee:	e022                	sd	s0,0(sp)
    80000bf0:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000bf2:	4601                	li	a2,0
    80000bf4:	00000097          	auipc	ra,0x0
    80000bf8:	97a080e7          	jalr	-1670(ra) # 8000056e <walk>
  if(pte == 0)
    80000bfc:	c901                	beqz	a0,80000c0c <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000bfe:	611c                	ld	a5,0(a0)
    80000c00:	9bbd                	andi	a5,a5,-17
    80000c02:	e11c                	sd	a5,0(a0)
}
    80000c04:	60a2                	ld	ra,8(sp)
    80000c06:	6402                	ld	s0,0(sp)
    80000c08:	0141                	addi	sp,sp,16
    80000c0a:	8082                	ret
    panic("uvmclear");
    80000c0c:	00007517          	auipc	a0,0x7
    80000c10:	53c50513          	addi	a0,a0,1340 # 80008148 <etext+0x148>
    80000c14:	00005097          	auipc	ra,0x5
    80000c18:	500080e7          	jalr	1280(ra) # 80006114 <panic>

0000000080000c1c <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000c1c:	c6bd                	beqz	a3,80000c8a <copyout+0x6e>
{
    80000c1e:	715d                	addi	sp,sp,-80
    80000c20:	e486                	sd	ra,72(sp)
    80000c22:	e0a2                	sd	s0,64(sp)
    80000c24:	fc26                	sd	s1,56(sp)
    80000c26:	f84a                	sd	s2,48(sp)
    80000c28:	f44e                	sd	s3,40(sp)
    80000c2a:	f052                	sd	s4,32(sp)
    80000c2c:	ec56                	sd	s5,24(sp)
    80000c2e:	e85a                	sd	s6,16(sp)
    80000c30:	e45e                	sd	s7,8(sp)
    80000c32:	e062                	sd	s8,0(sp)
    80000c34:	0880                	addi	s0,sp,80
    80000c36:	8b2a                	mv	s6,a0
    80000c38:	8c2e                	mv	s8,a1
    80000c3a:	8a32                	mv	s4,a2
    80000c3c:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000c3e:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000c40:	6a85                	lui	s5,0x1
    80000c42:	a015                	j	80000c66 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000c44:	9562                	add	a0,a0,s8
    80000c46:	0004861b          	sext.w	a2,s1
    80000c4a:	85d2                	mv	a1,s4
    80000c4c:	41250533          	sub	a0,a0,s2
    80000c50:	fffff097          	auipc	ra,0xfffff
    80000c54:	68a080e7          	jalr	1674(ra) # 800002da <memmove>

    len -= n;
    80000c58:	409989b3          	sub	s3,s3,s1
    src += n;
    80000c5c:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000c5e:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000c62:	02098263          	beqz	s3,80000c86 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000c66:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000c6a:	85ca                	mv	a1,s2
    80000c6c:	855a                	mv	a0,s6
    80000c6e:	00000097          	auipc	ra,0x0
    80000c72:	9a6080e7          	jalr	-1626(ra) # 80000614 <walkaddr>
    if(pa0 == 0)
    80000c76:	cd01                	beqz	a0,80000c8e <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000c78:	418904b3          	sub	s1,s2,s8
    80000c7c:	94d6                	add	s1,s1,s5
    80000c7e:	fc99f3e3          	bgeu	s3,s1,80000c44 <copyout+0x28>
    80000c82:	84ce                	mv	s1,s3
    80000c84:	b7c1                	j	80000c44 <copyout+0x28>
  }
  return 0;
    80000c86:	4501                	li	a0,0
    80000c88:	a021                	j	80000c90 <copyout+0x74>
    80000c8a:	4501                	li	a0,0
}
    80000c8c:	8082                	ret
      return -1;
    80000c8e:	557d                	li	a0,-1
}
    80000c90:	60a6                	ld	ra,72(sp)
    80000c92:	6406                	ld	s0,64(sp)
    80000c94:	74e2                	ld	s1,56(sp)
    80000c96:	7942                	ld	s2,48(sp)
    80000c98:	79a2                	ld	s3,40(sp)
    80000c9a:	7a02                	ld	s4,32(sp)
    80000c9c:	6ae2                	ld	s5,24(sp)
    80000c9e:	6b42                	ld	s6,16(sp)
    80000ca0:	6ba2                	ld	s7,8(sp)
    80000ca2:	6c02                	ld	s8,0(sp)
    80000ca4:	6161                	addi	sp,sp,80
    80000ca6:	8082                	ret

0000000080000ca8 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000ca8:	caa5                	beqz	a3,80000d18 <copyin+0x70>
{
    80000caa:	715d                	addi	sp,sp,-80
    80000cac:	e486                	sd	ra,72(sp)
    80000cae:	e0a2                	sd	s0,64(sp)
    80000cb0:	fc26                	sd	s1,56(sp)
    80000cb2:	f84a                	sd	s2,48(sp)
    80000cb4:	f44e                	sd	s3,40(sp)
    80000cb6:	f052                	sd	s4,32(sp)
    80000cb8:	ec56                	sd	s5,24(sp)
    80000cba:	e85a                	sd	s6,16(sp)
    80000cbc:	e45e                	sd	s7,8(sp)
    80000cbe:	e062                	sd	s8,0(sp)
    80000cc0:	0880                	addi	s0,sp,80
    80000cc2:	8b2a                	mv	s6,a0
    80000cc4:	8a2e                	mv	s4,a1
    80000cc6:	8c32                	mv	s8,a2
    80000cc8:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000cca:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000ccc:	6a85                	lui	s5,0x1
    80000cce:	a01d                	j	80000cf4 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000cd0:	018505b3          	add	a1,a0,s8
    80000cd4:	0004861b          	sext.w	a2,s1
    80000cd8:	412585b3          	sub	a1,a1,s2
    80000cdc:	8552                	mv	a0,s4
    80000cde:	fffff097          	auipc	ra,0xfffff
    80000ce2:	5fc080e7          	jalr	1532(ra) # 800002da <memmove>

    len -= n;
    80000ce6:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000cea:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000cec:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000cf0:	02098263          	beqz	s3,80000d14 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000cf4:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000cf8:	85ca                	mv	a1,s2
    80000cfa:	855a                	mv	a0,s6
    80000cfc:	00000097          	auipc	ra,0x0
    80000d00:	918080e7          	jalr	-1768(ra) # 80000614 <walkaddr>
    if(pa0 == 0)
    80000d04:	cd01                	beqz	a0,80000d1c <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000d06:	418904b3          	sub	s1,s2,s8
    80000d0a:	94d6                	add	s1,s1,s5
    80000d0c:	fc99f2e3          	bgeu	s3,s1,80000cd0 <copyin+0x28>
    80000d10:	84ce                	mv	s1,s3
    80000d12:	bf7d                	j	80000cd0 <copyin+0x28>
  }
  return 0;
    80000d14:	4501                	li	a0,0
    80000d16:	a021                	j	80000d1e <copyin+0x76>
    80000d18:	4501                	li	a0,0
}
    80000d1a:	8082                	ret
      return -1;
    80000d1c:	557d                	li	a0,-1
}
    80000d1e:	60a6                	ld	ra,72(sp)
    80000d20:	6406                	ld	s0,64(sp)
    80000d22:	74e2                	ld	s1,56(sp)
    80000d24:	7942                	ld	s2,48(sp)
    80000d26:	79a2                	ld	s3,40(sp)
    80000d28:	7a02                	ld	s4,32(sp)
    80000d2a:	6ae2                	ld	s5,24(sp)
    80000d2c:	6b42                	ld	s6,16(sp)
    80000d2e:	6ba2                	ld	s7,8(sp)
    80000d30:	6c02                	ld	s8,0(sp)
    80000d32:	6161                	addi	sp,sp,80
    80000d34:	8082                	ret

0000000080000d36 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000d36:	c2dd                	beqz	a3,80000ddc <copyinstr+0xa6>
{
    80000d38:	715d                	addi	sp,sp,-80
    80000d3a:	e486                	sd	ra,72(sp)
    80000d3c:	e0a2                	sd	s0,64(sp)
    80000d3e:	fc26                	sd	s1,56(sp)
    80000d40:	f84a                	sd	s2,48(sp)
    80000d42:	f44e                	sd	s3,40(sp)
    80000d44:	f052                	sd	s4,32(sp)
    80000d46:	ec56                	sd	s5,24(sp)
    80000d48:	e85a                	sd	s6,16(sp)
    80000d4a:	e45e                	sd	s7,8(sp)
    80000d4c:	0880                	addi	s0,sp,80
    80000d4e:	8a2a                	mv	s4,a0
    80000d50:	8b2e                	mv	s6,a1
    80000d52:	8bb2                	mv	s7,a2
    80000d54:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000d56:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000d58:	6985                	lui	s3,0x1
    80000d5a:	a02d                	j	80000d84 <copyinstr+0x4e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000d5c:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000d60:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000d62:	37fd                	addiw	a5,a5,-1
    80000d64:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000d68:	60a6                	ld	ra,72(sp)
    80000d6a:	6406                	ld	s0,64(sp)
    80000d6c:	74e2                	ld	s1,56(sp)
    80000d6e:	7942                	ld	s2,48(sp)
    80000d70:	79a2                	ld	s3,40(sp)
    80000d72:	7a02                	ld	s4,32(sp)
    80000d74:	6ae2                	ld	s5,24(sp)
    80000d76:	6b42                	ld	s6,16(sp)
    80000d78:	6ba2                	ld	s7,8(sp)
    80000d7a:	6161                	addi	sp,sp,80
    80000d7c:	8082                	ret
    srcva = va0 + PGSIZE;
    80000d7e:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000d82:	c8a9                	beqz	s1,80000dd4 <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    80000d84:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000d88:	85ca                	mv	a1,s2
    80000d8a:	8552                	mv	a0,s4
    80000d8c:	00000097          	auipc	ra,0x0
    80000d90:	888080e7          	jalr	-1912(ra) # 80000614 <walkaddr>
    if(pa0 == 0)
    80000d94:	c131                	beqz	a0,80000dd8 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80000d96:	417906b3          	sub	a3,s2,s7
    80000d9a:	96ce                	add	a3,a3,s3
    80000d9c:	00d4f363          	bgeu	s1,a3,80000da2 <copyinstr+0x6c>
    80000da0:	86a6                	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000da2:	955e                	add	a0,a0,s7
    80000da4:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000da8:	daf9                	beqz	a3,80000d7e <copyinstr+0x48>
    80000daa:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000dac:	41650633          	sub	a2,a0,s6
    80000db0:	fff48593          	addi	a1,s1,-1
    80000db4:	95da                	add	a1,a1,s6
    while(n > 0){
    80000db6:	96da                	add	a3,a3,s6
      if(*p == '\0'){
    80000db8:	00f60733          	add	a4,a2,a5
    80000dbc:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffd3db8>
    80000dc0:	df51                	beqz	a4,80000d5c <copyinstr+0x26>
        *dst = *p;
    80000dc2:	00e78023          	sb	a4,0(a5)
      --max;
    80000dc6:	40f584b3          	sub	s1,a1,a5
      dst++;
    80000dca:	0785                	addi	a5,a5,1
    while(n > 0){
    80000dcc:	fed796e3          	bne	a5,a3,80000db8 <copyinstr+0x82>
      dst++;
    80000dd0:	8b3e                	mv	s6,a5
    80000dd2:	b775                	j	80000d7e <copyinstr+0x48>
    80000dd4:	4781                	li	a5,0
    80000dd6:	b771                	j	80000d62 <copyinstr+0x2c>
      return -1;
    80000dd8:	557d                	li	a0,-1
    80000dda:	b779                	j	80000d68 <copyinstr+0x32>
  int got_null = 0;
    80000ddc:	4781                	li	a5,0
  if(got_null){
    80000dde:	37fd                	addiw	a5,a5,-1
    80000de0:	0007851b          	sext.w	a0,a5
}
    80000de4:	8082                	ret

0000000080000de6 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000de6:	7139                	addi	sp,sp,-64
    80000de8:	fc06                	sd	ra,56(sp)
    80000dea:	f822                	sd	s0,48(sp)
    80000dec:	f426                	sd	s1,40(sp)
    80000dee:	f04a                	sd	s2,32(sp)
    80000df0:	ec4e                	sd	s3,24(sp)
    80000df2:	e852                	sd	s4,16(sp)
    80000df4:	e456                	sd	s5,8(sp)
    80000df6:	e05a                	sd	s6,0(sp)
    80000df8:	0080                	addi	s0,sp,64
    80000dfa:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dfc:	00008497          	auipc	s1,0x8
    80000e00:	7b448493          	addi	s1,s1,1972 # 800095b0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000e04:	8b26                	mv	s6,s1
    80000e06:	00007a97          	auipc	s5,0x7
    80000e0a:	1faa8a93          	addi	s5,s5,506 # 80008000 <etext>
    80000e0e:	04000937          	lui	s2,0x4000
    80000e12:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000e14:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e16:	0000ea17          	auipc	s4,0xe
    80000e1a:	39aa0a13          	addi	s4,s4,922 # 8000f1b0 <tickslock>
    char *pa = kalloc();
    80000e1e:	fffff097          	auipc	ra,0xfffff
    80000e22:	358080e7          	jalr	856(ra) # 80000176 <kalloc>
    80000e26:	862a                	mv	a2,a0
    if(pa == 0)
    80000e28:	c131                	beqz	a0,80000e6c <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000e2a:	416485b3          	sub	a1,s1,s6
    80000e2e:	8591                	srai	a1,a1,0x4
    80000e30:	000ab783          	ld	a5,0(s5)
    80000e34:	02f585b3          	mul	a1,a1,a5
    80000e38:	2585                	addiw	a1,a1,1
    80000e3a:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000e3e:	4719                	li	a4,6
    80000e40:	6685                	lui	a3,0x1
    80000e42:	40b905b3          	sub	a1,s2,a1
    80000e46:	854e                	mv	a0,s3
    80000e48:	00000097          	auipc	ra,0x0
    80000e4c:	8ae080e7          	jalr	-1874(ra) # 800006f6 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e50:	17048493          	addi	s1,s1,368
    80000e54:	fd4495e3          	bne	s1,s4,80000e1e <proc_mapstacks+0x38>
  }
}
    80000e58:	70e2                	ld	ra,56(sp)
    80000e5a:	7442                	ld	s0,48(sp)
    80000e5c:	74a2                	ld	s1,40(sp)
    80000e5e:	7902                	ld	s2,32(sp)
    80000e60:	69e2                	ld	s3,24(sp)
    80000e62:	6a42                	ld	s4,16(sp)
    80000e64:	6aa2                	ld	s5,8(sp)
    80000e66:	6b02                	ld	s6,0(sp)
    80000e68:	6121                	addi	sp,sp,64
    80000e6a:	8082                	ret
      panic("kalloc");
    80000e6c:	00007517          	auipc	a0,0x7
    80000e70:	2ec50513          	addi	a0,a0,748 # 80008158 <etext+0x158>
    80000e74:	00005097          	auipc	ra,0x5
    80000e78:	2a0080e7          	jalr	672(ra) # 80006114 <panic>

0000000080000e7c <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000e7c:	7139                	addi	sp,sp,-64
    80000e7e:	fc06                	sd	ra,56(sp)
    80000e80:	f822                	sd	s0,48(sp)
    80000e82:	f426                	sd	s1,40(sp)
    80000e84:	f04a                	sd	s2,32(sp)
    80000e86:	ec4e                	sd	s3,24(sp)
    80000e88:	e852                	sd	s4,16(sp)
    80000e8a:	e456                	sd	s5,8(sp)
    80000e8c:	e05a                	sd	s6,0(sp)
    80000e8e:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000e90:	00007597          	auipc	a1,0x7
    80000e94:	2d058593          	addi	a1,a1,720 # 80008160 <etext+0x160>
    80000e98:	00008517          	auipc	a0,0x8
    80000e9c:	2d850513          	addi	a0,a0,728 # 80009170 <pid_lock>
    80000ea0:	00006097          	auipc	ra,0x6
    80000ea4:	912080e7          	jalr	-1774(ra) # 800067b2 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000ea8:	00007597          	auipc	a1,0x7
    80000eac:	2c058593          	addi	a1,a1,704 # 80008168 <etext+0x168>
    80000eb0:	00008517          	auipc	a0,0x8
    80000eb4:	2e050513          	addi	a0,a0,736 # 80009190 <wait_lock>
    80000eb8:	00006097          	auipc	ra,0x6
    80000ebc:	8fa080e7          	jalr	-1798(ra) # 800067b2 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ec0:	00008497          	auipc	s1,0x8
    80000ec4:	6f048493          	addi	s1,s1,1776 # 800095b0 <proc>
      initlock(&p->lock, "proc");
    80000ec8:	00007b17          	auipc	s6,0x7
    80000ecc:	2b0b0b13          	addi	s6,s6,688 # 80008178 <etext+0x178>
      p->kstack = KSTACK((int) (p - proc));
    80000ed0:	8aa6                	mv	s5,s1
    80000ed2:	00007a17          	auipc	s4,0x7
    80000ed6:	12ea0a13          	addi	s4,s4,302 # 80008000 <etext>
    80000eda:	04000937          	lui	s2,0x4000
    80000ede:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000ee0:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ee2:	0000e997          	auipc	s3,0xe
    80000ee6:	2ce98993          	addi	s3,s3,718 # 8000f1b0 <tickslock>
      initlock(&p->lock, "proc");
    80000eea:	85da                	mv	a1,s6
    80000eec:	8526                	mv	a0,s1
    80000eee:	00006097          	auipc	ra,0x6
    80000ef2:	8c4080e7          	jalr	-1852(ra) # 800067b2 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000ef6:	415487b3          	sub	a5,s1,s5
    80000efa:	8791                	srai	a5,a5,0x4
    80000efc:	000a3703          	ld	a4,0(s4)
    80000f00:	02e787b3          	mul	a5,a5,a4
    80000f04:	2785                	addiw	a5,a5,1
    80000f06:	00d7979b          	slliw	a5,a5,0xd
    80000f0a:	40f907b3          	sub	a5,s2,a5
    80000f0e:	e4bc                	sd	a5,72(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f10:	17048493          	addi	s1,s1,368
    80000f14:	fd349be3          	bne	s1,s3,80000eea <procinit+0x6e>
  }
}
    80000f18:	70e2                	ld	ra,56(sp)
    80000f1a:	7442                	ld	s0,48(sp)
    80000f1c:	74a2                	ld	s1,40(sp)
    80000f1e:	7902                	ld	s2,32(sp)
    80000f20:	69e2                	ld	s3,24(sp)
    80000f22:	6a42                	ld	s4,16(sp)
    80000f24:	6aa2                	ld	s5,8(sp)
    80000f26:	6b02                	ld	s6,0(sp)
    80000f28:	6121                	addi	sp,sp,64
    80000f2a:	8082                	ret

0000000080000f2c <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000f2c:	1141                	addi	sp,sp,-16
    80000f2e:	e422                	sd	s0,8(sp)
    80000f30:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000f32:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000f34:	2501                	sext.w	a0,a0
    80000f36:	6422                	ld	s0,8(sp)
    80000f38:	0141                	addi	sp,sp,16
    80000f3a:	8082                	ret

0000000080000f3c <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000f3c:	1141                	addi	sp,sp,-16
    80000f3e:	e422                	sd	s0,8(sp)
    80000f40:	0800                	addi	s0,sp,16
    80000f42:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000f44:	2781                	sext.w	a5,a5
    80000f46:	079e                	slli	a5,a5,0x7
  return c;
}
    80000f48:	00008517          	auipc	a0,0x8
    80000f4c:	26850513          	addi	a0,a0,616 # 800091b0 <cpus>
    80000f50:	953e                	add	a0,a0,a5
    80000f52:	6422                	ld	s0,8(sp)
    80000f54:	0141                	addi	sp,sp,16
    80000f56:	8082                	ret

0000000080000f58 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000f58:	1101                	addi	sp,sp,-32
    80000f5a:	ec06                	sd	ra,24(sp)
    80000f5c:	e822                	sd	s0,16(sp)
    80000f5e:	e426                	sd	s1,8(sp)
    80000f60:	1000                	addi	s0,sp,32
  push_off();
    80000f62:	00005097          	auipc	ra,0x5
    80000f66:	688080e7          	jalr	1672(ra) # 800065ea <push_off>
    80000f6a:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000f6c:	2781                	sext.w	a5,a5
    80000f6e:	079e                	slli	a5,a5,0x7
    80000f70:	00008717          	auipc	a4,0x8
    80000f74:	20070713          	addi	a4,a4,512 # 80009170 <pid_lock>
    80000f78:	97ba                	add	a5,a5,a4
    80000f7a:	63a4                	ld	s1,64(a5)
  pop_off();
    80000f7c:	00005097          	auipc	ra,0x5
    80000f80:	72a080e7          	jalr	1834(ra) # 800066a6 <pop_off>
  return p;
}
    80000f84:	8526                	mv	a0,s1
    80000f86:	60e2                	ld	ra,24(sp)
    80000f88:	6442                	ld	s0,16(sp)
    80000f8a:	64a2                	ld	s1,8(sp)
    80000f8c:	6105                	addi	sp,sp,32
    80000f8e:	8082                	ret

0000000080000f90 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000f90:	1141                	addi	sp,sp,-16
    80000f92:	e406                	sd	ra,8(sp)
    80000f94:	e022                	sd	s0,0(sp)
    80000f96:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000f98:	00000097          	auipc	ra,0x0
    80000f9c:	fc0080e7          	jalr	-64(ra) # 80000f58 <myproc>
    80000fa0:	00005097          	auipc	ra,0x5
    80000fa4:	766080e7          	jalr	1894(ra) # 80006706 <release>

  if (first) {
    80000fa8:	00008797          	auipc	a5,0x8
    80000fac:	9287a783          	lw	a5,-1752(a5) # 800088d0 <first.1>
    80000fb0:	eb89                	bnez	a5,80000fc2 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000fb2:	00001097          	auipc	ra,0x1
    80000fb6:	c14080e7          	jalr	-1004(ra) # 80001bc6 <usertrapret>
}
    80000fba:	60a2                	ld	ra,8(sp)
    80000fbc:	6402                	ld	s0,0(sp)
    80000fbe:	0141                	addi	sp,sp,16
    80000fc0:	8082                	ret
    first = 0;
    80000fc2:	00008797          	auipc	a5,0x8
    80000fc6:	9007a723          	sw	zero,-1778(a5) # 800088d0 <first.1>
    fsinit(ROOTDEV);
    80000fca:	4505                	li	a0,1
    80000fcc:	00002097          	auipc	ra,0x2
    80000fd0:	b14080e7          	jalr	-1260(ra) # 80002ae0 <fsinit>
    80000fd4:	bff9                	j	80000fb2 <forkret+0x22>

0000000080000fd6 <allocpid>:
allocpid() {
    80000fd6:	1101                	addi	sp,sp,-32
    80000fd8:	ec06                	sd	ra,24(sp)
    80000fda:	e822                	sd	s0,16(sp)
    80000fdc:	e426                	sd	s1,8(sp)
    80000fde:	e04a                	sd	s2,0(sp)
    80000fe0:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000fe2:	00008917          	auipc	s2,0x8
    80000fe6:	18e90913          	addi	s2,s2,398 # 80009170 <pid_lock>
    80000fea:	854a                	mv	a0,s2
    80000fec:	00005097          	auipc	ra,0x5
    80000ff0:	64a080e7          	jalr	1610(ra) # 80006636 <acquire>
  pid = nextpid;
    80000ff4:	00008797          	auipc	a5,0x8
    80000ff8:	8e078793          	addi	a5,a5,-1824 # 800088d4 <nextpid>
    80000ffc:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000ffe:	0014871b          	addiw	a4,s1,1
    80001002:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001004:	854a                	mv	a0,s2
    80001006:	00005097          	auipc	ra,0x5
    8000100a:	700080e7          	jalr	1792(ra) # 80006706 <release>
}
    8000100e:	8526                	mv	a0,s1
    80001010:	60e2                	ld	ra,24(sp)
    80001012:	6442                	ld	s0,16(sp)
    80001014:	64a2                	ld	s1,8(sp)
    80001016:	6902                	ld	s2,0(sp)
    80001018:	6105                	addi	sp,sp,32
    8000101a:	8082                	ret

000000008000101c <proc_pagetable>:
{
    8000101c:	1101                	addi	sp,sp,-32
    8000101e:	ec06                	sd	ra,24(sp)
    80001020:	e822                	sd	s0,16(sp)
    80001022:	e426                	sd	s1,8(sp)
    80001024:	e04a                	sd	s2,0(sp)
    80001026:	1000                	addi	s0,sp,32
    80001028:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    8000102a:	00000097          	auipc	ra,0x0
    8000102e:	8b6080e7          	jalr	-1866(ra) # 800008e0 <uvmcreate>
    80001032:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001034:	c121                	beqz	a0,80001074 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001036:	4729                	li	a4,10
    80001038:	00006697          	auipc	a3,0x6
    8000103c:	fc868693          	addi	a3,a3,-56 # 80007000 <_trampoline>
    80001040:	6605                	lui	a2,0x1
    80001042:	040005b7          	lui	a1,0x4000
    80001046:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001048:	05b2                	slli	a1,a1,0xc
    8000104a:	fffff097          	auipc	ra,0xfffff
    8000104e:	60c080e7          	jalr	1548(ra) # 80000656 <mappages>
    80001052:	02054863          	bltz	a0,80001082 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001056:	4719                	li	a4,6
    80001058:	06093683          	ld	a3,96(s2)
    8000105c:	6605                	lui	a2,0x1
    8000105e:	020005b7          	lui	a1,0x2000
    80001062:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001064:	05b6                	slli	a1,a1,0xd
    80001066:	8526                	mv	a0,s1
    80001068:	fffff097          	auipc	ra,0xfffff
    8000106c:	5ee080e7          	jalr	1518(ra) # 80000656 <mappages>
    80001070:	02054163          	bltz	a0,80001092 <proc_pagetable+0x76>
}
    80001074:	8526                	mv	a0,s1
    80001076:	60e2                	ld	ra,24(sp)
    80001078:	6442                	ld	s0,16(sp)
    8000107a:	64a2                	ld	s1,8(sp)
    8000107c:	6902                	ld	s2,0(sp)
    8000107e:	6105                	addi	sp,sp,32
    80001080:	8082                	ret
    uvmfree(pagetable, 0);
    80001082:	4581                	li	a1,0
    80001084:	8526                	mv	a0,s1
    80001086:	00000097          	auipc	ra,0x0
    8000108a:	a58080e7          	jalr	-1448(ra) # 80000ade <uvmfree>
    return 0;
    8000108e:	4481                	li	s1,0
    80001090:	b7d5                	j	80001074 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001092:	4681                	li	a3,0
    80001094:	4605                	li	a2,1
    80001096:	040005b7          	lui	a1,0x4000
    8000109a:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000109c:	05b2                	slli	a1,a1,0xc
    8000109e:	8526                	mv	a0,s1
    800010a0:	fffff097          	auipc	ra,0xfffff
    800010a4:	77c080e7          	jalr	1916(ra) # 8000081c <uvmunmap>
    uvmfree(pagetable, 0);
    800010a8:	4581                	li	a1,0
    800010aa:	8526                	mv	a0,s1
    800010ac:	00000097          	auipc	ra,0x0
    800010b0:	a32080e7          	jalr	-1486(ra) # 80000ade <uvmfree>
    return 0;
    800010b4:	4481                	li	s1,0
    800010b6:	bf7d                	j	80001074 <proc_pagetable+0x58>

00000000800010b8 <proc_freepagetable>:
{
    800010b8:	1101                	addi	sp,sp,-32
    800010ba:	ec06                	sd	ra,24(sp)
    800010bc:	e822                	sd	s0,16(sp)
    800010be:	e426                	sd	s1,8(sp)
    800010c0:	e04a                	sd	s2,0(sp)
    800010c2:	1000                	addi	s0,sp,32
    800010c4:	84aa                	mv	s1,a0
    800010c6:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800010c8:	4681                	li	a3,0
    800010ca:	4605                	li	a2,1
    800010cc:	040005b7          	lui	a1,0x4000
    800010d0:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800010d2:	05b2                	slli	a1,a1,0xc
    800010d4:	fffff097          	auipc	ra,0xfffff
    800010d8:	748080e7          	jalr	1864(ra) # 8000081c <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    800010dc:	4681                	li	a3,0
    800010de:	4605                	li	a2,1
    800010e0:	020005b7          	lui	a1,0x2000
    800010e4:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800010e6:	05b6                	slli	a1,a1,0xd
    800010e8:	8526                	mv	a0,s1
    800010ea:	fffff097          	auipc	ra,0xfffff
    800010ee:	732080e7          	jalr	1842(ra) # 8000081c <uvmunmap>
  uvmfree(pagetable, sz);
    800010f2:	85ca                	mv	a1,s2
    800010f4:	8526                	mv	a0,s1
    800010f6:	00000097          	auipc	ra,0x0
    800010fa:	9e8080e7          	jalr	-1560(ra) # 80000ade <uvmfree>
}
    800010fe:	60e2                	ld	ra,24(sp)
    80001100:	6442                	ld	s0,16(sp)
    80001102:	64a2                	ld	s1,8(sp)
    80001104:	6902                	ld	s2,0(sp)
    80001106:	6105                	addi	sp,sp,32
    80001108:	8082                	ret

000000008000110a <freeproc>:
{
    8000110a:	1101                	addi	sp,sp,-32
    8000110c:	ec06                	sd	ra,24(sp)
    8000110e:	e822                	sd	s0,16(sp)
    80001110:	e426                	sd	s1,8(sp)
    80001112:	1000                	addi	s0,sp,32
    80001114:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001116:	7128                	ld	a0,96(a0)
    80001118:	c509                	beqz	a0,80001122 <freeproc+0x18>
    kfree((void*)p->trapframe);
    8000111a:	fffff097          	auipc	ra,0xfffff
    8000111e:	f02080e7          	jalr	-254(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001122:	0604b023          	sd	zero,96(s1)
  if(p->pagetable)
    80001126:	6ca8                	ld	a0,88(s1)
    80001128:	c511                	beqz	a0,80001134 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    8000112a:	68ac                	ld	a1,80(s1)
    8000112c:	00000097          	auipc	ra,0x0
    80001130:	f8c080e7          	jalr	-116(ra) # 800010b8 <proc_freepagetable>
  p->pagetable = 0;
    80001134:	0404bc23          	sd	zero,88(s1)
  p->sz = 0;
    80001138:	0404b823          	sd	zero,80(s1)
  p->pid = 0;
    8000113c:	0204ac23          	sw	zero,56(s1)
  p->parent = 0;
    80001140:	0404b023          	sd	zero,64(s1)
  p->name[0] = 0;
    80001144:	16048023          	sb	zero,352(s1)
  p->chan = 0;
    80001148:	0204b423          	sd	zero,40(s1)
  p->killed = 0;
    8000114c:	0204a823          	sw	zero,48(s1)
  p->xstate = 0;
    80001150:	0204aa23          	sw	zero,52(s1)
  p->state = UNUSED;
    80001154:	0204a023          	sw	zero,32(s1)
}
    80001158:	60e2                	ld	ra,24(sp)
    8000115a:	6442                	ld	s0,16(sp)
    8000115c:	64a2                	ld	s1,8(sp)
    8000115e:	6105                	addi	sp,sp,32
    80001160:	8082                	ret

0000000080001162 <allocproc>:
{
    80001162:	1101                	addi	sp,sp,-32
    80001164:	ec06                	sd	ra,24(sp)
    80001166:	e822                	sd	s0,16(sp)
    80001168:	e426                	sd	s1,8(sp)
    8000116a:	e04a                	sd	s2,0(sp)
    8000116c:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    8000116e:	00008497          	auipc	s1,0x8
    80001172:	44248493          	addi	s1,s1,1090 # 800095b0 <proc>
    80001176:	0000e917          	auipc	s2,0xe
    8000117a:	03a90913          	addi	s2,s2,58 # 8000f1b0 <tickslock>
    acquire(&p->lock);
    8000117e:	8526                	mv	a0,s1
    80001180:	00005097          	auipc	ra,0x5
    80001184:	4b6080e7          	jalr	1206(ra) # 80006636 <acquire>
    if(p->state == UNUSED) {
    80001188:	509c                	lw	a5,32(s1)
    8000118a:	cf81                	beqz	a5,800011a2 <allocproc+0x40>
      release(&p->lock);
    8000118c:	8526                	mv	a0,s1
    8000118e:	00005097          	auipc	ra,0x5
    80001192:	578080e7          	jalr	1400(ra) # 80006706 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001196:	17048493          	addi	s1,s1,368
    8000119a:	ff2492e3          	bne	s1,s2,8000117e <allocproc+0x1c>
  return 0;
    8000119e:	4481                	li	s1,0
    800011a0:	a889                	j	800011f2 <allocproc+0x90>
  p->pid = allocpid();
    800011a2:	00000097          	auipc	ra,0x0
    800011a6:	e34080e7          	jalr	-460(ra) # 80000fd6 <allocpid>
    800011aa:	dc88                	sw	a0,56(s1)
  p->state = USED;
    800011ac:	4785                	li	a5,1
    800011ae:	d09c                	sw	a5,32(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800011b0:	fffff097          	auipc	ra,0xfffff
    800011b4:	fc6080e7          	jalr	-58(ra) # 80000176 <kalloc>
    800011b8:	892a                	mv	s2,a0
    800011ba:	f0a8                	sd	a0,96(s1)
    800011bc:	c131                	beqz	a0,80001200 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800011be:	8526                	mv	a0,s1
    800011c0:	00000097          	auipc	ra,0x0
    800011c4:	e5c080e7          	jalr	-420(ra) # 8000101c <proc_pagetable>
    800011c8:	892a                	mv	s2,a0
    800011ca:	eca8                	sd	a0,88(s1)
  if(p->pagetable == 0){
    800011cc:	c531                	beqz	a0,80001218 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800011ce:	07000613          	li	a2,112
    800011d2:	4581                	li	a1,0
    800011d4:	06848513          	addi	a0,s1,104
    800011d8:	fffff097          	auipc	ra,0xfffff
    800011dc:	0a6080e7          	jalr	166(ra) # 8000027e <memset>
  p->context.ra = (uint64)forkret;
    800011e0:	00000797          	auipc	a5,0x0
    800011e4:	db078793          	addi	a5,a5,-592 # 80000f90 <forkret>
    800011e8:	f4bc                	sd	a5,104(s1)
  p->context.sp = p->kstack + PGSIZE;
    800011ea:	64bc                	ld	a5,72(s1)
    800011ec:	6705                	lui	a4,0x1
    800011ee:	97ba                	add	a5,a5,a4
    800011f0:	f8bc                	sd	a5,112(s1)
}
    800011f2:	8526                	mv	a0,s1
    800011f4:	60e2                	ld	ra,24(sp)
    800011f6:	6442                	ld	s0,16(sp)
    800011f8:	64a2                	ld	s1,8(sp)
    800011fa:	6902                	ld	s2,0(sp)
    800011fc:	6105                	addi	sp,sp,32
    800011fe:	8082                	ret
    freeproc(p);
    80001200:	8526                	mv	a0,s1
    80001202:	00000097          	auipc	ra,0x0
    80001206:	f08080e7          	jalr	-248(ra) # 8000110a <freeproc>
    release(&p->lock);
    8000120a:	8526                	mv	a0,s1
    8000120c:	00005097          	auipc	ra,0x5
    80001210:	4fa080e7          	jalr	1274(ra) # 80006706 <release>
    return 0;
    80001214:	84ca                	mv	s1,s2
    80001216:	bff1                	j	800011f2 <allocproc+0x90>
    freeproc(p);
    80001218:	8526                	mv	a0,s1
    8000121a:	00000097          	auipc	ra,0x0
    8000121e:	ef0080e7          	jalr	-272(ra) # 8000110a <freeproc>
    release(&p->lock);
    80001222:	8526                	mv	a0,s1
    80001224:	00005097          	auipc	ra,0x5
    80001228:	4e2080e7          	jalr	1250(ra) # 80006706 <release>
    return 0;
    8000122c:	84ca                	mv	s1,s2
    8000122e:	b7d1                	j	800011f2 <allocproc+0x90>

0000000080001230 <userinit>:
{
    80001230:	1101                	addi	sp,sp,-32
    80001232:	ec06                	sd	ra,24(sp)
    80001234:	e822                	sd	s0,16(sp)
    80001236:	e426                	sd	s1,8(sp)
    80001238:	1000                	addi	s0,sp,32
  p = allocproc();
    8000123a:	00000097          	auipc	ra,0x0
    8000123e:	f28080e7          	jalr	-216(ra) # 80001162 <allocproc>
    80001242:	84aa                	mv	s1,a0
  initproc = p;
    80001244:	00008797          	auipc	a5,0x8
    80001248:	dca7b623          	sd	a0,-564(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    8000124c:	03400613          	li	a2,52
    80001250:	00007597          	auipc	a1,0x7
    80001254:	69058593          	addi	a1,a1,1680 # 800088e0 <initcode>
    80001258:	6d28                	ld	a0,88(a0)
    8000125a:	fffff097          	auipc	ra,0xfffff
    8000125e:	6b4080e7          	jalr	1716(ra) # 8000090e <uvminit>
  p->sz = PGSIZE;
    80001262:	6785                	lui	a5,0x1
    80001264:	e8bc                	sd	a5,80(s1)
  p->trapframe->epc = 0;      // user program counter
    80001266:	70b8                	ld	a4,96(s1)
    80001268:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    8000126c:	70b8                	ld	a4,96(s1)
    8000126e:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001270:	4641                	li	a2,16
    80001272:	00007597          	auipc	a1,0x7
    80001276:	f0e58593          	addi	a1,a1,-242 # 80008180 <etext+0x180>
    8000127a:	16048513          	addi	a0,s1,352
    8000127e:	fffff097          	auipc	ra,0xfffff
    80001282:	14a080e7          	jalr	330(ra) # 800003c8 <safestrcpy>
  p->cwd = namei("/");
    80001286:	00007517          	auipc	a0,0x7
    8000128a:	f0a50513          	addi	a0,a0,-246 # 80008190 <etext+0x190>
    8000128e:	00002097          	auipc	ra,0x2
    80001292:	288080e7          	jalr	648(ra) # 80003516 <namei>
    80001296:	14a4bc23          	sd	a0,344(s1)
  p->state = RUNNABLE;
    8000129a:	478d                	li	a5,3
    8000129c:	d09c                	sw	a5,32(s1)
  release(&p->lock);
    8000129e:	8526                	mv	a0,s1
    800012a0:	00005097          	auipc	ra,0x5
    800012a4:	466080e7          	jalr	1126(ra) # 80006706 <release>
}
    800012a8:	60e2                	ld	ra,24(sp)
    800012aa:	6442                	ld	s0,16(sp)
    800012ac:	64a2                	ld	s1,8(sp)
    800012ae:	6105                	addi	sp,sp,32
    800012b0:	8082                	ret

00000000800012b2 <growproc>:
{
    800012b2:	1101                	addi	sp,sp,-32
    800012b4:	ec06                	sd	ra,24(sp)
    800012b6:	e822                	sd	s0,16(sp)
    800012b8:	e426                	sd	s1,8(sp)
    800012ba:	e04a                	sd	s2,0(sp)
    800012bc:	1000                	addi	s0,sp,32
    800012be:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800012c0:	00000097          	auipc	ra,0x0
    800012c4:	c98080e7          	jalr	-872(ra) # 80000f58 <myproc>
    800012c8:	892a                	mv	s2,a0
  sz = p->sz;
    800012ca:	692c                	ld	a1,80(a0)
    800012cc:	0005879b          	sext.w	a5,a1
  if(n > 0){
    800012d0:	00904f63          	bgtz	s1,800012ee <growproc+0x3c>
  } else if(n < 0){
    800012d4:	0204cd63          	bltz	s1,8000130e <growproc+0x5c>
  p->sz = sz;
    800012d8:	1782                	slli	a5,a5,0x20
    800012da:	9381                	srli	a5,a5,0x20
    800012dc:	04f93823          	sd	a5,80(s2)
  return 0;
    800012e0:	4501                	li	a0,0
}
    800012e2:	60e2                	ld	ra,24(sp)
    800012e4:	6442                	ld	s0,16(sp)
    800012e6:	64a2                	ld	s1,8(sp)
    800012e8:	6902                	ld	s2,0(sp)
    800012ea:	6105                	addi	sp,sp,32
    800012ec:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    800012ee:	00f4863b          	addw	a2,s1,a5
    800012f2:	1602                	slli	a2,a2,0x20
    800012f4:	9201                	srli	a2,a2,0x20
    800012f6:	1582                	slli	a1,a1,0x20
    800012f8:	9181                	srli	a1,a1,0x20
    800012fa:	6d28                	ld	a0,88(a0)
    800012fc:	fffff097          	auipc	ra,0xfffff
    80001300:	6cc080e7          	jalr	1740(ra) # 800009c8 <uvmalloc>
    80001304:	0005079b          	sext.w	a5,a0
    80001308:	fbe1                	bnez	a5,800012d8 <growproc+0x26>
      return -1;
    8000130a:	557d                	li	a0,-1
    8000130c:	bfd9                	j	800012e2 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000130e:	00f4863b          	addw	a2,s1,a5
    80001312:	1602                	slli	a2,a2,0x20
    80001314:	9201                	srli	a2,a2,0x20
    80001316:	1582                	slli	a1,a1,0x20
    80001318:	9181                	srli	a1,a1,0x20
    8000131a:	6d28                	ld	a0,88(a0)
    8000131c:	fffff097          	auipc	ra,0xfffff
    80001320:	664080e7          	jalr	1636(ra) # 80000980 <uvmdealloc>
    80001324:	0005079b          	sext.w	a5,a0
    80001328:	bf45                	j	800012d8 <growproc+0x26>

000000008000132a <fork>:
{
    8000132a:	7139                	addi	sp,sp,-64
    8000132c:	fc06                	sd	ra,56(sp)
    8000132e:	f822                	sd	s0,48(sp)
    80001330:	f426                	sd	s1,40(sp)
    80001332:	f04a                	sd	s2,32(sp)
    80001334:	ec4e                	sd	s3,24(sp)
    80001336:	e852                	sd	s4,16(sp)
    80001338:	e456                	sd	s5,8(sp)
    8000133a:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    8000133c:	00000097          	auipc	ra,0x0
    80001340:	c1c080e7          	jalr	-996(ra) # 80000f58 <myproc>
    80001344:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001346:	00000097          	auipc	ra,0x0
    8000134a:	e1c080e7          	jalr	-484(ra) # 80001162 <allocproc>
    8000134e:	10050c63          	beqz	a0,80001466 <fork+0x13c>
    80001352:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001354:	050ab603          	ld	a2,80(s5)
    80001358:	6d2c                	ld	a1,88(a0)
    8000135a:	058ab503          	ld	a0,88(s5)
    8000135e:	fffff097          	auipc	ra,0xfffff
    80001362:	7ba080e7          	jalr	1978(ra) # 80000b18 <uvmcopy>
    80001366:	04054863          	bltz	a0,800013b6 <fork+0x8c>
  np->sz = p->sz;
    8000136a:	050ab783          	ld	a5,80(s5)
    8000136e:	04fa3823          	sd	a5,80(s4)
  *(np->trapframe) = *(p->trapframe);
    80001372:	060ab683          	ld	a3,96(s5)
    80001376:	87b6                	mv	a5,a3
    80001378:	060a3703          	ld	a4,96(s4)
    8000137c:	12068693          	addi	a3,a3,288
    80001380:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001384:	6788                	ld	a0,8(a5)
    80001386:	6b8c                	ld	a1,16(a5)
    80001388:	6f90                	ld	a2,24(a5)
    8000138a:	01073023          	sd	a6,0(a4)
    8000138e:	e708                	sd	a0,8(a4)
    80001390:	eb0c                	sd	a1,16(a4)
    80001392:	ef10                	sd	a2,24(a4)
    80001394:	02078793          	addi	a5,a5,32
    80001398:	02070713          	addi	a4,a4,32
    8000139c:	fed792e3          	bne	a5,a3,80001380 <fork+0x56>
  np->trapframe->a0 = 0;
    800013a0:	060a3783          	ld	a5,96(s4)
    800013a4:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800013a8:	0d8a8493          	addi	s1,s5,216
    800013ac:	0d8a0913          	addi	s2,s4,216
    800013b0:	158a8993          	addi	s3,s5,344
    800013b4:	a00d                	j	800013d6 <fork+0xac>
    freeproc(np);
    800013b6:	8552                	mv	a0,s4
    800013b8:	00000097          	auipc	ra,0x0
    800013bc:	d52080e7          	jalr	-686(ra) # 8000110a <freeproc>
    release(&np->lock);
    800013c0:	8552                	mv	a0,s4
    800013c2:	00005097          	auipc	ra,0x5
    800013c6:	344080e7          	jalr	836(ra) # 80006706 <release>
    return -1;
    800013ca:	597d                	li	s2,-1
    800013cc:	a059                	j	80001452 <fork+0x128>
  for(i = 0; i < NOFILE; i++)
    800013ce:	04a1                	addi	s1,s1,8
    800013d0:	0921                	addi	s2,s2,8
    800013d2:	01348b63          	beq	s1,s3,800013e8 <fork+0xbe>
    if(p->ofile[i])
    800013d6:	6088                	ld	a0,0(s1)
    800013d8:	d97d                	beqz	a0,800013ce <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    800013da:	00002097          	auipc	ra,0x2
    800013de:	7d2080e7          	jalr	2002(ra) # 80003bac <filedup>
    800013e2:	00a93023          	sd	a0,0(s2)
    800013e6:	b7e5                	j	800013ce <fork+0xa4>
  np->cwd = idup(p->cwd);
    800013e8:	158ab503          	ld	a0,344(s5)
    800013ec:	00002097          	auipc	ra,0x2
    800013f0:	930080e7          	jalr	-1744(ra) # 80002d1c <idup>
    800013f4:	14aa3c23          	sd	a0,344(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800013f8:	4641                	li	a2,16
    800013fa:	160a8593          	addi	a1,s5,352
    800013fe:	160a0513          	addi	a0,s4,352
    80001402:	fffff097          	auipc	ra,0xfffff
    80001406:	fc6080e7          	jalr	-58(ra) # 800003c8 <safestrcpy>
  pid = np->pid;
    8000140a:	038a2903          	lw	s2,56(s4)
  release(&np->lock);
    8000140e:	8552                	mv	a0,s4
    80001410:	00005097          	auipc	ra,0x5
    80001414:	2f6080e7          	jalr	758(ra) # 80006706 <release>
  acquire(&wait_lock);
    80001418:	00008497          	auipc	s1,0x8
    8000141c:	d7848493          	addi	s1,s1,-648 # 80009190 <wait_lock>
    80001420:	8526                	mv	a0,s1
    80001422:	00005097          	auipc	ra,0x5
    80001426:	214080e7          	jalr	532(ra) # 80006636 <acquire>
  np->parent = p;
    8000142a:	055a3023          	sd	s5,64(s4)
  release(&wait_lock);
    8000142e:	8526                	mv	a0,s1
    80001430:	00005097          	auipc	ra,0x5
    80001434:	2d6080e7          	jalr	726(ra) # 80006706 <release>
  acquire(&np->lock);
    80001438:	8552                	mv	a0,s4
    8000143a:	00005097          	auipc	ra,0x5
    8000143e:	1fc080e7          	jalr	508(ra) # 80006636 <acquire>
  np->state = RUNNABLE;
    80001442:	478d                	li	a5,3
    80001444:	02fa2023          	sw	a5,32(s4)
  release(&np->lock);
    80001448:	8552                	mv	a0,s4
    8000144a:	00005097          	auipc	ra,0x5
    8000144e:	2bc080e7          	jalr	700(ra) # 80006706 <release>
}
    80001452:	854a                	mv	a0,s2
    80001454:	70e2                	ld	ra,56(sp)
    80001456:	7442                	ld	s0,48(sp)
    80001458:	74a2                	ld	s1,40(sp)
    8000145a:	7902                	ld	s2,32(sp)
    8000145c:	69e2                	ld	s3,24(sp)
    8000145e:	6a42                	ld	s4,16(sp)
    80001460:	6aa2                	ld	s5,8(sp)
    80001462:	6121                	addi	sp,sp,64
    80001464:	8082                	ret
    return -1;
    80001466:	597d                	li	s2,-1
    80001468:	b7ed                	j	80001452 <fork+0x128>

000000008000146a <scheduler>:
{
    8000146a:	7139                	addi	sp,sp,-64
    8000146c:	fc06                	sd	ra,56(sp)
    8000146e:	f822                	sd	s0,48(sp)
    80001470:	f426                	sd	s1,40(sp)
    80001472:	f04a                	sd	s2,32(sp)
    80001474:	ec4e                	sd	s3,24(sp)
    80001476:	e852                	sd	s4,16(sp)
    80001478:	e456                	sd	s5,8(sp)
    8000147a:	e05a                	sd	s6,0(sp)
    8000147c:	0080                	addi	s0,sp,64
    8000147e:	8792                	mv	a5,tp
  int id = r_tp();
    80001480:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001482:	00779a93          	slli	s5,a5,0x7
    80001486:	00008717          	auipc	a4,0x8
    8000148a:	cea70713          	addi	a4,a4,-790 # 80009170 <pid_lock>
    8000148e:	9756                	add	a4,a4,s5
    80001490:	04073023          	sd	zero,64(a4)
        swtch(&c->context, &p->context);
    80001494:	00008717          	auipc	a4,0x8
    80001498:	d2470713          	addi	a4,a4,-732 # 800091b8 <cpus+0x8>
    8000149c:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    8000149e:	498d                	li	s3,3
        p->state = RUNNING;
    800014a0:	4b11                	li	s6,4
        c->proc = p;
    800014a2:	079e                	slli	a5,a5,0x7
    800014a4:	00008a17          	auipc	s4,0x8
    800014a8:	ccca0a13          	addi	s4,s4,-820 # 80009170 <pid_lock>
    800014ac:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800014ae:	0000e917          	auipc	s2,0xe
    800014b2:	d0290913          	addi	s2,s2,-766 # 8000f1b0 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800014b6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800014ba:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800014be:	10079073          	csrw	sstatus,a5
    800014c2:	00008497          	auipc	s1,0x8
    800014c6:	0ee48493          	addi	s1,s1,238 # 800095b0 <proc>
    800014ca:	a811                	j	800014de <scheduler+0x74>
      release(&p->lock);
    800014cc:	8526                	mv	a0,s1
    800014ce:	00005097          	auipc	ra,0x5
    800014d2:	238080e7          	jalr	568(ra) # 80006706 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800014d6:	17048493          	addi	s1,s1,368
    800014da:	fd248ee3          	beq	s1,s2,800014b6 <scheduler+0x4c>
      acquire(&p->lock);
    800014de:	8526                	mv	a0,s1
    800014e0:	00005097          	auipc	ra,0x5
    800014e4:	156080e7          	jalr	342(ra) # 80006636 <acquire>
      if(p->state == RUNNABLE) {
    800014e8:	509c                	lw	a5,32(s1)
    800014ea:	ff3791e3          	bne	a5,s3,800014cc <scheduler+0x62>
        p->state = RUNNING;
    800014ee:	0364a023          	sw	s6,32(s1)
        c->proc = p;
    800014f2:	049a3023          	sd	s1,64(s4)
        swtch(&c->context, &p->context);
    800014f6:	06848593          	addi	a1,s1,104
    800014fa:	8556                	mv	a0,s5
    800014fc:	00000097          	auipc	ra,0x0
    80001500:	620080e7          	jalr	1568(ra) # 80001b1c <swtch>
        c->proc = 0;
    80001504:	040a3023          	sd	zero,64(s4)
    80001508:	b7d1                	j	800014cc <scheduler+0x62>

000000008000150a <sched>:
{
    8000150a:	7179                	addi	sp,sp,-48
    8000150c:	f406                	sd	ra,40(sp)
    8000150e:	f022                	sd	s0,32(sp)
    80001510:	ec26                	sd	s1,24(sp)
    80001512:	e84a                	sd	s2,16(sp)
    80001514:	e44e                	sd	s3,8(sp)
    80001516:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001518:	00000097          	auipc	ra,0x0
    8000151c:	a40080e7          	jalr	-1472(ra) # 80000f58 <myproc>
    80001520:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001522:	00005097          	auipc	ra,0x5
    80001526:	09a080e7          	jalr	154(ra) # 800065bc <holding>
    8000152a:	c93d                	beqz	a0,800015a0 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000152c:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000152e:	2781                	sext.w	a5,a5
    80001530:	079e                	slli	a5,a5,0x7
    80001532:	00008717          	auipc	a4,0x8
    80001536:	c3e70713          	addi	a4,a4,-962 # 80009170 <pid_lock>
    8000153a:	97ba                	add	a5,a5,a4
    8000153c:	0b87a703          	lw	a4,184(a5)
    80001540:	4785                	li	a5,1
    80001542:	06f71763          	bne	a4,a5,800015b0 <sched+0xa6>
  if(p->state == RUNNING)
    80001546:	5098                	lw	a4,32(s1)
    80001548:	4791                	li	a5,4
    8000154a:	06f70b63          	beq	a4,a5,800015c0 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000154e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001552:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001554:	efb5                	bnez	a5,800015d0 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001556:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001558:	00008917          	auipc	s2,0x8
    8000155c:	c1890913          	addi	s2,s2,-1000 # 80009170 <pid_lock>
    80001560:	2781                	sext.w	a5,a5
    80001562:	079e                	slli	a5,a5,0x7
    80001564:	97ca                	add	a5,a5,s2
    80001566:	0bc7a983          	lw	s3,188(a5)
    8000156a:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000156c:	2781                	sext.w	a5,a5
    8000156e:	079e                	slli	a5,a5,0x7
    80001570:	00008597          	auipc	a1,0x8
    80001574:	c4858593          	addi	a1,a1,-952 # 800091b8 <cpus+0x8>
    80001578:	95be                	add	a1,a1,a5
    8000157a:	06848513          	addi	a0,s1,104
    8000157e:	00000097          	auipc	ra,0x0
    80001582:	59e080e7          	jalr	1438(ra) # 80001b1c <swtch>
    80001586:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001588:	2781                	sext.w	a5,a5
    8000158a:	079e                	slli	a5,a5,0x7
    8000158c:	993e                	add	s2,s2,a5
    8000158e:	0b392e23          	sw	s3,188(s2)
}
    80001592:	70a2                	ld	ra,40(sp)
    80001594:	7402                	ld	s0,32(sp)
    80001596:	64e2                	ld	s1,24(sp)
    80001598:	6942                	ld	s2,16(sp)
    8000159a:	69a2                	ld	s3,8(sp)
    8000159c:	6145                	addi	sp,sp,48
    8000159e:	8082                	ret
    panic("sched p->lock");
    800015a0:	00007517          	auipc	a0,0x7
    800015a4:	bf850513          	addi	a0,a0,-1032 # 80008198 <etext+0x198>
    800015a8:	00005097          	auipc	ra,0x5
    800015ac:	b6c080e7          	jalr	-1172(ra) # 80006114 <panic>
    panic("sched locks");
    800015b0:	00007517          	auipc	a0,0x7
    800015b4:	bf850513          	addi	a0,a0,-1032 # 800081a8 <etext+0x1a8>
    800015b8:	00005097          	auipc	ra,0x5
    800015bc:	b5c080e7          	jalr	-1188(ra) # 80006114 <panic>
    panic("sched running");
    800015c0:	00007517          	auipc	a0,0x7
    800015c4:	bf850513          	addi	a0,a0,-1032 # 800081b8 <etext+0x1b8>
    800015c8:	00005097          	auipc	ra,0x5
    800015cc:	b4c080e7          	jalr	-1204(ra) # 80006114 <panic>
    panic("sched interruptible");
    800015d0:	00007517          	auipc	a0,0x7
    800015d4:	bf850513          	addi	a0,a0,-1032 # 800081c8 <etext+0x1c8>
    800015d8:	00005097          	auipc	ra,0x5
    800015dc:	b3c080e7          	jalr	-1220(ra) # 80006114 <panic>

00000000800015e0 <yield>:
{
    800015e0:	1101                	addi	sp,sp,-32
    800015e2:	ec06                	sd	ra,24(sp)
    800015e4:	e822                	sd	s0,16(sp)
    800015e6:	e426                	sd	s1,8(sp)
    800015e8:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800015ea:	00000097          	auipc	ra,0x0
    800015ee:	96e080e7          	jalr	-1682(ra) # 80000f58 <myproc>
    800015f2:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800015f4:	00005097          	auipc	ra,0x5
    800015f8:	042080e7          	jalr	66(ra) # 80006636 <acquire>
  p->state = RUNNABLE;
    800015fc:	478d                	li	a5,3
    800015fe:	d09c                	sw	a5,32(s1)
  sched();
    80001600:	00000097          	auipc	ra,0x0
    80001604:	f0a080e7          	jalr	-246(ra) # 8000150a <sched>
  release(&p->lock);
    80001608:	8526                	mv	a0,s1
    8000160a:	00005097          	auipc	ra,0x5
    8000160e:	0fc080e7          	jalr	252(ra) # 80006706 <release>
}
    80001612:	60e2                	ld	ra,24(sp)
    80001614:	6442                	ld	s0,16(sp)
    80001616:	64a2                	ld	s1,8(sp)
    80001618:	6105                	addi	sp,sp,32
    8000161a:	8082                	ret

000000008000161c <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000161c:	7179                	addi	sp,sp,-48
    8000161e:	f406                	sd	ra,40(sp)
    80001620:	f022                	sd	s0,32(sp)
    80001622:	ec26                	sd	s1,24(sp)
    80001624:	e84a                	sd	s2,16(sp)
    80001626:	e44e                	sd	s3,8(sp)
    80001628:	1800                	addi	s0,sp,48
    8000162a:	89aa                	mv	s3,a0
    8000162c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000162e:	00000097          	auipc	ra,0x0
    80001632:	92a080e7          	jalr	-1750(ra) # 80000f58 <myproc>
    80001636:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001638:	00005097          	auipc	ra,0x5
    8000163c:	ffe080e7          	jalr	-2(ra) # 80006636 <acquire>
  release(lk);
    80001640:	854a                	mv	a0,s2
    80001642:	00005097          	auipc	ra,0x5
    80001646:	0c4080e7          	jalr	196(ra) # 80006706 <release>

  // Go to sleep.
  p->chan = chan;
    8000164a:	0334b423          	sd	s3,40(s1)
  p->state = SLEEPING;
    8000164e:	4789                	li	a5,2
    80001650:	d09c                	sw	a5,32(s1)

  sched();
    80001652:	00000097          	auipc	ra,0x0
    80001656:	eb8080e7          	jalr	-328(ra) # 8000150a <sched>

  // Tidy up.
  p->chan = 0;
    8000165a:	0204b423          	sd	zero,40(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000165e:	8526                	mv	a0,s1
    80001660:	00005097          	auipc	ra,0x5
    80001664:	0a6080e7          	jalr	166(ra) # 80006706 <release>
  acquire(lk);
    80001668:	854a                	mv	a0,s2
    8000166a:	00005097          	auipc	ra,0x5
    8000166e:	fcc080e7          	jalr	-52(ra) # 80006636 <acquire>
}
    80001672:	70a2                	ld	ra,40(sp)
    80001674:	7402                	ld	s0,32(sp)
    80001676:	64e2                	ld	s1,24(sp)
    80001678:	6942                	ld	s2,16(sp)
    8000167a:	69a2                	ld	s3,8(sp)
    8000167c:	6145                	addi	sp,sp,48
    8000167e:	8082                	ret

0000000080001680 <wait>:
{
    80001680:	715d                	addi	sp,sp,-80
    80001682:	e486                	sd	ra,72(sp)
    80001684:	e0a2                	sd	s0,64(sp)
    80001686:	fc26                	sd	s1,56(sp)
    80001688:	f84a                	sd	s2,48(sp)
    8000168a:	f44e                	sd	s3,40(sp)
    8000168c:	f052                	sd	s4,32(sp)
    8000168e:	ec56                	sd	s5,24(sp)
    80001690:	e85a                	sd	s6,16(sp)
    80001692:	e45e                	sd	s7,8(sp)
    80001694:	e062                	sd	s8,0(sp)
    80001696:	0880                	addi	s0,sp,80
    80001698:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    8000169a:	00000097          	auipc	ra,0x0
    8000169e:	8be080e7          	jalr	-1858(ra) # 80000f58 <myproc>
    800016a2:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800016a4:	00008517          	auipc	a0,0x8
    800016a8:	aec50513          	addi	a0,a0,-1300 # 80009190 <wait_lock>
    800016ac:	00005097          	auipc	ra,0x5
    800016b0:	f8a080e7          	jalr	-118(ra) # 80006636 <acquire>
    havekids = 0;
    800016b4:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800016b6:	4a15                	li	s4,5
        havekids = 1;
    800016b8:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    800016ba:	0000e997          	auipc	s3,0xe
    800016be:	af698993          	addi	s3,s3,-1290 # 8000f1b0 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016c2:	00008c17          	auipc	s8,0x8
    800016c6:	acec0c13          	addi	s8,s8,-1330 # 80009190 <wait_lock>
    havekids = 0;
    800016ca:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    800016cc:	00008497          	auipc	s1,0x8
    800016d0:	ee448493          	addi	s1,s1,-284 # 800095b0 <proc>
    800016d4:	a0bd                	j	80001742 <wait+0xc2>
          pid = np->pid;
    800016d6:	0384a983          	lw	s3,56(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800016da:	000b0e63          	beqz	s6,800016f6 <wait+0x76>
    800016de:	4691                	li	a3,4
    800016e0:	03448613          	addi	a2,s1,52
    800016e4:	85da                	mv	a1,s6
    800016e6:	05893503          	ld	a0,88(s2)
    800016ea:	fffff097          	auipc	ra,0xfffff
    800016ee:	532080e7          	jalr	1330(ra) # 80000c1c <copyout>
    800016f2:	02054563          	bltz	a0,8000171c <wait+0x9c>
          freeproc(np);
    800016f6:	8526                	mv	a0,s1
    800016f8:	00000097          	auipc	ra,0x0
    800016fc:	a12080e7          	jalr	-1518(ra) # 8000110a <freeproc>
          release(&np->lock);
    80001700:	8526                	mv	a0,s1
    80001702:	00005097          	auipc	ra,0x5
    80001706:	004080e7          	jalr	4(ra) # 80006706 <release>
          release(&wait_lock);
    8000170a:	00008517          	auipc	a0,0x8
    8000170e:	a8650513          	addi	a0,a0,-1402 # 80009190 <wait_lock>
    80001712:	00005097          	auipc	ra,0x5
    80001716:	ff4080e7          	jalr	-12(ra) # 80006706 <release>
          return pid;
    8000171a:	a09d                	j	80001780 <wait+0x100>
            release(&np->lock);
    8000171c:	8526                	mv	a0,s1
    8000171e:	00005097          	auipc	ra,0x5
    80001722:	fe8080e7          	jalr	-24(ra) # 80006706 <release>
            release(&wait_lock);
    80001726:	00008517          	auipc	a0,0x8
    8000172a:	a6a50513          	addi	a0,a0,-1430 # 80009190 <wait_lock>
    8000172e:	00005097          	auipc	ra,0x5
    80001732:	fd8080e7          	jalr	-40(ra) # 80006706 <release>
            return -1;
    80001736:	59fd                	li	s3,-1
    80001738:	a0a1                	j	80001780 <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    8000173a:	17048493          	addi	s1,s1,368
    8000173e:	03348463          	beq	s1,s3,80001766 <wait+0xe6>
      if(np->parent == p){
    80001742:	60bc                	ld	a5,64(s1)
    80001744:	ff279be3          	bne	a5,s2,8000173a <wait+0xba>
        acquire(&np->lock);
    80001748:	8526                	mv	a0,s1
    8000174a:	00005097          	auipc	ra,0x5
    8000174e:	eec080e7          	jalr	-276(ra) # 80006636 <acquire>
        if(np->state == ZOMBIE){
    80001752:	509c                	lw	a5,32(s1)
    80001754:	f94781e3          	beq	a5,s4,800016d6 <wait+0x56>
        release(&np->lock);
    80001758:	8526                	mv	a0,s1
    8000175a:	00005097          	auipc	ra,0x5
    8000175e:	fac080e7          	jalr	-84(ra) # 80006706 <release>
        havekids = 1;
    80001762:	8756                	mv	a4,s5
    80001764:	bfd9                	j	8000173a <wait+0xba>
    if(!havekids || p->killed){
    80001766:	c701                	beqz	a4,8000176e <wait+0xee>
    80001768:	03092783          	lw	a5,48(s2)
    8000176c:	c79d                	beqz	a5,8000179a <wait+0x11a>
      release(&wait_lock);
    8000176e:	00008517          	auipc	a0,0x8
    80001772:	a2250513          	addi	a0,a0,-1502 # 80009190 <wait_lock>
    80001776:	00005097          	auipc	ra,0x5
    8000177a:	f90080e7          	jalr	-112(ra) # 80006706 <release>
      return -1;
    8000177e:	59fd                	li	s3,-1
}
    80001780:	854e                	mv	a0,s3
    80001782:	60a6                	ld	ra,72(sp)
    80001784:	6406                	ld	s0,64(sp)
    80001786:	74e2                	ld	s1,56(sp)
    80001788:	7942                	ld	s2,48(sp)
    8000178a:	79a2                	ld	s3,40(sp)
    8000178c:	7a02                	ld	s4,32(sp)
    8000178e:	6ae2                	ld	s5,24(sp)
    80001790:	6b42                	ld	s6,16(sp)
    80001792:	6ba2                	ld	s7,8(sp)
    80001794:	6c02                	ld	s8,0(sp)
    80001796:	6161                	addi	sp,sp,80
    80001798:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000179a:	85e2                	mv	a1,s8
    8000179c:	854a                	mv	a0,s2
    8000179e:	00000097          	auipc	ra,0x0
    800017a2:	e7e080e7          	jalr	-386(ra) # 8000161c <sleep>
    havekids = 0;
    800017a6:	b715                	j	800016ca <wait+0x4a>

00000000800017a8 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800017a8:	7139                	addi	sp,sp,-64
    800017aa:	fc06                	sd	ra,56(sp)
    800017ac:	f822                	sd	s0,48(sp)
    800017ae:	f426                	sd	s1,40(sp)
    800017b0:	f04a                	sd	s2,32(sp)
    800017b2:	ec4e                	sd	s3,24(sp)
    800017b4:	e852                	sd	s4,16(sp)
    800017b6:	e456                	sd	s5,8(sp)
    800017b8:	0080                	addi	s0,sp,64
    800017ba:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800017bc:	00008497          	auipc	s1,0x8
    800017c0:	df448493          	addi	s1,s1,-524 # 800095b0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800017c4:	4989                	li	s3,2
        p->state = RUNNABLE;
    800017c6:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800017c8:	0000e917          	auipc	s2,0xe
    800017cc:	9e890913          	addi	s2,s2,-1560 # 8000f1b0 <tickslock>
    800017d0:	a811                	j	800017e4 <wakeup+0x3c>
      }
      release(&p->lock);
    800017d2:	8526                	mv	a0,s1
    800017d4:	00005097          	auipc	ra,0x5
    800017d8:	f32080e7          	jalr	-206(ra) # 80006706 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800017dc:	17048493          	addi	s1,s1,368
    800017e0:	03248663          	beq	s1,s2,8000180c <wakeup+0x64>
    if(p != myproc()){
    800017e4:	fffff097          	auipc	ra,0xfffff
    800017e8:	774080e7          	jalr	1908(ra) # 80000f58 <myproc>
    800017ec:	fea488e3          	beq	s1,a0,800017dc <wakeup+0x34>
      acquire(&p->lock);
    800017f0:	8526                	mv	a0,s1
    800017f2:	00005097          	auipc	ra,0x5
    800017f6:	e44080e7          	jalr	-444(ra) # 80006636 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800017fa:	509c                	lw	a5,32(s1)
    800017fc:	fd379be3          	bne	a5,s3,800017d2 <wakeup+0x2a>
    80001800:	749c                	ld	a5,40(s1)
    80001802:	fd4798e3          	bne	a5,s4,800017d2 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001806:	0354a023          	sw	s5,32(s1)
    8000180a:	b7e1                	j	800017d2 <wakeup+0x2a>
    }
  }
}
    8000180c:	70e2                	ld	ra,56(sp)
    8000180e:	7442                	ld	s0,48(sp)
    80001810:	74a2                	ld	s1,40(sp)
    80001812:	7902                	ld	s2,32(sp)
    80001814:	69e2                	ld	s3,24(sp)
    80001816:	6a42                	ld	s4,16(sp)
    80001818:	6aa2                	ld	s5,8(sp)
    8000181a:	6121                	addi	sp,sp,64
    8000181c:	8082                	ret

000000008000181e <reparent>:
{
    8000181e:	7179                	addi	sp,sp,-48
    80001820:	f406                	sd	ra,40(sp)
    80001822:	f022                	sd	s0,32(sp)
    80001824:	ec26                	sd	s1,24(sp)
    80001826:	e84a                	sd	s2,16(sp)
    80001828:	e44e                	sd	s3,8(sp)
    8000182a:	e052                	sd	s4,0(sp)
    8000182c:	1800                	addi	s0,sp,48
    8000182e:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001830:	00008497          	auipc	s1,0x8
    80001834:	d8048493          	addi	s1,s1,-640 # 800095b0 <proc>
      pp->parent = initproc;
    80001838:	00007a17          	auipc	s4,0x7
    8000183c:	7d8a0a13          	addi	s4,s4,2008 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001840:	0000e997          	auipc	s3,0xe
    80001844:	97098993          	addi	s3,s3,-1680 # 8000f1b0 <tickslock>
    80001848:	a029                	j	80001852 <reparent+0x34>
    8000184a:	17048493          	addi	s1,s1,368
    8000184e:	01348d63          	beq	s1,s3,80001868 <reparent+0x4a>
    if(pp->parent == p){
    80001852:	60bc                	ld	a5,64(s1)
    80001854:	ff279be3          	bne	a5,s2,8000184a <reparent+0x2c>
      pp->parent = initproc;
    80001858:	000a3503          	ld	a0,0(s4)
    8000185c:	e0a8                	sd	a0,64(s1)
      wakeup(initproc);
    8000185e:	00000097          	auipc	ra,0x0
    80001862:	f4a080e7          	jalr	-182(ra) # 800017a8 <wakeup>
    80001866:	b7d5                	j	8000184a <reparent+0x2c>
}
    80001868:	70a2                	ld	ra,40(sp)
    8000186a:	7402                	ld	s0,32(sp)
    8000186c:	64e2                	ld	s1,24(sp)
    8000186e:	6942                	ld	s2,16(sp)
    80001870:	69a2                	ld	s3,8(sp)
    80001872:	6a02                	ld	s4,0(sp)
    80001874:	6145                	addi	sp,sp,48
    80001876:	8082                	ret

0000000080001878 <exit>:
{
    80001878:	7179                	addi	sp,sp,-48
    8000187a:	f406                	sd	ra,40(sp)
    8000187c:	f022                	sd	s0,32(sp)
    8000187e:	ec26                	sd	s1,24(sp)
    80001880:	e84a                	sd	s2,16(sp)
    80001882:	e44e                	sd	s3,8(sp)
    80001884:	e052                	sd	s4,0(sp)
    80001886:	1800                	addi	s0,sp,48
    80001888:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000188a:	fffff097          	auipc	ra,0xfffff
    8000188e:	6ce080e7          	jalr	1742(ra) # 80000f58 <myproc>
    80001892:	89aa                	mv	s3,a0
  if(p == initproc)
    80001894:	00007797          	auipc	a5,0x7
    80001898:	77c7b783          	ld	a5,1916(a5) # 80009010 <initproc>
    8000189c:	0d850493          	addi	s1,a0,216
    800018a0:	15850913          	addi	s2,a0,344
    800018a4:	02a79363          	bne	a5,a0,800018ca <exit+0x52>
    panic("init exiting");
    800018a8:	00007517          	auipc	a0,0x7
    800018ac:	93850513          	addi	a0,a0,-1736 # 800081e0 <etext+0x1e0>
    800018b0:	00005097          	auipc	ra,0x5
    800018b4:	864080e7          	jalr	-1948(ra) # 80006114 <panic>
      fileclose(f);
    800018b8:	00002097          	auipc	ra,0x2
    800018bc:	346080e7          	jalr	838(ra) # 80003bfe <fileclose>
      p->ofile[fd] = 0;
    800018c0:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800018c4:	04a1                	addi	s1,s1,8
    800018c6:	01248563          	beq	s1,s2,800018d0 <exit+0x58>
    if(p->ofile[fd]){
    800018ca:	6088                	ld	a0,0(s1)
    800018cc:	f575                	bnez	a0,800018b8 <exit+0x40>
    800018ce:	bfdd                	j	800018c4 <exit+0x4c>
  begin_op();
    800018d0:	00002097          	auipc	ra,0x2
    800018d4:	e66080e7          	jalr	-410(ra) # 80003736 <begin_op>
  iput(p->cwd);
    800018d8:	1589b503          	ld	a0,344(s3)
    800018dc:	00001097          	auipc	ra,0x1
    800018e0:	638080e7          	jalr	1592(ra) # 80002f14 <iput>
  end_op();
    800018e4:	00002097          	auipc	ra,0x2
    800018e8:	ed0080e7          	jalr	-304(ra) # 800037b4 <end_op>
  p->cwd = 0;
    800018ec:	1409bc23          	sd	zero,344(s3)
  acquire(&wait_lock);
    800018f0:	00008497          	auipc	s1,0x8
    800018f4:	8a048493          	addi	s1,s1,-1888 # 80009190 <wait_lock>
    800018f8:	8526                	mv	a0,s1
    800018fa:	00005097          	auipc	ra,0x5
    800018fe:	d3c080e7          	jalr	-708(ra) # 80006636 <acquire>
  reparent(p);
    80001902:	854e                	mv	a0,s3
    80001904:	00000097          	auipc	ra,0x0
    80001908:	f1a080e7          	jalr	-230(ra) # 8000181e <reparent>
  wakeup(p->parent);
    8000190c:	0409b503          	ld	a0,64(s3)
    80001910:	00000097          	auipc	ra,0x0
    80001914:	e98080e7          	jalr	-360(ra) # 800017a8 <wakeup>
  acquire(&p->lock);
    80001918:	854e                	mv	a0,s3
    8000191a:	00005097          	auipc	ra,0x5
    8000191e:	d1c080e7          	jalr	-740(ra) # 80006636 <acquire>
  p->xstate = status;
    80001922:	0349aa23          	sw	s4,52(s3)
  p->state = ZOMBIE;
    80001926:	4795                	li	a5,5
    80001928:	02f9a023          	sw	a5,32(s3)
  release(&wait_lock);
    8000192c:	8526                	mv	a0,s1
    8000192e:	00005097          	auipc	ra,0x5
    80001932:	dd8080e7          	jalr	-552(ra) # 80006706 <release>
  sched();
    80001936:	00000097          	auipc	ra,0x0
    8000193a:	bd4080e7          	jalr	-1068(ra) # 8000150a <sched>
  panic("zombie exit");
    8000193e:	00007517          	auipc	a0,0x7
    80001942:	8b250513          	addi	a0,a0,-1870 # 800081f0 <etext+0x1f0>
    80001946:	00004097          	auipc	ra,0x4
    8000194a:	7ce080e7          	jalr	1998(ra) # 80006114 <panic>

000000008000194e <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    8000194e:	7179                	addi	sp,sp,-48
    80001950:	f406                	sd	ra,40(sp)
    80001952:	f022                	sd	s0,32(sp)
    80001954:	ec26                	sd	s1,24(sp)
    80001956:	e84a                	sd	s2,16(sp)
    80001958:	e44e                	sd	s3,8(sp)
    8000195a:	1800                	addi	s0,sp,48
    8000195c:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000195e:	00008497          	auipc	s1,0x8
    80001962:	c5248493          	addi	s1,s1,-942 # 800095b0 <proc>
    80001966:	0000e997          	auipc	s3,0xe
    8000196a:	84a98993          	addi	s3,s3,-1974 # 8000f1b0 <tickslock>
    acquire(&p->lock);
    8000196e:	8526                	mv	a0,s1
    80001970:	00005097          	auipc	ra,0x5
    80001974:	cc6080e7          	jalr	-826(ra) # 80006636 <acquire>
    if(p->pid == pid){
    80001978:	5c9c                	lw	a5,56(s1)
    8000197a:	01278d63          	beq	a5,s2,80001994 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000197e:	8526                	mv	a0,s1
    80001980:	00005097          	auipc	ra,0x5
    80001984:	d86080e7          	jalr	-634(ra) # 80006706 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001988:	17048493          	addi	s1,s1,368
    8000198c:	ff3491e3          	bne	s1,s3,8000196e <kill+0x20>
  }
  return -1;
    80001990:	557d                	li	a0,-1
    80001992:	a829                	j	800019ac <kill+0x5e>
      p->killed = 1;
    80001994:	4785                	li	a5,1
    80001996:	d89c                	sw	a5,48(s1)
      if(p->state == SLEEPING){
    80001998:	5098                	lw	a4,32(s1)
    8000199a:	4789                	li	a5,2
    8000199c:	00f70f63          	beq	a4,a5,800019ba <kill+0x6c>
      release(&p->lock);
    800019a0:	8526                	mv	a0,s1
    800019a2:	00005097          	auipc	ra,0x5
    800019a6:	d64080e7          	jalr	-668(ra) # 80006706 <release>
      return 0;
    800019aa:	4501                	li	a0,0
}
    800019ac:	70a2                	ld	ra,40(sp)
    800019ae:	7402                	ld	s0,32(sp)
    800019b0:	64e2                	ld	s1,24(sp)
    800019b2:	6942                	ld	s2,16(sp)
    800019b4:	69a2                	ld	s3,8(sp)
    800019b6:	6145                	addi	sp,sp,48
    800019b8:	8082                	ret
        p->state = RUNNABLE;
    800019ba:	478d                	li	a5,3
    800019bc:	d09c                	sw	a5,32(s1)
    800019be:	b7cd                	j	800019a0 <kill+0x52>

00000000800019c0 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800019c0:	7179                	addi	sp,sp,-48
    800019c2:	f406                	sd	ra,40(sp)
    800019c4:	f022                	sd	s0,32(sp)
    800019c6:	ec26                	sd	s1,24(sp)
    800019c8:	e84a                	sd	s2,16(sp)
    800019ca:	e44e                	sd	s3,8(sp)
    800019cc:	e052                	sd	s4,0(sp)
    800019ce:	1800                	addi	s0,sp,48
    800019d0:	84aa                	mv	s1,a0
    800019d2:	892e                	mv	s2,a1
    800019d4:	89b2                	mv	s3,a2
    800019d6:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800019d8:	fffff097          	auipc	ra,0xfffff
    800019dc:	580080e7          	jalr	1408(ra) # 80000f58 <myproc>
  if(user_dst){
    800019e0:	c08d                	beqz	s1,80001a02 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800019e2:	86d2                	mv	a3,s4
    800019e4:	864e                	mv	a2,s3
    800019e6:	85ca                	mv	a1,s2
    800019e8:	6d28                	ld	a0,88(a0)
    800019ea:	fffff097          	auipc	ra,0xfffff
    800019ee:	232080e7          	jalr	562(ra) # 80000c1c <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800019f2:	70a2                	ld	ra,40(sp)
    800019f4:	7402                	ld	s0,32(sp)
    800019f6:	64e2                	ld	s1,24(sp)
    800019f8:	6942                	ld	s2,16(sp)
    800019fa:	69a2                	ld	s3,8(sp)
    800019fc:	6a02                	ld	s4,0(sp)
    800019fe:	6145                	addi	sp,sp,48
    80001a00:	8082                	ret
    memmove((char *)dst, src, len);
    80001a02:	000a061b          	sext.w	a2,s4
    80001a06:	85ce                	mv	a1,s3
    80001a08:	854a                	mv	a0,s2
    80001a0a:	fffff097          	auipc	ra,0xfffff
    80001a0e:	8d0080e7          	jalr	-1840(ra) # 800002da <memmove>
    return 0;
    80001a12:	8526                	mv	a0,s1
    80001a14:	bff9                	j	800019f2 <either_copyout+0x32>

0000000080001a16 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001a16:	7179                	addi	sp,sp,-48
    80001a18:	f406                	sd	ra,40(sp)
    80001a1a:	f022                	sd	s0,32(sp)
    80001a1c:	ec26                	sd	s1,24(sp)
    80001a1e:	e84a                	sd	s2,16(sp)
    80001a20:	e44e                	sd	s3,8(sp)
    80001a22:	e052                	sd	s4,0(sp)
    80001a24:	1800                	addi	s0,sp,48
    80001a26:	892a                	mv	s2,a0
    80001a28:	84ae                	mv	s1,a1
    80001a2a:	89b2                	mv	s3,a2
    80001a2c:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a2e:	fffff097          	auipc	ra,0xfffff
    80001a32:	52a080e7          	jalr	1322(ra) # 80000f58 <myproc>
  if(user_src){
    80001a36:	c08d                	beqz	s1,80001a58 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001a38:	86d2                	mv	a3,s4
    80001a3a:	864e                	mv	a2,s3
    80001a3c:	85ca                	mv	a1,s2
    80001a3e:	6d28                	ld	a0,88(a0)
    80001a40:	fffff097          	auipc	ra,0xfffff
    80001a44:	268080e7          	jalr	616(ra) # 80000ca8 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001a48:	70a2                	ld	ra,40(sp)
    80001a4a:	7402                	ld	s0,32(sp)
    80001a4c:	64e2                	ld	s1,24(sp)
    80001a4e:	6942                	ld	s2,16(sp)
    80001a50:	69a2                	ld	s3,8(sp)
    80001a52:	6a02                	ld	s4,0(sp)
    80001a54:	6145                	addi	sp,sp,48
    80001a56:	8082                	ret
    memmove(dst, (char*)src, len);
    80001a58:	000a061b          	sext.w	a2,s4
    80001a5c:	85ce                	mv	a1,s3
    80001a5e:	854a                	mv	a0,s2
    80001a60:	fffff097          	auipc	ra,0xfffff
    80001a64:	87a080e7          	jalr	-1926(ra) # 800002da <memmove>
    return 0;
    80001a68:	8526                	mv	a0,s1
    80001a6a:	bff9                	j	80001a48 <either_copyin+0x32>

0000000080001a6c <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001a6c:	715d                	addi	sp,sp,-80
    80001a6e:	e486                	sd	ra,72(sp)
    80001a70:	e0a2                	sd	s0,64(sp)
    80001a72:	fc26                	sd	s1,56(sp)
    80001a74:	f84a                	sd	s2,48(sp)
    80001a76:	f44e                	sd	s3,40(sp)
    80001a78:	f052                	sd	s4,32(sp)
    80001a7a:	ec56                	sd	s5,24(sp)
    80001a7c:	e85a                	sd	s6,16(sp)
    80001a7e:	e45e                	sd	s7,8(sp)
    80001a80:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001a82:	00007517          	auipc	a0,0x7
    80001a86:	de650513          	addi	a0,a0,-538 # 80008868 <digits+0x88>
    80001a8a:	00004097          	auipc	ra,0x4
    80001a8e:	6d4080e7          	jalr	1748(ra) # 8000615e <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a92:	00008497          	auipc	s1,0x8
    80001a96:	c7e48493          	addi	s1,s1,-898 # 80009710 <proc+0x160>
    80001a9a:	0000e917          	auipc	s2,0xe
    80001a9e:	87690913          	addi	s2,s2,-1930 # 8000f310 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001aa2:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001aa4:	00006997          	auipc	s3,0x6
    80001aa8:	75c98993          	addi	s3,s3,1884 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    80001aac:	00006a97          	auipc	s5,0x6
    80001ab0:	75ca8a93          	addi	s5,s5,1884 # 80008208 <etext+0x208>
    printf("\n");
    80001ab4:	00007a17          	auipc	s4,0x7
    80001ab8:	db4a0a13          	addi	s4,s4,-588 # 80008868 <digits+0x88>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001abc:	00006b97          	auipc	s7,0x6
    80001ac0:	784b8b93          	addi	s7,s7,1924 # 80008240 <states.0>
    80001ac4:	a00d                	j	80001ae6 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001ac6:	ed86a583          	lw	a1,-296(a3)
    80001aca:	8556                	mv	a0,s5
    80001acc:	00004097          	auipc	ra,0x4
    80001ad0:	692080e7          	jalr	1682(ra) # 8000615e <printf>
    printf("\n");
    80001ad4:	8552                	mv	a0,s4
    80001ad6:	00004097          	auipc	ra,0x4
    80001ada:	688080e7          	jalr	1672(ra) # 8000615e <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001ade:	17048493          	addi	s1,s1,368
    80001ae2:	03248263          	beq	s1,s2,80001b06 <procdump+0x9a>
    if(p->state == UNUSED)
    80001ae6:	86a6                	mv	a3,s1
    80001ae8:	ec04a783          	lw	a5,-320(s1)
    80001aec:	dbed                	beqz	a5,80001ade <procdump+0x72>
      state = "???";
    80001aee:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001af0:	fcfb6be3          	bltu	s6,a5,80001ac6 <procdump+0x5a>
    80001af4:	02079713          	slli	a4,a5,0x20
    80001af8:	01d75793          	srli	a5,a4,0x1d
    80001afc:	97de                	add	a5,a5,s7
    80001afe:	6390                	ld	a2,0(a5)
    80001b00:	f279                	bnez	a2,80001ac6 <procdump+0x5a>
      state = "???";
    80001b02:	864e                	mv	a2,s3
    80001b04:	b7c9                	j	80001ac6 <procdump+0x5a>
  }
}
    80001b06:	60a6                	ld	ra,72(sp)
    80001b08:	6406                	ld	s0,64(sp)
    80001b0a:	74e2                	ld	s1,56(sp)
    80001b0c:	7942                	ld	s2,48(sp)
    80001b0e:	79a2                	ld	s3,40(sp)
    80001b10:	7a02                	ld	s4,32(sp)
    80001b12:	6ae2                	ld	s5,24(sp)
    80001b14:	6b42                	ld	s6,16(sp)
    80001b16:	6ba2                	ld	s7,8(sp)
    80001b18:	6161                	addi	sp,sp,80
    80001b1a:	8082                	ret

0000000080001b1c <swtch>:
    80001b1c:	00153023          	sd	ra,0(a0)
    80001b20:	00253423          	sd	sp,8(a0)
    80001b24:	e900                	sd	s0,16(a0)
    80001b26:	ed04                	sd	s1,24(a0)
    80001b28:	03253023          	sd	s2,32(a0)
    80001b2c:	03353423          	sd	s3,40(a0)
    80001b30:	03453823          	sd	s4,48(a0)
    80001b34:	03553c23          	sd	s5,56(a0)
    80001b38:	05653023          	sd	s6,64(a0)
    80001b3c:	05753423          	sd	s7,72(a0)
    80001b40:	05853823          	sd	s8,80(a0)
    80001b44:	05953c23          	sd	s9,88(a0)
    80001b48:	07a53023          	sd	s10,96(a0)
    80001b4c:	07b53423          	sd	s11,104(a0)
    80001b50:	0005b083          	ld	ra,0(a1)
    80001b54:	0085b103          	ld	sp,8(a1)
    80001b58:	6980                	ld	s0,16(a1)
    80001b5a:	6d84                	ld	s1,24(a1)
    80001b5c:	0205b903          	ld	s2,32(a1)
    80001b60:	0285b983          	ld	s3,40(a1)
    80001b64:	0305ba03          	ld	s4,48(a1)
    80001b68:	0385ba83          	ld	s5,56(a1)
    80001b6c:	0405bb03          	ld	s6,64(a1)
    80001b70:	0485bb83          	ld	s7,72(a1)
    80001b74:	0505bc03          	ld	s8,80(a1)
    80001b78:	0585bc83          	ld	s9,88(a1)
    80001b7c:	0605bd03          	ld	s10,96(a1)
    80001b80:	0685bd83          	ld	s11,104(a1)
    80001b84:	8082                	ret

0000000080001b86 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001b86:	1141                	addi	sp,sp,-16
    80001b88:	e406                	sd	ra,8(sp)
    80001b8a:	e022                	sd	s0,0(sp)
    80001b8c:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001b8e:	00006597          	auipc	a1,0x6
    80001b92:	6e258593          	addi	a1,a1,1762 # 80008270 <states.0+0x30>
    80001b96:	0000d517          	auipc	a0,0xd
    80001b9a:	61a50513          	addi	a0,a0,1562 # 8000f1b0 <tickslock>
    80001b9e:	00005097          	auipc	ra,0x5
    80001ba2:	c14080e7          	jalr	-1004(ra) # 800067b2 <initlock>
}
    80001ba6:	60a2                	ld	ra,8(sp)
    80001ba8:	6402                	ld	s0,0(sp)
    80001baa:	0141                	addi	sp,sp,16
    80001bac:	8082                	ret

0000000080001bae <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001bae:	1141                	addi	sp,sp,-16
    80001bb0:	e422                	sd	s0,8(sp)
    80001bb2:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001bb4:	00003797          	auipc	a5,0x3
    80001bb8:	68c78793          	addi	a5,a5,1676 # 80005240 <kernelvec>
    80001bbc:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001bc0:	6422                	ld	s0,8(sp)
    80001bc2:	0141                	addi	sp,sp,16
    80001bc4:	8082                	ret

0000000080001bc6 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001bc6:	1141                	addi	sp,sp,-16
    80001bc8:	e406                	sd	ra,8(sp)
    80001bca:	e022                	sd	s0,0(sp)
    80001bcc:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001bce:	fffff097          	auipc	ra,0xfffff
    80001bd2:	38a080e7          	jalr	906(ra) # 80000f58 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001bd6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001bda:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001bdc:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001be0:	00005697          	auipc	a3,0x5
    80001be4:	42068693          	addi	a3,a3,1056 # 80007000 <_trampoline>
    80001be8:	00005717          	auipc	a4,0x5
    80001bec:	41870713          	addi	a4,a4,1048 # 80007000 <_trampoline>
    80001bf0:	8f15                	sub	a4,a4,a3
    80001bf2:	040007b7          	lui	a5,0x4000
    80001bf6:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001bf8:	07b2                	slli	a5,a5,0xc
    80001bfa:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001bfc:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001c00:	7138                	ld	a4,96(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001c02:	18002673          	csrr	a2,satp
    80001c06:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001c08:	7130                	ld	a2,96(a0)
    80001c0a:	6538                	ld	a4,72(a0)
    80001c0c:	6585                	lui	a1,0x1
    80001c0e:	972e                	add	a4,a4,a1
    80001c10:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001c12:	7138                	ld	a4,96(a0)
    80001c14:	00000617          	auipc	a2,0x0
    80001c18:	13860613          	addi	a2,a2,312 # 80001d4c <usertrap>
    80001c1c:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001c1e:	7138                	ld	a4,96(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001c20:	8612                	mv	a2,tp
    80001c22:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c24:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001c28:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001c2c:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c30:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001c34:	7138                	ld	a4,96(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001c36:	6f18                	ld	a4,24(a4)
    80001c38:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001c3c:	6d2c                	ld	a1,88(a0)
    80001c3e:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001c40:	00005717          	auipc	a4,0x5
    80001c44:	45070713          	addi	a4,a4,1104 # 80007090 <userret>
    80001c48:	8f15                	sub	a4,a4,a3
    80001c4a:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001c4c:	577d                	li	a4,-1
    80001c4e:	177e                	slli	a4,a4,0x3f
    80001c50:	8dd9                	or	a1,a1,a4
    80001c52:	02000537          	lui	a0,0x2000
    80001c56:	157d                	addi	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    80001c58:	0536                	slli	a0,a0,0xd
    80001c5a:	9782                	jalr	a5
}
    80001c5c:	60a2                	ld	ra,8(sp)
    80001c5e:	6402                	ld	s0,0(sp)
    80001c60:	0141                	addi	sp,sp,16
    80001c62:	8082                	ret

0000000080001c64 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001c64:	1101                	addi	sp,sp,-32
    80001c66:	ec06                	sd	ra,24(sp)
    80001c68:	e822                	sd	s0,16(sp)
    80001c6a:	e426                	sd	s1,8(sp)
    80001c6c:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001c6e:	0000d497          	auipc	s1,0xd
    80001c72:	54248493          	addi	s1,s1,1346 # 8000f1b0 <tickslock>
    80001c76:	8526                	mv	a0,s1
    80001c78:	00005097          	auipc	ra,0x5
    80001c7c:	9be080e7          	jalr	-1602(ra) # 80006636 <acquire>
  ticks++;
    80001c80:	00007517          	auipc	a0,0x7
    80001c84:	39850513          	addi	a0,a0,920 # 80009018 <ticks>
    80001c88:	411c                	lw	a5,0(a0)
    80001c8a:	2785                	addiw	a5,a5,1
    80001c8c:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001c8e:	00000097          	auipc	ra,0x0
    80001c92:	b1a080e7          	jalr	-1254(ra) # 800017a8 <wakeup>
  release(&tickslock);
    80001c96:	8526                	mv	a0,s1
    80001c98:	00005097          	auipc	ra,0x5
    80001c9c:	a6e080e7          	jalr	-1426(ra) # 80006706 <release>
}
    80001ca0:	60e2                	ld	ra,24(sp)
    80001ca2:	6442                	ld	s0,16(sp)
    80001ca4:	64a2                	ld	s1,8(sp)
    80001ca6:	6105                	addi	sp,sp,32
    80001ca8:	8082                	ret

0000000080001caa <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001caa:	1101                	addi	sp,sp,-32
    80001cac:	ec06                	sd	ra,24(sp)
    80001cae:	e822                	sd	s0,16(sp)
    80001cb0:	e426                	sd	s1,8(sp)
    80001cb2:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001cb4:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001cb8:	00074d63          	bltz	a4,80001cd2 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001cbc:	57fd                	li	a5,-1
    80001cbe:	17fe                	slli	a5,a5,0x3f
    80001cc0:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001cc2:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001cc4:	06f70363          	beq	a4,a5,80001d2a <devintr+0x80>
  }
}
    80001cc8:	60e2                	ld	ra,24(sp)
    80001cca:	6442                	ld	s0,16(sp)
    80001ccc:	64a2                	ld	s1,8(sp)
    80001cce:	6105                	addi	sp,sp,32
    80001cd0:	8082                	ret
     (scause & 0xff) == 9){
    80001cd2:	0ff77793          	zext.b	a5,a4
  if((scause & 0x8000000000000000L) &&
    80001cd6:	46a5                	li	a3,9
    80001cd8:	fed792e3          	bne	a5,a3,80001cbc <devintr+0x12>
    int irq = plic_claim();
    80001cdc:	00003097          	auipc	ra,0x3
    80001ce0:	66c080e7          	jalr	1644(ra) # 80005348 <plic_claim>
    80001ce4:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001ce6:	47a9                	li	a5,10
    80001ce8:	02f50763          	beq	a0,a5,80001d16 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001cec:	4785                	li	a5,1
    80001cee:	02f50963          	beq	a0,a5,80001d20 <devintr+0x76>
    return 1;
    80001cf2:	4505                	li	a0,1
    } else if(irq){
    80001cf4:	d8f1                	beqz	s1,80001cc8 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001cf6:	85a6                	mv	a1,s1
    80001cf8:	00006517          	auipc	a0,0x6
    80001cfc:	58050513          	addi	a0,a0,1408 # 80008278 <states.0+0x38>
    80001d00:	00004097          	auipc	ra,0x4
    80001d04:	45e080e7          	jalr	1118(ra) # 8000615e <printf>
      plic_complete(irq);
    80001d08:	8526                	mv	a0,s1
    80001d0a:	00003097          	auipc	ra,0x3
    80001d0e:	662080e7          	jalr	1634(ra) # 8000536c <plic_complete>
    return 1;
    80001d12:	4505                	li	a0,1
    80001d14:	bf55                	j	80001cc8 <devintr+0x1e>
      uartintr();
    80001d16:	00005097          	auipc	ra,0x5
    80001d1a:	856080e7          	jalr	-1962(ra) # 8000656c <uartintr>
    80001d1e:	b7ed                	j	80001d08 <devintr+0x5e>
      virtio_disk_intr();
    80001d20:	00004097          	auipc	ra,0x4
    80001d24:	ad8080e7          	jalr	-1320(ra) # 800057f8 <virtio_disk_intr>
    80001d28:	b7c5                	j	80001d08 <devintr+0x5e>
    if(cpuid() == 0){
    80001d2a:	fffff097          	auipc	ra,0xfffff
    80001d2e:	202080e7          	jalr	514(ra) # 80000f2c <cpuid>
    80001d32:	c901                	beqz	a0,80001d42 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001d34:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001d38:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001d3a:	14479073          	csrw	sip,a5
    return 2;
    80001d3e:	4509                	li	a0,2
    80001d40:	b761                	j	80001cc8 <devintr+0x1e>
      clockintr();
    80001d42:	00000097          	auipc	ra,0x0
    80001d46:	f22080e7          	jalr	-222(ra) # 80001c64 <clockintr>
    80001d4a:	b7ed                	j	80001d34 <devintr+0x8a>

0000000080001d4c <usertrap>:
{
    80001d4c:	1101                	addi	sp,sp,-32
    80001d4e:	ec06                	sd	ra,24(sp)
    80001d50:	e822                	sd	s0,16(sp)
    80001d52:	e426                	sd	s1,8(sp)
    80001d54:	e04a                	sd	s2,0(sp)
    80001d56:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d58:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001d5c:	1007f793          	andi	a5,a5,256
    80001d60:	e3ad                	bnez	a5,80001dc2 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d62:	00003797          	auipc	a5,0x3
    80001d66:	4de78793          	addi	a5,a5,1246 # 80005240 <kernelvec>
    80001d6a:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001d6e:	fffff097          	auipc	ra,0xfffff
    80001d72:	1ea080e7          	jalr	490(ra) # 80000f58 <myproc>
    80001d76:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001d78:	713c                	ld	a5,96(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d7a:	14102773          	csrr	a4,sepc
    80001d7e:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d80:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001d84:	47a1                	li	a5,8
    80001d86:	04f71c63          	bne	a4,a5,80001dde <usertrap+0x92>
    if(p->killed)
    80001d8a:	591c                	lw	a5,48(a0)
    80001d8c:	e3b9                	bnez	a5,80001dd2 <usertrap+0x86>
    p->trapframe->epc += 4;
    80001d8e:	70b8                	ld	a4,96(s1)
    80001d90:	6f1c                	ld	a5,24(a4)
    80001d92:	0791                	addi	a5,a5,4
    80001d94:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d96:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d9a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d9e:	10079073          	csrw	sstatus,a5
    syscall();
    80001da2:	00000097          	auipc	ra,0x0
    80001da6:	2e0080e7          	jalr	736(ra) # 80002082 <syscall>
  if(p->killed)
    80001daa:	589c                	lw	a5,48(s1)
    80001dac:	ebc1                	bnez	a5,80001e3c <usertrap+0xf0>
  usertrapret();
    80001dae:	00000097          	auipc	ra,0x0
    80001db2:	e18080e7          	jalr	-488(ra) # 80001bc6 <usertrapret>
}
    80001db6:	60e2                	ld	ra,24(sp)
    80001db8:	6442                	ld	s0,16(sp)
    80001dba:	64a2                	ld	s1,8(sp)
    80001dbc:	6902                	ld	s2,0(sp)
    80001dbe:	6105                	addi	sp,sp,32
    80001dc0:	8082                	ret
    panic("usertrap: not from user mode");
    80001dc2:	00006517          	auipc	a0,0x6
    80001dc6:	4d650513          	addi	a0,a0,1238 # 80008298 <states.0+0x58>
    80001dca:	00004097          	auipc	ra,0x4
    80001dce:	34a080e7          	jalr	842(ra) # 80006114 <panic>
      exit(-1);
    80001dd2:	557d                	li	a0,-1
    80001dd4:	00000097          	auipc	ra,0x0
    80001dd8:	aa4080e7          	jalr	-1372(ra) # 80001878 <exit>
    80001ddc:	bf4d                	j	80001d8e <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001dde:	00000097          	auipc	ra,0x0
    80001de2:	ecc080e7          	jalr	-308(ra) # 80001caa <devintr>
    80001de6:	892a                	mv	s2,a0
    80001de8:	c501                	beqz	a0,80001df0 <usertrap+0xa4>
  if(p->killed)
    80001dea:	589c                	lw	a5,48(s1)
    80001dec:	c3a1                	beqz	a5,80001e2c <usertrap+0xe0>
    80001dee:	a815                	j	80001e22 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001df0:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001df4:	5c90                	lw	a2,56(s1)
    80001df6:	00006517          	auipc	a0,0x6
    80001dfa:	4c250513          	addi	a0,a0,1218 # 800082b8 <states.0+0x78>
    80001dfe:	00004097          	auipc	ra,0x4
    80001e02:	360080e7          	jalr	864(ra) # 8000615e <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e06:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e0a:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e0e:	00006517          	auipc	a0,0x6
    80001e12:	4da50513          	addi	a0,a0,1242 # 800082e8 <states.0+0xa8>
    80001e16:	00004097          	auipc	ra,0x4
    80001e1a:	348080e7          	jalr	840(ra) # 8000615e <printf>
    p->killed = 1;
    80001e1e:	4785                	li	a5,1
    80001e20:	d89c                	sw	a5,48(s1)
    exit(-1);
    80001e22:	557d                	li	a0,-1
    80001e24:	00000097          	auipc	ra,0x0
    80001e28:	a54080e7          	jalr	-1452(ra) # 80001878 <exit>
  if(which_dev == 2)
    80001e2c:	4789                	li	a5,2
    80001e2e:	f8f910e3          	bne	s2,a5,80001dae <usertrap+0x62>
    yield();
    80001e32:	fffff097          	auipc	ra,0xfffff
    80001e36:	7ae080e7          	jalr	1966(ra) # 800015e0 <yield>
    80001e3a:	bf95                	j	80001dae <usertrap+0x62>
  int which_dev = 0;
    80001e3c:	4901                	li	s2,0
    80001e3e:	b7d5                	j	80001e22 <usertrap+0xd6>

0000000080001e40 <kerneltrap>:
{
    80001e40:	7179                	addi	sp,sp,-48
    80001e42:	f406                	sd	ra,40(sp)
    80001e44:	f022                	sd	s0,32(sp)
    80001e46:	ec26                	sd	s1,24(sp)
    80001e48:	e84a                	sd	s2,16(sp)
    80001e4a:	e44e                	sd	s3,8(sp)
    80001e4c:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e4e:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e52:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e56:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001e5a:	1004f793          	andi	a5,s1,256
    80001e5e:	cb85                	beqz	a5,80001e8e <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e60:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e64:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001e66:	ef85                	bnez	a5,80001e9e <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001e68:	00000097          	auipc	ra,0x0
    80001e6c:	e42080e7          	jalr	-446(ra) # 80001caa <devintr>
    80001e70:	cd1d                	beqz	a0,80001eae <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e72:	4789                	li	a5,2
    80001e74:	06f50a63          	beq	a0,a5,80001ee8 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001e78:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e7c:	10049073          	csrw	sstatus,s1
}
    80001e80:	70a2                	ld	ra,40(sp)
    80001e82:	7402                	ld	s0,32(sp)
    80001e84:	64e2                	ld	s1,24(sp)
    80001e86:	6942                	ld	s2,16(sp)
    80001e88:	69a2                	ld	s3,8(sp)
    80001e8a:	6145                	addi	sp,sp,48
    80001e8c:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001e8e:	00006517          	auipc	a0,0x6
    80001e92:	47a50513          	addi	a0,a0,1146 # 80008308 <states.0+0xc8>
    80001e96:	00004097          	auipc	ra,0x4
    80001e9a:	27e080e7          	jalr	638(ra) # 80006114 <panic>
    panic("kerneltrap: interrupts enabled");
    80001e9e:	00006517          	auipc	a0,0x6
    80001ea2:	49250513          	addi	a0,a0,1170 # 80008330 <states.0+0xf0>
    80001ea6:	00004097          	auipc	ra,0x4
    80001eaa:	26e080e7          	jalr	622(ra) # 80006114 <panic>
    printf("scause %p\n", scause);
    80001eae:	85ce                	mv	a1,s3
    80001eb0:	00006517          	auipc	a0,0x6
    80001eb4:	4a050513          	addi	a0,a0,1184 # 80008350 <states.0+0x110>
    80001eb8:	00004097          	auipc	ra,0x4
    80001ebc:	2a6080e7          	jalr	678(ra) # 8000615e <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ec0:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001ec4:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001ec8:	00006517          	auipc	a0,0x6
    80001ecc:	49850513          	addi	a0,a0,1176 # 80008360 <states.0+0x120>
    80001ed0:	00004097          	auipc	ra,0x4
    80001ed4:	28e080e7          	jalr	654(ra) # 8000615e <printf>
    panic("kerneltrap");
    80001ed8:	00006517          	auipc	a0,0x6
    80001edc:	4a050513          	addi	a0,a0,1184 # 80008378 <states.0+0x138>
    80001ee0:	00004097          	auipc	ra,0x4
    80001ee4:	234080e7          	jalr	564(ra) # 80006114 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001ee8:	fffff097          	auipc	ra,0xfffff
    80001eec:	070080e7          	jalr	112(ra) # 80000f58 <myproc>
    80001ef0:	d541                	beqz	a0,80001e78 <kerneltrap+0x38>
    80001ef2:	fffff097          	auipc	ra,0xfffff
    80001ef6:	066080e7          	jalr	102(ra) # 80000f58 <myproc>
    80001efa:	5118                	lw	a4,32(a0)
    80001efc:	4791                	li	a5,4
    80001efe:	f6f71de3          	bne	a4,a5,80001e78 <kerneltrap+0x38>
    yield();
    80001f02:	fffff097          	auipc	ra,0xfffff
    80001f06:	6de080e7          	jalr	1758(ra) # 800015e0 <yield>
    80001f0a:	b7bd                	j	80001e78 <kerneltrap+0x38>

0000000080001f0c <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001f0c:	1101                	addi	sp,sp,-32
    80001f0e:	ec06                	sd	ra,24(sp)
    80001f10:	e822                	sd	s0,16(sp)
    80001f12:	e426                	sd	s1,8(sp)
    80001f14:	1000                	addi	s0,sp,32
    80001f16:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001f18:	fffff097          	auipc	ra,0xfffff
    80001f1c:	040080e7          	jalr	64(ra) # 80000f58 <myproc>
  switch (n) {
    80001f20:	4795                	li	a5,5
    80001f22:	0497e163          	bltu	a5,s1,80001f64 <argraw+0x58>
    80001f26:	048a                	slli	s1,s1,0x2
    80001f28:	00006717          	auipc	a4,0x6
    80001f2c:	48870713          	addi	a4,a4,1160 # 800083b0 <states.0+0x170>
    80001f30:	94ba                	add	s1,s1,a4
    80001f32:	409c                	lw	a5,0(s1)
    80001f34:	97ba                	add	a5,a5,a4
    80001f36:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001f38:	713c                	ld	a5,96(a0)
    80001f3a:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001f3c:	60e2                	ld	ra,24(sp)
    80001f3e:	6442                	ld	s0,16(sp)
    80001f40:	64a2                	ld	s1,8(sp)
    80001f42:	6105                	addi	sp,sp,32
    80001f44:	8082                	ret
    return p->trapframe->a1;
    80001f46:	713c                	ld	a5,96(a0)
    80001f48:	7fa8                	ld	a0,120(a5)
    80001f4a:	bfcd                	j	80001f3c <argraw+0x30>
    return p->trapframe->a2;
    80001f4c:	713c                	ld	a5,96(a0)
    80001f4e:	63c8                	ld	a0,128(a5)
    80001f50:	b7f5                	j	80001f3c <argraw+0x30>
    return p->trapframe->a3;
    80001f52:	713c                	ld	a5,96(a0)
    80001f54:	67c8                	ld	a0,136(a5)
    80001f56:	b7dd                	j	80001f3c <argraw+0x30>
    return p->trapframe->a4;
    80001f58:	713c                	ld	a5,96(a0)
    80001f5a:	6bc8                	ld	a0,144(a5)
    80001f5c:	b7c5                	j	80001f3c <argraw+0x30>
    return p->trapframe->a5;
    80001f5e:	713c                	ld	a5,96(a0)
    80001f60:	6fc8                	ld	a0,152(a5)
    80001f62:	bfe9                	j	80001f3c <argraw+0x30>
  panic("argraw");
    80001f64:	00006517          	auipc	a0,0x6
    80001f68:	42450513          	addi	a0,a0,1060 # 80008388 <states.0+0x148>
    80001f6c:	00004097          	auipc	ra,0x4
    80001f70:	1a8080e7          	jalr	424(ra) # 80006114 <panic>

0000000080001f74 <fetchaddr>:
{
    80001f74:	1101                	addi	sp,sp,-32
    80001f76:	ec06                	sd	ra,24(sp)
    80001f78:	e822                	sd	s0,16(sp)
    80001f7a:	e426                	sd	s1,8(sp)
    80001f7c:	e04a                	sd	s2,0(sp)
    80001f7e:	1000                	addi	s0,sp,32
    80001f80:	84aa                	mv	s1,a0
    80001f82:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001f84:	fffff097          	auipc	ra,0xfffff
    80001f88:	fd4080e7          	jalr	-44(ra) # 80000f58 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80001f8c:	693c                	ld	a5,80(a0)
    80001f8e:	02f4f863          	bgeu	s1,a5,80001fbe <fetchaddr+0x4a>
    80001f92:	00848713          	addi	a4,s1,8
    80001f96:	02e7e663          	bltu	a5,a4,80001fc2 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001f9a:	46a1                	li	a3,8
    80001f9c:	8626                	mv	a2,s1
    80001f9e:	85ca                	mv	a1,s2
    80001fa0:	6d28                	ld	a0,88(a0)
    80001fa2:	fffff097          	auipc	ra,0xfffff
    80001fa6:	d06080e7          	jalr	-762(ra) # 80000ca8 <copyin>
    80001faa:	00a03533          	snez	a0,a0
    80001fae:	40a00533          	neg	a0,a0
}
    80001fb2:	60e2                	ld	ra,24(sp)
    80001fb4:	6442                	ld	s0,16(sp)
    80001fb6:	64a2                	ld	s1,8(sp)
    80001fb8:	6902                	ld	s2,0(sp)
    80001fba:	6105                	addi	sp,sp,32
    80001fbc:	8082                	ret
    return -1;
    80001fbe:	557d                	li	a0,-1
    80001fc0:	bfcd                	j	80001fb2 <fetchaddr+0x3e>
    80001fc2:	557d                	li	a0,-1
    80001fc4:	b7fd                	j	80001fb2 <fetchaddr+0x3e>

0000000080001fc6 <fetchstr>:
{
    80001fc6:	7179                	addi	sp,sp,-48
    80001fc8:	f406                	sd	ra,40(sp)
    80001fca:	f022                	sd	s0,32(sp)
    80001fcc:	ec26                	sd	s1,24(sp)
    80001fce:	e84a                	sd	s2,16(sp)
    80001fd0:	e44e                	sd	s3,8(sp)
    80001fd2:	1800                	addi	s0,sp,48
    80001fd4:	892a                	mv	s2,a0
    80001fd6:	84ae                	mv	s1,a1
    80001fd8:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001fda:	fffff097          	auipc	ra,0xfffff
    80001fde:	f7e080e7          	jalr	-130(ra) # 80000f58 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80001fe2:	86ce                	mv	a3,s3
    80001fe4:	864a                	mv	a2,s2
    80001fe6:	85a6                	mv	a1,s1
    80001fe8:	6d28                	ld	a0,88(a0)
    80001fea:	fffff097          	auipc	ra,0xfffff
    80001fee:	d4c080e7          	jalr	-692(ra) # 80000d36 <copyinstr>
  if(err < 0)
    80001ff2:	00054763          	bltz	a0,80002000 <fetchstr+0x3a>
  return strlen(buf);
    80001ff6:	8526                	mv	a0,s1
    80001ff8:	ffffe097          	auipc	ra,0xffffe
    80001ffc:	402080e7          	jalr	1026(ra) # 800003fa <strlen>
}
    80002000:	70a2                	ld	ra,40(sp)
    80002002:	7402                	ld	s0,32(sp)
    80002004:	64e2                	ld	s1,24(sp)
    80002006:	6942                	ld	s2,16(sp)
    80002008:	69a2                	ld	s3,8(sp)
    8000200a:	6145                	addi	sp,sp,48
    8000200c:	8082                	ret

000000008000200e <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    8000200e:	1101                	addi	sp,sp,-32
    80002010:	ec06                	sd	ra,24(sp)
    80002012:	e822                	sd	s0,16(sp)
    80002014:	e426                	sd	s1,8(sp)
    80002016:	1000                	addi	s0,sp,32
    80002018:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000201a:	00000097          	auipc	ra,0x0
    8000201e:	ef2080e7          	jalr	-270(ra) # 80001f0c <argraw>
    80002022:	c088                	sw	a0,0(s1)
  return 0;
}
    80002024:	4501                	li	a0,0
    80002026:	60e2                	ld	ra,24(sp)
    80002028:	6442                	ld	s0,16(sp)
    8000202a:	64a2                	ld	s1,8(sp)
    8000202c:	6105                	addi	sp,sp,32
    8000202e:	8082                	ret

0000000080002030 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80002030:	1101                	addi	sp,sp,-32
    80002032:	ec06                	sd	ra,24(sp)
    80002034:	e822                	sd	s0,16(sp)
    80002036:	e426                	sd	s1,8(sp)
    80002038:	1000                	addi	s0,sp,32
    8000203a:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000203c:	00000097          	auipc	ra,0x0
    80002040:	ed0080e7          	jalr	-304(ra) # 80001f0c <argraw>
    80002044:	e088                	sd	a0,0(s1)
  return 0;
}
    80002046:	4501                	li	a0,0
    80002048:	60e2                	ld	ra,24(sp)
    8000204a:	6442                	ld	s0,16(sp)
    8000204c:	64a2                	ld	s1,8(sp)
    8000204e:	6105                	addi	sp,sp,32
    80002050:	8082                	ret

0000000080002052 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002052:	1101                	addi	sp,sp,-32
    80002054:	ec06                	sd	ra,24(sp)
    80002056:	e822                	sd	s0,16(sp)
    80002058:	e426                	sd	s1,8(sp)
    8000205a:	e04a                	sd	s2,0(sp)
    8000205c:	1000                	addi	s0,sp,32
    8000205e:	84ae                	mv	s1,a1
    80002060:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002062:	00000097          	auipc	ra,0x0
    80002066:	eaa080e7          	jalr	-342(ra) # 80001f0c <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    8000206a:	864a                	mv	a2,s2
    8000206c:	85a6                	mv	a1,s1
    8000206e:	00000097          	auipc	ra,0x0
    80002072:	f58080e7          	jalr	-168(ra) # 80001fc6 <fetchstr>
}
    80002076:	60e2                	ld	ra,24(sp)
    80002078:	6442                	ld	s0,16(sp)
    8000207a:	64a2                	ld	s1,8(sp)
    8000207c:	6902                	ld	s2,0(sp)
    8000207e:	6105                	addi	sp,sp,32
    80002080:	8082                	ret

0000000080002082 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80002082:	1101                	addi	sp,sp,-32
    80002084:	ec06                	sd	ra,24(sp)
    80002086:	e822                	sd	s0,16(sp)
    80002088:	e426                	sd	s1,8(sp)
    8000208a:	e04a                	sd	s2,0(sp)
    8000208c:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    8000208e:	fffff097          	auipc	ra,0xfffff
    80002092:	eca080e7          	jalr	-310(ra) # 80000f58 <myproc>
    80002096:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002098:	06053903          	ld	s2,96(a0)
    8000209c:	0a893783          	ld	a5,168(s2)
    800020a0:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800020a4:	37fd                	addiw	a5,a5,-1
    800020a6:	4751                	li	a4,20
    800020a8:	00f76f63          	bltu	a4,a5,800020c6 <syscall+0x44>
    800020ac:	00369713          	slli	a4,a3,0x3
    800020b0:	00006797          	auipc	a5,0x6
    800020b4:	31878793          	addi	a5,a5,792 # 800083c8 <syscalls>
    800020b8:	97ba                	add	a5,a5,a4
    800020ba:	639c                	ld	a5,0(a5)
    800020bc:	c789                	beqz	a5,800020c6 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    800020be:	9782                	jalr	a5
    800020c0:	06a93823          	sd	a0,112(s2)
    800020c4:	a839                	j	800020e2 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800020c6:	16048613          	addi	a2,s1,352
    800020ca:	5c8c                	lw	a1,56(s1)
    800020cc:	00006517          	auipc	a0,0x6
    800020d0:	2c450513          	addi	a0,a0,708 # 80008390 <states.0+0x150>
    800020d4:	00004097          	auipc	ra,0x4
    800020d8:	08a080e7          	jalr	138(ra) # 8000615e <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800020dc:	70bc                	ld	a5,96(s1)
    800020de:	577d                	li	a4,-1
    800020e0:	fbb8                	sd	a4,112(a5)
  }
}
    800020e2:	60e2                	ld	ra,24(sp)
    800020e4:	6442                	ld	s0,16(sp)
    800020e6:	64a2                	ld	s1,8(sp)
    800020e8:	6902                	ld	s2,0(sp)
    800020ea:	6105                	addi	sp,sp,32
    800020ec:	8082                	ret

00000000800020ee <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800020ee:	1101                	addi	sp,sp,-32
    800020f0:	ec06                	sd	ra,24(sp)
    800020f2:	e822                	sd	s0,16(sp)
    800020f4:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    800020f6:	fec40593          	addi	a1,s0,-20
    800020fa:	4501                	li	a0,0
    800020fc:	00000097          	auipc	ra,0x0
    80002100:	f12080e7          	jalr	-238(ra) # 8000200e <argint>
    return -1;
    80002104:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002106:	00054963          	bltz	a0,80002118 <sys_exit+0x2a>
  exit(n);
    8000210a:	fec42503          	lw	a0,-20(s0)
    8000210e:	fffff097          	auipc	ra,0xfffff
    80002112:	76a080e7          	jalr	1898(ra) # 80001878 <exit>
  return 0;  // not reached
    80002116:	4781                	li	a5,0
}
    80002118:	853e                	mv	a0,a5
    8000211a:	60e2                	ld	ra,24(sp)
    8000211c:	6442                	ld	s0,16(sp)
    8000211e:	6105                	addi	sp,sp,32
    80002120:	8082                	ret

0000000080002122 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002122:	1141                	addi	sp,sp,-16
    80002124:	e406                	sd	ra,8(sp)
    80002126:	e022                	sd	s0,0(sp)
    80002128:	0800                	addi	s0,sp,16
  return myproc()->pid;
    8000212a:	fffff097          	auipc	ra,0xfffff
    8000212e:	e2e080e7          	jalr	-466(ra) # 80000f58 <myproc>
}
    80002132:	5d08                	lw	a0,56(a0)
    80002134:	60a2                	ld	ra,8(sp)
    80002136:	6402                	ld	s0,0(sp)
    80002138:	0141                	addi	sp,sp,16
    8000213a:	8082                	ret

000000008000213c <sys_fork>:

uint64
sys_fork(void)
{
    8000213c:	1141                	addi	sp,sp,-16
    8000213e:	e406                	sd	ra,8(sp)
    80002140:	e022                	sd	s0,0(sp)
    80002142:	0800                	addi	s0,sp,16
  return fork();
    80002144:	fffff097          	auipc	ra,0xfffff
    80002148:	1e6080e7          	jalr	486(ra) # 8000132a <fork>
}
    8000214c:	60a2                	ld	ra,8(sp)
    8000214e:	6402                	ld	s0,0(sp)
    80002150:	0141                	addi	sp,sp,16
    80002152:	8082                	ret

0000000080002154 <sys_wait>:

uint64
sys_wait(void)
{
    80002154:	1101                	addi	sp,sp,-32
    80002156:	ec06                	sd	ra,24(sp)
    80002158:	e822                	sd	s0,16(sp)
    8000215a:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    8000215c:	fe840593          	addi	a1,s0,-24
    80002160:	4501                	li	a0,0
    80002162:	00000097          	auipc	ra,0x0
    80002166:	ece080e7          	jalr	-306(ra) # 80002030 <argaddr>
    8000216a:	87aa                	mv	a5,a0
    return -1;
    8000216c:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    8000216e:	0007c863          	bltz	a5,8000217e <sys_wait+0x2a>
  return wait(p);
    80002172:	fe843503          	ld	a0,-24(s0)
    80002176:	fffff097          	auipc	ra,0xfffff
    8000217a:	50a080e7          	jalr	1290(ra) # 80001680 <wait>
}
    8000217e:	60e2                	ld	ra,24(sp)
    80002180:	6442                	ld	s0,16(sp)
    80002182:	6105                	addi	sp,sp,32
    80002184:	8082                	ret

0000000080002186 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002186:	7179                	addi	sp,sp,-48
    80002188:	f406                	sd	ra,40(sp)
    8000218a:	f022                	sd	s0,32(sp)
    8000218c:	ec26                	sd	s1,24(sp)
    8000218e:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002190:	fdc40593          	addi	a1,s0,-36
    80002194:	4501                	li	a0,0
    80002196:	00000097          	auipc	ra,0x0
    8000219a:	e78080e7          	jalr	-392(ra) # 8000200e <argint>
    8000219e:	87aa                	mv	a5,a0
    return -1;
    800021a0:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    800021a2:	0207c063          	bltz	a5,800021c2 <sys_sbrk+0x3c>
  addr = myproc()->sz;
    800021a6:	fffff097          	auipc	ra,0xfffff
    800021aa:	db2080e7          	jalr	-590(ra) # 80000f58 <myproc>
    800021ae:	4924                	lw	s1,80(a0)
  if(growproc(n) < 0)
    800021b0:	fdc42503          	lw	a0,-36(s0)
    800021b4:	fffff097          	auipc	ra,0xfffff
    800021b8:	0fe080e7          	jalr	254(ra) # 800012b2 <growproc>
    800021bc:	00054863          	bltz	a0,800021cc <sys_sbrk+0x46>
    return -1;
  return addr;
    800021c0:	8526                	mv	a0,s1
}
    800021c2:	70a2                	ld	ra,40(sp)
    800021c4:	7402                	ld	s0,32(sp)
    800021c6:	64e2                	ld	s1,24(sp)
    800021c8:	6145                	addi	sp,sp,48
    800021ca:	8082                	ret
    return -1;
    800021cc:	557d                	li	a0,-1
    800021ce:	bfd5                	j	800021c2 <sys_sbrk+0x3c>

00000000800021d0 <sys_sleep>:

uint64
sys_sleep(void)
{
    800021d0:	7139                	addi	sp,sp,-64
    800021d2:	fc06                	sd	ra,56(sp)
    800021d4:	f822                	sd	s0,48(sp)
    800021d6:	f426                	sd	s1,40(sp)
    800021d8:	f04a                	sd	s2,32(sp)
    800021da:	ec4e                	sd	s3,24(sp)
    800021dc:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    800021de:	fcc40593          	addi	a1,s0,-52
    800021e2:	4501                	li	a0,0
    800021e4:	00000097          	auipc	ra,0x0
    800021e8:	e2a080e7          	jalr	-470(ra) # 8000200e <argint>
    return -1;
    800021ec:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800021ee:	06054563          	bltz	a0,80002258 <sys_sleep+0x88>
  acquire(&tickslock);
    800021f2:	0000d517          	auipc	a0,0xd
    800021f6:	fbe50513          	addi	a0,a0,-66 # 8000f1b0 <tickslock>
    800021fa:	00004097          	auipc	ra,0x4
    800021fe:	43c080e7          	jalr	1084(ra) # 80006636 <acquire>
  ticks0 = ticks;
    80002202:	00007917          	auipc	s2,0x7
    80002206:	e1692903          	lw	s2,-490(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    8000220a:	fcc42783          	lw	a5,-52(s0)
    8000220e:	cf85                	beqz	a5,80002246 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002210:	0000d997          	auipc	s3,0xd
    80002214:	fa098993          	addi	s3,s3,-96 # 8000f1b0 <tickslock>
    80002218:	00007497          	auipc	s1,0x7
    8000221c:	e0048493          	addi	s1,s1,-512 # 80009018 <ticks>
    if(myproc()->killed){
    80002220:	fffff097          	auipc	ra,0xfffff
    80002224:	d38080e7          	jalr	-712(ra) # 80000f58 <myproc>
    80002228:	591c                	lw	a5,48(a0)
    8000222a:	ef9d                	bnez	a5,80002268 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    8000222c:	85ce                	mv	a1,s3
    8000222e:	8526                	mv	a0,s1
    80002230:	fffff097          	auipc	ra,0xfffff
    80002234:	3ec080e7          	jalr	1004(ra) # 8000161c <sleep>
  while(ticks - ticks0 < n){
    80002238:	409c                	lw	a5,0(s1)
    8000223a:	412787bb          	subw	a5,a5,s2
    8000223e:	fcc42703          	lw	a4,-52(s0)
    80002242:	fce7efe3          	bltu	a5,a4,80002220 <sys_sleep+0x50>
  }
  release(&tickslock);
    80002246:	0000d517          	auipc	a0,0xd
    8000224a:	f6a50513          	addi	a0,a0,-150 # 8000f1b0 <tickslock>
    8000224e:	00004097          	auipc	ra,0x4
    80002252:	4b8080e7          	jalr	1208(ra) # 80006706 <release>
  return 0;
    80002256:	4781                	li	a5,0
}
    80002258:	853e                	mv	a0,a5
    8000225a:	70e2                	ld	ra,56(sp)
    8000225c:	7442                	ld	s0,48(sp)
    8000225e:	74a2                	ld	s1,40(sp)
    80002260:	7902                	ld	s2,32(sp)
    80002262:	69e2                	ld	s3,24(sp)
    80002264:	6121                	addi	sp,sp,64
    80002266:	8082                	ret
      release(&tickslock);
    80002268:	0000d517          	auipc	a0,0xd
    8000226c:	f4850513          	addi	a0,a0,-184 # 8000f1b0 <tickslock>
    80002270:	00004097          	auipc	ra,0x4
    80002274:	496080e7          	jalr	1174(ra) # 80006706 <release>
      return -1;
    80002278:	57fd                	li	a5,-1
    8000227a:	bff9                	j	80002258 <sys_sleep+0x88>

000000008000227c <sys_kill>:

uint64
sys_kill(void)
{
    8000227c:	1101                	addi	sp,sp,-32
    8000227e:	ec06                	sd	ra,24(sp)
    80002280:	e822                	sd	s0,16(sp)
    80002282:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002284:	fec40593          	addi	a1,s0,-20
    80002288:	4501                	li	a0,0
    8000228a:	00000097          	auipc	ra,0x0
    8000228e:	d84080e7          	jalr	-636(ra) # 8000200e <argint>
    80002292:	87aa                	mv	a5,a0
    return -1;
    80002294:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002296:	0007c863          	bltz	a5,800022a6 <sys_kill+0x2a>
  return kill(pid);
    8000229a:	fec42503          	lw	a0,-20(s0)
    8000229e:	fffff097          	auipc	ra,0xfffff
    800022a2:	6b0080e7          	jalr	1712(ra) # 8000194e <kill>
}
    800022a6:	60e2                	ld	ra,24(sp)
    800022a8:	6442                	ld	s0,16(sp)
    800022aa:	6105                	addi	sp,sp,32
    800022ac:	8082                	ret

00000000800022ae <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800022ae:	1101                	addi	sp,sp,-32
    800022b0:	ec06                	sd	ra,24(sp)
    800022b2:	e822                	sd	s0,16(sp)
    800022b4:	e426                	sd	s1,8(sp)
    800022b6:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800022b8:	0000d517          	auipc	a0,0xd
    800022bc:	ef850513          	addi	a0,a0,-264 # 8000f1b0 <tickslock>
    800022c0:	00004097          	auipc	ra,0x4
    800022c4:	376080e7          	jalr	886(ra) # 80006636 <acquire>
  xticks = ticks;
    800022c8:	00007497          	auipc	s1,0x7
    800022cc:	d504a483          	lw	s1,-688(s1) # 80009018 <ticks>
  release(&tickslock);
    800022d0:	0000d517          	auipc	a0,0xd
    800022d4:	ee050513          	addi	a0,a0,-288 # 8000f1b0 <tickslock>
    800022d8:	00004097          	auipc	ra,0x4
    800022dc:	42e080e7          	jalr	1070(ra) # 80006706 <release>
  return xticks;
}
    800022e0:	02049513          	slli	a0,s1,0x20
    800022e4:	9101                	srli	a0,a0,0x20
    800022e6:	60e2                	ld	ra,24(sp)
    800022e8:	6442                	ld	s0,16(sp)
    800022ea:	64a2                	ld	s1,8(sp)
    800022ec:	6105                	addi	sp,sp,32
    800022ee:	8082                	ret

00000000800022f0 <binit>:
  struct buf heads[NUM_BUCKET];
} bcache;

void
binit(void)
{
    800022f0:	715d                	addi	sp,sp,-80
    800022f2:	e486                	sd	ra,72(sp)
    800022f4:	e0a2                	sd	s0,64(sp)
    800022f6:	fc26                	sd	s1,56(sp)
    800022f8:	f84a                	sd	s2,48(sp)
    800022fa:	f44e                	sd	s3,40(sp)
    800022fc:	f052                	sd	s4,32(sp)
    800022fe:	ec56                	sd	s5,24(sp)
    80002300:	e85a                	sd	s6,16(sp)
    80002302:	e45e                	sd	s7,8(sp)
    80002304:	e062                	sd	s8,0(sp)
    80002306:	0880                	addi	s0,sp,80
  struct buf* b;
  char* lockname = "bcache0";
  uint i;
  // 初始化锁和头节点
  for (i = 0; i < NUM_BUCKET; ++i) {
    80002308:	0000d917          	auipc	s2,0xd
    8000230c:	ec890913          	addi	s2,s2,-312 # 8000f1d0 <bcache>
    80002310:	00015497          	auipc	s1,0x15
    80002314:	3a048493          	addi	s1,s1,928 # 800176b0 <bcache+0x84e0>
    80002318:	00019a97          	auipc	s5,0x19
    8000231c:	c78a8a93          	addi	s5,s5,-904 # 8001af90 <sb>
      initlock(bcache.locks + i, lockname);
    80002320:	00006997          	auipc	s3,0x6
    80002324:	15898993          	addi	s3,s3,344 # 80008478 <syscalls+0xb0>
      ++lockname[6];
    80002328:	03100a13          	li	s4,49
      initlock(bcache.locks + i, lockname);
    8000232c:	85ce                	mv	a1,s3
    8000232e:	854a                	mv	a0,s2
    80002330:	00004097          	auipc	ra,0x4
    80002334:	482080e7          	jalr	1154(ra) # 800067b2 <initlock>
      ++lockname[6];
    80002338:	01498323          	sb	s4,6(s3)
      bcache.heads[i].prev = bcache.heads + i;
    8000233c:	e8a4                	sd	s1,80(s1)
      bcache.heads[i].next = bcache.heads + i;
    8000233e:	eca4                	sd	s1,88(s1)
  for (i = 0; i < NUM_BUCKET; ++i) {
    80002340:	02090913          	addi	s2,s2,32
    80002344:	46048493          	addi	s1,s1,1120
    80002348:	ff5492e3          	bne	s1,s5,8000232c <binit+0x3c>
  }
  // 将buf放入哈希表中
  for (b = bcache.buf; b < bcache.buf + NBUF; ++b) {
    8000234c:	0000d497          	auipc	s1,0xd
    80002350:	02448493          	addi	s1,s1,36 # 8000f370 <bcache+0x1a0>
      i = HASH(b->blockno);  
    80002354:	4bb5                	li	s7,13
      b->next = bcache.heads[i].next;
    80002356:	0000db17          	auipc	s6,0xd
    8000235a:	e7ab0b13          	addi	s6,s6,-390 # 8000f1d0 <bcache>
    8000235e:	46000a93          	li	s5,1120
    80002362:	6a21                	lui	s4,0x8
      b->prev = bcache.heads + i;
    80002364:	00015917          	auipc	s2,0x15
    80002368:	34c90913          	addi	s2,s2,844 # 800176b0 <bcache+0x84e0>
      initsleeplock(&b->lock, "buffer");
    8000236c:	00006997          	auipc	s3,0x6
    80002370:	11498993          	addi	s3,s3,276 # 80008480 <syscalls+0xb8>
      i = HASH(b->blockno);  
    80002374:	44dc                	lw	a5,12(s1)
    80002376:	0377f7bb          	remuw	a5,a5,s7
      b->next = bcache.heads[i].next;
    8000237a:	1782                	slli	a5,a5,0x20
    8000237c:	9381                	srli	a5,a5,0x20
    8000237e:	035787b3          	mul	a5,a5,s5
    80002382:	00fb0c33          	add	s8,s6,a5
    80002386:	9c52                	add	s8,s8,s4
    80002388:	538c3703          	ld	a4,1336(s8)
    8000238c:	ecb8                	sd	a4,88(s1)
      b->prev = bcache.heads + i;
    8000238e:	97ca                	add	a5,a5,s2
    80002390:	e8bc                	sd	a5,80(s1)
      initsleeplock(&b->lock, "buffer");
    80002392:	85ce                	mv	a1,s3
    80002394:	01048513          	addi	a0,s1,16
    80002398:	00001097          	auipc	ra,0x1
    8000239c:	658080e7          	jalr	1624(ra) # 800039f0 <initsleeplock>
      bcache.heads[i].next->prev = b;
    800023a0:	538c3783          	ld	a5,1336(s8)
    800023a4:	eba4                	sd	s1,80(a5)
      bcache.heads[i].next = b;
    800023a6:	529c3c23          	sd	s1,1336(s8)
  for (b = bcache.buf; b < bcache.buf + NBUF; ++b) {
    800023aa:	46048493          	addi	s1,s1,1120
    800023ae:	fd2493e3          	bne	s1,s2,80002374 <binit+0x84>
  }
}
    800023b2:	60a6                	ld	ra,72(sp)
    800023b4:	6406                	ld	s0,64(sp)
    800023b6:	74e2                	ld	s1,56(sp)
    800023b8:	7942                	ld	s2,48(sp)
    800023ba:	79a2                	ld	s3,40(sp)
    800023bc:	7a02                	ld	s4,32(sp)
    800023be:	6ae2                	ld	s5,24(sp)
    800023c0:	6b42                	ld	s6,16(sp)
    800023c2:	6ba2                	ld	s7,8(sp)
    800023c4:	6c02                	ld	s8,0(sp)
    800023c6:	6161                	addi	sp,sp,80
    800023c8:	8082                	ret

00000000800023ca <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800023ca:	7159                	addi	sp,sp,-112
    800023cc:	f486                	sd	ra,104(sp)
    800023ce:	f0a2                	sd	s0,96(sp)
    800023d0:	eca6                	sd	s1,88(sp)
    800023d2:	e8ca                	sd	s2,80(sp)
    800023d4:	e4ce                	sd	s3,72(sp)
    800023d6:	e0d2                	sd	s4,64(sp)
    800023d8:	fc56                	sd	s5,56(sp)
    800023da:	f85a                	sd	s6,48(sp)
    800023dc:	f45e                	sd	s7,40(sp)
    800023de:	f062                	sd	s8,32(sp)
    800023e0:	ec66                	sd	s9,24(sp)
    800023e2:	e86a                	sd	s10,16(sp)
    800023e4:	e46e                	sd	s11,8(sp)
    800023e6:	1880                	addi	s0,sp,112
    800023e8:	89aa                	mv	s3,a0
    800023ea:	8a2e                	mv	s4,a1
  uint jdx, idx = HASH(blockno);
    800023ec:	4ab5                	li	s5,13
    800023ee:	0355fabb          	remuw	s5,a1,s5
    800023f2:	000a8d1b          	sext.w	s10,s5
  acquire(bcache.locks + idx); // 获取本桶的锁
    800023f6:	020a9913          	slli	s2,s5,0x20
    800023fa:	02095913          	srli	s2,s2,0x20
    800023fe:	00591b93          	slli	s7,s2,0x5
    80002402:	0000d497          	auipc	s1,0xd
    80002406:	dce48493          	addi	s1,s1,-562 # 8000f1d0 <bcache>
    8000240a:	9ba6                	add	s7,s7,s1
    8000240c:	855e                	mv	a0,s7
    8000240e:	00004097          	auipc	ra,0x4
    80002412:	228080e7          	jalr	552(ra) # 80006636 <acquire>
  for (b = bcache.heads[idx].next; b != bcache.heads + idx; b = b->next) {
    80002416:	46000793          	li	a5,1120
    8000241a:	02f90933          	mul	s2,s2,a5
    8000241e:	94ca                	add	s1,s1,s2
    80002420:	67a1                	lui	a5,0x8
    80002422:	97a6                	add	a5,a5,s1
    80002424:	5387b483          	ld	s1,1336(a5) # 8538 <_entry-0x7fff7ac8>
    80002428:	00015797          	auipc	a5,0x15
    8000242c:	28878793          	addi	a5,a5,648 # 800176b0 <bcache+0x84e0>
    80002430:	993e                	add	s2,s2,a5
    80002432:	05249f63          	bne	s1,s2,80002490 <bread+0xc6>
  for (b = bcache.heads[idx].prev; b != bcache.heads + idx; b = b->prev) {
    80002436:	020a9793          	slli	a5,s5,0x20
    8000243a:	9381                	srli	a5,a5,0x20
    8000243c:	46000713          	li	a4,1120
    80002440:	02e787b3          	mul	a5,a5,a4
    80002444:	0000d717          	auipc	a4,0xd
    80002448:	d8c70713          	addi	a4,a4,-628 # 8000f1d0 <bcache>
    8000244c:	973e                	add	a4,a4,a5
    8000244e:	67a1                	lui	a5,0x8
    80002450:	97ba                	add	a5,a5,a4
    80002452:	5307b483          	ld	s1,1328(a5) # 8530 <_entry-0x7fff7ad0>
    80002456:	01248763          	beq	s1,s2,80002464 <bread+0x9a>
      if (b->refcnt == 0) {
    8000245a:	44bc                	lw	a5,72(s1)
    8000245c:	cfb9                	beqz	a5,800024ba <bread+0xf0>
  for (b = bcache.heads[idx].prev; b != bcache.heads + idx; b = b->prev) {
    8000245e:	68a4                	ld	s1,80(s1)
    80002460:	ff249de3          	bne	s1,s2,8000245a <bread+0x90>
  release(bcache.locks + idx);
    80002464:	855e                	mv	a0,s7
    80002466:	00004097          	auipc	ra,0x4
    8000246a:	2a0080e7          	jalr	672(ra) # 80006706 <release>
  for (jdx = HASH(idx + 1); jdx != idx; jdx = (jdx + 1) % NUM_BUCKET) {
    8000246e:	001a8b1b          	addiw	s6,s5,1
    80002472:	47b5                	li	a5,13
    80002474:	02fb7b3b          	remuw	s6,s6,a5
    80002478:	156d0d63          	beq	s10,s6,800025d2 <bread+0x208>
      acquire(bcache.locks + jdx);
    8000247c:	0000dc97          	auipc	s9,0xd
    80002480:	d54c8c93          	addi	s9,s9,-684 # 8000f1d0 <bcache>
      for (b = bcache.heads[jdx].prev; b != bcache.heads + jdx; b = b->prev) {
    80002484:	46000d93          	li	s11,1120
    80002488:	a229                	j	80002592 <bread+0x1c8>
  for (b = bcache.heads[idx].next; b != bcache.heads + idx; b = b->next) {
    8000248a:	6ca4                	ld	s1,88(s1)
    8000248c:	fb2485e3          	beq	s1,s2,80002436 <bread+0x6c>
      if (b->dev == dev && b->blockno == blockno) {
    80002490:	449c                	lw	a5,8(s1)
    80002492:	ff379ce3          	bne	a5,s3,8000248a <bread+0xc0>
    80002496:	44dc                	lw	a5,12(s1)
    80002498:	ff4799e3          	bne	a5,s4,8000248a <bread+0xc0>
          b->refcnt++;
    8000249c:	44bc                	lw	a5,72(s1)
    8000249e:	2785                	addiw	a5,a5,1
    800024a0:	c4bc                	sw	a5,72(s1)
          release(bcache.locks + idx);
    800024a2:	855e                	mv	a0,s7
    800024a4:	00004097          	auipc	ra,0x4
    800024a8:	262080e7          	jalr	610(ra) # 80006706 <release>
          acquiresleep(&b->lock);
    800024ac:	01048513          	addi	a0,s1,16
    800024b0:	00001097          	auipc	ra,0x1
    800024b4:	57a080e7          	jalr	1402(ra) # 80003a2a <acquiresleep>
          return b;  
    800024b8:	a045                	j	80002558 <bread+0x18e>
          b->dev = dev;
    800024ba:	0134a423          	sw	s3,8(s1)
          b->blockno = blockno;
    800024be:	0144a623          	sw	s4,12(s1)
          b->valid = 0;
    800024c2:	0004a023          	sw	zero,0(s1)
          b->refcnt = 1;
    800024c6:	4785                	li	a5,1
    800024c8:	c4bc                	sw	a5,72(s1)
          release(bcache.locks + idx);
    800024ca:	855e                	mv	a0,s7
    800024cc:	00004097          	auipc	ra,0x4
    800024d0:	23a080e7          	jalr	570(ra) # 80006706 <release>
          acquiresleep(&b->lock);
    800024d4:	01048513          	addi	a0,s1,16
    800024d8:	00001097          	auipc	ra,0x1
    800024dc:	552080e7          	jalr	1362(ra) # 80003a2a <acquiresleep>
          return b;  
    800024e0:	a8a5                	j	80002558 <bread+0x18e>
              b->dev = dev;
    800024e2:	0134a423          	sw	s3,8(s1)
              b->blockno = blockno;
    800024e6:	0144a623          	sw	s4,12(s1)
              b->valid = 0;
    800024ea:	0004a023          	sw	zero,0(s1)
              b->refcnt = 1;
    800024ee:	4785                	li	a5,1
    800024f0:	c4bc                	sw	a5,72(s1)
              b->next->prev = b->prev;
    800024f2:	6cbc                	ld	a5,88(s1)
    800024f4:	68b8                	ld	a4,80(s1)
    800024f6:	ebb8                	sd	a4,80(a5)
              b->prev->next = b->next;
    800024f8:	68bc                	ld	a5,80(s1)
    800024fa:	6cb8                	ld	a4,88(s1)
    800024fc:	efb8                	sd	a4,88(a5)
              release(bcache.locks + jdx); // 释放jdx桶的锁
    800024fe:	8562                	mv	a0,s8
    80002500:	00004097          	auipc	ra,0x4
    80002504:	206080e7          	jalr	518(ra) # 80006706 <release>
              acquire(bcache.locks + idx);  // 重新获取idx桶的锁
    80002508:	855e                	mv	a0,s7
    8000250a:	00004097          	auipc	ra,0x4
    8000250e:	12c080e7          	jalr	300(ra) # 80006636 <acquire>
              b->next = bcache.heads[idx].next;
    80002512:	1a82                	slli	s5,s5,0x20
    80002514:	020ada93          	srli	s5,s5,0x20
    80002518:	46000793          	li	a5,1120
    8000251c:	02fa8ab3          	mul	s5,s5,a5
    80002520:	0000d717          	auipc	a4,0xd
    80002524:	cb070713          	addi	a4,a4,-848 # 8000f1d0 <bcache>
    80002528:	9756                	add	a4,a4,s5
    8000252a:	67a1                	lui	a5,0x8
    8000252c:	97ba                	add	a5,a5,a4
    8000252e:	5387b703          	ld	a4,1336(a5) # 8538 <_entry-0x7fff7ac8>
    80002532:	ecb8                	sd	a4,88(s1)
              b->prev = bcache.heads + idx;
    80002534:	0524b823          	sd	s2,80(s1)
              bcache.heads[idx].next->prev = b;
    80002538:	5387b703          	ld	a4,1336(a5)
    8000253c:	eb24                	sd	s1,80(a4)
              bcache.heads[idx].next = b;
    8000253e:	5297bc23          	sd	s1,1336(a5)
              release(bcache.locks + idx);  // 操作后释放idx桶的锁
    80002542:	855e                	mv	a0,s7
    80002544:	00004097          	auipc	ra,0x4
    80002548:	1c2080e7          	jalr	450(ra) # 80006706 <release>
              acquiresleep(&b->lock);
    8000254c:	01048513          	addi	a0,s1,16
    80002550:	00001097          	auipc	ra,0x1
    80002554:	4da080e7          	jalr	1242(ra) # 80003a2a <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002558:	409c                	lw	a5,0(s1)
    8000255a:	c7c1                	beqz	a5,800025e2 <bread+0x218>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000255c:	8526                	mv	a0,s1
    8000255e:	70a6                	ld	ra,104(sp)
    80002560:	7406                	ld	s0,96(sp)
    80002562:	64e6                	ld	s1,88(sp)
    80002564:	6946                	ld	s2,80(sp)
    80002566:	69a6                	ld	s3,72(sp)
    80002568:	6a06                	ld	s4,64(sp)
    8000256a:	7ae2                	ld	s5,56(sp)
    8000256c:	7b42                	ld	s6,48(sp)
    8000256e:	7ba2                	ld	s7,40(sp)
    80002570:	7c02                	ld	s8,32(sp)
    80002572:	6ce2                	ld	s9,24(sp)
    80002574:	6d42                	ld	s10,16(sp)
    80002576:	6da2                	ld	s11,8(sp)
    80002578:	6165                	addi	sp,sp,112
    8000257a:	8082                	ret
      release(bcache.locks + jdx);
    8000257c:	8562                	mv	a0,s8
    8000257e:	00004097          	auipc	ra,0x4
    80002582:	188080e7          	jalr	392(ra) # 80006706 <release>
  for (jdx = HASH(idx + 1); jdx != idx; jdx = (jdx + 1) % NUM_BUCKET) {
    80002586:	2b05                	addiw	s6,s6,1
    80002588:	47b5                	li	a5,13
    8000258a:	02fb7b3b          	remuw	s6,s6,a5
    8000258e:	056d0263          	beq	s10,s6,800025d2 <bread+0x208>
      acquire(bcache.locks + jdx);
    80002592:	020b1493          	slli	s1,s6,0x20
    80002596:	9081                	srli	s1,s1,0x20
    80002598:	005b1c13          	slli	s8,s6,0x5
    8000259c:	9c66                	add	s8,s8,s9
    8000259e:	8562                	mv	a0,s8
    800025a0:	00004097          	auipc	ra,0x4
    800025a4:	096080e7          	jalr	150(ra) # 80006636 <acquire>
      for (b = bcache.heads[jdx].prev; b != bcache.heads + jdx; b = b->prev) {
    800025a8:	03b48733          	mul	a4,s1,s11
    800025ac:	00ec87b3          	add	a5,s9,a4
    800025b0:	66a1                	lui	a3,0x8
    800025b2:	97b6                	add	a5,a5,a3
    800025b4:	5307b483          	ld	s1,1328(a5)
    800025b8:	00015797          	auipc	a5,0x15
    800025bc:	0f878793          	addi	a5,a5,248 # 800176b0 <bcache+0x84e0>
    800025c0:	973e                	add	a4,a4,a5
    800025c2:	fae48de3          	beq	s1,a4,8000257c <bread+0x1b2>
          if (b->refcnt == 0) {
    800025c6:	44bc                	lw	a5,72(s1)
    800025c8:	df89                	beqz	a5,800024e2 <bread+0x118>
      for (b = bcache.heads[jdx].prev; b != bcache.heads + jdx; b = b->prev) {
    800025ca:	68a4                	ld	s1,80(s1)
    800025cc:	fee49de3          	bne	s1,a4,800025c6 <bread+0x1fc>
    800025d0:	b775                	j	8000257c <bread+0x1b2>
  panic("bget: no buffers");
    800025d2:	00006517          	auipc	a0,0x6
    800025d6:	eb650513          	addi	a0,a0,-330 # 80008488 <syscalls+0xc0>
    800025da:	00004097          	auipc	ra,0x4
    800025de:	b3a080e7          	jalr	-1222(ra) # 80006114 <panic>
    virtio_disk_rw(b, 0);
    800025e2:	4581                	li	a1,0
    800025e4:	8526                	mv	a0,s1
    800025e6:	00003097          	auipc	ra,0x3
    800025ea:	f8c080e7          	jalr	-116(ra) # 80005572 <virtio_disk_rw>
    b->valid = 1;
    800025ee:	4785                	li	a5,1
    800025f0:	c09c                	sw	a5,0(s1)
  return b;
    800025f2:	b7ad                	j	8000255c <bread+0x192>

00000000800025f4 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800025f4:	1101                	addi	sp,sp,-32
    800025f6:	ec06                	sd	ra,24(sp)
    800025f8:	e822                	sd	s0,16(sp)
    800025fa:	e426                	sd	s1,8(sp)
    800025fc:	1000                	addi	s0,sp,32
    800025fe:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002600:	0541                	addi	a0,a0,16
    80002602:	00001097          	auipc	ra,0x1
    80002606:	4c2080e7          	jalr	1218(ra) # 80003ac4 <holdingsleep>
    8000260a:	cd01                	beqz	a0,80002622 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000260c:	4585                	li	a1,1
    8000260e:	8526                	mv	a0,s1
    80002610:	00003097          	auipc	ra,0x3
    80002614:	f62080e7          	jalr	-158(ra) # 80005572 <virtio_disk_rw>
}
    80002618:	60e2                	ld	ra,24(sp)
    8000261a:	6442                	ld	s0,16(sp)
    8000261c:	64a2                	ld	s1,8(sp)
    8000261e:	6105                	addi	sp,sp,32
    80002620:	8082                	ret
    panic("bwrite");
    80002622:	00006517          	auipc	a0,0x6
    80002626:	e7e50513          	addi	a0,a0,-386 # 800084a0 <syscalls+0xd8>
    8000262a:	00004097          	auipc	ra,0x4
    8000262e:	aea080e7          	jalr	-1302(ra) # 80006114 <panic>

0000000080002632 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002632:	7179                	addi	sp,sp,-48
    80002634:	f406                	sd	ra,40(sp)
    80002636:	f022                	sd	s0,32(sp)
    80002638:	ec26                	sd	s1,24(sp)
    8000263a:	e84a                	sd	s2,16(sp)
    8000263c:	e44e                	sd	s3,8(sp)
    8000263e:	e052                	sd	s4,0(sp)
    80002640:	1800                	addi	s0,sp,48
    80002642:	84aa                	mv	s1,a0
  uint idx = HASH(b->blockno);
    80002644:	00c52903          	lw	s2,12(a0)
    80002648:	47b5                	li	a5,13
    8000264a:	02f9793b          	remuw	s2,s2,a5
  if (!holdingsleep(&b->lock)){
    8000264e:	01050993          	addi	s3,a0,16
    80002652:	854e                	mv	a0,s3
    80002654:	00001097          	auipc	ra,0x1
    80002658:	470080e7          	jalr	1136(ra) # 80003ac4 <holdingsleep>
    8000265c:	c949                	beqz	a0,800026ee <brelse+0xbc>
      panic("brelse");
  } 
  releasesleep(&b->lock);
    8000265e:	854e                	mv	a0,s3
    80002660:	00001097          	auipc	ra,0x1
    80002664:	420080e7          	jalr	1056(ra) # 80003a80 <releasesleep>

  acquire(bcache.locks + idx);
    80002668:	02091a13          	slli	s4,s2,0x20
    8000266c:	020a5a13          	srli	s4,s4,0x20
    80002670:	005a1993          	slli	s3,s4,0x5
    80002674:	0000d797          	auipc	a5,0xd
    80002678:	b5c78793          	addi	a5,a5,-1188 # 8000f1d0 <bcache>
    8000267c:	99be                	add	s3,s3,a5
    8000267e:	854e                	mv	a0,s3
    80002680:	00004097          	auipc	ra,0x4
    80002684:	fb6080e7          	jalr	-74(ra) # 80006636 <acquire>
  b->refcnt--;
    80002688:	44bc                	lw	a5,72(s1)
    8000268a:	37fd                	addiw	a5,a5,-1
    8000268c:	0007871b          	sext.w	a4,a5
    80002690:	c4bc                	sw	a5,72(s1)
  if (b->refcnt == 0) {
    80002692:	e329                	bnez	a4,800026d4 <brelse+0xa2>
      // 将b从列表中删去
      b->next->prev = b->prev;
    80002694:	6cbc                	ld	a5,88(s1)
    80002696:	68b8                	ld	a4,80(s1)
    80002698:	ebb8                	sd	a4,80(a5)
      b->prev->next = b->next;
    8000269a:	68bc                	ld	a5,80(s1)
    8000269c:	6cb8                	ld	a4,88(s1)
    8000269e:	efb8                	sd	a4,88(a5)
      // 将b加入到本桶list head的左边
      b->prev = bcache.heads[idx].prev;
    800026a0:	46000693          	li	a3,1120
    800026a4:	02da0933          	mul	s2,s4,a3
    800026a8:	0000d797          	auipc	a5,0xd
    800026ac:	b2878793          	addi	a5,a5,-1240 # 8000f1d0 <bcache>
    800026b0:	97ca                	add	a5,a5,s2
    800026b2:	6721                	lui	a4,0x8
    800026b4:	973e                	add	a4,a4,a5
    800026b6:	53073783          	ld	a5,1328(a4) # 8530 <_entry-0x7fff7ad0>
    800026ba:	e8bc                	sd	a5,80(s1)
      b->next = bcache.heads + idx;
    800026bc:	00015697          	auipc	a3,0x15
    800026c0:	ff468693          	addi	a3,a3,-12 # 800176b0 <bcache+0x84e0>
    800026c4:	00d907b3          	add	a5,s2,a3
    800026c8:	ecbc                	sd	a5,88(s1)
      bcache.heads[idx].prev->next = b;
    800026ca:	53073783          	ld	a5,1328(a4)
    800026ce:	efa4                	sd	s1,88(a5)
      bcache.heads[idx].prev = b;
    800026d0:	52973823          	sd	s1,1328(a4)
  }
  release(bcache.locks + idx);
    800026d4:	854e                	mv	a0,s3
    800026d6:	00004097          	auipc	ra,0x4
    800026da:	030080e7          	jalr	48(ra) # 80006706 <release>
}
    800026de:	70a2                	ld	ra,40(sp)
    800026e0:	7402                	ld	s0,32(sp)
    800026e2:	64e2                	ld	s1,24(sp)
    800026e4:	6942                	ld	s2,16(sp)
    800026e6:	69a2                	ld	s3,8(sp)
    800026e8:	6a02                	ld	s4,0(sp)
    800026ea:	6145                	addi	sp,sp,48
    800026ec:	8082                	ret
      panic("brelse");
    800026ee:	00006517          	auipc	a0,0x6
    800026f2:	dba50513          	addi	a0,a0,-582 # 800084a8 <syscalls+0xe0>
    800026f6:	00004097          	auipc	ra,0x4
    800026fa:	a1e080e7          	jalr	-1506(ra) # 80006114 <panic>

00000000800026fe <bpin>:

void
bpin(struct buf *b) {
    800026fe:	1101                	addi	sp,sp,-32
    80002700:	ec06                	sd	ra,24(sp)
    80002702:	e822                	sd	s0,16(sp)
    80002704:	e426                	sd	s1,8(sp)
    80002706:	e04a                	sd	s2,0(sp)
    80002708:	1000                	addi	s0,sp,32
    8000270a:	892a                	mv	s2,a0
  uint idx = HASH(b->blockno);
    8000270c:	4544                	lw	s1,12(a0)
    8000270e:	47b5                	li	a5,13
    80002710:	02f4f4bb          	remuw	s1,s1,a5
  acquire(bcache.locks + idx);
    80002714:	1482                	slli	s1,s1,0x20
    80002716:	9081                	srli	s1,s1,0x20
    80002718:	0496                	slli	s1,s1,0x5
    8000271a:	0000d797          	auipc	a5,0xd
    8000271e:	ab678793          	addi	a5,a5,-1354 # 8000f1d0 <bcache>
    80002722:	94be                	add	s1,s1,a5
    80002724:	8526                	mv	a0,s1
    80002726:	00004097          	auipc	ra,0x4
    8000272a:	f10080e7          	jalr	-240(ra) # 80006636 <acquire>
  b->refcnt++;
    8000272e:	04892783          	lw	a5,72(s2)
    80002732:	2785                	addiw	a5,a5,1
    80002734:	04f92423          	sw	a5,72(s2)
  release(bcache.locks + idx);
    80002738:	8526                	mv	a0,s1
    8000273a:	00004097          	auipc	ra,0x4
    8000273e:	fcc080e7          	jalr	-52(ra) # 80006706 <release>
}
    80002742:	60e2                	ld	ra,24(sp)
    80002744:	6442                	ld	s0,16(sp)
    80002746:	64a2                	ld	s1,8(sp)
    80002748:	6902                	ld	s2,0(sp)
    8000274a:	6105                	addi	sp,sp,32
    8000274c:	8082                	ret

000000008000274e <bunpin>:

void
bunpin(struct buf *b) {
    8000274e:	1101                	addi	sp,sp,-32
    80002750:	ec06                	sd	ra,24(sp)
    80002752:	e822                	sd	s0,16(sp)
    80002754:	e426                	sd	s1,8(sp)
    80002756:	e04a                	sd	s2,0(sp)
    80002758:	1000                	addi	s0,sp,32
    8000275a:	892a                	mv	s2,a0
  uint idx = HASH(b->blockno);
    8000275c:	4544                	lw	s1,12(a0)
    8000275e:	47b5                	li	a5,13
    80002760:	02f4f4bb          	remuw	s1,s1,a5
  acquire(bcache.locks + idx);
    80002764:	1482                	slli	s1,s1,0x20
    80002766:	9081                	srli	s1,s1,0x20
    80002768:	0496                	slli	s1,s1,0x5
    8000276a:	0000d797          	auipc	a5,0xd
    8000276e:	a6678793          	addi	a5,a5,-1434 # 8000f1d0 <bcache>
    80002772:	94be                	add	s1,s1,a5
    80002774:	8526                	mv	a0,s1
    80002776:	00004097          	auipc	ra,0x4
    8000277a:	ec0080e7          	jalr	-320(ra) # 80006636 <acquire>
  b->refcnt--;
    8000277e:	04892783          	lw	a5,72(s2)
    80002782:	37fd                	addiw	a5,a5,-1
    80002784:	04f92423          	sw	a5,72(s2)
  release(bcache.locks + idx);
    80002788:	8526                	mv	a0,s1
    8000278a:	00004097          	auipc	ra,0x4
    8000278e:	f7c080e7          	jalr	-132(ra) # 80006706 <release>
}
    80002792:	60e2                	ld	ra,24(sp)
    80002794:	6442                	ld	s0,16(sp)
    80002796:	64a2                	ld	s1,8(sp)
    80002798:	6902                	ld	s2,0(sp)
    8000279a:	6105                	addi	sp,sp,32
    8000279c:	8082                	ret

000000008000279e <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000279e:	1101                	addi	sp,sp,-32
    800027a0:	ec06                	sd	ra,24(sp)
    800027a2:	e822                	sd	s0,16(sp)
    800027a4:	e426                	sd	s1,8(sp)
    800027a6:	e04a                	sd	s2,0(sp)
    800027a8:	1000                	addi	s0,sp,32
    800027aa:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800027ac:	00d5d59b          	srliw	a1,a1,0xd
    800027b0:	00018797          	auipc	a5,0x18
    800027b4:	7fc7a783          	lw	a5,2044(a5) # 8001afac <sb+0x1c>
    800027b8:	9dbd                	addw	a1,a1,a5
    800027ba:	00000097          	auipc	ra,0x0
    800027be:	c10080e7          	jalr	-1008(ra) # 800023ca <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800027c2:	0074f713          	andi	a4,s1,7
    800027c6:	4785                	li	a5,1
    800027c8:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800027cc:	14ce                	slli	s1,s1,0x33
    800027ce:	90d9                	srli	s1,s1,0x36
    800027d0:	00950733          	add	a4,a0,s1
    800027d4:	06074703          	lbu	a4,96(a4)
    800027d8:	00e7f6b3          	and	a3,a5,a4
    800027dc:	c69d                	beqz	a3,8000280a <bfree+0x6c>
    800027de:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800027e0:	94aa                	add	s1,s1,a0
    800027e2:	fff7c793          	not	a5,a5
    800027e6:	8f7d                	and	a4,a4,a5
    800027e8:	06e48023          	sb	a4,96(s1)
  log_write(bp);
    800027ec:	00001097          	auipc	ra,0x1
    800027f0:	120080e7          	jalr	288(ra) # 8000390c <log_write>
  brelse(bp);
    800027f4:	854a                	mv	a0,s2
    800027f6:	00000097          	auipc	ra,0x0
    800027fa:	e3c080e7          	jalr	-452(ra) # 80002632 <brelse>
}
    800027fe:	60e2                	ld	ra,24(sp)
    80002800:	6442                	ld	s0,16(sp)
    80002802:	64a2                	ld	s1,8(sp)
    80002804:	6902                	ld	s2,0(sp)
    80002806:	6105                	addi	sp,sp,32
    80002808:	8082                	ret
    panic("freeing free block");
    8000280a:	00006517          	auipc	a0,0x6
    8000280e:	ca650513          	addi	a0,a0,-858 # 800084b0 <syscalls+0xe8>
    80002812:	00004097          	auipc	ra,0x4
    80002816:	902080e7          	jalr	-1790(ra) # 80006114 <panic>

000000008000281a <balloc>:
{
    8000281a:	711d                	addi	sp,sp,-96
    8000281c:	ec86                	sd	ra,88(sp)
    8000281e:	e8a2                	sd	s0,80(sp)
    80002820:	e4a6                	sd	s1,72(sp)
    80002822:	e0ca                	sd	s2,64(sp)
    80002824:	fc4e                	sd	s3,56(sp)
    80002826:	f852                	sd	s4,48(sp)
    80002828:	f456                	sd	s5,40(sp)
    8000282a:	f05a                	sd	s6,32(sp)
    8000282c:	ec5e                	sd	s7,24(sp)
    8000282e:	e862                	sd	s8,16(sp)
    80002830:	e466                	sd	s9,8(sp)
    80002832:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002834:	00018797          	auipc	a5,0x18
    80002838:	7607a783          	lw	a5,1888(a5) # 8001af94 <sb+0x4>
    8000283c:	cbc1                	beqz	a5,800028cc <balloc+0xb2>
    8000283e:	8baa                	mv	s7,a0
    80002840:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002842:	00018b17          	auipc	s6,0x18
    80002846:	74eb0b13          	addi	s6,s6,1870 # 8001af90 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000284a:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000284c:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000284e:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002850:	6c89                	lui	s9,0x2
    80002852:	a831                	j	8000286e <balloc+0x54>
    brelse(bp);
    80002854:	854a                	mv	a0,s2
    80002856:	00000097          	auipc	ra,0x0
    8000285a:	ddc080e7          	jalr	-548(ra) # 80002632 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000285e:	015c87bb          	addw	a5,s9,s5
    80002862:	00078a9b          	sext.w	s5,a5
    80002866:	004b2703          	lw	a4,4(s6)
    8000286a:	06eaf163          	bgeu	s5,a4,800028cc <balloc+0xb2>
    bp = bread(dev, BBLOCK(b, sb));
    8000286e:	41fad79b          	sraiw	a5,s5,0x1f
    80002872:	0137d79b          	srliw	a5,a5,0x13
    80002876:	015787bb          	addw	a5,a5,s5
    8000287a:	40d7d79b          	sraiw	a5,a5,0xd
    8000287e:	01cb2583          	lw	a1,28(s6)
    80002882:	9dbd                	addw	a1,a1,a5
    80002884:	855e                	mv	a0,s7
    80002886:	00000097          	auipc	ra,0x0
    8000288a:	b44080e7          	jalr	-1212(ra) # 800023ca <bread>
    8000288e:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002890:	004b2503          	lw	a0,4(s6)
    80002894:	000a849b          	sext.w	s1,s5
    80002898:	8762                	mv	a4,s8
    8000289a:	faa4fde3          	bgeu	s1,a0,80002854 <balloc+0x3a>
      m = 1 << (bi % 8);
    8000289e:	00777693          	andi	a3,a4,7
    800028a2:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800028a6:	41f7579b          	sraiw	a5,a4,0x1f
    800028aa:	01d7d79b          	srliw	a5,a5,0x1d
    800028ae:	9fb9                	addw	a5,a5,a4
    800028b0:	4037d79b          	sraiw	a5,a5,0x3
    800028b4:	00f90633          	add	a2,s2,a5
    800028b8:	06064603          	lbu	a2,96(a2)
    800028bc:	00c6f5b3          	and	a1,a3,a2
    800028c0:	cd91                	beqz	a1,800028dc <balloc+0xc2>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800028c2:	2705                	addiw	a4,a4,1
    800028c4:	2485                	addiw	s1,s1,1
    800028c6:	fd471ae3          	bne	a4,s4,8000289a <balloc+0x80>
    800028ca:	b769                	j	80002854 <balloc+0x3a>
  panic("balloc: out of blocks");
    800028cc:	00006517          	auipc	a0,0x6
    800028d0:	bfc50513          	addi	a0,a0,-1028 # 800084c8 <syscalls+0x100>
    800028d4:	00004097          	auipc	ra,0x4
    800028d8:	840080e7          	jalr	-1984(ra) # 80006114 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    800028dc:	97ca                	add	a5,a5,s2
    800028de:	8e55                	or	a2,a2,a3
    800028e0:	06c78023          	sb	a2,96(a5)
        log_write(bp);
    800028e4:	854a                	mv	a0,s2
    800028e6:	00001097          	auipc	ra,0x1
    800028ea:	026080e7          	jalr	38(ra) # 8000390c <log_write>
        brelse(bp);
    800028ee:	854a                	mv	a0,s2
    800028f0:	00000097          	auipc	ra,0x0
    800028f4:	d42080e7          	jalr	-702(ra) # 80002632 <brelse>
  bp = bread(dev, bno);
    800028f8:	85a6                	mv	a1,s1
    800028fa:	855e                	mv	a0,s7
    800028fc:	00000097          	auipc	ra,0x0
    80002900:	ace080e7          	jalr	-1330(ra) # 800023ca <bread>
    80002904:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002906:	40000613          	li	a2,1024
    8000290a:	4581                	li	a1,0
    8000290c:	06050513          	addi	a0,a0,96
    80002910:	ffffe097          	auipc	ra,0xffffe
    80002914:	96e080e7          	jalr	-1682(ra) # 8000027e <memset>
  log_write(bp);
    80002918:	854a                	mv	a0,s2
    8000291a:	00001097          	auipc	ra,0x1
    8000291e:	ff2080e7          	jalr	-14(ra) # 8000390c <log_write>
  brelse(bp);
    80002922:	854a                	mv	a0,s2
    80002924:	00000097          	auipc	ra,0x0
    80002928:	d0e080e7          	jalr	-754(ra) # 80002632 <brelse>
}
    8000292c:	8526                	mv	a0,s1
    8000292e:	60e6                	ld	ra,88(sp)
    80002930:	6446                	ld	s0,80(sp)
    80002932:	64a6                	ld	s1,72(sp)
    80002934:	6906                	ld	s2,64(sp)
    80002936:	79e2                	ld	s3,56(sp)
    80002938:	7a42                	ld	s4,48(sp)
    8000293a:	7aa2                	ld	s5,40(sp)
    8000293c:	7b02                	ld	s6,32(sp)
    8000293e:	6be2                	ld	s7,24(sp)
    80002940:	6c42                	ld	s8,16(sp)
    80002942:	6ca2                	ld	s9,8(sp)
    80002944:	6125                	addi	sp,sp,96
    80002946:	8082                	ret

0000000080002948 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80002948:	7179                	addi	sp,sp,-48
    8000294a:	f406                	sd	ra,40(sp)
    8000294c:	f022                	sd	s0,32(sp)
    8000294e:	ec26                	sd	s1,24(sp)
    80002950:	e84a                	sd	s2,16(sp)
    80002952:	e44e                	sd	s3,8(sp)
    80002954:	e052                	sd	s4,0(sp)
    80002956:	1800                	addi	s0,sp,48
    80002958:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000295a:	47ad                	li	a5,11
    8000295c:	04b7fe63          	bgeu	a5,a1,800029b8 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80002960:	ff45849b          	addiw	s1,a1,-12 # ff4 <_entry-0x7ffff00c>
    80002964:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002968:	0ff00793          	li	a5,255
    8000296c:	0ae7e463          	bltu	a5,a4,80002a14 <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80002970:	08852583          	lw	a1,136(a0)
    80002974:	c5b5                	beqz	a1,800029e0 <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80002976:	00092503          	lw	a0,0(s2)
    8000297a:	00000097          	auipc	ra,0x0
    8000297e:	a50080e7          	jalr	-1456(ra) # 800023ca <bread>
    80002982:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002984:	06050793          	addi	a5,a0,96
    if((addr = a[bn]) == 0){
    80002988:	02049713          	slli	a4,s1,0x20
    8000298c:	01e75593          	srli	a1,a4,0x1e
    80002990:	00b784b3          	add	s1,a5,a1
    80002994:	0004a983          	lw	s3,0(s1)
    80002998:	04098e63          	beqz	s3,800029f4 <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    8000299c:	8552                	mv	a0,s4
    8000299e:	00000097          	auipc	ra,0x0
    800029a2:	c94080e7          	jalr	-876(ra) # 80002632 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800029a6:	854e                	mv	a0,s3
    800029a8:	70a2                	ld	ra,40(sp)
    800029aa:	7402                	ld	s0,32(sp)
    800029ac:	64e2                	ld	s1,24(sp)
    800029ae:	6942                	ld	s2,16(sp)
    800029b0:	69a2                	ld	s3,8(sp)
    800029b2:	6a02                	ld	s4,0(sp)
    800029b4:	6145                	addi	sp,sp,48
    800029b6:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    800029b8:	02059793          	slli	a5,a1,0x20
    800029bc:	01e7d593          	srli	a1,a5,0x1e
    800029c0:	00b504b3          	add	s1,a0,a1
    800029c4:	0584a983          	lw	s3,88(s1)
    800029c8:	fc099fe3          	bnez	s3,800029a6 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    800029cc:	4108                	lw	a0,0(a0)
    800029ce:	00000097          	auipc	ra,0x0
    800029d2:	e4c080e7          	jalr	-436(ra) # 8000281a <balloc>
    800029d6:	0005099b          	sext.w	s3,a0
    800029da:	0534ac23          	sw	s3,88(s1)
    800029de:	b7e1                	j	800029a6 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    800029e0:	4108                	lw	a0,0(a0)
    800029e2:	00000097          	auipc	ra,0x0
    800029e6:	e38080e7          	jalr	-456(ra) # 8000281a <balloc>
    800029ea:	0005059b          	sext.w	a1,a0
    800029ee:	08b92423          	sw	a1,136(s2)
    800029f2:	b751                	j	80002976 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    800029f4:	00092503          	lw	a0,0(s2)
    800029f8:	00000097          	auipc	ra,0x0
    800029fc:	e22080e7          	jalr	-478(ra) # 8000281a <balloc>
    80002a00:	0005099b          	sext.w	s3,a0
    80002a04:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80002a08:	8552                	mv	a0,s4
    80002a0a:	00001097          	auipc	ra,0x1
    80002a0e:	f02080e7          	jalr	-254(ra) # 8000390c <log_write>
    80002a12:	b769                	j	8000299c <bmap+0x54>
  panic("bmap: out of range");
    80002a14:	00006517          	auipc	a0,0x6
    80002a18:	acc50513          	addi	a0,a0,-1332 # 800084e0 <syscalls+0x118>
    80002a1c:	00003097          	auipc	ra,0x3
    80002a20:	6f8080e7          	jalr	1784(ra) # 80006114 <panic>

0000000080002a24 <iget>:
{
    80002a24:	7179                	addi	sp,sp,-48
    80002a26:	f406                	sd	ra,40(sp)
    80002a28:	f022                	sd	s0,32(sp)
    80002a2a:	ec26                	sd	s1,24(sp)
    80002a2c:	e84a                	sd	s2,16(sp)
    80002a2e:	e44e                	sd	s3,8(sp)
    80002a30:	e052                	sd	s4,0(sp)
    80002a32:	1800                	addi	s0,sp,48
    80002a34:	89aa                	mv	s3,a0
    80002a36:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002a38:	00018517          	auipc	a0,0x18
    80002a3c:	57850513          	addi	a0,a0,1400 # 8001afb0 <itable>
    80002a40:	00004097          	auipc	ra,0x4
    80002a44:	bf6080e7          	jalr	-1034(ra) # 80006636 <acquire>
  empty = 0;
    80002a48:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a4a:	00018497          	auipc	s1,0x18
    80002a4e:	58648493          	addi	s1,s1,1414 # 8001afd0 <itable+0x20>
    80002a52:	0001a697          	auipc	a3,0x1a
    80002a56:	19e68693          	addi	a3,a3,414 # 8001cbf0 <log>
    80002a5a:	a039                	j	80002a68 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a5c:	02090b63          	beqz	s2,80002a92 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a60:	09048493          	addi	s1,s1,144
    80002a64:	02d48a63          	beq	s1,a3,80002a98 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002a68:	449c                	lw	a5,8(s1)
    80002a6a:	fef059e3          	blez	a5,80002a5c <iget+0x38>
    80002a6e:	4098                	lw	a4,0(s1)
    80002a70:	ff3716e3          	bne	a4,s3,80002a5c <iget+0x38>
    80002a74:	40d8                	lw	a4,4(s1)
    80002a76:	ff4713e3          	bne	a4,s4,80002a5c <iget+0x38>
      ip->ref++;
    80002a7a:	2785                	addiw	a5,a5,1
    80002a7c:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002a7e:	00018517          	auipc	a0,0x18
    80002a82:	53250513          	addi	a0,a0,1330 # 8001afb0 <itable>
    80002a86:	00004097          	auipc	ra,0x4
    80002a8a:	c80080e7          	jalr	-896(ra) # 80006706 <release>
      return ip;
    80002a8e:	8926                	mv	s2,s1
    80002a90:	a03d                	j	80002abe <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a92:	f7f9                	bnez	a5,80002a60 <iget+0x3c>
    80002a94:	8926                	mv	s2,s1
    80002a96:	b7e9                	j	80002a60 <iget+0x3c>
  if(empty == 0)
    80002a98:	02090c63          	beqz	s2,80002ad0 <iget+0xac>
  ip->dev = dev;
    80002a9c:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002aa0:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002aa4:	4785                	li	a5,1
    80002aa6:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002aaa:	04092423          	sw	zero,72(s2)
  release(&itable.lock);
    80002aae:	00018517          	auipc	a0,0x18
    80002ab2:	50250513          	addi	a0,a0,1282 # 8001afb0 <itable>
    80002ab6:	00004097          	auipc	ra,0x4
    80002aba:	c50080e7          	jalr	-944(ra) # 80006706 <release>
}
    80002abe:	854a                	mv	a0,s2
    80002ac0:	70a2                	ld	ra,40(sp)
    80002ac2:	7402                	ld	s0,32(sp)
    80002ac4:	64e2                	ld	s1,24(sp)
    80002ac6:	6942                	ld	s2,16(sp)
    80002ac8:	69a2                	ld	s3,8(sp)
    80002aca:	6a02                	ld	s4,0(sp)
    80002acc:	6145                	addi	sp,sp,48
    80002ace:	8082                	ret
    panic("iget: no inodes");
    80002ad0:	00006517          	auipc	a0,0x6
    80002ad4:	a2850513          	addi	a0,a0,-1496 # 800084f8 <syscalls+0x130>
    80002ad8:	00003097          	auipc	ra,0x3
    80002adc:	63c080e7          	jalr	1596(ra) # 80006114 <panic>

0000000080002ae0 <fsinit>:
fsinit(int dev) {
    80002ae0:	7179                	addi	sp,sp,-48
    80002ae2:	f406                	sd	ra,40(sp)
    80002ae4:	f022                	sd	s0,32(sp)
    80002ae6:	ec26                	sd	s1,24(sp)
    80002ae8:	e84a                	sd	s2,16(sp)
    80002aea:	e44e                	sd	s3,8(sp)
    80002aec:	1800                	addi	s0,sp,48
    80002aee:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002af0:	4585                	li	a1,1
    80002af2:	00000097          	auipc	ra,0x0
    80002af6:	8d8080e7          	jalr	-1832(ra) # 800023ca <bread>
    80002afa:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002afc:	00018997          	auipc	s3,0x18
    80002b00:	49498993          	addi	s3,s3,1172 # 8001af90 <sb>
    80002b04:	02000613          	li	a2,32
    80002b08:	06050593          	addi	a1,a0,96
    80002b0c:	854e                	mv	a0,s3
    80002b0e:	ffffd097          	auipc	ra,0xffffd
    80002b12:	7cc080e7          	jalr	1996(ra) # 800002da <memmove>
  brelse(bp);
    80002b16:	8526                	mv	a0,s1
    80002b18:	00000097          	auipc	ra,0x0
    80002b1c:	b1a080e7          	jalr	-1254(ra) # 80002632 <brelse>
  if(sb.magic != FSMAGIC)
    80002b20:	0009a703          	lw	a4,0(s3)
    80002b24:	102037b7          	lui	a5,0x10203
    80002b28:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002b2c:	02f71263          	bne	a4,a5,80002b50 <fsinit+0x70>
  initlog(dev, &sb);
    80002b30:	00018597          	auipc	a1,0x18
    80002b34:	46058593          	addi	a1,a1,1120 # 8001af90 <sb>
    80002b38:	854a                	mv	a0,s2
    80002b3a:	00001097          	auipc	ra,0x1
    80002b3e:	b56080e7          	jalr	-1194(ra) # 80003690 <initlog>
}
    80002b42:	70a2                	ld	ra,40(sp)
    80002b44:	7402                	ld	s0,32(sp)
    80002b46:	64e2                	ld	s1,24(sp)
    80002b48:	6942                	ld	s2,16(sp)
    80002b4a:	69a2                	ld	s3,8(sp)
    80002b4c:	6145                	addi	sp,sp,48
    80002b4e:	8082                	ret
    panic("invalid file system");
    80002b50:	00006517          	auipc	a0,0x6
    80002b54:	9b850513          	addi	a0,a0,-1608 # 80008508 <syscalls+0x140>
    80002b58:	00003097          	auipc	ra,0x3
    80002b5c:	5bc080e7          	jalr	1468(ra) # 80006114 <panic>

0000000080002b60 <iinit>:
{
    80002b60:	7179                	addi	sp,sp,-48
    80002b62:	f406                	sd	ra,40(sp)
    80002b64:	f022                	sd	s0,32(sp)
    80002b66:	ec26                	sd	s1,24(sp)
    80002b68:	e84a                	sd	s2,16(sp)
    80002b6a:	e44e                	sd	s3,8(sp)
    80002b6c:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002b6e:	00006597          	auipc	a1,0x6
    80002b72:	9b258593          	addi	a1,a1,-1614 # 80008520 <syscalls+0x158>
    80002b76:	00018517          	auipc	a0,0x18
    80002b7a:	43a50513          	addi	a0,a0,1082 # 8001afb0 <itable>
    80002b7e:	00004097          	auipc	ra,0x4
    80002b82:	c34080e7          	jalr	-972(ra) # 800067b2 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002b86:	00018497          	auipc	s1,0x18
    80002b8a:	45a48493          	addi	s1,s1,1114 # 8001afe0 <itable+0x30>
    80002b8e:	0001a997          	auipc	s3,0x1a
    80002b92:	07298993          	addi	s3,s3,114 # 8001cc00 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002b96:	00006917          	auipc	s2,0x6
    80002b9a:	99290913          	addi	s2,s2,-1646 # 80008528 <syscalls+0x160>
    80002b9e:	85ca                	mv	a1,s2
    80002ba0:	8526                	mv	a0,s1
    80002ba2:	00001097          	auipc	ra,0x1
    80002ba6:	e4e080e7          	jalr	-434(ra) # 800039f0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002baa:	09048493          	addi	s1,s1,144
    80002bae:	ff3498e3          	bne	s1,s3,80002b9e <iinit+0x3e>
}
    80002bb2:	70a2                	ld	ra,40(sp)
    80002bb4:	7402                	ld	s0,32(sp)
    80002bb6:	64e2                	ld	s1,24(sp)
    80002bb8:	6942                	ld	s2,16(sp)
    80002bba:	69a2                	ld	s3,8(sp)
    80002bbc:	6145                	addi	sp,sp,48
    80002bbe:	8082                	ret

0000000080002bc0 <ialloc>:
{
    80002bc0:	715d                	addi	sp,sp,-80
    80002bc2:	e486                	sd	ra,72(sp)
    80002bc4:	e0a2                	sd	s0,64(sp)
    80002bc6:	fc26                	sd	s1,56(sp)
    80002bc8:	f84a                	sd	s2,48(sp)
    80002bca:	f44e                	sd	s3,40(sp)
    80002bcc:	f052                	sd	s4,32(sp)
    80002bce:	ec56                	sd	s5,24(sp)
    80002bd0:	e85a                	sd	s6,16(sp)
    80002bd2:	e45e                	sd	s7,8(sp)
    80002bd4:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002bd6:	00018717          	auipc	a4,0x18
    80002bda:	3c672703          	lw	a4,966(a4) # 8001af9c <sb+0xc>
    80002bde:	4785                	li	a5,1
    80002be0:	04e7fa63          	bgeu	a5,a4,80002c34 <ialloc+0x74>
    80002be4:	8aaa                	mv	s5,a0
    80002be6:	8bae                	mv	s7,a1
    80002be8:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002bea:	00018a17          	auipc	s4,0x18
    80002bee:	3a6a0a13          	addi	s4,s4,934 # 8001af90 <sb>
    80002bf2:	00048b1b          	sext.w	s6,s1
    80002bf6:	0044d593          	srli	a1,s1,0x4
    80002bfa:	018a2783          	lw	a5,24(s4)
    80002bfe:	9dbd                	addw	a1,a1,a5
    80002c00:	8556                	mv	a0,s5
    80002c02:	fffff097          	auipc	ra,0xfffff
    80002c06:	7c8080e7          	jalr	1992(ra) # 800023ca <bread>
    80002c0a:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002c0c:	06050993          	addi	s3,a0,96
    80002c10:	00f4f793          	andi	a5,s1,15
    80002c14:	079a                	slli	a5,a5,0x6
    80002c16:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002c18:	00099783          	lh	a5,0(s3)
    80002c1c:	c785                	beqz	a5,80002c44 <ialloc+0x84>
    brelse(bp);
    80002c1e:	00000097          	auipc	ra,0x0
    80002c22:	a14080e7          	jalr	-1516(ra) # 80002632 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002c26:	0485                	addi	s1,s1,1
    80002c28:	00ca2703          	lw	a4,12(s4)
    80002c2c:	0004879b          	sext.w	a5,s1
    80002c30:	fce7e1e3          	bltu	a5,a4,80002bf2 <ialloc+0x32>
  panic("ialloc: no inodes");
    80002c34:	00006517          	auipc	a0,0x6
    80002c38:	8fc50513          	addi	a0,a0,-1796 # 80008530 <syscalls+0x168>
    80002c3c:	00003097          	auipc	ra,0x3
    80002c40:	4d8080e7          	jalr	1240(ra) # 80006114 <panic>
      memset(dip, 0, sizeof(*dip));
    80002c44:	04000613          	li	a2,64
    80002c48:	4581                	li	a1,0
    80002c4a:	854e                	mv	a0,s3
    80002c4c:	ffffd097          	auipc	ra,0xffffd
    80002c50:	632080e7          	jalr	1586(ra) # 8000027e <memset>
      dip->type = type;
    80002c54:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002c58:	854a                	mv	a0,s2
    80002c5a:	00001097          	auipc	ra,0x1
    80002c5e:	cb2080e7          	jalr	-846(ra) # 8000390c <log_write>
      brelse(bp);
    80002c62:	854a                	mv	a0,s2
    80002c64:	00000097          	auipc	ra,0x0
    80002c68:	9ce080e7          	jalr	-1586(ra) # 80002632 <brelse>
      return iget(dev, inum);
    80002c6c:	85da                	mv	a1,s6
    80002c6e:	8556                	mv	a0,s5
    80002c70:	00000097          	auipc	ra,0x0
    80002c74:	db4080e7          	jalr	-588(ra) # 80002a24 <iget>
}
    80002c78:	60a6                	ld	ra,72(sp)
    80002c7a:	6406                	ld	s0,64(sp)
    80002c7c:	74e2                	ld	s1,56(sp)
    80002c7e:	7942                	ld	s2,48(sp)
    80002c80:	79a2                	ld	s3,40(sp)
    80002c82:	7a02                	ld	s4,32(sp)
    80002c84:	6ae2                	ld	s5,24(sp)
    80002c86:	6b42                	ld	s6,16(sp)
    80002c88:	6ba2                	ld	s7,8(sp)
    80002c8a:	6161                	addi	sp,sp,80
    80002c8c:	8082                	ret

0000000080002c8e <iupdate>:
{
    80002c8e:	1101                	addi	sp,sp,-32
    80002c90:	ec06                	sd	ra,24(sp)
    80002c92:	e822                	sd	s0,16(sp)
    80002c94:	e426                	sd	s1,8(sp)
    80002c96:	e04a                	sd	s2,0(sp)
    80002c98:	1000                	addi	s0,sp,32
    80002c9a:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c9c:	415c                	lw	a5,4(a0)
    80002c9e:	0047d79b          	srliw	a5,a5,0x4
    80002ca2:	00018597          	auipc	a1,0x18
    80002ca6:	3065a583          	lw	a1,774(a1) # 8001afa8 <sb+0x18>
    80002caa:	9dbd                	addw	a1,a1,a5
    80002cac:	4108                	lw	a0,0(a0)
    80002cae:	fffff097          	auipc	ra,0xfffff
    80002cb2:	71c080e7          	jalr	1820(ra) # 800023ca <bread>
    80002cb6:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002cb8:	06050793          	addi	a5,a0,96
    80002cbc:	40d8                	lw	a4,4(s1)
    80002cbe:	8b3d                	andi	a4,a4,15
    80002cc0:	071a                	slli	a4,a4,0x6
    80002cc2:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002cc4:	04c49703          	lh	a4,76(s1)
    80002cc8:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002ccc:	04e49703          	lh	a4,78(s1)
    80002cd0:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002cd4:	05049703          	lh	a4,80(s1)
    80002cd8:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002cdc:	05249703          	lh	a4,82(s1)
    80002ce0:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002ce4:	48f8                	lw	a4,84(s1)
    80002ce6:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002ce8:	03400613          	li	a2,52
    80002cec:	05848593          	addi	a1,s1,88
    80002cf0:	00c78513          	addi	a0,a5,12
    80002cf4:	ffffd097          	auipc	ra,0xffffd
    80002cf8:	5e6080e7          	jalr	1510(ra) # 800002da <memmove>
  log_write(bp);
    80002cfc:	854a                	mv	a0,s2
    80002cfe:	00001097          	auipc	ra,0x1
    80002d02:	c0e080e7          	jalr	-1010(ra) # 8000390c <log_write>
  brelse(bp);
    80002d06:	854a                	mv	a0,s2
    80002d08:	00000097          	auipc	ra,0x0
    80002d0c:	92a080e7          	jalr	-1750(ra) # 80002632 <brelse>
}
    80002d10:	60e2                	ld	ra,24(sp)
    80002d12:	6442                	ld	s0,16(sp)
    80002d14:	64a2                	ld	s1,8(sp)
    80002d16:	6902                	ld	s2,0(sp)
    80002d18:	6105                	addi	sp,sp,32
    80002d1a:	8082                	ret

0000000080002d1c <idup>:
{
    80002d1c:	1101                	addi	sp,sp,-32
    80002d1e:	ec06                	sd	ra,24(sp)
    80002d20:	e822                	sd	s0,16(sp)
    80002d22:	e426                	sd	s1,8(sp)
    80002d24:	1000                	addi	s0,sp,32
    80002d26:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002d28:	00018517          	auipc	a0,0x18
    80002d2c:	28850513          	addi	a0,a0,648 # 8001afb0 <itable>
    80002d30:	00004097          	auipc	ra,0x4
    80002d34:	906080e7          	jalr	-1786(ra) # 80006636 <acquire>
  ip->ref++;
    80002d38:	449c                	lw	a5,8(s1)
    80002d3a:	2785                	addiw	a5,a5,1
    80002d3c:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002d3e:	00018517          	auipc	a0,0x18
    80002d42:	27250513          	addi	a0,a0,626 # 8001afb0 <itable>
    80002d46:	00004097          	auipc	ra,0x4
    80002d4a:	9c0080e7          	jalr	-1600(ra) # 80006706 <release>
}
    80002d4e:	8526                	mv	a0,s1
    80002d50:	60e2                	ld	ra,24(sp)
    80002d52:	6442                	ld	s0,16(sp)
    80002d54:	64a2                	ld	s1,8(sp)
    80002d56:	6105                	addi	sp,sp,32
    80002d58:	8082                	ret

0000000080002d5a <ilock>:
{
    80002d5a:	1101                	addi	sp,sp,-32
    80002d5c:	ec06                	sd	ra,24(sp)
    80002d5e:	e822                	sd	s0,16(sp)
    80002d60:	e426                	sd	s1,8(sp)
    80002d62:	e04a                	sd	s2,0(sp)
    80002d64:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002d66:	c115                	beqz	a0,80002d8a <ilock+0x30>
    80002d68:	84aa                	mv	s1,a0
    80002d6a:	451c                	lw	a5,8(a0)
    80002d6c:	00f05f63          	blez	a5,80002d8a <ilock+0x30>
  acquiresleep(&ip->lock);
    80002d70:	0541                	addi	a0,a0,16
    80002d72:	00001097          	auipc	ra,0x1
    80002d76:	cb8080e7          	jalr	-840(ra) # 80003a2a <acquiresleep>
  if(ip->valid == 0){
    80002d7a:	44bc                	lw	a5,72(s1)
    80002d7c:	cf99                	beqz	a5,80002d9a <ilock+0x40>
}
    80002d7e:	60e2                	ld	ra,24(sp)
    80002d80:	6442                	ld	s0,16(sp)
    80002d82:	64a2                	ld	s1,8(sp)
    80002d84:	6902                	ld	s2,0(sp)
    80002d86:	6105                	addi	sp,sp,32
    80002d88:	8082                	ret
    panic("ilock");
    80002d8a:	00005517          	auipc	a0,0x5
    80002d8e:	7be50513          	addi	a0,a0,1982 # 80008548 <syscalls+0x180>
    80002d92:	00003097          	auipc	ra,0x3
    80002d96:	382080e7          	jalr	898(ra) # 80006114 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002d9a:	40dc                	lw	a5,4(s1)
    80002d9c:	0047d79b          	srliw	a5,a5,0x4
    80002da0:	00018597          	auipc	a1,0x18
    80002da4:	2085a583          	lw	a1,520(a1) # 8001afa8 <sb+0x18>
    80002da8:	9dbd                	addw	a1,a1,a5
    80002daa:	4088                	lw	a0,0(s1)
    80002dac:	fffff097          	auipc	ra,0xfffff
    80002db0:	61e080e7          	jalr	1566(ra) # 800023ca <bread>
    80002db4:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002db6:	06050593          	addi	a1,a0,96
    80002dba:	40dc                	lw	a5,4(s1)
    80002dbc:	8bbd                	andi	a5,a5,15
    80002dbe:	079a                	slli	a5,a5,0x6
    80002dc0:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002dc2:	00059783          	lh	a5,0(a1)
    80002dc6:	04f49623          	sh	a5,76(s1)
    ip->major = dip->major;
    80002dca:	00259783          	lh	a5,2(a1)
    80002dce:	04f49723          	sh	a5,78(s1)
    ip->minor = dip->minor;
    80002dd2:	00459783          	lh	a5,4(a1)
    80002dd6:	04f49823          	sh	a5,80(s1)
    ip->nlink = dip->nlink;
    80002dda:	00659783          	lh	a5,6(a1)
    80002dde:	04f49923          	sh	a5,82(s1)
    ip->size = dip->size;
    80002de2:	459c                	lw	a5,8(a1)
    80002de4:	c8fc                	sw	a5,84(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002de6:	03400613          	li	a2,52
    80002dea:	05b1                	addi	a1,a1,12
    80002dec:	05848513          	addi	a0,s1,88
    80002df0:	ffffd097          	auipc	ra,0xffffd
    80002df4:	4ea080e7          	jalr	1258(ra) # 800002da <memmove>
    brelse(bp);
    80002df8:	854a                	mv	a0,s2
    80002dfa:	00000097          	auipc	ra,0x0
    80002dfe:	838080e7          	jalr	-1992(ra) # 80002632 <brelse>
    ip->valid = 1;
    80002e02:	4785                	li	a5,1
    80002e04:	c4bc                	sw	a5,72(s1)
    if(ip->type == 0)
    80002e06:	04c49783          	lh	a5,76(s1)
    80002e0a:	fbb5                	bnez	a5,80002d7e <ilock+0x24>
      panic("ilock: no type");
    80002e0c:	00005517          	auipc	a0,0x5
    80002e10:	74450513          	addi	a0,a0,1860 # 80008550 <syscalls+0x188>
    80002e14:	00003097          	auipc	ra,0x3
    80002e18:	300080e7          	jalr	768(ra) # 80006114 <panic>

0000000080002e1c <iunlock>:
{
    80002e1c:	1101                	addi	sp,sp,-32
    80002e1e:	ec06                	sd	ra,24(sp)
    80002e20:	e822                	sd	s0,16(sp)
    80002e22:	e426                	sd	s1,8(sp)
    80002e24:	e04a                	sd	s2,0(sp)
    80002e26:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002e28:	c905                	beqz	a0,80002e58 <iunlock+0x3c>
    80002e2a:	84aa                	mv	s1,a0
    80002e2c:	01050913          	addi	s2,a0,16
    80002e30:	854a                	mv	a0,s2
    80002e32:	00001097          	auipc	ra,0x1
    80002e36:	c92080e7          	jalr	-878(ra) # 80003ac4 <holdingsleep>
    80002e3a:	cd19                	beqz	a0,80002e58 <iunlock+0x3c>
    80002e3c:	449c                	lw	a5,8(s1)
    80002e3e:	00f05d63          	blez	a5,80002e58 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002e42:	854a                	mv	a0,s2
    80002e44:	00001097          	auipc	ra,0x1
    80002e48:	c3c080e7          	jalr	-964(ra) # 80003a80 <releasesleep>
}
    80002e4c:	60e2                	ld	ra,24(sp)
    80002e4e:	6442                	ld	s0,16(sp)
    80002e50:	64a2                	ld	s1,8(sp)
    80002e52:	6902                	ld	s2,0(sp)
    80002e54:	6105                	addi	sp,sp,32
    80002e56:	8082                	ret
    panic("iunlock");
    80002e58:	00005517          	auipc	a0,0x5
    80002e5c:	70850513          	addi	a0,a0,1800 # 80008560 <syscalls+0x198>
    80002e60:	00003097          	auipc	ra,0x3
    80002e64:	2b4080e7          	jalr	692(ra) # 80006114 <panic>

0000000080002e68 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002e68:	7179                	addi	sp,sp,-48
    80002e6a:	f406                	sd	ra,40(sp)
    80002e6c:	f022                	sd	s0,32(sp)
    80002e6e:	ec26                	sd	s1,24(sp)
    80002e70:	e84a                	sd	s2,16(sp)
    80002e72:	e44e                	sd	s3,8(sp)
    80002e74:	e052                	sd	s4,0(sp)
    80002e76:	1800                	addi	s0,sp,48
    80002e78:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002e7a:	05850493          	addi	s1,a0,88
    80002e7e:	08850913          	addi	s2,a0,136
    80002e82:	a021                	j	80002e8a <itrunc+0x22>
    80002e84:	0491                	addi	s1,s1,4
    80002e86:	01248d63          	beq	s1,s2,80002ea0 <itrunc+0x38>
    if(ip->addrs[i]){
    80002e8a:	408c                	lw	a1,0(s1)
    80002e8c:	dde5                	beqz	a1,80002e84 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002e8e:	0009a503          	lw	a0,0(s3)
    80002e92:	00000097          	auipc	ra,0x0
    80002e96:	90c080e7          	jalr	-1780(ra) # 8000279e <bfree>
      ip->addrs[i] = 0;
    80002e9a:	0004a023          	sw	zero,0(s1)
    80002e9e:	b7dd                	j	80002e84 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002ea0:	0889a583          	lw	a1,136(s3)
    80002ea4:	e185                	bnez	a1,80002ec4 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002ea6:	0409aa23          	sw	zero,84(s3)
  iupdate(ip);
    80002eaa:	854e                	mv	a0,s3
    80002eac:	00000097          	auipc	ra,0x0
    80002eb0:	de2080e7          	jalr	-542(ra) # 80002c8e <iupdate>
}
    80002eb4:	70a2                	ld	ra,40(sp)
    80002eb6:	7402                	ld	s0,32(sp)
    80002eb8:	64e2                	ld	s1,24(sp)
    80002eba:	6942                	ld	s2,16(sp)
    80002ebc:	69a2                	ld	s3,8(sp)
    80002ebe:	6a02                	ld	s4,0(sp)
    80002ec0:	6145                	addi	sp,sp,48
    80002ec2:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002ec4:	0009a503          	lw	a0,0(s3)
    80002ec8:	fffff097          	auipc	ra,0xfffff
    80002ecc:	502080e7          	jalr	1282(ra) # 800023ca <bread>
    80002ed0:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002ed2:	06050493          	addi	s1,a0,96
    80002ed6:	46050913          	addi	s2,a0,1120
    80002eda:	a021                	j	80002ee2 <itrunc+0x7a>
    80002edc:	0491                	addi	s1,s1,4
    80002ede:	01248b63          	beq	s1,s2,80002ef4 <itrunc+0x8c>
      if(a[j])
    80002ee2:	408c                	lw	a1,0(s1)
    80002ee4:	dde5                	beqz	a1,80002edc <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002ee6:	0009a503          	lw	a0,0(s3)
    80002eea:	00000097          	auipc	ra,0x0
    80002eee:	8b4080e7          	jalr	-1868(ra) # 8000279e <bfree>
    80002ef2:	b7ed                	j	80002edc <itrunc+0x74>
    brelse(bp);
    80002ef4:	8552                	mv	a0,s4
    80002ef6:	fffff097          	auipc	ra,0xfffff
    80002efa:	73c080e7          	jalr	1852(ra) # 80002632 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002efe:	0889a583          	lw	a1,136(s3)
    80002f02:	0009a503          	lw	a0,0(s3)
    80002f06:	00000097          	auipc	ra,0x0
    80002f0a:	898080e7          	jalr	-1896(ra) # 8000279e <bfree>
    ip->addrs[NDIRECT] = 0;
    80002f0e:	0809a423          	sw	zero,136(s3)
    80002f12:	bf51                	j	80002ea6 <itrunc+0x3e>

0000000080002f14 <iput>:
{
    80002f14:	1101                	addi	sp,sp,-32
    80002f16:	ec06                	sd	ra,24(sp)
    80002f18:	e822                	sd	s0,16(sp)
    80002f1a:	e426                	sd	s1,8(sp)
    80002f1c:	e04a                	sd	s2,0(sp)
    80002f1e:	1000                	addi	s0,sp,32
    80002f20:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002f22:	00018517          	auipc	a0,0x18
    80002f26:	08e50513          	addi	a0,a0,142 # 8001afb0 <itable>
    80002f2a:	00003097          	auipc	ra,0x3
    80002f2e:	70c080e7          	jalr	1804(ra) # 80006636 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002f32:	4498                	lw	a4,8(s1)
    80002f34:	4785                	li	a5,1
    80002f36:	02f70363          	beq	a4,a5,80002f5c <iput+0x48>
  ip->ref--;
    80002f3a:	449c                	lw	a5,8(s1)
    80002f3c:	37fd                	addiw	a5,a5,-1
    80002f3e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002f40:	00018517          	auipc	a0,0x18
    80002f44:	07050513          	addi	a0,a0,112 # 8001afb0 <itable>
    80002f48:	00003097          	auipc	ra,0x3
    80002f4c:	7be080e7          	jalr	1982(ra) # 80006706 <release>
}
    80002f50:	60e2                	ld	ra,24(sp)
    80002f52:	6442                	ld	s0,16(sp)
    80002f54:	64a2                	ld	s1,8(sp)
    80002f56:	6902                	ld	s2,0(sp)
    80002f58:	6105                	addi	sp,sp,32
    80002f5a:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002f5c:	44bc                	lw	a5,72(s1)
    80002f5e:	dff1                	beqz	a5,80002f3a <iput+0x26>
    80002f60:	05249783          	lh	a5,82(s1)
    80002f64:	fbf9                	bnez	a5,80002f3a <iput+0x26>
    acquiresleep(&ip->lock);
    80002f66:	01048913          	addi	s2,s1,16
    80002f6a:	854a                	mv	a0,s2
    80002f6c:	00001097          	auipc	ra,0x1
    80002f70:	abe080e7          	jalr	-1346(ra) # 80003a2a <acquiresleep>
    release(&itable.lock);
    80002f74:	00018517          	auipc	a0,0x18
    80002f78:	03c50513          	addi	a0,a0,60 # 8001afb0 <itable>
    80002f7c:	00003097          	auipc	ra,0x3
    80002f80:	78a080e7          	jalr	1930(ra) # 80006706 <release>
    itrunc(ip);
    80002f84:	8526                	mv	a0,s1
    80002f86:	00000097          	auipc	ra,0x0
    80002f8a:	ee2080e7          	jalr	-286(ra) # 80002e68 <itrunc>
    ip->type = 0;
    80002f8e:	04049623          	sh	zero,76(s1)
    iupdate(ip);
    80002f92:	8526                	mv	a0,s1
    80002f94:	00000097          	auipc	ra,0x0
    80002f98:	cfa080e7          	jalr	-774(ra) # 80002c8e <iupdate>
    ip->valid = 0;
    80002f9c:	0404a423          	sw	zero,72(s1)
    releasesleep(&ip->lock);
    80002fa0:	854a                	mv	a0,s2
    80002fa2:	00001097          	auipc	ra,0x1
    80002fa6:	ade080e7          	jalr	-1314(ra) # 80003a80 <releasesleep>
    acquire(&itable.lock);
    80002faa:	00018517          	auipc	a0,0x18
    80002fae:	00650513          	addi	a0,a0,6 # 8001afb0 <itable>
    80002fb2:	00003097          	auipc	ra,0x3
    80002fb6:	684080e7          	jalr	1668(ra) # 80006636 <acquire>
    80002fba:	b741                	j	80002f3a <iput+0x26>

0000000080002fbc <iunlockput>:
{
    80002fbc:	1101                	addi	sp,sp,-32
    80002fbe:	ec06                	sd	ra,24(sp)
    80002fc0:	e822                	sd	s0,16(sp)
    80002fc2:	e426                	sd	s1,8(sp)
    80002fc4:	1000                	addi	s0,sp,32
    80002fc6:	84aa                	mv	s1,a0
  iunlock(ip);
    80002fc8:	00000097          	auipc	ra,0x0
    80002fcc:	e54080e7          	jalr	-428(ra) # 80002e1c <iunlock>
  iput(ip);
    80002fd0:	8526                	mv	a0,s1
    80002fd2:	00000097          	auipc	ra,0x0
    80002fd6:	f42080e7          	jalr	-190(ra) # 80002f14 <iput>
}
    80002fda:	60e2                	ld	ra,24(sp)
    80002fdc:	6442                	ld	s0,16(sp)
    80002fde:	64a2                	ld	s1,8(sp)
    80002fe0:	6105                	addi	sp,sp,32
    80002fe2:	8082                	ret

0000000080002fe4 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002fe4:	1141                	addi	sp,sp,-16
    80002fe6:	e422                	sd	s0,8(sp)
    80002fe8:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002fea:	411c                	lw	a5,0(a0)
    80002fec:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002fee:	415c                	lw	a5,4(a0)
    80002ff0:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002ff2:	04c51783          	lh	a5,76(a0)
    80002ff6:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002ffa:	05251783          	lh	a5,82(a0)
    80002ffe:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003002:	05456783          	lwu	a5,84(a0)
    80003006:	e99c                	sd	a5,16(a1)
}
    80003008:	6422                	ld	s0,8(sp)
    8000300a:	0141                	addi	sp,sp,16
    8000300c:	8082                	ret

000000008000300e <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000300e:	497c                	lw	a5,84(a0)
    80003010:	0ed7e963          	bltu	a5,a3,80003102 <readi+0xf4>
{
    80003014:	7159                	addi	sp,sp,-112
    80003016:	f486                	sd	ra,104(sp)
    80003018:	f0a2                	sd	s0,96(sp)
    8000301a:	eca6                	sd	s1,88(sp)
    8000301c:	e8ca                	sd	s2,80(sp)
    8000301e:	e4ce                	sd	s3,72(sp)
    80003020:	e0d2                	sd	s4,64(sp)
    80003022:	fc56                	sd	s5,56(sp)
    80003024:	f85a                	sd	s6,48(sp)
    80003026:	f45e                	sd	s7,40(sp)
    80003028:	f062                	sd	s8,32(sp)
    8000302a:	ec66                	sd	s9,24(sp)
    8000302c:	e86a                	sd	s10,16(sp)
    8000302e:	e46e                	sd	s11,8(sp)
    80003030:	1880                	addi	s0,sp,112
    80003032:	8baa                	mv	s7,a0
    80003034:	8c2e                	mv	s8,a1
    80003036:	8ab2                	mv	s5,a2
    80003038:	84b6                	mv	s1,a3
    8000303a:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    8000303c:	9f35                	addw	a4,a4,a3
    return 0;
    8000303e:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003040:	0ad76063          	bltu	a4,a3,800030e0 <readi+0xd2>
  if(off + n > ip->size)
    80003044:	00e7f463          	bgeu	a5,a4,8000304c <readi+0x3e>
    n = ip->size - off;
    80003048:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000304c:	0a0b0963          	beqz	s6,800030fe <readi+0xf0>
    80003050:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003052:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003056:	5cfd                	li	s9,-1
    80003058:	a82d                	j	80003092 <readi+0x84>
    8000305a:	020a1d93          	slli	s11,s4,0x20
    8000305e:	020ddd93          	srli	s11,s11,0x20
    80003062:	06090613          	addi	a2,s2,96
    80003066:	86ee                	mv	a3,s11
    80003068:	963a                	add	a2,a2,a4
    8000306a:	85d6                	mv	a1,s5
    8000306c:	8562                	mv	a0,s8
    8000306e:	fffff097          	auipc	ra,0xfffff
    80003072:	952080e7          	jalr	-1710(ra) # 800019c0 <either_copyout>
    80003076:	05950d63          	beq	a0,s9,800030d0 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    8000307a:	854a                	mv	a0,s2
    8000307c:	fffff097          	auipc	ra,0xfffff
    80003080:	5b6080e7          	jalr	1462(ra) # 80002632 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003084:	013a09bb          	addw	s3,s4,s3
    80003088:	009a04bb          	addw	s1,s4,s1
    8000308c:	9aee                	add	s5,s5,s11
    8000308e:	0569f763          	bgeu	s3,s6,800030dc <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003092:	000ba903          	lw	s2,0(s7)
    80003096:	00a4d59b          	srliw	a1,s1,0xa
    8000309a:	855e                	mv	a0,s7
    8000309c:	00000097          	auipc	ra,0x0
    800030a0:	8ac080e7          	jalr	-1876(ra) # 80002948 <bmap>
    800030a4:	0005059b          	sext.w	a1,a0
    800030a8:	854a                	mv	a0,s2
    800030aa:	fffff097          	auipc	ra,0xfffff
    800030ae:	320080e7          	jalr	800(ra) # 800023ca <bread>
    800030b2:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800030b4:	3ff4f713          	andi	a4,s1,1023
    800030b8:	40ed07bb          	subw	a5,s10,a4
    800030bc:	413b06bb          	subw	a3,s6,s3
    800030c0:	8a3e                	mv	s4,a5
    800030c2:	2781                	sext.w	a5,a5
    800030c4:	0006861b          	sext.w	a2,a3
    800030c8:	f8f679e3          	bgeu	a2,a5,8000305a <readi+0x4c>
    800030cc:	8a36                	mv	s4,a3
    800030ce:	b771                	j	8000305a <readi+0x4c>
      brelse(bp);
    800030d0:	854a                	mv	a0,s2
    800030d2:	fffff097          	auipc	ra,0xfffff
    800030d6:	560080e7          	jalr	1376(ra) # 80002632 <brelse>
      tot = -1;
    800030da:	59fd                	li	s3,-1
  }
  return tot;
    800030dc:	0009851b          	sext.w	a0,s3
}
    800030e0:	70a6                	ld	ra,104(sp)
    800030e2:	7406                	ld	s0,96(sp)
    800030e4:	64e6                	ld	s1,88(sp)
    800030e6:	6946                	ld	s2,80(sp)
    800030e8:	69a6                	ld	s3,72(sp)
    800030ea:	6a06                	ld	s4,64(sp)
    800030ec:	7ae2                	ld	s5,56(sp)
    800030ee:	7b42                	ld	s6,48(sp)
    800030f0:	7ba2                	ld	s7,40(sp)
    800030f2:	7c02                	ld	s8,32(sp)
    800030f4:	6ce2                	ld	s9,24(sp)
    800030f6:	6d42                	ld	s10,16(sp)
    800030f8:	6da2                	ld	s11,8(sp)
    800030fa:	6165                	addi	sp,sp,112
    800030fc:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800030fe:	89da                	mv	s3,s6
    80003100:	bff1                	j	800030dc <readi+0xce>
    return 0;
    80003102:	4501                	li	a0,0
}
    80003104:	8082                	ret

0000000080003106 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003106:	497c                	lw	a5,84(a0)
    80003108:	10d7e863          	bltu	a5,a3,80003218 <writei+0x112>
{
    8000310c:	7159                	addi	sp,sp,-112
    8000310e:	f486                	sd	ra,104(sp)
    80003110:	f0a2                	sd	s0,96(sp)
    80003112:	eca6                	sd	s1,88(sp)
    80003114:	e8ca                	sd	s2,80(sp)
    80003116:	e4ce                	sd	s3,72(sp)
    80003118:	e0d2                	sd	s4,64(sp)
    8000311a:	fc56                	sd	s5,56(sp)
    8000311c:	f85a                	sd	s6,48(sp)
    8000311e:	f45e                	sd	s7,40(sp)
    80003120:	f062                	sd	s8,32(sp)
    80003122:	ec66                	sd	s9,24(sp)
    80003124:	e86a                	sd	s10,16(sp)
    80003126:	e46e                	sd	s11,8(sp)
    80003128:	1880                	addi	s0,sp,112
    8000312a:	8b2a                	mv	s6,a0
    8000312c:	8c2e                	mv	s8,a1
    8000312e:	8ab2                	mv	s5,a2
    80003130:	8936                	mv	s2,a3
    80003132:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80003134:	00e687bb          	addw	a5,a3,a4
    80003138:	0ed7e263          	bltu	a5,a3,8000321c <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    8000313c:	00043737          	lui	a4,0x43
    80003140:	0ef76063          	bltu	a4,a5,80003220 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003144:	0c0b8863          	beqz	s7,80003214 <writei+0x10e>
    80003148:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    8000314a:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    8000314e:	5cfd                	li	s9,-1
    80003150:	a091                	j	80003194 <writei+0x8e>
    80003152:	02099d93          	slli	s11,s3,0x20
    80003156:	020ddd93          	srli	s11,s11,0x20
    8000315a:	06048513          	addi	a0,s1,96
    8000315e:	86ee                	mv	a3,s11
    80003160:	8656                	mv	a2,s5
    80003162:	85e2                	mv	a1,s8
    80003164:	953a                	add	a0,a0,a4
    80003166:	fffff097          	auipc	ra,0xfffff
    8000316a:	8b0080e7          	jalr	-1872(ra) # 80001a16 <either_copyin>
    8000316e:	07950263          	beq	a0,s9,800031d2 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003172:	8526                	mv	a0,s1
    80003174:	00000097          	auipc	ra,0x0
    80003178:	798080e7          	jalr	1944(ra) # 8000390c <log_write>
    brelse(bp);
    8000317c:	8526                	mv	a0,s1
    8000317e:	fffff097          	auipc	ra,0xfffff
    80003182:	4b4080e7          	jalr	1204(ra) # 80002632 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003186:	01498a3b          	addw	s4,s3,s4
    8000318a:	0129893b          	addw	s2,s3,s2
    8000318e:	9aee                	add	s5,s5,s11
    80003190:	057a7663          	bgeu	s4,s7,800031dc <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003194:	000b2483          	lw	s1,0(s6)
    80003198:	00a9559b          	srliw	a1,s2,0xa
    8000319c:	855a                	mv	a0,s6
    8000319e:	fffff097          	auipc	ra,0xfffff
    800031a2:	7aa080e7          	jalr	1962(ra) # 80002948 <bmap>
    800031a6:	0005059b          	sext.w	a1,a0
    800031aa:	8526                	mv	a0,s1
    800031ac:	fffff097          	auipc	ra,0xfffff
    800031b0:	21e080e7          	jalr	542(ra) # 800023ca <bread>
    800031b4:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800031b6:	3ff97713          	andi	a4,s2,1023
    800031ba:	40ed07bb          	subw	a5,s10,a4
    800031be:	414b86bb          	subw	a3,s7,s4
    800031c2:	89be                	mv	s3,a5
    800031c4:	2781                	sext.w	a5,a5
    800031c6:	0006861b          	sext.w	a2,a3
    800031ca:	f8f674e3          	bgeu	a2,a5,80003152 <writei+0x4c>
    800031ce:	89b6                	mv	s3,a3
    800031d0:	b749                	j	80003152 <writei+0x4c>
      brelse(bp);
    800031d2:	8526                	mv	a0,s1
    800031d4:	fffff097          	auipc	ra,0xfffff
    800031d8:	45e080e7          	jalr	1118(ra) # 80002632 <brelse>
  }

  if(off > ip->size)
    800031dc:	054b2783          	lw	a5,84(s6)
    800031e0:	0127f463          	bgeu	a5,s2,800031e8 <writei+0xe2>
    ip->size = off;
    800031e4:	052b2a23          	sw	s2,84(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800031e8:	855a                	mv	a0,s6
    800031ea:	00000097          	auipc	ra,0x0
    800031ee:	aa4080e7          	jalr	-1372(ra) # 80002c8e <iupdate>

  return tot;
    800031f2:	000a051b          	sext.w	a0,s4
}
    800031f6:	70a6                	ld	ra,104(sp)
    800031f8:	7406                	ld	s0,96(sp)
    800031fa:	64e6                	ld	s1,88(sp)
    800031fc:	6946                	ld	s2,80(sp)
    800031fe:	69a6                	ld	s3,72(sp)
    80003200:	6a06                	ld	s4,64(sp)
    80003202:	7ae2                	ld	s5,56(sp)
    80003204:	7b42                	ld	s6,48(sp)
    80003206:	7ba2                	ld	s7,40(sp)
    80003208:	7c02                	ld	s8,32(sp)
    8000320a:	6ce2                	ld	s9,24(sp)
    8000320c:	6d42                	ld	s10,16(sp)
    8000320e:	6da2                	ld	s11,8(sp)
    80003210:	6165                	addi	sp,sp,112
    80003212:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003214:	8a5e                	mv	s4,s7
    80003216:	bfc9                	j	800031e8 <writei+0xe2>
    return -1;
    80003218:	557d                	li	a0,-1
}
    8000321a:	8082                	ret
    return -1;
    8000321c:	557d                	li	a0,-1
    8000321e:	bfe1                	j	800031f6 <writei+0xf0>
    return -1;
    80003220:	557d                	li	a0,-1
    80003222:	bfd1                	j	800031f6 <writei+0xf0>

0000000080003224 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003224:	1141                	addi	sp,sp,-16
    80003226:	e406                	sd	ra,8(sp)
    80003228:	e022                	sd	s0,0(sp)
    8000322a:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000322c:	4639                	li	a2,14
    8000322e:	ffffd097          	auipc	ra,0xffffd
    80003232:	120080e7          	jalr	288(ra) # 8000034e <strncmp>
}
    80003236:	60a2                	ld	ra,8(sp)
    80003238:	6402                	ld	s0,0(sp)
    8000323a:	0141                	addi	sp,sp,16
    8000323c:	8082                	ret

000000008000323e <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000323e:	7139                	addi	sp,sp,-64
    80003240:	fc06                	sd	ra,56(sp)
    80003242:	f822                	sd	s0,48(sp)
    80003244:	f426                	sd	s1,40(sp)
    80003246:	f04a                	sd	s2,32(sp)
    80003248:	ec4e                	sd	s3,24(sp)
    8000324a:	e852                	sd	s4,16(sp)
    8000324c:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    8000324e:	04c51703          	lh	a4,76(a0)
    80003252:	4785                	li	a5,1
    80003254:	00f71a63          	bne	a4,a5,80003268 <dirlookup+0x2a>
    80003258:	892a                	mv	s2,a0
    8000325a:	89ae                	mv	s3,a1
    8000325c:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    8000325e:	497c                	lw	a5,84(a0)
    80003260:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003262:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003264:	e79d                	bnez	a5,80003292 <dirlookup+0x54>
    80003266:	a8a5                	j	800032de <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003268:	00005517          	auipc	a0,0x5
    8000326c:	30050513          	addi	a0,a0,768 # 80008568 <syscalls+0x1a0>
    80003270:	00003097          	auipc	ra,0x3
    80003274:	ea4080e7          	jalr	-348(ra) # 80006114 <panic>
      panic("dirlookup read");
    80003278:	00005517          	auipc	a0,0x5
    8000327c:	30850513          	addi	a0,a0,776 # 80008580 <syscalls+0x1b8>
    80003280:	00003097          	auipc	ra,0x3
    80003284:	e94080e7          	jalr	-364(ra) # 80006114 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003288:	24c1                	addiw	s1,s1,16
    8000328a:	05492783          	lw	a5,84(s2)
    8000328e:	04f4f763          	bgeu	s1,a5,800032dc <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003292:	4741                	li	a4,16
    80003294:	86a6                	mv	a3,s1
    80003296:	fc040613          	addi	a2,s0,-64
    8000329a:	4581                	li	a1,0
    8000329c:	854a                	mv	a0,s2
    8000329e:	00000097          	auipc	ra,0x0
    800032a2:	d70080e7          	jalr	-656(ra) # 8000300e <readi>
    800032a6:	47c1                	li	a5,16
    800032a8:	fcf518e3          	bne	a0,a5,80003278 <dirlookup+0x3a>
    if(de.inum == 0)
    800032ac:	fc045783          	lhu	a5,-64(s0)
    800032b0:	dfe1                	beqz	a5,80003288 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800032b2:	fc240593          	addi	a1,s0,-62
    800032b6:	854e                	mv	a0,s3
    800032b8:	00000097          	auipc	ra,0x0
    800032bc:	f6c080e7          	jalr	-148(ra) # 80003224 <namecmp>
    800032c0:	f561                	bnez	a0,80003288 <dirlookup+0x4a>
      if(poff)
    800032c2:	000a0463          	beqz	s4,800032ca <dirlookup+0x8c>
        *poff = off;
    800032c6:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800032ca:	fc045583          	lhu	a1,-64(s0)
    800032ce:	00092503          	lw	a0,0(s2)
    800032d2:	fffff097          	auipc	ra,0xfffff
    800032d6:	752080e7          	jalr	1874(ra) # 80002a24 <iget>
    800032da:	a011                	j	800032de <dirlookup+0xa0>
  return 0;
    800032dc:	4501                	li	a0,0
}
    800032de:	70e2                	ld	ra,56(sp)
    800032e0:	7442                	ld	s0,48(sp)
    800032e2:	74a2                	ld	s1,40(sp)
    800032e4:	7902                	ld	s2,32(sp)
    800032e6:	69e2                	ld	s3,24(sp)
    800032e8:	6a42                	ld	s4,16(sp)
    800032ea:	6121                	addi	sp,sp,64
    800032ec:	8082                	ret

00000000800032ee <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800032ee:	711d                	addi	sp,sp,-96
    800032f0:	ec86                	sd	ra,88(sp)
    800032f2:	e8a2                	sd	s0,80(sp)
    800032f4:	e4a6                	sd	s1,72(sp)
    800032f6:	e0ca                	sd	s2,64(sp)
    800032f8:	fc4e                	sd	s3,56(sp)
    800032fa:	f852                	sd	s4,48(sp)
    800032fc:	f456                	sd	s5,40(sp)
    800032fe:	f05a                	sd	s6,32(sp)
    80003300:	ec5e                	sd	s7,24(sp)
    80003302:	e862                	sd	s8,16(sp)
    80003304:	e466                	sd	s9,8(sp)
    80003306:	e06a                	sd	s10,0(sp)
    80003308:	1080                	addi	s0,sp,96
    8000330a:	84aa                	mv	s1,a0
    8000330c:	8b2e                	mv	s6,a1
    8000330e:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003310:	00054703          	lbu	a4,0(a0)
    80003314:	02f00793          	li	a5,47
    80003318:	02f70363          	beq	a4,a5,8000333e <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000331c:	ffffe097          	auipc	ra,0xffffe
    80003320:	c3c080e7          	jalr	-964(ra) # 80000f58 <myproc>
    80003324:	15853503          	ld	a0,344(a0)
    80003328:	00000097          	auipc	ra,0x0
    8000332c:	9f4080e7          	jalr	-1548(ra) # 80002d1c <idup>
    80003330:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003332:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003336:	4cb5                	li	s9,13
  len = path - s;
    80003338:	4b81                	li	s7,0

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000333a:	4c05                	li	s8,1
    8000333c:	a87d                	j	800033fa <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    8000333e:	4585                	li	a1,1
    80003340:	4505                	li	a0,1
    80003342:	fffff097          	auipc	ra,0xfffff
    80003346:	6e2080e7          	jalr	1762(ra) # 80002a24 <iget>
    8000334a:	8a2a                	mv	s4,a0
    8000334c:	b7dd                	j	80003332 <namex+0x44>
      iunlockput(ip);
    8000334e:	8552                	mv	a0,s4
    80003350:	00000097          	auipc	ra,0x0
    80003354:	c6c080e7          	jalr	-916(ra) # 80002fbc <iunlockput>
      return 0;
    80003358:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000335a:	8552                	mv	a0,s4
    8000335c:	60e6                	ld	ra,88(sp)
    8000335e:	6446                	ld	s0,80(sp)
    80003360:	64a6                	ld	s1,72(sp)
    80003362:	6906                	ld	s2,64(sp)
    80003364:	79e2                	ld	s3,56(sp)
    80003366:	7a42                	ld	s4,48(sp)
    80003368:	7aa2                	ld	s5,40(sp)
    8000336a:	7b02                	ld	s6,32(sp)
    8000336c:	6be2                	ld	s7,24(sp)
    8000336e:	6c42                	ld	s8,16(sp)
    80003370:	6ca2                	ld	s9,8(sp)
    80003372:	6d02                	ld	s10,0(sp)
    80003374:	6125                	addi	sp,sp,96
    80003376:	8082                	ret
      iunlock(ip);
    80003378:	8552                	mv	a0,s4
    8000337a:	00000097          	auipc	ra,0x0
    8000337e:	aa2080e7          	jalr	-1374(ra) # 80002e1c <iunlock>
      return ip;
    80003382:	bfe1                	j	8000335a <namex+0x6c>
      iunlockput(ip);
    80003384:	8552                	mv	a0,s4
    80003386:	00000097          	auipc	ra,0x0
    8000338a:	c36080e7          	jalr	-970(ra) # 80002fbc <iunlockput>
      return 0;
    8000338e:	8a4e                	mv	s4,s3
    80003390:	b7e9                	j	8000335a <namex+0x6c>
  len = path - s;
    80003392:	40998633          	sub	a2,s3,s1
    80003396:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    8000339a:	09acd863          	bge	s9,s10,8000342a <namex+0x13c>
    memmove(name, s, DIRSIZ);
    8000339e:	4639                	li	a2,14
    800033a0:	85a6                	mv	a1,s1
    800033a2:	8556                	mv	a0,s5
    800033a4:	ffffd097          	auipc	ra,0xffffd
    800033a8:	f36080e7          	jalr	-202(ra) # 800002da <memmove>
    800033ac:	84ce                	mv	s1,s3
  while(*path == '/')
    800033ae:	0004c783          	lbu	a5,0(s1)
    800033b2:	01279763          	bne	a5,s2,800033c0 <namex+0xd2>
    path++;
    800033b6:	0485                	addi	s1,s1,1
  while(*path == '/')
    800033b8:	0004c783          	lbu	a5,0(s1)
    800033bc:	ff278de3          	beq	a5,s2,800033b6 <namex+0xc8>
    ilock(ip);
    800033c0:	8552                	mv	a0,s4
    800033c2:	00000097          	auipc	ra,0x0
    800033c6:	998080e7          	jalr	-1640(ra) # 80002d5a <ilock>
    if(ip->type != T_DIR){
    800033ca:	04ca1783          	lh	a5,76(s4)
    800033ce:	f98790e3          	bne	a5,s8,8000334e <namex+0x60>
    if(nameiparent && *path == '\0'){
    800033d2:	000b0563          	beqz	s6,800033dc <namex+0xee>
    800033d6:	0004c783          	lbu	a5,0(s1)
    800033da:	dfd9                	beqz	a5,80003378 <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    800033dc:	865e                	mv	a2,s7
    800033de:	85d6                	mv	a1,s5
    800033e0:	8552                	mv	a0,s4
    800033e2:	00000097          	auipc	ra,0x0
    800033e6:	e5c080e7          	jalr	-420(ra) # 8000323e <dirlookup>
    800033ea:	89aa                	mv	s3,a0
    800033ec:	dd41                	beqz	a0,80003384 <namex+0x96>
    iunlockput(ip);
    800033ee:	8552                	mv	a0,s4
    800033f0:	00000097          	auipc	ra,0x0
    800033f4:	bcc080e7          	jalr	-1076(ra) # 80002fbc <iunlockput>
    ip = next;
    800033f8:	8a4e                	mv	s4,s3
  while(*path == '/')
    800033fa:	0004c783          	lbu	a5,0(s1)
    800033fe:	01279763          	bne	a5,s2,8000340c <namex+0x11e>
    path++;
    80003402:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003404:	0004c783          	lbu	a5,0(s1)
    80003408:	ff278de3          	beq	a5,s2,80003402 <namex+0x114>
  if(*path == 0)
    8000340c:	cb9d                	beqz	a5,80003442 <namex+0x154>
  while(*path != '/' && *path != 0)
    8000340e:	0004c783          	lbu	a5,0(s1)
    80003412:	89a6                	mv	s3,s1
  len = path - s;
    80003414:	8d5e                	mv	s10,s7
    80003416:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80003418:	01278963          	beq	a5,s2,8000342a <namex+0x13c>
    8000341c:	dbbd                	beqz	a5,80003392 <namex+0xa4>
    path++;
    8000341e:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003420:	0009c783          	lbu	a5,0(s3)
    80003424:	ff279ce3          	bne	a5,s2,8000341c <namex+0x12e>
    80003428:	b7ad                	j	80003392 <namex+0xa4>
    memmove(name, s, len);
    8000342a:	2601                	sext.w	a2,a2
    8000342c:	85a6                	mv	a1,s1
    8000342e:	8556                	mv	a0,s5
    80003430:	ffffd097          	auipc	ra,0xffffd
    80003434:	eaa080e7          	jalr	-342(ra) # 800002da <memmove>
    name[len] = 0;
    80003438:	9d56                	add	s10,s10,s5
    8000343a:	000d0023          	sb	zero,0(s10)
    8000343e:	84ce                	mv	s1,s3
    80003440:	b7bd                	j	800033ae <namex+0xc0>
  if(nameiparent){
    80003442:	f00b0ce3          	beqz	s6,8000335a <namex+0x6c>
    iput(ip);
    80003446:	8552                	mv	a0,s4
    80003448:	00000097          	auipc	ra,0x0
    8000344c:	acc080e7          	jalr	-1332(ra) # 80002f14 <iput>
    return 0;
    80003450:	4a01                	li	s4,0
    80003452:	b721                	j	8000335a <namex+0x6c>

0000000080003454 <dirlink>:
{
    80003454:	7139                	addi	sp,sp,-64
    80003456:	fc06                	sd	ra,56(sp)
    80003458:	f822                	sd	s0,48(sp)
    8000345a:	f426                	sd	s1,40(sp)
    8000345c:	f04a                	sd	s2,32(sp)
    8000345e:	ec4e                	sd	s3,24(sp)
    80003460:	e852                	sd	s4,16(sp)
    80003462:	0080                	addi	s0,sp,64
    80003464:	892a                	mv	s2,a0
    80003466:	8a2e                	mv	s4,a1
    80003468:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    8000346a:	4601                	li	a2,0
    8000346c:	00000097          	auipc	ra,0x0
    80003470:	dd2080e7          	jalr	-558(ra) # 8000323e <dirlookup>
    80003474:	e93d                	bnez	a0,800034ea <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003476:	05492483          	lw	s1,84(s2)
    8000347a:	c49d                	beqz	s1,800034a8 <dirlink+0x54>
    8000347c:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000347e:	4741                	li	a4,16
    80003480:	86a6                	mv	a3,s1
    80003482:	fc040613          	addi	a2,s0,-64
    80003486:	4581                	li	a1,0
    80003488:	854a                	mv	a0,s2
    8000348a:	00000097          	auipc	ra,0x0
    8000348e:	b84080e7          	jalr	-1148(ra) # 8000300e <readi>
    80003492:	47c1                	li	a5,16
    80003494:	06f51163          	bne	a0,a5,800034f6 <dirlink+0xa2>
    if(de.inum == 0)
    80003498:	fc045783          	lhu	a5,-64(s0)
    8000349c:	c791                	beqz	a5,800034a8 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000349e:	24c1                	addiw	s1,s1,16
    800034a0:	05492783          	lw	a5,84(s2)
    800034a4:	fcf4ede3          	bltu	s1,a5,8000347e <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800034a8:	4639                	li	a2,14
    800034aa:	85d2                	mv	a1,s4
    800034ac:	fc240513          	addi	a0,s0,-62
    800034b0:	ffffd097          	auipc	ra,0xffffd
    800034b4:	eda080e7          	jalr	-294(ra) # 8000038a <strncpy>
  de.inum = inum;
    800034b8:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800034bc:	4741                	li	a4,16
    800034be:	86a6                	mv	a3,s1
    800034c0:	fc040613          	addi	a2,s0,-64
    800034c4:	4581                	li	a1,0
    800034c6:	854a                	mv	a0,s2
    800034c8:	00000097          	auipc	ra,0x0
    800034cc:	c3e080e7          	jalr	-962(ra) # 80003106 <writei>
    800034d0:	872a                	mv	a4,a0
    800034d2:	47c1                	li	a5,16
  return 0;
    800034d4:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800034d6:	02f71863          	bne	a4,a5,80003506 <dirlink+0xb2>
}
    800034da:	70e2                	ld	ra,56(sp)
    800034dc:	7442                	ld	s0,48(sp)
    800034de:	74a2                	ld	s1,40(sp)
    800034e0:	7902                	ld	s2,32(sp)
    800034e2:	69e2                	ld	s3,24(sp)
    800034e4:	6a42                	ld	s4,16(sp)
    800034e6:	6121                	addi	sp,sp,64
    800034e8:	8082                	ret
    iput(ip);
    800034ea:	00000097          	auipc	ra,0x0
    800034ee:	a2a080e7          	jalr	-1494(ra) # 80002f14 <iput>
    return -1;
    800034f2:	557d                	li	a0,-1
    800034f4:	b7dd                	j	800034da <dirlink+0x86>
      panic("dirlink read");
    800034f6:	00005517          	auipc	a0,0x5
    800034fa:	09a50513          	addi	a0,a0,154 # 80008590 <syscalls+0x1c8>
    800034fe:	00003097          	auipc	ra,0x3
    80003502:	c16080e7          	jalr	-1002(ra) # 80006114 <panic>
    panic("dirlink");
    80003506:	00005517          	auipc	a0,0x5
    8000350a:	19a50513          	addi	a0,a0,410 # 800086a0 <syscalls+0x2d8>
    8000350e:	00003097          	auipc	ra,0x3
    80003512:	c06080e7          	jalr	-1018(ra) # 80006114 <panic>

0000000080003516 <namei>:

struct inode*
namei(char *path)
{
    80003516:	1101                	addi	sp,sp,-32
    80003518:	ec06                	sd	ra,24(sp)
    8000351a:	e822                	sd	s0,16(sp)
    8000351c:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    8000351e:	fe040613          	addi	a2,s0,-32
    80003522:	4581                	li	a1,0
    80003524:	00000097          	auipc	ra,0x0
    80003528:	dca080e7          	jalr	-566(ra) # 800032ee <namex>
}
    8000352c:	60e2                	ld	ra,24(sp)
    8000352e:	6442                	ld	s0,16(sp)
    80003530:	6105                	addi	sp,sp,32
    80003532:	8082                	ret

0000000080003534 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003534:	1141                	addi	sp,sp,-16
    80003536:	e406                	sd	ra,8(sp)
    80003538:	e022                	sd	s0,0(sp)
    8000353a:	0800                	addi	s0,sp,16
    8000353c:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000353e:	4585                	li	a1,1
    80003540:	00000097          	auipc	ra,0x0
    80003544:	dae080e7          	jalr	-594(ra) # 800032ee <namex>
}
    80003548:	60a2                	ld	ra,8(sp)
    8000354a:	6402                	ld	s0,0(sp)
    8000354c:	0141                	addi	sp,sp,16
    8000354e:	8082                	ret

0000000080003550 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003550:	1101                	addi	sp,sp,-32
    80003552:	ec06                	sd	ra,24(sp)
    80003554:	e822                	sd	s0,16(sp)
    80003556:	e426                	sd	s1,8(sp)
    80003558:	e04a                	sd	s2,0(sp)
    8000355a:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000355c:	00019917          	auipc	s2,0x19
    80003560:	69490913          	addi	s2,s2,1684 # 8001cbf0 <log>
    80003564:	02092583          	lw	a1,32(s2)
    80003568:	03092503          	lw	a0,48(s2)
    8000356c:	fffff097          	auipc	ra,0xfffff
    80003570:	e5e080e7          	jalr	-418(ra) # 800023ca <bread>
    80003574:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003576:	03492683          	lw	a3,52(s2)
    8000357a:	d134                	sw	a3,96(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000357c:	02d05863          	blez	a3,800035ac <write_head+0x5c>
    80003580:	00019797          	auipc	a5,0x19
    80003584:	6a878793          	addi	a5,a5,1704 # 8001cc28 <log+0x38>
    80003588:	06450713          	addi	a4,a0,100
    8000358c:	36fd                	addiw	a3,a3,-1
    8000358e:	02069613          	slli	a2,a3,0x20
    80003592:	01e65693          	srli	a3,a2,0x1e
    80003596:	00019617          	auipc	a2,0x19
    8000359a:	69660613          	addi	a2,a2,1686 # 8001cc2c <log+0x3c>
    8000359e:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800035a0:	4390                	lw	a2,0(a5)
    800035a2:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800035a4:	0791                	addi	a5,a5,4
    800035a6:	0711                	addi	a4,a4,4 # 43004 <_entry-0x7ffbcffc>
    800035a8:	fed79ce3          	bne	a5,a3,800035a0 <write_head+0x50>
  }
  bwrite(buf);
    800035ac:	8526                	mv	a0,s1
    800035ae:	fffff097          	auipc	ra,0xfffff
    800035b2:	046080e7          	jalr	70(ra) # 800025f4 <bwrite>
  brelse(buf);
    800035b6:	8526                	mv	a0,s1
    800035b8:	fffff097          	auipc	ra,0xfffff
    800035bc:	07a080e7          	jalr	122(ra) # 80002632 <brelse>
}
    800035c0:	60e2                	ld	ra,24(sp)
    800035c2:	6442                	ld	s0,16(sp)
    800035c4:	64a2                	ld	s1,8(sp)
    800035c6:	6902                	ld	s2,0(sp)
    800035c8:	6105                	addi	sp,sp,32
    800035ca:	8082                	ret

00000000800035cc <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800035cc:	00019797          	auipc	a5,0x19
    800035d0:	6587a783          	lw	a5,1624(a5) # 8001cc24 <log+0x34>
    800035d4:	0af05d63          	blez	a5,8000368e <install_trans+0xc2>
{
    800035d8:	7139                	addi	sp,sp,-64
    800035da:	fc06                	sd	ra,56(sp)
    800035dc:	f822                	sd	s0,48(sp)
    800035de:	f426                	sd	s1,40(sp)
    800035e0:	f04a                	sd	s2,32(sp)
    800035e2:	ec4e                	sd	s3,24(sp)
    800035e4:	e852                	sd	s4,16(sp)
    800035e6:	e456                	sd	s5,8(sp)
    800035e8:	e05a                	sd	s6,0(sp)
    800035ea:	0080                	addi	s0,sp,64
    800035ec:	8b2a                	mv	s6,a0
    800035ee:	00019a97          	auipc	s5,0x19
    800035f2:	63aa8a93          	addi	s5,s5,1594 # 8001cc28 <log+0x38>
  for (tail = 0; tail < log.lh.n; tail++) {
    800035f6:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800035f8:	00019997          	auipc	s3,0x19
    800035fc:	5f898993          	addi	s3,s3,1528 # 8001cbf0 <log>
    80003600:	a00d                	j	80003622 <install_trans+0x56>
    brelse(lbuf);
    80003602:	854a                	mv	a0,s2
    80003604:	fffff097          	auipc	ra,0xfffff
    80003608:	02e080e7          	jalr	46(ra) # 80002632 <brelse>
    brelse(dbuf);
    8000360c:	8526                	mv	a0,s1
    8000360e:	fffff097          	auipc	ra,0xfffff
    80003612:	024080e7          	jalr	36(ra) # 80002632 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003616:	2a05                	addiw	s4,s4,1
    80003618:	0a91                	addi	s5,s5,4
    8000361a:	0349a783          	lw	a5,52(s3)
    8000361e:	04fa5e63          	bge	s4,a5,8000367a <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003622:	0209a583          	lw	a1,32(s3)
    80003626:	014585bb          	addw	a1,a1,s4
    8000362a:	2585                	addiw	a1,a1,1
    8000362c:	0309a503          	lw	a0,48(s3)
    80003630:	fffff097          	auipc	ra,0xfffff
    80003634:	d9a080e7          	jalr	-614(ra) # 800023ca <bread>
    80003638:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000363a:	000aa583          	lw	a1,0(s5)
    8000363e:	0309a503          	lw	a0,48(s3)
    80003642:	fffff097          	auipc	ra,0xfffff
    80003646:	d88080e7          	jalr	-632(ra) # 800023ca <bread>
    8000364a:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000364c:	40000613          	li	a2,1024
    80003650:	06090593          	addi	a1,s2,96
    80003654:	06050513          	addi	a0,a0,96
    80003658:	ffffd097          	auipc	ra,0xffffd
    8000365c:	c82080e7          	jalr	-894(ra) # 800002da <memmove>
    bwrite(dbuf);  // write dst to disk
    80003660:	8526                	mv	a0,s1
    80003662:	fffff097          	auipc	ra,0xfffff
    80003666:	f92080e7          	jalr	-110(ra) # 800025f4 <bwrite>
    if(recovering == 0)
    8000366a:	f80b1ce3          	bnez	s6,80003602 <install_trans+0x36>
      bunpin(dbuf);
    8000366e:	8526                	mv	a0,s1
    80003670:	fffff097          	auipc	ra,0xfffff
    80003674:	0de080e7          	jalr	222(ra) # 8000274e <bunpin>
    80003678:	b769                	j	80003602 <install_trans+0x36>
}
    8000367a:	70e2                	ld	ra,56(sp)
    8000367c:	7442                	ld	s0,48(sp)
    8000367e:	74a2                	ld	s1,40(sp)
    80003680:	7902                	ld	s2,32(sp)
    80003682:	69e2                	ld	s3,24(sp)
    80003684:	6a42                	ld	s4,16(sp)
    80003686:	6aa2                	ld	s5,8(sp)
    80003688:	6b02                	ld	s6,0(sp)
    8000368a:	6121                	addi	sp,sp,64
    8000368c:	8082                	ret
    8000368e:	8082                	ret

0000000080003690 <initlog>:
{
    80003690:	7179                	addi	sp,sp,-48
    80003692:	f406                	sd	ra,40(sp)
    80003694:	f022                	sd	s0,32(sp)
    80003696:	ec26                	sd	s1,24(sp)
    80003698:	e84a                	sd	s2,16(sp)
    8000369a:	e44e                	sd	s3,8(sp)
    8000369c:	1800                	addi	s0,sp,48
    8000369e:	892a                	mv	s2,a0
    800036a0:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800036a2:	00019497          	auipc	s1,0x19
    800036a6:	54e48493          	addi	s1,s1,1358 # 8001cbf0 <log>
    800036aa:	00005597          	auipc	a1,0x5
    800036ae:	ef658593          	addi	a1,a1,-266 # 800085a0 <syscalls+0x1d8>
    800036b2:	8526                	mv	a0,s1
    800036b4:	00003097          	auipc	ra,0x3
    800036b8:	0fe080e7          	jalr	254(ra) # 800067b2 <initlock>
  log.start = sb->logstart;
    800036bc:	0149a583          	lw	a1,20(s3)
    800036c0:	d08c                	sw	a1,32(s1)
  log.size = sb->nlog;
    800036c2:	0109a783          	lw	a5,16(s3)
    800036c6:	d0dc                	sw	a5,36(s1)
  log.dev = dev;
    800036c8:	0324a823          	sw	s2,48(s1)
  struct buf *buf = bread(log.dev, log.start);
    800036cc:	854a                	mv	a0,s2
    800036ce:	fffff097          	auipc	ra,0xfffff
    800036d2:	cfc080e7          	jalr	-772(ra) # 800023ca <bread>
  log.lh.n = lh->n;
    800036d6:	5134                	lw	a3,96(a0)
    800036d8:	d8d4                	sw	a3,52(s1)
  for (i = 0; i < log.lh.n; i++) {
    800036da:	02d05663          	blez	a3,80003706 <initlog+0x76>
    800036de:	06450793          	addi	a5,a0,100
    800036e2:	00019717          	auipc	a4,0x19
    800036e6:	54670713          	addi	a4,a4,1350 # 8001cc28 <log+0x38>
    800036ea:	36fd                	addiw	a3,a3,-1
    800036ec:	02069613          	slli	a2,a3,0x20
    800036f0:	01e65693          	srli	a3,a2,0x1e
    800036f4:	06850613          	addi	a2,a0,104
    800036f8:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    800036fa:	4390                	lw	a2,0(a5)
    800036fc:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800036fe:	0791                	addi	a5,a5,4
    80003700:	0711                	addi	a4,a4,4
    80003702:	fed79ce3          	bne	a5,a3,800036fa <initlog+0x6a>
  brelse(buf);
    80003706:	fffff097          	auipc	ra,0xfffff
    8000370a:	f2c080e7          	jalr	-212(ra) # 80002632 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000370e:	4505                	li	a0,1
    80003710:	00000097          	auipc	ra,0x0
    80003714:	ebc080e7          	jalr	-324(ra) # 800035cc <install_trans>
  log.lh.n = 0;
    80003718:	00019797          	auipc	a5,0x19
    8000371c:	5007a623          	sw	zero,1292(a5) # 8001cc24 <log+0x34>
  write_head(); // clear the log
    80003720:	00000097          	auipc	ra,0x0
    80003724:	e30080e7          	jalr	-464(ra) # 80003550 <write_head>
}
    80003728:	70a2                	ld	ra,40(sp)
    8000372a:	7402                	ld	s0,32(sp)
    8000372c:	64e2                	ld	s1,24(sp)
    8000372e:	6942                	ld	s2,16(sp)
    80003730:	69a2                	ld	s3,8(sp)
    80003732:	6145                	addi	sp,sp,48
    80003734:	8082                	ret

0000000080003736 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003736:	1101                	addi	sp,sp,-32
    80003738:	ec06                	sd	ra,24(sp)
    8000373a:	e822                	sd	s0,16(sp)
    8000373c:	e426                	sd	s1,8(sp)
    8000373e:	e04a                	sd	s2,0(sp)
    80003740:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003742:	00019517          	auipc	a0,0x19
    80003746:	4ae50513          	addi	a0,a0,1198 # 8001cbf0 <log>
    8000374a:	00003097          	auipc	ra,0x3
    8000374e:	eec080e7          	jalr	-276(ra) # 80006636 <acquire>
  while(1){
    if(log.committing){
    80003752:	00019497          	auipc	s1,0x19
    80003756:	49e48493          	addi	s1,s1,1182 # 8001cbf0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000375a:	4979                	li	s2,30
    8000375c:	a039                	j	8000376a <begin_op+0x34>
      sleep(&log, &log.lock);
    8000375e:	85a6                	mv	a1,s1
    80003760:	8526                	mv	a0,s1
    80003762:	ffffe097          	auipc	ra,0xffffe
    80003766:	eba080e7          	jalr	-326(ra) # 8000161c <sleep>
    if(log.committing){
    8000376a:	54dc                	lw	a5,44(s1)
    8000376c:	fbed                	bnez	a5,8000375e <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000376e:	5498                	lw	a4,40(s1)
    80003770:	2705                	addiw	a4,a4,1
    80003772:	0007069b          	sext.w	a3,a4
    80003776:	0027179b          	slliw	a5,a4,0x2
    8000377a:	9fb9                	addw	a5,a5,a4
    8000377c:	0017979b          	slliw	a5,a5,0x1
    80003780:	58d8                	lw	a4,52(s1)
    80003782:	9fb9                	addw	a5,a5,a4
    80003784:	00f95963          	bge	s2,a5,80003796 <begin_op+0x60>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003788:	85a6                	mv	a1,s1
    8000378a:	8526                	mv	a0,s1
    8000378c:	ffffe097          	auipc	ra,0xffffe
    80003790:	e90080e7          	jalr	-368(ra) # 8000161c <sleep>
    80003794:	bfd9                	j	8000376a <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003796:	00019517          	auipc	a0,0x19
    8000379a:	45a50513          	addi	a0,a0,1114 # 8001cbf0 <log>
    8000379e:	d514                	sw	a3,40(a0)
      release(&log.lock);
    800037a0:	00003097          	auipc	ra,0x3
    800037a4:	f66080e7          	jalr	-154(ra) # 80006706 <release>
      break;
    }
  }
}
    800037a8:	60e2                	ld	ra,24(sp)
    800037aa:	6442                	ld	s0,16(sp)
    800037ac:	64a2                	ld	s1,8(sp)
    800037ae:	6902                	ld	s2,0(sp)
    800037b0:	6105                	addi	sp,sp,32
    800037b2:	8082                	ret

00000000800037b4 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800037b4:	7139                	addi	sp,sp,-64
    800037b6:	fc06                	sd	ra,56(sp)
    800037b8:	f822                	sd	s0,48(sp)
    800037ba:	f426                	sd	s1,40(sp)
    800037bc:	f04a                	sd	s2,32(sp)
    800037be:	ec4e                	sd	s3,24(sp)
    800037c0:	e852                	sd	s4,16(sp)
    800037c2:	e456                	sd	s5,8(sp)
    800037c4:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800037c6:	00019497          	auipc	s1,0x19
    800037ca:	42a48493          	addi	s1,s1,1066 # 8001cbf0 <log>
    800037ce:	8526                	mv	a0,s1
    800037d0:	00003097          	auipc	ra,0x3
    800037d4:	e66080e7          	jalr	-410(ra) # 80006636 <acquire>
  log.outstanding -= 1;
    800037d8:	549c                	lw	a5,40(s1)
    800037da:	37fd                	addiw	a5,a5,-1
    800037dc:	0007891b          	sext.w	s2,a5
    800037e0:	d49c                	sw	a5,40(s1)
  if(log.committing)
    800037e2:	54dc                	lw	a5,44(s1)
    800037e4:	e7b9                	bnez	a5,80003832 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    800037e6:	04091e63          	bnez	s2,80003842 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800037ea:	00019497          	auipc	s1,0x19
    800037ee:	40648493          	addi	s1,s1,1030 # 8001cbf0 <log>
    800037f2:	4785                	li	a5,1
    800037f4:	d4dc                	sw	a5,44(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800037f6:	8526                	mv	a0,s1
    800037f8:	00003097          	auipc	ra,0x3
    800037fc:	f0e080e7          	jalr	-242(ra) # 80006706 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003800:	58dc                	lw	a5,52(s1)
    80003802:	06f04763          	bgtz	a5,80003870 <end_op+0xbc>
    acquire(&log.lock);
    80003806:	00019497          	auipc	s1,0x19
    8000380a:	3ea48493          	addi	s1,s1,1002 # 8001cbf0 <log>
    8000380e:	8526                	mv	a0,s1
    80003810:	00003097          	auipc	ra,0x3
    80003814:	e26080e7          	jalr	-474(ra) # 80006636 <acquire>
    log.committing = 0;
    80003818:	0204a623          	sw	zero,44(s1)
    wakeup(&log);
    8000381c:	8526                	mv	a0,s1
    8000381e:	ffffe097          	auipc	ra,0xffffe
    80003822:	f8a080e7          	jalr	-118(ra) # 800017a8 <wakeup>
    release(&log.lock);
    80003826:	8526                	mv	a0,s1
    80003828:	00003097          	auipc	ra,0x3
    8000382c:	ede080e7          	jalr	-290(ra) # 80006706 <release>
}
    80003830:	a03d                	j	8000385e <end_op+0xaa>
    panic("log.committing");
    80003832:	00005517          	auipc	a0,0x5
    80003836:	d7650513          	addi	a0,a0,-650 # 800085a8 <syscalls+0x1e0>
    8000383a:	00003097          	auipc	ra,0x3
    8000383e:	8da080e7          	jalr	-1830(ra) # 80006114 <panic>
    wakeup(&log);
    80003842:	00019497          	auipc	s1,0x19
    80003846:	3ae48493          	addi	s1,s1,942 # 8001cbf0 <log>
    8000384a:	8526                	mv	a0,s1
    8000384c:	ffffe097          	auipc	ra,0xffffe
    80003850:	f5c080e7          	jalr	-164(ra) # 800017a8 <wakeup>
  release(&log.lock);
    80003854:	8526                	mv	a0,s1
    80003856:	00003097          	auipc	ra,0x3
    8000385a:	eb0080e7          	jalr	-336(ra) # 80006706 <release>
}
    8000385e:	70e2                	ld	ra,56(sp)
    80003860:	7442                	ld	s0,48(sp)
    80003862:	74a2                	ld	s1,40(sp)
    80003864:	7902                	ld	s2,32(sp)
    80003866:	69e2                	ld	s3,24(sp)
    80003868:	6a42                	ld	s4,16(sp)
    8000386a:	6aa2                	ld	s5,8(sp)
    8000386c:	6121                	addi	sp,sp,64
    8000386e:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80003870:	00019a97          	auipc	s5,0x19
    80003874:	3b8a8a93          	addi	s5,s5,952 # 8001cc28 <log+0x38>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003878:	00019a17          	auipc	s4,0x19
    8000387c:	378a0a13          	addi	s4,s4,888 # 8001cbf0 <log>
    80003880:	020a2583          	lw	a1,32(s4)
    80003884:	012585bb          	addw	a1,a1,s2
    80003888:	2585                	addiw	a1,a1,1
    8000388a:	030a2503          	lw	a0,48(s4)
    8000388e:	fffff097          	auipc	ra,0xfffff
    80003892:	b3c080e7          	jalr	-1220(ra) # 800023ca <bread>
    80003896:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003898:	000aa583          	lw	a1,0(s5)
    8000389c:	030a2503          	lw	a0,48(s4)
    800038a0:	fffff097          	auipc	ra,0xfffff
    800038a4:	b2a080e7          	jalr	-1238(ra) # 800023ca <bread>
    800038a8:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800038aa:	40000613          	li	a2,1024
    800038ae:	06050593          	addi	a1,a0,96
    800038b2:	06048513          	addi	a0,s1,96
    800038b6:	ffffd097          	auipc	ra,0xffffd
    800038ba:	a24080e7          	jalr	-1500(ra) # 800002da <memmove>
    bwrite(to);  // write the log
    800038be:	8526                	mv	a0,s1
    800038c0:	fffff097          	auipc	ra,0xfffff
    800038c4:	d34080e7          	jalr	-716(ra) # 800025f4 <bwrite>
    brelse(from);
    800038c8:	854e                	mv	a0,s3
    800038ca:	fffff097          	auipc	ra,0xfffff
    800038ce:	d68080e7          	jalr	-664(ra) # 80002632 <brelse>
    brelse(to);
    800038d2:	8526                	mv	a0,s1
    800038d4:	fffff097          	auipc	ra,0xfffff
    800038d8:	d5e080e7          	jalr	-674(ra) # 80002632 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800038dc:	2905                	addiw	s2,s2,1
    800038de:	0a91                	addi	s5,s5,4
    800038e0:	034a2783          	lw	a5,52(s4)
    800038e4:	f8f94ee3          	blt	s2,a5,80003880 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800038e8:	00000097          	auipc	ra,0x0
    800038ec:	c68080e7          	jalr	-920(ra) # 80003550 <write_head>
    install_trans(0); // Now install writes to home locations
    800038f0:	4501                	li	a0,0
    800038f2:	00000097          	auipc	ra,0x0
    800038f6:	cda080e7          	jalr	-806(ra) # 800035cc <install_trans>
    log.lh.n = 0;
    800038fa:	00019797          	auipc	a5,0x19
    800038fe:	3207a523          	sw	zero,810(a5) # 8001cc24 <log+0x34>
    write_head();    // Erase the transaction from the log
    80003902:	00000097          	auipc	ra,0x0
    80003906:	c4e080e7          	jalr	-946(ra) # 80003550 <write_head>
    8000390a:	bdf5                	j	80003806 <end_op+0x52>

000000008000390c <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000390c:	1101                	addi	sp,sp,-32
    8000390e:	ec06                	sd	ra,24(sp)
    80003910:	e822                	sd	s0,16(sp)
    80003912:	e426                	sd	s1,8(sp)
    80003914:	e04a                	sd	s2,0(sp)
    80003916:	1000                	addi	s0,sp,32
    80003918:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000391a:	00019917          	auipc	s2,0x19
    8000391e:	2d690913          	addi	s2,s2,726 # 8001cbf0 <log>
    80003922:	854a                	mv	a0,s2
    80003924:	00003097          	auipc	ra,0x3
    80003928:	d12080e7          	jalr	-750(ra) # 80006636 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000392c:	03492603          	lw	a2,52(s2)
    80003930:	47f5                	li	a5,29
    80003932:	06c7c563          	blt	a5,a2,8000399c <log_write+0x90>
    80003936:	00019797          	auipc	a5,0x19
    8000393a:	2de7a783          	lw	a5,734(a5) # 8001cc14 <log+0x24>
    8000393e:	37fd                	addiw	a5,a5,-1
    80003940:	04f65e63          	bge	a2,a5,8000399c <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003944:	00019797          	auipc	a5,0x19
    80003948:	2d47a783          	lw	a5,724(a5) # 8001cc18 <log+0x28>
    8000394c:	06f05063          	blez	a5,800039ac <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003950:	4781                	li	a5,0
    80003952:	06c05563          	blez	a2,800039bc <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003956:	44cc                	lw	a1,12(s1)
    80003958:	00019717          	auipc	a4,0x19
    8000395c:	2d070713          	addi	a4,a4,720 # 8001cc28 <log+0x38>
  for (i = 0; i < log.lh.n; i++) {
    80003960:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003962:	4314                	lw	a3,0(a4)
    80003964:	04b68c63          	beq	a3,a1,800039bc <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003968:	2785                	addiw	a5,a5,1
    8000396a:	0711                	addi	a4,a4,4
    8000396c:	fef61be3          	bne	a2,a5,80003962 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003970:	0631                	addi	a2,a2,12
    80003972:	060a                	slli	a2,a2,0x2
    80003974:	00019797          	auipc	a5,0x19
    80003978:	27c78793          	addi	a5,a5,636 # 8001cbf0 <log>
    8000397c:	97b2                	add	a5,a5,a2
    8000397e:	44d8                	lw	a4,12(s1)
    80003980:	c798                	sw	a4,8(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003982:	8526                	mv	a0,s1
    80003984:	fffff097          	auipc	ra,0xfffff
    80003988:	d7a080e7          	jalr	-646(ra) # 800026fe <bpin>
    log.lh.n++;
    8000398c:	00019717          	auipc	a4,0x19
    80003990:	26470713          	addi	a4,a4,612 # 8001cbf0 <log>
    80003994:	5b5c                	lw	a5,52(a4)
    80003996:	2785                	addiw	a5,a5,1
    80003998:	db5c                	sw	a5,52(a4)
    8000399a:	a82d                	j	800039d4 <log_write+0xc8>
    panic("too big a transaction");
    8000399c:	00005517          	auipc	a0,0x5
    800039a0:	c1c50513          	addi	a0,a0,-996 # 800085b8 <syscalls+0x1f0>
    800039a4:	00002097          	auipc	ra,0x2
    800039a8:	770080e7          	jalr	1904(ra) # 80006114 <panic>
    panic("log_write outside of trans");
    800039ac:	00005517          	auipc	a0,0x5
    800039b0:	c2450513          	addi	a0,a0,-988 # 800085d0 <syscalls+0x208>
    800039b4:	00002097          	auipc	ra,0x2
    800039b8:	760080e7          	jalr	1888(ra) # 80006114 <panic>
  log.lh.block[i] = b->blockno;
    800039bc:	00c78693          	addi	a3,a5,12
    800039c0:	068a                	slli	a3,a3,0x2
    800039c2:	00019717          	auipc	a4,0x19
    800039c6:	22e70713          	addi	a4,a4,558 # 8001cbf0 <log>
    800039ca:	9736                	add	a4,a4,a3
    800039cc:	44d4                	lw	a3,12(s1)
    800039ce:	c714                	sw	a3,8(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800039d0:	faf609e3          	beq	a2,a5,80003982 <log_write+0x76>
  }
  release(&log.lock);
    800039d4:	00019517          	auipc	a0,0x19
    800039d8:	21c50513          	addi	a0,a0,540 # 8001cbf0 <log>
    800039dc:	00003097          	auipc	ra,0x3
    800039e0:	d2a080e7          	jalr	-726(ra) # 80006706 <release>
}
    800039e4:	60e2                	ld	ra,24(sp)
    800039e6:	6442                	ld	s0,16(sp)
    800039e8:	64a2                	ld	s1,8(sp)
    800039ea:	6902                	ld	s2,0(sp)
    800039ec:	6105                	addi	sp,sp,32
    800039ee:	8082                	ret

00000000800039f0 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800039f0:	1101                	addi	sp,sp,-32
    800039f2:	ec06                	sd	ra,24(sp)
    800039f4:	e822                	sd	s0,16(sp)
    800039f6:	e426                	sd	s1,8(sp)
    800039f8:	e04a                	sd	s2,0(sp)
    800039fa:	1000                	addi	s0,sp,32
    800039fc:	84aa                	mv	s1,a0
    800039fe:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003a00:	00005597          	auipc	a1,0x5
    80003a04:	bf058593          	addi	a1,a1,-1040 # 800085f0 <syscalls+0x228>
    80003a08:	0521                	addi	a0,a0,8
    80003a0a:	00003097          	auipc	ra,0x3
    80003a0e:	da8080e7          	jalr	-600(ra) # 800067b2 <initlock>
  lk->name = name;
    80003a12:	0324b423          	sd	s2,40(s1)
  lk->locked = 0;
    80003a16:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003a1a:	0204a823          	sw	zero,48(s1)
}
    80003a1e:	60e2                	ld	ra,24(sp)
    80003a20:	6442                	ld	s0,16(sp)
    80003a22:	64a2                	ld	s1,8(sp)
    80003a24:	6902                	ld	s2,0(sp)
    80003a26:	6105                	addi	sp,sp,32
    80003a28:	8082                	ret

0000000080003a2a <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003a2a:	1101                	addi	sp,sp,-32
    80003a2c:	ec06                	sd	ra,24(sp)
    80003a2e:	e822                	sd	s0,16(sp)
    80003a30:	e426                	sd	s1,8(sp)
    80003a32:	e04a                	sd	s2,0(sp)
    80003a34:	1000                	addi	s0,sp,32
    80003a36:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003a38:	00850913          	addi	s2,a0,8
    80003a3c:	854a                	mv	a0,s2
    80003a3e:	00003097          	auipc	ra,0x3
    80003a42:	bf8080e7          	jalr	-1032(ra) # 80006636 <acquire>
  while (lk->locked) {
    80003a46:	409c                	lw	a5,0(s1)
    80003a48:	cb89                	beqz	a5,80003a5a <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003a4a:	85ca                	mv	a1,s2
    80003a4c:	8526                	mv	a0,s1
    80003a4e:	ffffe097          	auipc	ra,0xffffe
    80003a52:	bce080e7          	jalr	-1074(ra) # 8000161c <sleep>
  while (lk->locked) {
    80003a56:	409c                	lw	a5,0(s1)
    80003a58:	fbed                	bnez	a5,80003a4a <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003a5a:	4785                	li	a5,1
    80003a5c:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003a5e:	ffffd097          	auipc	ra,0xffffd
    80003a62:	4fa080e7          	jalr	1274(ra) # 80000f58 <myproc>
    80003a66:	5d1c                	lw	a5,56(a0)
    80003a68:	d89c                	sw	a5,48(s1)
  release(&lk->lk);
    80003a6a:	854a                	mv	a0,s2
    80003a6c:	00003097          	auipc	ra,0x3
    80003a70:	c9a080e7          	jalr	-870(ra) # 80006706 <release>
}
    80003a74:	60e2                	ld	ra,24(sp)
    80003a76:	6442                	ld	s0,16(sp)
    80003a78:	64a2                	ld	s1,8(sp)
    80003a7a:	6902                	ld	s2,0(sp)
    80003a7c:	6105                	addi	sp,sp,32
    80003a7e:	8082                	ret

0000000080003a80 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003a80:	1101                	addi	sp,sp,-32
    80003a82:	ec06                	sd	ra,24(sp)
    80003a84:	e822                	sd	s0,16(sp)
    80003a86:	e426                	sd	s1,8(sp)
    80003a88:	e04a                	sd	s2,0(sp)
    80003a8a:	1000                	addi	s0,sp,32
    80003a8c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003a8e:	00850913          	addi	s2,a0,8
    80003a92:	854a                	mv	a0,s2
    80003a94:	00003097          	auipc	ra,0x3
    80003a98:	ba2080e7          	jalr	-1118(ra) # 80006636 <acquire>
  lk->locked = 0;
    80003a9c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003aa0:	0204a823          	sw	zero,48(s1)
  wakeup(lk);
    80003aa4:	8526                	mv	a0,s1
    80003aa6:	ffffe097          	auipc	ra,0xffffe
    80003aaa:	d02080e7          	jalr	-766(ra) # 800017a8 <wakeup>
  release(&lk->lk);
    80003aae:	854a                	mv	a0,s2
    80003ab0:	00003097          	auipc	ra,0x3
    80003ab4:	c56080e7          	jalr	-938(ra) # 80006706 <release>
}
    80003ab8:	60e2                	ld	ra,24(sp)
    80003aba:	6442                	ld	s0,16(sp)
    80003abc:	64a2                	ld	s1,8(sp)
    80003abe:	6902                	ld	s2,0(sp)
    80003ac0:	6105                	addi	sp,sp,32
    80003ac2:	8082                	ret

0000000080003ac4 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003ac4:	7179                	addi	sp,sp,-48
    80003ac6:	f406                	sd	ra,40(sp)
    80003ac8:	f022                	sd	s0,32(sp)
    80003aca:	ec26                	sd	s1,24(sp)
    80003acc:	e84a                	sd	s2,16(sp)
    80003ace:	e44e                	sd	s3,8(sp)
    80003ad0:	1800                	addi	s0,sp,48
    80003ad2:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003ad4:	00850913          	addi	s2,a0,8
    80003ad8:	854a                	mv	a0,s2
    80003ada:	00003097          	auipc	ra,0x3
    80003ade:	b5c080e7          	jalr	-1188(ra) # 80006636 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003ae2:	409c                	lw	a5,0(s1)
    80003ae4:	ef99                	bnez	a5,80003b02 <holdingsleep+0x3e>
    80003ae6:	4481                	li	s1,0
  release(&lk->lk);
    80003ae8:	854a                	mv	a0,s2
    80003aea:	00003097          	auipc	ra,0x3
    80003aee:	c1c080e7          	jalr	-996(ra) # 80006706 <release>
  return r;
}
    80003af2:	8526                	mv	a0,s1
    80003af4:	70a2                	ld	ra,40(sp)
    80003af6:	7402                	ld	s0,32(sp)
    80003af8:	64e2                	ld	s1,24(sp)
    80003afa:	6942                	ld	s2,16(sp)
    80003afc:	69a2                	ld	s3,8(sp)
    80003afe:	6145                	addi	sp,sp,48
    80003b00:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003b02:	0304a983          	lw	s3,48(s1)
    80003b06:	ffffd097          	auipc	ra,0xffffd
    80003b0a:	452080e7          	jalr	1106(ra) # 80000f58 <myproc>
    80003b0e:	5d04                	lw	s1,56(a0)
    80003b10:	413484b3          	sub	s1,s1,s3
    80003b14:	0014b493          	seqz	s1,s1
    80003b18:	bfc1                	j	80003ae8 <holdingsleep+0x24>

0000000080003b1a <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003b1a:	1141                	addi	sp,sp,-16
    80003b1c:	e406                	sd	ra,8(sp)
    80003b1e:	e022                	sd	s0,0(sp)
    80003b20:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003b22:	00005597          	auipc	a1,0x5
    80003b26:	ade58593          	addi	a1,a1,-1314 # 80008600 <syscalls+0x238>
    80003b2a:	00019517          	auipc	a0,0x19
    80003b2e:	21650513          	addi	a0,a0,534 # 8001cd40 <ftable>
    80003b32:	00003097          	auipc	ra,0x3
    80003b36:	c80080e7          	jalr	-896(ra) # 800067b2 <initlock>
}
    80003b3a:	60a2                	ld	ra,8(sp)
    80003b3c:	6402                	ld	s0,0(sp)
    80003b3e:	0141                	addi	sp,sp,16
    80003b40:	8082                	ret

0000000080003b42 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003b42:	1101                	addi	sp,sp,-32
    80003b44:	ec06                	sd	ra,24(sp)
    80003b46:	e822                	sd	s0,16(sp)
    80003b48:	e426                	sd	s1,8(sp)
    80003b4a:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003b4c:	00019517          	auipc	a0,0x19
    80003b50:	1f450513          	addi	a0,a0,500 # 8001cd40 <ftable>
    80003b54:	00003097          	auipc	ra,0x3
    80003b58:	ae2080e7          	jalr	-1310(ra) # 80006636 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b5c:	00019497          	auipc	s1,0x19
    80003b60:	20448493          	addi	s1,s1,516 # 8001cd60 <ftable+0x20>
    80003b64:	0001a717          	auipc	a4,0x1a
    80003b68:	19c70713          	addi	a4,a4,412 # 8001dd00 <ftable+0xfc0>
    if(f->ref == 0){
    80003b6c:	40dc                	lw	a5,4(s1)
    80003b6e:	cf99                	beqz	a5,80003b8c <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b70:	02848493          	addi	s1,s1,40
    80003b74:	fee49ce3          	bne	s1,a4,80003b6c <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003b78:	00019517          	auipc	a0,0x19
    80003b7c:	1c850513          	addi	a0,a0,456 # 8001cd40 <ftable>
    80003b80:	00003097          	auipc	ra,0x3
    80003b84:	b86080e7          	jalr	-1146(ra) # 80006706 <release>
  return 0;
    80003b88:	4481                	li	s1,0
    80003b8a:	a819                	j	80003ba0 <filealloc+0x5e>
      f->ref = 1;
    80003b8c:	4785                	li	a5,1
    80003b8e:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003b90:	00019517          	auipc	a0,0x19
    80003b94:	1b050513          	addi	a0,a0,432 # 8001cd40 <ftable>
    80003b98:	00003097          	auipc	ra,0x3
    80003b9c:	b6e080e7          	jalr	-1170(ra) # 80006706 <release>
}
    80003ba0:	8526                	mv	a0,s1
    80003ba2:	60e2                	ld	ra,24(sp)
    80003ba4:	6442                	ld	s0,16(sp)
    80003ba6:	64a2                	ld	s1,8(sp)
    80003ba8:	6105                	addi	sp,sp,32
    80003baa:	8082                	ret

0000000080003bac <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003bac:	1101                	addi	sp,sp,-32
    80003bae:	ec06                	sd	ra,24(sp)
    80003bb0:	e822                	sd	s0,16(sp)
    80003bb2:	e426                	sd	s1,8(sp)
    80003bb4:	1000                	addi	s0,sp,32
    80003bb6:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003bb8:	00019517          	auipc	a0,0x19
    80003bbc:	18850513          	addi	a0,a0,392 # 8001cd40 <ftable>
    80003bc0:	00003097          	auipc	ra,0x3
    80003bc4:	a76080e7          	jalr	-1418(ra) # 80006636 <acquire>
  if(f->ref < 1)
    80003bc8:	40dc                	lw	a5,4(s1)
    80003bca:	02f05263          	blez	a5,80003bee <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003bce:	2785                	addiw	a5,a5,1
    80003bd0:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003bd2:	00019517          	auipc	a0,0x19
    80003bd6:	16e50513          	addi	a0,a0,366 # 8001cd40 <ftable>
    80003bda:	00003097          	auipc	ra,0x3
    80003bde:	b2c080e7          	jalr	-1236(ra) # 80006706 <release>
  return f;
}
    80003be2:	8526                	mv	a0,s1
    80003be4:	60e2                	ld	ra,24(sp)
    80003be6:	6442                	ld	s0,16(sp)
    80003be8:	64a2                	ld	s1,8(sp)
    80003bea:	6105                	addi	sp,sp,32
    80003bec:	8082                	ret
    panic("filedup");
    80003bee:	00005517          	auipc	a0,0x5
    80003bf2:	a1a50513          	addi	a0,a0,-1510 # 80008608 <syscalls+0x240>
    80003bf6:	00002097          	auipc	ra,0x2
    80003bfa:	51e080e7          	jalr	1310(ra) # 80006114 <panic>

0000000080003bfe <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003bfe:	7139                	addi	sp,sp,-64
    80003c00:	fc06                	sd	ra,56(sp)
    80003c02:	f822                	sd	s0,48(sp)
    80003c04:	f426                	sd	s1,40(sp)
    80003c06:	f04a                	sd	s2,32(sp)
    80003c08:	ec4e                	sd	s3,24(sp)
    80003c0a:	e852                	sd	s4,16(sp)
    80003c0c:	e456                	sd	s5,8(sp)
    80003c0e:	0080                	addi	s0,sp,64
    80003c10:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003c12:	00019517          	auipc	a0,0x19
    80003c16:	12e50513          	addi	a0,a0,302 # 8001cd40 <ftable>
    80003c1a:	00003097          	auipc	ra,0x3
    80003c1e:	a1c080e7          	jalr	-1508(ra) # 80006636 <acquire>
  if(f->ref < 1)
    80003c22:	40dc                	lw	a5,4(s1)
    80003c24:	06f05163          	blez	a5,80003c86 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003c28:	37fd                	addiw	a5,a5,-1
    80003c2a:	0007871b          	sext.w	a4,a5
    80003c2e:	c0dc                	sw	a5,4(s1)
    80003c30:	06e04363          	bgtz	a4,80003c96 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003c34:	0004a903          	lw	s2,0(s1)
    80003c38:	0094ca83          	lbu	s5,9(s1)
    80003c3c:	0104ba03          	ld	s4,16(s1)
    80003c40:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003c44:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003c48:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003c4c:	00019517          	auipc	a0,0x19
    80003c50:	0f450513          	addi	a0,a0,244 # 8001cd40 <ftable>
    80003c54:	00003097          	auipc	ra,0x3
    80003c58:	ab2080e7          	jalr	-1358(ra) # 80006706 <release>

  if(ff.type == FD_PIPE){
    80003c5c:	4785                	li	a5,1
    80003c5e:	04f90d63          	beq	s2,a5,80003cb8 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003c62:	3979                	addiw	s2,s2,-2
    80003c64:	4785                	li	a5,1
    80003c66:	0527e063          	bltu	a5,s2,80003ca6 <fileclose+0xa8>
    begin_op();
    80003c6a:	00000097          	auipc	ra,0x0
    80003c6e:	acc080e7          	jalr	-1332(ra) # 80003736 <begin_op>
    iput(ff.ip);
    80003c72:	854e                	mv	a0,s3
    80003c74:	fffff097          	auipc	ra,0xfffff
    80003c78:	2a0080e7          	jalr	672(ra) # 80002f14 <iput>
    end_op();
    80003c7c:	00000097          	auipc	ra,0x0
    80003c80:	b38080e7          	jalr	-1224(ra) # 800037b4 <end_op>
    80003c84:	a00d                	j	80003ca6 <fileclose+0xa8>
    panic("fileclose");
    80003c86:	00005517          	auipc	a0,0x5
    80003c8a:	98a50513          	addi	a0,a0,-1654 # 80008610 <syscalls+0x248>
    80003c8e:	00002097          	auipc	ra,0x2
    80003c92:	486080e7          	jalr	1158(ra) # 80006114 <panic>
    release(&ftable.lock);
    80003c96:	00019517          	auipc	a0,0x19
    80003c9a:	0aa50513          	addi	a0,a0,170 # 8001cd40 <ftable>
    80003c9e:	00003097          	auipc	ra,0x3
    80003ca2:	a68080e7          	jalr	-1432(ra) # 80006706 <release>
  }
}
    80003ca6:	70e2                	ld	ra,56(sp)
    80003ca8:	7442                	ld	s0,48(sp)
    80003caa:	74a2                	ld	s1,40(sp)
    80003cac:	7902                	ld	s2,32(sp)
    80003cae:	69e2                	ld	s3,24(sp)
    80003cb0:	6a42                	ld	s4,16(sp)
    80003cb2:	6aa2                	ld	s5,8(sp)
    80003cb4:	6121                	addi	sp,sp,64
    80003cb6:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003cb8:	85d6                	mv	a1,s5
    80003cba:	8552                	mv	a0,s4
    80003cbc:	00000097          	auipc	ra,0x0
    80003cc0:	34c080e7          	jalr	844(ra) # 80004008 <pipeclose>
    80003cc4:	b7cd                	j	80003ca6 <fileclose+0xa8>

0000000080003cc6 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003cc6:	715d                	addi	sp,sp,-80
    80003cc8:	e486                	sd	ra,72(sp)
    80003cca:	e0a2                	sd	s0,64(sp)
    80003ccc:	fc26                	sd	s1,56(sp)
    80003cce:	f84a                	sd	s2,48(sp)
    80003cd0:	f44e                	sd	s3,40(sp)
    80003cd2:	0880                	addi	s0,sp,80
    80003cd4:	84aa                	mv	s1,a0
    80003cd6:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003cd8:	ffffd097          	auipc	ra,0xffffd
    80003cdc:	280080e7          	jalr	640(ra) # 80000f58 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003ce0:	409c                	lw	a5,0(s1)
    80003ce2:	37f9                	addiw	a5,a5,-2
    80003ce4:	4705                	li	a4,1
    80003ce6:	04f76763          	bltu	a4,a5,80003d34 <filestat+0x6e>
    80003cea:	892a                	mv	s2,a0
    ilock(f->ip);
    80003cec:	6c88                	ld	a0,24(s1)
    80003cee:	fffff097          	auipc	ra,0xfffff
    80003cf2:	06c080e7          	jalr	108(ra) # 80002d5a <ilock>
    stati(f->ip, &st);
    80003cf6:	fb840593          	addi	a1,s0,-72
    80003cfa:	6c88                	ld	a0,24(s1)
    80003cfc:	fffff097          	auipc	ra,0xfffff
    80003d00:	2e8080e7          	jalr	744(ra) # 80002fe4 <stati>
    iunlock(f->ip);
    80003d04:	6c88                	ld	a0,24(s1)
    80003d06:	fffff097          	auipc	ra,0xfffff
    80003d0a:	116080e7          	jalr	278(ra) # 80002e1c <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003d0e:	46e1                	li	a3,24
    80003d10:	fb840613          	addi	a2,s0,-72
    80003d14:	85ce                	mv	a1,s3
    80003d16:	05893503          	ld	a0,88(s2)
    80003d1a:	ffffd097          	auipc	ra,0xffffd
    80003d1e:	f02080e7          	jalr	-254(ra) # 80000c1c <copyout>
    80003d22:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003d26:	60a6                	ld	ra,72(sp)
    80003d28:	6406                	ld	s0,64(sp)
    80003d2a:	74e2                	ld	s1,56(sp)
    80003d2c:	7942                	ld	s2,48(sp)
    80003d2e:	79a2                	ld	s3,40(sp)
    80003d30:	6161                	addi	sp,sp,80
    80003d32:	8082                	ret
  return -1;
    80003d34:	557d                	li	a0,-1
    80003d36:	bfc5                	j	80003d26 <filestat+0x60>

0000000080003d38 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003d38:	7179                	addi	sp,sp,-48
    80003d3a:	f406                	sd	ra,40(sp)
    80003d3c:	f022                	sd	s0,32(sp)
    80003d3e:	ec26                	sd	s1,24(sp)
    80003d40:	e84a                	sd	s2,16(sp)
    80003d42:	e44e                	sd	s3,8(sp)
    80003d44:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003d46:	00854783          	lbu	a5,8(a0)
    80003d4a:	c3d5                	beqz	a5,80003dee <fileread+0xb6>
    80003d4c:	84aa                	mv	s1,a0
    80003d4e:	89ae                	mv	s3,a1
    80003d50:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d52:	411c                	lw	a5,0(a0)
    80003d54:	4705                	li	a4,1
    80003d56:	04e78963          	beq	a5,a4,80003da8 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d5a:	470d                	li	a4,3
    80003d5c:	04e78d63          	beq	a5,a4,80003db6 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d60:	4709                	li	a4,2
    80003d62:	06e79e63          	bne	a5,a4,80003dde <fileread+0xa6>
    ilock(f->ip);
    80003d66:	6d08                	ld	a0,24(a0)
    80003d68:	fffff097          	auipc	ra,0xfffff
    80003d6c:	ff2080e7          	jalr	-14(ra) # 80002d5a <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003d70:	874a                	mv	a4,s2
    80003d72:	5094                	lw	a3,32(s1)
    80003d74:	864e                	mv	a2,s3
    80003d76:	4585                	li	a1,1
    80003d78:	6c88                	ld	a0,24(s1)
    80003d7a:	fffff097          	auipc	ra,0xfffff
    80003d7e:	294080e7          	jalr	660(ra) # 8000300e <readi>
    80003d82:	892a                	mv	s2,a0
    80003d84:	00a05563          	blez	a0,80003d8e <fileread+0x56>
      f->off += r;
    80003d88:	509c                	lw	a5,32(s1)
    80003d8a:	9fa9                	addw	a5,a5,a0
    80003d8c:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003d8e:	6c88                	ld	a0,24(s1)
    80003d90:	fffff097          	auipc	ra,0xfffff
    80003d94:	08c080e7          	jalr	140(ra) # 80002e1c <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003d98:	854a                	mv	a0,s2
    80003d9a:	70a2                	ld	ra,40(sp)
    80003d9c:	7402                	ld	s0,32(sp)
    80003d9e:	64e2                	ld	s1,24(sp)
    80003da0:	6942                	ld	s2,16(sp)
    80003da2:	69a2                	ld	s3,8(sp)
    80003da4:	6145                	addi	sp,sp,48
    80003da6:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003da8:	6908                	ld	a0,16(a0)
    80003daa:	00000097          	auipc	ra,0x0
    80003dae:	3ca080e7          	jalr	970(ra) # 80004174 <piperead>
    80003db2:	892a                	mv	s2,a0
    80003db4:	b7d5                	j	80003d98 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003db6:	02451783          	lh	a5,36(a0)
    80003dba:	03079693          	slli	a3,a5,0x30
    80003dbe:	92c1                	srli	a3,a3,0x30
    80003dc0:	4725                	li	a4,9
    80003dc2:	02d76863          	bltu	a4,a3,80003df2 <fileread+0xba>
    80003dc6:	0792                	slli	a5,a5,0x4
    80003dc8:	00019717          	auipc	a4,0x19
    80003dcc:	ed870713          	addi	a4,a4,-296 # 8001cca0 <devsw>
    80003dd0:	97ba                	add	a5,a5,a4
    80003dd2:	639c                	ld	a5,0(a5)
    80003dd4:	c38d                	beqz	a5,80003df6 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003dd6:	4505                	li	a0,1
    80003dd8:	9782                	jalr	a5
    80003dda:	892a                	mv	s2,a0
    80003ddc:	bf75                	j	80003d98 <fileread+0x60>
    panic("fileread");
    80003dde:	00005517          	auipc	a0,0x5
    80003de2:	84250513          	addi	a0,a0,-1982 # 80008620 <syscalls+0x258>
    80003de6:	00002097          	auipc	ra,0x2
    80003dea:	32e080e7          	jalr	814(ra) # 80006114 <panic>
    return -1;
    80003dee:	597d                	li	s2,-1
    80003df0:	b765                	j	80003d98 <fileread+0x60>
      return -1;
    80003df2:	597d                	li	s2,-1
    80003df4:	b755                	j	80003d98 <fileread+0x60>
    80003df6:	597d                	li	s2,-1
    80003df8:	b745                	j	80003d98 <fileread+0x60>

0000000080003dfa <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003dfa:	715d                	addi	sp,sp,-80
    80003dfc:	e486                	sd	ra,72(sp)
    80003dfe:	e0a2                	sd	s0,64(sp)
    80003e00:	fc26                	sd	s1,56(sp)
    80003e02:	f84a                	sd	s2,48(sp)
    80003e04:	f44e                	sd	s3,40(sp)
    80003e06:	f052                	sd	s4,32(sp)
    80003e08:	ec56                	sd	s5,24(sp)
    80003e0a:	e85a                	sd	s6,16(sp)
    80003e0c:	e45e                	sd	s7,8(sp)
    80003e0e:	e062                	sd	s8,0(sp)
    80003e10:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003e12:	00954783          	lbu	a5,9(a0)
    80003e16:	10078663          	beqz	a5,80003f22 <filewrite+0x128>
    80003e1a:	892a                	mv	s2,a0
    80003e1c:	8b2e                	mv	s6,a1
    80003e1e:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003e20:	411c                	lw	a5,0(a0)
    80003e22:	4705                	li	a4,1
    80003e24:	02e78263          	beq	a5,a4,80003e48 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003e28:	470d                	li	a4,3
    80003e2a:	02e78663          	beq	a5,a4,80003e56 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003e2e:	4709                	li	a4,2
    80003e30:	0ee79163          	bne	a5,a4,80003f12 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003e34:	0ac05d63          	blez	a2,80003eee <filewrite+0xf4>
    int i = 0;
    80003e38:	4981                	li	s3,0
    80003e3a:	6b85                	lui	s7,0x1
    80003e3c:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003e40:	6c05                	lui	s8,0x1
    80003e42:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003e46:	a861                	j	80003ede <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003e48:	6908                	ld	a0,16(a0)
    80003e4a:	00000097          	auipc	ra,0x0
    80003e4e:	238080e7          	jalr	568(ra) # 80004082 <pipewrite>
    80003e52:	8a2a                	mv	s4,a0
    80003e54:	a045                	j	80003ef4 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003e56:	02451783          	lh	a5,36(a0)
    80003e5a:	03079693          	slli	a3,a5,0x30
    80003e5e:	92c1                	srli	a3,a3,0x30
    80003e60:	4725                	li	a4,9
    80003e62:	0cd76263          	bltu	a4,a3,80003f26 <filewrite+0x12c>
    80003e66:	0792                	slli	a5,a5,0x4
    80003e68:	00019717          	auipc	a4,0x19
    80003e6c:	e3870713          	addi	a4,a4,-456 # 8001cca0 <devsw>
    80003e70:	97ba                	add	a5,a5,a4
    80003e72:	679c                	ld	a5,8(a5)
    80003e74:	cbdd                	beqz	a5,80003f2a <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003e76:	4505                	li	a0,1
    80003e78:	9782                	jalr	a5
    80003e7a:	8a2a                	mv	s4,a0
    80003e7c:	a8a5                	j	80003ef4 <filewrite+0xfa>
    80003e7e:	00048a9b          	sext.w	s5,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003e82:	00000097          	auipc	ra,0x0
    80003e86:	8b4080e7          	jalr	-1868(ra) # 80003736 <begin_op>
      ilock(f->ip);
    80003e8a:	01893503          	ld	a0,24(s2)
    80003e8e:	fffff097          	auipc	ra,0xfffff
    80003e92:	ecc080e7          	jalr	-308(ra) # 80002d5a <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003e96:	8756                	mv	a4,s5
    80003e98:	02092683          	lw	a3,32(s2)
    80003e9c:	01698633          	add	a2,s3,s6
    80003ea0:	4585                	li	a1,1
    80003ea2:	01893503          	ld	a0,24(s2)
    80003ea6:	fffff097          	auipc	ra,0xfffff
    80003eaa:	260080e7          	jalr	608(ra) # 80003106 <writei>
    80003eae:	84aa                	mv	s1,a0
    80003eb0:	00a05763          	blez	a0,80003ebe <filewrite+0xc4>
        f->off += r;
    80003eb4:	02092783          	lw	a5,32(s2)
    80003eb8:	9fa9                	addw	a5,a5,a0
    80003eba:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003ebe:	01893503          	ld	a0,24(s2)
    80003ec2:	fffff097          	auipc	ra,0xfffff
    80003ec6:	f5a080e7          	jalr	-166(ra) # 80002e1c <iunlock>
      end_op();
    80003eca:	00000097          	auipc	ra,0x0
    80003ece:	8ea080e7          	jalr	-1814(ra) # 800037b4 <end_op>

      if(r != n1){
    80003ed2:	009a9f63          	bne	s5,s1,80003ef0 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003ed6:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003eda:	0149db63          	bge	s3,s4,80003ef0 <filewrite+0xf6>
      int n1 = n - i;
    80003ede:	413a04bb          	subw	s1,s4,s3
    80003ee2:	0004879b          	sext.w	a5,s1
    80003ee6:	f8fbdce3          	bge	s7,a5,80003e7e <filewrite+0x84>
    80003eea:	84e2                	mv	s1,s8
    80003eec:	bf49                	j	80003e7e <filewrite+0x84>
    int i = 0;
    80003eee:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003ef0:	013a1f63          	bne	s4,s3,80003f0e <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003ef4:	8552                	mv	a0,s4
    80003ef6:	60a6                	ld	ra,72(sp)
    80003ef8:	6406                	ld	s0,64(sp)
    80003efa:	74e2                	ld	s1,56(sp)
    80003efc:	7942                	ld	s2,48(sp)
    80003efe:	79a2                	ld	s3,40(sp)
    80003f00:	7a02                	ld	s4,32(sp)
    80003f02:	6ae2                	ld	s5,24(sp)
    80003f04:	6b42                	ld	s6,16(sp)
    80003f06:	6ba2                	ld	s7,8(sp)
    80003f08:	6c02                	ld	s8,0(sp)
    80003f0a:	6161                	addi	sp,sp,80
    80003f0c:	8082                	ret
    ret = (i == n ? n : -1);
    80003f0e:	5a7d                	li	s4,-1
    80003f10:	b7d5                	j	80003ef4 <filewrite+0xfa>
    panic("filewrite");
    80003f12:	00004517          	auipc	a0,0x4
    80003f16:	71e50513          	addi	a0,a0,1822 # 80008630 <syscalls+0x268>
    80003f1a:	00002097          	auipc	ra,0x2
    80003f1e:	1fa080e7          	jalr	506(ra) # 80006114 <panic>
    return -1;
    80003f22:	5a7d                	li	s4,-1
    80003f24:	bfc1                	j	80003ef4 <filewrite+0xfa>
      return -1;
    80003f26:	5a7d                	li	s4,-1
    80003f28:	b7f1                	j	80003ef4 <filewrite+0xfa>
    80003f2a:	5a7d                	li	s4,-1
    80003f2c:	b7e1                	j	80003ef4 <filewrite+0xfa>

0000000080003f2e <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003f2e:	7179                	addi	sp,sp,-48
    80003f30:	f406                	sd	ra,40(sp)
    80003f32:	f022                	sd	s0,32(sp)
    80003f34:	ec26                	sd	s1,24(sp)
    80003f36:	e84a                	sd	s2,16(sp)
    80003f38:	e44e                	sd	s3,8(sp)
    80003f3a:	e052                	sd	s4,0(sp)
    80003f3c:	1800                	addi	s0,sp,48
    80003f3e:	84aa                	mv	s1,a0
    80003f40:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003f42:	0005b023          	sd	zero,0(a1)
    80003f46:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003f4a:	00000097          	auipc	ra,0x0
    80003f4e:	bf8080e7          	jalr	-1032(ra) # 80003b42 <filealloc>
    80003f52:	e088                	sd	a0,0(s1)
    80003f54:	c551                	beqz	a0,80003fe0 <pipealloc+0xb2>
    80003f56:	00000097          	auipc	ra,0x0
    80003f5a:	bec080e7          	jalr	-1044(ra) # 80003b42 <filealloc>
    80003f5e:	00aa3023          	sd	a0,0(s4)
    80003f62:	c92d                	beqz	a0,80003fd4 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003f64:	ffffc097          	auipc	ra,0xffffc
    80003f68:	212080e7          	jalr	530(ra) # 80000176 <kalloc>
    80003f6c:	892a                	mv	s2,a0
    80003f6e:	c125                	beqz	a0,80003fce <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003f70:	4985                	li	s3,1
    80003f72:	23352423          	sw	s3,552(a0)
  pi->writeopen = 1;
    80003f76:	23352623          	sw	s3,556(a0)
  pi->nwrite = 0;
    80003f7a:	22052223          	sw	zero,548(a0)
  pi->nread = 0;
    80003f7e:	22052023          	sw	zero,544(a0)
  initlock(&pi->lock, "pipe");
    80003f82:	00004597          	auipc	a1,0x4
    80003f86:	6be58593          	addi	a1,a1,1726 # 80008640 <syscalls+0x278>
    80003f8a:	00003097          	auipc	ra,0x3
    80003f8e:	828080e7          	jalr	-2008(ra) # 800067b2 <initlock>
  (*f0)->type = FD_PIPE;
    80003f92:	609c                	ld	a5,0(s1)
    80003f94:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003f98:	609c                	ld	a5,0(s1)
    80003f9a:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003f9e:	609c                	ld	a5,0(s1)
    80003fa0:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003fa4:	609c                	ld	a5,0(s1)
    80003fa6:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003faa:	000a3783          	ld	a5,0(s4)
    80003fae:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003fb2:	000a3783          	ld	a5,0(s4)
    80003fb6:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003fba:	000a3783          	ld	a5,0(s4)
    80003fbe:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003fc2:	000a3783          	ld	a5,0(s4)
    80003fc6:	0127b823          	sd	s2,16(a5)
  return 0;
    80003fca:	4501                	li	a0,0
    80003fcc:	a025                	j	80003ff4 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003fce:	6088                	ld	a0,0(s1)
    80003fd0:	e501                	bnez	a0,80003fd8 <pipealloc+0xaa>
    80003fd2:	a039                	j	80003fe0 <pipealloc+0xb2>
    80003fd4:	6088                	ld	a0,0(s1)
    80003fd6:	c51d                	beqz	a0,80004004 <pipealloc+0xd6>
    fileclose(*f0);
    80003fd8:	00000097          	auipc	ra,0x0
    80003fdc:	c26080e7          	jalr	-986(ra) # 80003bfe <fileclose>
  if(*f1)
    80003fe0:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003fe4:	557d                	li	a0,-1
  if(*f1)
    80003fe6:	c799                	beqz	a5,80003ff4 <pipealloc+0xc6>
    fileclose(*f1);
    80003fe8:	853e                	mv	a0,a5
    80003fea:	00000097          	auipc	ra,0x0
    80003fee:	c14080e7          	jalr	-1004(ra) # 80003bfe <fileclose>
  return -1;
    80003ff2:	557d                	li	a0,-1
}
    80003ff4:	70a2                	ld	ra,40(sp)
    80003ff6:	7402                	ld	s0,32(sp)
    80003ff8:	64e2                	ld	s1,24(sp)
    80003ffa:	6942                	ld	s2,16(sp)
    80003ffc:	69a2                	ld	s3,8(sp)
    80003ffe:	6a02                	ld	s4,0(sp)
    80004000:	6145                	addi	sp,sp,48
    80004002:	8082                	ret
  return -1;
    80004004:	557d                	li	a0,-1
    80004006:	b7fd                	j	80003ff4 <pipealloc+0xc6>

0000000080004008 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004008:	1101                	addi	sp,sp,-32
    8000400a:	ec06                	sd	ra,24(sp)
    8000400c:	e822                	sd	s0,16(sp)
    8000400e:	e426                	sd	s1,8(sp)
    80004010:	e04a                	sd	s2,0(sp)
    80004012:	1000                	addi	s0,sp,32
    80004014:	84aa                	mv	s1,a0
    80004016:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004018:	00002097          	auipc	ra,0x2
    8000401c:	61e080e7          	jalr	1566(ra) # 80006636 <acquire>
  if(writable){
    80004020:	04090263          	beqz	s2,80004064 <pipeclose+0x5c>
    pi->writeopen = 0;
    80004024:	2204a623          	sw	zero,556(s1)
    wakeup(&pi->nread);
    80004028:	22048513          	addi	a0,s1,544
    8000402c:	ffffd097          	auipc	ra,0xffffd
    80004030:	77c080e7          	jalr	1916(ra) # 800017a8 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004034:	2284b783          	ld	a5,552(s1)
    80004038:	ef9d                	bnez	a5,80004076 <pipeclose+0x6e>
    release(&pi->lock);
    8000403a:	8526                	mv	a0,s1
    8000403c:	00002097          	auipc	ra,0x2
    80004040:	6ca080e7          	jalr	1738(ra) # 80006706 <release>
#ifdef LAB_LOCK
    freelock(&pi->lock);
    80004044:	8526                	mv	a0,s1
    80004046:	00002097          	auipc	ra,0x2
    8000404a:	708080e7          	jalr	1800(ra) # 8000674e <freelock>
#endif    
    kfree((char*)pi);
    8000404e:	8526                	mv	a0,s1
    80004050:	ffffc097          	auipc	ra,0xffffc
    80004054:	fcc080e7          	jalr	-52(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80004058:	60e2                	ld	ra,24(sp)
    8000405a:	6442                	ld	s0,16(sp)
    8000405c:	64a2                	ld	s1,8(sp)
    8000405e:	6902                	ld	s2,0(sp)
    80004060:	6105                	addi	sp,sp,32
    80004062:	8082                	ret
    pi->readopen = 0;
    80004064:	2204a423          	sw	zero,552(s1)
    wakeup(&pi->nwrite);
    80004068:	22448513          	addi	a0,s1,548
    8000406c:	ffffd097          	auipc	ra,0xffffd
    80004070:	73c080e7          	jalr	1852(ra) # 800017a8 <wakeup>
    80004074:	b7c1                	j	80004034 <pipeclose+0x2c>
    release(&pi->lock);
    80004076:	8526                	mv	a0,s1
    80004078:	00002097          	auipc	ra,0x2
    8000407c:	68e080e7          	jalr	1678(ra) # 80006706 <release>
}
    80004080:	bfe1                	j	80004058 <pipeclose+0x50>

0000000080004082 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004082:	711d                	addi	sp,sp,-96
    80004084:	ec86                	sd	ra,88(sp)
    80004086:	e8a2                	sd	s0,80(sp)
    80004088:	e4a6                	sd	s1,72(sp)
    8000408a:	e0ca                	sd	s2,64(sp)
    8000408c:	fc4e                	sd	s3,56(sp)
    8000408e:	f852                	sd	s4,48(sp)
    80004090:	f456                	sd	s5,40(sp)
    80004092:	f05a                	sd	s6,32(sp)
    80004094:	ec5e                	sd	s7,24(sp)
    80004096:	e862                	sd	s8,16(sp)
    80004098:	1080                	addi	s0,sp,96
    8000409a:	84aa                	mv	s1,a0
    8000409c:	8aae                	mv	s5,a1
    8000409e:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800040a0:	ffffd097          	auipc	ra,0xffffd
    800040a4:	eb8080e7          	jalr	-328(ra) # 80000f58 <myproc>
    800040a8:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800040aa:	8526                	mv	a0,s1
    800040ac:	00002097          	auipc	ra,0x2
    800040b0:	58a080e7          	jalr	1418(ra) # 80006636 <acquire>
  while(i < n){
    800040b4:	0b405363          	blez	s4,8000415a <pipewrite+0xd8>
  int i = 0;
    800040b8:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800040ba:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800040bc:	22048c13          	addi	s8,s1,544
      sleep(&pi->nwrite, &pi->lock);
    800040c0:	22448b93          	addi	s7,s1,548
    800040c4:	a089                	j	80004106 <pipewrite+0x84>
      release(&pi->lock);
    800040c6:	8526                	mv	a0,s1
    800040c8:	00002097          	auipc	ra,0x2
    800040cc:	63e080e7          	jalr	1598(ra) # 80006706 <release>
      return -1;
    800040d0:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800040d2:	854a                	mv	a0,s2
    800040d4:	60e6                	ld	ra,88(sp)
    800040d6:	6446                	ld	s0,80(sp)
    800040d8:	64a6                	ld	s1,72(sp)
    800040da:	6906                	ld	s2,64(sp)
    800040dc:	79e2                	ld	s3,56(sp)
    800040de:	7a42                	ld	s4,48(sp)
    800040e0:	7aa2                	ld	s5,40(sp)
    800040e2:	7b02                	ld	s6,32(sp)
    800040e4:	6be2                	ld	s7,24(sp)
    800040e6:	6c42                	ld	s8,16(sp)
    800040e8:	6125                	addi	sp,sp,96
    800040ea:	8082                	ret
      wakeup(&pi->nread);
    800040ec:	8562                	mv	a0,s8
    800040ee:	ffffd097          	auipc	ra,0xffffd
    800040f2:	6ba080e7          	jalr	1722(ra) # 800017a8 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800040f6:	85a6                	mv	a1,s1
    800040f8:	855e                	mv	a0,s7
    800040fa:	ffffd097          	auipc	ra,0xffffd
    800040fe:	522080e7          	jalr	1314(ra) # 8000161c <sleep>
  while(i < n){
    80004102:	05495d63          	bge	s2,s4,8000415c <pipewrite+0xda>
    if(pi->readopen == 0 || pr->killed){
    80004106:	2284a783          	lw	a5,552(s1)
    8000410a:	dfd5                	beqz	a5,800040c6 <pipewrite+0x44>
    8000410c:	0309a783          	lw	a5,48(s3)
    80004110:	fbdd                	bnez	a5,800040c6 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004112:	2204a783          	lw	a5,544(s1)
    80004116:	2244a703          	lw	a4,548(s1)
    8000411a:	2007879b          	addiw	a5,a5,512
    8000411e:	fcf707e3          	beq	a4,a5,800040ec <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004122:	4685                	li	a3,1
    80004124:	01590633          	add	a2,s2,s5
    80004128:	faf40593          	addi	a1,s0,-81
    8000412c:	0589b503          	ld	a0,88(s3)
    80004130:	ffffd097          	auipc	ra,0xffffd
    80004134:	b78080e7          	jalr	-1160(ra) # 80000ca8 <copyin>
    80004138:	03650263          	beq	a0,s6,8000415c <pipewrite+0xda>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000413c:	2244a783          	lw	a5,548(s1)
    80004140:	0017871b          	addiw	a4,a5,1
    80004144:	22e4a223          	sw	a4,548(s1)
    80004148:	1ff7f793          	andi	a5,a5,511
    8000414c:	97a6                	add	a5,a5,s1
    8000414e:	faf44703          	lbu	a4,-81(s0)
    80004152:	02e78023          	sb	a4,32(a5)
      i++;
    80004156:	2905                	addiw	s2,s2,1
    80004158:	b76d                	j	80004102 <pipewrite+0x80>
  int i = 0;
    8000415a:	4901                	li	s2,0
  wakeup(&pi->nread);
    8000415c:	22048513          	addi	a0,s1,544
    80004160:	ffffd097          	auipc	ra,0xffffd
    80004164:	648080e7          	jalr	1608(ra) # 800017a8 <wakeup>
  release(&pi->lock);
    80004168:	8526                	mv	a0,s1
    8000416a:	00002097          	auipc	ra,0x2
    8000416e:	59c080e7          	jalr	1436(ra) # 80006706 <release>
  return i;
    80004172:	b785                	j	800040d2 <pipewrite+0x50>

0000000080004174 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004174:	715d                	addi	sp,sp,-80
    80004176:	e486                	sd	ra,72(sp)
    80004178:	e0a2                	sd	s0,64(sp)
    8000417a:	fc26                	sd	s1,56(sp)
    8000417c:	f84a                	sd	s2,48(sp)
    8000417e:	f44e                	sd	s3,40(sp)
    80004180:	f052                	sd	s4,32(sp)
    80004182:	ec56                	sd	s5,24(sp)
    80004184:	e85a                	sd	s6,16(sp)
    80004186:	0880                	addi	s0,sp,80
    80004188:	84aa                	mv	s1,a0
    8000418a:	892e                	mv	s2,a1
    8000418c:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000418e:	ffffd097          	auipc	ra,0xffffd
    80004192:	dca080e7          	jalr	-566(ra) # 80000f58 <myproc>
    80004196:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004198:	8526                	mv	a0,s1
    8000419a:	00002097          	auipc	ra,0x2
    8000419e:	49c080e7          	jalr	1180(ra) # 80006636 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800041a2:	2204a703          	lw	a4,544(s1)
    800041a6:	2244a783          	lw	a5,548(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800041aa:	22048993          	addi	s3,s1,544
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800041ae:	02f71463          	bne	a4,a5,800041d6 <piperead+0x62>
    800041b2:	22c4a783          	lw	a5,556(s1)
    800041b6:	c385                	beqz	a5,800041d6 <piperead+0x62>
    if(pr->killed){
    800041b8:	030a2783          	lw	a5,48(s4)
    800041bc:	ebc9                	bnez	a5,8000424e <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800041be:	85a6                	mv	a1,s1
    800041c0:	854e                	mv	a0,s3
    800041c2:	ffffd097          	auipc	ra,0xffffd
    800041c6:	45a080e7          	jalr	1114(ra) # 8000161c <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800041ca:	2204a703          	lw	a4,544(s1)
    800041ce:	2244a783          	lw	a5,548(s1)
    800041d2:	fef700e3          	beq	a4,a5,800041b2 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800041d6:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800041d8:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800041da:	05505463          	blez	s5,80004222 <piperead+0xae>
    if(pi->nread == pi->nwrite)
    800041de:	2204a783          	lw	a5,544(s1)
    800041e2:	2244a703          	lw	a4,548(s1)
    800041e6:	02f70e63          	beq	a4,a5,80004222 <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800041ea:	0017871b          	addiw	a4,a5,1
    800041ee:	22e4a023          	sw	a4,544(s1)
    800041f2:	1ff7f793          	andi	a5,a5,511
    800041f6:	97a6                	add	a5,a5,s1
    800041f8:	0207c783          	lbu	a5,32(a5)
    800041fc:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004200:	4685                	li	a3,1
    80004202:	fbf40613          	addi	a2,s0,-65
    80004206:	85ca                	mv	a1,s2
    80004208:	058a3503          	ld	a0,88(s4)
    8000420c:	ffffd097          	auipc	ra,0xffffd
    80004210:	a10080e7          	jalr	-1520(ra) # 80000c1c <copyout>
    80004214:	01650763          	beq	a0,s6,80004222 <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004218:	2985                	addiw	s3,s3,1
    8000421a:	0905                	addi	s2,s2,1
    8000421c:	fd3a91e3          	bne	s5,s3,800041de <piperead+0x6a>
    80004220:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004222:	22448513          	addi	a0,s1,548
    80004226:	ffffd097          	auipc	ra,0xffffd
    8000422a:	582080e7          	jalr	1410(ra) # 800017a8 <wakeup>
  release(&pi->lock);
    8000422e:	8526                	mv	a0,s1
    80004230:	00002097          	auipc	ra,0x2
    80004234:	4d6080e7          	jalr	1238(ra) # 80006706 <release>
  return i;
}
    80004238:	854e                	mv	a0,s3
    8000423a:	60a6                	ld	ra,72(sp)
    8000423c:	6406                	ld	s0,64(sp)
    8000423e:	74e2                	ld	s1,56(sp)
    80004240:	7942                	ld	s2,48(sp)
    80004242:	79a2                	ld	s3,40(sp)
    80004244:	7a02                	ld	s4,32(sp)
    80004246:	6ae2                	ld	s5,24(sp)
    80004248:	6b42                	ld	s6,16(sp)
    8000424a:	6161                	addi	sp,sp,80
    8000424c:	8082                	ret
      release(&pi->lock);
    8000424e:	8526                	mv	a0,s1
    80004250:	00002097          	auipc	ra,0x2
    80004254:	4b6080e7          	jalr	1206(ra) # 80006706 <release>
      return -1;
    80004258:	59fd                	li	s3,-1
    8000425a:	bff9                	j	80004238 <piperead+0xc4>

000000008000425c <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    8000425c:	de010113          	addi	sp,sp,-544
    80004260:	20113c23          	sd	ra,536(sp)
    80004264:	20813823          	sd	s0,528(sp)
    80004268:	20913423          	sd	s1,520(sp)
    8000426c:	21213023          	sd	s2,512(sp)
    80004270:	ffce                	sd	s3,504(sp)
    80004272:	fbd2                	sd	s4,496(sp)
    80004274:	f7d6                	sd	s5,488(sp)
    80004276:	f3da                	sd	s6,480(sp)
    80004278:	efde                	sd	s7,472(sp)
    8000427a:	ebe2                	sd	s8,464(sp)
    8000427c:	e7e6                	sd	s9,456(sp)
    8000427e:	e3ea                	sd	s10,448(sp)
    80004280:	ff6e                	sd	s11,440(sp)
    80004282:	1400                	addi	s0,sp,544
    80004284:	892a                	mv	s2,a0
    80004286:	dea43423          	sd	a0,-536(s0)
    8000428a:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000428e:	ffffd097          	auipc	ra,0xffffd
    80004292:	cca080e7          	jalr	-822(ra) # 80000f58 <myproc>
    80004296:	84aa                	mv	s1,a0

  begin_op();
    80004298:	fffff097          	auipc	ra,0xfffff
    8000429c:	49e080e7          	jalr	1182(ra) # 80003736 <begin_op>

  if((ip = namei(path)) == 0){
    800042a0:	854a                	mv	a0,s2
    800042a2:	fffff097          	auipc	ra,0xfffff
    800042a6:	274080e7          	jalr	628(ra) # 80003516 <namei>
    800042aa:	c93d                	beqz	a0,80004320 <exec+0xc4>
    800042ac:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800042ae:	fffff097          	auipc	ra,0xfffff
    800042b2:	aac080e7          	jalr	-1364(ra) # 80002d5a <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800042b6:	04000713          	li	a4,64
    800042ba:	4681                	li	a3,0
    800042bc:	e5040613          	addi	a2,s0,-432
    800042c0:	4581                	li	a1,0
    800042c2:	8556                	mv	a0,s5
    800042c4:	fffff097          	auipc	ra,0xfffff
    800042c8:	d4a080e7          	jalr	-694(ra) # 8000300e <readi>
    800042cc:	04000793          	li	a5,64
    800042d0:	00f51a63          	bne	a0,a5,800042e4 <exec+0x88>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    800042d4:	e5042703          	lw	a4,-432(s0)
    800042d8:	464c47b7          	lui	a5,0x464c4
    800042dc:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800042e0:	04f70663          	beq	a4,a5,8000432c <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800042e4:	8556                	mv	a0,s5
    800042e6:	fffff097          	auipc	ra,0xfffff
    800042ea:	cd6080e7          	jalr	-810(ra) # 80002fbc <iunlockput>
    end_op();
    800042ee:	fffff097          	auipc	ra,0xfffff
    800042f2:	4c6080e7          	jalr	1222(ra) # 800037b4 <end_op>
  }
  return -1;
    800042f6:	557d                	li	a0,-1
}
    800042f8:	21813083          	ld	ra,536(sp)
    800042fc:	21013403          	ld	s0,528(sp)
    80004300:	20813483          	ld	s1,520(sp)
    80004304:	20013903          	ld	s2,512(sp)
    80004308:	79fe                	ld	s3,504(sp)
    8000430a:	7a5e                	ld	s4,496(sp)
    8000430c:	7abe                	ld	s5,488(sp)
    8000430e:	7b1e                	ld	s6,480(sp)
    80004310:	6bfe                	ld	s7,472(sp)
    80004312:	6c5e                	ld	s8,464(sp)
    80004314:	6cbe                	ld	s9,456(sp)
    80004316:	6d1e                	ld	s10,448(sp)
    80004318:	7dfa                	ld	s11,440(sp)
    8000431a:	22010113          	addi	sp,sp,544
    8000431e:	8082                	ret
    end_op();
    80004320:	fffff097          	auipc	ra,0xfffff
    80004324:	494080e7          	jalr	1172(ra) # 800037b4 <end_op>
    return -1;
    80004328:	557d                	li	a0,-1
    8000432a:	b7f9                	j	800042f8 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    8000432c:	8526                	mv	a0,s1
    8000432e:	ffffd097          	auipc	ra,0xffffd
    80004332:	cee080e7          	jalr	-786(ra) # 8000101c <proc_pagetable>
    80004336:	8b2a                	mv	s6,a0
    80004338:	d555                	beqz	a0,800042e4 <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000433a:	e7042783          	lw	a5,-400(s0)
    8000433e:	e8845703          	lhu	a4,-376(s0)
    80004342:	c735                	beqz	a4,800043ae <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004344:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004346:	e0043423          	sd	zero,-504(s0)
    if((ph.vaddr % PGSIZE) != 0)
    8000434a:	6a05                	lui	s4,0x1
    8000434c:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    80004350:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    80004354:	6d85                	lui	s11,0x1
    80004356:	7d7d                	lui	s10,0xfffff
    80004358:	ac1d                	j	8000458e <exec+0x332>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    8000435a:	00004517          	auipc	a0,0x4
    8000435e:	2ee50513          	addi	a0,a0,750 # 80008648 <syscalls+0x280>
    80004362:	00002097          	auipc	ra,0x2
    80004366:	db2080e7          	jalr	-590(ra) # 80006114 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    8000436a:	874a                	mv	a4,s2
    8000436c:	009c86bb          	addw	a3,s9,s1
    80004370:	4581                	li	a1,0
    80004372:	8556                	mv	a0,s5
    80004374:	fffff097          	auipc	ra,0xfffff
    80004378:	c9a080e7          	jalr	-870(ra) # 8000300e <readi>
    8000437c:	2501                	sext.w	a0,a0
    8000437e:	1aa91863          	bne	s2,a0,8000452e <exec+0x2d2>
  for(i = 0; i < sz; i += PGSIZE){
    80004382:	009d84bb          	addw	s1,s11,s1
    80004386:	013d09bb          	addw	s3,s10,s3
    8000438a:	1f74f263          	bgeu	s1,s7,8000456e <exec+0x312>
    pa = walkaddr(pagetable, va + i);
    8000438e:	02049593          	slli	a1,s1,0x20
    80004392:	9181                	srli	a1,a1,0x20
    80004394:	95e2                	add	a1,a1,s8
    80004396:	855a                	mv	a0,s6
    80004398:	ffffc097          	auipc	ra,0xffffc
    8000439c:	27c080e7          	jalr	636(ra) # 80000614 <walkaddr>
    800043a0:	862a                	mv	a2,a0
    if(pa == 0)
    800043a2:	dd45                	beqz	a0,8000435a <exec+0xfe>
      n = PGSIZE;
    800043a4:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    800043a6:	fd49f2e3          	bgeu	s3,s4,8000436a <exec+0x10e>
      n = sz - i;
    800043aa:	894e                	mv	s2,s3
    800043ac:	bf7d                	j	8000436a <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800043ae:	4481                	li	s1,0
  iunlockput(ip);
    800043b0:	8556                	mv	a0,s5
    800043b2:	fffff097          	auipc	ra,0xfffff
    800043b6:	c0a080e7          	jalr	-1014(ra) # 80002fbc <iunlockput>
  end_op();
    800043ba:	fffff097          	auipc	ra,0xfffff
    800043be:	3fa080e7          	jalr	1018(ra) # 800037b4 <end_op>
  p = myproc();
    800043c2:	ffffd097          	auipc	ra,0xffffd
    800043c6:	b96080e7          	jalr	-1130(ra) # 80000f58 <myproc>
    800043ca:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    800043cc:	05053d03          	ld	s10,80(a0)
  sz = PGROUNDUP(sz);
    800043d0:	6785                	lui	a5,0x1
    800043d2:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800043d4:	97a6                	add	a5,a5,s1
    800043d6:	777d                	lui	a4,0xfffff
    800043d8:	8ff9                	and	a5,a5,a4
    800043da:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800043de:	6609                	lui	a2,0x2
    800043e0:	963e                	add	a2,a2,a5
    800043e2:	85be                	mv	a1,a5
    800043e4:	855a                	mv	a0,s6
    800043e6:	ffffc097          	auipc	ra,0xffffc
    800043ea:	5e2080e7          	jalr	1506(ra) # 800009c8 <uvmalloc>
    800043ee:	8c2a                	mv	s8,a0
  ip = 0;
    800043f0:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800043f2:	12050e63          	beqz	a0,8000452e <exec+0x2d2>
  uvmclear(pagetable, sz-2*PGSIZE);
    800043f6:	75f9                	lui	a1,0xffffe
    800043f8:	95aa                	add	a1,a1,a0
    800043fa:	855a                	mv	a0,s6
    800043fc:	ffffc097          	auipc	ra,0xffffc
    80004400:	7ee080e7          	jalr	2030(ra) # 80000bea <uvmclear>
  stackbase = sp - PGSIZE;
    80004404:	7afd                	lui	s5,0xfffff
    80004406:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    80004408:	df043783          	ld	a5,-528(s0)
    8000440c:	6388                	ld	a0,0(a5)
    8000440e:	c925                	beqz	a0,8000447e <exec+0x222>
    80004410:	e9040993          	addi	s3,s0,-368
    80004414:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004418:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    8000441a:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    8000441c:	ffffc097          	auipc	ra,0xffffc
    80004420:	fde080e7          	jalr	-34(ra) # 800003fa <strlen>
    80004424:	0015079b          	addiw	a5,a0,1
    80004428:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000442c:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80004430:	13596363          	bltu	s2,s5,80004556 <exec+0x2fa>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004434:	df043d83          	ld	s11,-528(s0)
    80004438:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    8000443c:	8552                	mv	a0,s4
    8000443e:	ffffc097          	auipc	ra,0xffffc
    80004442:	fbc080e7          	jalr	-68(ra) # 800003fa <strlen>
    80004446:	0015069b          	addiw	a3,a0,1
    8000444a:	8652                	mv	a2,s4
    8000444c:	85ca                	mv	a1,s2
    8000444e:	855a                	mv	a0,s6
    80004450:	ffffc097          	auipc	ra,0xffffc
    80004454:	7cc080e7          	jalr	1996(ra) # 80000c1c <copyout>
    80004458:	10054363          	bltz	a0,8000455e <exec+0x302>
    ustack[argc] = sp;
    8000445c:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004460:	0485                	addi	s1,s1,1
    80004462:	008d8793          	addi	a5,s11,8
    80004466:	def43823          	sd	a5,-528(s0)
    8000446a:	008db503          	ld	a0,8(s11)
    8000446e:	c911                	beqz	a0,80004482 <exec+0x226>
    if(argc >= MAXARG)
    80004470:	09a1                	addi	s3,s3,8
    80004472:	fb3c95e3          	bne	s9,s3,8000441c <exec+0x1c0>
  sz = sz1;
    80004476:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000447a:	4a81                	li	s5,0
    8000447c:	a84d                	j	8000452e <exec+0x2d2>
  sp = sz;
    8000447e:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004480:	4481                	li	s1,0
  ustack[argc] = 0;
    80004482:	00349793          	slli	a5,s1,0x3
    80004486:	f9078793          	addi	a5,a5,-112
    8000448a:	97a2                	add	a5,a5,s0
    8000448c:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004490:	00148693          	addi	a3,s1,1
    80004494:	068e                	slli	a3,a3,0x3
    80004496:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000449a:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    8000449e:	01597663          	bgeu	s2,s5,800044aa <exec+0x24e>
  sz = sz1;
    800044a2:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800044a6:	4a81                	li	s5,0
    800044a8:	a059                	j	8000452e <exec+0x2d2>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800044aa:	e9040613          	addi	a2,s0,-368
    800044ae:	85ca                	mv	a1,s2
    800044b0:	855a                	mv	a0,s6
    800044b2:	ffffc097          	auipc	ra,0xffffc
    800044b6:	76a080e7          	jalr	1898(ra) # 80000c1c <copyout>
    800044ba:	0a054663          	bltz	a0,80004566 <exec+0x30a>
  p->trapframe->a1 = sp;
    800044be:	060bb783          	ld	a5,96(s7)
    800044c2:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800044c6:	de843783          	ld	a5,-536(s0)
    800044ca:	0007c703          	lbu	a4,0(a5)
    800044ce:	cf11                	beqz	a4,800044ea <exec+0x28e>
    800044d0:	0785                	addi	a5,a5,1
    if(*s == '/')
    800044d2:	02f00693          	li	a3,47
    800044d6:	a039                	j	800044e4 <exec+0x288>
      last = s+1;
    800044d8:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    800044dc:	0785                	addi	a5,a5,1
    800044de:	fff7c703          	lbu	a4,-1(a5)
    800044e2:	c701                	beqz	a4,800044ea <exec+0x28e>
    if(*s == '/')
    800044e4:	fed71ce3          	bne	a4,a3,800044dc <exec+0x280>
    800044e8:	bfc5                	j	800044d8 <exec+0x27c>
  safestrcpy(p->name, last, sizeof(p->name));
    800044ea:	4641                	li	a2,16
    800044ec:	de843583          	ld	a1,-536(s0)
    800044f0:	160b8513          	addi	a0,s7,352
    800044f4:	ffffc097          	auipc	ra,0xffffc
    800044f8:	ed4080e7          	jalr	-300(ra) # 800003c8 <safestrcpy>
  oldpagetable = p->pagetable;
    800044fc:	058bb503          	ld	a0,88(s7)
  p->pagetable = pagetable;
    80004500:	056bbc23          	sd	s6,88(s7)
  p->sz = sz;
    80004504:	058bb823          	sd	s8,80(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004508:	060bb783          	ld	a5,96(s7)
    8000450c:	e6843703          	ld	a4,-408(s0)
    80004510:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004512:	060bb783          	ld	a5,96(s7)
    80004516:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000451a:	85ea                	mv	a1,s10
    8000451c:	ffffd097          	auipc	ra,0xffffd
    80004520:	b9c080e7          	jalr	-1124(ra) # 800010b8 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004524:	0004851b          	sext.w	a0,s1
    80004528:	bbc1                	j	800042f8 <exec+0x9c>
    8000452a:	de943c23          	sd	s1,-520(s0)
    proc_freepagetable(pagetable, sz);
    8000452e:	df843583          	ld	a1,-520(s0)
    80004532:	855a                	mv	a0,s6
    80004534:	ffffd097          	auipc	ra,0xffffd
    80004538:	b84080e7          	jalr	-1148(ra) # 800010b8 <proc_freepagetable>
  if(ip){
    8000453c:	da0a94e3          	bnez	s5,800042e4 <exec+0x88>
  return -1;
    80004540:	557d                	li	a0,-1
    80004542:	bb5d                	j	800042f8 <exec+0x9c>
    80004544:	de943c23          	sd	s1,-520(s0)
    80004548:	b7dd                	j	8000452e <exec+0x2d2>
    8000454a:	de943c23          	sd	s1,-520(s0)
    8000454e:	b7c5                	j	8000452e <exec+0x2d2>
    80004550:	de943c23          	sd	s1,-520(s0)
    80004554:	bfe9                	j	8000452e <exec+0x2d2>
  sz = sz1;
    80004556:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000455a:	4a81                	li	s5,0
    8000455c:	bfc9                	j	8000452e <exec+0x2d2>
  sz = sz1;
    8000455e:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004562:	4a81                	li	s5,0
    80004564:	b7e9                	j	8000452e <exec+0x2d2>
  sz = sz1;
    80004566:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000456a:	4a81                	li	s5,0
    8000456c:	b7c9                	j	8000452e <exec+0x2d2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000456e:	df843483          	ld	s1,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004572:	e0843783          	ld	a5,-504(s0)
    80004576:	0017869b          	addiw	a3,a5,1
    8000457a:	e0d43423          	sd	a3,-504(s0)
    8000457e:	e0043783          	ld	a5,-512(s0)
    80004582:	0387879b          	addiw	a5,a5,56
    80004586:	e8845703          	lhu	a4,-376(s0)
    8000458a:	e2e6d3e3          	bge	a3,a4,800043b0 <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000458e:	2781                	sext.w	a5,a5
    80004590:	e0f43023          	sd	a5,-512(s0)
    80004594:	03800713          	li	a4,56
    80004598:	86be                	mv	a3,a5
    8000459a:	e1840613          	addi	a2,s0,-488
    8000459e:	4581                	li	a1,0
    800045a0:	8556                	mv	a0,s5
    800045a2:	fffff097          	auipc	ra,0xfffff
    800045a6:	a6c080e7          	jalr	-1428(ra) # 8000300e <readi>
    800045aa:	03800793          	li	a5,56
    800045ae:	f6f51ee3          	bne	a0,a5,8000452a <exec+0x2ce>
    if(ph.type != ELF_PROG_LOAD)
    800045b2:	e1842783          	lw	a5,-488(s0)
    800045b6:	4705                	li	a4,1
    800045b8:	fae79de3          	bne	a5,a4,80004572 <exec+0x316>
    if(ph.memsz < ph.filesz)
    800045bc:	e4043603          	ld	a2,-448(s0)
    800045c0:	e3843783          	ld	a5,-456(s0)
    800045c4:	f8f660e3          	bltu	a2,a5,80004544 <exec+0x2e8>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800045c8:	e2843783          	ld	a5,-472(s0)
    800045cc:	963e                	add	a2,a2,a5
    800045ce:	f6f66ee3          	bltu	a2,a5,8000454a <exec+0x2ee>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800045d2:	85a6                	mv	a1,s1
    800045d4:	855a                	mv	a0,s6
    800045d6:	ffffc097          	auipc	ra,0xffffc
    800045da:	3f2080e7          	jalr	1010(ra) # 800009c8 <uvmalloc>
    800045de:	dea43c23          	sd	a0,-520(s0)
    800045e2:	d53d                	beqz	a0,80004550 <exec+0x2f4>
    if((ph.vaddr % PGSIZE) != 0)
    800045e4:	e2843c03          	ld	s8,-472(s0)
    800045e8:	de043783          	ld	a5,-544(s0)
    800045ec:	00fc77b3          	and	a5,s8,a5
    800045f0:	ff9d                	bnez	a5,8000452e <exec+0x2d2>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800045f2:	e2042c83          	lw	s9,-480(s0)
    800045f6:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800045fa:	f60b8ae3          	beqz	s7,8000456e <exec+0x312>
    800045fe:	89de                	mv	s3,s7
    80004600:	4481                	li	s1,0
    80004602:	b371                	j	8000438e <exec+0x132>

0000000080004604 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004604:	7179                	addi	sp,sp,-48
    80004606:	f406                	sd	ra,40(sp)
    80004608:	f022                	sd	s0,32(sp)
    8000460a:	ec26                	sd	s1,24(sp)
    8000460c:	e84a                	sd	s2,16(sp)
    8000460e:	1800                	addi	s0,sp,48
    80004610:	892e                	mv	s2,a1
    80004612:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004614:	fdc40593          	addi	a1,s0,-36
    80004618:	ffffe097          	auipc	ra,0xffffe
    8000461c:	9f6080e7          	jalr	-1546(ra) # 8000200e <argint>
    80004620:	04054063          	bltz	a0,80004660 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004624:	fdc42703          	lw	a4,-36(s0)
    80004628:	47bd                	li	a5,15
    8000462a:	02e7ed63          	bltu	a5,a4,80004664 <argfd+0x60>
    8000462e:	ffffd097          	auipc	ra,0xffffd
    80004632:	92a080e7          	jalr	-1750(ra) # 80000f58 <myproc>
    80004636:	fdc42703          	lw	a4,-36(s0)
    8000463a:	01a70793          	addi	a5,a4,26 # fffffffffffff01a <end+0xffffffff7ffd3dd2>
    8000463e:	078e                	slli	a5,a5,0x3
    80004640:	953e                	add	a0,a0,a5
    80004642:	651c                	ld	a5,8(a0)
    80004644:	c395                	beqz	a5,80004668 <argfd+0x64>
    return -1;
  if(pfd)
    80004646:	00090463          	beqz	s2,8000464e <argfd+0x4a>
    *pfd = fd;
    8000464a:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    8000464e:	4501                	li	a0,0
  if(pf)
    80004650:	c091                	beqz	s1,80004654 <argfd+0x50>
    *pf = f;
    80004652:	e09c                	sd	a5,0(s1)
}
    80004654:	70a2                	ld	ra,40(sp)
    80004656:	7402                	ld	s0,32(sp)
    80004658:	64e2                	ld	s1,24(sp)
    8000465a:	6942                	ld	s2,16(sp)
    8000465c:	6145                	addi	sp,sp,48
    8000465e:	8082                	ret
    return -1;
    80004660:	557d                	li	a0,-1
    80004662:	bfcd                	j	80004654 <argfd+0x50>
    return -1;
    80004664:	557d                	li	a0,-1
    80004666:	b7fd                	j	80004654 <argfd+0x50>
    80004668:	557d                	li	a0,-1
    8000466a:	b7ed                	j	80004654 <argfd+0x50>

000000008000466c <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000466c:	1101                	addi	sp,sp,-32
    8000466e:	ec06                	sd	ra,24(sp)
    80004670:	e822                	sd	s0,16(sp)
    80004672:	e426                	sd	s1,8(sp)
    80004674:	1000                	addi	s0,sp,32
    80004676:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004678:	ffffd097          	auipc	ra,0xffffd
    8000467c:	8e0080e7          	jalr	-1824(ra) # 80000f58 <myproc>
    80004680:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004682:	0d850793          	addi	a5,a0,216
    80004686:	4501                	li	a0,0
    80004688:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000468a:	6398                	ld	a4,0(a5)
    8000468c:	cb19                	beqz	a4,800046a2 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    8000468e:	2505                	addiw	a0,a0,1
    80004690:	07a1                	addi	a5,a5,8
    80004692:	fed51ce3          	bne	a0,a3,8000468a <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004696:	557d                	li	a0,-1
}
    80004698:	60e2                	ld	ra,24(sp)
    8000469a:	6442                	ld	s0,16(sp)
    8000469c:	64a2                	ld	s1,8(sp)
    8000469e:	6105                	addi	sp,sp,32
    800046a0:	8082                	ret
      p->ofile[fd] = f;
    800046a2:	01a50793          	addi	a5,a0,26
    800046a6:	078e                	slli	a5,a5,0x3
    800046a8:	963e                	add	a2,a2,a5
    800046aa:	e604                	sd	s1,8(a2)
      return fd;
    800046ac:	b7f5                	j	80004698 <fdalloc+0x2c>

00000000800046ae <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800046ae:	715d                	addi	sp,sp,-80
    800046b0:	e486                	sd	ra,72(sp)
    800046b2:	e0a2                	sd	s0,64(sp)
    800046b4:	fc26                	sd	s1,56(sp)
    800046b6:	f84a                	sd	s2,48(sp)
    800046b8:	f44e                	sd	s3,40(sp)
    800046ba:	f052                	sd	s4,32(sp)
    800046bc:	ec56                	sd	s5,24(sp)
    800046be:	0880                	addi	s0,sp,80
    800046c0:	89ae                	mv	s3,a1
    800046c2:	8ab2                	mv	s5,a2
    800046c4:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800046c6:	fb040593          	addi	a1,s0,-80
    800046ca:	fffff097          	auipc	ra,0xfffff
    800046ce:	e6a080e7          	jalr	-406(ra) # 80003534 <nameiparent>
    800046d2:	892a                	mv	s2,a0
    800046d4:	12050e63          	beqz	a0,80004810 <create+0x162>
    return 0;

  ilock(dp);
    800046d8:	ffffe097          	auipc	ra,0xffffe
    800046dc:	682080e7          	jalr	1666(ra) # 80002d5a <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800046e0:	4601                	li	a2,0
    800046e2:	fb040593          	addi	a1,s0,-80
    800046e6:	854a                	mv	a0,s2
    800046e8:	fffff097          	auipc	ra,0xfffff
    800046ec:	b56080e7          	jalr	-1194(ra) # 8000323e <dirlookup>
    800046f0:	84aa                	mv	s1,a0
    800046f2:	c921                	beqz	a0,80004742 <create+0x94>
    iunlockput(dp);
    800046f4:	854a                	mv	a0,s2
    800046f6:	fffff097          	auipc	ra,0xfffff
    800046fa:	8c6080e7          	jalr	-1850(ra) # 80002fbc <iunlockput>
    ilock(ip);
    800046fe:	8526                	mv	a0,s1
    80004700:	ffffe097          	auipc	ra,0xffffe
    80004704:	65a080e7          	jalr	1626(ra) # 80002d5a <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004708:	2981                	sext.w	s3,s3
    8000470a:	4789                	li	a5,2
    8000470c:	02f99463          	bne	s3,a5,80004734 <create+0x86>
    80004710:	04c4d783          	lhu	a5,76(s1)
    80004714:	37f9                	addiw	a5,a5,-2
    80004716:	17c2                	slli	a5,a5,0x30
    80004718:	93c1                	srli	a5,a5,0x30
    8000471a:	4705                	li	a4,1
    8000471c:	00f76c63          	bltu	a4,a5,80004734 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80004720:	8526                	mv	a0,s1
    80004722:	60a6                	ld	ra,72(sp)
    80004724:	6406                	ld	s0,64(sp)
    80004726:	74e2                	ld	s1,56(sp)
    80004728:	7942                	ld	s2,48(sp)
    8000472a:	79a2                	ld	s3,40(sp)
    8000472c:	7a02                	ld	s4,32(sp)
    8000472e:	6ae2                	ld	s5,24(sp)
    80004730:	6161                	addi	sp,sp,80
    80004732:	8082                	ret
    iunlockput(ip);
    80004734:	8526                	mv	a0,s1
    80004736:	fffff097          	auipc	ra,0xfffff
    8000473a:	886080e7          	jalr	-1914(ra) # 80002fbc <iunlockput>
    return 0;
    8000473e:	4481                	li	s1,0
    80004740:	b7c5                	j	80004720 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    80004742:	85ce                	mv	a1,s3
    80004744:	00092503          	lw	a0,0(s2)
    80004748:	ffffe097          	auipc	ra,0xffffe
    8000474c:	478080e7          	jalr	1144(ra) # 80002bc0 <ialloc>
    80004750:	84aa                	mv	s1,a0
    80004752:	c521                	beqz	a0,8000479a <create+0xec>
  ilock(ip);
    80004754:	ffffe097          	auipc	ra,0xffffe
    80004758:	606080e7          	jalr	1542(ra) # 80002d5a <ilock>
  ip->major = major;
    8000475c:	05549723          	sh	s5,78(s1)
  ip->minor = minor;
    80004760:	05449823          	sh	s4,80(s1)
  ip->nlink = 1;
    80004764:	4a05                	li	s4,1
    80004766:	05449923          	sh	s4,82(s1)
  iupdate(ip);
    8000476a:	8526                	mv	a0,s1
    8000476c:	ffffe097          	auipc	ra,0xffffe
    80004770:	522080e7          	jalr	1314(ra) # 80002c8e <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004774:	2981                	sext.w	s3,s3
    80004776:	03498a63          	beq	s3,s4,800047aa <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    8000477a:	40d0                	lw	a2,4(s1)
    8000477c:	fb040593          	addi	a1,s0,-80
    80004780:	854a                	mv	a0,s2
    80004782:	fffff097          	auipc	ra,0xfffff
    80004786:	cd2080e7          	jalr	-814(ra) # 80003454 <dirlink>
    8000478a:	06054b63          	bltz	a0,80004800 <create+0x152>
  iunlockput(dp);
    8000478e:	854a                	mv	a0,s2
    80004790:	fffff097          	auipc	ra,0xfffff
    80004794:	82c080e7          	jalr	-2004(ra) # 80002fbc <iunlockput>
  return ip;
    80004798:	b761                	j	80004720 <create+0x72>
    panic("create: ialloc");
    8000479a:	00004517          	auipc	a0,0x4
    8000479e:	ece50513          	addi	a0,a0,-306 # 80008668 <syscalls+0x2a0>
    800047a2:	00002097          	auipc	ra,0x2
    800047a6:	972080e7          	jalr	-1678(ra) # 80006114 <panic>
    dp->nlink++;  // for ".."
    800047aa:	05295783          	lhu	a5,82(s2)
    800047ae:	2785                	addiw	a5,a5,1
    800047b0:	04f91923          	sh	a5,82(s2)
    iupdate(dp);
    800047b4:	854a                	mv	a0,s2
    800047b6:	ffffe097          	auipc	ra,0xffffe
    800047ba:	4d8080e7          	jalr	1240(ra) # 80002c8e <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800047be:	40d0                	lw	a2,4(s1)
    800047c0:	00004597          	auipc	a1,0x4
    800047c4:	eb858593          	addi	a1,a1,-328 # 80008678 <syscalls+0x2b0>
    800047c8:	8526                	mv	a0,s1
    800047ca:	fffff097          	auipc	ra,0xfffff
    800047ce:	c8a080e7          	jalr	-886(ra) # 80003454 <dirlink>
    800047d2:	00054f63          	bltz	a0,800047f0 <create+0x142>
    800047d6:	00492603          	lw	a2,4(s2)
    800047da:	00004597          	auipc	a1,0x4
    800047de:	ea658593          	addi	a1,a1,-346 # 80008680 <syscalls+0x2b8>
    800047e2:	8526                	mv	a0,s1
    800047e4:	fffff097          	auipc	ra,0xfffff
    800047e8:	c70080e7          	jalr	-912(ra) # 80003454 <dirlink>
    800047ec:	f80557e3          	bgez	a0,8000477a <create+0xcc>
      panic("create dots");
    800047f0:	00004517          	auipc	a0,0x4
    800047f4:	e9850513          	addi	a0,a0,-360 # 80008688 <syscalls+0x2c0>
    800047f8:	00002097          	auipc	ra,0x2
    800047fc:	91c080e7          	jalr	-1764(ra) # 80006114 <panic>
    panic("create: dirlink");
    80004800:	00004517          	auipc	a0,0x4
    80004804:	e9850513          	addi	a0,a0,-360 # 80008698 <syscalls+0x2d0>
    80004808:	00002097          	auipc	ra,0x2
    8000480c:	90c080e7          	jalr	-1780(ra) # 80006114 <panic>
    return 0;
    80004810:	84aa                	mv	s1,a0
    80004812:	b739                	j	80004720 <create+0x72>

0000000080004814 <sys_dup>:
{
    80004814:	7179                	addi	sp,sp,-48
    80004816:	f406                	sd	ra,40(sp)
    80004818:	f022                	sd	s0,32(sp)
    8000481a:	ec26                	sd	s1,24(sp)
    8000481c:	e84a                	sd	s2,16(sp)
    8000481e:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004820:	fd840613          	addi	a2,s0,-40
    80004824:	4581                	li	a1,0
    80004826:	4501                	li	a0,0
    80004828:	00000097          	auipc	ra,0x0
    8000482c:	ddc080e7          	jalr	-548(ra) # 80004604 <argfd>
    return -1;
    80004830:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004832:	02054363          	bltz	a0,80004858 <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    80004836:	fd843903          	ld	s2,-40(s0)
    8000483a:	854a                	mv	a0,s2
    8000483c:	00000097          	auipc	ra,0x0
    80004840:	e30080e7          	jalr	-464(ra) # 8000466c <fdalloc>
    80004844:	84aa                	mv	s1,a0
    return -1;
    80004846:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004848:	00054863          	bltz	a0,80004858 <sys_dup+0x44>
  filedup(f);
    8000484c:	854a                	mv	a0,s2
    8000484e:	fffff097          	auipc	ra,0xfffff
    80004852:	35e080e7          	jalr	862(ra) # 80003bac <filedup>
  return fd;
    80004856:	87a6                	mv	a5,s1
}
    80004858:	853e                	mv	a0,a5
    8000485a:	70a2                	ld	ra,40(sp)
    8000485c:	7402                	ld	s0,32(sp)
    8000485e:	64e2                	ld	s1,24(sp)
    80004860:	6942                	ld	s2,16(sp)
    80004862:	6145                	addi	sp,sp,48
    80004864:	8082                	ret

0000000080004866 <sys_read>:
{
    80004866:	7179                	addi	sp,sp,-48
    80004868:	f406                	sd	ra,40(sp)
    8000486a:	f022                	sd	s0,32(sp)
    8000486c:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000486e:	fe840613          	addi	a2,s0,-24
    80004872:	4581                	li	a1,0
    80004874:	4501                	li	a0,0
    80004876:	00000097          	auipc	ra,0x0
    8000487a:	d8e080e7          	jalr	-626(ra) # 80004604 <argfd>
    return -1;
    8000487e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004880:	04054163          	bltz	a0,800048c2 <sys_read+0x5c>
    80004884:	fe440593          	addi	a1,s0,-28
    80004888:	4509                	li	a0,2
    8000488a:	ffffd097          	auipc	ra,0xffffd
    8000488e:	784080e7          	jalr	1924(ra) # 8000200e <argint>
    return -1;
    80004892:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004894:	02054763          	bltz	a0,800048c2 <sys_read+0x5c>
    80004898:	fd840593          	addi	a1,s0,-40
    8000489c:	4505                	li	a0,1
    8000489e:	ffffd097          	auipc	ra,0xffffd
    800048a2:	792080e7          	jalr	1938(ra) # 80002030 <argaddr>
    return -1;
    800048a6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048a8:	00054d63          	bltz	a0,800048c2 <sys_read+0x5c>
  return fileread(f, p, n);
    800048ac:	fe442603          	lw	a2,-28(s0)
    800048b0:	fd843583          	ld	a1,-40(s0)
    800048b4:	fe843503          	ld	a0,-24(s0)
    800048b8:	fffff097          	auipc	ra,0xfffff
    800048bc:	480080e7          	jalr	1152(ra) # 80003d38 <fileread>
    800048c0:	87aa                	mv	a5,a0
}
    800048c2:	853e                	mv	a0,a5
    800048c4:	70a2                	ld	ra,40(sp)
    800048c6:	7402                	ld	s0,32(sp)
    800048c8:	6145                	addi	sp,sp,48
    800048ca:	8082                	ret

00000000800048cc <sys_write>:
{
    800048cc:	7179                	addi	sp,sp,-48
    800048ce:	f406                	sd	ra,40(sp)
    800048d0:	f022                	sd	s0,32(sp)
    800048d2:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048d4:	fe840613          	addi	a2,s0,-24
    800048d8:	4581                	li	a1,0
    800048da:	4501                	li	a0,0
    800048dc:	00000097          	auipc	ra,0x0
    800048e0:	d28080e7          	jalr	-728(ra) # 80004604 <argfd>
    return -1;
    800048e4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048e6:	04054163          	bltz	a0,80004928 <sys_write+0x5c>
    800048ea:	fe440593          	addi	a1,s0,-28
    800048ee:	4509                	li	a0,2
    800048f0:	ffffd097          	auipc	ra,0xffffd
    800048f4:	71e080e7          	jalr	1822(ra) # 8000200e <argint>
    return -1;
    800048f8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048fa:	02054763          	bltz	a0,80004928 <sys_write+0x5c>
    800048fe:	fd840593          	addi	a1,s0,-40
    80004902:	4505                	li	a0,1
    80004904:	ffffd097          	auipc	ra,0xffffd
    80004908:	72c080e7          	jalr	1836(ra) # 80002030 <argaddr>
    return -1;
    8000490c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000490e:	00054d63          	bltz	a0,80004928 <sys_write+0x5c>
  return filewrite(f, p, n);
    80004912:	fe442603          	lw	a2,-28(s0)
    80004916:	fd843583          	ld	a1,-40(s0)
    8000491a:	fe843503          	ld	a0,-24(s0)
    8000491e:	fffff097          	auipc	ra,0xfffff
    80004922:	4dc080e7          	jalr	1244(ra) # 80003dfa <filewrite>
    80004926:	87aa                	mv	a5,a0
}
    80004928:	853e                	mv	a0,a5
    8000492a:	70a2                	ld	ra,40(sp)
    8000492c:	7402                	ld	s0,32(sp)
    8000492e:	6145                	addi	sp,sp,48
    80004930:	8082                	ret

0000000080004932 <sys_close>:
{
    80004932:	1101                	addi	sp,sp,-32
    80004934:	ec06                	sd	ra,24(sp)
    80004936:	e822                	sd	s0,16(sp)
    80004938:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000493a:	fe040613          	addi	a2,s0,-32
    8000493e:	fec40593          	addi	a1,s0,-20
    80004942:	4501                	li	a0,0
    80004944:	00000097          	auipc	ra,0x0
    80004948:	cc0080e7          	jalr	-832(ra) # 80004604 <argfd>
    return -1;
    8000494c:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000494e:	02054463          	bltz	a0,80004976 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004952:	ffffc097          	auipc	ra,0xffffc
    80004956:	606080e7          	jalr	1542(ra) # 80000f58 <myproc>
    8000495a:	fec42783          	lw	a5,-20(s0)
    8000495e:	07e9                	addi	a5,a5,26
    80004960:	078e                	slli	a5,a5,0x3
    80004962:	953e                	add	a0,a0,a5
    80004964:	00053423          	sd	zero,8(a0)
  fileclose(f);
    80004968:	fe043503          	ld	a0,-32(s0)
    8000496c:	fffff097          	auipc	ra,0xfffff
    80004970:	292080e7          	jalr	658(ra) # 80003bfe <fileclose>
  return 0;
    80004974:	4781                	li	a5,0
}
    80004976:	853e                	mv	a0,a5
    80004978:	60e2                	ld	ra,24(sp)
    8000497a:	6442                	ld	s0,16(sp)
    8000497c:	6105                	addi	sp,sp,32
    8000497e:	8082                	ret

0000000080004980 <sys_fstat>:
{
    80004980:	1101                	addi	sp,sp,-32
    80004982:	ec06                	sd	ra,24(sp)
    80004984:	e822                	sd	s0,16(sp)
    80004986:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004988:	fe840613          	addi	a2,s0,-24
    8000498c:	4581                	li	a1,0
    8000498e:	4501                	li	a0,0
    80004990:	00000097          	auipc	ra,0x0
    80004994:	c74080e7          	jalr	-908(ra) # 80004604 <argfd>
    return -1;
    80004998:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000499a:	02054563          	bltz	a0,800049c4 <sys_fstat+0x44>
    8000499e:	fe040593          	addi	a1,s0,-32
    800049a2:	4505                	li	a0,1
    800049a4:	ffffd097          	auipc	ra,0xffffd
    800049a8:	68c080e7          	jalr	1676(ra) # 80002030 <argaddr>
    return -1;
    800049ac:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800049ae:	00054b63          	bltz	a0,800049c4 <sys_fstat+0x44>
  return filestat(f, st);
    800049b2:	fe043583          	ld	a1,-32(s0)
    800049b6:	fe843503          	ld	a0,-24(s0)
    800049ba:	fffff097          	auipc	ra,0xfffff
    800049be:	30c080e7          	jalr	780(ra) # 80003cc6 <filestat>
    800049c2:	87aa                	mv	a5,a0
}
    800049c4:	853e                	mv	a0,a5
    800049c6:	60e2                	ld	ra,24(sp)
    800049c8:	6442                	ld	s0,16(sp)
    800049ca:	6105                	addi	sp,sp,32
    800049cc:	8082                	ret

00000000800049ce <sys_link>:
{
    800049ce:	7169                	addi	sp,sp,-304
    800049d0:	f606                	sd	ra,296(sp)
    800049d2:	f222                	sd	s0,288(sp)
    800049d4:	ee26                	sd	s1,280(sp)
    800049d6:	ea4a                	sd	s2,272(sp)
    800049d8:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800049da:	08000613          	li	a2,128
    800049de:	ed040593          	addi	a1,s0,-304
    800049e2:	4501                	li	a0,0
    800049e4:	ffffd097          	auipc	ra,0xffffd
    800049e8:	66e080e7          	jalr	1646(ra) # 80002052 <argstr>
    return -1;
    800049ec:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800049ee:	10054e63          	bltz	a0,80004b0a <sys_link+0x13c>
    800049f2:	08000613          	li	a2,128
    800049f6:	f5040593          	addi	a1,s0,-176
    800049fa:	4505                	li	a0,1
    800049fc:	ffffd097          	auipc	ra,0xffffd
    80004a00:	656080e7          	jalr	1622(ra) # 80002052 <argstr>
    return -1;
    80004a04:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a06:	10054263          	bltz	a0,80004b0a <sys_link+0x13c>
  begin_op();
    80004a0a:	fffff097          	auipc	ra,0xfffff
    80004a0e:	d2c080e7          	jalr	-724(ra) # 80003736 <begin_op>
  if((ip = namei(old)) == 0){
    80004a12:	ed040513          	addi	a0,s0,-304
    80004a16:	fffff097          	auipc	ra,0xfffff
    80004a1a:	b00080e7          	jalr	-1280(ra) # 80003516 <namei>
    80004a1e:	84aa                	mv	s1,a0
    80004a20:	c551                	beqz	a0,80004aac <sys_link+0xde>
  ilock(ip);
    80004a22:	ffffe097          	auipc	ra,0xffffe
    80004a26:	338080e7          	jalr	824(ra) # 80002d5a <ilock>
  if(ip->type == T_DIR){
    80004a2a:	04c49703          	lh	a4,76(s1)
    80004a2e:	4785                	li	a5,1
    80004a30:	08f70463          	beq	a4,a5,80004ab8 <sys_link+0xea>
  ip->nlink++;
    80004a34:	0524d783          	lhu	a5,82(s1)
    80004a38:	2785                	addiw	a5,a5,1
    80004a3a:	04f49923          	sh	a5,82(s1)
  iupdate(ip);
    80004a3e:	8526                	mv	a0,s1
    80004a40:	ffffe097          	auipc	ra,0xffffe
    80004a44:	24e080e7          	jalr	590(ra) # 80002c8e <iupdate>
  iunlock(ip);
    80004a48:	8526                	mv	a0,s1
    80004a4a:	ffffe097          	auipc	ra,0xffffe
    80004a4e:	3d2080e7          	jalr	978(ra) # 80002e1c <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004a52:	fd040593          	addi	a1,s0,-48
    80004a56:	f5040513          	addi	a0,s0,-176
    80004a5a:	fffff097          	auipc	ra,0xfffff
    80004a5e:	ada080e7          	jalr	-1318(ra) # 80003534 <nameiparent>
    80004a62:	892a                	mv	s2,a0
    80004a64:	c935                	beqz	a0,80004ad8 <sys_link+0x10a>
  ilock(dp);
    80004a66:	ffffe097          	auipc	ra,0xffffe
    80004a6a:	2f4080e7          	jalr	756(ra) # 80002d5a <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004a6e:	00092703          	lw	a4,0(s2)
    80004a72:	409c                	lw	a5,0(s1)
    80004a74:	04f71d63          	bne	a4,a5,80004ace <sys_link+0x100>
    80004a78:	40d0                	lw	a2,4(s1)
    80004a7a:	fd040593          	addi	a1,s0,-48
    80004a7e:	854a                	mv	a0,s2
    80004a80:	fffff097          	auipc	ra,0xfffff
    80004a84:	9d4080e7          	jalr	-1580(ra) # 80003454 <dirlink>
    80004a88:	04054363          	bltz	a0,80004ace <sys_link+0x100>
  iunlockput(dp);
    80004a8c:	854a                	mv	a0,s2
    80004a8e:	ffffe097          	auipc	ra,0xffffe
    80004a92:	52e080e7          	jalr	1326(ra) # 80002fbc <iunlockput>
  iput(ip);
    80004a96:	8526                	mv	a0,s1
    80004a98:	ffffe097          	auipc	ra,0xffffe
    80004a9c:	47c080e7          	jalr	1148(ra) # 80002f14 <iput>
  end_op();
    80004aa0:	fffff097          	auipc	ra,0xfffff
    80004aa4:	d14080e7          	jalr	-748(ra) # 800037b4 <end_op>
  return 0;
    80004aa8:	4781                	li	a5,0
    80004aaa:	a085                	j	80004b0a <sys_link+0x13c>
    end_op();
    80004aac:	fffff097          	auipc	ra,0xfffff
    80004ab0:	d08080e7          	jalr	-760(ra) # 800037b4 <end_op>
    return -1;
    80004ab4:	57fd                	li	a5,-1
    80004ab6:	a891                	j	80004b0a <sys_link+0x13c>
    iunlockput(ip);
    80004ab8:	8526                	mv	a0,s1
    80004aba:	ffffe097          	auipc	ra,0xffffe
    80004abe:	502080e7          	jalr	1282(ra) # 80002fbc <iunlockput>
    end_op();
    80004ac2:	fffff097          	auipc	ra,0xfffff
    80004ac6:	cf2080e7          	jalr	-782(ra) # 800037b4 <end_op>
    return -1;
    80004aca:	57fd                	li	a5,-1
    80004acc:	a83d                	j	80004b0a <sys_link+0x13c>
    iunlockput(dp);
    80004ace:	854a                	mv	a0,s2
    80004ad0:	ffffe097          	auipc	ra,0xffffe
    80004ad4:	4ec080e7          	jalr	1260(ra) # 80002fbc <iunlockput>
  ilock(ip);
    80004ad8:	8526                	mv	a0,s1
    80004ada:	ffffe097          	auipc	ra,0xffffe
    80004ade:	280080e7          	jalr	640(ra) # 80002d5a <ilock>
  ip->nlink--;
    80004ae2:	0524d783          	lhu	a5,82(s1)
    80004ae6:	37fd                	addiw	a5,a5,-1
    80004ae8:	04f49923          	sh	a5,82(s1)
  iupdate(ip);
    80004aec:	8526                	mv	a0,s1
    80004aee:	ffffe097          	auipc	ra,0xffffe
    80004af2:	1a0080e7          	jalr	416(ra) # 80002c8e <iupdate>
  iunlockput(ip);
    80004af6:	8526                	mv	a0,s1
    80004af8:	ffffe097          	auipc	ra,0xffffe
    80004afc:	4c4080e7          	jalr	1220(ra) # 80002fbc <iunlockput>
  end_op();
    80004b00:	fffff097          	auipc	ra,0xfffff
    80004b04:	cb4080e7          	jalr	-844(ra) # 800037b4 <end_op>
  return -1;
    80004b08:	57fd                	li	a5,-1
}
    80004b0a:	853e                	mv	a0,a5
    80004b0c:	70b2                	ld	ra,296(sp)
    80004b0e:	7412                	ld	s0,288(sp)
    80004b10:	64f2                	ld	s1,280(sp)
    80004b12:	6952                	ld	s2,272(sp)
    80004b14:	6155                	addi	sp,sp,304
    80004b16:	8082                	ret

0000000080004b18 <sys_unlink>:
{
    80004b18:	7151                	addi	sp,sp,-240
    80004b1a:	f586                	sd	ra,232(sp)
    80004b1c:	f1a2                	sd	s0,224(sp)
    80004b1e:	eda6                	sd	s1,216(sp)
    80004b20:	e9ca                	sd	s2,208(sp)
    80004b22:	e5ce                	sd	s3,200(sp)
    80004b24:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004b26:	08000613          	li	a2,128
    80004b2a:	f3040593          	addi	a1,s0,-208
    80004b2e:	4501                	li	a0,0
    80004b30:	ffffd097          	auipc	ra,0xffffd
    80004b34:	522080e7          	jalr	1314(ra) # 80002052 <argstr>
    80004b38:	18054163          	bltz	a0,80004cba <sys_unlink+0x1a2>
  begin_op();
    80004b3c:	fffff097          	auipc	ra,0xfffff
    80004b40:	bfa080e7          	jalr	-1030(ra) # 80003736 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004b44:	fb040593          	addi	a1,s0,-80
    80004b48:	f3040513          	addi	a0,s0,-208
    80004b4c:	fffff097          	auipc	ra,0xfffff
    80004b50:	9e8080e7          	jalr	-1560(ra) # 80003534 <nameiparent>
    80004b54:	84aa                	mv	s1,a0
    80004b56:	c979                	beqz	a0,80004c2c <sys_unlink+0x114>
  ilock(dp);
    80004b58:	ffffe097          	auipc	ra,0xffffe
    80004b5c:	202080e7          	jalr	514(ra) # 80002d5a <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004b60:	00004597          	auipc	a1,0x4
    80004b64:	b1858593          	addi	a1,a1,-1256 # 80008678 <syscalls+0x2b0>
    80004b68:	fb040513          	addi	a0,s0,-80
    80004b6c:	ffffe097          	auipc	ra,0xffffe
    80004b70:	6b8080e7          	jalr	1720(ra) # 80003224 <namecmp>
    80004b74:	14050a63          	beqz	a0,80004cc8 <sys_unlink+0x1b0>
    80004b78:	00004597          	auipc	a1,0x4
    80004b7c:	b0858593          	addi	a1,a1,-1272 # 80008680 <syscalls+0x2b8>
    80004b80:	fb040513          	addi	a0,s0,-80
    80004b84:	ffffe097          	auipc	ra,0xffffe
    80004b88:	6a0080e7          	jalr	1696(ra) # 80003224 <namecmp>
    80004b8c:	12050e63          	beqz	a0,80004cc8 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004b90:	f2c40613          	addi	a2,s0,-212
    80004b94:	fb040593          	addi	a1,s0,-80
    80004b98:	8526                	mv	a0,s1
    80004b9a:	ffffe097          	auipc	ra,0xffffe
    80004b9e:	6a4080e7          	jalr	1700(ra) # 8000323e <dirlookup>
    80004ba2:	892a                	mv	s2,a0
    80004ba4:	12050263          	beqz	a0,80004cc8 <sys_unlink+0x1b0>
  ilock(ip);
    80004ba8:	ffffe097          	auipc	ra,0xffffe
    80004bac:	1b2080e7          	jalr	434(ra) # 80002d5a <ilock>
  if(ip->nlink < 1)
    80004bb0:	05291783          	lh	a5,82(s2)
    80004bb4:	08f05263          	blez	a5,80004c38 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004bb8:	04c91703          	lh	a4,76(s2)
    80004bbc:	4785                	li	a5,1
    80004bbe:	08f70563          	beq	a4,a5,80004c48 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004bc2:	4641                	li	a2,16
    80004bc4:	4581                	li	a1,0
    80004bc6:	fc040513          	addi	a0,s0,-64
    80004bca:	ffffb097          	auipc	ra,0xffffb
    80004bce:	6b4080e7          	jalr	1716(ra) # 8000027e <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004bd2:	4741                	li	a4,16
    80004bd4:	f2c42683          	lw	a3,-212(s0)
    80004bd8:	fc040613          	addi	a2,s0,-64
    80004bdc:	4581                	li	a1,0
    80004bde:	8526                	mv	a0,s1
    80004be0:	ffffe097          	auipc	ra,0xffffe
    80004be4:	526080e7          	jalr	1318(ra) # 80003106 <writei>
    80004be8:	47c1                	li	a5,16
    80004bea:	0af51563          	bne	a0,a5,80004c94 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004bee:	04c91703          	lh	a4,76(s2)
    80004bf2:	4785                	li	a5,1
    80004bf4:	0af70863          	beq	a4,a5,80004ca4 <sys_unlink+0x18c>
  iunlockput(dp);
    80004bf8:	8526                	mv	a0,s1
    80004bfa:	ffffe097          	auipc	ra,0xffffe
    80004bfe:	3c2080e7          	jalr	962(ra) # 80002fbc <iunlockput>
  ip->nlink--;
    80004c02:	05295783          	lhu	a5,82(s2)
    80004c06:	37fd                	addiw	a5,a5,-1
    80004c08:	04f91923          	sh	a5,82(s2)
  iupdate(ip);
    80004c0c:	854a                	mv	a0,s2
    80004c0e:	ffffe097          	auipc	ra,0xffffe
    80004c12:	080080e7          	jalr	128(ra) # 80002c8e <iupdate>
  iunlockput(ip);
    80004c16:	854a                	mv	a0,s2
    80004c18:	ffffe097          	auipc	ra,0xffffe
    80004c1c:	3a4080e7          	jalr	932(ra) # 80002fbc <iunlockput>
  end_op();
    80004c20:	fffff097          	auipc	ra,0xfffff
    80004c24:	b94080e7          	jalr	-1132(ra) # 800037b4 <end_op>
  return 0;
    80004c28:	4501                	li	a0,0
    80004c2a:	a84d                	j	80004cdc <sys_unlink+0x1c4>
    end_op();
    80004c2c:	fffff097          	auipc	ra,0xfffff
    80004c30:	b88080e7          	jalr	-1144(ra) # 800037b4 <end_op>
    return -1;
    80004c34:	557d                	li	a0,-1
    80004c36:	a05d                	j	80004cdc <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004c38:	00004517          	auipc	a0,0x4
    80004c3c:	a7050513          	addi	a0,a0,-1424 # 800086a8 <syscalls+0x2e0>
    80004c40:	00001097          	auipc	ra,0x1
    80004c44:	4d4080e7          	jalr	1236(ra) # 80006114 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004c48:	05492703          	lw	a4,84(s2)
    80004c4c:	02000793          	li	a5,32
    80004c50:	f6e7f9e3          	bgeu	a5,a4,80004bc2 <sys_unlink+0xaa>
    80004c54:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c58:	4741                	li	a4,16
    80004c5a:	86ce                	mv	a3,s3
    80004c5c:	f1840613          	addi	a2,s0,-232
    80004c60:	4581                	li	a1,0
    80004c62:	854a                	mv	a0,s2
    80004c64:	ffffe097          	auipc	ra,0xffffe
    80004c68:	3aa080e7          	jalr	938(ra) # 8000300e <readi>
    80004c6c:	47c1                	li	a5,16
    80004c6e:	00f51b63          	bne	a0,a5,80004c84 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004c72:	f1845783          	lhu	a5,-232(s0)
    80004c76:	e7a1                	bnez	a5,80004cbe <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004c78:	29c1                	addiw	s3,s3,16
    80004c7a:	05492783          	lw	a5,84(s2)
    80004c7e:	fcf9ede3          	bltu	s3,a5,80004c58 <sys_unlink+0x140>
    80004c82:	b781                	j	80004bc2 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004c84:	00004517          	auipc	a0,0x4
    80004c88:	a3c50513          	addi	a0,a0,-1476 # 800086c0 <syscalls+0x2f8>
    80004c8c:	00001097          	auipc	ra,0x1
    80004c90:	488080e7          	jalr	1160(ra) # 80006114 <panic>
    panic("unlink: writei");
    80004c94:	00004517          	auipc	a0,0x4
    80004c98:	a4450513          	addi	a0,a0,-1468 # 800086d8 <syscalls+0x310>
    80004c9c:	00001097          	auipc	ra,0x1
    80004ca0:	478080e7          	jalr	1144(ra) # 80006114 <panic>
    dp->nlink--;
    80004ca4:	0524d783          	lhu	a5,82(s1)
    80004ca8:	37fd                	addiw	a5,a5,-1
    80004caa:	04f49923          	sh	a5,82(s1)
    iupdate(dp);
    80004cae:	8526                	mv	a0,s1
    80004cb0:	ffffe097          	auipc	ra,0xffffe
    80004cb4:	fde080e7          	jalr	-34(ra) # 80002c8e <iupdate>
    80004cb8:	b781                	j	80004bf8 <sys_unlink+0xe0>
    return -1;
    80004cba:	557d                	li	a0,-1
    80004cbc:	a005                	j	80004cdc <sys_unlink+0x1c4>
    iunlockput(ip);
    80004cbe:	854a                	mv	a0,s2
    80004cc0:	ffffe097          	auipc	ra,0xffffe
    80004cc4:	2fc080e7          	jalr	764(ra) # 80002fbc <iunlockput>
  iunlockput(dp);
    80004cc8:	8526                	mv	a0,s1
    80004cca:	ffffe097          	auipc	ra,0xffffe
    80004cce:	2f2080e7          	jalr	754(ra) # 80002fbc <iunlockput>
  end_op();
    80004cd2:	fffff097          	auipc	ra,0xfffff
    80004cd6:	ae2080e7          	jalr	-1310(ra) # 800037b4 <end_op>
  return -1;
    80004cda:	557d                	li	a0,-1
}
    80004cdc:	70ae                	ld	ra,232(sp)
    80004cde:	740e                	ld	s0,224(sp)
    80004ce0:	64ee                	ld	s1,216(sp)
    80004ce2:	694e                	ld	s2,208(sp)
    80004ce4:	69ae                	ld	s3,200(sp)
    80004ce6:	616d                	addi	sp,sp,240
    80004ce8:	8082                	ret

0000000080004cea <sys_open>:

uint64
sys_open(void)
{
    80004cea:	7131                	addi	sp,sp,-192
    80004cec:	fd06                	sd	ra,184(sp)
    80004cee:	f922                	sd	s0,176(sp)
    80004cf0:	f526                	sd	s1,168(sp)
    80004cf2:	f14a                	sd	s2,160(sp)
    80004cf4:	ed4e                	sd	s3,152(sp)
    80004cf6:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004cf8:	08000613          	li	a2,128
    80004cfc:	f5040593          	addi	a1,s0,-176
    80004d00:	4501                	li	a0,0
    80004d02:	ffffd097          	auipc	ra,0xffffd
    80004d06:	350080e7          	jalr	848(ra) # 80002052 <argstr>
    return -1;
    80004d0a:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004d0c:	0c054163          	bltz	a0,80004dce <sys_open+0xe4>
    80004d10:	f4c40593          	addi	a1,s0,-180
    80004d14:	4505                	li	a0,1
    80004d16:	ffffd097          	auipc	ra,0xffffd
    80004d1a:	2f8080e7          	jalr	760(ra) # 8000200e <argint>
    80004d1e:	0a054863          	bltz	a0,80004dce <sys_open+0xe4>

  begin_op();
    80004d22:	fffff097          	auipc	ra,0xfffff
    80004d26:	a14080e7          	jalr	-1516(ra) # 80003736 <begin_op>

  if(omode & O_CREATE){
    80004d2a:	f4c42783          	lw	a5,-180(s0)
    80004d2e:	2007f793          	andi	a5,a5,512
    80004d32:	cbdd                	beqz	a5,80004de8 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004d34:	4681                	li	a3,0
    80004d36:	4601                	li	a2,0
    80004d38:	4589                	li	a1,2
    80004d3a:	f5040513          	addi	a0,s0,-176
    80004d3e:	00000097          	auipc	ra,0x0
    80004d42:	970080e7          	jalr	-1680(ra) # 800046ae <create>
    80004d46:	892a                	mv	s2,a0
    if(ip == 0){
    80004d48:	c959                	beqz	a0,80004dde <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004d4a:	04c91703          	lh	a4,76(s2)
    80004d4e:	478d                	li	a5,3
    80004d50:	00f71763          	bne	a4,a5,80004d5e <sys_open+0x74>
    80004d54:	04e95703          	lhu	a4,78(s2)
    80004d58:	47a5                	li	a5,9
    80004d5a:	0ce7ec63          	bltu	a5,a4,80004e32 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004d5e:	fffff097          	auipc	ra,0xfffff
    80004d62:	de4080e7          	jalr	-540(ra) # 80003b42 <filealloc>
    80004d66:	89aa                	mv	s3,a0
    80004d68:	10050263          	beqz	a0,80004e6c <sys_open+0x182>
    80004d6c:	00000097          	auipc	ra,0x0
    80004d70:	900080e7          	jalr	-1792(ra) # 8000466c <fdalloc>
    80004d74:	84aa                	mv	s1,a0
    80004d76:	0e054663          	bltz	a0,80004e62 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004d7a:	04c91703          	lh	a4,76(s2)
    80004d7e:	478d                	li	a5,3
    80004d80:	0cf70463          	beq	a4,a5,80004e48 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004d84:	4789                	li	a5,2
    80004d86:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004d8a:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004d8e:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004d92:	f4c42783          	lw	a5,-180(s0)
    80004d96:	0017c713          	xori	a4,a5,1
    80004d9a:	8b05                	andi	a4,a4,1
    80004d9c:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004da0:	0037f713          	andi	a4,a5,3
    80004da4:	00e03733          	snez	a4,a4
    80004da8:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004dac:	4007f793          	andi	a5,a5,1024
    80004db0:	c791                	beqz	a5,80004dbc <sys_open+0xd2>
    80004db2:	04c91703          	lh	a4,76(s2)
    80004db6:	4789                	li	a5,2
    80004db8:	08f70f63          	beq	a4,a5,80004e56 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004dbc:	854a                	mv	a0,s2
    80004dbe:	ffffe097          	auipc	ra,0xffffe
    80004dc2:	05e080e7          	jalr	94(ra) # 80002e1c <iunlock>
  end_op();
    80004dc6:	fffff097          	auipc	ra,0xfffff
    80004dca:	9ee080e7          	jalr	-1554(ra) # 800037b4 <end_op>

  return fd;
}
    80004dce:	8526                	mv	a0,s1
    80004dd0:	70ea                	ld	ra,184(sp)
    80004dd2:	744a                	ld	s0,176(sp)
    80004dd4:	74aa                	ld	s1,168(sp)
    80004dd6:	790a                	ld	s2,160(sp)
    80004dd8:	69ea                	ld	s3,152(sp)
    80004dda:	6129                	addi	sp,sp,192
    80004ddc:	8082                	ret
      end_op();
    80004dde:	fffff097          	auipc	ra,0xfffff
    80004de2:	9d6080e7          	jalr	-1578(ra) # 800037b4 <end_op>
      return -1;
    80004de6:	b7e5                	j	80004dce <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004de8:	f5040513          	addi	a0,s0,-176
    80004dec:	ffffe097          	auipc	ra,0xffffe
    80004df0:	72a080e7          	jalr	1834(ra) # 80003516 <namei>
    80004df4:	892a                	mv	s2,a0
    80004df6:	c905                	beqz	a0,80004e26 <sys_open+0x13c>
    ilock(ip);
    80004df8:	ffffe097          	auipc	ra,0xffffe
    80004dfc:	f62080e7          	jalr	-158(ra) # 80002d5a <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004e00:	04c91703          	lh	a4,76(s2)
    80004e04:	4785                	li	a5,1
    80004e06:	f4f712e3          	bne	a4,a5,80004d4a <sys_open+0x60>
    80004e0a:	f4c42783          	lw	a5,-180(s0)
    80004e0e:	dba1                	beqz	a5,80004d5e <sys_open+0x74>
      iunlockput(ip);
    80004e10:	854a                	mv	a0,s2
    80004e12:	ffffe097          	auipc	ra,0xffffe
    80004e16:	1aa080e7          	jalr	426(ra) # 80002fbc <iunlockput>
      end_op();
    80004e1a:	fffff097          	auipc	ra,0xfffff
    80004e1e:	99a080e7          	jalr	-1638(ra) # 800037b4 <end_op>
      return -1;
    80004e22:	54fd                	li	s1,-1
    80004e24:	b76d                	j	80004dce <sys_open+0xe4>
      end_op();
    80004e26:	fffff097          	auipc	ra,0xfffff
    80004e2a:	98e080e7          	jalr	-1650(ra) # 800037b4 <end_op>
      return -1;
    80004e2e:	54fd                	li	s1,-1
    80004e30:	bf79                	j	80004dce <sys_open+0xe4>
    iunlockput(ip);
    80004e32:	854a                	mv	a0,s2
    80004e34:	ffffe097          	auipc	ra,0xffffe
    80004e38:	188080e7          	jalr	392(ra) # 80002fbc <iunlockput>
    end_op();
    80004e3c:	fffff097          	auipc	ra,0xfffff
    80004e40:	978080e7          	jalr	-1672(ra) # 800037b4 <end_op>
    return -1;
    80004e44:	54fd                	li	s1,-1
    80004e46:	b761                	j	80004dce <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004e48:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004e4c:	04e91783          	lh	a5,78(s2)
    80004e50:	02f99223          	sh	a5,36(s3)
    80004e54:	bf2d                	j	80004d8e <sys_open+0xa4>
    itrunc(ip);
    80004e56:	854a                	mv	a0,s2
    80004e58:	ffffe097          	auipc	ra,0xffffe
    80004e5c:	010080e7          	jalr	16(ra) # 80002e68 <itrunc>
    80004e60:	bfb1                	j	80004dbc <sys_open+0xd2>
      fileclose(f);
    80004e62:	854e                	mv	a0,s3
    80004e64:	fffff097          	auipc	ra,0xfffff
    80004e68:	d9a080e7          	jalr	-614(ra) # 80003bfe <fileclose>
    iunlockput(ip);
    80004e6c:	854a                	mv	a0,s2
    80004e6e:	ffffe097          	auipc	ra,0xffffe
    80004e72:	14e080e7          	jalr	334(ra) # 80002fbc <iunlockput>
    end_op();
    80004e76:	fffff097          	auipc	ra,0xfffff
    80004e7a:	93e080e7          	jalr	-1730(ra) # 800037b4 <end_op>
    return -1;
    80004e7e:	54fd                	li	s1,-1
    80004e80:	b7b9                	j	80004dce <sys_open+0xe4>

0000000080004e82 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004e82:	7175                	addi	sp,sp,-144
    80004e84:	e506                	sd	ra,136(sp)
    80004e86:	e122                	sd	s0,128(sp)
    80004e88:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004e8a:	fffff097          	auipc	ra,0xfffff
    80004e8e:	8ac080e7          	jalr	-1876(ra) # 80003736 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004e92:	08000613          	li	a2,128
    80004e96:	f7040593          	addi	a1,s0,-144
    80004e9a:	4501                	li	a0,0
    80004e9c:	ffffd097          	auipc	ra,0xffffd
    80004ea0:	1b6080e7          	jalr	438(ra) # 80002052 <argstr>
    80004ea4:	02054963          	bltz	a0,80004ed6 <sys_mkdir+0x54>
    80004ea8:	4681                	li	a3,0
    80004eaa:	4601                	li	a2,0
    80004eac:	4585                	li	a1,1
    80004eae:	f7040513          	addi	a0,s0,-144
    80004eb2:	fffff097          	auipc	ra,0xfffff
    80004eb6:	7fc080e7          	jalr	2044(ra) # 800046ae <create>
    80004eba:	cd11                	beqz	a0,80004ed6 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004ebc:	ffffe097          	auipc	ra,0xffffe
    80004ec0:	100080e7          	jalr	256(ra) # 80002fbc <iunlockput>
  end_op();
    80004ec4:	fffff097          	auipc	ra,0xfffff
    80004ec8:	8f0080e7          	jalr	-1808(ra) # 800037b4 <end_op>
  return 0;
    80004ecc:	4501                	li	a0,0
}
    80004ece:	60aa                	ld	ra,136(sp)
    80004ed0:	640a                	ld	s0,128(sp)
    80004ed2:	6149                	addi	sp,sp,144
    80004ed4:	8082                	ret
    end_op();
    80004ed6:	fffff097          	auipc	ra,0xfffff
    80004eda:	8de080e7          	jalr	-1826(ra) # 800037b4 <end_op>
    return -1;
    80004ede:	557d                	li	a0,-1
    80004ee0:	b7fd                	j	80004ece <sys_mkdir+0x4c>

0000000080004ee2 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004ee2:	7135                	addi	sp,sp,-160
    80004ee4:	ed06                	sd	ra,152(sp)
    80004ee6:	e922                	sd	s0,144(sp)
    80004ee8:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004eea:	fffff097          	auipc	ra,0xfffff
    80004eee:	84c080e7          	jalr	-1972(ra) # 80003736 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004ef2:	08000613          	li	a2,128
    80004ef6:	f7040593          	addi	a1,s0,-144
    80004efa:	4501                	li	a0,0
    80004efc:	ffffd097          	auipc	ra,0xffffd
    80004f00:	156080e7          	jalr	342(ra) # 80002052 <argstr>
    80004f04:	04054a63          	bltz	a0,80004f58 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004f08:	f6c40593          	addi	a1,s0,-148
    80004f0c:	4505                	li	a0,1
    80004f0e:	ffffd097          	auipc	ra,0xffffd
    80004f12:	100080e7          	jalr	256(ra) # 8000200e <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f16:	04054163          	bltz	a0,80004f58 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004f1a:	f6840593          	addi	a1,s0,-152
    80004f1e:	4509                	li	a0,2
    80004f20:	ffffd097          	auipc	ra,0xffffd
    80004f24:	0ee080e7          	jalr	238(ra) # 8000200e <argint>
     argint(1, &major) < 0 ||
    80004f28:	02054863          	bltz	a0,80004f58 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004f2c:	f6841683          	lh	a3,-152(s0)
    80004f30:	f6c41603          	lh	a2,-148(s0)
    80004f34:	458d                	li	a1,3
    80004f36:	f7040513          	addi	a0,s0,-144
    80004f3a:	fffff097          	auipc	ra,0xfffff
    80004f3e:	774080e7          	jalr	1908(ra) # 800046ae <create>
     argint(2, &minor) < 0 ||
    80004f42:	c919                	beqz	a0,80004f58 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004f44:	ffffe097          	auipc	ra,0xffffe
    80004f48:	078080e7          	jalr	120(ra) # 80002fbc <iunlockput>
  end_op();
    80004f4c:	fffff097          	auipc	ra,0xfffff
    80004f50:	868080e7          	jalr	-1944(ra) # 800037b4 <end_op>
  return 0;
    80004f54:	4501                	li	a0,0
    80004f56:	a031                	j	80004f62 <sys_mknod+0x80>
    end_op();
    80004f58:	fffff097          	auipc	ra,0xfffff
    80004f5c:	85c080e7          	jalr	-1956(ra) # 800037b4 <end_op>
    return -1;
    80004f60:	557d                	li	a0,-1
}
    80004f62:	60ea                	ld	ra,152(sp)
    80004f64:	644a                	ld	s0,144(sp)
    80004f66:	610d                	addi	sp,sp,160
    80004f68:	8082                	ret

0000000080004f6a <sys_chdir>:

uint64
sys_chdir(void)
{
    80004f6a:	7135                	addi	sp,sp,-160
    80004f6c:	ed06                	sd	ra,152(sp)
    80004f6e:	e922                	sd	s0,144(sp)
    80004f70:	e526                	sd	s1,136(sp)
    80004f72:	e14a                	sd	s2,128(sp)
    80004f74:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004f76:	ffffc097          	auipc	ra,0xffffc
    80004f7a:	fe2080e7          	jalr	-30(ra) # 80000f58 <myproc>
    80004f7e:	892a                	mv	s2,a0
  
  begin_op();
    80004f80:	ffffe097          	auipc	ra,0xffffe
    80004f84:	7b6080e7          	jalr	1974(ra) # 80003736 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004f88:	08000613          	li	a2,128
    80004f8c:	f6040593          	addi	a1,s0,-160
    80004f90:	4501                	li	a0,0
    80004f92:	ffffd097          	auipc	ra,0xffffd
    80004f96:	0c0080e7          	jalr	192(ra) # 80002052 <argstr>
    80004f9a:	04054b63          	bltz	a0,80004ff0 <sys_chdir+0x86>
    80004f9e:	f6040513          	addi	a0,s0,-160
    80004fa2:	ffffe097          	auipc	ra,0xffffe
    80004fa6:	574080e7          	jalr	1396(ra) # 80003516 <namei>
    80004faa:	84aa                	mv	s1,a0
    80004fac:	c131                	beqz	a0,80004ff0 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004fae:	ffffe097          	auipc	ra,0xffffe
    80004fb2:	dac080e7          	jalr	-596(ra) # 80002d5a <ilock>
  if(ip->type != T_DIR){
    80004fb6:	04c49703          	lh	a4,76(s1)
    80004fba:	4785                	li	a5,1
    80004fbc:	04f71063          	bne	a4,a5,80004ffc <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004fc0:	8526                	mv	a0,s1
    80004fc2:	ffffe097          	auipc	ra,0xffffe
    80004fc6:	e5a080e7          	jalr	-422(ra) # 80002e1c <iunlock>
  iput(p->cwd);
    80004fca:	15893503          	ld	a0,344(s2)
    80004fce:	ffffe097          	auipc	ra,0xffffe
    80004fd2:	f46080e7          	jalr	-186(ra) # 80002f14 <iput>
  end_op();
    80004fd6:	ffffe097          	auipc	ra,0xffffe
    80004fda:	7de080e7          	jalr	2014(ra) # 800037b4 <end_op>
  p->cwd = ip;
    80004fde:	14993c23          	sd	s1,344(s2)
  return 0;
    80004fe2:	4501                	li	a0,0
}
    80004fe4:	60ea                	ld	ra,152(sp)
    80004fe6:	644a                	ld	s0,144(sp)
    80004fe8:	64aa                	ld	s1,136(sp)
    80004fea:	690a                	ld	s2,128(sp)
    80004fec:	610d                	addi	sp,sp,160
    80004fee:	8082                	ret
    end_op();
    80004ff0:	ffffe097          	auipc	ra,0xffffe
    80004ff4:	7c4080e7          	jalr	1988(ra) # 800037b4 <end_op>
    return -1;
    80004ff8:	557d                	li	a0,-1
    80004ffa:	b7ed                	j	80004fe4 <sys_chdir+0x7a>
    iunlockput(ip);
    80004ffc:	8526                	mv	a0,s1
    80004ffe:	ffffe097          	auipc	ra,0xffffe
    80005002:	fbe080e7          	jalr	-66(ra) # 80002fbc <iunlockput>
    end_op();
    80005006:	ffffe097          	auipc	ra,0xffffe
    8000500a:	7ae080e7          	jalr	1966(ra) # 800037b4 <end_op>
    return -1;
    8000500e:	557d                	li	a0,-1
    80005010:	bfd1                	j	80004fe4 <sys_chdir+0x7a>

0000000080005012 <sys_exec>:

uint64
sys_exec(void)
{
    80005012:	7145                	addi	sp,sp,-464
    80005014:	e786                	sd	ra,456(sp)
    80005016:	e3a2                	sd	s0,448(sp)
    80005018:	ff26                	sd	s1,440(sp)
    8000501a:	fb4a                	sd	s2,432(sp)
    8000501c:	f74e                	sd	s3,424(sp)
    8000501e:	f352                	sd	s4,416(sp)
    80005020:	ef56                	sd	s5,408(sp)
    80005022:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005024:	08000613          	li	a2,128
    80005028:	f4040593          	addi	a1,s0,-192
    8000502c:	4501                	li	a0,0
    8000502e:	ffffd097          	auipc	ra,0xffffd
    80005032:	024080e7          	jalr	36(ra) # 80002052 <argstr>
    return -1;
    80005036:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005038:	0c054b63          	bltz	a0,8000510e <sys_exec+0xfc>
    8000503c:	e3840593          	addi	a1,s0,-456
    80005040:	4505                	li	a0,1
    80005042:	ffffd097          	auipc	ra,0xffffd
    80005046:	fee080e7          	jalr	-18(ra) # 80002030 <argaddr>
    8000504a:	0c054263          	bltz	a0,8000510e <sys_exec+0xfc>
  }
  memset(argv, 0, sizeof(argv));
    8000504e:	10000613          	li	a2,256
    80005052:	4581                	li	a1,0
    80005054:	e4040513          	addi	a0,s0,-448
    80005058:	ffffb097          	auipc	ra,0xffffb
    8000505c:	226080e7          	jalr	550(ra) # 8000027e <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005060:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80005064:	89a6                	mv	s3,s1
    80005066:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005068:	02000a13          	li	s4,32
    8000506c:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005070:	00391513          	slli	a0,s2,0x3
    80005074:	e3040593          	addi	a1,s0,-464
    80005078:	e3843783          	ld	a5,-456(s0)
    8000507c:	953e                	add	a0,a0,a5
    8000507e:	ffffd097          	auipc	ra,0xffffd
    80005082:	ef6080e7          	jalr	-266(ra) # 80001f74 <fetchaddr>
    80005086:	02054a63          	bltz	a0,800050ba <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    8000508a:	e3043783          	ld	a5,-464(s0)
    8000508e:	c3b9                	beqz	a5,800050d4 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005090:	ffffb097          	auipc	ra,0xffffb
    80005094:	0e6080e7          	jalr	230(ra) # 80000176 <kalloc>
    80005098:	85aa                	mv	a1,a0
    8000509a:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    8000509e:	cd11                	beqz	a0,800050ba <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800050a0:	6605                	lui	a2,0x1
    800050a2:	e3043503          	ld	a0,-464(s0)
    800050a6:	ffffd097          	auipc	ra,0xffffd
    800050aa:	f20080e7          	jalr	-224(ra) # 80001fc6 <fetchstr>
    800050ae:	00054663          	bltz	a0,800050ba <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    800050b2:	0905                	addi	s2,s2,1
    800050b4:	09a1                	addi	s3,s3,8
    800050b6:	fb491be3          	bne	s2,s4,8000506c <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050ba:	f4040913          	addi	s2,s0,-192
    800050be:	6088                	ld	a0,0(s1)
    800050c0:	c531                	beqz	a0,8000510c <sys_exec+0xfa>
    kfree(argv[i]);
    800050c2:	ffffb097          	auipc	ra,0xffffb
    800050c6:	f5a080e7          	jalr	-166(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050ca:	04a1                	addi	s1,s1,8
    800050cc:	ff2499e3          	bne	s1,s2,800050be <sys_exec+0xac>
  return -1;
    800050d0:	597d                	li	s2,-1
    800050d2:	a835                	j	8000510e <sys_exec+0xfc>
      argv[i] = 0;
    800050d4:	0a8e                	slli	s5,s5,0x3
    800050d6:	fc0a8793          	addi	a5,s5,-64 # ffffffffffffefc0 <end+0xffffffff7ffd3d78>
    800050da:	00878ab3          	add	s5,a5,s0
    800050de:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    800050e2:	e4040593          	addi	a1,s0,-448
    800050e6:	f4040513          	addi	a0,s0,-192
    800050ea:	fffff097          	auipc	ra,0xfffff
    800050ee:	172080e7          	jalr	370(ra) # 8000425c <exec>
    800050f2:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050f4:	f4040993          	addi	s3,s0,-192
    800050f8:	6088                	ld	a0,0(s1)
    800050fa:	c911                	beqz	a0,8000510e <sys_exec+0xfc>
    kfree(argv[i]);
    800050fc:	ffffb097          	auipc	ra,0xffffb
    80005100:	f20080e7          	jalr	-224(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005104:	04a1                	addi	s1,s1,8
    80005106:	ff3499e3          	bne	s1,s3,800050f8 <sys_exec+0xe6>
    8000510a:	a011                	j	8000510e <sys_exec+0xfc>
  return -1;
    8000510c:	597d                	li	s2,-1
}
    8000510e:	854a                	mv	a0,s2
    80005110:	60be                	ld	ra,456(sp)
    80005112:	641e                	ld	s0,448(sp)
    80005114:	74fa                	ld	s1,440(sp)
    80005116:	795a                	ld	s2,432(sp)
    80005118:	79ba                	ld	s3,424(sp)
    8000511a:	7a1a                	ld	s4,416(sp)
    8000511c:	6afa                	ld	s5,408(sp)
    8000511e:	6179                	addi	sp,sp,464
    80005120:	8082                	ret

0000000080005122 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005122:	7139                	addi	sp,sp,-64
    80005124:	fc06                	sd	ra,56(sp)
    80005126:	f822                	sd	s0,48(sp)
    80005128:	f426                	sd	s1,40(sp)
    8000512a:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    8000512c:	ffffc097          	auipc	ra,0xffffc
    80005130:	e2c080e7          	jalr	-468(ra) # 80000f58 <myproc>
    80005134:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80005136:	fd840593          	addi	a1,s0,-40
    8000513a:	4501                	li	a0,0
    8000513c:	ffffd097          	auipc	ra,0xffffd
    80005140:	ef4080e7          	jalr	-268(ra) # 80002030 <argaddr>
    return -1;
    80005144:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80005146:	0e054063          	bltz	a0,80005226 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    8000514a:	fc840593          	addi	a1,s0,-56
    8000514e:	fd040513          	addi	a0,s0,-48
    80005152:	fffff097          	auipc	ra,0xfffff
    80005156:	ddc080e7          	jalr	-548(ra) # 80003f2e <pipealloc>
    return -1;
    8000515a:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    8000515c:	0c054563          	bltz	a0,80005226 <sys_pipe+0x104>
  fd0 = -1;
    80005160:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005164:	fd043503          	ld	a0,-48(s0)
    80005168:	fffff097          	auipc	ra,0xfffff
    8000516c:	504080e7          	jalr	1284(ra) # 8000466c <fdalloc>
    80005170:	fca42223          	sw	a0,-60(s0)
    80005174:	08054c63          	bltz	a0,8000520c <sys_pipe+0xea>
    80005178:	fc843503          	ld	a0,-56(s0)
    8000517c:	fffff097          	auipc	ra,0xfffff
    80005180:	4f0080e7          	jalr	1264(ra) # 8000466c <fdalloc>
    80005184:	fca42023          	sw	a0,-64(s0)
    80005188:	06054963          	bltz	a0,800051fa <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000518c:	4691                	li	a3,4
    8000518e:	fc440613          	addi	a2,s0,-60
    80005192:	fd843583          	ld	a1,-40(s0)
    80005196:	6ca8                	ld	a0,88(s1)
    80005198:	ffffc097          	auipc	ra,0xffffc
    8000519c:	a84080e7          	jalr	-1404(ra) # 80000c1c <copyout>
    800051a0:	02054063          	bltz	a0,800051c0 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800051a4:	4691                	li	a3,4
    800051a6:	fc040613          	addi	a2,s0,-64
    800051aa:	fd843583          	ld	a1,-40(s0)
    800051ae:	0591                	addi	a1,a1,4
    800051b0:	6ca8                	ld	a0,88(s1)
    800051b2:	ffffc097          	auipc	ra,0xffffc
    800051b6:	a6a080e7          	jalr	-1430(ra) # 80000c1c <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800051ba:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800051bc:	06055563          	bgez	a0,80005226 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    800051c0:	fc442783          	lw	a5,-60(s0)
    800051c4:	07e9                	addi	a5,a5,26
    800051c6:	078e                	slli	a5,a5,0x3
    800051c8:	97a6                	add	a5,a5,s1
    800051ca:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    800051ce:	fc042783          	lw	a5,-64(s0)
    800051d2:	07e9                	addi	a5,a5,26
    800051d4:	078e                	slli	a5,a5,0x3
    800051d6:	00f48533          	add	a0,s1,a5
    800051da:	00053423          	sd	zero,8(a0)
    fileclose(rf);
    800051de:	fd043503          	ld	a0,-48(s0)
    800051e2:	fffff097          	auipc	ra,0xfffff
    800051e6:	a1c080e7          	jalr	-1508(ra) # 80003bfe <fileclose>
    fileclose(wf);
    800051ea:	fc843503          	ld	a0,-56(s0)
    800051ee:	fffff097          	auipc	ra,0xfffff
    800051f2:	a10080e7          	jalr	-1520(ra) # 80003bfe <fileclose>
    return -1;
    800051f6:	57fd                	li	a5,-1
    800051f8:	a03d                	j	80005226 <sys_pipe+0x104>
    if(fd0 >= 0)
    800051fa:	fc442783          	lw	a5,-60(s0)
    800051fe:	0007c763          	bltz	a5,8000520c <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005202:	07e9                	addi	a5,a5,26
    80005204:	078e                	slli	a5,a5,0x3
    80005206:	97a6                	add	a5,a5,s1
    80005208:	0007b423          	sd	zero,8(a5)
    fileclose(rf);
    8000520c:	fd043503          	ld	a0,-48(s0)
    80005210:	fffff097          	auipc	ra,0xfffff
    80005214:	9ee080e7          	jalr	-1554(ra) # 80003bfe <fileclose>
    fileclose(wf);
    80005218:	fc843503          	ld	a0,-56(s0)
    8000521c:	fffff097          	auipc	ra,0xfffff
    80005220:	9e2080e7          	jalr	-1566(ra) # 80003bfe <fileclose>
    return -1;
    80005224:	57fd                	li	a5,-1
}
    80005226:	853e                	mv	a0,a5
    80005228:	70e2                	ld	ra,56(sp)
    8000522a:	7442                	ld	s0,48(sp)
    8000522c:	74a2                	ld	s1,40(sp)
    8000522e:	6121                	addi	sp,sp,64
    80005230:	8082                	ret
	...

0000000080005240 <kernelvec>:
    80005240:	7111                	addi	sp,sp,-256
    80005242:	e006                	sd	ra,0(sp)
    80005244:	e40a                	sd	sp,8(sp)
    80005246:	e80e                	sd	gp,16(sp)
    80005248:	ec12                	sd	tp,24(sp)
    8000524a:	f016                	sd	t0,32(sp)
    8000524c:	f41a                	sd	t1,40(sp)
    8000524e:	f81e                	sd	t2,48(sp)
    80005250:	fc22                	sd	s0,56(sp)
    80005252:	e0a6                	sd	s1,64(sp)
    80005254:	e4aa                	sd	a0,72(sp)
    80005256:	e8ae                	sd	a1,80(sp)
    80005258:	ecb2                	sd	a2,88(sp)
    8000525a:	f0b6                	sd	a3,96(sp)
    8000525c:	f4ba                	sd	a4,104(sp)
    8000525e:	f8be                	sd	a5,112(sp)
    80005260:	fcc2                	sd	a6,120(sp)
    80005262:	e146                	sd	a7,128(sp)
    80005264:	e54a                	sd	s2,136(sp)
    80005266:	e94e                	sd	s3,144(sp)
    80005268:	ed52                	sd	s4,152(sp)
    8000526a:	f156                	sd	s5,160(sp)
    8000526c:	f55a                	sd	s6,168(sp)
    8000526e:	f95e                	sd	s7,176(sp)
    80005270:	fd62                	sd	s8,184(sp)
    80005272:	e1e6                	sd	s9,192(sp)
    80005274:	e5ea                	sd	s10,200(sp)
    80005276:	e9ee                	sd	s11,208(sp)
    80005278:	edf2                	sd	t3,216(sp)
    8000527a:	f1f6                	sd	t4,224(sp)
    8000527c:	f5fa                	sd	t5,232(sp)
    8000527e:	f9fe                	sd	t6,240(sp)
    80005280:	bc1fc0ef          	jal	ra,80001e40 <kerneltrap>
    80005284:	6082                	ld	ra,0(sp)
    80005286:	6122                	ld	sp,8(sp)
    80005288:	61c2                	ld	gp,16(sp)
    8000528a:	7282                	ld	t0,32(sp)
    8000528c:	7322                	ld	t1,40(sp)
    8000528e:	73c2                	ld	t2,48(sp)
    80005290:	7462                	ld	s0,56(sp)
    80005292:	6486                	ld	s1,64(sp)
    80005294:	6526                	ld	a0,72(sp)
    80005296:	65c6                	ld	a1,80(sp)
    80005298:	6666                	ld	a2,88(sp)
    8000529a:	7686                	ld	a3,96(sp)
    8000529c:	7726                	ld	a4,104(sp)
    8000529e:	77c6                	ld	a5,112(sp)
    800052a0:	7866                	ld	a6,120(sp)
    800052a2:	688a                	ld	a7,128(sp)
    800052a4:	692a                	ld	s2,136(sp)
    800052a6:	69ca                	ld	s3,144(sp)
    800052a8:	6a6a                	ld	s4,152(sp)
    800052aa:	7a8a                	ld	s5,160(sp)
    800052ac:	7b2a                	ld	s6,168(sp)
    800052ae:	7bca                	ld	s7,176(sp)
    800052b0:	7c6a                	ld	s8,184(sp)
    800052b2:	6c8e                	ld	s9,192(sp)
    800052b4:	6d2e                	ld	s10,200(sp)
    800052b6:	6dce                	ld	s11,208(sp)
    800052b8:	6e6e                	ld	t3,216(sp)
    800052ba:	7e8e                	ld	t4,224(sp)
    800052bc:	7f2e                	ld	t5,232(sp)
    800052be:	7fce                	ld	t6,240(sp)
    800052c0:	6111                	addi	sp,sp,256
    800052c2:	10200073          	sret
    800052c6:	00000013          	nop
    800052ca:	00000013          	nop
    800052ce:	0001                	nop

00000000800052d0 <timervec>:
    800052d0:	34051573          	csrrw	a0,mscratch,a0
    800052d4:	e10c                	sd	a1,0(a0)
    800052d6:	e510                	sd	a2,8(a0)
    800052d8:	e914                	sd	a3,16(a0)
    800052da:	6d0c                	ld	a1,24(a0)
    800052dc:	7110                	ld	a2,32(a0)
    800052de:	6194                	ld	a3,0(a1)
    800052e0:	96b2                	add	a3,a3,a2
    800052e2:	e194                	sd	a3,0(a1)
    800052e4:	4589                	li	a1,2
    800052e6:	14459073          	csrw	sip,a1
    800052ea:	6914                	ld	a3,16(a0)
    800052ec:	6510                	ld	a2,8(a0)
    800052ee:	610c                	ld	a1,0(a0)
    800052f0:	34051573          	csrrw	a0,mscratch,a0
    800052f4:	30200073          	mret
	...

00000000800052fa <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800052fa:	1141                	addi	sp,sp,-16
    800052fc:	e422                	sd	s0,8(sp)
    800052fe:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005300:	0c0007b7          	lui	a5,0xc000
    80005304:	4705                	li	a4,1
    80005306:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005308:	c3d8                	sw	a4,4(a5)
}
    8000530a:	6422                	ld	s0,8(sp)
    8000530c:	0141                	addi	sp,sp,16
    8000530e:	8082                	ret

0000000080005310 <plicinithart>:

void
plicinithart(void)
{
    80005310:	1141                	addi	sp,sp,-16
    80005312:	e406                	sd	ra,8(sp)
    80005314:	e022                	sd	s0,0(sp)
    80005316:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005318:	ffffc097          	auipc	ra,0xffffc
    8000531c:	c14080e7          	jalr	-1004(ra) # 80000f2c <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005320:	0085171b          	slliw	a4,a0,0x8
    80005324:	0c0027b7          	lui	a5,0xc002
    80005328:	97ba                	add	a5,a5,a4
    8000532a:	40200713          	li	a4,1026
    8000532e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005332:	00d5151b          	slliw	a0,a0,0xd
    80005336:	0c2017b7          	lui	a5,0xc201
    8000533a:	97aa                	add	a5,a5,a0
    8000533c:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005340:	60a2                	ld	ra,8(sp)
    80005342:	6402                	ld	s0,0(sp)
    80005344:	0141                	addi	sp,sp,16
    80005346:	8082                	ret

0000000080005348 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005348:	1141                	addi	sp,sp,-16
    8000534a:	e406                	sd	ra,8(sp)
    8000534c:	e022                	sd	s0,0(sp)
    8000534e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005350:	ffffc097          	auipc	ra,0xffffc
    80005354:	bdc080e7          	jalr	-1060(ra) # 80000f2c <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005358:	00d5151b          	slliw	a0,a0,0xd
    8000535c:	0c2017b7          	lui	a5,0xc201
    80005360:	97aa                	add	a5,a5,a0
  return irq;
}
    80005362:	43c8                	lw	a0,4(a5)
    80005364:	60a2                	ld	ra,8(sp)
    80005366:	6402                	ld	s0,0(sp)
    80005368:	0141                	addi	sp,sp,16
    8000536a:	8082                	ret

000000008000536c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000536c:	1101                	addi	sp,sp,-32
    8000536e:	ec06                	sd	ra,24(sp)
    80005370:	e822                	sd	s0,16(sp)
    80005372:	e426                	sd	s1,8(sp)
    80005374:	1000                	addi	s0,sp,32
    80005376:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005378:	ffffc097          	auipc	ra,0xffffc
    8000537c:	bb4080e7          	jalr	-1100(ra) # 80000f2c <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005380:	00d5151b          	slliw	a0,a0,0xd
    80005384:	0c2017b7          	lui	a5,0xc201
    80005388:	97aa                	add	a5,a5,a0
    8000538a:	c3c4                	sw	s1,4(a5)
}
    8000538c:	60e2                	ld	ra,24(sp)
    8000538e:	6442                	ld	s0,16(sp)
    80005390:	64a2                	ld	s1,8(sp)
    80005392:	6105                	addi	sp,sp,32
    80005394:	8082                	ret

0000000080005396 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005396:	1141                	addi	sp,sp,-16
    80005398:	e406                	sd	ra,8(sp)
    8000539a:	e022                	sd	s0,0(sp)
    8000539c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000539e:	479d                	li	a5,7
    800053a0:	06a7c863          	blt	a5,a0,80005410 <free_desc+0x7a>
    panic("free_desc 1");
  if(disk.free[i])
    800053a4:	00019717          	auipc	a4,0x19
    800053a8:	c5c70713          	addi	a4,a4,-932 # 8001e000 <disk>
    800053ac:	972a                	add	a4,a4,a0
    800053ae:	6789                	lui	a5,0x2
    800053b0:	97ba                	add	a5,a5,a4
    800053b2:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    800053b6:	e7ad                	bnez	a5,80005420 <free_desc+0x8a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800053b8:	00451793          	slli	a5,a0,0x4
    800053bc:	0001b717          	auipc	a4,0x1b
    800053c0:	c4470713          	addi	a4,a4,-956 # 80020000 <disk+0x2000>
    800053c4:	6314                	ld	a3,0(a4)
    800053c6:	96be                	add	a3,a3,a5
    800053c8:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800053cc:	6314                	ld	a3,0(a4)
    800053ce:	96be                	add	a3,a3,a5
    800053d0:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    800053d4:	6314                	ld	a3,0(a4)
    800053d6:	96be                	add	a3,a3,a5
    800053d8:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    800053dc:	6318                	ld	a4,0(a4)
    800053de:	97ba                	add	a5,a5,a4
    800053e0:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    800053e4:	00019717          	auipc	a4,0x19
    800053e8:	c1c70713          	addi	a4,a4,-996 # 8001e000 <disk>
    800053ec:	972a                	add	a4,a4,a0
    800053ee:	6789                	lui	a5,0x2
    800053f0:	97ba                	add	a5,a5,a4
    800053f2:	4705                	li	a4,1
    800053f4:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    800053f8:	0001b517          	auipc	a0,0x1b
    800053fc:	c2050513          	addi	a0,a0,-992 # 80020018 <disk+0x2018>
    80005400:	ffffc097          	auipc	ra,0xffffc
    80005404:	3a8080e7          	jalr	936(ra) # 800017a8 <wakeup>
}
    80005408:	60a2                	ld	ra,8(sp)
    8000540a:	6402                	ld	s0,0(sp)
    8000540c:	0141                	addi	sp,sp,16
    8000540e:	8082                	ret
    panic("free_desc 1");
    80005410:	00003517          	auipc	a0,0x3
    80005414:	2d850513          	addi	a0,a0,728 # 800086e8 <syscalls+0x320>
    80005418:	00001097          	auipc	ra,0x1
    8000541c:	cfc080e7          	jalr	-772(ra) # 80006114 <panic>
    panic("free_desc 2");
    80005420:	00003517          	auipc	a0,0x3
    80005424:	2d850513          	addi	a0,a0,728 # 800086f8 <syscalls+0x330>
    80005428:	00001097          	auipc	ra,0x1
    8000542c:	cec080e7          	jalr	-788(ra) # 80006114 <panic>

0000000080005430 <virtio_disk_init>:
{
    80005430:	1101                	addi	sp,sp,-32
    80005432:	ec06                	sd	ra,24(sp)
    80005434:	e822                	sd	s0,16(sp)
    80005436:	e426                	sd	s1,8(sp)
    80005438:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000543a:	00003597          	auipc	a1,0x3
    8000543e:	2ce58593          	addi	a1,a1,718 # 80008708 <syscalls+0x340>
    80005442:	0001b517          	auipc	a0,0x1b
    80005446:	ce650513          	addi	a0,a0,-794 # 80020128 <disk+0x2128>
    8000544a:	00001097          	auipc	ra,0x1
    8000544e:	368080e7          	jalr	872(ra) # 800067b2 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005452:	100017b7          	lui	a5,0x10001
    80005456:	4398                	lw	a4,0(a5)
    80005458:	2701                	sext.w	a4,a4
    8000545a:	747277b7          	lui	a5,0x74727
    8000545e:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005462:	0ef71063          	bne	a4,a5,80005542 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005466:	100017b7          	lui	a5,0x10001
    8000546a:	43dc                	lw	a5,4(a5)
    8000546c:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000546e:	4705                	li	a4,1
    80005470:	0ce79963          	bne	a5,a4,80005542 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005474:	100017b7          	lui	a5,0x10001
    80005478:	479c                	lw	a5,8(a5)
    8000547a:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    8000547c:	4709                	li	a4,2
    8000547e:	0ce79263          	bne	a5,a4,80005542 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005482:	100017b7          	lui	a5,0x10001
    80005486:	47d8                	lw	a4,12(a5)
    80005488:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000548a:	554d47b7          	lui	a5,0x554d4
    8000548e:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005492:	0af71863          	bne	a4,a5,80005542 <virtio_disk_init+0x112>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005496:	100017b7          	lui	a5,0x10001
    8000549a:	4705                	li	a4,1
    8000549c:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000549e:	470d                	li	a4,3
    800054a0:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800054a2:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800054a4:	c7ffe6b7          	lui	a3,0xc7ffe
    800054a8:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fd3517>
    800054ac:	8f75                	and	a4,a4,a3
    800054ae:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800054b0:	472d                	li	a4,11
    800054b2:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800054b4:	473d                	li	a4,15
    800054b6:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    800054b8:	6705                	lui	a4,0x1
    800054ba:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800054bc:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800054c0:	5bdc                	lw	a5,52(a5)
    800054c2:	2781                	sext.w	a5,a5
  if(max == 0)
    800054c4:	c7d9                	beqz	a5,80005552 <virtio_disk_init+0x122>
  if(max < NUM)
    800054c6:	471d                	li	a4,7
    800054c8:	08f77d63          	bgeu	a4,a5,80005562 <virtio_disk_init+0x132>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800054cc:	100014b7          	lui	s1,0x10001
    800054d0:	47a1                	li	a5,8
    800054d2:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    800054d4:	6609                	lui	a2,0x2
    800054d6:	4581                	li	a1,0
    800054d8:	00019517          	auipc	a0,0x19
    800054dc:	b2850513          	addi	a0,a0,-1240 # 8001e000 <disk>
    800054e0:	ffffb097          	auipc	ra,0xffffb
    800054e4:	d9e080e7          	jalr	-610(ra) # 8000027e <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    800054e8:	00019717          	auipc	a4,0x19
    800054ec:	b1870713          	addi	a4,a4,-1256 # 8001e000 <disk>
    800054f0:	00c75793          	srli	a5,a4,0xc
    800054f4:	2781                	sext.w	a5,a5
    800054f6:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    800054f8:	0001b797          	auipc	a5,0x1b
    800054fc:	b0878793          	addi	a5,a5,-1272 # 80020000 <disk+0x2000>
    80005500:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005502:	00019717          	auipc	a4,0x19
    80005506:	b7e70713          	addi	a4,a4,-1154 # 8001e080 <disk+0x80>
    8000550a:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    8000550c:	0001a717          	auipc	a4,0x1a
    80005510:	af470713          	addi	a4,a4,-1292 # 8001f000 <disk+0x1000>
    80005514:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80005516:	4705                	li	a4,1
    80005518:	00e78c23          	sb	a4,24(a5)
    8000551c:	00e78ca3          	sb	a4,25(a5)
    80005520:	00e78d23          	sb	a4,26(a5)
    80005524:	00e78da3          	sb	a4,27(a5)
    80005528:	00e78e23          	sb	a4,28(a5)
    8000552c:	00e78ea3          	sb	a4,29(a5)
    80005530:	00e78f23          	sb	a4,30(a5)
    80005534:	00e78fa3          	sb	a4,31(a5)
}
    80005538:	60e2                	ld	ra,24(sp)
    8000553a:	6442                	ld	s0,16(sp)
    8000553c:	64a2                	ld	s1,8(sp)
    8000553e:	6105                	addi	sp,sp,32
    80005540:	8082                	ret
    panic("could not find virtio disk");
    80005542:	00003517          	auipc	a0,0x3
    80005546:	1d650513          	addi	a0,a0,470 # 80008718 <syscalls+0x350>
    8000554a:	00001097          	auipc	ra,0x1
    8000554e:	bca080e7          	jalr	-1078(ra) # 80006114 <panic>
    panic("virtio disk has no queue 0");
    80005552:	00003517          	auipc	a0,0x3
    80005556:	1e650513          	addi	a0,a0,486 # 80008738 <syscalls+0x370>
    8000555a:	00001097          	auipc	ra,0x1
    8000555e:	bba080e7          	jalr	-1094(ra) # 80006114 <panic>
    panic("virtio disk max queue too short");
    80005562:	00003517          	auipc	a0,0x3
    80005566:	1f650513          	addi	a0,a0,502 # 80008758 <syscalls+0x390>
    8000556a:	00001097          	auipc	ra,0x1
    8000556e:	baa080e7          	jalr	-1110(ra) # 80006114 <panic>

0000000080005572 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005572:	7119                	addi	sp,sp,-128
    80005574:	fc86                	sd	ra,120(sp)
    80005576:	f8a2                	sd	s0,112(sp)
    80005578:	f4a6                	sd	s1,104(sp)
    8000557a:	f0ca                	sd	s2,96(sp)
    8000557c:	ecce                	sd	s3,88(sp)
    8000557e:	e8d2                	sd	s4,80(sp)
    80005580:	e4d6                	sd	s5,72(sp)
    80005582:	e0da                	sd	s6,64(sp)
    80005584:	fc5e                	sd	s7,56(sp)
    80005586:	f862                	sd	s8,48(sp)
    80005588:	f466                	sd	s9,40(sp)
    8000558a:	f06a                	sd	s10,32(sp)
    8000558c:	ec6e                	sd	s11,24(sp)
    8000558e:	0100                	addi	s0,sp,128
    80005590:	8aaa                	mv	s5,a0
    80005592:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005594:	00c52c83          	lw	s9,12(a0)
    80005598:	001c9c9b          	slliw	s9,s9,0x1
    8000559c:	1c82                	slli	s9,s9,0x20
    8000559e:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800055a2:	0001b517          	auipc	a0,0x1b
    800055a6:	b8650513          	addi	a0,a0,-1146 # 80020128 <disk+0x2128>
    800055aa:	00001097          	auipc	ra,0x1
    800055ae:	08c080e7          	jalr	140(ra) # 80006636 <acquire>
  for(int i = 0; i < 3; i++){
    800055b2:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800055b4:	44a1                	li	s1,8
      disk.free[i] = 0;
    800055b6:	00019c17          	auipc	s8,0x19
    800055ba:	a4ac0c13          	addi	s8,s8,-1462 # 8001e000 <disk>
    800055be:	6b89                	lui	s7,0x2
  for(int i = 0; i < 3; i++){
    800055c0:	4b0d                	li	s6,3
    800055c2:	a0ad                	j	8000562c <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    800055c4:	00fc0733          	add	a4,s8,a5
    800055c8:	975e                	add	a4,a4,s7
    800055ca:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800055ce:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800055d0:	0207c563          	bltz	a5,800055fa <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    800055d4:	2905                	addiw	s2,s2,1
    800055d6:	0611                	addi	a2,a2,4 # 2004 <_entry-0x7fffdffc>
    800055d8:	19690c63          	beq	s2,s6,80005770 <virtio_disk_rw+0x1fe>
    idx[i] = alloc_desc();
    800055dc:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800055de:	0001b717          	auipc	a4,0x1b
    800055e2:	a3a70713          	addi	a4,a4,-1478 # 80020018 <disk+0x2018>
    800055e6:	87ce                	mv	a5,s3
    if(disk.free[i]){
    800055e8:	00074683          	lbu	a3,0(a4)
    800055ec:	fee1                	bnez	a3,800055c4 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    800055ee:	2785                	addiw	a5,a5,1
    800055f0:	0705                	addi	a4,a4,1
    800055f2:	fe979be3          	bne	a5,s1,800055e8 <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    800055f6:	57fd                	li	a5,-1
    800055f8:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    800055fa:	01205d63          	blez	s2,80005614 <virtio_disk_rw+0xa2>
    800055fe:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    80005600:	000a2503          	lw	a0,0(s4)
    80005604:	00000097          	auipc	ra,0x0
    80005608:	d92080e7          	jalr	-622(ra) # 80005396 <free_desc>
      for(int j = 0; j < i; j++)
    8000560c:	2d85                	addiw	s11,s11,1
    8000560e:	0a11                	addi	s4,s4,4
    80005610:	ff2d98e3          	bne	s11,s2,80005600 <virtio_disk_rw+0x8e>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005614:	0001b597          	auipc	a1,0x1b
    80005618:	b1458593          	addi	a1,a1,-1260 # 80020128 <disk+0x2128>
    8000561c:	0001b517          	auipc	a0,0x1b
    80005620:	9fc50513          	addi	a0,a0,-1540 # 80020018 <disk+0x2018>
    80005624:	ffffc097          	auipc	ra,0xffffc
    80005628:	ff8080e7          	jalr	-8(ra) # 8000161c <sleep>
  for(int i = 0; i < 3; i++){
    8000562c:	f8040a13          	addi	s4,s0,-128
{
    80005630:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    80005632:	894e                	mv	s2,s3
    80005634:	b765                	j	800055dc <virtio_disk_rw+0x6a>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80005636:	0001b697          	auipc	a3,0x1b
    8000563a:	9ca6b683          	ld	a3,-1590(a3) # 80020000 <disk+0x2000>
    8000563e:	96ba                	add	a3,a3,a4
    80005640:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005644:	00019817          	auipc	a6,0x19
    80005648:	9bc80813          	addi	a6,a6,-1604 # 8001e000 <disk>
    8000564c:	0001b697          	auipc	a3,0x1b
    80005650:	9b468693          	addi	a3,a3,-1612 # 80020000 <disk+0x2000>
    80005654:	6290                	ld	a2,0(a3)
    80005656:	963a                	add	a2,a2,a4
    80005658:	00c65583          	lhu	a1,12(a2)
    8000565c:	0015e593          	ori	a1,a1,1
    80005660:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[1]].next = idx[2];
    80005664:	f8842603          	lw	a2,-120(s0)
    80005668:	628c                	ld	a1,0(a3)
    8000566a:	972e                	add	a4,a4,a1
    8000566c:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005670:	20050593          	addi	a1,a0,512
    80005674:	0592                	slli	a1,a1,0x4
    80005676:	95c2                	add	a1,a1,a6
    80005678:	577d                	li	a4,-1
    8000567a:	02e58823          	sb	a4,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000567e:	00461713          	slli	a4,a2,0x4
    80005682:	6290                	ld	a2,0(a3)
    80005684:	963a                	add	a2,a2,a4
    80005686:	03078793          	addi	a5,a5,48
    8000568a:	97c2                	add	a5,a5,a6
    8000568c:	e21c                	sd	a5,0(a2)
  disk.desc[idx[2]].len = 1;
    8000568e:	629c                	ld	a5,0(a3)
    80005690:	97ba                	add	a5,a5,a4
    80005692:	4605                	li	a2,1
    80005694:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005696:	629c                	ld	a5,0(a3)
    80005698:	97ba                	add	a5,a5,a4
    8000569a:	4809                	li	a6,2
    8000569c:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    800056a0:	629c                	ld	a5,0(a3)
    800056a2:	97ba                	add	a5,a5,a4
    800056a4:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800056a8:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    800056ac:	0355b423          	sd	s5,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800056b0:	6698                	ld	a4,8(a3)
    800056b2:	00275783          	lhu	a5,2(a4)
    800056b6:	8b9d                	andi	a5,a5,7
    800056b8:	0786                	slli	a5,a5,0x1
    800056ba:	973e                	add	a4,a4,a5
    800056bc:	00a71223          	sh	a0,4(a4)

  __sync_synchronize();
    800056c0:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800056c4:	6698                	ld	a4,8(a3)
    800056c6:	00275783          	lhu	a5,2(a4)
    800056ca:	2785                	addiw	a5,a5,1
    800056cc:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800056d0:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800056d4:	100017b7          	lui	a5,0x10001
    800056d8:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800056dc:	004aa783          	lw	a5,4(s5)
    800056e0:	02c79163          	bne	a5,a2,80005702 <virtio_disk_rw+0x190>
    sleep(b, &disk.vdisk_lock);
    800056e4:	0001b917          	auipc	s2,0x1b
    800056e8:	a4490913          	addi	s2,s2,-1468 # 80020128 <disk+0x2128>
  while(b->disk == 1) {
    800056ec:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800056ee:	85ca                	mv	a1,s2
    800056f0:	8556                	mv	a0,s5
    800056f2:	ffffc097          	auipc	ra,0xffffc
    800056f6:	f2a080e7          	jalr	-214(ra) # 8000161c <sleep>
  while(b->disk == 1) {
    800056fa:	004aa783          	lw	a5,4(s5)
    800056fe:	fe9788e3          	beq	a5,s1,800056ee <virtio_disk_rw+0x17c>
  }

  disk.info[idx[0]].b = 0;
    80005702:	f8042903          	lw	s2,-128(s0)
    80005706:	20090713          	addi	a4,s2,512
    8000570a:	0712                	slli	a4,a4,0x4
    8000570c:	00019797          	auipc	a5,0x19
    80005710:	8f478793          	addi	a5,a5,-1804 # 8001e000 <disk>
    80005714:	97ba                	add	a5,a5,a4
    80005716:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    8000571a:	0001b997          	auipc	s3,0x1b
    8000571e:	8e698993          	addi	s3,s3,-1818 # 80020000 <disk+0x2000>
    80005722:	00491713          	slli	a4,s2,0x4
    80005726:	0009b783          	ld	a5,0(s3)
    8000572a:	97ba                	add	a5,a5,a4
    8000572c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005730:	854a                	mv	a0,s2
    80005732:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005736:	00000097          	auipc	ra,0x0
    8000573a:	c60080e7          	jalr	-928(ra) # 80005396 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000573e:	8885                	andi	s1,s1,1
    80005740:	f0ed                	bnez	s1,80005722 <virtio_disk_rw+0x1b0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005742:	0001b517          	auipc	a0,0x1b
    80005746:	9e650513          	addi	a0,a0,-1562 # 80020128 <disk+0x2128>
    8000574a:	00001097          	auipc	ra,0x1
    8000574e:	fbc080e7          	jalr	-68(ra) # 80006706 <release>
}
    80005752:	70e6                	ld	ra,120(sp)
    80005754:	7446                	ld	s0,112(sp)
    80005756:	74a6                	ld	s1,104(sp)
    80005758:	7906                	ld	s2,96(sp)
    8000575a:	69e6                	ld	s3,88(sp)
    8000575c:	6a46                	ld	s4,80(sp)
    8000575e:	6aa6                	ld	s5,72(sp)
    80005760:	6b06                	ld	s6,64(sp)
    80005762:	7be2                	ld	s7,56(sp)
    80005764:	7c42                	ld	s8,48(sp)
    80005766:	7ca2                	ld	s9,40(sp)
    80005768:	7d02                	ld	s10,32(sp)
    8000576a:	6de2                	ld	s11,24(sp)
    8000576c:	6109                	addi	sp,sp,128
    8000576e:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005770:	f8042503          	lw	a0,-128(s0)
    80005774:	20050793          	addi	a5,a0,512
    80005778:	0792                	slli	a5,a5,0x4
  if(write)
    8000577a:	00019817          	auipc	a6,0x19
    8000577e:	88680813          	addi	a6,a6,-1914 # 8001e000 <disk>
    80005782:	00f80733          	add	a4,a6,a5
    80005786:	01a036b3          	snez	a3,s10
    8000578a:	0ad72423          	sw	a3,168(a4)
  buf0->reserved = 0;
    8000578e:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80005792:	0b973823          	sd	s9,176(a4)
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005796:	7679                	lui	a2,0xffffe
    80005798:	963e                	add	a2,a2,a5
    8000579a:	0001b697          	auipc	a3,0x1b
    8000579e:	86668693          	addi	a3,a3,-1946 # 80020000 <disk+0x2000>
    800057a2:	6298                	ld	a4,0(a3)
    800057a4:	9732                	add	a4,a4,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800057a6:	0a878593          	addi	a1,a5,168
    800057aa:	95c2                	add	a1,a1,a6
  disk.desc[idx[0]].addr = (uint64) buf0;
    800057ac:	e30c                	sd	a1,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800057ae:	6298                	ld	a4,0(a3)
    800057b0:	9732                	add	a4,a4,a2
    800057b2:	45c1                	li	a1,16
    800057b4:	c70c                	sw	a1,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800057b6:	6298                	ld	a4,0(a3)
    800057b8:	9732                	add	a4,a4,a2
    800057ba:	4585                	li	a1,1
    800057bc:	00b71623          	sh	a1,12(a4)
  disk.desc[idx[0]].next = idx[1];
    800057c0:	f8442703          	lw	a4,-124(s0)
    800057c4:	628c                	ld	a1,0(a3)
    800057c6:	962e                	add	a2,a2,a1
    800057c8:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd2dc6>
  disk.desc[idx[1]].addr = (uint64) b->data;
    800057cc:	0712                	slli	a4,a4,0x4
    800057ce:	6290                	ld	a2,0(a3)
    800057d0:	963a                	add	a2,a2,a4
    800057d2:	060a8593          	addi	a1,s5,96
    800057d6:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800057d8:	6294                	ld	a3,0(a3)
    800057da:	96ba                	add	a3,a3,a4
    800057dc:	40000613          	li	a2,1024
    800057e0:	c690                	sw	a2,8(a3)
  if(write)
    800057e2:	e40d1ae3          	bnez	s10,80005636 <virtio_disk_rw+0xc4>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    800057e6:	0001b697          	auipc	a3,0x1b
    800057ea:	81a6b683          	ld	a3,-2022(a3) # 80020000 <disk+0x2000>
    800057ee:	96ba                	add	a3,a3,a4
    800057f0:	4609                	li	a2,2
    800057f2:	00c69623          	sh	a2,12(a3)
    800057f6:	b5b9                	j	80005644 <virtio_disk_rw+0xd2>

00000000800057f8 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800057f8:	1101                	addi	sp,sp,-32
    800057fa:	ec06                	sd	ra,24(sp)
    800057fc:	e822                	sd	s0,16(sp)
    800057fe:	e426                	sd	s1,8(sp)
    80005800:	e04a                	sd	s2,0(sp)
    80005802:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005804:	0001b517          	auipc	a0,0x1b
    80005808:	92450513          	addi	a0,a0,-1756 # 80020128 <disk+0x2128>
    8000580c:	00001097          	auipc	ra,0x1
    80005810:	e2a080e7          	jalr	-470(ra) # 80006636 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005814:	10001737          	lui	a4,0x10001
    80005818:	533c                	lw	a5,96(a4)
    8000581a:	8b8d                	andi	a5,a5,3
    8000581c:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    8000581e:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005822:	0001a797          	auipc	a5,0x1a
    80005826:	7de78793          	addi	a5,a5,2014 # 80020000 <disk+0x2000>
    8000582a:	6b94                	ld	a3,16(a5)
    8000582c:	0207d703          	lhu	a4,32(a5)
    80005830:	0026d783          	lhu	a5,2(a3)
    80005834:	06f70163          	beq	a4,a5,80005896 <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005838:	00018917          	auipc	s2,0x18
    8000583c:	7c890913          	addi	s2,s2,1992 # 8001e000 <disk>
    80005840:	0001a497          	auipc	s1,0x1a
    80005844:	7c048493          	addi	s1,s1,1984 # 80020000 <disk+0x2000>
    __sync_synchronize();
    80005848:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000584c:	6898                	ld	a4,16(s1)
    8000584e:	0204d783          	lhu	a5,32(s1)
    80005852:	8b9d                	andi	a5,a5,7
    80005854:	078e                	slli	a5,a5,0x3
    80005856:	97ba                	add	a5,a5,a4
    80005858:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    8000585a:	20078713          	addi	a4,a5,512
    8000585e:	0712                	slli	a4,a4,0x4
    80005860:	974a                	add	a4,a4,s2
    80005862:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    80005866:	e731                	bnez	a4,800058b2 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005868:	20078793          	addi	a5,a5,512
    8000586c:	0792                	slli	a5,a5,0x4
    8000586e:	97ca                	add	a5,a5,s2
    80005870:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80005872:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005876:	ffffc097          	auipc	ra,0xffffc
    8000587a:	f32080e7          	jalr	-206(ra) # 800017a8 <wakeup>

    disk.used_idx += 1;
    8000587e:	0204d783          	lhu	a5,32(s1)
    80005882:	2785                	addiw	a5,a5,1
    80005884:	17c2                	slli	a5,a5,0x30
    80005886:	93c1                	srli	a5,a5,0x30
    80005888:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    8000588c:	6898                	ld	a4,16(s1)
    8000588e:	00275703          	lhu	a4,2(a4)
    80005892:	faf71be3          	bne	a4,a5,80005848 <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    80005896:	0001b517          	auipc	a0,0x1b
    8000589a:	89250513          	addi	a0,a0,-1902 # 80020128 <disk+0x2128>
    8000589e:	00001097          	auipc	ra,0x1
    800058a2:	e68080e7          	jalr	-408(ra) # 80006706 <release>
}
    800058a6:	60e2                	ld	ra,24(sp)
    800058a8:	6442                	ld	s0,16(sp)
    800058aa:	64a2                	ld	s1,8(sp)
    800058ac:	6902                	ld	s2,0(sp)
    800058ae:	6105                	addi	sp,sp,32
    800058b0:	8082                	ret
      panic("virtio_disk_intr status");
    800058b2:	00003517          	auipc	a0,0x3
    800058b6:	ec650513          	addi	a0,a0,-314 # 80008778 <syscalls+0x3b0>
    800058ba:	00001097          	auipc	ra,0x1
    800058be:	85a080e7          	jalr	-1958(ra) # 80006114 <panic>

00000000800058c2 <statswrite>:
int statscopyin(char*, int);
int statslock(char*, int);
  
int
statswrite(int user_src, uint64 src, int n)
{
    800058c2:	1141                	addi	sp,sp,-16
    800058c4:	e422                	sd	s0,8(sp)
    800058c6:	0800                	addi	s0,sp,16
  return -1;
}
    800058c8:	557d                	li	a0,-1
    800058ca:	6422                	ld	s0,8(sp)
    800058cc:	0141                	addi	sp,sp,16
    800058ce:	8082                	ret

00000000800058d0 <statsread>:

int
statsread(int user_dst, uint64 dst, int n)
{
    800058d0:	7179                	addi	sp,sp,-48
    800058d2:	f406                	sd	ra,40(sp)
    800058d4:	f022                	sd	s0,32(sp)
    800058d6:	ec26                	sd	s1,24(sp)
    800058d8:	e84a                	sd	s2,16(sp)
    800058da:	e44e                	sd	s3,8(sp)
    800058dc:	e052                	sd	s4,0(sp)
    800058de:	1800                	addi	s0,sp,48
    800058e0:	892a                	mv	s2,a0
    800058e2:	89ae                	mv	s3,a1
    800058e4:	84b2                	mv	s1,a2
  int m;

  acquire(&stats.lock);
    800058e6:	0001b517          	auipc	a0,0x1b
    800058ea:	71a50513          	addi	a0,a0,1818 # 80021000 <stats>
    800058ee:	00001097          	auipc	ra,0x1
    800058f2:	d48080e7          	jalr	-696(ra) # 80006636 <acquire>

  if(stats.sz == 0) {
    800058f6:	0001c797          	auipc	a5,0x1c
    800058fa:	72a7a783          	lw	a5,1834(a5) # 80022020 <stats+0x1020>
    800058fe:	cbb5                	beqz	a5,80005972 <statsread+0xa2>
#endif
#ifdef LAB_LOCK
    stats.sz = statslock(stats.buf, BUFSZ);
#endif
  }
  m = stats.sz - stats.off;
    80005900:	0001c797          	auipc	a5,0x1c
    80005904:	70078793          	addi	a5,a5,1792 # 80022000 <stats+0x1000>
    80005908:	53d8                	lw	a4,36(a5)
    8000590a:	539c                	lw	a5,32(a5)
    8000590c:	9f99                	subw	a5,a5,a4
    8000590e:	0007869b          	sext.w	a3,a5

  if (m > 0) {
    80005912:	06d05e63          	blez	a3,8000598e <statsread+0xbe>
    if(m > n)
    80005916:	8a3e                	mv	s4,a5
    80005918:	00d4d363          	bge	s1,a3,8000591e <statsread+0x4e>
    8000591c:	8a26                	mv	s4,s1
    8000591e:	000a049b          	sext.w	s1,s4
      m  = n;
    if(either_copyout(user_dst, dst, stats.buf+stats.off, m) != -1) {
    80005922:	86a6                	mv	a3,s1
    80005924:	0001b617          	auipc	a2,0x1b
    80005928:	6fc60613          	addi	a2,a2,1788 # 80021020 <stats+0x20>
    8000592c:	963a                	add	a2,a2,a4
    8000592e:	85ce                	mv	a1,s3
    80005930:	854a                	mv	a0,s2
    80005932:	ffffc097          	auipc	ra,0xffffc
    80005936:	08e080e7          	jalr	142(ra) # 800019c0 <either_copyout>
    8000593a:	57fd                	li	a5,-1
    8000593c:	00f50a63          	beq	a0,a5,80005950 <statsread+0x80>
      stats.off += m;
    80005940:	0001c717          	auipc	a4,0x1c
    80005944:	6c070713          	addi	a4,a4,1728 # 80022000 <stats+0x1000>
    80005948:	535c                	lw	a5,36(a4)
    8000594a:	00fa07bb          	addw	a5,s4,a5
    8000594e:	d35c                	sw	a5,36(a4)
  } else {
    m = -1;
    stats.sz = 0;
    stats.off = 0;
  }
  release(&stats.lock);
    80005950:	0001b517          	auipc	a0,0x1b
    80005954:	6b050513          	addi	a0,a0,1712 # 80021000 <stats>
    80005958:	00001097          	auipc	ra,0x1
    8000595c:	dae080e7          	jalr	-594(ra) # 80006706 <release>
  return m;
}
    80005960:	8526                	mv	a0,s1
    80005962:	70a2                	ld	ra,40(sp)
    80005964:	7402                	ld	s0,32(sp)
    80005966:	64e2                	ld	s1,24(sp)
    80005968:	6942                	ld	s2,16(sp)
    8000596a:	69a2                	ld	s3,8(sp)
    8000596c:	6a02                	ld	s4,0(sp)
    8000596e:	6145                	addi	sp,sp,48
    80005970:	8082                	ret
    stats.sz = statslock(stats.buf, BUFSZ);
    80005972:	6585                	lui	a1,0x1
    80005974:	0001b517          	auipc	a0,0x1b
    80005978:	6ac50513          	addi	a0,a0,1708 # 80021020 <stats+0x20>
    8000597c:	00001097          	auipc	ra,0x1
    80005980:	f10080e7          	jalr	-240(ra) # 8000688c <statslock>
    80005984:	0001c797          	auipc	a5,0x1c
    80005988:	68a7ae23          	sw	a0,1692(a5) # 80022020 <stats+0x1020>
    8000598c:	bf95                	j	80005900 <statsread+0x30>
    stats.sz = 0;
    8000598e:	0001c797          	auipc	a5,0x1c
    80005992:	67278793          	addi	a5,a5,1650 # 80022000 <stats+0x1000>
    80005996:	0207a023          	sw	zero,32(a5)
    stats.off = 0;
    8000599a:	0207a223          	sw	zero,36(a5)
    m = -1;
    8000599e:	54fd                	li	s1,-1
    800059a0:	bf45                	j	80005950 <statsread+0x80>

00000000800059a2 <statsinit>:

void
statsinit(void)
{
    800059a2:	1141                	addi	sp,sp,-16
    800059a4:	e406                	sd	ra,8(sp)
    800059a6:	e022                	sd	s0,0(sp)
    800059a8:	0800                	addi	s0,sp,16
  initlock(&stats.lock, "stats");
    800059aa:	00003597          	auipc	a1,0x3
    800059ae:	de658593          	addi	a1,a1,-538 # 80008790 <syscalls+0x3c8>
    800059b2:	0001b517          	auipc	a0,0x1b
    800059b6:	64e50513          	addi	a0,a0,1614 # 80021000 <stats>
    800059ba:	00001097          	auipc	ra,0x1
    800059be:	df8080e7          	jalr	-520(ra) # 800067b2 <initlock>

  devsw[STATS].read = statsread;
    800059c2:	00017797          	auipc	a5,0x17
    800059c6:	2de78793          	addi	a5,a5,734 # 8001cca0 <devsw>
    800059ca:	00000717          	auipc	a4,0x0
    800059ce:	f0670713          	addi	a4,a4,-250 # 800058d0 <statsread>
    800059d2:	f398                	sd	a4,32(a5)
  devsw[STATS].write = statswrite;
    800059d4:	00000717          	auipc	a4,0x0
    800059d8:	eee70713          	addi	a4,a4,-274 # 800058c2 <statswrite>
    800059dc:	f798                	sd	a4,40(a5)
}
    800059de:	60a2                	ld	ra,8(sp)
    800059e0:	6402                	ld	s0,0(sp)
    800059e2:	0141                	addi	sp,sp,16
    800059e4:	8082                	ret

00000000800059e6 <sprintint>:
  return 1;
}

static int
sprintint(char *s, int xx, int base, int sign)
{
    800059e6:	1101                	addi	sp,sp,-32
    800059e8:	ec22                	sd	s0,24(sp)
    800059ea:	1000                	addi	s0,sp,32
    800059ec:	882a                	mv	a6,a0
  char buf[16];
  int i, n;
  uint x;

  if(sign && (sign = xx < 0))
    800059ee:	c299                	beqz	a3,800059f4 <sprintint+0xe>
    800059f0:	0805c263          	bltz	a1,80005a74 <sprintint+0x8e>
    x = -xx;
  else
    x = xx;
    800059f4:	2581                	sext.w	a1,a1
    800059f6:	4301                	li	t1,0

  i = 0;
    800059f8:	fe040713          	addi	a4,s0,-32
    800059fc:	4501                	li	a0,0
  do {
    buf[i++] = digits[x % base];
    800059fe:	2601                	sext.w	a2,a2
    80005a00:	00003697          	auipc	a3,0x3
    80005a04:	db068693          	addi	a3,a3,-592 # 800087b0 <digits>
    80005a08:	88aa                	mv	a7,a0
    80005a0a:	2505                	addiw	a0,a0,1
    80005a0c:	02c5f7bb          	remuw	a5,a1,a2
    80005a10:	1782                	slli	a5,a5,0x20
    80005a12:	9381                	srli	a5,a5,0x20
    80005a14:	97b6                	add	a5,a5,a3
    80005a16:	0007c783          	lbu	a5,0(a5)
    80005a1a:	00f70023          	sb	a5,0(a4)
  } while((x /= base) != 0);
    80005a1e:	0005879b          	sext.w	a5,a1
    80005a22:	02c5d5bb          	divuw	a1,a1,a2
    80005a26:	0705                	addi	a4,a4,1
    80005a28:	fec7f0e3          	bgeu	a5,a2,80005a08 <sprintint+0x22>

  if(sign)
    80005a2c:	00030b63          	beqz	t1,80005a42 <sprintint+0x5c>
    buf[i++] = '-';
    80005a30:	ff050793          	addi	a5,a0,-16
    80005a34:	97a2                	add	a5,a5,s0
    80005a36:	02d00713          	li	a4,45
    80005a3a:	fee78823          	sb	a4,-16(a5)
    80005a3e:	0028851b          	addiw	a0,a7,2

  n = 0;
  while(--i >= 0)
    80005a42:	02a05d63          	blez	a0,80005a7c <sprintint+0x96>
    80005a46:	fe040793          	addi	a5,s0,-32
    80005a4a:	00a78733          	add	a4,a5,a0
    80005a4e:	87c2                	mv	a5,a6
    80005a50:	00180613          	addi	a2,a6,1
    80005a54:	fff5069b          	addiw	a3,a0,-1
    80005a58:	1682                	slli	a3,a3,0x20
    80005a5a:	9281                	srli	a3,a3,0x20
    80005a5c:	9636                	add	a2,a2,a3
  *s = c;
    80005a5e:	fff74683          	lbu	a3,-1(a4)
    80005a62:	00d78023          	sb	a3,0(a5)
  while(--i >= 0)
    80005a66:	177d                	addi	a4,a4,-1
    80005a68:	0785                	addi	a5,a5,1
    80005a6a:	fec79ae3          	bne	a5,a2,80005a5e <sprintint+0x78>
    n += sputc(s+n, buf[i]);
  return n;
}
    80005a6e:	6462                	ld	s0,24(sp)
    80005a70:	6105                	addi	sp,sp,32
    80005a72:	8082                	ret
    x = -xx;
    80005a74:	40b005bb          	negw	a1,a1
  if(sign && (sign = xx < 0))
    80005a78:	4305                	li	t1,1
    x = -xx;
    80005a7a:	bfbd                	j	800059f8 <sprintint+0x12>
  while(--i >= 0)
    80005a7c:	4501                	li	a0,0
    80005a7e:	bfc5                	j	80005a6e <sprintint+0x88>

0000000080005a80 <snprintf>:

int
snprintf(char *buf, int sz, char *fmt, ...)
{
    80005a80:	7135                	addi	sp,sp,-160
    80005a82:	f486                	sd	ra,104(sp)
    80005a84:	f0a2                	sd	s0,96(sp)
    80005a86:	eca6                	sd	s1,88(sp)
    80005a88:	e8ca                	sd	s2,80(sp)
    80005a8a:	e4ce                	sd	s3,72(sp)
    80005a8c:	e0d2                	sd	s4,64(sp)
    80005a8e:	fc56                	sd	s5,56(sp)
    80005a90:	f85a                	sd	s6,48(sp)
    80005a92:	f45e                	sd	s7,40(sp)
    80005a94:	f062                	sd	s8,32(sp)
    80005a96:	ec66                	sd	s9,24(sp)
    80005a98:	e86a                	sd	s10,16(sp)
    80005a9a:	1880                	addi	s0,sp,112
    80005a9c:	e414                	sd	a3,8(s0)
    80005a9e:	e818                	sd	a4,16(s0)
    80005aa0:	ec1c                	sd	a5,24(s0)
    80005aa2:	03043023          	sd	a6,32(s0)
    80005aa6:	03143423          	sd	a7,40(s0)
  va_list ap;
  int i, c;
  int off = 0;
  char *s;

  if (fmt == 0)
    80005aaa:	c61d                	beqz	a2,80005ad8 <snprintf+0x58>
    80005aac:	8baa                	mv	s7,a0
    80005aae:	89ae                	mv	s3,a1
    80005ab0:	8a32                	mv	s4,a2
    panic("null fmt");

  va_start(ap, fmt);
    80005ab2:	00840793          	addi	a5,s0,8
    80005ab6:	f8f43c23          	sd	a5,-104(s0)
  int off = 0;
    80005aba:	4481                	li	s1,0
  for(i = 0; off < sz && (c = fmt[i] & 0xff) != 0; i++){
    80005abc:	4901                	li	s2,0
    80005abe:	02b05563          	blez	a1,80005ae8 <snprintf+0x68>
    if(c != '%'){
    80005ac2:	02500a93          	li	s5,37
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
    80005ac6:	07300b13          	li	s6,115
      off += sprintint(buf+off, va_arg(ap, int), 16, 1);
      break;
    case 's':
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s && off < sz; s++)
    80005aca:	02800d13          	li	s10,40
    switch(c){
    80005ace:	07800c93          	li	s9,120
    80005ad2:	06400c13          	li	s8,100
    80005ad6:	a01d                	j	80005afc <snprintf+0x7c>
    panic("null fmt");
    80005ad8:	00003517          	auipc	a0,0x3
    80005adc:	cc850513          	addi	a0,a0,-824 # 800087a0 <syscalls+0x3d8>
    80005ae0:	00000097          	auipc	ra,0x0
    80005ae4:	634080e7          	jalr	1588(ra) # 80006114 <panic>
  int off = 0;
    80005ae8:	4481                	li	s1,0
    80005aea:	a875                	j	80005ba6 <snprintf+0x126>
  *s = c;
    80005aec:	009b8733          	add	a4,s7,s1
    80005af0:	00f70023          	sb	a5,0(a4)
      off += sputc(buf+off, c);
    80005af4:	2485                	addiw	s1,s1,1
  for(i = 0; off < sz && (c = fmt[i] & 0xff) != 0; i++){
    80005af6:	2905                	addiw	s2,s2,1
    80005af8:	0b34d763          	bge	s1,s3,80005ba6 <snprintf+0x126>
    80005afc:	012a07b3          	add	a5,s4,s2
    80005b00:	0007c783          	lbu	a5,0(a5)
    80005b04:	0007871b          	sext.w	a4,a5
    80005b08:	cfd9                	beqz	a5,80005ba6 <snprintf+0x126>
    if(c != '%'){
    80005b0a:	ff5711e3          	bne	a4,s5,80005aec <snprintf+0x6c>
    c = fmt[++i] & 0xff;
    80005b0e:	2905                	addiw	s2,s2,1
    80005b10:	012a07b3          	add	a5,s4,s2
    80005b14:	0007c783          	lbu	a5,0(a5)
    if(c == 0)
    80005b18:	c7d9                	beqz	a5,80005ba6 <snprintf+0x126>
    switch(c){
    80005b1a:	05678c63          	beq	a5,s6,80005b72 <snprintf+0xf2>
    80005b1e:	02fb6763          	bltu	s6,a5,80005b4c <snprintf+0xcc>
    80005b22:	0b578763          	beq	a5,s5,80005bd0 <snprintf+0x150>
    80005b26:	0b879b63          	bne	a5,s8,80005bdc <snprintf+0x15c>
      off += sprintint(buf+off, va_arg(ap, int), 10, 1);
    80005b2a:	f9843783          	ld	a5,-104(s0)
    80005b2e:	00878713          	addi	a4,a5,8
    80005b32:	f8e43c23          	sd	a4,-104(s0)
    80005b36:	4685                	li	a3,1
    80005b38:	4629                	li	a2,10
    80005b3a:	438c                	lw	a1,0(a5)
    80005b3c:	009b8533          	add	a0,s7,s1
    80005b40:	00000097          	auipc	ra,0x0
    80005b44:	ea6080e7          	jalr	-346(ra) # 800059e6 <sprintint>
    80005b48:	9ca9                	addw	s1,s1,a0
      break;
    80005b4a:	b775                	j	80005af6 <snprintf+0x76>
    switch(c){
    80005b4c:	09979863          	bne	a5,s9,80005bdc <snprintf+0x15c>
      off += sprintint(buf+off, va_arg(ap, int), 16, 1);
    80005b50:	f9843783          	ld	a5,-104(s0)
    80005b54:	00878713          	addi	a4,a5,8
    80005b58:	f8e43c23          	sd	a4,-104(s0)
    80005b5c:	4685                	li	a3,1
    80005b5e:	4641                	li	a2,16
    80005b60:	438c                	lw	a1,0(a5)
    80005b62:	009b8533          	add	a0,s7,s1
    80005b66:	00000097          	auipc	ra,0x0
    80005b6a:	e80080e7          	jalr	-384(ra) # 800059e6 <sprintint>
    80005b6e:	9ca9                	addw	s1,s1,a0
      break;
    80005b70:	b759                	j	80005af6 <snprintf+0x76>
      if((s = va_arg(ap, char*)) == 0)
    80005b72:	f9843783          	ld	a5,-104(s0)
    80005b76:	00878713          	addi	a4,a5,8
    80005b7a:	f8e43c23          	sd	a4,-104(s0)
    80005b7e:	639c                	ld	a5,0(a5)
    80005b80:	c3b1                	beqz	a5,80005bc4 <snprintf+0x144>
      for(; *s && off < sz; s++)
    80005b82:	0007c703          	lbu	a4,0(a5)
    80005b86:	db25                	beqz	a4,80005af6 <snprintf+0x76>
    80005b88:	0734d563          	bge	s1,s3,80005bf2 <snprintf+0x172>
    80005b8c:	009b86b3          	add	a3,s7,s1
  *s = c;
    80005b90:	00e68023          	sb	a4,0(a3)
        off += sputc(buf+off, *s);
    80005b94:	2485                	addiw	s1,s1,1
      for(; *s && off < sz; s++)
    80005b96:	0785                	addi	a5,a5,1
    80005b98:	0007c703          	lbu	a4,0(a5)
    80005b9c:	df29                	beqz	a4,80005af6 <snprintf+0x76>
    80005b9e:	0685                	addi	a3,a3,1
    80005ba0:	fe9998e3          	bne	s3,s1,80005b90 <snprintf+0x110>
  int off = 0;
    80005ba4:	84ce                	mv	s1,s3
      off += sputc(buf+off, c);
      break;
    }
  }
  return off;
}
    80005ba6:	8526                	mv	a0,s1
    80005ba8:	70a6                	ld	ra,104(sp)
    80005baa:	7406                	ld	s0,96(sp)
    80005bac:	64e6                	ld	s1,88(sp)
    80005bae:	6946                	ld	s2,80(sp)
    80005bb0:	69a6                	ld	s3,72(sp)
    80005bb2:	6a06                	ld	s4,64(sp)
    80005bb4:	7ae2                	ld	s5,56(sp)
    80005bb6:	7b42                	ld	s6,48(sp)
    80005bb8:	7ba2                	ld	s7,40(sp)
    80005bba:	7c02                	ld	s8,32(sp)
    80005bbc:	6ce2                	ld	s9,24(sp)
    80005bbe:	6d42                	ld	s10,16(sp)
    80005bc0:	610d                	addi	sp,sp,160
    80005bc2:	8082                	ret
        s = "(null)";
    80005bc4:	00003797          	auipc	a5,0x3
    80005bc8:	bd478793          	addi	a5,a5,-1068 # 80008798 <syscalls+0x3d0>
      for(; *s && off < sz; s++)
    80005bcc:	876a                	mv	a4,s10
    80005bce:	bf6d                	j	80005b88 <snprintf+0x108>
  *s = c;
    80005bd0:	009b87b3          	add	a5,s7,s1
    80005bd4:	01578023          	sb	s5,0(a5)
      off += sputc(buf+off, '%');
    80005bd8:	2485                	addiw	s1,s1,1
      break;
    80005bda:	bf31                	j	80005af6 <snprintf+0x76>
  *s = c;
    80005bdc:	009b8733          	add	a4,s7,s1
    80005be0:	01570023          	sb	s5,0(a4)
      off += sputc(buf+off, c);
    80005be4:	0014871b          	addiw	a4,s1,1
  *s = c;
    80005be8:	975e                	add	a4,a4,s7
    80005bea:	00f70023          	sb	a5,0(a4)
      off += sputc(buf+off, c);
    80005bee:	2489                	addiw	s1,s1,2
      break;
    80005bf0:	b719                	j	80005af6 <snprintf+0x76>
      for(; *s && off < sz; s++)
    80005bf2:	89a6                	mv	s3,s1
    80005bf4:	bf45                	j	80005ba4 <snprintf+0x124>

0000000080005bf6 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005bf6:	1141                	addi	sp,sp,-16
    80005bf8:	e422                	sd	s0,8(sp)
    80005bfa:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005bfc:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005c00:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005c04:	0037979b          	slliw	a5,a5,0x3
    80005c08:	02004737          	lui	a4,0x2004
    80005c0c:	97ba                	add	a5,a5,a4
    80005c0e:	0200c737          	lui	a4,0x200c
    80005c12:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005c16:	000f4637          	lui	a2,0xf4
    80005c1a:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005c1e:	9732                	add	a4,a4,a2
    80005c20:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005c22:	00259693          	slli	a3,a1,0x2
    80005c26:	96ae                	add	a3,a3,a1
    80005c28:	068e                	slli	a3,a3,0x3
    80005c2a:	0001c717          	auipc	a4,0x1c
    80005c2e:	40670713          	addi	a4,a4,1030 # 80022030 <timer_scratch>
    80005c32:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005c34:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005c36:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005c38:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005c3c:	fffff797          	auipc	a5,0xfffff
    80005c40:	69478793          	addi	a5,a5,1684 # 800052d0 <timervec>
    80005c44:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005c48:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005c4c:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005c50:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005c54:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005c58:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005c5c:	30479073          	csrw	mie,a5
}
    80005c60:	6422                	ld	s0,8(sp)
    80005c62:	0141                	addi	sp,sp,16
    80005c64:	8082                	ret

0000000080005c66 <start>:
{
    80005c66:	1141                	addi	sp,sp,-16
    80005c68:	e406                	sd	ra,8(sp)
    80005c6a:	e022                	sd	s0,0(sp)
    80005c6c:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005c6e:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005c72:	7779                	lui	a4,0xffffe
    80005c74:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd35b7>
    80005c78:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005c7a:	6705                	lui	a4,0x1
    80005c7c:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005c80:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005c82:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005c86:	ffffa797          	auipc	a5,0xffffa
    80005c8a:	79e78793          	addi	a5,a5,1950 # 80000424 <main>
    80005c8e:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005c92:	4781                	li	a5,0
    80005c94:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005c98:	67c1                	lui	a5,0x10
    80005c9a:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005c9c:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005ca0:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005ca4:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005ca8:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005cac:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005cb0:	57fd                	li	a5,-1
    80005cb2:	83a9                	srli	a5,a5,0xa
    80005cb4:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005cb8:	47bd                	li	a5,15
    80005cba:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005cbe:	00000097          	auipc	ra,0x0
    80005cc2:	f38080e7          	jalr	-200(ra) # 80005bf6 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005cc6:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005cca:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005ccc:	823e                	mv	tp,a5
  asm volatile("mret");
    80005cce:	30200073          	mret
}
    80005cd2:	60a2                	ld	ra,8(sp)
    80005cd4:	6402                	ld	s0,0(sp)
    80005cd6:	0141                	addi	sp,sp,16
    80005cd8:	8082                	ret

0000000080005cda <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005cda:	715d                	addi	sp,sp,-80
    80005cdc:	e486                	sd	ra,72(sp)
    80005cde:	e0a2                	sd	s0,64(sp)
    80005ce0:	fc26                	sd	s1,56(sp)
    80005ce2:	f84a                	sd	s2,48(sp)
    80005ce4:	f44e                	sd	s3,40(sp)
    80005ce6:	f052                	sd	s4,32(sp)
    80005ce8:	ec56                	sd	s5,24(sp)
    80005cea:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005cec:	04c05763          	blez	a2,80005d3a <consolewrite+0x60>
    80005cf0:	8a2a                	mv	s4,a0
    80005cf2:	84ae                	mv	s1,a1
    80005cf4:	89b2                	mv	s3,a2
    80005cf6:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005cf8:	5afd                	li	s5,-1
    80005cfa:	4685                	li	a3,1
    80005cfc:	8626                	mv	a2,s1
    80005cfe:	85d2                	mv	a1,s4
    80005d00:	fbf40513          	addi	a0,s0,-65
    80005d04:	ffffc097          	auipc	ra,0xffffc
    80005d08:	d12080e7          	jalr	-750(ra) # 80001a16 <either_copyin>
    80005d0c:	01550d63          	beq	a0,s5,80005d26 <consolewrite+0x4c>
      break;
    uartputc(c);
    80005d10:	fbf44503          	lbu	a0,-65(s0)
    80005d14:	00000097          	auipc	ra,0x0
    80005d18:	77e080e7          	jalr	1918(ra) # 80006492 <uartputc>
  for(i = 0; i < n; i++){
    80005d1c:	2905                	addiw	s2,s2,1
    80005d1e:	0485                	addi	s1,s1,1
    80005d20:	fd299de3          	bne	s3,s2,80005cfa <consolewrite+0x20>
    80005d24:	894e                	mv	s2,s3
  }

  return i;
}
    80005d26:	854a                	mv	a0,s2
    80005d28:	60a6                	ld	ra,72(sp)
    80005d2a:	6406                	ld	s0,64(sp)
    80005d2c:	74e2                	ld	s1,56(sp)
    80005d2e:	7942                	ld	s2,48(sp)
    80005d30:	79a2                	ld	s3,40(sp)
    80005d32:	7a02                	ld	s4,32(sp)
    80005d34:	6ae2                	ld	s5,24(sp)
    80005d36:	6161                	addi	sp,sp,80
    80005d38:	8082                	ret
  for(i = 0; i < n; i++){
    80005d3a:	4901                	li	s2,0
    80005d3c:	b7ed                	j	80005d26 <consolewrite+0x4c>

0000000080005d3e <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005d3e:	7159                	addi	sp,sp,-112
    80005d40:	f486                	sd	ra,104(sp)
    80005d42:	f0a2                	sd	s0,96(sp)
    80005d44:	eca6                	sd	s1,88(sp)
    80005d46:	e8ca                	sd	s2,80(sp)
    80005d48:	e4ce                	sd	s3,72(sp)
    80005d4a:	e0d2                	sd	s4,64(sp)
    80005d4c:	fc56                	sd	s5,56(sp)
    80005d4e:	f85a                	sd	s6,48(sp)
    80005d50:	f45e                	sd	s7,40(sp)
    80005d52:	f062                	sd	s8,32(sp)
    80005d54:	ec66                	sd	s9,24(sp)
    80005d56:	e86a                	sd	s10,16(sp)
    80005d58:	1880                	addi	s0,sp,112
    80005d5a:	8aaa                	mv	s5,a0
    80005d5c:	8a2e                	mv	s4,a1
    80005d5e:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005d60:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005d64:	00024517          	auipc	a0,0x24
    80005d68:	40c50513          	addi	a0,a0,1036 # 8002a170 <cons>
    80005d6c:	00001097          	auipc	ra,0x1
    80005d70:	8ca080e7          	jalr	-1846(ra) # 80006636 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005d74:	00024497          	auipc	s1,0x24
    80005d78:	3fc48493          	addi	s1,s1,1020 # 8002a170 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005d7c:	00024917          	auipc	s2,0x24
    80005d80:	49490913          	addi	s2,s2,1172 # 8002a210 <cons+0xa0>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    80005d84:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005d86:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005d88:	4ca9                	li	s9,10
  while(n > 0){
    80005d8a:	07305863          	blez	s3,80005dfa <consoleread+0xbc>
    while(cons.r == cons.w){
    80005d8e:	0a04a783          	lw	a5,160(s1)
    80005d92:	0a44a703          	lw	a4,164(s1)
    80005d96:	02f71463          	bne	a4,a5,80005dbe <consoleread+0x80>
      if(myproc()->killed){
    80005d9a:	ffffb097          	auipc	ra,0xffffb
    80005d9e:	1be080e7          	jalr	446(ra) # 80000f58 <myproc>
    80005da2:	591c                	lw	a5,48(a0)
    80005da4:	e7b5                	bnez	a5,80005e10 <consoleread+0xd2>
      sleep(&cons.r, &cons.lock);
    80005da6:	85a6                	mv	a1,s1
    80005da8:	854a                	mv	a0,s2
    80005daa:	ffffc097          	auipc	ra,0xffffc
    80005dae:	872080e7          	jalr	-1934(ra) # 8000161c <sleep>
    while(cons.r == cons.w){
    80005db2:	0a04a783          	lw	a5,160(s1)
    80005db6:	0a44a703          	lw	a4,164(s1)
    80005dba:	fef700e3          	beq	a4,a5,80005d9a <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80005dbe:	0017871b          	addiw	a4,a5,1
    80005dc2:	0ae4a023          	sw	a4,160(s1)
    80005dc6:	07f7f713          	andi	a4,a5,127
    80005dca:	9726                	add	a4,a4,s1
    80005dcc:	02074703          	lbu	a4,32(a4)
    80005dd0:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    80005dd4:	077d0563          	beq	s10,s7,80005e3e <consoleread+0x100>
    cbuf = c;
    80005dd8:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005ddc:	4685                	li	a3,1
    80005dde:	f9f40613          	addi	a2,s0,-97
    80005de2:	85d2                	mv	a1,s4
    80005de4:	8556                	mv	a0,s5
    80005de6:	ffffc097          	auipc	ra,0xffffc
    80005dea:	bda080e7          	jalr	-1062(ra) # 800019c0 <either_copyout>
    80005dee:	01850663          	beq	a0,s8,80005dfa <consoleread+0xbc>
    dst++;
    80005df2:	0a05                	addi	s4,s4,1
    --n;
    80005df4:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    80005df6:	f99d1ae3          	bne	s10,s9,80005d8a <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005dfa:	00024517          	auipc	a0,0x24
    80005dfe:	37650513          	addi	a0,a0,886 # 8002a170 <cons>
    80005e02:	00001097          	auipc	ra,0x1
    80005e06:	904080e7          	jalr	-1788(ra) # 80006706 <release>

  return target - n;
    80005e0a:	413b053b          	subw	a0,s6,s3
    80005e0e:	a811                	j	80005e22 <consoleread+0xe4>
        release(&cons.lock);
    80005e10:	00024517          	auipc	a0,0x24
    80005e14:	36050513          	addi	a0,a0,864 # 8002a170 <cons>
    80005e18:	00001097          	auipc	ra,0x1
    80005e1c:	8ee080e7          	jalr	-1810(ra) # 80006706 <release>
        return -1;
    80005e20:	557d                	li	a0,-1
}
    80005e22:	70a6                	ld	ra,104(sp)
    80005e24:	7406                	ld	s0,96(sp)
    80005e26:	64e6                	ld	s1,88(sp)
    80005e28:	6946                	ld	s2,80(sp)
    80005e2a:	69a6                	ld	s3,72(sp)
    80005e2c:	6a06                	ld	s4,64(sp)
    80005e2e:	7ae2                	ld	s5,56(sp)
    80005e30:	7b42                	ld	s6,48(sp)
    80005e32:	7ba2                	ld	s7,40(sp)
    80005e34:	7c02                	ld	s8,32(sp)
    80005e36:	6ce2                	ld	s9,24(sp)
    80005e38:	6d42                	ld	s10,16(sp)
    80005e3a:	6165                	addi	sp,sp,112
    80005e3c:	8082                	ret
      if(n < target){
    80005e3e:	0009871b          	sext.w	a4,s3
    80005e42:	fb677ce3          	bgeu	a4,s6,80005dfa <consoleread+0xbc>
        cons.r--;
    80005e46:	00024717          	auipc	a4,0x24
    80005e4a:	3cf72523          	sw	a5,970(a4) # 8002a210 <cons+0xa0>
    80005e4e:	b775                	j	80005dfa <consoleread+0xbc>

0000000080005e50 <consputc>:
{
    80005e50:	1141                	addi	sp,sp,-16
    80005e52:	e406                	sd	ra,8(sp)
    80005e54:	e022                	sd	s0,0(sp)
    80005e56:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005e58:	10000793          	li	a5,256
    80005e5c:	00f50a63          	beq	a0,a5,80005e70 <consputc+0x20>
    uartputc_sync(c);
    80005e60:	00000097          	auipc	ra,0x0
    80005e64:	560080e7          	jalr	1376(ra) # 800063c0 <uartputc_sync>
}
    80005e68:	60a2                	ld	ra,8(sp)
    80005e6a:	6402                	ld	s0,0(sp)
    80005e6c:	0141                	addi	sp,sp,16
    80005e6e:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005e70:	4521                	li	a0,8
    80005e72:	00000097          	auipc	ra,0x0
    80005e76:	54e080e7          	jalr	1358(ra) # 800063c0 <uartputc_sync>
    80005e7a:	02000513          	li	a0,32
    80005e7e:	00000097          	auipc	ra,0x0
    80005e82:	542080e7          	jalr	1346(ra) # 800063c0 <uartputc_sync>
    80005e86:	4521                	li	a0,8
    80005e88:	00000097          	auipc	ra,0x0
    80005e8c:	538080e7          	jalr	1336(ra) # 800063c0 <uartputc_sync>
    80005e90:	bfe1                	j	80005e68 <consputc+0x18>

0000000080005e92 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005e92:	1101                	addi	sp,sp,-32
    80005e94:	ec06                	sd	ra,24(sp)
    80005e96:	e822                	sd	s0,16(sp)
    80005e98:	e426                	sd	s1,8(sp)
    80005e9a:	e04a                	sd	s2,0(sp)
    80005e9c:	1000                	addi	s0,sp,32
    80005e9e:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005ea0:	00024517          	auipc	a0,0x24
    80005ea4:	2d050513          	addi	a0,a0,720 # 8002a170 <cons>
    80005ea8:	00000097          	auipc	ra,0x0
    80005eac:	78e080e7          	jalr	1934(ra) # 80006636 <acquire>

  switch(c){
    80005eb0:	47d5                	li	a5,21
    80005eb2:	0af48663          	beq	s1,a5,80005f5e <consoleintr+0xcc>
    80005eb6:	0297ca63          	blt	a5,s1,80005eea <consoleintr+0x58>
    80005eba:	47a1                	li	a5,8
    80005ebc:	0ef48763          	beq	s1,a5,80005faa <consoleintr+0x118>
    80005ec0:	47c1                	li	a5,16
    80005ec2:	10f49a63          	bne	s1,a5,80005fd6 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005ec6:	ffffc097          	auipc	ra,0xffffc
    80005eca:	ba6080e7          	jalr	-1114(ra) # 80001a6c <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005ece:	00024517          	auipc	a0,0x24
    80005ed2:	2a250513          	addi	a0,a0,674 # 8002a170 <cons>
    80005ed6:	00001097          	auipc	ra,0x1
    80005eda:	830080e7          	jalr	-2000(ra) # 80006706 <release>
}
    80005ede:	60e2                	ld	ra,24(sp)
    80005ee0:	6442                	ld	s0,16(sp)
    80005ee2:	64a2                	ld	s1,8(sp)
    80005ee4:	6902                	ld	s2,0(sp)
    80005ee6:	6105                	addi	sp,sp,32
    80005ee8:	8082                	ret
  switch(c){
    80005eea:	07f00793          	li	a5,127
    80005eee:	0af48e63          	beq	s1,a5,80005faa <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005ef2:	00024717          	auipc	a4,0x24
    80005ef6:	27e70713          	addi	a4,a4,638 # 8002a170 <cons>
    80005efa:	0a872783          	lw	a5,168(a4)
    80005efe:	0a072703          	lw	a4,160(a4)
    80005f02:	9f99                	subw	a5,a5,a4
    80005f04:	07f00713          	li	a4,127
    80005f08:	fcf763e3          	bltu	a4,a5,80005ece <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005f0c:	47b5                	li	a5,13
    80005f0e:	0cf48763          	beq	s1,a5,80005fdc <consoleintr+0x14a>
      consputc(c);
    80005f12:	8526                	mv	a0,s1
    80005f14:	00000097          	auipc	ra,0x0
    80005f18:	f3c080e7          	jalr	-196(ra) # 80005e50 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005f1c:	00024797          	auipc	a5,0x24
    80005f20:	25478793          	addi	a5,a5,596 # 8002a170 <cons>
    80005f24:	0a87a703          	lw	a4,168(a5)
    80005f28:	0017069b          	addiw	a3,a4,1
    80005f2c:	0006861b          	sext.w	a2,a3
    80005f30:	0ad7a423          	sw	a3,168(a5)
    80005f34:	07f77713          	andi	a4,a4,127
    80005f38:	97ba                	add	a5,a5,a4
    80005f3a:	02978023          	sb	s1,32(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005f3e:	47a9                	li	a5,10
    80005f40:	0cf48563          	beq	s1,a5,8000600a <consoleintr+0x178>
    80005f44:	4791                	li	a5,4
    80005f46:	0cf48263          	beq	s1,a5,8000600a <consoleintr+0x178>
    80005f4a:	00024797          	auipc	a5,0x24
    80005f4e:	2c67a783          	lw	a5,710(a5) # 8002a210 <cons+0xa0>
    80005f52:	0807879b          	addiw	a5,a5,128
    80005f56:	f6f61ce3          	bne	a2,a5,80005ece <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005f5a:	863e                	mv	a2,a5
    80005f5c:	a07d                	j	8000600a <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005f5e:	00024717          	auipc	a4,0x24
    80005f62:	21270713          	addi	a4,a4,530 # 8002a170 <cons>
    80005f66:	0a872783          	lw	a5,168(a4)
    80005f6a:	0a472703          	lw	a4,164(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005f6e:	00024497          	auipc	s1,0x24
    80005f72:	20248493          	addi	s1,s1,514 # 8002a170 <cons>
    while(cons.e != cons.w &&
    80005f76:	4929                	li	s2,10
    80005f78:	f4f70be3          	beq	a4,a5,80005ece <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005f7c:	37fd                	addiw	a5,a5,-1
    80005f7e:	07f7f713          	andi	a4,a5,127
    80005f82:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005f84:	02074703          	lbu	a4,32(a4)
    80005f88:	f52703e3          	beq	a4,s2,80005ece <consoleintr+0x3c>
      cons.e--;
    80005f8c:	0af4a423          	sw	a5,168(s1)
      consputc(BACKSPACE);
    80005f90:	10000513          	li	a0,256
    80005f94:	00000097          	auipc	ra,0x0
    80005f98:	ebc080e7          	jalr	-324(ra) # 80005e50 <consputc>
    while(cons.e != cons.w &&
    80005f9c:	0a84a783          	lw	a5,168(s1)
    80005fa0:	0a44a703          	lw	a4,164(s1)
    80005fa4:	fcf71ce3          	bne	a4,a5,80005f7c <consoleintr+0xea>
    80005fa8:	b71d                	j	80005ece <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005faa:	00024717          	auipc	a4,0x24
    80005fae:	1c670713          	addi	a4,a4,454 # 8002a170 <cons>
    80005fb2:	0a872783          	lw	a5,168(a4)
    80005fb6:	0a472703          	lw	a4,164(a4)
    80005fba:	f0f70ae3          	beq	a4,a5,80005ece <consoleintr+0x3c>
      cons.e--;
    80005fbe:	37fd                	addiw	a5,a5,-1
    80005fc0:	00024717          	auipc	a4,0x24
    80005fc4:	24f72c23          	sw	a5,600(a4) # 8002a218 <cons+0xa8>
      consputc(BACKSPACE);
    80005fc8:	10000513          	li	a0,256
    80005fcc:	00000097          	auipc	ra,0x0
    80005fd0:	e84080e7          	jalr	-380(ra) # 80005e50 <consputc>
    80005fd4:	bded                	j	80005ece <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005fd6:	ee048ce3          	beqz	s1,80005ece <consoleintr+0x3c>
    80005fda:	bf21                	j	80005ef2 <consoleintr+0x60>
      consputc(c);
    80005fdc:	4529                	li	a0,10
    80005fde:	00000097          	auipc	ra,0x0
    80005fe2:	e72080e7          	jalr	-398(ra) # 80005e50 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005fe6:	00024797          	auipc	a5,0x24
    80005fea:	18a78793          	addi	a5,a5,394 # 8002a170 <cons>
    80005fee:	0a87a703          	lw	a4,168(a5)
    80005ff2:	0017069b          	addiw	a3,a4,1
    80005ff6:	0006861b          	sext.w	a2,a3
    80005ffa:	0ad7a423          	sw	a3,168(a5)
    80005ffe:	07f77713          	andi	a4,a4,127
    80006002:	97ba                	add	a5,a5,a4
    80006004:	4729                	li	a4,10
    80006006:	02e78023          	sb	a4,32(a5)
        cons.w = cons.e;
    8000600a:	00024797          	auipc	a5,0x24
    8000600e:	20c7a523          	sw	a2,522(a5) # 8002a214 <cons+0xa4>
        wakeup(&cons.r);
    80006012:	00024517          	auipc	a0,0x24
    80006016:	1fe50513          	addi	a0,a0,510 # 8002a210 <cons+0xa0>
    8000601a:	ffffb097          	auipc	ra,0xffffb
    8000601e:	78e080e7          	jalr	1934(ra) # 800017a8 <wakeup>
    80006022:	b575                	j	80005ece <consoleintr+0x3c>

0000000080006024 <consoleinit>:

void
consoleinit(void)
{
    80006024:	1141                	addi	sp,sp,-16
    80006026:	e406                	sd	ra,8(sp)
    80006028:	e022                	sd	s0,0(sp)
    8000602a:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    8000602c:	00002597          	auipc	a1,0x2
    80006030:	79c58593          	addi	a1,a1,1948 # 800087c8 <digits+0x18>
    80006034:	00024517          	auipc	a0,0x24
    80006038:	13c50513          	addi	a0,a0,316 # 8002a170 <cons>
    8000603c:	00000097          	auipc	ra,0x0
    80006040:	776080e7          	jalr	1910(ra) # 800067b2 <initlock>

  uartinit();
    80006044:	00000097          	auipc	ra,0x0
    80006048:	32c080e7          	jalr	812(ra) # 80006370 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000604c:	00017797          	auipc	a5,0x17
    80006050:	c5478793          	addi	a5,a5,-940 # 8001cca0 <devsw>
    80006054:	00000717          	auipc	a4,0x0
    80006058:	cea70713          	addi	a4,a4,-790 # 80005d3e <consoleread>
    8000605c:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000605e:	00000717          	auipc	a4,0x0
    80006062:	c7c70713          	addi	a4,a4,-900 # 80005cda <consolewrite>
    80006066:	ef98                	sd	a4,24(a5)
}
    80006068:	60a2                	ld	ra,8(sp)
    8000606a:	6402                	ld	s0,0(sp)
    8000606c:	0141                	addi	sp,sp,16
    8000606e:	8082                	ret

0000000080006070 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80006070:	7179                	addi	sp,sp,-48
    80006072:	f406                	sd	ra,40(sp)
    80006074:	f022                	sd	s0,32(sp)
    80006076:	ec26                	sd	s1,24(sp)
    80006078:	e84a                	sd	s2,16(sp)
    8000607a:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    8000607c:	c219                	beqz	a2,80006082 <printint+0x12>
    8000607e:	08054763          	bltz	a0,8000610c <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80006082:	2501                	sext.w	a0,a0
    80006084:	4881                	li	a7,0
    80006086:	fd040693          	addi	a3,s0,-48

  i = 0;
    8000608a:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    8000608c:	2581                	sext.w	a1,a1
    8000608e:	00002617          	auipc	a2,0x2
    80006092:	75260613          	addi	a2,a2,1874 # 800087e0 <digits>
    80006096:	883a                	mv	a6,a4
    80006098:	2705                	addiw	a4,a4,1
    8000609a:	02b577bb          	remuw	a5,a0,a1
    8000609e:	1782                	slli	a5,a5,0x20
    800060a0:	9381                	srli	a5,a5,0x20
    800060a2:	97b2                	add	a5,a5,a2
    800060a4:	0007c783          	lbu	a5,0(a5)
    800060a8:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800060ac:	0005079b          	sext.w	a5,a0
    800060b0:	02b5553b          	divuw	a0,a0,a1
    800060b4:	0685                	addi	a3,a3,1
    800060b6:	feb7f0e3          	bgeu	a5,a1,80006096 <printint+0x26>

  if(sign)
    800060ba:	00088c63          	beqz	a7,800060d2 <printint+0x62>
    buf[i++] = '-';
    800060be:	fe070793          	addi	a5,a4,-32
    800060c2:	00878733          	add	a4,a5,s0
    800060c6:	02d00793          	li	a5,45
    800060ca:	fef70823          	sb	a5,-16(a4)
    800060ce:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    800060d2:	02e05763          	blez	a4,80006100 <printint+0x90>
    800060d6:	fd040793          	addi	a5,s0,-48
    800060da:	00e784b3          	add	s1,a5,a4
    800060de:	fff78913          	addi	s2,a5,-1
    800060e2:	993a                	add	s2,s2,a4
    800060e4:	377d                	addiw	a4,a4,-1
    800060e6:	1702                	slli	a4,a4,0x20
    800060e8:	9301                	srli	a4,a4,0x20
    800060ea:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    800060ee:	fff4c503          	lbu	a0,-1(s1)
    800060f2:	00000097          	auipc	ra,0x0
    800060f6:	d5e080e7          	jalr	-674(ra) # 80005e50 <consputc>
  while(--i >= 0)
    800060fa:	14fd                	addi	s1,s1,-1
    800060fc:	ff2499e3          	bne	s1,s2,800060ee <printint+0x7e>
}
    80006100:	70a2                	ld	ra,40(sp)
    80006102:	7402                	ld	s0,32(sp)
    80006104:	64e2                	ld	s1,24(sp)
    80006106:	6942                	ld	s2,16(sp)
    80006108:	6145                	addi	sp,sp,48
    8000610a:	8082                	ret
    x = -xx;
    8000610c:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80006110:	4885                	li	a7,1
    x = -xx;
    80006112:	bf95                	j	80006086 <printint+0x16>

0000000080006114 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80006114:	1101                	addi	sp,sp,-32
    80006116:	ec06                	sd	ra,24(sp)
    80006118:	e822                	sd	s0,16(sp)
    8000611a:	e426                	sd	s1,8(sp)
    8000611c:	1000                	addi	s0,sp,32
    8000611e:	84aa                	mv	s1,a0
  pr.locking = 0;
    80006120:	00024797          	auipc	a5,0x24
    80006124:	1207a023          	sw	zero,288(a5) # 8002a240 <pr+0x20>
  printf("panic: ");
    80006128:	00002517          	auipc	a0,0x2
    8000612c:	6a850513          	addi	a0,a0,1704 # 800087d0 <digits+0x20>
    80006130:	00000097          	auipc	ra,0x0
    80006134:	02e080e7          	jalr	46(ra) # 8000615e <printf>
  printf(s);
    80006138:	8526                	mv	a0,s1
    8000613a:	00000097          	auipc	ra,0x0
    8000613e:	024080e7          	jalr	36(ra) # 8000615e <printf>
  printf("\n");
    80006142:	00002517          	auipc	a0,0x2
    80006146:	72650513          	addi	a0,a0,1830 # 80008868 <digits+0x88>
    8000614a:	00000097          	auipc	ra,0x0
    8000614e:	014080e7          	jalr	20(ra) # 8000615e <printf>
  panicked = 1; // freeze uart output from other CPUs
    80006152:	4785                	li	a5,1
    80006154:	00003717          	auipc	a4,0x3
    80006158:	ecf72423          	sw	a5,-312(a4) # 8000901c <panicked>
  for(;;)
    8000615c:	a001                	j	8000615c <panic+0x48>

000000008000615e <printf>:
{
    8000615e:	7131                	addi	sp,sp,-192
    80006160:	fc86                	sd	ra,120(sp)
    80006162:	f8a2                	sd	s0,112(sp)
    80006164:	f4a6                	sd	s1,104(sp)
    80006166:	f0ca                	sd	s2,96(sp)
    80006168:	ecce                	sd	s3,88(sp)
    8000616a:	e8d2                	sd	s4,80(sp)
    8000616c:	e4d6                	sd	s5,72(sp)
    8000616e:	e0da                	sd	s6,64(sp)
    80006170:	fc5e                	sd	s7,56(sp)
    80006172:	f862                	sd	s8,48(sp)
    80006174:	f466                	sd	s9,40(sp)
    80006176:	f06a                	sd	s10,32(sp)
    80006178:	ec6e                	sd	s11,24(sp)
    8000617a:	0100                	addi	s0,sp,128
    8000617c:	8a2a                	mv	s4,a0
    8000617e:	e40c                	sd	a1,8(s0)
    80006180:	e810                	sd	a2,16(s0)
    80006182:	ec14                	sd	a3,24(s0)
    80006184:	f018                	sd	a4,32(s0)
    80006186:	f41c                	sd	a5,40(s0)
    80006188:	03043823          	sd	a6,48(s0)
    8000618c:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80006190:	00024d97          	auipc	s11,0x24
    80006194:	0b0dad83          	lw	s11,176(s11) # 8002a240 <pr+0x20>
  if(locking)
    80006198:	020d9b63          	bnez	s11,800061ce <printf+0x70>
  if (fmt == 0)
    8000619c:	040a0263          	beqz	s4,800061e0 <printf+0x82>
  va_start(ap, fmt);
    800061a0:	00840793          	addi	a5,s0,8
    800061a4:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800061a8:	000a4503          	lbu	a0,0(s4)
    800061ac:	14050f63          	beqz	a0,8000630a <printf+0x1ac>
    800061b0:	4981                	li	s3,0
    if(c != '%'){
    800061b2:	02500a93          	li	s5,37
    switch(c){
    800061b6:	07000b93          	li	s7,112
  consputc('x');
    800061ba:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800061bc:	00002b17          	auipc	s6,0x2
    800061c0:	624b0b13          	addi	s6,s6,1572 # 800087e0 <digits>
    switch(c){
    800061c4:	07300c93          	li	s9,115
    800061c8:	06400c13          	li	s8,100
    800061cc:	a82d                	j	80006206 <printf+0xa8>
    acquire(&pr.lock);
    800061ce:	00024517          	auipc	a0,0x24
    800061d2:	05250513          	addi	a0,a0,82 # 8002a220 <pr>
    800061d6:	00000097          	auipc	ra,0x0
    800061da:	460080e7          	jalr	1120(ra) # 80006636 <acquire>
    800061de:	bf7d                	j	8000619c <printf+0x3e>
    panic("null fmt");
    800061e0:	00002517          	auipc	a0,0x2
    800061e4:	5c050513          	addi	a0,a0,1472 # 800087a0 <syscalls+0x3d8>
    800061e8:	00000097          	auipc	ra,0x0
    800061ec:	f2c080e7          	jalr	-212(ra) # 80006114 <panic>
      consputc(c);
    800061f0:	00000097          	auipc	ra,0x0
    800061f4:	c60080e7          	jalr	-928(ra) # 80005e50 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800061f8:	2985                	addiw	s3,s3,1
    800061fa:	013a07b3          	add	a5,s4,s3
    800061fe:	0007c503          	lbu	a0,0(a5)
    80006202:	10050463          	beqz	a0,8000630a <printf+0x1ac>
    if(c != '%'){
    80006206:	ff5515e3          	bne	a0,s5,800061f0 <printf+0x92>
    c = fmt[++i] & 0xff;
    8000620a:	2985                	addiw	s3,s3,1
    8000620c:	013a07b3          	add	a5,s4,s3
    80006210:	0007c783          	lbu	a5,0(a5)
    80006214:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80006218:	cbed                	beqz	a5,8000630a <printf+0x1ac>
    switch(c){
    8000621a:	05778a63          	beq	a5,s7,8000626e <printf+0x110>
    8000621e:	02fbf663          	bgeu	s7,a5,8000624a <printf+0xec>
    80006222:	09978863          	beq	a5,s9,800062b2 <printf+0x154>
    80006226:	07800713          	li	a4,120
    8000622a:	0ce79563          	bne	a5,a4,800062f4 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    8000622e:	f8843783          	ld	a5,-120(s0)
    80006232:	00878713          	addi	a4,a5,8
    80006236:	f8e43423          	sd	a4,-120(s0)
    8000623a:	4605                	li	a2,1
    8000623c:	85ea                	mv	a1,s10
    8000623e:	4388                	lw	a0,0(a5)
    80006240:	00000097          	auipc	ra,0x0
    80006244:	e30080e7          	jalr	-464(ra) # 80006070 <printint>
      break;
    80006248:	bf45                	j	800061f8 <printf+0x9a>
    switch(c){
    8000624a:	09578f63          	beq	a5,s5,800062e8 <printf+0x18a>
    8000624e:	0b879363          	bne	a5,s8,800062f4 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80006252:	f8843783          	ld	a5,-120(s0)
    80006256:	00878713          	addi	a4,a5,8
    8000625a:	f8e43423          	sd	a4,-120(s0)
    8000625e:	4605                	li	a2,1
    80006260:	45a9                	li	a1,10
    80006262:	4388                	lw	a0,0(a5)
    80006264:	00000097          	auipc	ra,0x0
    80006268:	e0c080e7          	jalr	-500(ra) # 80006070 <printint>
      break;
    8000626c:	b771                	j	800061f8 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    8000626e:	f8843783          	ld	a5,-120(s0)
    80006272:	00878713          	addi	a4,a5,8
    80006276:	f8e43423          	sd	a4,-120(s0)
    8000627a:	0007b903          	ld	s2,0(a5)
  consputc('0');
    8000627e:	03000513          	li	a0,48
    80006282:	00000097          	auipc	ra,0x0
    80006286:	bce080e7          	jalr	-1074(ra) # 80005e50 <consputc>
  consputc('x');
    8000628a:	07800513          	li	a0,120
    8000628e:	00000097          	auipc	ra,0x0
    80006292:	bc2080e7          	jalr	-1086(ra) # 80005e50 <consputc>
    80006296:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006298:	03c95793          	srli	a5,s2,0x3c
    8000629c:	97da                	add	a5,a5,s6
    8000629e:	0007c503          	lbu	a0,0(a5)
    800062a2:	00000097          	auipc	ra,0x0
    800062a6:	bae080e7          	jalr	-1106(ra) # 80005e50 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800062aa:	0912                	slli	s2,s2,0x4
    800062ac:	34fd                	addiw	s1,s1,-1
    800062ae:	f4ed                	bnez	s1,80006298 <printf+0x13a>
    800062b0:	b7a1                	j	800061f8 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    800062b2:	f8843783          	ld	a5,-120(s0)
    800062b6:	00878713          	addi	a4,a5,8
    800062ba:	f8e43423          	sd	a4,-120(s0)
    800062be:	6384                	ld	s1,0(a5)
    800062c0:	cc89                	beqz	s1,800062da <printf+0x17c>
      for(; *s; s++)
    800062c2:	0004c503          	lbu	a0,0(s1)
    800062c6:	d90d                	beqz	a0,800061f8 <printf+0x9a>
        consputc(*s);
    800062c8:	00000097          	auipc	ra,0x0
    800062cc:	b88080e7          	jalr	-1144(ra) # 80005e50 <consputc>
      for(; *s; s++)
    800062d0:	0485                	addi	s1,s1,1
    800062d2:	0004c503          	lbu	a0,0(s1)
    800062d6:	f96d                	bnez	a0,800062c8 <printf+0x16a>
    800062d8:	b705                	j	800061f8 <printf+0x9a>
        s = "(null)";
    800062da:	00002497          	auipc	s1,0x2
    800062de:	4be48493          	addi	s1,s1,1214 # 80008798 <syscalls+0x3d0>
      for(; *s; s++)
    800062e2:	02800513          	li	a0,40
    800062e6:	b7cd                	j	800062c8 <printf+0x16a>
      consputc('%');
    800062e8:	8556                	mv	a0,s5
    800062ea:	00000097          	auipc	ra,0x0
    800062ee:	b66080e7          	jalr	-1178(ra) # 80005e50 <consputc>
      break;
    800062f2:	b719                	j	800061f8 <printf+0x9a>
      consputc('%');
    800062f4:	8556                	mv	a0,s5
    800062f6:	00000097          	auipc	ra,0x0
    800062fa:	b5a080e7          	jalr	-1190(ra) # 80005e50 <consputc>
      consputc(c);
    800062fe:	8526                	mv	a0,s1
    80006300:	00000097          	auipc	ra,0x0
    80006304:	b50080e7          	jalr	-1200(ra) # 80005e50 <consputc>
      break;
    80006308:	bdc5                	j	800061f8 <printf+0x9a>
  if(locking)
    8000630a:	020d9163          	bnez	s11,8000632c <printf+0x1ce>
}
    8000630e:	70e6                	ld	ra,120(sp)
    80006310:	7446                	ld	s0,112(sp)
    80006312:	74a6                	ld	s1,104(sp)
    80006314:	7906                	ld	s2,96(sp)
    80006316:	69e6                	ld	s3,88(sp)
    80006318:	6a46                	ld	s4,80(sp)
    8000631a:	6aa6                	ld	s5,72(sp)
    8000631c:	6b06                	ld	s6,64(sp)
    8000631e:	7be2                	ld	s7,56(sp)
    80006320:	7c42                	ld	s8,48(sp)
    80006322:	7ca2                	ld	s9,40(sp)
    80006324:	7d02                	ld	s10,32(sp)
    80006326:	6de2                	ld	s11,24(sp)
    80006328:	6129                	addi	sp,sp,192
    8000632a:	8082                	ret
    release(&pr.lock);
    8000632c:	00024517          	auipc	a0,0x24
    80006330:	ef450513          	addi	a0,a0,-268 # 8002a220 <pr>
    80006334:	00000097          	auipc	ra,0x0
    80006338:	3d2080e7          	jalr	978(ra) # 80006706 <release>
}
    8000633c:	bfc9                	j	8000630e <printf+0x1b0>

000000008000633e <printfinit>:
    ;
}

void
printfinit(void)
{
    8000633e:	1101                	addi	sp,sp,-32
    80006340:	ec06                	sd	ra,24(sp)
    80006342:	e822                	sd	s0,16(sp)
    80006344:	e426                	sd	s1,8(sp)
    80006346:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80006348:	00024497          	auipc	s1,0x24
    8000634c:	ed848493          	addi	s1,s1,-296 # 8002a220 <pr>
    80006350:	00002597          	auipc	a1,0x2
    80006354:	48858593          	addi	a1,a1,1160 # 800087d8 <digits+0x28>
    80006358:	8526                	mv	a0,s1
    8000635a:	00000097          	auipc	ra,0x0
    8000635e:	458080e7          	jalr	1112(ra) # 800067b2 <initlock>
  pr.locking = 1;
    80006362:	4785                	li	a5,1
    80006364:	d09c                	sw	a5,32(s1)
}
    80006366:	60e2                	ld	ra,24(sp)
    80006368:	6442                	ld	s0,16(sp)
    8000636a:	64a2                	ld	s1,8(sp)
    8000636c:	6105                	addi	sp,sp,32
    8000636e:	8082                	ret

0000000080006370 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80006370:	1141                	addi	sp,sp,-16
    80006372:	e406                	sd	ra,8(sp)
    80006374:	e022                	sd	s0,0(sp)
    80006376:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006378:	100007b7          	lui	a5,0x10000
    8000637c:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80006380:	f8000713          	li	a4,-128
    80006384:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80006388:	470d                	li	a4,3
    8000638a:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    8000638e:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80006392:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80006396:	469d                	li	a3,7
    80006398:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    8000639c:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800063a0:	00002597          	auipc	a1,0x2
    800063a4:	45858593          	addi	a1,a1,1112 # 800087f8 <digits+0x18>
    800063a8:	00024517          	auipc	a0,0x24
    800063ac:	ea050513          	addi	a0,a0,-352 # 8002a248 <uart_tx_lock>
    800063b0:	00000097          	auipc	ra,0x0
    800063b4:	402080e7          	jalr	1026(ra) # 800067b2 <initlock>
}
    800063b8:	60a2                	ld	ra,8(sp)
    800063ba:	6402                	ld	s0,0(sp)
    800063bc:	0141                	addi	sp,sp,16
    800063be:	8082                	ret

00000000800063c0 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800063c0:	1101                	addi	sp,sp,-32
    800063c2:	ec06                	sd	ra,24(sp)
    800063c4:	e822                	sd	s0,16(sp)
    800063c6:	e426                	sd	s1,8(sp)
    800063c8:	1000                	addi	s0,sp,32
    800063ca:	84aa                	mv	s1,a0
  push_off();
    800063cc:	00000097          	auipc	ra,0x0
    800063d0:	21e080e7          	jalr	542(ra) # 800065ea <push_off>

  if(panicked){
    800063d4:	00003797          	auipc	a5,0x3
    800063d8:	c487a783          	lw	a5,-952(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800063dc:	10000737          	lui	a4,0x10000
  if(panicked){
    800063e0:	c391                	beqz	a5,800063e4 <uartputc_sync+0x24>
    for(;;)
    800063e2:	a001                	j	800063e2 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800063e4:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    800063e8:	0207f793          	andi	a5,a5,32
    800063ec:	dfe5                	beqz	a5,800063e4 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    800063ee:	0ff4f513          	zext.b	a0,s1
    800063f2:	100007b7          	lui	a5,0x10000
    800063f6:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    800063fa:	00000097          	auipc	ra,0x0
    800063fe:	2ac080e7          	jalr	684(ra) # 800066a6 <pop_off>
}
    80006402:	60e2                	ld	ra,24(sp)
    80006404:	6442                	ld	s0,16(sp)
    80006406:	64a2                	ld	s1,8(sp)
    80006408:	6105                	addi	sp,sp,32
    8000640a:	8082                	ret

000000008000640c <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000640c:	00003797          	auipc	a5,0x3
    80006410:	c147b783          	ld	a5,-1004(a5) # 80009020 <uart_tx_r>
    80006414:	00003717          	auipc	a4,0x3
    80006418:	c1473703          	ld	a4,-1004(a4) # 80009028 <uart_tx_w>
    8000641c:	06f70a63          	beq	a4,a5,80006490 <uartstart+0x84>
{
    80006420:	7139                	addi	sp,sp,-64
    80006422:	fc06                	sd	ra,56(sp)
    80006424:	f822                	sd	s0,48(sp)
    80006426:	f426                	sd	s1,40(sp)
    80006428:	f04a                	sd	s2,32(sp)
    8000642a:	ec4e                	sd	s3,24(sp)
    8000642c:	e852                	sd	s4,16(sp)
    8000642e:	e456                	sd	s5,8(sp)
    80006430:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006432:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006436:	00024a17          	auipc	s4,0x24
    8000643a:	e12a0a13          	addi	s4,s4,-494 # 8002a248 <uart_tx_lock>
    uart_tx_r += 1;
    8000643e:	00003497          	auipc	s1,0x3
    80006442:	be248493          	addi	s1,s1,-1054 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80006446:	00003997          	auipc	s3,0x3
    8000644a:	be298993          	addi	s3,s3,-1054 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000644e:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80006452:	02077713          	andi	a4,a4,32
    80006456:	c705                	beqz	a4,8000647e <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006458:	01f7f713          	andi	a4,a5,31
    8000645c:	9752                	add	a4,a4,s4
    8000645e:	02074a83          	lbu	s5,32(a4)
    uart_tx_r += 1;
    80006462:	0785                	addi	a5,a5,1
    80006464:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80006466:	8526                	mv	a0,s1
    80006468:	ffffb097          	auipc	ra,0xffffb
    8000646c:	340080e7          	jalr	832(ra) # 800017a8 <wakeup>
    
    WriteReg(THR, c);
    80006470:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80006474:	609c                	ld	a5,0(s1)
    80006476:	0009b703          	ld	a4,0(s3)
    8000647a:	fcf71ae3          	bne	a4,a5,8000644e <uartstart+0x42>
  }
}
    8000647e:	70e2                	ld	ra,56(sp)
    80006480:	7442                	ld	s0,48(sp)
    80006482:	74a2                	ld	s1,40(sp)
    80006484:	7902                	ld	s2,32(sp)
    80006486:	69e2                	ld	s3,24(sp)
    80006488:	6a42                	ld	s4,16(sp)
    8000648a:	6aa2                	ld	s5,8(sp)
    8000648c:	6121                	addi	sp,sp,64
    8000648e:	8082                	ret
    80006490:	8082                	ret

0000000080006492 <uartputc>:
{
    80006492:	7179                	addi	sp,sp,-48
    80006494:	f406                	sd	ra,40(sp)
    80006496:	f022                	sd	s0,32(sp)
    80006498:	ec26                	sd	s1,24(sp)
    8000649a:	e84a                	sd	s2,16(sp)
    8000649c:	e44e                	sd	s3,8(sp)
    8000649e:	e052                	sd	s4,0(sp)
    800064a0:	1800                	addi	s0,sp,48
    800064a2:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800064a4:	00024517          	auipc	a0,0x24
    800064a8:	da450513          	addi	a0,a0,-604 # 8002a248 <uart_tx_lock>
    800064ac:	00000097          	auipc	ra,0x0
    800064b0:	18a080e7          	jalr	394(ra) # 80006636 <acquire>
  if(panicked){
    800064b4:	00003797          	auipc	a5,0x3
    800064b8:	b687a783          	lw	a5,-1176(a5) # 8000901c <panicked>
    800064bc:	c391                	beqz	a5,800064c0 <uartputc+0x2e>
    for(;;)
    800064be:	a001                	j	800064be <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800064c0:	00003717          	auipc	a4,0x3
    800064c4:	b6873703          	ld	a4,-1176(a4) # 80009028 <uart_tx_w>
    800064c8:	00003797          	auipc	a5,0x3
    800064cc:	b587b783          	ld	a5,-1192(a5) # 80009020 <uart_tx_r>
    800064d0:	02078793          	addi	a5,a5,32
    800064d4:	02e79b63          	bne	a5,a4,8000650a <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    800064d8:	00024997          	auipc	s3,0x24
    800064dc:	d7098993          	addi	s3,s3,-656 # 8002a248 <uart_tx_lock>
    800064e0:	00003497          	auipc	s1,0x3
    800064e4:	b4048493          	addi	s1,s1,-1216 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800064e8:	00003917          	auipc	s2,0x3
    800064ec:	b4090913          	addi	s2,s2,-1216 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    800064f0:	85ce                	mv	a1,s3
    800064f2:	8526                	mv	a0,s1
    800064f4:	ffffb097          	auipc	ra,0xffffb
    800064f8:	128080e7          	jalr	296(ra) # 8000161c <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800064fc:	00093703          	ld	a4,0(s2)
    80006500:	609c                	ld	a5,0(s1)
    80006502:	02078793          	addi	a5,a5,32
    80006506:	fee785e3          	beq	a5,a4,800064f0 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    8000650a:	00024497          	auipc	s1,0x24
    8000650e:	d3e48493          	addi	s1,s1,-706 # 8002a248 <uart_tx_lock>
    80006512:	01f77793          	andi	a5,a4,31
    80006516:	97a6                	add	a5,a5,s1
    80006518:	03478023          	sb	s4,32(a5)
      uart_tx_w += 1;
    8000651c:	0705                	addi	a4,a4,1
    8000651e:	00003797          	auipc	a5,0x3
    80006522:	b0e7b523          	sd	a4,-1270(a5) # 80009028 <uart_tx_w>
      uartstart();
    80006526:	00000097          	auipc	ra,0x0
    8000652a:	ee6080e7          	jalr	-282(ra) # 8000640c <uartstart>
      release(&uart_tx_lock);
    8000652e:	8526                	mv	a0,s1
    80006530:	00000097          	auipc	ra,0x0
    80006534:	1d6080e7          	jalr	470(ra) # 80006706 <release>
}
    80006538:	70a2                	ld	ra,40(sp)
    8000653a:	7402                	ld	s0,32(sp)
    8000653c:	64e2                	ld	s1,24(sp)
    8000653e:	6942                	ld	s2,16(sp)
    80006540:	69a2                	ld	s3,8(sp)
    80006542:	6a02                	ld	s4,0(sp)
    80006544:	6145                	addi	sp,sp,48
    80006546:	8082                	ret

0000000080006548 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006548:	1141                	addi	sp,sp,-16
    8000654a:	e422                	sd	s0,8(sp)
    8000654c:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    8000654e:	100007b7          	lui	a5,0x10000
    80006552:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006556:	8b85                	andi	a5,a5,1
    80006558:	cb81                	beqz	a5,80006568 <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    8000655a:	100007b7          	lui	a5,0x10000
    8000655e:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80006562:	6422                	ld	s0,8(sp)
    80006564:	0141                	addi	sp,sp,16
    80006566:	8082                	ret
    return -1;
    80006568:	557d                	li	a0,-1
    8000656a:	bfe5                	j	80006562 <uartgetc+0x1a>

000000008000656c <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    8000656c:	1101                	addi	sp,sp,-32
    8000656e:	ec06                	sd	ra,24(sp)
    80006570:	e822                	sd	s0,16(sp)
    80006572:	e426                	sd	s1,8(sp)
    80006574:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006576:	54fd                	li	s1,-1
    80006578:	a029                	j	80006582 <uartintr+0x16>
      break;
    consoleintr(c);
    8000657a:	00000097          	auipc	ra,0x0
    8000657e:	918080e7          	jalr	-1768(ra) # 80005e92 <consoleintr>
    int c = uartgetc();
    80006582:	00000097          	auipc	ra,0x0
    80006586:	fc6080e7          	jalr	-58(ra) # 80006548 <uartgetc>
    if(c == -1)
    8000658a:	fe9518e3          	bne	a0,s1,8000657a <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000658e:	00024497          	auipc	s1,0x24
    80006592:	cba48493          	addi	s1,s1,-838 # 8002a248 <uart_tx_lock>
    80006596:	8526                	mv	a0,s1
    80006598:	00000097          	auipc	ra,0x0
    8000659c:	09e080e7          	jalr	158(ra) # 80006636 <acquire>
  uartstart();
    800065a0:	00000097          	auipc	ra,0x0
    800065a4:	e6c080e7          	jalr	-404(ra) # 8000640c <uartstart>
  release(&uart_tx_lock);
    800065a8:	8526                	mv	a0,s1
    800065aa:	00000097          	auipc	ra,0x0
    800065ae:	15c080e7          	jalr	348(ra) # 80006706 <release>
}
    800065b2:	60e2                	ld	ra,24(sp)
    800065b4:	6442                	ld	s0,16(sp)
    800065b6:	64a2                	ld	s1,8(sp)
    800065b8:	6105                	addi	sp,sp,32
    800065ba:	8082                	ret

00000000800065bc <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800065bc:	411c                	lw	a5,0(a0)
    800065be:	e399                	bnez	a5,800065c4 <holding+0x8>
    800065c0:	4501                	li	a0,0
  return r;
}
    800065c2:	8082                	ret
{
    800065c4:	1101                	addi	sp,sp,-32
    800065c6:	ec06                	sd	ra,24(sp)
    800065c8:	e822                	sd	s0,16(sp)
    800065ca:	e426                	sd	s1,8(sp)
    800065cc:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800065ce:	6904                	ld	s1,16(a0)
    800065d0:	ffffb097          	auipc	ra,0xffffb
    800065d4:	96c080e7          	jalr	-1684(ra) # 80000f3c <mycpu>
    800065d8:	40a48533          	sub	a0,s1,a0
    800065dc:	00153513          	seqz	a0,a0
}
    800065e0:	60e2                	ld	ra,24(sp)
    800065e2:	6442                	ld	s0,16(sp)
    800065e4:	64a2                	ld	s1,8(sp)
    800065e6:	6105                	addi	sp,sp,32
    800065e8:	8082                	ret

00000000800065ea <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800065ea:	1101                	addi	sp,sp,-32
    800065ec:	ec06                	sd	ra,24(sp)
    800065ee:	e822                	sd	s0,16(sp)
    800065f0:	e426                	sd	s1,8(sp)
    800065f2:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800065f4:	100024f3          	csrr	s1,sstatus
    800065f8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800065fc:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800065fe:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006602:	ffffb097          	auipc	ra,0xffffb
    80006606:	93a080e7          	jalr	-1734(ra) # 80000f3c <mycpu>
    8000660a:	5d3c                	lw	a5,120(a0)
    8000660c:	cf89                	beqz	a5,80006626 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    8000660e:	ffffb097          	auipc	ra,0xffffb
    80006612:	92e080e7          	jalr	-1746(ra) # 80000f3c <mycpu>
    80006616:	5d3c                	lw	a5,120(a0)
    80006618:	2785                	addiw	a5,a5,1
    8000661a:	dd3c                	sw	a5,120(a0)
}
    8000661c:	60e2                	ld	ra,24(sp)
    8000661e:	6442                	ld	s0,16(sp)
    80006620:	64a2                	ld	s1,8(sp)
    80006622:	6105                	addi	sp,sp,32
    80006624:	8082                	ret
    mycpu()->intena = old;
    80006626:	ffffb097          	auipc	ra,0xffffb
    8000662a:	916080e7          	jalr	-1770(ra) # 80000f3c <mycpu>
  return (x & SSTATUS_SIE) != 0;
    8000662e:	8085                	srli	s1,s1,0x1
    80006630:	8885                	andi	s1,s1,1
    80006632:	dd64                	sw	s1,124(a0)
    80006634:	bfe9                	j	8000660e <push_off+0x24>

0000000080006636 <acquire>:
{
    80006636:	1101                	addi	sp,sp,-32
    80006638:	ec06                	sd	ra,24(sp)
    8000663a:	e822                	sd	s0,16(sp)
    8000663c:	e426                	sd	s1,8(sp)
    8000663e:	1000                	addi	s0,sp,32
    80006640:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80006642:	00000097          	auipc	ra,0x0
    80006646:	fa8080e7          	jalr	-88(ra) # 800065ea <push_off>
  if(holding(lk))
    8000664a:	8526                	mv	a0,s1
    8000664c:	00000097          	auipc	ra,0x0
    80006650:	f70080e7          	jalr	-144(ra) # 800065bc <holding>
    80006654:	e911                	bnez	a0,80006668 <acquire+0x32>
    __sync_fetch_and_add(&(lk->n), 1);
    80006656:	4785                	li	a5,1
    80006658:	01c48713          	addi	a4,s1,28
    8000665c:	0f50000f          	fence	iorw,ow
    80006660:	04f7202f          	amoadd.w.aq	zero,a5,(a4)
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0) {
    80006664:	4705                	li	a4,1
    80006666:	a839                	j	80006684 <acquire+0x4e>
    panic("acquire");
    80006668:	00002517          	auipc	a0,0x2
    8000666c:	19850513          	addi	a0,a0,408 # 80008800 <digits+0x20>
    80006670:	00000097          	auipc	ra,0x0
    80006674:	aa4080e7          	jalr	-1372(ra) # 80006114 <panic>
    __sync_fetch_and_add(&(lk->nts), 1);
    80006678:	01848793          	addi	a5,s1,24
    8000667c:	0f50000f          	fence	iorw,ow
    80006680:	04e7a02f          	amoadd.w.aq	zero,a4,(a5)
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0) {
    80006684:	87ba                	mv	a5,a4
    80006686:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000668a:	2781                	sext.w	a5,a5
    8000668c:	f7f5                	bnez	a5,80006678 <acquire+0x42>
  __sync_synchronize();
    8000668e:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006692:	ffffb097          	auipc	ra,0xffffb
    80006696:	8aa080e7          	jalr	-1878(ra) # 80000f3c <mycpu>
    8000669a:	e888                	sd	a0,16(s1)
}
    8000669c:	60e2                	ld	ra,24(sp)
    8000669e:	6442                	ld	s0,16(sp)
    800066a0:	64a2                	ld	s1,8(sp)
    800066a2:	6105                	addi	sp,sp,32
    800066a4:	8082                	ret

00000000800066a6 <pop_off>:

void
pop_off(void)
{
    800066a6:	1141                	addi	sp,sp,-16
    800066a8:	e406                	sd	ra,8(sp)
    800066aa:	e022                	sd	s0,0(sp)
    800066ac:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800066ae:	ffffb097          	auipc	ra,0xffffb
    800066b2:	88e080e7          	jalr	-1906(ra) # 80000f3c <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800066b6:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800066ba:	8b89                	andi	a5,a5,2
  if(intr_get())
    800066bc:	e78d                	bnez	a5,800066e6 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800066be:	5d3c                	lw	a5,120(a0)
    800066c0:	02f05b63          	blez	a5,800066f6 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    800066c4:	37fd                	addiw	a5,a5,-1
    800066c6:	0007871b          	sext.w	a4,a5
    800066ca:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800066cc:	eb09                	bnez	a4,800066de <pop_off+0x38>
    800066ce:	5d7c                	lw	a5,124(a0)
    800066d0:	c799                	beqz	a5,800066de <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800066d2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800066d6:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800066da:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800066de:	60a2                	ld	ra,8(sp)
    800066e0:	6402                	ld	s0,0(sp)
    800066e2:	0141                	addi	sp,sp,16
    800066e4:	8082                	ret
    panic("pop_off - interruptible");
    800066e6:	00002517          	auipc	a0,0x2
    800066ea:	12250513          	addi	a0,a0,290 # 80008808 <digits+0x28>
    800066ee:	00000097          	auipc	ra,0x0
    800066f2:	a26080e7          	jalr	-1498(ra) # 80006114 <panic>
    panic("pop_off");
    800066f6:	00002517          	auipc	a0,0x2
    800066fa:	12a50513          	addi	a0,a0,298 # 80008820 <digits+0x40>
    800066fe:	00000097          	auipc	ra,0x0
    80006702:	a16080e7          	jalr	-1514(ra) # 80006114 <panic>

0000000080006706 <release>:
{
    80006706:	1101                	addi	sp,sp,-32
    80006708:	ec06                	sd	ra,24(sp)
    8000670a:	e822                	sd	s0,16(sp)
    8000670c:	e426                	sd	s1,8(sp)
    8000670e:	1000                	addi	s0,sp,32
    80006710:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006712:	00000097          	auipc	ra,0x0
    80006716:	eaa080e7          	jalr	-342(ra) # 800065bc <holding>
    8000671a:	c115                	beqz	a0,8000673e <release+0x38>
  lk->cpu = 0;
    8000671c:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006720:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80006724:	0f50000f          	fence	iorw,ow
    80006728:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    8000672c:	00000097          	auipc	ra,0x0
    80006730:	f7a080e7          	jalr	-134(ra) # 800066a6 <pop_off>
}
    80006734:	60e2                	ld	ra,24(sp)
    80006736:	6442                	ld	s0,16(sp)
    80006738:	64a2                	ld	s1,8(sp)
    8000673a:	6105                	addi	sp,sp,32
    8000673c:	8082                	ret
    panic("release");
    8000673e:	00002517          	auipc	a0,0x2
    80006742:	0ea50513          	addi	a0,a0,234 # 80008828 <digits+0x48>
    80006746:	00000097          	auipc	ra,0x0
    8000674a:	9ce080e7          	jalr	-1586(ra) # 80006114 <panic>

000000008000674e <freelock>:
{
    8000674e:	1101                	addi	sp,sp,-32
    80006750:	ec06                	sd	ra,24(sp)
    80006752:	e822                	sd	s0,16(sp)
    80006754:	e426                	sd	s1,8(sp)
    80006756:	1000                	addi	s0,sp,32
    80006758:	84aa                	mv	s1,a0
  acquire(&lock_locks);
    8000675a:	00024517          	auipc	a0,0x24
    8000675e:	b2e50513          	addi	a0,a0,-1234 # 8002a288 <lock_locks>
    80006762:	00000097          	auipc	ra,0x0
    80006766:	ed4080e7          	jalr	-300(ra) # 80006636 <acquire>
  for (i = 0; i < NLOCK; i++) {
    8000676a:	00024717          	auipc	a4,0x24
    8000676e:	b3e70713          	addi	a4,a4,-1218 # 8002a2a8 <locks>
    80006772:	4781                	li	a5,0
    80006774:	1f400613          	li	a2,500
    if(locks[i] == lk) {
    80006778:	6314                	ld	a3,0(a4)
    8000677a:	00968763          	beq	a3,s1,80006788 <freelock+0x3a>
  for (i = 0; i < NLOCK; i++) {
    8000677e:	2785                	addiw	a5,a5,1
    80006780:	0721                	addi	a4,a4,8
    80006782:	fec79be3          	bne	a5,a2,80006778 <freelock+0x2a>
    80006786:	a809                	j	80006798 <freelock+0x4a>
      locks[i] = 0;
    80006788:	078e                	slli	a5,a5,0x3
    8000678a:	00024717          	auipc	a4,0x24
    8000678e:	b1e70713          	addi	a4,a4,-1250 # 8002a2a8 <locks>
    80006792:	97ba                	add	a5,a5,a4
    80006794:	0007b023          	sd	zero,0(a5)
  release(&lock_locks);
    80006798:	00024517          	auipc	a0,0x24
    8000679c:	af050513          	addi	a0,a0,-1296 # 8002a288 <lock_locks>
    800067a0:	00000097          	auipc	ra,0x0
    800067a4:	f66080e7          	jalr	-154(ra) # 80006706 <release>
}
    800067a8:	60e2                	ld	ra,24(sp)
    800067aa:	6442                	ld	s0,16(sp)
    800067ac:	64a2                	ld	s1,8(sp)
    800067ae:	6105                	addi	sp,sp,32
    800067b0:	8082                	ret

00000000800067b2 <initlock>:
{
    800067b2:	1101                	addi	sp,sp,-32
    800067b4:	ec06                	sd	ra,24(sp)
    800067b6:	e822                	sd	s0,16(sp)
    800067b8:	e426                	sd	s1,8(sp)
    800067ba:	1000                	addi	s0,sp,32
    800067bc:	84aa                	mv	s1,a0
  lk->name = name;
    800067be:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800067c0:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800067c4:	00053823          	sd	zero,16(a0)
  lk->nts = 0;
    800067c8:	00052c23          	sw	zero,24(a0)
  lk->n = 0;
    800067cc:	00052e23          	sw	zero,28(a0)
  acquire(&lock_locks);
    800067d0:	00024517          	auipc	a0,0x24
    800067d4:	ab850513          	addi	a0,a0,-1352 # 8002a288 <lock_locks>
    800067d8:	00000097          	auipc	ra,0x0
    800067dc:	e5e080e7          	jalr	-418(ra) # 80006636 <acquire>
  for (i = 0; i < NLOCK; i++) {
    800067e0:	00024717          	auipc	a4,0x24
    800067e4:	ac870713          	addi	a4,a4,-1336 # 8002a2a8 <locks>
    800067e8:	4781                	li	a5,0
    800067ea:	1f400613          	li	a2,500
    if(locks[i] == 0) {
    800067ee:	6314                	ld	a3,0(a4)
    800067f0:	ce89                	beqz	a3,8000680a <initlock+0x58>
  for (i = 0; i < NLOCK; i++) {
    800067f2:	2785                	addiw	a5,a5,1
    800067f4:	0721                	addi	a4,a4,8
    800067f6:	fec79ce3          	bne	a5,a2,800067ee <initlock+0x3c>
  panic("findslot");
    800067fa:	00002517          	auipc	a0,0x2
    800067fe:	03650513          	addi	a0,a0,54 # 80008830 <digits+0x50>
    80006802:	00000097          	auipc	ra,0x0
    80006806:	912080e7          	jalr	-1774(ra) # 80006114 <panic>
      locks[i] = lk;
    8000680a:	078e                	slli	a5,a5,0x3
    8000680c:	00024717          	auipc	a4,0x24
    80006810:	a9c70713          	addi	a4,a4,-1380 # 8002a2a8 <locks>
    80006814:	97ba                	add	a5,a5,a4
    80006816:	e384                	sd	s1,0(a5)
      release(&lock_locks);
    80006818:	00024517          	auipc	a0,0x24
    8000681c:	a7050513          	addi	a0,a0,-1424 # 8002a288 <lock_locks>
    80006820:	00000097          	auipc	ra,0x0
    80006824:	ee6080e7          	jalr	-282(ra) # 80006706 <release>
}
    80006828:	60e2                	ld	ra,24(sp)
    8000682a:	6442                	ld	s0,16(sp)
    8000682c:	64a2                	ld	s1,8(sp)
    8000682e:	6105                	addi	sp,sp,32
    80006830:	8082                	ret

0000000080006832 <lockfree_read8>:

// Read a shared 64-bit value without holding a lock
uint64
lockfree_read8(uint64 *addr) {
    80006832:	1141                	addi	sp,sp,-16
    80006834:	e422                	sd	s0,8(sp)
    80006836:	0800                	addi	s0,sp,16
  uint64 val;
  __atomic_load(addr, &val, __ATOMIC_SEQ_CST);
    80006838:	0ff0000f          	fence
    8000683c:	6108                	ld	a0,0(a0)
    8000683e:	0ff0000f          	fence
  return val;
}
    80006842:	6422                	ld	s0,8(sp)
    80006844:	0141                	addi	sp,sp,16
    80006846:	8082                	ret

0000000080006848 <lockfree_read4>:

// Read a shared 32-bit value without holding a lock
int
lockfree_read4(int *addr) {
    80006848:	1141                	addi	sp,sp,-16
    8000684a:	e422                	sd	s0,8(sp)
    8000684c:	0800                	addi	s0,sp,16
  uint32 val;
  __atomic_load(addr, &val, __ATOMIC_SEQ_CST);
    8000684e:	0ff0000f          	fence
    80006852:	4108                	lw	a0,0(a0)
    80006854:	0ff0000f          	fence
  return val;
}
    80006858:	6422                	ld	s0,8(sp)
    8000685a:	0141                	addi	sp,sp,16
    8000685c:	8082                	ret

000000008000685e <snprint_lock>:
#ifdef LAB_LOCK
int
snprint_lock(char *buf, int sz, struct spinlock *lk)
{
  int n = 0;
  if(lk->n > 0) {
    8000685e:	4e5c                	lw	a5,28(a2)
    80006860:	00f04463          	bgtz	a5,80006868 <snprint_lock+0xa>
  int n = 0;
    80006864:	4501                	li	a0,0
    n = snprintf(buf, sz, "lock: %s: #test-and-set %d #acquire() %d\n",
                 lk->name, lk->nts, lk->n);
  }
  return n;
}
    80006866:	8082                	ret
{
    80006868:	1141                	addi	sp,sp,-16
    8000686a:	e406                	sd	ra,8(sp)
    8000686c:	e022                	sd	s0,0(sp)
    8000686e:	0800                	addi	s0,sp,16
    n = snprintf(buf, sz, "lock: %s: #test-and-set %d #acquire() %d\n",
    80006870:	4e18                	lw	a4,24(a2)
    80006872:	6614                	ld	a3,8(a2)
    80006874:	00002617          	auipc	a2,0x2
    80006878:	fcc60613          	addi	a2,a2,-52 # 80008840 <digits+0x60>
    8000687c:	fffff097          	auipc	ra,0xfffff
    80006880:	204080e7          	jalr	516(ra) # 80005a80 <snprintf>
}
    80006884:	60a2                	ld	ra,8(sp)
    80006886:	6402                	ld	s0,0(sp)
    80006888:	0141                	addi	sp,sp,16
    8000688a:	8082                	ret

000000008000688c <statslock>:

int
statslock(char *buf, int sz) {
    8000688c:	7159                	addi	sp,sp,-112
    8000688e:	f486                	sd	ra,104(sp)
    80006890:	f0a2                	sd	s0,96(sp)
    80006892:	eca6                	sd	s1,88(sp)
    80006894:	e8ca                	sd	s2,80(sp)
    80006896:	e4ce                	sd	s3,72(sp)
    80006898:	e0d2                	sd	s4,64(sp)
    8000689a:	fc56                	sd	s5,56(sp)
    8000689c:	f85a                	sd	s6,48(sp)
    8000689e:	f45e                	sd	s7,40(sp)
    800068a0:	f062                	sd	s8,32(sp)
    800068a2:	ec66                	sd	s9,24(sp)
    800068a4:	e86a                	sd	s10,16(sp)
    800068a6:	e46e                	sd	s11,8(sp)
    800068a8:	1880                	addi	s0,sp,112
    800068aa:	8aaa                	mv	s5,a0
    800068ac:	8b2e                	mv	s6,a1
  int n;
  int tot = 0;

  acquire(&lock_locks);
    800068ae:	00024517          	auipc	a0,0x24
    800068b2:	9da50513          	addi	a0,a0,-1574 # 8002a288 <lock_locks>
    800068b6:	00000097          	auipc	ra,0x0
    800068ba:	d80080e7          	jalr	-640(ra) # 80006636 <acquire>
  n = snprintf(buf, sz, "--- lock kmem/bcache stats\n");
    800068be:	00002617          	auipc	a2,0x2
    800068c2:	fb260613          	addi	a2,a2,-78 # 80008870 <digits+0x90>
    800068c6:	85da                	mv	a1,s6
    800068c8:	8556                	mv	a0,s5
    800068ca:	fffff097          	auipc	ra,0xfffff
    800068ce:	1b6080e7          	jalr	438(ra) # 80005a80 <snprintf>
    800068d2:	892a                	mv	s2,a0
  for(int i = 0; i < NLOCK; i++) {
    800068d4:	00024c97          	auipc	s9,0x24
    800068d8:	9d4c8c93          	addi	s9,s9,-1580 # 8002a2a8 <locks>
    800068dc:	00025c17          	auipc	s8,0x25
    800068e0:	96cc0c13          	addi	s8,s8,-1684 # 8002b248 <end>
  n = snprintf(buf, sz, "--- lock kmem/bcache stats\n");
    800068e4:	84e6                	mv	s1,s9
  int tot = 0;
    800068e6:	4a01                	li	s4,0
    if(locks[i] == 0)
      break;
    if(strncmp(locks[i]->name, "bcache", strlen("bcache")) == 0 ||
    800068e8:	00002b97          	auipc	s7,0x2
    800068ec:	fa8b8b93          	addi	s7,s7,-88 # 80008890 <digits+0xb0>
       strncmp(locks[i]->name, "kmem", strlen("kmem")) == 0) {
    800068f0:	00002d17          	auipc	s10,0x2
    800068f4:	fa8d0d13          	addi	s10,s10,-88 # 80008898 <digits+0xb8>
    800068f8:	a01d                	j	8000691e <statslock+0x92>
      tot += locks[i]->nts;
    800068fa:	0009b603          	ld	a2,0(s3)
    800068fe:	4e1c                	lw	a5,24(a2)
    80006900:	01478a3b          	addw	s4,a5,s4
      n += snprint_lock(buf +n, sz-n, locks[i]);
    80006904:	412b05bb          	subw	a1,s6,s2
    80006908:	012a8533          	add	a0,s5,s2
    8000690c:	00000097          	auipc	ra,0x0
    80006910:	f52080e7          	jalr	-174(ra) # 8000685e <snprint_lock>
    80006914:	0125093b          	addw	s2,a0,s2
  for(int i = 0; i < NLOCK; i++) {
    80006918:	04a1                	addi	s1,s1,8
    8000691a:	05848763          	beq	s1,s8,80006968 <statslock+0xdc>
    if(locks[i] == 0)
    8000691e:	89a6                	mv	s3,s1
    80006920:	609c                	ld	a5,0(s1)
    80006922:	c3b9                	beqz	a5,80006968 <statslock+0xdc>
    if(strncmp(locks[i]->name, "bcache", strlen("bcache")) == 0 ||
    80006924:	0087bd83          	ld	s11,8(a5)
    80006928:	855e                	mv	a0,s7
    8000692a:	ffffa097          	auipc	ra,0xffffa
    8000692e:	ad0080e7          	jalr	-1328(ra) # 800003fa <strlen>
    80006932:	0005061b          	sext.w	a2,a0
    80006936:	85de                	mv	a1,s7
    80006938:	856e                	mv	a0,s11
    8000693a:	ffffa097          	auipc	ra,0xffffa
    8000693e:	a14080e7          	jalr	-1516(ra) # 8000034e <strncmp>
    80006942:	dd45                	beqz	a0,800068fa <statslock+0x6e>
       strncmp(locks[i]->name, "kmem", strlen("kmem")) == 0) {
    80006944:	609c                	ld	a5,0(s1)
    80006946:	0087bd83          	ld	s11,8(a5)
    8000694a:	856a                	mv	a0,s10
    8000694c:	ffffa097          	auipc	ra,0xffffa
    80006950:	aae080e7          	jalr	-1362(ra) # 800003fa <strlen>
    80006954:	0005061b          	sext.w	a2,a0
    80006958:	85ea                	mv	a1,s10
    8000695a:	856e                	mv	a0,s11
    8000695c:	ffffa097          	auipc	ra,0xffffa
    80006960:	9f2080e7          	jalr	-1550(ra) # 8000034e <strncmp>
    if(strncmp(locks[i]->name, "bcache", strlen("bcache")) == 0 ||
    80006964:	f955                	bnez	a0,80006918 <statslock+0x8c>
    80006966:	bf51                	j	800068fa <statslock+0x6e>
    }
  }
  
  n += snprintf(buf+n, sz-n, "--- top 5 contended locks:\n");
    80006968:	00002617          	auipc	a2,0x2
    8000696c:	f3860613          	addi	a2,a2,-200 # 800088a0 <digits+0xc0>
    80006970:	412b05bb          	subw	a1,s6,s2
    80006974:	012a8533          	add	a0,s5,s2
    80006978:	fffff097          	auipc	ra,0xfffff
    8000697c:	108080e7          	jalr	264(ra) # 80005a80 <snprintf>
    80006980:	012509bb          	addw	s3,a0,s2
    80006984:	4b95                	li	s7,5
  int last = 100000000;
    80006986:	05f5e537          	lui	a0,0x5f5e
    8000698a:	10050513          	addi	a0,a0,256 # 5f5e100 <_entry-0x7a0a1f00>
  // stupid way to compute top 5 contended locks
  for(int t = 0; t < 5; t++) {
    int top = 0;
    for(int i = 0; i < NLOCK; i++) {
    8000698e:	4c01                	li	s8,0
      if(locks[i] == 0)
        break;
      if(locks[i]->nts > locks[top]->nts && locks[i]->nts < last) {
    80006990:	00024497          	auipc	s1,0x24
    80006994:	91848493          	addi	s1,s1,-1768 # 8002a2a8 <locks>
    for(int i = 0; i < NLOCK; i++) {
    80006998:	1f400913          	li	s2,500
    8000699c:	a881                	j	800069ec <statslock+0x160>
    8000699e:	2705                	addiw	a4,a4,1
    800069a0:	06a1                	addi	a3,a3,8
    800069a2:	03270063          	beq	a4,s2,800069c2 <statslock+0x136>
      if(locks[i] == 0)
    800069a6:	629c                	ld	a5,0(a3)
    800069a8:	cf89                	beqz	a5,800069c2 <statslock+0x136>
      if(locks[i]->nts > locks[top]->nts && locks[i]->nts < last) {
    800069aa:	4f90                	lw	a2,24(a5)
    800069ac:	00359793          	slli	a5,a1,0x3
    800069b0:	97a6                	add	a5,a5,s1
    800069b2:	639c                	ld	a5,0(a5)
    800069b4:	4f9c                	lw	a5,24(a5)
    800069b6:	fec7d4e3          	bge	a5,a2,8000699e <statslock+0x112>
    800069ba:	fea652e3          	bge	a2,a0,8000699e <statslock+0x112>
    800069be:	85ba                	mv	a1,a4
    800069c0:	bff9                	j	8000699e <statslock+0x112>
        top = i;
      }
    }
    n += snprint_lock(buf+n, sz-n, locks[top]);
    800069c2:	058e                	slli	a1,a1,0x3
    800069c4:	00b48d33          	add	s10,s1,a1
    800069c8:	000d3603          	ld	a2,0(s10)
    800069cc:	413b05bb          	subw	a1,s6,s3
    800069d0:	013a8533          	add	a0,s5,s3
    800069d4:	00000097          	auipc	ra,0x0
    800069d8:	e8a080e7          	jalr	-374(ra) # 8000685e <snprint_lock>
    800069dc:	013509bb          	addw	s3,a0,s3
    last = locks[top]->nts;
    800069e0:	000d3783          	ld	a5,0(s10)
    800069e4:	4f88                	lw	a0,24(a5)
  for(int t = 0; t < 5; t++) {
    800069e6:	3bfd                	addiw	s7,s7,-1
    800069e8:	000b8663          	beqz	s7,800069f4 <statslock+0x168>
  int tot = 0;
    800069ec:	86e6                	mv	a3,s9
    for(int i = 0; i < NLOCK; i++) {
    800069ee:	8762                	mv	a4,s8
    int top = 0;
    800069f0:	85e2                	mv	a1,s8
    800069f2:	bf55                	j	800069a6 <statslock+0x11a>
  }
  n += snprintf(buf+n, sz-n, "tot= %d\n", tot);
    800069f4:	86d2                	mv	a3,s4
    800069f6:	00002617          	auipc	a2,0x2
    800069fa:	eca60613          	addi	a2,a2,-310 # 800088c0 <digits+0xe0>
    800069fe:	413b05bb          	subw	a1,s6,s3
    80006a02:	013a8533          	add	a0,s5,s3
    80006a06:	fffff097          	auipc	ra,0xfffff
    80006a0a:	07a080e7          	jalr	122(ra) # 80005a80 <snprintf>
    80006a0e:	013509bb          	addw	s3,a0,s3
  release(&lock_locks);  
    80006a12:	00024517          	auipc	a0,0x24
    80006a16:	87650513          	addi	a0,a0,-1930 # 8002a288 <lock_locks>
    80006a1a:	00000097          	auipc	ra,0x0
    80006a1e:	cec080e7          	jalr	-788(ra) # 80006706 <release>
  return n;
}
    80006a22:	854e                	mv	a0,s3
    80006a24:	70a6                	ld	ra,104(sp)
    80006a26:	7406                	ld	s0,96(sp)
    80006a28:	64e6                	ld	s1,88(sp)
    80006a2a:	6946                	ld	s2,80(sp)
    80006a2c:	69a6                	ld	s3,72(sp)
    80006a2e:	6a06                	ld	s4,64(sp)
    80006a30:	7ae2                	ld	s5,56(sp)
    80006a32:	7b42                	ld	s6,48(sp)
    80006a34:	7ba2                	ld	s7,40(sp)
    80006a36:	7c02                	ld	s8,32(sp)
    80006a38:	6ce2                	ld	s9,24(sp)
    80006a3a:	6d42                	ld	s10,16(sp)
    80006a3c:	6da2                	ld	s11,8(sp)
    80006a3e:	6165                	addi	sp,sp,112
    80006a40:	8082                	ret
	...

0000000080007000 <_trampoline>:
    80007000:	14051573          	csrrw	a0,sscratch,a0
    80007004:	02153423          	sd	ra,40(a0)
    80007008:	02253823          	sd	sp,48(a0)
    8000700c:	02353c23          	sd	gp,56(a0)
    80007010:	04453023          	sd	tp,64(a0)
    80007014:	04553423          	sd	t0,72(a0)
    80007018:	04653823          	sd	t1,80(a0)
    8000701c:	04753c23          	sd	t2,88(a0)
    80007020:	f120                	sd	s0,96(a0)
    80007022:	f524                	sd	s1,104(a0)
    80007024:	fd2c                	sd	a1,120(a0)
    80007026:	e150                	sd	a2,128(a0)
    80007028:	e554                	sd	a3,136(a0)
    8000702a:	e958                	sd	a4,144(a0)
    8000702c:	ed5c                	sd	a5,152(a0)
    8000702e:	0b053023          	sd	a6,160(a0)
    80007032:	0b153423          	sd	a7,168(a0)
    80007036:	0b253823          	sd	s2,176(a0)
    8000703a:	0b353c23          	sd	s3,184(a0)
    8000703e:	0d453023          	sd	s4,192(a0)
    80007042:	0d553423          	sd	s5,200(a0)
    80007046:	0d653823          	sd	s6,208(a0)
    8000704a:	0d753c23          	sd	s7,216(a0)
    8000704e:	0f853023          	sd	s8,224(a0)
    80007052:	0f953423          	sd	s9,232(a0)
    80007056:	0fa53823          	sd	s10,240(a0)
    8000705a:	0fb53c23          	sd	s11,248(a0)
    8000705e:	11c53023          	sd	t3,256(a0)
    80007062:	11d53423          	sd	t4,264(a0)
    80007066:	11e53823          	sd	t5,272(a0)
    8000706a:	11f53c23          	sd	t6,280(a0)
    8000706e:	140022f3          	csrr	t0,sscratch
    80007072:	06553823          	sd	t0,112(a0)
    80007076:	00853103          	ld	sp,8(a0)
    8000707a:	02053203          	ld	tp,32(a0)
    8000707e:	01053283          	ld	t0,16(a0)
    80007082:	00053303          	ld	t1,0(a0)
    80007086:	18031073          	csrw	satp,t1
    8000708a:	12000073          	sfence.vma
    8000708e:	8282                	jr	t0

0000000080007090 <userret>:
    80007090:	18059073          	csrw	satp,a1
    80007094:	12000073          	sfence.vma
    80007098:	07053283          	ld	t0,112(a0)
    8000709c:	14029073          	csrw	sscratch,t0
    800070a0:	02853083          	ld	ra,40(a0)
    800070a4:	03053103          	ld	sp,48(a0)
    800070a8:	03853183          	ld	gp,56(a0)
    800070ac:	04053203          	ld	tp,64(a0)
    800070b0:	04853283          	ld	t0,72(a0)
    800070b4:	05053303          	ld	t1,80(a0)
    800070b8:	05853383          	ld	t2,88(a0)
    800070bc:	7120                	ld	s0,96(a0)
    800070be:	7524                	ld	s1,104(a0)
    800070c0:	7d2c                	ld	a1,120(a0)
    800070c2:	6150                	ld	a2,128(a0)
    800070c4:	6554                	ld	a3,136(a0)
    800070c6:	6958                	ld	a4,144(a0)
    800070c8:	6d5c                	ld	a5,152(a0)
    800070ca:	0a053803          	ld	a6,160(a0)
    800070ce:	0a853883          	ld	a7,168(a0)
    800070d2:	0b053903          	ld	s2,176(a0)
    800070d6:	0b853983          	ld	s3,184(a0)
    800070da:	0c053a03          	ld	s4,192(a0)
    800070de:	0c853a83          	ld	s5,200(a0)
    800070e2:	0d053b03          	ld	s6,208(a0)
    800070e6:	0d853b83          	ld	s7,216(a0)
    800070ea:	0e053c03          	ld	s8,224(a0)
    800070ee:	0e853c83          	ld	s9,232(a0)
    800070f2:	0f053d03          	ld	s10,240(a0)
    800070f6:	0f853d83          	ld	s11,248(a0)
    800070fa:	10053e03          	ld	t3,256(a0)
    800070fe:	10853e83          	ld	t4,264(a0)
    80007102:	11053f03          	ld	t5,272(a0)
    80007106:	11853f83          	ld	t6,280(a0)
    8000710a:	14051573          	csrrw	a0,sscratch,a0
    8000710e:	10200073          	sret
	...
