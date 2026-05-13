
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
_entry:
        # set up a stack for C.
        # stack0 is declared in start.c,
        # with a 4096-byte stack per CPU.
        # sp = stack0 + ((hartid + 1) * 4096)
        la sp, stack0
    80000000:	0001e117          	auipc	sp,0x1e
    80000004:	ac010113          	addi	sp,sp,-1344 # 8001dac0 <stack0>
        li a0, 1024*4
    80000008:	6505                	lui	a0,0x1
        csrr a1, mhartid
    8000000a:	f14025f3          	csrr	a1,mhartid
        addi a1, a1, 1
    8000000e:	0585                	addi	a1,a1,1
        mul a0, a0, a1
    80000010:	02b50533          	mul	a0,a0,a1
        add sp, sp, a0
    80000014:	912a                	add	sp,sp,a0
        # jump to start() in start.c
        call start
    80000016:	711040ef          	jal	80004f26 <start>

000000008000001a <spin>:
spin:
        j spin
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	00026797          	auipc	a5,0x26
    8000002c:	b7078793          	addi	a5,a5,-1168 # 80025b98 <end>
    80000030:	00f53733          	sltu	a4,a0,a5
    80000034:	47c5                	li	a5,17
    80000036:	07ee                	slli	a5,a5,0x1b
    80000038:	17fd                	addi	a5,a5,-1
    8000003a:	00a7b7b3          	sltu	a5,a5,a0
    8000003e:	8fd9                	or	a5,a5,a4
    80000040:	ef95                	bnez	a5,8000007c <kfree+0x60>
    80000042:	84aa                	mv	s1,a0
    80000044:	03451793          	slli	a5,a0,0x34
    80000048:	eb95                	bnez	a5,8000007c <kfree+0x60>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    8000004a:	6605                	lui	a2,0x1
    8000004c:	4585                	li	a1,1
    8000004e:	110000ef          	jal	8000015e <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000052:	00008917          	auipc	s2,0x8
    80000056:	83e90913          	addi	s2,s2,-1986 # 80007890 <kmem>
    8000005a:	854a                	mv	a0,s2
    8000005c:	1a5050ef          	jal	80005a00 <acquire>
  r->next = kmem.freelist;
    80000060:	01893783          	ld	a5,24(s2)
    80000064:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000066:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006a:	854a                	mv	a0,s2
    8000006c:	229050ef          	jal	80005a94 <release>
}
    80000070:	60e2                	ld	ra,24(sp)
    80000072:	6442                	ld	s0,16(sp)
    80000074:	64a2                	ld	s1,8(sp)
    80000076:	6902                	ld	s2,0(sp)
    80000078:	6105                	addi	sp,sp,32
    8000007a:	8082                	ret
    panic("kfree");
    8000007c:	00007517          	auipc	a0,0x7
    80000080:	f8450513          	addi	a0,a0,-124 # 80007000 <etext>
    80000084:	6da050ef          	jal	8000575e <panic>

0000000080000088 <freerange>:
{
    80000088:	7179                	addi	sp,sp,-48
    8000008a:	f406                	sd	ra,40(sp)
    8000008c:	f022                	sd	s0,32(sp)
    8000008e:	ec26                	sd	s1,24(sp)
    80000090:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000092:	6785                	lui	a5,0x1
    80000094:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000098:	00e504b3          	add	s1,a0,a4
    8000009c:	777d                	lui	a4,0xfffff
    8000009e:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000a0:	94be                	add	s1,s1,a5
    800000a2:	0295e263          	bltu	a1,s1,800000c6 <freerange+0x3e>
    800000a6:	e84a                	sd	s2,16(sp)
    800000a8:	e44e                	sd	s3,8(sp)
    800000aa:	e052                	sd	s4,0(sp)
    800000ac:	892e                	mv	s2,a1
    kfree(p);
    800000ae:	8a3a                	mv	s4,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b0:	89be                	mv	s3,a5
    kfree(p);
    800000b2:	01448533          	add	a0,s1,s4
    800000b6:	f67ff0ef          	jal	8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ba:	94ce                	add	s1,s1,s3
    800000bc:	fe997be3          	bgeu	s2,s1,800000b2 <freerange+0x2a>
    800000c0:	6942                	ld	s2,16(sp)
    800000c2:	69a2                	ld	s3,8(sp)
    800000c4:	6a02                	ld	s4,0(sp)
}
    800000c6:	70a2                	ld	ra,40(sp)
    800000c8:	7402                	ld	s0,32(sp)
    800000ca:	64e2                	ld	s1,24(sp)
    800000cc:	6145                	addi	sp,sp,48
    800000ce:	8082                	ret

00000000800000d0 <kinit>:
{
    800000d0:	1141                	addi	sp,sp,-16
    800000d2:	e406                	sd	ra,8(sp)
    800000d4:	e022                	sd	s0,0(sp)
    800000d6:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000d8:	00007597          	auipc	a1,0x7
    800000dc:	f3858593          	addi	a1,a1,-200 # 80007010 <etext+0x10>
    800000e0:	00007517          	auipc	a0,0x7
    800000e4:	7b050513          	addi	a0,a0,1968 # 80007890 <kmem>
    800000e8:	08f050ef          	jal	80005976 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000ec:	45c5                	li	a1,17
    800000ee:	05ee                	slli	a1,a1,0x1b
    800000f0:	00026517          	auipc	a0,0x26
    800000f4:	aa850513          	addi	a0,a0,-1368 # 80025b98 <end>
    800000f8:	f91ff0ef          	jal	80000088 <freerange>
}
    800000fc:	60a2                	ld	ra,8(sp)
    800000fe:	6402                	ld	s0,0(sp)
    80000100:	0141                	addi	sp,sp,16
    80000102:	8082                	ret

0000000080000104 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000104:	1101                	addi	sp,sp,-32
    80000106:	ec06                	sd	ra,24(sp)
    80000108:	e822                	sd	s0,16(sp)
    8000010a:	e426                	sd	s1,8(sp)
    8000010c:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    8000010e:	00007517          	auipc	a0,0x7
    80000112:	78250513          	addi	a0,a0,1922 # 80007890 <kmem>
    80000116:	0eb050ef          	jal	80005a00 <acquire>
  r = kmem.freelist;
    8000011a:	00007497          	auipc	s1,0x7
    8000011e:	78e4b483          	ld	s1,1934(s1) # 800078a8 <kmem+0x18>
  if(r)
    80000122:	c49d                	beqz	s1,80000150 <kalloc+0x4c>
    kmem.freelist = r->next;
    80000124:	609c                	ld	a5,0(s1)
    80000126:	00007717          	auipc	a4,0x7
    8000012a:	78f73123          	sd	a5,1922(a4) # 800078a8 <kmem+0x18>
  release(&kmem.lock);
    8000012e:	00007517          	auipc	a0,0x7
    80000132:	76250513          	addi	a0,a0,1890 # 80007890 <kmem>
    80000136:	15f050ef          	jal	80005a94 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000013a:	6605                	lui	a2,0x1
    8000013c:	4595                	li	a1,5
    8000013e:	8526                	mv	a0,s1
    80000140:	01e000ef          	jal	8000015e <memset>
  return (void*)r;
}
    80000144:	8526                	mv	a0,s1
    80000146:	60e2                	ld	ra,24(sp)
    80000148:	6442                	ld	s0,16(sp)
    8000014a:	64a2                	ld	s1,8(sp)
    8000014c:	6105                	addi	sp,sp,32
    8000014e:	8082                	ret
  release(&kmem.lock);
    80000150:	00007517          	auipc	a0,0x7
    80000154:	74050513          	addi	a0,a0,1856 # 80007890 <kmem>
    80000158:	13d050ef          	jal	80005a94 <release>
  if(r)
    8000015c:	b7e5                	j	80000144 <kalloc+0x40>

000000008000015e <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000015e:	1141                	addi	sp,sp,-16
    80000160:	e406                	sd	ra,8(sp)
    80000162:	e022                	sd	s0,0(sp)
    80000164:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000166:	ca19                	beqz	a2,8000017c <memset+0x1e>
    80000168:	87aa                	mv	a5,a0
    8000016a:	1602                	slli	a2,a2,0x20
    8000016c:	9201                	srli	a2,a2,0x20
    8000016e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000172:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000176:	0785                	addi	a5,a5,1
    80000178:	fee79de3          	bne	a5,a4,80000172 <memset+0x14>
  }
  return dst;
}
    8000017c:	60a2                	ld	ra,8(sp)
    8000017e:	6402                	ld	s0,0(sp)
    80000180:	0141                	addi	sp,sp,16
    80000182:	8082                	ret

0000000080000184 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000184:	1141                	addi	sp,sp,-16
    80000186:	e406                	sd	ra,8(sp)
    80000188:	e022                	sd	s0,0(sp)
    8000018a:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    8000018c:	c61d                	beqz	a2,800001ba <memcmp+0x36>
    8000018e:	1602                	slli	a2,a2,0x20
    80000190:	9201                	srli	a2,a2,0x20
    80000192:	00c506b3          	add	a3,a0,a2
    if(*s1 != *s2)
    80000196:	00054783          	lbu	a5,0(a0)
    8000019a:	0005c703          	lbu	a4,0(a1)
    8000019e:	00e79863          	bne	a5,a4,800001ae <memcmp+0x2a>
      return *s1 - *s2;
    s1++, s2++;
    800001a2:	0505                	addi	a0,a0,1
    800001a4:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001a6:	fed518e3          	bne	a0,a3,80000196 <memcmp+0x12>
  }

  return 0;
    800001aa:	4501                	li	a0,0
    800001ac:	a019                	j	800001b2 <memcmp+0x2e>
      return *s1 - *s2;
    800001ae:	40e7853b          	subw	a0,a5,a4
}
    800001b2:	60a2                	ld	ra,8(sp)
    800001b4:	6402                	ld	s0,0(sp)
    800001b6:	0141                	addi	sp,sp,16
    800001b8:	8082                	ret
  return 0;
    800001ba:	4501                	li	a0,0
    800001bc:	bfdd                	j	800001b2 <memcmp+0x2e>

00000000800001be <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001be:	1141                	addi	sp,sp,-16
    800001c0:	e406                	sd	ra,8(sp)
    800001c2:	e022                	sd	s0,0(sp)
    800001c4:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001c6:	c205                	beqz	a2,800001e6 <memmove+0x28>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001c8:	02a5e363          	bltu	a1,a0,800001ee <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001cc:	1602                	slli	a2,a2,0x20
    800001ce:	9201                	srli	a2,a2,0x20
    800001d0:	00c587b3          	add	a5,a1,a2
{
    800001d4:	872a                	mv	a4,a0
      *d++ = *s++;
    800001d6:	0585                	addi	a1,a1,1
    800001d8:	0705                	addi	a4,a4,1
    800001da:	fff5c683          	lbu	a3,-1(a1)
    800001de:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001e2:	feb79ae3          	bne	a5,a1,800001d6 <memmove+0x18>

  return dst;
}
    800001e6:	60a2                	ld	ra,8(sp)
    800001e8:	6402                	ld	s0,0(sp)
    800001ea:	0141                	addi	sp,sp,16
    800001ec:	8082                	ret
  if(s < d && s + n > d){
    800001ee:	02061693          	slli	a3,a2,0x20
    800001f2:	9281                	srli	a3,a3,0x20
    800001f4:	00d58733          	add	a4,a1,a3
    800001f8:	fce57ae3          	bgeu	a0,a4,800001cc <memmove+0xe>
    d += n;
    800001fc:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    800001fe:	fff6079b          	addiw	a5,a2,-1 # fff <_entry-0x7ffff001>
    80000202:	1782                	slli	a5,a5,0x20
    80000204:	9381                	srli	a5,a5,0x20
    80000206:	fff7c793          	not	a5,a5
    8000020a:	97ba                	add	a5,a5,a4
      *--d = *--s;
    8000020c:	177d                	addi	a4,a4,-1
    8000020e:	16fd                	addi	a3,a3,-1
    80000210:	00074603          	lbu	a2,0(a4)
    80000214:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000218:	fee79ae3          	bne	a5,a4,8000020c <memmove+0x4e>
    8000021c:	b7e9                	j	800001e6 <memmove+0x28>

000000008000021e <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    8000021e:	1141                	addi	sp,sp,-16
    80000220:	e406                	sd	ra,8(sp)
    80000222:	e022                	sd	s0,0(sp)
    80000224:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000226:	f99ff0ef          	jal	800001be <memmove>
}
    8000022a:	60a2                	ld	ra,8(sp)
    8000022c:	6402                	ld	s0,0(sp)
    8000022e:	0141                	addi	sp,sp,16
    80000230:	8082                	ret

0000000080000232 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000232:	1141                	addi	sp,sp,-16
    80000234:	e406                	sd	ra,8(sp)
    80000236:	e022                	sd	s0,0(sp)
    80000238:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    8000023a:	ce11                	beqz	a2,80000256 <strncmp+0x24>
    8000023c:	00054783          	lbu	a5,0(a0)
    80000240:	cf89                	beqz	a5,8000025a <strncmp+0x28>
    80000242:	0005c703          	lbu	a4,0(a1)
    80000246:	00f71a63          	bne	a4,a5,8000025a <strncmp+0x28>
    n--, p++, q++;
    8000024a:	367d                	addiw	a2,a2,-1
    8000024c:	0505                	addi	a0,a0,1
    8000024e:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000250:	f675                	bnez	a2,8000023c <strncmp+0xa>
  if(n == 0)
    return 0;
    80000252:	4501                	li	a0,0
    80000254:	a801                	j	80000264 <strncmp+0x32>
    80000256:	4501                	li	a0,0
    80000258:	a031                	j	80000264 <strncmp+0x32>
  return (uchar)*p - (uchar)*q;
    8000025a:	00054503          	lbu	a0,0(a0)
    8000025e:	0005c783          	lbu	a5,0(a1)
    80000262:	9d1d                	subw	a0,a0,a5
}
    80000264:	60a2                	ld	ra,8(sp)
    80000266:	6402                	ld	s0,0(sp)
    80000268:	0141                	addi	sp,sp,16
    8000026a:	8082                	ret

000000008000026c <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    8000026c:	1141                	addi	sp,sp,-16
    8000026e:	e406                	sd	ra,8(sp)
    80000270:	e022                	sd	s0,0(sp)
    80000272:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000274:	87aa                	mv	a5,a0
    80000276:	a011                	j	8000027a <strncpy+0xe>
    80000278:	8636                	mv	a2,a3
    8000027a:	02c05863          	blez	a2,800002aa <strncpy+0x3e>
    8000027e:	fff6069b          	addiw	a3,a2,-1
    80000282:	8836                	mv	a6,a3
    80000284:	0785                	addi	a5,a5,1
    80000286:	0005c703          	lbu	a4,0(a1)
    8000028a:	fee78fa3          	sb	a4,-1(a5)
    8000028e:	0585                	addi	a1,a1,1
    80000290:	f765                	bnez	a4,80000278 <strncpy+0xc>
    ;
  while(n-- > 0)
    80000292:	873e                	mv	a4,a5
    80000294:	01005b63          	blez	a6,800002aa <strncpy+0x3e>
    80000298:	9fb1                	addw	a5,a5,a2
    8000029a:	37fd                	addiw	a5,a5,-1
    *s++ = 0;
    8000029c:	0705                	addi	a4,a4,1
    8000029e:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    800002a2:	40e786bb          	subw	a3,a5,a4
    800002a6:	fed04be3          	bgtz	a3,8000029c <strncpy+0x30>
  return os;
}
    800002aa:	60a2                	ld	ra,8(sp)
    800002ac:	6402                	ld	s0,0(sp)
    800002ae:	0141                	addi	sp,sp,16
    800002b0:	8082                	ret

00000000800002b2 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002b2:	1141                	addi	sp,sp,-16
    800002b4:	e406                	sd	ra,8(sp)
    800002b6:	e022                	sd	s0,0(sp)
    800002b8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002ba:	02c05363          	blez	a2,800002e0 <safestrcpy+0x2e>
    800002be:	fff6069b          	addiw	a3,a2,-1
    800002c2:	1682                	slli	a3,a3,0x20
    800002c4:	9281                	srli	a3,a3,0x20
    800002c6:	96ae                	add	a3,a3,a1
    800002c8:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002ca:	00d58963          	beq	a1,a3,800002dc <safestrcpy+0x2a>
    800002ce:	0585                	addi	a1,a1,1
    800002d0:	0785                	addi	a5,a5,1
    800002d2:	fff5c703          	lbu	a4,-1(a1)
    800002d6:	fee78fa3          	sb	a4,-1(a5)
    800002da:	fb65                	bnez	a4,800002ca <safestrcpy+0x18>
    ;
  *s = 0;
    800002dc:	00078023          	sb	zero,0(a5)
  return os;
}
    800002e0:	60a2                	ld	ra,8(sp)
    800002e2:	6402                	ld	s0,0(sp)
    800002e4:	0141                	addi	sp,sp,16
    800002e6:	8082                	ret

00000000800002e8 <strlen>:

int
strlen(const char *s)
{
    800002e8:	1141                	addi	sp,sp,-16
    800002ea:	e406                	sd	ra,8(sp)
    800002ec:	e022                	sd	s0,0(sp)
    800002ee:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002f0:	00054783          	lbu	a5,0(a0)
    800002f4:	cf91                	beqz	a5,80000310 <strlen+0x28>
    800002f6:	00150793          	addi	a5,a0,1
    800002fa:	86be                	mv	a3,a5
    800002fc:	0785                	addi	a5,a5,1
    800002fe:	fff7c703          	lbu	a4,-1(a5)
    80000302:	ff65                	bnez	a4,800002fa <strlen+0x12>
    80000304:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
    80000308:	60a2                	ld	ra,8(sp)
    8000030a:	6402                	ld	s0,0(sp)
    8000030c:	0141                	addi	sp,sp,16
    8000030e:	8082                	ret
  for(n = 0; s[n]; n++)
    80000310:	4501                	li	a0,0
    80000312:	bfdd                	j	80000308 <strlen+0x20>

0000000080000314 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000314:	1141                	addi	sp,sp,-16
    80000316:	e406                	sd	ra,8(sp)
    80000318:	e022                	sd	s0,0(sp)
    8000031a:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    8000031c:	22d000ef          	jal	80000d48 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000320:	00007717          	auipc	a4,0x7
    80000324:	54070713          	addi	a4,a4,1344 # 80007860 <started>
  if(cpuid() == 0){
    80000328:	c51d                	beqz	a0,80000356 <main+0x42>
    while(started == 0)
    8000032a:	431c                	lw	a5,0(a4)
    8000032c:	2781                	sext.w	a5,a5
    8000032e:	dff5                	beqz	a5,8000032a <main+0x16>
      ;
    __sync_synchronize();
    80000330:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    80000334:	215000ef          	jal	80000d48 <cpuid>
    80000338:	85aa                	mv	a1,a0
    8000033a:	00007517          	auipc	a0,0x7
    8000033e:	cfe50513          	addi	a0,a0,-770 # 80007038 <etext+0x38>
    80000342:	07a050ef          	jal	800053bc <printf>
    kvminithart();    // turn on paging
    80000346:	080000ef          	jal	800003c6 <kvminithart>
    trapinithart();   // install kernel trap vector
    8000034a:	560010ef          	jal	800018aa <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000034e:	61a040ef          	jal	80004968 <plicinithart>
  }

  scheduler();        
    80000352:	69f000ef          	jal	800011f0 <scheduler>
    consoleinit();
    80000356:	78d040ef          	jal	800052e2 <consoleinit>
    printfinit();
    8000035a:	38c050ef          	jal	800056e6 <printfinit>
    printf("\n");
    8000035e:	00007517          	auipc	a0,0x7
    80000362:	cba50513          	addi	a0,a0,-838 # 80007018 <etext+0x18>
    80000366:	056050ef          	jal	800053bc <printf>
    printf("xv6 kernel is booting\n");
    8000036a:	00007517          	auipc	a0,0x7
    8000036e:	cb650513          	addi	a0,a0,-842 # 80007020 <etext+0x20>
    80000372:	04a050ef          	jal	800053bc <printf>
    printf("\n");
    80000376:	00007517          	auipc	a0,0x7
    8000037a:	ca250513          	addi	a0,a0,-862 # 80007018 <etext+0x18>
    8000037e:	03e050ef          	jal	800053bc <printf>
    kinit();         // physical page allocator
    80000382:	d4fff0ef          	jal	800000d0 <kinit>
    kvminit();       // create kernel page table
    80000386:	2cc000ef          	jal	80000652 <kvminit>
    kvminithart();   // turn on paging
    8000038a:	03c000ef          	jal	800003c6 <kvminithart>
    procinit();      // process table
    8000038e:	111000ef          	jal	80000c9e <procinit>
    trapinit();      // trap vectors
    80000392:	4f4010ef          	jal	80001886 <trapinit>
    trapinithart();  // install kernel trap vector
    80000396:	514010ef          	jal	800018aa <trapinithart>
    plicinit();      // set up interrupt controller
    8000039a:	5b4040ef          	jal	8000494e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    8000039e:	5ca040ef          	jal	80004968 <plicinithart>
    binit();         // buffer cache
    800003a2:	43f010ef          	jal	80001fe0 <binit>
    iinit();         // inode table
    800003a6:	190020ef          	jal	80002536 <iinit>
    fileinit();      // file table
    800003aa:	0bc030ef          	jal	80003466 <fileinit>
    virtio_disk_init(); // emulated hard disk
    800003ae:	6aa040ef          	jal	80004a58 <virtio_disk_init>
    userinit();      // first user process
    800003b2:	4a5000ef          	jal	80001056 <userinit>
    __sync_synchronize();
    800003b6:	0330000f          	fence	rw,rw
    started = 1;
    800003ba:	4785                	li	a5,1
    800003bc:	00007717          	auipc	a4,0x7
    800003c0:	4af72223          	sw	a5,1188(a4) # 80007860 <started>
    800003c4:	b779                	j	80000352 <main+0x3e>

00000000800003c6 <kvminithart>:

// Switch the current CPU's h/w page table register to
// the kernel's page table, and enable paging.
void
kvminithart()
{
    800003c6:	1141                	addi	sp,sp,-16
    800003c8:	e406                	sd	ra,8(sp)
    800003ca:	e022                	sd	s0,0(sp)
    800003cc:	0800                	addi	s0,sp,16

// flush the TLB.
static inline void
sfence_vma() {
	// the zero, zero means flush all TLB entries.
	asm volatile("sfence.vma zero, zero");
    800003ce:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    800003d2:	00007797          	auipc	a5,0x7
    800003d6:	4967b783          	ld	a5,1174(a5) # 80007868 <kernel_pagetable>
    800003da:	83b1                	srli	a5,a5,0xc
    800003dc:	577d                	li	a4,-1
    800003de:	177e                	slli	a4,a4,0x3f
    800003e0:	8fd9                	or	a5,a5,a4
	asm volatile("csrw satp, %0" : : "r"(x));
    800003e2:	18079073          	csrw	satp,a5
	asm volatile("sfence.vma zero, zero");
    800003e6:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    800003ea:	60a2                	ld	ra,8(sp)
    800003ec:	6402                	ld	s0,0(sp)
    800003ee:	0141                	addi	sp,sp,16
    800003f0:	8082                	ret

00000000800003f2 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800003f2:	7139                	addi	sp,sp,-64
    800003f4:	fc06                	sd	ra,56(sp)
    800003f6:	f822                	sd	s0,48(sp)
    800003f8:	f426                	sd	s1,40(sp)
    800003fa:	f04a                	sd	s2,32(sp)
    800003fc:	ec4e                	sd	s3,24(sp)
    800003fe:	e852                	sd	s4,16(sp)
    80000400:	e456                	sd	s5,8(sp)
    80000402:	e05a                	sd	s6,0(sp)
    80000404:	0080                	addi	s0,sp,64
    80000406:	84aa                	mv	s1,a0
    80000408:	89ae                	mv	s3,a1
    8000040a:	8b32                	mv	s6,a2
  if(va >= MAXVA)
    8000040c:	57fd                	li	a5,-1
    8000040e:	83e9                	srli	a5,a5,0x1a
    80000410:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000412:	4ab1                	li	s5,12
  if(va >= MAXVA)
    80000414:	04b7e263          	bltu	a5,a1,80000458 <walk+0x66>
    pte_t *pte = &pagetable[PX(level, va)];
    80000418:	0149d933          	srl	s2,s3,s4
    8000041c:	1ff97913          	andi	s2,s2,511
    80000420:	090e                	slli	s2,s2,0x3
    80000422:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000424:	00093483          	ld	s1,0(s2)
    80000428:	0014f793          	andi	a5,s1,1
    8000042c:	cf85                	beqz	a5,80000464 <walk+0x72>
      pagetable = (pagetable_t)PTE2PA(*pte);
    8000042e:	80a9                	srli	s1,s1,0xa
    80000430:	04b2                	slli	s1,s1,0xc
  for(int level = 2; level > 0; level--) {
    80000432:	3a5d                	addiw	s4,s4,-9
    80000434:	ff5a12e3          	bne	s4,s5,80000418 <walk+0x26>
        return 0;
      memset(pagetable, 0, PGSIZE);
      *pte = PA2PTE(pagetable) | PTE_V;
    }
  }
  return &pagetable[PX(0, va)];
    80000438:	00c9d513          	srli	a0,s3,0xc
    8000043c:	1ff57513          	andi	a0,a0,511
    80000440:	050e                	slli	a0,a0,0x3
    80000442:	9526                	add	a0,a0,s1
}
    80000444:	70e2                	ld	ra,56(sp)
    80000446:	7442                	ld	s0,48(sp)
    80000448:	74a2                	ld	s1,40(sp)
    8000044a:	7902                	ld	s2,32(sp)
    8000044c:	69e2                	ld	s3,24(sp)
    8000044e:	6a42                	ld	s4,16(sp)
    80000450:	6aa2                	ld	s5,8(sp)
    80000452:	6b02                	ld	s6,0(sp)
    80000454:	6121                	addi	sp,sp,64
    80000456:	8082                	ret
    panic("walk");
    80000458:	00007517          	auipc	a0,0x7
    8000045c:	bf850513          	addi	a0,a0,-1032 # 80007050 <etext+0x50>
    80000460:	2fe050ef          	jal	8000575e <panic>
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000464:	020b0263          	beqz	s6,80000488 <walk+0x96>
    80000468:	c9dff0ef          	jal	80000104 <kalloc>
    8000046c:	84aa                	mv	s1,a0
    8000046e:	d979                	beqz	a0,80000444 <walk+0x52>
      memset(pagetable, 0, PGSIZE);
    80000470:	6605                	lui	a2,0x1
    80000472:	4581                	li	a1,0
    80000474:	cebff0ef          	jal	8000015e <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000478:	00c4d793          	srli	a5,s1,0xc
    8000047c:	07aa                	slli	a5,a5,0xa
    8000047e:	0017e793          	ori	a5,a5,1
    80000482:	00f93023          	sd	a5,0(s2)
    80000486:	b775                	j	80000432 <walk+0x40>
        return 0;
    80000488:	4501                	li	a0,0
    8000048a:	bf6d                	j	80000444 <walk+0x52>

000000008000048c <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000048c:	57fd                	li	a5,-1
    8000048e:	83e9                	srli	a5,a5,0x1a
    80000490:	00b7f463          	bgeu	a5,a1,80000498 <walkaddr+0xc>
    return 0;
    80000494:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000496:	8082                	ret
{
    80000498:	1141                	addi	sp,sp,-16
    8000049a:	e406                	sd	ra,8(sp)
    8000049c:	e022                	sd	s0,0(sp)
    8000049e:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    800004a0:	4601                	li	a2,0
    800004a2:	f51ff0ef          	jal	800003f2 <walk>
  if(pte == 0)
    800004a6:	c901                	beqz	a0,800004b6 <walkaddr+0x2a>
  if((*pte & PTE_V) == 0)
    800004a8:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    800004aa:	0117f693          	andi	a3,a5,17
    800004ae:	4745                	li	a4,17
    return 0;
    800004b0:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    800004b2:	00e68663          	beq	a3,a4,800004be <walkaddr+0x32>
}
    800004b6:	60a2                	ld	ra,8(sp)
    800004b8:	6402                	ld	s0,0(sp)
    800004ba:	0141                	addi	sp,sp,16
    800004bc:	8082                	ret
  pa = PTE2PA(*pte);
    800004be:	83a9                	srli	a5,a5,0xa
    800004c0:	00c79513          	slli	a0,a5,0xc
  return pa;
    800004c4:	bfcd                	j	800004b6 <walkaddr+0x2a>

00000000800004c6 <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800004c6:	715d                	addi	sp,sp,-80
    800004c8:	e486                	sd	ra,72(sp)
    800004ca:	e0a2                	sd	s0,64(sp)
    800004cc:	fc26                	sd	s1,56(sp)
    800004ce:	f84a                	sd	s2,48(sp)
    800004d0:	f44e                	sd	s3,40(sp)
    800004d2:	f052                	sd	s4,32(sp)
    800004d4:	ec56                	sd	s5,24(sp)
    800004d6:	e85a                	sd	s6,16(sp)
    800004d8:	e45e                	sd	s7,8(sp)
    800004da:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800004dc:	03459793          	slli	a5,a1,0x34
    800004e0:	eba1                	bnez	a5,80000530 <mappages+0x6a>
    800004e2:	8a2a                	mv	s4,a0
    800004e4:	8aba                	mv	s5,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    800004e6:	03461793          	slli	a5,a2,0x34
    800004ea:	eba9                	bnez	a5,8000053c <mappages+0x76>
    panic("mappages: size not aligned");

  if(size == 0)
    800004ec:	ce31                	beqz	a2,80000548 <mappages+0x82>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    800004ee:	80060613          	addi	a2,a2,-2048 # 800 <_entry-0x7ffff800>
    800004f2:	80060613          	addi	a2,a2,-2048
    800004f6:	00b60933          	add	s2,a2,a1
  a = va;
    800004fa:	84ae                	mv	s1,a1
  for(;;){
    if((pte = walk(pagetable, a, 1)) == 0)
    800004fc:	4b05                	li	s6,1
    800004fe:	40b689b3          	sub	s3,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000502:	6b85                	lui	s7,0x1
    if((pte = walk(pagetable, a, 1)) == 0)
    80000504:	865a                	mv	a2,s6
    80000506:	85a6                	mv	a1,s1
    80000508:	8552                	mv	a0,s4
    8000050a:	ee9ff0ef          	jal	800003f2 <walk>
    8000050e:	c929                	beqz	a0,80000560 <mappages+0x9a>
    if(*pte & PTE_V)
    80000510:	611c                	ld	a5,0(a0)
    80000512:	8b85                	andi	a5,a5,1
    80000514:	e3a1                	bnez	a5,80000554 <mappages+0x8e>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000516:	013487b3          	add	a5,s1,s3
    8000051a:	83b1                	srli	a5,a5,0xc
    8000051c:	07aa                	slli	a5,a5,0xa
    8000051e:	0157e7b3          	or	a5,a5,s5
    80000522:	0017e793          	ori	a5,a5,1
    80000526:	e11c                	sd	a5,0(a0)
    if(a == last)
    80000528:	05248863          	beq	s1,s2,80000578 <mappages+0xb2>
    a += PGSIZE;
    8000052c:	94de                	add	s1,s1,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    8000052e:	bfd9                	j	80000504 <mappages+0x3e>
    panic("mappages: va not aligned");
    80000530:	00007517          	auipc	a0,0x7
    80000534:	b2850513          	addi	a0,a0,-1240 # 80007058 <etext+0x58>
    80000538:	226050ef          	jal	8000575e <panic>
    panic("mappages: size not aligned");
    8000053c:	00007517          	auipc	a0,0x7
    80000540:	b3c50513          	addi	a0,a0,-1220 # 80007078 <etext+0x78>
    80000544:	21a050ef          	jal	8000575e <panic>
    panic("mappages: size");
    80000548:	00007517          	auipc	a0,0x7
    8000054c:	b5050513          	addi	a0,a0,-1200 # 80007098 <etext+0x98>
    80000550:	20e050ef          	jal	8000575e <panic>
      panic("mappages: remap");
    80000554:	00007517          	auipc	a0,0x7
    80000558:	b5450513          	addi	a0,a0,-1196 # 800070a8 <etext+0xa8>
    8000055c:	202050ef          	jal	8000575e <panic>
      return -1;
    80000560:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80000562:	60a6                	ld	ra,72(sp)
    80000564:	6406                	ld	s0,64(sp)
    80000566:	74e2                	ld	s1,56(sp)
    80000568:	7942                	ld	s2,48(sp)
    8000056a:	79a2                	ld	s3,40(sp)
    8000056c:	7a02                	ld	s4,32(sp)
    8000056e:	6ae2                	ld	s5,24(sp)
    80000570:	6b42                	ld	s6,16(sp)
    80000572:	6ba2                	ld	s7,8(sp)
    80000574:	6161                	addi	sp,sp,80
    80000576:	8082                	ret
  return 0;
    80000578:	4501                	li	a0,0
    8000057a:	b7e5                	j	80000562 <mappages+0x9c>

000000008000057c <kvmmap>:
{
    8000057c:	1141                	addi	sp,sp,-16
    8000057e:	e406                	sd	ra,8(sp)
    80000580:	e022                	sd	s0,0(sp)
    80000582:	0800                	addi	s0,sp,16
    80000584:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80000586:	86b2                	mv	a3,a2
    80000588:	863e                	mv	a2,a5
    8000058a:	f3dff0ef          	jal	800004c6 <mappages>
    8000058e:	e509                	bnez	a0,80000598 <kvmmap+0x1c>
}
    80000590:	60a2                	ld	ra,8(sp)
    80000592:	6402                	ld	s0,0(sp)
    80000594:	0141                	addi	sp,sp,16
    80000596:	8082                	ret
    panic("kvmmap");
    80000598:	00007517          	auipc	a0,0x7
    8000059c:	b2050513          	addi	a0,a0,-1248 # 800070b8 <etext+0xb8>
    800005a0:	1be050ef          	jal	8000575e <panic>

00000000800005a4 <kvmmake>:
{
    800005a4:	1101                	addi	sp,sp,-32
    800005a6:	ec06                	sd	ra,24(sp)
    800005a8:	e822                	sd	s0,16(sp)
    800005aa:	e426                	sd	s1,8(sp)
    800005ac:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    800005ae:	b57ff0ef          	jal	80000104 <kalloc>
    800005b2:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800005b4:	6605                	lui	a2,0x1
    800005b6:	4581                	li	a1,0
    800005b8:	ba7ff0ef          	jal	8000015e <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800005bc:	4719                	li	a4,6
    800005be:	6685                	lui	a3,0x1
    800005c0:	10000637          	lui	a2,0x10000
    800005c4:	85b2                	mv	a1,a2
    800005c6:	8526                	mv	a0,s1
    800005c8:	fb5ff0ef          	jal	8000057c <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800005cc:	4719                	li	a4,6
    800005ce:	6685                	lui	a3,0x1
    800005d0:	10001637          	lui	a2,0x10001
    800005d4:	85b2                	mv	a1,a2
    800005d6:	8526                	mv	a0,s1
    800005d8:	fa5ff0ef          	jal	8000057c <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    800005dc:	4719                	li	a4,6
    800005de:	040006b7          	lui	a3,0x4000
    800005e2:	0c000637          	lui	a2,0xc000
    800005e6:	85b2                	mv	a1,a2
    800005e8:	8526                	mv	a0,s1
    800005ea:	f93ff0ef          	jal	8000057c <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800005ee:	4729                	li	a4,10
    800005f0:	80007697          	auipc	a3,0x80007
    800005f4:	a1068693          	addi	a3,a3,-1520 # 7000 <_entry-0x7fff9000>
    800005f8:	4605                	li	a2,1
    800005fa:	067e                	slli	a2,a2,0x1f
    800005fc:	85b2                	mv	a1,a2
    800005fe:	8526                	mv	a0,s1
    80000600:	f7dff0ef          	jal	8000057c <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80000604:	4719                	li	a4,6
    80000606:	00007697          	auipc	a3,0x7
    8000060a:	9fa68693          	addi	a3,a3,-1542 # 80007000 <etext>
    8000060e:	47c5                	li	a5,17
    80000610:	07ee                	slli	a5,a5,0x1b
    80000612:	40d786b3          	sub	a3,a5,a3
    80000616:	00007617          	auipc	a2,0x7
    8000061a:	9ea60613          	addi	a2,a2,-1558 # 80007000 <etext>
    8000061e:	85b2                	mv	a1,a2
    80000620:	8526                	mv	a0,s1
    80000622:	f5bff0ef          	jal	8000057c <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80000626:	4729                	li	a4,10
    80000628:	6685                	lui	a3,0x1
    8000062a:	00006617          	auipc	a2,0x6
    8000062e:	9d660613          	addi	a2,a2,-1578 # 80006000 <_trampoline>
    80000632:	040005b7          	lui	a1,0x4000
    80000636:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000638:	05b2                	slli	a1,a1,0xc
    8000063a:	8526                	mv	a0,s1
    8000063c:	f41ff0ef          	jal	8000057c <kvmmap>
  proc_mapstacks(kpgtbl);
    80000640:	8526                	mv	a0,s1
    80000642:	5c4000ef          	jal	80000c06 <proc_mapstacks>
}
    80000646:	8526                	mv	a0,s1
    80000648:	60e2                	ld	ra,24(sp)
    8000064a:	6442                	ld	s0,16(sp)
    8000064c:	64a2                	ld	s1,8(sp)
    8000064e:	6105                	addi	sp,sp,32
    80000650:	8082                	ret

0000000080000652 <kvminit>:
{
    80000652:	1141                	addi	sp,sp,-16
    80000654:	e406                	sd	ra,8(sp)
    80000656:	e022                	sd	s0,0(sp)
    80000658:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000065a:	f4bff0ef          	jal	800005a4 <kvmmake>
    8000065e:	00007797          	auipc	a5,0x7
    80000662:	20a7b523          	sd	a0,522(a5) # 80007868 <kernel_pagetable>
}
    80000666:	60a2                	ld	ra,8(sp)
    80000668:	6402                	ld	s0,0(sp)
    8000066a:	0141                	addi	sp,sp,16
    8000066c:	8082                	ret

000000008000066e <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    8000066e:	1101                	addi	sp,sp,-32
    80000670:	ec06                	sd	ra,24(sp)
    80000672:	e822                	sd	s0,16(sp)
    80000674:	e426                	sd	s1,8(sp)
    80000676:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000678:	a8dff0ef          	jal	80000104 <kalloc>
    8000067c:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000067e:	c509                	beqz	a0,80000688 <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000680:	6605                	lui	a2,0x1
    80000682:	4581                	li	a1,0
    80000684:	adbff0ef          	jal	8000015e <memset>
  return pagetable;
}
    80000688:	8526                	mv	a0,s1
    8000068a:	60e2                	ld	ra,24(sp)
    8000068c:	6442                	ld	s0,16(sp)
    8000068e:	64a2                	ld	s1,8(sp)
    80000690:	6105                	addi	sp,sp,32
    80000692:	8082                	ret

0000000080000694 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. It's OK if the mappings don't exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000694:	7139                	addi	sp,sp,-64
    80000696:	fc06                	sd	ra,56(sp)
    80000698:	f822                	sd	s0,48(sp)
    8000069a:	0080                	addi	s0,sp,64
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000069c:	03459793          	slli	a5,a1,0x34
    800006a0:	e38d                	bnez	a5,800006c2 <uvmunmap+0x2e>
    800006a2:	f04a                	sd	s2,32(sp)
    800006a4:	ec4e                	sd	s3,24(sp)
    800006a6:	e852                	sd	s4,16(sp)
    800006a8:	e456                	sd	s5,8(sp)
    800006aa:	e05a                	sd	s6,0(sp)
    800006ac:	8a2a                	mv	s4,a0
    800006ae:	892e                	mv	s2,a1
    800006b0:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800006b2:	0632                	slli	a2,a2,0xc
    800006b4:	00b609b3          	add	s3,a2,a1
    800006b8:	6b05                	lui	s6,0x1
    800006ba:	0535f963          	bgeu	a1,s3,8000070c <uvmunmap+0x78>
    800006be:	f426                	sd	s1,40(sp)
    800006c0:	a015                	j	800006e4 <uvmunmap+0x50>
    800006c2:	f426                	sd	s1,40(sp)
    800006c4:	f04a                	sd	s2,32(sp)
    800006c6:	ec4e                	sd	s3,24(sp)
    800006c8:	e852                	sd	s4,16(sp)
    800006ca:	e456                	sd	s5,8(sp)
    800006cc:	e05a                	sd	s6,0(sp)
    panic("uvmunmap: not aligned");
    800006ce:	00007517          	auipc	a0,0x7
    800006d2:	9f250513          	addi	a0,a0,-1550 # 800070c0 <etext+0xc0>
    800006d6:	088050ef          	jal	8000575e <panic>
      continue;
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    800006da:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800006de:	995a                	add	s2,s2,s6
    800006e0:	03397563          	bgeu	s2,s3,8000070a <uvmunmap+0x76>
    if((pte = walk(pagetable, a, 0)) == 0) // leaf page table entry allocated?
    800006e4:	4601                	li	a2,0
    800006e6:	85ca                	mv	a1,s2
    800006e8:	8552                	mv	a0,s4
    800006ea:	d09ff0ef          	jal	800003f2 <walk>
    800006ee:	84aa                	mv	s1,a0
    800006f0:	d57d                	beqz	a0,800006de <uvmunmap+0x4a>
    if((*pte & PTE_V) == 0)  // has physical page been allocated?
    800006f2:	611c                	ld	a5,0(a0)
    800006f4:	0017f713          	andi	a4,a5,1
    800006f8:	d37d                	beqz	a4,800006de <uvmunmap+0x4a>
    if(do_free){
    800006fa:	fe0a80e3          	beqz	s5,800006da <uvmunmap+0x46>
      uint64 pa = PTE2PA(*pte);
    800006fe:	83a9                	srli	a5,a5,0xa
      kfree((void*)pa);
    80000700:	00c79513          	slli	a0,a5,0xc
    80000704:	919ff0ef          	jal	8000001c <kfree>
    80000708:	bfc9                	j	800006da <uvmunmap+0x46>
    8000070a:	74a2                	ld	s1,40(sp)
    8000070c:	7902                	ld	s2,32(sp)
    8000070e:	69e2                	ld	s3,24(sp)
    80000710:	6a42                	ld	s4,16(sp)
    80000712:	6aa2                	ld	s5,8(sp)
    80000714:	6b02                	ld	s6,0(sp)
  }
}
    80000716:	70e2                	ld	ra,56(sp)
    80000718:	7442                	ld	s0,48(sp)
    8000071a:	6121                	addi	sp,sp,64
    8000071c:	8082                	ret

000000008000071e <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000071e:	1101                	addi	sp,sp,-32
    80000720:	ec06                	sd	ra,24(sp)
    80000722:	e822                	sd	s0,16(sp)
    80000724:	e426                	sd	s1,8(sp)
    80000726:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80000728:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000072a:	00b67d63          	bgeu	a2,a1,80000744 <uvmdealloc+0x26>
    8000072e:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000730:	6785                	lui	a5,0x1
    80000732:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000734:	00f60733          	add	a4,a2,a5
    80000738:	76fd                	lui	a3,0xfffff
    8000073a:	8f75                	and	a4,a4,a3
    8000073c:	97ae                	add	a5,a5,a1
    8000073e:	8ff5                	and	a5,a5,a3
    80000740:	00f76863          	bltu	a4,a5,80000750 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000744:	8526                	mv	a0,s1
    80000746:	60e2                	ld	ra,24(sp)
    80000748:	6442                	ld	s0,16(sp)
    8000074a:	64a2                	ld	s1,8(sp)
    8000074c:	6105                	addi	sp,sp,32
    8000074e:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80000750:	8f99                	sub	a5,a5,a4
    80000752:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80000754:	4685                	li	a3,1
    80000756:	0007861b          	sext.w	a2,a5
    8000075a:	85ba                	mv	a1,a4
    8000075c:	f39ff0ef          	jal	80000694 <uvmunmap>
    80000760:	b7d5                	j	80000744 <uvmdealloc+0x26>

0000000080000762 <uvmalloc>:
  if(newsz < oldsz)
    80000762:	0ab66163          	bltu	a2,a1,80000804 <uvmalloc+0xa2>
{
    80000766:	715d                	addi	sp,sp,-80
    80000768:	e486                	sd	ra,72(sp)
    8000076a:	e0a2                	sd	s0,64(sp)
    8000076c:	f84a                	sd	s2,48(sp)
    8000076e:	f052                	sd	s4,32(sp)
    80000770:	ec56                	sd	s5,24(sp)
    80000772:	e45e                	sd	s7,8(sp)
    80000774:	0880                	addi	s0,sp,80
    80000776:	8aaa                	mv	s5,a0
    80000778:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    8000077a:	6785                	lui	a5,0x1
    8000077c:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000077e:	95be                	add	a1,a1,a5
    80000780:	77fd                	lui	a5,0xfffff
    80000782:	00f5f933          	and	s2,a1,a5
    80000786:	8bca                	mv	s7,s2
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000788:	08c97063          	bgeu	s2,a2,80000808 <uvmalloc+0xa6>
    8000078c:	fc26                	sd	s1,56(sp)
    8000078e:	f44e                	sd	s3,40(sp)
    80000790:	e85a                	sd	s6,16(sp)
    memset(mem, 0, PGSIZE);
    80000792:	6985                	lui	s3,0x1
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000794:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80000798:	96dff0ef          	jal	80000104 <kalloc>
    8000079c:	84aa                	mv	s1,a0
    if(mem == 0){
    8000079e:	c50d                	beqz	a0,800007c8 <uvmalloc+0x66>
    memset(mem, 0, PGSIZE);
    800007a0:	864e                	mv	a2,s3
    800007a2:	4581                	li	a1,0
    800007a4:	9bbff0ef          	jal	8000015e <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800007a8:	875a                	mv	a4,s6
    800007aa:	86a6                	mv	a3,s1
    800007ac:	864e                	mv	a2,s3
    800007ae:	85ca                	mv	a1,s2
    800007b0:	8556                	mv	a0,s5
    800007b2:	d15ff0ef          	jal	800004c6 <mappages>
    800007b6:	e915                	bnez	a0,800007ea <uvmalloc+0x88>
  for(a = oldsz; a < newsz; a += PGSIZE){
    800007b8:	994e                	add	s2,s2,s3
    800007ba:	fd496fe3          	bltu	s2,s4,80000798 <uvmalloc+0x36>
  return newsz;
    800007be:	8552                	mv	a0,s4
    800007c0:	74e2                	ld	s1,56(sp)
    800007c2:	79a2                	ld	s3,40(sp)
    800007c4:	6b42                	ld	s6,16(sp)
    800007c6:	a811                	j	800007da <uvmalloc+0x78>
      uvmdealloc(pagetable, a, oldsz);
    800007c8:	865e                	mv	a2,s7
    800007ca:	85ca                	mv	a1,s2
    800007cc:	8556                	mv	a0,s5
    800007ce:	f51ff0ef          	jal	8000071e <uvmdealloc>
      return 0;
    800007d2:	4501                	li	a0,0
    800007d4:	74e2                	ld	s1,56(sp)
    800007d6:	79a2                	ld	s3,40(sp)
    800007d8:	6b42                	ld	s6,16(sp)
}
    800007da:	60a6                	ld	ra,72(sp)
    800007dc:	6406                	ld	s0,64(sp)
    800007de:	7942                	ld	s2,48(sp)
    800007e0:	7a02                	ld	s4,32(sp)
    800007e2:	6ae2                	ld	s5,24(sp)
    800007e4:	6ba2                	ld	s7,8(sp)
    800007e6:	6161                	addi	sp,sp,80
    800007e8:	8082                	ret
      kfree(mem);
    800007ea:	8526                	mv	a0,s1
    800007ec:	831ff0ef          	jal	8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800007f0:	865e                	mv	a2,s7
    800007f2:	85ca                	mv	a1,s2
    800007f4:	8556                	mv	a0,s5
    800007f6:	f29ff0ef          	jal	8000071e <uvmdealloc>
      return 0;
    800007fa:	4501                	li	a0,0
    800007fc:	74e2                	ld	s1,56(sp)
    800007fe:	79a2                	ld	s3,40(sp)
    80000800:	6b42                	ld	s6,16(sp)
    80000802:	bfe1                	j	800007da <uvmalloc+0x78>
    return oldsz;
    80000804:	852e                	mv	a0,a1
}
    80000806:	8082                	ret
  return newsz;
    80000808:	8532                	mv	a0,a2
    8000080a:	bfc1                	j	800007da <uvmalloc+0x78>

000000008000080c <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    8000080c:	7179                	addi	sp,sp,-48
    8000080e:	f406                	sd	ra,40(sp)
    80000810:	f022                	sd	s0,32(sp)
    80000812:	ec26                	sd	s1,24(sp)
    80000814:	e84a                	sd	s2,16(sp)
    80000816:	e44e                	sd	s3,8(sp)
    80000818:	1800                	addi	s0,sp,48
    8000081a:	89aa                	mv	s3,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    8000081c:	84aa                	mv	s1,a0
    8000081e:	6905                	lui	s2,0x1
    80000820:	992a                	add	s2,s2,a0
    80000822:	a811                	j	80000836 <freewalk+0x2a>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
      freewalk((pagetable_t)child);
      pagetable[i] = 0;
    } else if(pte & PTE_V){
      panic("freewalk: leaf");
    80000824:	00007517          	auipc	a0,0x7
    80000828:	8b450513          	addi	a0,a0,-1868 # 800070d8 <etext+0xd8>
    8000082c:	733040ef          	jal	8000575e <panic>
  for(int i = 0; i < 512; i++){
    80000830:	04a1                	addi	s1,s1,8
    80000832:	03248163          	beq	s1,s2,80000854 <freewalk+0x48>
    pte_t pte = pagetable[i];
    80000836:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000838:	0017f713          	andi	a4,a5,1
    8000083c:	db75                	beqz	a4,80000830 <freewalk+0x24>
    8000083e:	00e7f713          	andi	a4,a5,14
    80000842:	f36d                	bnez	a4,80000824 <freewalk+0x18>
      uint64 child = PTE2PA(pte);
    80000844:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80000846:	00c79513          	slli	a0,a5,0xc
    8000084a:	fc3ff0ef          	jal	8000080c <freewalk>
      pagetable[i] = 0;
    8000084e:	0004b023          	sd	zero,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000852:	bff9                	j	80000830 <freewalk+0x24>
    }
  }
  kfree((void*)pagetable);
    80000854:	854e                	mv	a0,s3
    80000856:	fc6ff0ef          	jal	8000001c <kfree>
}
    8000085a:	70a2                	ld	ra,40(sp)
    8000085c:	7402                	ld	s0,32(sp)
    8000085e:	64e2                	ld	s1,24(sp)
    80000860:	6942                	ld	s2,16(sp)
    80000862:	69a2                	ld	s3,8(sp)
    80000864:	6145                	addi	sp,sp,48
    80000866:	8082                	ret

0000000080000868 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000868:	1101                	addi	sp,sp,-32
    8000086a:	ec06                	sd	ra,24(sp)
    8000086c:	e822                	sd	s0,16(sp)
    8000086e:	e426                	sd	s1,8(sp)
    80000870:	1000                	addi	s0,sp,32
    80000872:	84aa                	mv	s1,a0
  if(sz > 0)
    80000874:	e989                	bnez	a1,80000886 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000876:	8526                	mv	a0,s1
    80000878:	f95ff0ef          	jal	8000080c <freewalk>
}
    8000087c:	60e2                	ld	ra,24(sp)
    8000087e:	6442                	ld	s0,16(sp)
    80000880:	64a2                	ld	s1,8(sp)
    80000882:	6105                	addi	sp,sp,32
    80000884:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000886:	6785                	lui	a5,0x1
    80000888:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000088a:	95be                	add	a1,a1,a5
    8000088c:	4685                	li	a3,1
    8000088e:	00c5d613          	srli	a2,a1,0xc
    80000892:	4581                	li	a1,0
    80000894:	e01ff0ef          	jal	80000694 <uvmunmap>
    80000898:	bff9                	j	80000876 <uvmfree+0xe>

000000008000089a <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    8000089a:	ca59                	beqz	a2,80000930 <uvmcopy+0x96>
{
    8000089c:	715d                	addi	sp,sp,-80
    8000089e:	e486                	sd	ra,72(sp)
    800008a0:	e0a2                	sd	s0,64(sp)
    800008a2:	fc26                	sd	s1,56(sp)
    800008a4:	f84a                	sd	s2,48(sp)
    800008a6:	f44e                	sd	s3,40(sp)
    800008a8:	f052                	sd	s4,32(sp)
    800008aa:	ec56                	sd	s5,24(sp)
    800008ac:	e85a                	sd	s6,16(sp)
    800008ae:	e45e                	sd	s7,8(sp)
    800008b0:	0880                	addi	s0,sp,80
    800008b2:	8b2a                	mv	s6,a0
    800008b4:	8bae                	mv	s7,a1
    800008b6:	8ab2                	mv	s5,a2
  for(i = 0; i < sz; i += PGSIZE){
    800008b8:	4481                	li	s1,0
      continue;   // physical page hasn't been allocated
    pa = PTE2PA(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    800008ba:	6a05                	lui	s4,0x1
    800008bc:	a021                	j	800008c4 <uvmcopy+0x2a>
  for(i = 0; i < sz; i += PGSIZE){
    800008be:	94d2                	add	s1,s1,s4
    800008c0:	0554fc63          	bgeu	s1,s5,80000918 <uvmcopy+0x7e>
    if((pte = walk(old, i, 0)) == 0)
    800008c4:	4601                	li	a2,0
    800008c6:	85a6                	mv	a1,s1
    800008c8:	855a                	mv	a0,s6
    800008ca:	b29ff0ef          	jal	800003f2 <walk>
    800008ce:	d965                	beqz	a0,800008be <uvmcopy+0x24>
    if((*pte & PTE_V) == 0)
    800008d0:	00053983          	ld	s3,0(a0)
    800008d4:	0019f793          	andi	a5,s3,1
    800008d8:	d3fd                	beqz	a5,800008be <uvmcopy+0x24>
    if((mem = kalloc()) == 0)
    800008da:	82bff0ef          	jal	80000104 <kalloc>
    800008de:	892a                	mv	s2,a0
    800008e0:	c11d                	beqz	a0,80000906 <uvmcopy+0x6c>
    pa = PTE2PA(*pte);
    800008e2:	00a9d593          	srli	a1,s3,0xa
    memmove(mem, (char*)pa, PGSIZE);
    800008e6:	8652                	mv	a2,s4
    800008e8:	05b2                	slli	a1,a1,0xc
    800008ea:	8d5ff0ef          	jal	800001be <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    800008ee:	3ff9f713          	andi	a4,s3,1023
    800008f2:	86ca                	mv	a3,s2
    800008f4:	8652                	mv	a2,s4
    800008f6:	85a6                	mv	a1,s1
    800008f8:	855e                	mv	a0,s7
    800008fa:	bcdff0ef          	jal	800004c6 <mappages>
    800008fe:	d161                	beqz	a0,800008be <uvmcopy+0x24>
      kfree(mem);
    80000900:	854a                	mv	a0,s2
    80000902:	f1aff0ef          	jal	8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000906:	4685                	li	a3,1
    80000908:	00c4d613          	srli	a2,s1,0xc
    8000090c:	4581                	li	a1,0
    8000090e:	855e                	mv	a0,s7
    80000910:	d85ff0ef          	jal	80000694 <uvmunmap>
  return -1;
    80000914:	557d                	li	a0,-1
    80000916:	a011                	j	8000091a <uvmcopy+0x80>
  return 0;
    80000918:	4501                	li	a0,0
}
    8000091a:	60a6                	ld	ra,72(sp)
    8000091c:	6406                	ld	s0,64(sp)
    8000091e:	74e2                	ld	s1,56(sp)
    80000920:	7942                	ld	s2,48(sp)
    80000922:	79a2                	ld	s3,40(sp)
    80000924:	7a02                	ld	s4,32(sp)
    80000926:	6ae2                	ld	s5,24(sp)
    80000928:	6b42                	ld	s6,16(sp)
    8000092a:	6ba2                	ld	s7,8(sp)
    8000092c:	6161                	addi	sp,sp,80
    8000092e:	8082                	ret
  return 0;
    80000930:	4501                	li	a0,0
}
    80000932:	8082                	ret

0000000080000934 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000934:	1141                	addi	sp,sp,-16
    80000936:	e406                	sd	ra,8(sp)
    80000938:	e022                	sd	s0,0(sp)
    8000093a:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    8000093c:	4601                	li	a2,0
    8000093e:	ab5ff0ef          	jal	800003f2 <walk>
  if(pte == 0)
    80000942:	c901                	beqz	a0,80000952 <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000944:	611c                	ld	a5,0(a0)
    80000946:	9bbd                	andi	a5,a5,-17
    80000948:	e11c                	sd	a5,0(a0)
}
    8000094a:	60a2                	ld	ra,8(sp)
    8000094c:	6402                	ld	s0,0(sp)
    8000094e:	0141                	addi	sp,sp,16
    80000950:	8082                	ret
    panic("uvmclear");
    80000952:	00006517          	auipc	a0,0x6
    80000956:	79650513          	addi	a0,a0,1942 # 800070e8 <etext+0xe8>
    8000095a:	605040ef          	jal	8000575e <panic>

000000008000095e <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    8000095e:	cac5                	beqz	a3,80000a0e <copyinstr+0xb0>
{
    80000960:	715d                	addi	sp,sp,-80
    80000962:	e486                	sd	ra,72(sp)
    80000964:	e0a2                	sd	s0,64(sp)
    80000966:	fc26                	sd	s1,56(sp)
    80000968:	f84a                	sd	s2,48(sp)
    8000096a:	f44e                	sd	s3,40(sp)
    8000096c:	f052                	sd	s4,32(sp)
    8000096e:	ec56                	sd	s5,24(sp)
    80000970:	e85a                	sd	s6,16(sp)
    80000972:	e45e                	sd	s7,8(sp)
    80000974:	0880                	addi	s0,sp,80
    80000976:	8aaa                	mv	s5,a0
    80000978:	84ae                	mv	s1,a1
    8000097a:	8bb2                	mv	s7,a2
    8000097c:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    8000097e:	7b7d                	lui	s6,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000980:	6a05                	lui	s4,0x1
    80000982:	a82d                	j	800009bc <copyinstr+0x5e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000984:	00078023          	sb	zero,0(a5)
        got_null = 1;
    80000988:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    8000098a:	0017c793          	xori	a5,a5,1
    8000098e:	40f0053b          	negw	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000992:	60a6                	ld	ra,72(sp)
    80000994:	6406                	ld	s0,64(sp)
    80000996:	74e2                	ld	s1,56(sp)
    80000998:	7942                	ld	s2,48(sp)
    8000099a:	79a2                	ld	s3,40(sp)
    8000099c:	7a02                	ld	s4,32(sp)
    8000099e:	6ae2                	ld	s5,24(sp)
    800009a0:	6b42                	ld	s6,16(sp)
    800009a2:	6ba2                	ld	s7,8(sp)
    800009a4:	6161                	addi	sp,sp,80
    800009a6:	8082                	ret
    800009a8:	fff98713          	addi	a4,s3,-1 # fff <_entry-0x7ffff001>
    800009ac:	9726                	add	a4,a4,s1
      --max;
    800009ae:	40b709b3          	sub	s3,a4,a1
    srcva = va0 + PGSIZE;
    800009b2:	01490bb3          	add	s7,s2,s4
  while(got_null == 0 && max > 0){
    800009b6:	04e58463          	beq	a1,a4,800009fe <copyinstr+0xa0>
{
    800009ba:	84be                	mv	s1,a5
    va0 = PGROUNDDOWN(srcva);
    800009bc:	016bf933          	and	s2,s7,s6
    pa0 = walkaddr(pagetable, va0);
    800009c0:	85ca                	mv	a1,s2
    800009c2:	8556                	mv	a0,s5
    800009c4:	ac9ff0ef          	jal	8000048c <walkaddr>
    if(pa0 == 0)
    800009c8:	cd0d                	beqz	a0,80000a02 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    800009ca:	417906b3          	sub	a3,s2,s7
    800009ce:	96d2                	add	a3,a3,s4
    if(n > max)
    800009d0:	00d9f363          	bgeu	s3,a3,800009d6 <copyinstr+0x78>
    800009d4:	86ce                	mv	a3,s3
    while(n > 0){
    800009d6:	ca85                	beqz	a3,80000a06 <copyinstr+0xa8>
    char *p = (char *) (pa0 + (srcva - va0));
    800009d8:	01750633          	add	a2,a0,s7
    800009dc:	41260633          	sub	a2,a2,s2
    800009e0:	87a6                	mv	a5,s1
      if(*p == '\0'){
    800009e2:	8e05                	sub	a2,a2,s1
    while(n > 0){
    800009e4:	96a6                	add	a3,a3,s1
    800009e6:	85be                	mv	a1,a5
      if(*p == '\0'){
    800009e8:	00f60733          	add	a4,a2,a5
    800009ec:	00074703          	lbu	a4,0(a4)
    800009f0:	db51                	beqz	a4,80000984 <copyinstr+0x26>
        *dst = *p;
    800009f2:	00e78023          	sb	a4,0(a5)
      dst++;
    800009f6:	0785                	addi	a5,a5,1
    while(n > 0){
    800009f8:	fed797e3          	bne	a5,a3,800009e6 <copyinstr+0x88>
    800009fc:	b775                	j	800009a8 <copyinstr+0x4a>
    800009fe:	4781                	li	a5,0
    80000a00:	b769                	j	8000098a <copyinstr+0x2c>
      return -1;
    80000a02:	557d                	li	a0,-1
    80000a04:	b779                	j	80000992 <copyinstr+0x34>
    srcva = va0 + PGSIZE;
    80000a06:	6b85                	lui	s7,0x1
    80000a08:	9bca                	add	s7,s7,s2
    80000a0a:	87a6                	mv	a5,s1
    80000a0c:	b77d                	j	800009ba <copyinstr+0x5c>
  int got_null = 0;
    80000a0e:	4781                	li	a5,0
  if(got_null){
    80000a10:	0017c793          	xori	a5,a5,1
    80000a14:	40f0053b          	negw	a0,a5
}
    80000a18:	8082                	ret

0000000080000a1a <ismapped>:
  return mem;
}

int
ismapped(pagetable_t pagetable, uint64 va)
{
    80000a1a:	1141                	addi	sp,sp,-16
    80000a1c:	e406                	sd	ra,8(sp)
    80000a1e:	e022                	sd	s0,0(sp)
    80000a20:	0800                	addi	s0,sp,16
  pte_t *pte = walk(pagetable, va, 0);
    80000a22:	4601                	li	a2,0
    80000a24:	9cfff0ef          	jal	800003f2 <walk>
  if (pte == 0) {
    80000a28:	c119                	beqz	a0,80000a2e <ismapped+0x14>
    return 0;
  }
  if (*pte & PTE_V){
    80000a2a:	6108                	ld	a0,0(a0)
    80000a2c:	8905                	andi	a0,a0,1
    return 1;
  }
  return 0;
}
    80000a2e:	60a2                	ld	ra,8(sp)
    80000a30:	6402                	ld	s0,0(sp)
    80000a32:	0141                	addi	sp,sp,16
    80000a34:	8082                	ret

0000000080000a36 <vmfault>:
{
    80000a36:	7179                	addi	sp,sp,-48
    80000a38:	f406                	sd	ra,40(sp)
    80000a3a:	f022                	sd	s0,32(sp)
    80000a3c:	e84a                	sd	s2,16(sp)
    80000a3e:	e44e                	sd	s3,8(sp)
    80000a40:	1800                	addi	s0,sp,48
    80000a42:	89aa                	mv	s3,a0
    80000a44:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80000a46:	336000ef          	jal	80000d7c <myproc>
  if (va >= p->sz)
    80000a4a:	653c                	ld	a5,72(a0)
    80000a4c:	00f96a63          	bltu	s2,a5,80000a60 <vmfault+0x2a>
    return 0;
    80000a50:	4981                	li	s3,0
}
    80000a52:	854e                	mv	a0,s3
    80000a54:	70a2                	ld	ra,40(sp)
    80000a56:	7402                	ld	s0,32(sp)
    80000a58:	6942                	ld	s2,16(sp)
    80000a5a:	69a2                	ld	s3,8(sp)
    80000a5c:	6145                	addi	sp,sp,48
    80000a5e:	8082                	ret
    80000a60:	ec26                	sd	s1,24(sp)
    80000a62:	e052                	sd	s4,0(sp)
    80000a64:	84aa                	mv	s1,a0
  va = PGROUNDDOWN(va);
    80000a66:	77fd                	lui	a5,0xfffff
    80000a68:	00f97a33          	and	s4,s2,a5
  if(ismapped(pagetable, va)) {
    80000a6c:	85d2                	mv	a1,s4
    80000a6e:	854e                	mv	a0,s3
    80000a70:	fabff0ef          	jal	80000a1a <ismapped>
    return 0;
    80000a74:	4981                	li	s3,0
  if(ismapped(pagetable, va)) {
    80000a76:	c501                	beqz	a0,80000a7e <vmfault+0x48>
    80000a78:	64e2                	ld	s1,24(sp)
    80000a7a:	6a02                	ld	s4,0(sp)
    80000a7c:	bfd9                	j	80000a52 <vmfault+0x1c>
  mem = (uint64) kalloc();
    80000a7e:	e86ff0ef          	jal	80000104 <kalloc>
    80000a82:	892a                	mv	s2,a0
  if(mem == 0)
    80000a84:	c905                	beqz	a0,80000ab4 <vmfault+0x7e>
  mem = (uint64) kalloc();
    80000a86:	89aa                	mv	s3,a0
  memset((void *) mem, 0, PGSIZE);
    80000a88:	6605                	lui	a2,0x1
    80000a8a:	4581                	li	a1,0
    80000a8c:	ed2ff0ef          	jal	8000015e <memset>
  if (mappages(p->pagetable, va, PGSIZE, mem, PTE_W|PTE_U|PTE_R) != 0) {
    80000a90:	4759                	li	a4,22
    80000a92:	86ca                	mv	a3,s2
    80000a94:	6605                	lui	a2,0x1
    80000a96:	85d2                	mv	a1,s4
    80000a98:	68a8                	ld	a0,80(s1)
    80000a9a:	a2dff0ef          	jal	800004c6 <mappages>
    80000a9e:	e501                	bnez	a0,80000aa6 <vmfault+0x70>
    80000aa0:	64e2                	ld	s1,24(sp)
    80000aa2:	6a02                	ld	s4,0(sp)
    80000aa4:	b77d                	j	80000a52 <vmfault+0x1c>
    kfree((void *)mem);
    80000aa6:	854a                	mv	a0,s2
    80000aa8:	d74ff0ef          	jal	8000001c <kfree>
    return 0;
    80000aac:	4981                	li	s3,0
    80000aae:	64e2                	ld	s1,24(sp)
    80000ab0:	6a02                	ld	s4,0(sp)
    80000ab2:	b745                	j	80000a52 <vmfault+0x1c>
    80000ab4:	64e2                	ld	s1,24(sp)
    80000ab6:	6a02                	ld	s4,0(sp)
    80000ab8:	bf69                	j	80000a52 <vmfault+0x1c>

0000000080000aba <copyout>:
  while(len > 0){
    80000aba:	cad1                	beqz	a3,80000b4e <copyout+0x94>
{
    80000abc:	711d                	addi	sp,sp,-96
    80000abe:	ec86                	sd	ra,88(sp)
    80000ac0:	e8a2                	sd	s0,80(sp)
    80000ac2:	e4a6                	sd	s1,72(sp)
    80000ac4:	e0ca                	sd	s2,64(sp)
    80000ac6:	fc4e                	sd	s3,56(sp)
    80000ac8:	f852                	sd	s4,48(sp)
    80000aca:	f456                	sd	s5,40(sp)
    80000acc:	f05a                	sd	s6,32(sp)
    80000ace:	ec5e                	sd	s7,24(sp)
    80000ad0:	e862                	sd	s8,16(sp)
    80000ad2:	e466                	sd	s9,8(sp)
    80000ad4:	e06a                	sd	s10,0(sp)
    80000ad6:	1080                	addi	s0,sp,96
    80000ad8:	8baa                	mv	s7,a0
    80000ada:	8a2e                	mv	s4,a1
    80000adc:	8b32                	mv	s6,a2
    80000ade:	8ab6                	mv	s5,a3
    va0 = PGROUNDDOWN(dstva);
    80000ae0:	7d7d                	lui	s10,0xfffff
    if(va0 >= MAXVA)
    80000ae2:	5cfd                	li	s9,-1
    80000ae4:	01acdc93          	srli	s9,s9,0x1a
    n = PGSIZE - (dstva - va0);
    80000ae8:	6c05                	lui	s8,0x1
    80000aea:	a005                	j	80000b0a <copyout+0x50>
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000aec:	409a0533          	sub	a0,s4,s1
    80000af0:	0009061b          	sext.w	a2,s2
    80000af4:	85da                	mv	a1,s6
    80000af6:	954e                	add	a0,a0,s3
    80000af8:	ec6ff0ef          	jal	800001be <memmove>
    len -= n;
    80000afc:	412a8ab3          	sub	s5,s5,s2
    src += n;
    80000b00:	9b4a                	add	s6,s6,s2
    dstva = va0 + PGSIZE;
    80000b02:	01848a33          	add	s4,s1,s8
  while(len > 0){
    80000b06:	040a8263          	beqz	s5,80000b4a <copyout+0x90>
    va0 = PGROUNDDOWN(dstva);
    80000b0a:	01aa74b3          	and	s1,s4,s10
    if(va0 >= MAXVA)
    80000b0e:	049ce263          	bltu	s9,s1,80000b52 <copyout+0x98>
    pa0 = walkaddr(pagetable, va0);
    80000b12:	85a6                	mv	a1,s1
    80000b14:	855e                	mv	a0,s7
    80000b16:	977ff0ef          	jal	8000048c <walkaddr>
    80000b1a:	89aa                	mv	s3,a0
    if(pa0 == 0) {
    80000b1c:	e901                	bnez	a0,80000b2c <copyout+0x72>
      if((pa0 = vmfault(pagetable, va0, 0)) == 0) {
    80000b1e:	4601                	li	a2,0
    80000b20:	85a6                	mv	a1,s1
    80000b22:	855e                	mv	a0,s7
    80000b24:	f13ff0ef          	jal	80000a36 <vmfault>
    80000b28:	89aa                	mv	s3,a0
    80000b2a:	c139                	beqz	a0,80000b70 <copyout+0xb6>
    pte = walk(pagetable, va0, 0);
    80000b2c:	4601                	li	a2,0
    80000b2e:	85a6                	mv	a1,s1
    80000b30:	855e                	mv	a0,s7
    80000b32:	8c1ff0ef          	jal	800003f2 <walk>
    if((*pte & PTE_W) == 0)
    80000b36:	611c                	ld	a5,0(a0)
    80000b38:	8b91                	andi	a5,a5,4
    80000b3a:	cf8d                	beqz	a5,80000b74 <copyout+0xba>
    n = PGSIZE - (dstva - va0);
    80000b3c:	41448933          	sub	s2,s1,s4
    80000b40:	9962                	add	s2,s2,s8
    if(n > len)
    80000b42:	fb2af5e3          	bgeu	s5,s2,80000aec <copyout+0x32>
    80000b46:	8956                	mv	s2,s5
    80000b48:	b755                	j	80000aec <copyout+0x32>
  return 0;
    80000b4a:	4501                	li	a0,0
    80000b4c:	a021                	j	80000b54 <copyout+0x9a>
    80000b4e:	4501                	li	a0,0
}
    80000b50:	8082                	ret
      return -1;
    80000b52:	557d                	li	a0,-1
}
    80000b54:	60e6                	ld	ra,88(sp)
    80000b56:	6446                	ld	s0,80(sp)
    80000b58:	64a6                	ld	s1,72(sp)
    80000b5a:	6906                	ld	s2,64(sp)
    80000b5c:	79e2                	ld	s3,56(sp)
    80000b5e:	7a42                	ld	s4,48(sp)
    80000b60:	7aa2                	ld	s5,40(sp)
    80000b62:	7b02                	ld	s6,32(sp)
    80000b64:	6be2                	ld	s7,24(sp)
    80000b66:	6c42                	ld	s8,16(sp)
    80000b68:	6ca2                	ld	s9,8(sp)
    80000b6a:	6d02                	ld	s10,0(sp)
    80000b6c:	6125                	addi	sp,sp,96
    80000b6e:	8082                	ret
        return -1;
    80000b70:	557d                	li	a0,-1
    80000b72:	b7cd                	j	80000b54 <copyout+0x9a>
      return -1;
    80000b74:	557d                	li	a0,-1
    80000b76:	bff9                	j	80000b54 <copyout+0x9a>

0000000080000b78 <copyin>:
  while(len > 0){
    80000b78:	c6c9                	beqz	a3,80000c02 <copyin+0x8a>
{
    80000b7a:	715d                	addi	sp,sp,-80
    80000b7c:	e486                	sd	ra,72(sp)
    80000b7e:	e0a2                	sd	s0,64(sp)
    80000b80:	fc26                	sd	s1,56(sp)
    80000b82:	f84a                	sd	s2,48(sp)
    80000b84:	f44e                	sd	s3,40(sp)
    80000b86:	f052                	sd	s4,32(sp)
    80000b88:	ec56                	sd	s5,24(sp)
    80000b8a:	e85a                	sd	s6,16(sp)
    80000b8c:	e45e                	sd	s7,8(sp)
    80000b8e:	e062                	sd	s8,0(sp)
    80000b90:	0880                	addi	s0,sp,80
    80000b92:	8baa                	mv	s7,a0
    80000b94:	8aae                	mv	s5,a1
    80000b96:	8932                	mv	s2,a2
    80000b98:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(srcva);
    80000b9a:	7c7d                	lui	s8,0xfffff
    n = PGSIZE - (srcva - va0);
    80000b9c:	6b05                	lui	s6,0x1
    80000b9e:	a035                	j	80000bca <copyin+0x52>
    80000ba0:	412984b3          	sub	s1,s3,s2
    80000ba4:	94da                	add	s1,s1,s6
    if(n > len)
    80000ba6:	009a7363          	bgeu	s4,s1,80000bac <copyin+0x34>
    80000baa:	84d2                	mv	s1,s4
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000bac:	413905b3          	sub	a1,s2,s3
    80000bb0:	0004861b          	sext.w	a2,s1
    80000bb4:	95aa                	add	a1,a1,a0
    80000bb6:	8556                	mv	a0,s5
    80000bb8:	e06ff0ef          	jal	800001be <memmove>
    len -= n;
    80000bbc:	409a0a33          	sub	s4,s4,s1
    dst += n;
    80000bc0:	9aa6                	add	s5,s5,s1
    srcva = va0 + PGSIZE;
    80000bc2:	01698933          	add	s2,s3,s6
  while(len > 0){
    80000bc6:	020a0163          	beqz	s4,80000be8 <copyin+0x70>
    va0 = PGROUNDDOWN(srcva);
    80000bca:	018979b3          	and	s3,s2,s8
    pa0 = walkaddr(pagetable, va0);
    80000bce:	85ce                	mv	a1,s3
    80000bd0:	855e                	mv	a0,s7
    80000bd2:	8bbff0ef          	jal	8000048c <walkaddr>
    if(pa0 == 0) {
    80000bd6:	f569                	bnez	a0,80000ba0 <copyin+0x28>
      if((pa0 = vmfault(pagetable, va0, 0)) == 0) {
    80000bd8:	4601                	li	a2,0
    80000bda:	85ce                	mv	a1,s3
    80000bdc:	855e                	mv	a0,s7
    80000bde:	e59ff0ef          	jal	80000a36 <vmfault>
    80000be2:	fd5d                	bnez	a0,80000ba0 <copyin+0x28>
        return -1;
    80000be4:	557d                	li	a0,-1
    80000be6:	a011                	j	80000bea <copyin+0x72>
  return 0;
    80000be8:	4501                	li	a0,0
}
    80000bea:	60a6                	ld	ra,72(sp)
    80000bec:	6406                	ld	s0,64(sp)
    80000bee:	74e2                	ld	s1,56(sp)
    80000bf0:	7942                	ld	s2,48(sp)
    80000bf2:	79a2                	ld	s3,40(sp)
    80000bf4:	7a02                	ld	s4,32(sp)
    80000bf6:	6ae2                	ld	s5,24(sp)
    80000bf8:	6b42                	ld	s6,16(sp)
    80000bfa:	6ba2                	ld	s7,8(sp)
    80000bfc:	6c02                	ld	s8,0(sp)
    80000bfe:	6161                	addi	sp,sp,80
    80000c00:	8082                	ret
  return 0;
    80000c02:	4501                	li	a0,0
}
    80000c04:	8082                	ret

0000000080000c06 <proc_mapstacks>:
struct spinlock wait_lock;

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void proc_mapstacks(pagetable_t kpgtbl) {
    80000c06:	715d                	addi	sp,sp,-80
    80000c08:	e486                	sd	ra,72(sp)
    80000c0a:	e0a2                	sd	s0,64(sp)
    80000c0c:	fc26                	sd	s1,56(sp)
    80000c0e:	f84a                	sd	s2,48(sp)
    80000c10:	f44e                	sd	s3,40(sp)
    80000c12:	f052                	sd	s4,32(sp)
    80000c14:	ec56                	sd	s5,24(sp)
    80000c16:	e85a                	sd	s6,16(sp)
    80000c18:	e45e                	sd	s7,8(sp)
    80000c1a:	e062                	sd	s8,0(sp)
    80000c1c:	0880                	addi	s0,sp,80
    80000c1e:	8a2a                	mv	s4,a0
	struct proc* p;

	for (p = proc; p < &proc[NPROC]; p++) {
    80000c20:	00007497          	auipc	s1,0x7
    80000c24:	0c048493          	addi	s1,s1,192 # 80007ce0 <proc>
		char* pa = kalloc();
		if (pa == 0)
			panic("kalloc");
		uint64 va = KSTACK((int)(p - proc));
    80000c28:	8c26                	mv	s8,s1
    80000c2a:	fcfd07b7          	lui	a5,0xfcfd0
    80000c2e:	cfd78793          	addi	a5,a5,-771 # fffffffffcfcfcfd <end+0xffffffff7cfaa165>
    80000c32:	02079993          	slli	s3,a5,0x20
    80000c36:	99be                	add	s3,s3,a5
    80000c38:	04000937          	lui	s2,0x4000
    80000c3c:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000c3e:	0932                	slli	s2,s2,0xc
		kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000c40:	4b99                	li	s7,6
    80000c42:	6b05                	lui	s6,0x1
	for (p = proc; p < &proc[NPROC]; p++) {
    80000c44:	00012a97          	auipc	s5,0x12
    80000c48:	a9ca8a93          	addi	s5,s5,-1380 # 800126e0 <tickslock>
		char* pa = kalloc();
    80000c4c:	cb8ff0ef          	jal	80000104 <kalloc>
    80000c50:	862a                	mv	a2,a0
		if (pa == 0)
    80000c52:	c121                	beqz	a0,80000c92 <proc_mapstacks+0x8c>
		uint64 va = KSTACK((int)(p - proc));
    80000c54:	418485b3          	sub	a1,s1,s8
    80000c58:	858d                	srai	a1,a1,0x3
    80000c5a:	033585b3          	mul	a1,a1,s3
    80000c5e:	05b6                	slli	a1,a1,0xd
    80000c60:	6789                	lui	a5,0x2
    80000c62:	9dbd                	addw	a1,a1,a5
		kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000c64:	875e                	mv	a4,s7
    80000c66:	86da                	mv	a3,s6
    80000c68:	40b905b3          	sub	a1,s2,a1
    80000c6c:	8552                	mv	a0,s4
    80000c6e:	90fff0ef          	jal	8000057c <kvmmap>
	for (p = proc; p < &proc[NPROC]; p++) {
    80000c72:	2a848493          	addi	s1,s1,680
    80000c76:	fd549be3          	bne	s1,s5,80000c4c <proc_mapstacks+0x46>
	}
}
    80000c7a:	60a6                	ld	ra,72(sp)
    80000c7c:	6406                	ld	s0,64(sp)
    80000c7e:	74e2                	ld	s1,56(sp)
    80000c80:	7942                	ld	s2,48(sp)
    80000c82:	79a2                	ld	s3,40(sp)
    80000c84:	7a02                	ld	s4,32(sp)
    80000c86:	6ae2                	ld	s5,24(sp)
    80000c88:	6b42                	ld	s6,16(sp)
    80000c8a:	6ba2                	ld	s7,8(sp)
    80000c8c:	6c02                	ld	s8,0(sp)
    80000c8e:	6161                	addi	sp,sp,80
    80000c90:	8082                	ret
			panic("kalloc");
    80000c92:	00006517          	auipc	a0,0x6
    80000c96:	46650513          	addi	a0,a0,1126 # 800070f8 <etext+0xf8>
    80000c9a:	2c5040ef          	jal	8000575e <panic>

0000000080000c9e <procinit>:

// initialize the proc table.
void procinit(void) {
    80000c9e:	7139                	addi	sp,sp,-64
    80000ca0:	fc06                	sd	ra,56(sp)
    80000ca2:	f822                	sd	s0,48(sp)
    80000ca4:	f426                	sd	s1,40(sp)
    80000ca6:	f04a                	sd	s2,32(sp)
    80000ca8:	ec4e                	sd	s3,24(sp)
    80000caa:	e852                	sd	s4,16(sp)
    80000cac:	e456                	sd	s5,8(sp)
    80000cae:	e05a                	sd	s6,0(sp)
    80000cb0:	0080                	addi	s0,sp,64
	struct proc* p;

	initlock(&pid_lock, "nextpid");
    80000cb2:	00006597          	auipc	a1,0x6
    80000cb6:	44e58593          	addi	a1,a1,1102 # 80007100 <etext+0x100>
    80000cba:	00007517          	auipc	a0,0x7
    80000cbe:	bf650513          	addi	a0,a0,-1034 # 800078b0 <pid_lock>
    80000cc2:	4b5040ef          	jal	80005976 <initlock>
	initlock(&wait_lock, "wait_lock");
    80000cc6:	00006597          	auipc	a1,0x6
    80000cca:	44258593          	addi	a1,a1,1090 # 80007108 <etext+0x108>
    80000cce:	00007517          	auipc	a0,0x7
    80000cd2:	bfa50513          	addi	a0,a0,-1030 # 800078c8 <wait_lock>
    80000cd6:	4a1040ef          	jal	80005976 <initlock>
	for (p = proc; p < &proc[NPROC]; p++) {
    80000cda:	00007497          	auipc	s1,0x7
    80000cde:	00648493          	addi	s1,s1,6 # 80007ce0 <proc>
		initlock(&p->lock, "proc");
    80000ce2:	00006b17          	auipc	s6,0x6
    80000ce6:	436b0b13          	addi	s6,s6,1078 # 80007118 <etext+0x118>
		p->state = UNUSED;
		p->kstack = KSTACK((int)(p - proc));
    80000cea:	8aa6                	mv	s5,s1
    80000cec:	fcfd07b7          	lui	a5,0xfcfd0
    80000cf0:	cfd78793          	addi	a5,a5,-771 # fffffffffcfcfcfd <end+0xffffffff7cfaa165>
    80000cf4:	02079993          	slli	s3,a5,0x20
    80000cf8:	99be                	add	s3,s3,a5
    80000cfa:	04000937          	lui	s2,0x4000
    80000cfe:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000d00:	0932                	slli	s2,s2,0xc
	for (p = proc; p < &proc[NPROC]; p++) {
    80000d02:	00012a17          	auipc	s4,0x12
    80000d06:	9dea0a13          	addi	s4,s4,-1570 # 800126e0 <tickslock>
		initlock(&p->lock, "proc");
    80000d0a:	85da                	mv	a1,s6
    80000d0c:	8526                	mv	a0,s1
    80000d0e:	469040ef          	jal	80005976 <initlock>
		p->state = UNUSED;
    80000d12:	0004ac23          	sw	zero,24(s1)
		p->kstack = KSTACK((int)(p - proc));
    80000d16:	415487b3          	sub	a5,s1,s5
    80000d1a:	878d                	srai	a5,a5,0x3
    80000d1c:	033787b3          	mul	a5,a5,s3
    80000d20:	07b6                	slli	a5,a5,0xd
    80000d22:	6709                	lui	a4,0x2
    80000d24:	9fb9                	addw	a5,a5,a4
    80000d26:	40f907b3          	sub	a5,s2,a5
    80000d2a:	e0bc                	sd	a5,64(s1)
	for (p = proc; p < &proc[NPROC]; p++) {
    80000d2c:	2a848493          	addi	s1,s1,680
    80000d30:	fd449de3          	bne	s1,s4,80000d0a <procinit+0x6c>
	}
}
    80000d34:	70e2                	ld	ra,56(sp)
    80000d36:	7442                	ld	s0,48(sp)
    80000d38:	74a2                	ld	s1,40(sp)
    80000d3a:	7902                	ld	s2,32(sp)
    80000d3c:	69e2                	ld	s3,24(sp)
    80000d3e:	6a42                	ld	s4,16(sp)
    80000d40:	6aa2                	ld	s5,8(sp)
    80000d42:	6b02                	ld	s6,0(sp)
    80000d44:	6121                	addi	sp,sp,64
    80000d46:	8082                	ret

0000000080000d48 <cpuid>:

// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int cpuid() {
    80000d48:	1141                	addi	sp,sp,-16
    80000d4a:	e406                	sd	ra,8(sp)
    80000d4c:	e022                	sd	s0,0(sp)
    80000d4e:	0800                	addi	s0,sp,16
	asm volatile("mv %0, tp" : "=r"(x));
    80000d50:	8512                	mv	a0,tp
	int id = r_tp();
	return id;
}
    80000d52:	2501                	sext.w	a0,a0
    80000d54:	60a2                	ld	ra,8(sp)
    80000d56:	6402                	ld	s0,0(sp)
    80000d58:	0141                	addi	sp,sp,16
    80000d5a:	8082                	ret

0000000080000d5c <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000d5c:	1141                	addi	sp,sp,-16
    80000d5e:	e406                	sd	ra,8(sp)
    80000d60:	e022                	sd	s0,0(sp)
    80000d62:	0800                	addi	s0,sp,16
    80000d64:	8792                	mv	a5,tp
	int id = cpuid();
	struct cpu* c = &cpus[id];
    80000d66:	2781                	sext.w	a5,a5
    80000d68:	079e                	slli	a5,a5,0x7
	return c;
}
    80000d6a:	00007517          	auipc	a0,0x7
    80000d6e:	b7650513          	addi	a0,a0,-1162 # 800078e0 <cpus>
    80000d72:	953e                	add	a0,a0,a5
    80000d74:	60a2                	ld	ra,8(sp)
    80000d76:	6402                	ld	s0,0(sp)
    80000d78:	0141                	addi	sp,sp,16
    80000d7a:	8082                	ret

0000000080000d7c <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000d7c:	1101                	addi	sp,sp,-32
    80000d7e:	ec06                	sd	ra,24(sp)
    80000d80:	e822                	sd	s0,16(sp)
    80000d82:	e426                	sd	s1,8(sp)
    80000d84:	1000                	addi	s0,sp,32
	push_off();
    80000d86:	437040ef          	jal	800059bc <push_off>
    80000d8a:	8792                	mv	a5,tp
	struct cpu* c = mycpu();
	struct proc* p = c->proc;
    80000d8c:	2781                	sext.w	a5,a5
    80000d8e:	079e                	slli	a5,a5,0x7
    80000d90:	00007717          	auipc	a4,0x7
    80000d94:	b2070713          	addi	a4,a4,-1248 # 800078b0 <pid_lock>
    80000d98:	97ba                	add	a5,a5,a4
    80000d9a:	7b9c                	ld	a5,48(a5)
    80000d9c:	84be                	mv	s1,a5
	pop_off();
    80000d9e:	4a7040ef          	jal	80005a44 <pop_off>
	return p;
}
    80000da2:	8526                	mv	a0,s1
    80000da4:	60e2                	ld	ra,24(sp)
    80000da6:	6442                	ld	s0,16(sp)
    80000da8:	64a2                	ld	s1,8(sp)
    80000daa:	6105                	addi	sp,sp,32
    80000dac:	8082                	ret

0000000080000dae <forkret>:
	release(&p->lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void forkret(void) {
    80000dae:	7179                	addi	sp,sp,-48
    80000db0:	f406                	sd	ra,40(sp)
    80000db2:	f022                	sd	s0,32(sp)
    80000db4:	ec26                	sd	s1,24(sp)
    80000db6:	1800                	addi	s0,sp,48
	extern char userret[];
	static int first = 1;
	struct proc* p = myproc();
    80000db8:	fc5ff0ef          	jal	80000d7c <myproc>
    80000dbc:	84aa                	mv	s1,a0

	// Still holding p->lock from scheduler.
	release(&p->lock);
    80000dbe:	4d7040ef          	jal	80005a94 <release>

	if (first) {
    80000dc2:	00007797          	auipc	a5,0x7
    80000dc6:	a8e7a783          	lw	a5,-1394(a5) # 80007850 <first.1>
    80000dca:	cf95                	beqz	a5,80000e06 <forkret+0x58>
		// File system initialization must be run in the context of a
		// regular process (e.g., because it calls sleep), and thus cannot
		// be run from main().
		fsinit(ROOTDEV);
    80000dcc:	4505                	li	a0,1
    80000dce:	425010ef          	jal	800029f2 <fsinit>

		first = 0;
    80000dd2:	00007797          	auipc	a5,0x7
    80000dd6:	a607af23          	sw	zero,-1410(a5) # 80007850 <first.1>
		// ensure other cores see first=0.
		__sync_synchronize();
    80000dda:	0330000f          	fence	rw,rw

		// We can invoke kexec() now that file system is initialized.
		// Put the return value (argc) of kexec into a0.
		p->trapframe->a0 = kexec("/init", (char*[]){"/init", 0});
    80000dde:	00006797          	auipc	a5,0x6
    80000de2:	34278793          	addi	a5,a5,834 # 80007120 <etext+0x120>
    80000de6:	fcf43823          	sd	a5,-48(s0)
    80000dea:	fc043c23          	sd	zero,-40(s0)
    80000dee:	fd040593          	addi	a1,s0,-48
    80000df2:	853e                	mv	a0,a5
    80000df4:	57d020ef          	jal	80003b70 <kexec>
    80000df8:	6cbc                	ld	a5,88(s1)
    80000dfa:	fba8                	sd	a0,112(a5)
		if (p->trapframe->a0 == -1) {
    80000dfc:	6cbc                	ld	a5,88(s1)
    80000dfe:	7bb8                	ld	a4,112(a5)
    80000e00:	57fd                	li	a5,-1
    80000e02:	02f70d63          	beq	a4,a5,80000e3c <forkret+0x8e>
			panic("exec");
		}
	}

	// return to user space, mimicing usertrap()'s return.
	prepare_return();
    80000e06:	2c1000ef          	jal	800018c6 <prepare_return>
	uint64 satp = MAKE_SATP(p->pagetable);
    80000e0a:	68a8                	ld	a0,80(s1)
    80000e0c:	8131                	srli	a0,a0,0xc
	uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80000e0e:	04000737          	lui	a4,0x4000
    80000e12:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    80000e14:	0732                	slli	a4,a4,0xc
    80000e16:	00005797          	auipc	a5,0x5
    80000e1a:	28678793          	addi	a5,a5,646 # 8000609c <userret>
    80000e1e:	00005697          	auipc	a3,0x5
    80000e22:	1e268693          	addi	a3,a3,482 # 80006000 <_trampoline>
    80000e26:	8f95                	sub	a5,a5,a3
    80000e28:	97ba                	add	a5,a5,a4
	((void (*)(uint64))trampoline_userret)(satp);
    80000e2a:	577d                	li	a4,-1
    80000e2c:	177e                	slli	a4,a4,0x3f
    80000e2e:	8d59                	or	a0,a0,a4
    80000e30:	9782                	jalr	a5
}
    80000e32:	70a2                	ld	ra,40(sp)
    80000e34:	7402                	ld	s0,32(sp)
    80000e36:	64e2                	ld	s1,24(sp)
    80000e38:	6145                	addi	sp,sp,48
    80000e3a:	8082                	ret
			panic("exec");
    80000e3c:	00006517          	auipc	a0,0x6
    80000e40:	2ec50513          	addi	a0,a0,748 # 80007128 <etext+0x128>
    80000e44:	11b040ef          	jal	8000575e <panic>

0000000080000e48 <allocpid>:
int allocpid() {
    80000e48:	1101                	addi	sp,sp,-32
    80000e4a:	ec06                	sd	ra,24(sp)
    80000e4c:	e822                	sd	s0,16(sp)
    80000e4e:	e426                	sd	s1,8(sp)
    80000e50:	1000                	addi	s0,sp,32
	acquire(&pid_lock);
    80000e52:	00007517          	auipc	a0,0x7
    80000e56:	a5e50513          	addi	a0,a0,-1442 # 800078b0 <pid_lock>
    80000e5a:	3a7040ef          	jal	80005a00 <acquire>
	pid = nextpid;
    80000e5e:	00007797          	auipc	a5,0x7
    80000e62:	9f678793          	addi	a5,a5,-1546 # 80007854 <nextpid>
    80000e66:	4384                	lw	s1,0(a5)
	nextpid = nextpid + 1;
    80000e68:	0014871b          	addiw	a4,s1,1
    80000e6c:	c398                	sw	a4,0(a5)
	release(&pid_lock);
    80000e6e:	00007517          	auipc	a0,0x7
    80000e72:	a4250513          	addi	a0,a0,-1470 # 800078b0 <pid_lock>
    80000e76:	41f040ef          	jal	80005a94 <release>
}
    80000e7a:	8526                	mv	a0,s1
    80000e7c:	60e2                	ld	ra,24(sp)
    80000e7e:	6442                	ld	s0,16(sp)
    80000e80:	64a2                	ld	s1,8(sp)
    80000e82:	6105                	addi	sp,sp,32
    80000e84:	8082                	ret

0000000080000e86 <proc_pagetable>:
proc_pagetable(struct proc* p) {
    80000e86:	1101                	addi	sp,sp,-32
    80000e88:	ec06                	sd	ra,24(sp)
    80000e8a:	e822                	sd	s0,16(sp)
    80000e8c:	e426                	sd	s1,8(sp)
    80000e8e:	e04a                	sd	s2,0(sp)
    80000e90:	1000                	addi	s0,sp,32
    80000e92:	892a                	mv	s2,a0
	pagetable = uvmcreate();
    80000e94:	fdaff0ef          	jal	8000066e <uvmcreate>
    80000e98:	84aa                	mv	s1,a0
	if (pagetable == 0)
    80000e9a:	cd05                	beqz	a0,80000ed2 <proc_pagetable+0x4c>
	if (mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000e9c:	4729                	li	a4,10
    80000e9e:	00005697          	auipc	a3,0x5
    80000ea2:	16268693          	addi	a3,a3,354 # 80006000 <_trampoline>
    80000ea6:	6605                	lui	a2,0x1
    80000ea8:	040005b7          	lui	a1,0x4000
    80000eac:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000eae:	05b2                	slli	a1,a1,0xc
    80000eb0:	e16ff0ef          	jal	800004c6 <mappages>
    80000eb4:	02054663          	bltz	a0,80000ee0 <proc_pagetable+0x5a>
	if (mappages(pagetable, TRAPFRAME, PGSIZE,
    80000eb8:	4719                	li	a4,6
    80000eba:	05893683          	ld	a3,88(s2)
    80000ebe:	6605                	lui	a2,0x1
    80000ec0:	020005b7          	lui	a1,0x2000
    80000ec4:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000ec6:	05b6                	slli	a1,a1,0xd
    80000ec8:	8526                	mv	a0,s1
    80000eca:	dfcff0ef          	jal	800004c6 <mappages>
    80000ece:	00054f63          	bltz	a0,80000eec <proc_pagetable+0x66>
}
    80000ed2:	8526                	mv	a0,s1
    80000ed4:	60e2                	ld	ra,24(sp)
    80000ed6:	6442                	ld	s0,16(sp)
    80000ed8:	64a2                	ld	s1,8(sp)
    80000eda:	6902                	ld	s2,0(sp)
    80000edc:	6105                	addi	sp,sp,32
    80000ede:	8082                	ret
		uvmfree(pagetable, 0);
    80000ee0:	4581                	li	a1,0
    80000ee2:	8526                	mv	a0,s1
    80000ee4:	985ff0ef          	jal	80000868 <uvmfree>
		return 0;
    80000ee8:	4481                	li	s1,0
    80000eea:	b7e5                	j	80000ed2 <proc_pagetable+0x4c>
		uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000eec:	4681                	li	a3,0
    80000eee:	4605                	li	a2,1
    80000ef0:	040005b7          	lui	a1,0x4000
    80000ef4:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000ef6:	05b2                	slli	a1,a1,0xc
    80000ef8:	8526                	mv	a0,s1
    80000efa:	f9aff0ef          	jal	80000694 <uvmunmap>
		uvmfree(pagetable, 0);
    80000efe:	4581                	li	a1,0
    80000f00:	8526                	mv	a0,s1
    80000f02:	967ff0ef          	jal	80000868 <uvmfree>
		return 0;
    80000f06:	4481                	li	s1,0
    80000f08:	b7e9                	j	80000ed2 <proc_pagetable+0x4c>

0000000080000f0a <proc_freepagetable>:
void proc_freepagetable(pagetable_t pagetable, uint64 sz) {
    80000f0a:	1101                	addi	sp,sp,-32
    80000f0c:	ec06                	sd	ra,24(sp)
    80000f0e:	e822                	sd	s0,16(sp)
    80000f10:	e426                	sd	s1,8(sp)
    80000f12:	e04a                	sd	s2,0(sp)
    80000f14:	1000                	addi	s0,sp,32
    80000f16:	84aa                	mv	s1,a0
    80000f18:	892e                	mv	s2,a1
	uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f1a:	4681                	li	a3,0
    80000f1c:	4605                	li	a2,1
    80000f1e:	040005b7          	lui	a1,0x4000
    80000f22:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f24:	05b2                	slli	a1,a1,0xc
    80000f26:	f6eff0ef          	jal	80000694 <uvmunmap>
	uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000f2a:	4681                	li	a3,0
    80000f2c:	4605                	li	a2,1
    80000f2e:	020005b7          	lui	a1,0x2000
    80000f32:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000f34:	05b6                	slli	a1,a1,0xd
    80000f36:	8526                	mv	a0,s1
    80000f38:	f5cff0ef          	jal	80000694 <uvmunmap>
	uvmfree(pagetable, sz);
    80000f3c:	85ca                	mv	a1,s2
    80000f3e:	8526                	mv	a0,s1
    80000f40:	929ff0ef          	jal	80000868 <uvmfree>
}
    80000f44:	60e2                	ld	ra,24(sp)
    80000f46:	6442                	ld	s0,16(sp)
    80000f48:	64a2                	ld	s1,8(sp)
    80000f4a:	6902                	ld	s2,0(sp)
    80000f4c:	6105                	addi	sp,sp,32
    80000f4e:	8082                	ret

0000000080000f50 <freeproc>:
freeproc(struct proc* p) {
    80000f50:	1101                	addi	sp,sp,-32
    80000f52:	ec06                	sd	ra,24(sp)
    80000f54:	e822                	sd	s0,16(sp)
    80000f56:	e426                	sd	s1,8(sp)
    80000f58:	1000                	addi	s0,sp,32
    80000f5a:	84aa                	mv	s1,a0
	if (p->trapframe)
    80000f5c:	6d28                	ld	a0,88(a0)
    80000f5e:	c119                	beqz	a0,80000f64 <freeproc+0x14>
		kfree((void*)p->trapframe);
    80000f60:	8bcff0ef          	jal	8000001c <kfree>
	p->trapframe = 0;
    80000f64:	0404bc23          	sd	zero,88(s1)
	if (p->pagetable)
    80000f68:	68a8                	ld	a0,80(s1)
    80000f6a:	c501                	beqz	a0,80000f72 <freeproc+0x22>
		proc_freepagetable(p->pagetable, p->sz);
    80000f6c:	64ac                	ld	a1,72(s1)
    80000f6e:	f9dff0ef          	jal	80000f0a <proc_freepagetable>
	p->pagetable = 0;
    80000f72:	0404b823          	sd	zero,80(s1)
	p->sz = 0;
    80000f76:	0404b423          	sd	zero,72(s1)
	p->pid = 0;
    80000f7a:	0204a823          	sw	zero,48(s1)
	p->parent = 0;
    80000f7e:	0204bc23          	sd	zero,56(s1)
	p->name[0] = 0;
    80000f82:	14048c23          	sb	zero,344(s1)
	p->chan = 0;
    80000f86:	0204b023          	sd	zero,32(s1)
	p->killed = 0;
    80000f8a:	0204a423          	sw	zero,40(s1)
	p->xstate = 0;
    80000f8e:	0204a623          	sw	zero,44(s1)
	p->state = UNUSED;
    80000f92:	0004ac23          	sw	zero,24(s1)
}
    80000f96:	60e2                	ld	ra,24(sp)
    80000f98:	6442                	ld	s0,16(sp)
    80000f9a:	64a2                	ld	s1,8(sp)
    80000f9c:	6105                	addi	sp,sp,32
    80000f9e:	8082                	ret

0000000080000fa0 <allocproc>:
allocproc(void) {
    80000fa0:	1101                	addi	sp,sp,-32
    80000fa2:	ec06                	sd	ra,24(sp)
    80000fa4:	e822                	sd	s0,16(sp)
    80000fa6:	e426                	sd	s1,8(sp)
    80000fa8:	e04a                	sd	s2,0(sp)
    80000faa:	1000                	addi	s0,sp,32
	for (p = proc; p < &proc[NPROC]; p++) {
    80000fac:	00007497          	auipc	s1,0x7
    80000fb0:	d3448493          	addi	s1,s1,-716 # 80007ce0 <proc>
    80000fb4:	00011917          	auipc	s2,0x11
    80000fb8:	72c90913          	addi	s2,s2,1836 # 800126e0 <tickslock>
		acquire(&p->lock);
    80000fbc:	8526                	mv	a0,s1
    80000fbe:	243040ef          	jal	80005a00 <acquire>
		if (p->state == UNUSED) {
    80000fc2:	4c9c                	lw	a5,24(s1)
    80000fc4:	cb91                	beqz	a5,80000fd8 <allocproc+0x38>
			release(&p->lock);
    80000fc6:	8526                	mv	a0,s1
    80000fc8:	2cd040ef          	jal	80005a94 <release>
	for (p = proc; p < &proc[NPROC]; p++) {
    80000fcc:	2a848493          	addi	s1,s1,680
    80000fd0:	ff2496e3          	bne	s1,s2,80000fbc <allocproc+0x1c>
	return 0;
    80000fd4:	4481                	li	s1,0
    80000fd6:	a889                	j	80001028 <allocproc+0x88>
	p->pid = allocpid();
    80000fd8:	e71ff0ef          	jal	80000e48 <allocpid>
    80000fdc:	d888                	sw	a0,48(s1)
	p->state = USED;
    80000fde:	4785                	li	a5,1
    80000fe0:	cc9c                	sw	a5,24(s1)
	if ((p->trapframe = (struct trapframe*)kalloc()) == 0) {
    80000fe2:	922ff0ef          	jal	80000104 <kalloc>
    80000fe6:	892a                	mv	s2,a0
    80000fe8:	eca8                	sd	a0,88(s1)
    80000fea:	c531                	beqz	a0,80001036 <allocproc+0x96>
	p->pagetable = proc_pagetable(p);
    80000fec:	8526                	mv	a0,s1
    80000fee:	e99ff0ef          	jal	80000e86 <proc_pagetable>
    80000ff2:	892a                	mv	s2,a0
    80000ff4:	e8a8                	sd	a0,80(s1)
	if (p->pagetable == 0) {
    80000ff6:	c921                	beqz	a0,80001046 <allocproc+0xa6>
	p->lasttick = 0;
    80000ff8:	1604b423          	sd	zero,360(s1)
	p->handler = 0;
    80000ffc:	1604bc23          	sd	zero,376(s1)
	p->alarming = 0;
    80001000:	1804a023          	sw	zero,384(s1)
	p->interval = 0;
    80001004:	1604b823          	sd	zero,368(s1)
	memset(&p->context, 0, sizeof(p->context));
    80001008:	07000613          	li	a2,112
    8000100c:	4581                	li	a1,0
    8000100e:	06048513          	addi	a0,s1,96
    80001012:	94cff0ef          	jal	8000015e <memset>
	p->context.ra = (uint64)forkret;
    80001016:	00000797          	auipc	a5,0x0
    8000101a:	d9878793          	addi	a5,a5,-616 # 80000dae <forkret>
    8000101e:	f0bc                	sd	a5,96(s1)
	p->context.sp = p->kstack + PGSIZE;
    80001020:	60bc                	ld	a5,64(s1)
    80001022:	6705                	lui	a4,0x1
    80001024:	97ba                	add	a5,a5,a4
    80001026:	f4bc                	sd	a5,104(s1)
}
    80001028:	8526                	mv	a0,s1
    8000102a:	60e2                	ld	ra,24(sp)
    8000102c:	6442                	ld	s0,16(sp)
    8000102e:	64a2                	ld	s1,8(sp)
    80001030:	6902                	ld	s2,0(sp)
    80001032:	6105                	addi	sp,sp,32
    80001034:	8082                	ret
		freeproc(p);
    80001036:	8526                	mv	a0,s1
    80001038:	f19ff0ef          	jal	80000f50 <freeproc>
		release(&p->lock);
    8000103c:	8526                	mv	a0,s1
    8000103e:	257040ef          	jal	80005a94 <release>
		return 0;
    80001042:	84ca                	mv	s1,s2
    80001044:	b7d5                	j	80001028 <allocproc+0x88>
		freeproc(p);
    80001046:	8526                	mv	a0,s1
    80001048:	f09ff0ef          	jal	80000f50 <freeproc>
		release(&p->lock);
    8000104c:	8526                	mv	a0,s1
    8000104e:	247040ef          	jal	80005a94 <release>
		return 0;
    80001052:	84ca                	mv	s1,s2
    80001054:	bfd1                	j	80001028 <allocproc+0x88>

0000000080001056 <userinit>:
void userinit(void) {
    80001056:	1101                	addi	sp,sp,-32
    80001058:	ec06                	sd	ra,24(sp)
    8000105a:	e822                	sd	s0,16(sp)
    8000105c:	e426                	sd	s1,8(sp)
    8000105e:	1000                	addi	s0,sp,32
	p = allocproc();
    80001060:	f41ff0ef          	jal	80000fa0 <allocproc>
    80001064:	84aa                	mv	s1,a0
	initproc = p;
    80001066:	00007797          	auipc	a5,0x7
    8000106a:	80a7b523          	sd	a0,-2038(a5) # 80007870 <initproc>
	p->cwd = namei("/");
    8000106e:	00006517          	auipc	a0,0x6
    80001072:	0c250513          	addi	a0,a0,194 # 80007130 <etext+0x130>
    80001076:	6b7010ef          	jal	80002f2c <namei>
    8000107a:	14a4b823          	sd	a0,336(s1)
	p->state = RUNNABLE;
    8000107e:	478d                	li	a5,3
    80001080:	cc9c                	sw	a5,24(s1)
	release(&p->lock);
    80001082:	8526                	mv	a0,s1
    80001084:	211040ef          	jal	80005a94 <release>
}
    80001088:	60e2                	ld	ra,24(sp)
    8000108a:	6442                	ld	s0,16(sp)
    8000108c:	64a2                	ld	s1,8(sp)
    8000108e:	6105                	addi	sp,sp,32
    80001090:	8082                	ret

0000000080001092 <growproc>:
int growproc(int n) {
    80001092:	1101                	addi	sp,sp,-32
    80001094:	ec06                	sd	ra,24(sp)
    80001096:	e822                	sd	s0,16(sp)
    80001098:	e426                	sd	s1,8(sp)
    8000109a:	e04a                	sd	s2,0(sp)
    8000109c:	1000                	addi	s0,sp,32
    8000109e:	892a                	mv	s2,a0
	struct proc* p = myproc();
    800010a0:	cddff0ef          	jal	80000d7c <myproc>
    800010a4:	84aa                	mv	s1,a0
	sz = p->sz;
    800010a6:	652c                	ld	a1,72(a0)
	if (n > 0) {
    800010a8:	01204c63          	bgtz	s2,800010c0 <growproc+0x2e>
	} else if (n < 0) {
    800010ac:	02094463          	bltz	s2,800010d4 <growproc+0x42>
	p->sz = sz;
    800010b0:	e4ac                	sd	a1,72(s1)
	return 0;
    800010b2:	4501                	li	a0,0
}
    800010b4:	60e2                	ld	ra,24(sp)
    800010b6:	6442                	ld	s0,16(sp)
    800010b8:	64a2                	ld	s1,8(sp)
    800010ba:	6902                	ld	s2,0(sp)
    800010bc:	6105                	addi	sp,sp,32
    800010be:	8082                	ret
		if ((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    800010c0:	4691                	li	a3,4
    800010c2:	00b90633          	add	a2,s2,a1
    800010c6:	6928                	ld	a0,80(a0)
    800010c8:	e9aff0ef          	jal	80000762 <uvmalloc>
    800010cc:	85aa                	mv	a1,a0
    800010ce:	f16d                	bnez	a0,800010b0 <growproc+0x1e>
			return -1;
    800010d0:	557d                	li	a0,-1
    800010d2:	b7cd                	j	800010b4 <growproc+0x22>
		sz = uvmdealloc(p->pagetable, sz, sz + n);
    800010d4:	00b90633          	add	a2,s2,a1
    800010d8:	6928                	ld	a0,80(a0)
    800010da:	e44ff0ef          	jal	8000071e <uvmdealloc>
    800010de:	85aa                	mv	a1,a0
    800010e0:	bfc1                	j	800010b0 <growproc+0x1e>

00000000800010e2 <kfork>:
int kfork(void) {
    800010e2:	7139                	addi	sp,sp,-64
    800010e4:	fc06                	sd	ra,56(sp)
    800010e6:	f822                	sd	s0,48(sp)
    800010e8:	f426                	sd	s1,40(sp)
    800010ea:	e456                	sd	s5,8(sp)
    800010ec:	0080                	addi	s0,sp,64
	struct proc* p = myproc();
    800010ee:	c8fff0ef          	jal	80000d7c <myproc>
    800010f2:	8aaa                	mv	s5,a0
	if ((np = allocproc()) == 0) {
    800010f4:	eadff0ef          	jal	80000fa0 <allocproc>
    800010f8:	0e050a63          	beqz	a0,800011ec <kfork+0x10a>
    800010fc:	e852                	sd	s4,16(sp)
    800010fe:	8a2a                	mv	s4,a0
	if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0) {
    80001100:	048ab603          	ld	a2,72(s5)
    80001104:	692c                	ld	a1,80(a0)
    80001106:	050ab503          	ld	a0,80(s5)
    8000110a:	f90ff0ef          	jal	8000089a <uvmcopy>
    8000110e:	04054863          	bltz	a0,8000115e <kfork+0x7c>
    80001112:	f04a                	sd	s2,32(sp)
    80001114:	ec4e                	sd	s3,24(sp)
	np->sz = p->sz;
    80001116:	048ab783          	ld	a5,72(s5)
    8000111a:	04fa3423          	sd	a5,72(s4)
	*(np->trapframe) = *(p->trapframe);
    8000111e:	058ab683          	ld	a3,88(s5)
    80001122:	87b6                	mv	a5,a3
    80001124:	058a3703          	ld	a4,88(s4)
    80001128:	12068693          	addi	a3,a3,288
    8000112c:	6388                	ld	a0,0(a5)
    8000112e:	678c                	ld	a1,8(a5)
    80001130:	6b90                	ld	a2,16(a5)
    80001132:	e308                	sd	a0,0(a4)
    80001134:	e70c                	sd	a1,8(a4)
    80001136:	eb10                	sd	a2,16(a4)
    80001138:	6f90                	ld	a2,24(a5)
    8000113a:	ef10                	sd	a2,24(a4)
    8000113c:	02078793          	addi	a5,a5,32
    80001140:	02070713          	addi	a4,a4,32 # 1020 <_entry-0x7fffefe0>
    80001144:	fed794e3          	bne	a5,a3,8000112c <kfork+0x4a>
	np->trapframe->a0 = 0;
    80001148:	058a3783          	ld	a5,88(s4)
    8000114c:	0607b823          	sd	zero,112(a5)
	for (i = 0; i < NOFILE; i++)
    80001150:	0d0a8493          	addi	s1,s5,208
    80001154:	0d0a0913          	addi	s2,s4,208
    80001158:	150a8993          	addi	s3,s5,336
    8000115c:	a831                	j	80001178 <kfork+0x96>
		freeproc(np);
    8000115e:	8552                	mv	a0,s4
    80001160:	df1ff0ef          	jal	80000f50 <freeproc>
		release(&np->lock);
    80001164:	8552                	mv	a0,s4
    80001166:	12f040ef          	jal	80005a94 <release>
		return -1;
    8000116a:	54fd                	li	s1,-1
    8000116c:	6a42                	ld	s4,16(sp)
    8000116e:	a885                	j	800011de <kfork+0xfc>
	for (i = 0; i < NOFILE; i++)
    80001170:	04a1                	addi	s1,s1,8
    80001172:	0921                	addi	s2,s2,8
    80001174:	01348963          	beq	s1,s3,80001186 <kfork+0xa4>
		if (p->ofile[i])
    80001178:	6088                	ld	a0,0(s1)
    8000117a:	d97d                	beqz	a0,80001170 <kfork+0x8e>
			np->ofile[i] = filedup(p->ofile[i]);
    8000117c:	36c020ef          	jal	800034e8 <filedup>
    80001180:	00a93023          	sd	a0,0(s2)
    80001184:	b7f5                	j	80001170 <kfork+0x8e>
	np->cwd = idup(p->cwd);
    80001186:	150ab503          	ld	a0,336(s5)
    8000118a:	53e010ef          	jal	800026c8 <idup>
    8000118e:	14aa3823          	sd	a0,336(s4)
	safestrcpy(np->name, p->name, sizeof(p->name));
    80001192:	4641                	li	a2,16
    80001194:	158a8593          	addi	a1,s5,344
    80001198:	158a0513          	addi	a0,s4,344
    8000119c:	916ff0ef          	jal	800002b2 <safestrcpy>
	pid = np->pid;
    800011a0:	030a2483          	lw	s1,48(s4)
	release(&np->lock);
    800011a4:	8552                	mv	a0,s4
    800011a6:	0ef040ef          	jal	80005a94 <release>
	acquire(&wait_lock);
    800011aa:	00006517          	auipc	a0,0x6
    800011ae:	71e50513          	addi	a0,a0,1822 # 800078c8 <wait_lock>
    800011b2:	04f040ef          	jal	80005a00 <acquire>
	np->parent = p;
    800011b6:	035a3c23          	sd	s5,56(s4)
	release(&wait_lock);
    800011ba:	00006517          	auipc	a0,0x6
    800011be:	70e50513          	addi	a0,a0,1806 # 800078c8 <wait_lock>
    800011c2:	0d3040ef          	jal	80005a94 <release>
	acquire(&np->lock);
    800011c6:	8552                	mv	a0,s4
    800011c8:	039040ef          	jal	80005a00 <acquire>
	np->state = RUNNABLE;
    800011cc:	478d                	li	a5,3
    800011ce:	00fa2c23          	sw	a5,24(s4)
	release(&np->lock);
    800011d2:	8552                	mv	a0,s4
    800011d4:	0c1040ef          	jal	80005a94 <release>
	return pid;
    800011d8:	7902                	ld	s2,32(sp)
    800011da:	69e2                	ld	s3,24(sp)
    800011dc:	6a42                	ld	s4,16(sp)
}
    800011de:	8526                	mv	a0,s1
    800011e0:	70e2                	ld	ra,56(sp)
    800011e2:	7442                	ld	s0,48(sp)
    800011e4:	74a2                	ld	s1,40(sp)
    800011e6:	6aa2                	ld	s5,8(sp)
    800011e8:	6121                	addi	sp,sp,64
    800011ea:	8082                	ret
		return -1;
    800011ec:	54fd                	li	s1,-1
    800011ee:	bfc5                	j	800011de <kfork+0xfc>

00000000800011f0 <scheduler>:
void scheduler(void) {
    800011f0:	715d                	addi	sp,sp,-80
    800011f2:	e486                	sd	ra,72(sp)
    800011f4:	e0a2                	sd	s0,64(sp)
    800011f6:	fc26                	sd	s1,56(sp)
    800011f8:	f84a                	sd	s2,48(sp)
    800011fa:	f44e                	sd	s3,40(sp)
    800011fc:	f052                	sd	s4,32(sp)
    800011fe:	ec56                	sd	s5,24(sp)
    80001200:	e85a                	sd	s6,16(sp)
    80001202:	e45e                	sd	s7,8(sp)
    80001204:	e062                	sd	s8,0(sp)
    80001206:	0880                	addi	s0,sp,80
    80001208:	8792                	mv	a5,tp
	int id = r_tp();
    8000120a:	2781                	sext.w	a5,a5
	c->proc = 0;
    8000120c:	00779b13          	slli	s6,a5,0x7
    80001210:	00006717          	auipc	a4,0x6
    80001214:	6a070713          	addi	a4,a4,1696 # 800078b0 <pid_lock>
    80001218:	975a                	add	a4,a4,s6
    8000121a:	02073823          	sd	zero,48(a4)
				swtch(&c->context, &p->context);
    8000121e:	00006717          	auipc	a4,0x6
    80001222:	6ca70713          	addi	a4,a4,1738 # 800078e8 <cpus+0x8>
    80001226:	9b3a                	add	s6,s6,a4
				p->state = RUNNING;
    80001228:	4c11                	li	s8,4
				c->proc = p;
    8000122a:	079e                	slli	a5,a5,0x7
    8000122c:	00006a17          	auipc	s4,0x6
    80001230:	684a0a13          	addi	s4,s4,1668 # 800078b0 <pid_lock>
    80001234:	9a3e                	add	s4,s4,a5
				found = 1;
    80001236:	4b85                	li	s7,1
    80001238:	a83d                	j	80001276 <scheduler+0x86>
			release(&p->lock);
    8000123a:	8526                	mv	a0,s1
    8000123c:	059040ef          	jal	80005a94 <release>
		for (p = proc; p < &proc[NPROC]; p++) {
    80001240:	2a848493          	addi	s1,s1,680
    80001244:	03248563          	beq	s1,s2,8000126e <scheduler+0x7e>
			acquire(&p->lock);
    80001248:	8526                	mv	a0,s1
    8000124a:	7b6040ef          	jal	80005a00 <acquire>
			if (p->state == RUNNABLE) {
    8000124e:	4c9c                	lw	a5,24(s1)
    80001250:	ff3795e3          	bne	a5,s3,8000123a <scheduler+0x4a>
				p->state = RUNNING;
    80001254:	0184ac23          	sw	s8,24(s1)
				c->proc = p;
    80001258:	029a3823          	sd	s1,48(s4)
				swtch(&c->context, &p->context);
    8000125c:	06048593          	addi	a1,s1,96
    80001260:	855a                	mv	a0,s6
    80001262:	5ba000ef          	jal	8000181c <swtch>
				c->proc = 0;
    80001266:	020a3823          	sd	zero,48(s4)
				found = 1;
    8000126a:	8ade                	mv	s5,s7
    8000126c:	b7f9                	j	8000123a <scheduler+0x4a>
		if (found == 0) {
    8000126e:	000a9463          	bnez	s5,80001276 <scheduler+0x86>
			asm volatile("wfi");
    80001272:	10500073          	wfi
	asm volatile("csrr %0, sstatus" : "=r"(x));
    80001276:	100027f3          	csrr	a5,sstatus
	w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000127a:	0027e793          	ori	a5,a5,2
	asm volatile("csrw sstatus, %0" : : "r"(x));
    8000127e:	10079073          	csrw	sstatus,a5
	asm volatile("csrr %0, sstatus" : "=r"(x));
    80001282:	100027f3          	csrr	a5,sstatus
	w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001286:	9bf5                	andi	a5,a5,-3
	asm volatile("csrw sstatus, %0" : : "r"(x));
    80001288:	10079073          	csrw	sstatus,a5
		int found = 0;
    8000128c:	4a81                	li	s5,0
		for (p = proc; p < &proc[NPROC]; p++) {
    8000128e:	00007497          	auipc	s1,0x7
    80001292:	a5248493          	addi	s1,s1,-1454 # 80007ce0 <proc>
			if (p->state == RUNNABLE) {
    80001296:	498d                	li	s3,3
		for (p = proc; p < &proc[NPROC]; p++) {
    80001298:	00011917          	auipc	s2,0x11
    8000129c:	44890913          	addi	s2,s2,1096 # 800126e0 <tickslock>
    800012a0:	b765                	j	80001248 <scheduler+0x58>

00000000800012a2 <sched>:
void sched(void) {
    800012a2:	7179                	addi	sp,sp,-48
    800012a4:	f406                	sd	ra,40(sp)
    800012a6:	f022                	sd	s0,32(sp)
    800012a8:	ec26                	sd	s1,24(sp)
    800012aa:	e84a                	sd	s2,16(sp)
    800012ac:	e44e                	sd	s3,8(sp)
    800012ae:	1800                	addi	s0,sp,48
	struct proc* p = myproc();
    800012b0:	acdff0ef          	jal	80000d7c <myproc>
    800012b4:	84aa                	mv	s1,a0
	if (!holding(&p->lock))
    800012b6:	6da040ef          	jal	80005990 <holding>
    800012ba:	c935                	beqz	a0,8000132e <sched+0x8c>
	asm volatile("mv %0, tp" : "=r"(x));
    800012bc:	8792                	mv	a5,tp
	if (mycpu()->noff != 1)
    800012be:	2781                	sext.w	a5,a5
    800012c0:	079e                	slli	a5,a5,0x7
    800012c2:	00006717          	auipc	a4,0x6
    800012c6:	5ee70713          	addi	a4,a4,1518 # 800078b0 <pid_lock>
    800012ca:	97ba                	add	a5,a5,a4
    800012cc:	0a87a703          	lw	a4,168(a5)
    800012d0:	4785                	li	a5,1
    800012d2:	06f71463          	bne	a4,a5,8000133a <sched+0x98>
	if (p->state == RUNNING)
    800012d6:	4c98                	lw	a4,24(s1)
    800012d8:	4791                	li	a5,4
    800012da:	06f70663          	beq	a4,a5,80001346 <sched+0xa4>
	asm volatile("csrr %0, sstatus" : "=r"(x));
    800012de:	100027f3          	csrr	a5,sstatus
	return (x & SSTATUS_SIE) != 0;
    800012e2:	8b89                	andi	a5,a5,2
	if (intr_get())
    800012e4:	e7bd                	bnez	a5,80001352 <sched+0xb0>
	asm volatile("mv %0, tp" : "=r"(x));
    800012e6:	8792                	mv	a5,tp
	intena = mycpu()->intena;
    800012e8:	00006917          	auipc	s2,0x6
    800012ec:	5c890913          	addi	s2,s2,1480 # 800078b0 <pid_lock>
    800012f0:	2781                	sext.w	a5,a5
    800012f2:	079e                	slli	a5,a5,0x7
    800012f4:	97ca                	add	a5,a5,s2
    800012f6:	0ac7a983          	lw	s3,172(a5)
    800012fa:	8792                	mv	a5,tp
	swtch(&p->context, &mycpu()->context);
    800012fc:	2781                	sext.w	a5,a5
    800012fe:	079e                	slli	a5,a5,0x7
    80001300:	07a1                	addi	a5,a5,8
    80001302:	00006597          	auipc	a1,0x6
    80001306:	5de58593          	addi	a1,a1,1502 # 800078e0 <cpus>
    8000130a:	95be                	add	a1,a1,a5
    8000130c:	06048513          	addi	a0,s1,96
    80001310:	50c000ef          	jal	8000181c <swtch>
    80001314:	8792                	mv	a5,tp
	mycpu()->intena = intena;
    80001316:	2781                	sext.w	a5,a5
    80001318:	079e                	slli	a5,a5,0x7
    8000131a:	993e                	add	s2,s2,a5
    8000131c:	0b392623          	sw	s3,172(s2)
}
    80001320:	70a2                	ld	ra,40(sp)
    80001322:	7402                	ld	s0,32(sp)
    80001324:	64e2                	ld	s1,24(sp)
    80001326:	6942                	ld	s2,16(sp)
    80001328:	69a2                	ld	s3,8(sp)
    8000132a:	6145                	addi	sp,sp,48
    8000132c:	8082                	ret
		panic("sched p->lock");
    8000132e:	00006517          	auipc	a0,0x6
    80001332:	e0a50513          	addi	a0,a0,-502 # 80007138 <etext+0x138>
    80001336:	428040ef          	jal	8000575e <panic>
		panic("sched locks");
    8000133a:	00006517          	auipc	a0,0x6
    8000133e:	e0e50513          	addi	a0,a0,-498 # 80007148 <etext+0x148>
    80001342:	41c040ef          	jal	8000575e <panic>
		panic("sched RUNNING");
    80001346:	00006517          	auipc	a0,0x6
    8000134a:	e1250513          	addi	a0,a0,-494 # 80007158 <etext+0x158>
    8000134e:	410040ef          	jal	8000575e <panic>
		panic("sched interruptible");
    80001352:	00006517          	auipc	a0,0x6
    80001356:	e1650513          	addi	a0,a0,-490 # 80007168 <etext+0x168>
    8000135a:	404040ef          	jal	8000575e <panic>

000000008000135e <yield>:
void yield(void) {
    8000135e:	1101                	addi	sp,sp,-32
    80001360:	ec06                	sd	ra,24(sp)
    80001362:	e822                	sd	s0,16(sp)
    80001364:	e426                	sd	s1,8(sp)
    80001366:	1000                	addi	s0,sp,32
	struct proc* p = myproc();
    80001368:	a15ff0ef          	jal	80000d7c <myproc>
    8000136c:	84aa                	mv	s1,a0
	acquire(&p->lock);
    8000136e:	692040ef          	jal	80005a00 <acquire>
	p->state = RUNNABLE;
    80001372:	478d                	li	a5,3
    80001374:	cc9c                	sw	a5,24(s1)
	sched();
    80001376:	f2dff0ef          	jal	800012a2 <sched>
	release(&p->lock);
    8000137a:	8526                	mv	a0,s1
    8000137c:	718040ef          	jal	80005a94 <release>
}
    80001380:	60e2                	ld	ra,24(sp)
    80001382:	6442                	ld	s0,16(sp)
    80001384:	64a2                	ld	s1,8(sp)
    80001386:	6105                	addi	sp,sp,32
    80001388:	8082                	ret

000000008000138a <sleep>:

// Sleep on channel chan, releasing condition lock lk.
// Re-acquires lk when awakened.
void sleep(void* chan, struct spinlock* lk) {
    8000138a:	7179                	addi	sp,sp,-48
    8000138c:	f406                	sd	ra,40(sp)
    8000138e:	f022                	sd	s0,32(sp)
    80001390:	ec26                	sd	s1,24(sp)
    80001392:	e84a                	sd	s2,16(sp)
    80001394:	e44e                	sd	s3,8(sp)
    80001396:	1800                	addi	s0,sp,48
    80001398:	89aa                	mv	s3,a0
    8000139a:	892e                	mv	s2,a1
	struct proc* p = myproc();
    8000139c:	9e1ff0ef          	jal	80000d7c <myproc>
    800013a0:	84aa                	mv	s1,a0
	// Once we hold p->lock, we can be
	// guaranteed that we won't miss any wakeup
	// (wakeup locks p->lock),
	// so it's okay to release lk.

	acquire(&p->lock);  // DOC: sleeplock1
    800013a2:	65e040ef          	jal	80005a00 <acquire>
	release(lk);
    800013a6:	854a                	mv	a0,s2
    800013a8:	6ec040ef          	jal	80005a94 <release>

	// Go to sleep.
	p->chan = chan;
    800013ac:	0334b023          	sd	s3,32(s1)
	p->state = SLEEPING;
    800013b0:	4789                	li	a5,2
    800013b2:	cc9c                	sw	a5,24(s1)

	sched();
    800013b4:	eefff0ef          	jal	800012a2 <sched>

	// Tidy up.
	p->chan = 0;
    800013b8:	0204b023          	sd	zero,32(s1)

	// Reacquire original lock.
	release(&p->lock);
    800013bc:	8526                	mv	a0,s1
    800013be:	6d6040ef          	jal	80005a94 <release>
	acquire(lk);
    800013c2:	854a                	mv	a0,s2
    800013c4:	63c040ef          	jal	80005a00 <acquire>
}
    800013c8:	70a2                	ld	ra,40(sp)
    800013ca:	7402                	ld	s0,32(sp)
    800013cc:	64e2                	ld	s1,24(sp)
    800013ce:	6942                	ld	s2,16(sp)
    800013d0:	69a2                	ld	s3,8(sp)
    800013d2:	6145                	addi	sp,sp,48
    800013d4:	8082                	ret

00000000800013d6 <wakeup>:

// Wake up all processes sleeping on channel chan.
// Caller should hold the condition lock.
void wakeup(void* chan) {
    800013d6:	7139                	addi	sp,sp,-64
    800013d8:	fc06                	sd	ra,56(sp)
    800013da:	f822                	sd	s0,48(sp)
    800013dc:	f426                	sd	s1,40(sp)
    800013de:	f04a                	sd	s2,32(sp)
    800013e0:	ec4e                	sd	s3,24(sp)
    800013e2:	e852                	sd	s4,16(sp)
    800013e4:	e456                	sd	s5,8(sp)
    800013e6:	0080                	addi	s0,sp,64
    800013e8:	8a2a                	mv	s4,a0
	struct proc* p;

	for (p = proc; p < &proc[NPROC]; p++) {
    800013ea:	00007497          	auipc	s1,0x7
    800013ee:	8f648493          	addi	s1,s1,-1802 # 80007ce0 <proc>
		if (p != myproc()) {
			acquire(&p->lock);
			if (p->state == SLEEPING && p->chan == chan) {
    800013f2:	4989                	li	s3,2
				p->state = RUNNABLE;
    800013f4:	4a8d                	li	s5,3
	for (p = proc; p < &proc[NPROC]; p++) {
    800013f6:	00011917          	auipc	s2,0x11
    800013fa:	2ea90913          	addi	s2,s2,746 # 800126e0 <tickslock>
    800013fe:	a801                	j	8000140e <wakeup+0x38>
			}
			release(&p->lock);
    80001400:	8526                	mv	a0,s1
    80001402:	692040ef          	jal	80005a94 <release>
	for (p = proc; p < &proc[NPROC]; p++) {
    80001406:	2a848493          	addi	s1,s1,680
    8000140a:	03248263          	beq	s1,s2,8000142e <wakeup+0x58>
		if (p != myproc()) {
    8000140e:	96fff0ef          	jal	80000d7c <myproc>
    80001412:	fe950ae3          	beq	a0,s1,80001406 <wakeup+0x30>
			acquire(&p->lock);
    80001416:	8526                	mv	a0,s1
    80001418:	5e8040ef          	jal	80005a00 <acquire>
			if (p->state == SLEEPING && p->chan == chan) {
    8000141c:	4c9c                	lw	a5,24(s1)
    8000141e:	ff3791e3          	bne	a5,s3,80001400 <wakeup+0x2a>
    80001422:	709c                	ld	a5,32(s1)
    80001424:	fd479ee3          	bne	a5,s4,80001400 <wakeup+0x2a>
				p->state = RUNNABLE;
    80001428:	0154ac23          	sw	s5,24(s1)
    8000142c:	bfd1                	j	80001400 <wakeup+0x2a>
		}
	}
}
    8000142e:	70e2                	ld	ra,56(sp)
    80001430:	7442                	ld	s0,48(sp)
    80001432:	74a2                	ld	s1,40(sp)
    80001434:	7902                	ld	s2,32(sp)
    80001436:	69e2                	ld	s3,24(sp)
    80001438:	6a42                	ld	s4,16(sp)
    8000143a:	6aa2                	ld	s5,8(sp)
    8000143c:	6121                	addi	sp,sp,64
    8000143e:	8082                	ret

0000000080001440 <reparent>:
void reparent(struct proc* p) {
    80001440:	7179                	addi	sp,sp,-48
    80001442:	f406                	sd	ra,40(sp)
    80001444:	f022                	sd	s0,32(sp)
    80001446:	ec26                	sd	s1,24(sp)
    80001448:	e84a                	sd	s2,16(sp)
    8000144a:	e44e                	sd	s3,8(sp)
    8000144c:	e052                	sd	s4,0(sp)
    8000144e:	1800                	addi	s0,sp,48
    80001450:	892a                	mv	s2,a0
	for (pp = proc; pp < &proc[NPROC]; pp++) {
    80001452:	00007497          	auipc	s1,0x7
    80001456:	88e48493          	addi	s1,s1,-1906 # 80007ce0 <proc>
			pp->parent = initproc;
    8000145a:	00006a17          	auipc	s4,0x6
    8000145e:	416a0a13          	addi	s4,s4,1046 # 80007870 <initproc>
	for (pp = proc; pp < &proc[NPROC]; pp++) {
    80001462:	00011997          	auipc	s3,0x11
    80001466:	27e98993          	addi	s3,s3,638 # 800126e0 <tickslock>
    8000146a:	a029                	j	80001474 <reparent+0x34>
    8000146c:	2a848493          	addi	s1,s1,680
    80001470:	01348b63          	beq	s1,s3,80001486 <reparent+0x46>
		if (pp->parent == p) {
    80001474:	7c9c                	ld	a5,56(s1)
    80001476:	ff279be3          	bne	a5,s2,8000146c <reparent+0x2c>
			pp->parent = initproc;
    8000147a:	000a3503          	ld	a0,0(s4)
    8000147e:	fc88                	sd	a0,56(s1)
			wakeup(initproc);
    80001480:	f57ff0ef          	jal	800013d6 <wakeup>
    80001484:	b7e5                	j	8000146c <reparent+0x2c>
}
    80001486:	70a2                	ld	ra,40(sp)
    80001488:	7402                	ld	s0,32(sp)
    8000148a:	64e2                	ld	s1,24(sp)
    8000148c:	6942                	ld	s2,16(sp)
    8000148e:	69a2                	ld	s3,8(sp)
    80001490:	6a02                	ld	s4,0(sp)
    80001492:	6145                	addi	sp,sp,48
    80001494:	8082                	ret

0000000080001496 <kexit>:
void kexit(int status) {
    80001496:	7179                	addi	sp,sp,-48
    80001498:	f406                	sd	ra,40(sp)
    8000149a:	f022                	sd	s0,32(sp)
    8000149c:	ec26                	sd	s1,24(sp)
    8000149e:	e84a                	sd	s2,16(sp)
    800014a0:	e44e                	sd	s3,8(sp)
    800014a2:	e052                	sd	s4,0(sp)
    800014a4:	1800                	addi	s0,sp,48
    800014a6:	8a2a                	mv	s4,a0
	struct proc* p = myproc();
    800014a8:	8d5ff0ef          	jal	80000d7c <myproc>
    800014ac:	89aa                	mv	s3,a0
	if (p == initproc)
    800014ae:	00006797          	auipc	a5,0x6
    800014b2:	3c27b783          	ld	a5,962(a5) # 80007870 <initproc>
    800014b6:	0d050493          	addi	s1,a0,208
    800014ba:	15050913          	addi	s2,a0,336
    800014be:	00a79b63          	bne	a5,a0,800014d4 <kexit+0x3e>
		panic("init exiting");
    800014c2:	00006517          	auipc	a0,0x6
    800014c6:	cbe50513          	addi	a0,a0,-834 # 80007180 <etext+0x180>
    800014ca:	294040ef          	jal	8000575e <panic>
	for (int fd = 0; fd < NOFILE; fd++) {
    800014ce:	04a1                	addi	s1,s1,8
    800014d0:	01248963          	beq	s1,s2,800014e2 <kexit+0x4c>
		if (p->ofile[fd]) {
    800014d4:	6088                	ld	a0,0(s1)
    800014d6:	dd65                	beqz	a0,800014ce <kexit+0x38>
			fileclose(f);
    800014d8:	056020ef          	jal	8000352e <fileclose>
			p->ofile[fd] = 0;
    800014dc:	0004b023          	sd	zero,0(s1)
    800014e0:	b7fd                	j	800014ce <kexit+0x38>
	begin_op();
    800014e2:	429010ef          	jal	8000310a <begin_op>
	iput(p->cwd);
    800014e6:	1509b503          	ld	a0,336(s3)
    800014ea:	396010ef          	jal	80002880 <iput>
	end_op();
    800014ee:	48d010ef          	jal	8000317a <end_op>
	p->cwd = 0;
    800014f2:	1409b823          	sd	zero,336(s3)
	acquire(&wait_lock);
    800014f6:	00006517          	auipc	a0,0x6
    800014fa:	3d250513          	addi	a0,a0,978 # 800078c8 <wait_lock>
    800014fe:	502040ef          	jal	80005a00 <acquire>
	reparent(p);
    80001502:	854e                	mv	a0,s3
    80001504:	f3dff0ef          	jal	80001440 <reparent>
	wakeup(p->parent);
    80001508:	0389b503          	ld	a0,56(s3)
    8000150c:	ecbff0ef          	jal	800013d6 <wakeup>
	acquire(&p->lock);
    80001510:	854e                	mv	a0,s3
    80001512:	4ee040ef          	jal	80005a00 <acquire>
	p->xstate = status;
    80001516:	0349a623          	sw	s4,44(s3)
	p->state = ZOMBIE;
    8000151a:	4795                	li	a5,5
    8000151c:	00f9ac23          	sw	a5,24(s3)
	release(&wait_lock);
    80001520:	00006517          	auipc	a0,0x6
    80001524:	3a850513          	addi	a0,a0,936 # 800078c8 <wait_lock>
    80001528:	56c040ef          	jal	80005a94 <release>
	sched();
    8000152c:	d77ff0ef          	jal	800012a2 <sched>
	panic("zombie exit");
    80001530:	00006517          	auipc	a0,0x6
    80001534:	c6050513          	addi	a0,a0,-928 # 80007190 <etext+0x190>
    80001538:	226040ef          	jal	8000575e <panic>

000000008000153c <kkill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kkill(int pid) {
    8000153c:	7179                	addi	sp,sp,-48
    8000153e:	f406                	sd	ra,40(sp)
    80001540:	f022                	sd	s0,32(sp)
    80001542:	ec26                	sd	s1,24(sp)
    80001544:	e84a                	sd	s2,16(sp)
    80001546:	e44e                	sd	s3,8(sp)
    80001548:	1800                	addi	s0,sp,48
    8000154a:	892a                	mv	s2,a0
	struct proc* p;

	for (p = proc; p < &proc[NPROC]; p++) {
    8000154c:	00006497          	auipc	s1,0x6
    80001550:	79448493          	addi	s1,s1,1940 # 80007ce0 <proc>
    80001554:	00011997          	auipc	s3,0x11
    80001558:	18c98993          	addi	s3,s3,396 # 800126e0 <tickslock>
		acquire(&p->lock);
    8000155c:	8526                	mv	a0,s1
    8000155e:	4a2040ef          	jal	80005a00 <acquire>
		if (p->pid == pid) {
    80001562:	589c                	lw	a5,48(s1)
    80001564:	01278b63          	beq	a5,s2,8000157a <kkill+0x3e>
				p->state = RUNNABLE;
			}
			release(&p->lock);
			return 0;
		}
		release(&p->lock);
    80001568:	8526                	mv	a0,s1
    8000156a:	52a040ef          	jal	80005a94 <release>
	for (p = proc; p < &proc[NPROC]; p++) {
    8000156e:	2a848493          	addi	s1,s1,680
    80001572:	ff3495e3          	bne	s1,s3,8000155c <kkill+0x20>
	}
	return -1;
    80001576:	557d                	li	a0,-1
    80001578:	a819                	j	8000158e <kkill+0x52>
			p->killed = 1;
    8000157a:	4785                	li	a5,1
    8000157c:	d49c                	sw	a5,40(s1)
			if (p->state == SLEEPING) {
    8000157e:	4c98                	lw	a4,24(s1)
    80001580:	4789                	li	a5,2
    80001582:	00f70d63          	beq	a4,a5,8000159c <kkill+0x60>
			release(&p->lock);
    80001586:	8526                	mv	a0,s1
    80001588:	50c040ef          	jal	80005a94 <release>
			return 0;
    8000158c:	4501                	li	a0,0
}
    8000158e:	70a2                	ld	ra,40(sp)
    80001590:	7402                	ld	s0,32(sp)
    80001592:	64e2                	ld	s1,24(sp)
    80001594:	6942                	ld	s2,16(sp)
    80001596:	69a2                	ld	s3,8(sp)
    80001598:	6145                	addi	sp,sp,48
    8000159a:	8082                	ret
				p->state = RUNNABLE;
    8000159c:	478d                	li	a5,3
    8000159e:	cc9c                	sw	a5,24(s1)
    800015a0:	b7dd                	j	80001586 <kkill+0x4a>

00000000800015a2 <setkilled>:

void setkilled(struct proc* p) {
    800015a2:	1101                	addi	sp,sp,-32
    800015a4:	ec06                	sd	ra,24(sp)
    800015a6:	e822                	sd	s0,16(sp)
    800015a8:	e426                	sd	s1,8(sp)
    800015aa:	1000                	addi	s0,sp,32
    800015ac:	84aa                	mv	s1,a0
	acquire(&p->lock);
    800015ae:	452040ef          	jal	80005a00 <acquire>
	p->killed = 1;
    800015b2:	4785                	li	a5,1
    800015b4:	d49c                	sw	a5,40(s1)
	release(&p->lock);
    800015b6:	8526                	mv	a0,s1
    800015b8:	4dc040ef          	jal	80005a94 <release>
}
    800015bc:	60e2                	ld	ra,24(sp)
    800015be:	6442                	ld	s0,16(sp)
    800015c0:	64a2                	ld	s1,8(sp)
    800015c2:	6105                	addi	sp,sp,32
    800015c4:	8082                	ret

00000000800015c6 <killed>:

int killed(struct proc* p) {
    800015c6:	1101                	addi	sp,sp,-32
    800015c8:	ec06                	sd	ra,24(sp)
    800015ca:	e822                	sd	s0,16(sp)
    800015cc:	e426                	sd	s1,8(sp)
    800015ce:	e04a                	sd	s2,0(sp)
    800015d0:	1000                	addi	s0,sp,32
    800015d2:	84aa                	mv	s1,a0
	int k;

	acquire(&p->lock);
    800015d4:	42c040ef          	jal	80005a00 <acquire>
	k = p->killed;
    800015d8:	549c                	lw	a5,40(s1)
    800015da:	893e                	mv	s2,a5
	release(&p->lock);
    800015dc:	8526                	mv	a0,s1
    800015de:	4b6040ef          	jal	80005a94 <release>
	return k;
}
    800015e2:	854a                	mv	a0,s2
    800015e4:	60e2                	ld	ra,24(sp)
    800015e6:	6442                	ld	s0,16(sp)
    800015e8:	64a2                	ld	s1,8(sp)
    800015ea:	6902                	ld	s2,0(sp)
    800015ec:	6105                	addi	sp,sp,32
    800015ee:	8082                	ret

00000000800015f0 <kwait>:
int kwait(uint64 addr) {
    800015f0:	715d                	addi	sp,sp,-80
    800015f2:	e486                	sd	ra,72(sp)
    800015f4:	e0a2                	sd	s0,64(sp)
    800015f6:	fc26                	sd	s1,56(sp)
    800015f8:	f84a                	sd	s2,48(sp)
    800015fa:	f44e                	sd	s3,40(sp)
    800015fc:	f052                	sd	s4,32(sp)
    800015fe:	ec56                	sd	s5,24(sp)
    80001600:	e85a                	sd	s6,16(sp)
    80001602:	e45e                	sd	s7,8(sp)
    80001604:	0880                	addi	s0,sp,80
    80001606:	8baa                	mv	s7,a0
	struct proc* p = myproc();
    80001608:	f74ff0ef          	jal	80000d7c <myproc>
    8000160c:	892a                	mv	s2,a0
	acquire(&wait_lock);
    8000160e:	00006517          	auipc	a0,0x6
    80001612:	2ba50513          	addi	a0,a0,698 # 800078c8 <wait_lock>
    80001616:	3ea040ef          	jal	80005a00 <acquire>
				if (pp->state == ZOMBIE) {
    8000161a:	4a15                	li	s4,5
				havekids = 1;
    8000161c:	4a85                	li	s5,1
		for (pp = proc; pp < &proc[NPROC]; pp++) {
    8000161e:	00011997          	auipc	s3,0x11
    80001622:	0c298993          	addi	s3,s3,194 # 800126e0 <tickslock>
		sleep(p, &wait_lock);  // DOC: wait-sleep
    80001626:	00006b17          	auipc	s6,0x6
    8000162a:	2a2b0b13          	addi	s6,s6,674 # 800078c8 <wait_lock>
    8000162e:	a869                	j	800016c8 <kwait+0xd8>
					pid = pp->pid;
    80001630:	0304a983          	lw	s3,48(s1)
					if (addr != 0 && copyout(p->pagetable, addr, (char*)&pp->xstate,
    80001634:	000b8c63          	beqz	s7,8000164c <kwait+0x5c>
    80001638:	4691                	li	a3,4
    8000163a:	02c48613          	addi	a2,s1,44
    8000163e:	85de                	mv	a1,s7
    80001640:	05093503          	ld	a0,80(s2)
    80001644:	c76ff0ef          	jal	80000aba <copyout>
    80001648:	02054a63          	bltz	a0,8000167c <kwait+0x8c>
					freeproc(pp);
    8000164c:	8526                	mv	a0,s1
    8000164e:	903ff0ef          	jal	80000f50 <freeproc>
					release(&pp->lock);
    80001652:	8526                	mv	a0,s1
    80001654:	440040ef          	jal	80005a94 <release>
					release(&wait_lock);
    80001658:	00006517          	auipc	a0,0x6
    8000165c:	27050513          	addi	a0,a0,624 # 800078c8 <wait_lock>
    80001660:	434040ef          	jal	80005a94 <release>
}
    80001664:	854e                	mv	a0,s3
    80001666:	60a6                	ld	ra,72(sp)
    80001668:	6406                	ld	s0,64(sp)
    8000166a:	74e2                	ld	s1,56(sp)
    8000166c:	7942                	ld	s2,48(sp)
    8000166e:	79a2                	ld	s3,40(sp)
    80001670:	7a02                	ld	s4,32(sp)
    80001672:	6ae2                	ld	s5,24(sp)
    80001674:	6b42                	ld	s6,16(sp)
    80001676:	6ba2                	ld	s7,8(sp)
    80001678:	6161                	addi	sp,sp,80
    8000167a:	8082                	ret
						release(&pp->lock);
    8000167c:	8526                	mv	a0,s1
    8000167e:	416040ef          	jal	80005a94 <release>
						release(&wait_lock);
    80001682:	00006517          	auipc	a0,0x6
    80001686:	24650513          	addi	a0,a0,582 # 800078c8 <wait_lock>
    8000168a:	40a040ef          	jal	80005a94 <release>
						return -1;
    8000168e:	59fd                	li	s3,-1
    80001690:	bfd1                	j	80001664 <kwait+0x74>
		for (pp = proc; pp < &proc[NPROC]; pp++) {
    80001692:	2a848493          	addi	s1,s1,680
    80001696:	03348063          	beq	s1,s3,800016b6 <kwait+0xc6>
			if (pp->parent == p) {
    8000169a:	7c9c                	ld	a5,56(s1)
    8000169c:	ff279be3          	bne	a5,s2,80001692 <kwait+0xa2>
				acquire(&pp->lock);
    800016a0:	8526                	mv	a0,s1
    800016a2:	35e040ef          	jal	80005a00 <acquire>
				if (pp->state == ZOMBIE) {
    800016a6:	4c9c                	lw	a5,24(s1)
    800016a8:	f94784e3          	beq	a5,s4,80001630 <kwait+0x40>
				release(&pp->lock);
    800016ac:	8526                	mv	a0,s1
    800016ae:	3e6040ef          	jal	80005a94 <release>
				havekids = 1;
    800016b2:	8756                	mv	a4,s5
    800016b4:	bff9                	j	80001692 <kwait+0xa2>
		if (!havekids || killed(p)) {
    800016b6:	cf19                	beqz	a4,800016d4 <kwait+0xe4>
    800016b8:	854a                	mv	a0,s2
    800016ba:	f0dff0ef          	jal	800015c6 <killed>
    800016be:	e919                	bnez	a0,800016d4 <kwait+0xe4>
		sleep(p, &wait_lock);  // DOC: wait-sleep
    800016c0:	85da                	mv	a1,s6
    800016c2:	854a                	mv	a0,s2
    800016c4:	cc7ff0ef          	jal	8000138a <sleep>
		havekids = 0;
    800016c8:	4701                	li	a4,0
		for (pp = proc; pp < &proc[NPROC]; pp++) {
    800016ca:	00006497          	auipc	s1,0x6
    800016ce:	61648493          	addi	s1,s1,1558 # 80007ce0 <proc>
    800016d2:	b7e1                	j	8000169a <kwait+0xaa>
			release(&wait_lock);
    800016d4:	00006517          	auipc	a0,0x6
    800016d8:	1f450513          	addi	a0,a0,500 # 800078c8 <wait_lock>
    800016dc:	3b8040ef          	jal	80005a94 <release>
			return -1;
    800016e0:	59fd                	li	s3,-1
    800016e2:	b749                	j	80001664 <kwait+0x74>

00000000800016e4 <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void* src, uint64 len) {
    800016e4:	7179                	addi	sp,sp,-48
    800016e6:	f406                	sd	ra,40(sp)
    800016e8:	f022                	sd	s0,32(sp)
    800016ea:	ec26                	sd	s1,24(sp)
    800016ec:	e84a                	sd	s2,16(sp)
    800016ee:	e44e                	sd	s3,8(sp)
    800016f0:	e052                	sd	s4,0(sp)
    800016f2:	1800                	addi	s0,sp,48
    800016f4:	84aa                	mv	s1,a0
    800016f6:	8a2e                	mv	s4,a1
    800016f8:	89b2                	mv	s3,a2
    800016fa:	8936                	mv	s2,a3
	struct proc* p = myproc();
    800016fc:	e80ff0ef          	jal	80000d7c <myproc>
	if (user_dst) {
    80001700:	cc99                	beqz	s1,8000171e <either_copyout+0x3a>
		return copyout(p->pagetable, dst, src, len);
    80001702:	86ca                	mv	a3,s2
    80001704:	864e                	mv	a2,s3
    80001706:	85d2                	mv	a1,s4
    80001708:	6928                	ld	a0,80(a0)
    8000170a:	bb0ff0ef          	jal	80000aba <copyout>
	} else {
		memmove((char*)dst, src, len);
		return 0;
	}
}
    8000170e:	70a2                	ld	ra,40(sp)
    80001710:	7402                	ld	s0,32(sp)
    80001712:	64e2                	ld	s1,24(sp)
    80001714:	6942                	ld	s2,16(sp)
    80001716:	69a2                	ld	s3,8(sp)
    80001718:	6a02                	ld	s4,0(sp)
    8000171a:	6145                	addi	sp,sp,48
    8000171c:	8082                	ret
		memmove((char*)dst, src, len);
    8000171e:	0009061b          	sext.w	a2,s2
    80001722:	85ce                	mv	a1,s3
    80001724:	8552                	mv	a0,s4
    80001726:	a99fe0ef          	jal	800001be <memmove>
		return 0;
    8000172a:	8526                	mv	a0,s1
    8000172c:	b7cd                	j	8000170e <either_copyout+0x2a>

000000008000172e <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void* dst, int user_src, uint64 src, uint64 len) {
    8000172e:	7179                	addi	sp,sp,-48
    80001730:	f406                	sd	ra,40(sp)
    80001732:	f022                	sd	s0,32(sp)
    80001734:	ec26                	sd	s1,24(sp)
    80001736:	e84a                	sd	s2,16(sp)
    80001738:	e44e                	sd	s3,8(sp)
    8000173a:	e052                	sd	s4,0(sp)
    8000173c:	1800                	addi	s0,sp,48
    8000173e:	8a2a                	mv	s4,a0
    80001740:	84ae                	mv	s1,a1
    80001742:	89b2                	mv	s3,a2
    80001744:	8936                	mv	s2,a3
	struct proc* p = myproc();
    80001746:	e36ff0ef          	jal	80000d7c <myproc>
	if (user_src) {
    8000174a:	cc99                	beqz	s1,80001768 <either_copyin+0x3a>
		return copyin(p->pagetable, dst, src, len);
    8000174c:	86ca                	mv	a3,s2
    8000174e:	864e                	mv	a2,s3
    80001750:	85d2                	mv	a1,s4
    80001752:	6928                	ld	a0,80(a0)
    80001754:	c24ff0ef          	jal	80000b78 <copyin>
	} else {
		memmove(dst, (char*)src, len);
		return 0;
	}
}
    80001758:	70a2                	ld	ra,40(sp)
    8000175a:	7402                	ld	s0,32(sp)
    8000175c:	64e2                	ld	s1,24(sp)
    8000175e:	6942                	ld	s2,16(sp)
    80001760:	69a2                	ld	s3,8(sp)
    80001762:	6a02                	ld	s4,0(sp)
    80001764:	6145                	addi	sp,sp,48
    80001766:	8082                	ret
		memmove(dst, (char*)src, len);
    80001768:	0009061b          	sext.w	a2,s2
    8000176c:	85ce                	mv	a1,s3
    8000176e:	8552                	mv	a0,s4
    80001770:	a4ffe0ef          	jal	800001be <memmove>
		return 0;
    80001774:	8526                	mv	a0,s1
    80001776:	b7cd                	j	80001758 <either_copyin+0x2a>

0000000080001778 <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void) {
    80001778:	715d                	addi	sp,sp,-80
    8000177a:	e486                	sd	ra,72(sp)
    8000177c:	e0a2                	sd	s0,64(sp)
    8000177e:	fc26                	sd	s1,56(sp)
    80001780:	f84a                	sd	s2,48(sp)
    80001782:	f44e                	sd	s3,40(sp)
    80001784:	f052                	sd	s4,32(sp)
    80001786:	ec56                	sd	s5,24(sp)
    80001788:	e85a                	sd	s6,16(sp)
    8000178a:	e45e                	sd	s7,8(sp)
    8000178c:	0880                	addi	s0,sp,80
	    [RUNNING] "run   ",
	    [ZOMBIE] "zombie"};
	struct proc* p;
	char* state;

	printf("\n");
    8000178e:	00006517          	auipc	a0,0x6
    80001792:	88a50513          	addi	a0,a0,-1910 # 80007018 <etext+0x18>
    80001796:	427030ef          	jal	800053bc <printf>
	for (p = proc; p < &proc[NPROC]; p++) {
    8000179a:	00006497          	auipc	s1,0x6
    8000179e:	69e48493          	addi	s1,s1,1694 # 80007e38 <proc+0x158>
    800017a2:	00011917          	auipc	s2,0x11
    800017a6:	09690913          	addi	s2,s2,150 # 80012838 <bcache+0x140>
		if (p->state == UNUSED)
			continue;
		if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800017aa:	4b15                	li	s6,5
			state = states[p->state];
		else
			state = "???";
    800017ac:	00006997          	auipc	s3,0x6
    800017b0:	9f498993          	addi	s3,s3,-1548 # 800071a0 <etext+0x1a0>
		printf("%d %s %s", p->pid, state, p->name);
    800017b4:	00006a97          	auipc	s5,0x6
    800017b8:	9f4a8a93          	addi	s5,s5,-1548 # 800071a8 <etext+0x1a8>
		printf("\n");
    800017bc:	00006a17          	auipc	s4,0x6
    800017c0:	85ca0a13          	addi	s4,s4,-1956 # 80007018 <etext+0x18>
		if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800017c4:	00006b97          	auipc	s7,0x6
    800017c8:	f64b8b93          	addi	s7,s7,-156 # 80007728 <states.0>
    800017cc:	a829                	j	800017e6 <procdump+0x6e>
		printf("%d %s %s", p->pid, state, p->name);
    800017ce:	ed86a583          	lw	a1,-296(a3)
    800017d2:	8556                	mv	a0,s5
    800017d4:	3e9030ef          	jal	800053bc <printf>
		printf("\n");
    800017d8:	8552                	mv	a0,s4
    800017da:	3e3030ef          	jal	800053bc <printf>
	for (p = proc; p < &proc[NPROC]; p++) {
    800017de:	2a848493          	addi	s1,s1,680
    800017e2:	03248263          	beq	s1,s2,80001806 <procdump+0x8e>
		if (p->state == UNUSED)
    800017e6:	86a6                	mv	a3,s1
    800017e8:	ec04a783          	lw	a5,-320(s1)
    800017ec:	dbed                	beqz	a5,800017de <procdump+0x66>
			state = "???";
    800017ee:	864e                	mv	a2,s3
		if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800017f0:	fcfb6fe3          	bltu	s6,a5,800017ce <procdump+0x56>
    800017f4:	02079713          	slli	a4,a5,0x20
    800017f8:	01d75793          	srli	a5,a4,0x1d
    800017fc:	97de                	add	a5,a5,s7
    800017fe:	6390                	ld	a2,0(a5)
    80001800:	f679                	bnez	a2,800017ce <procdump+0x56>
			state = "???";
    80001802:	864e                	mv	a2,s3
    80001804:	b7e9                	j	800017ce <procdump+0x56>
	}
}
    80001806:	60a6                	ld	ra,72(sp)
    80001808:	6406                	ld	s0,64(sp)
    8000180a:	74e2                	ld	s1,56(sp)
    8000180c:	7942                	ld	s2,48(sp)
    8000180e:	79a2                	ld	s3,40(sp)
    80001810:	7a02                	ld	s4,32(sp)
    80001812:	6ae2                	ld	s5,24(sp)
    80001814:	6b42                	ld	s6,16(sp)
    80001816:	6ba2                	ld	s7,8(sp)
    80001818:	6161                	addi	sp,sp,80
    8000181a:	8082                	ret

000000008000181c <swtch>:
# Save current registers in old. Load from new.	


.globl swtch
swtch:
        sd ra, 0(a0)
    8000181c:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    80001820:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    80001824:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    80001826:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    80001828:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    8000182c:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    80001830:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    80001834:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    80001838:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    8000183c:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    80001840:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    80001844:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    80001848:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    8000184c:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    80001850:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    80001854:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    80001858:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    8000185a:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    8000185c:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    80001860:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    80001864:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    80001868:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    8000186c:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    80001870:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    80001874:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    80001878:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    8000187c:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    80001880:	0685bd83          	ld	s11,104(a1)
        
        ret
    80001884:	8082                	ret

0000000080001886 <trapinit>:
// in kernelvec.S, calls kerneltrap().
void kernelvec();

extern int devintr();

void trapinit(void) {
    80001886:	1141                	addi	sp,sp,-16
    80001888:	e406                	sd	ra,8(sp)
    8000188a:	e022                	sd	s0,0(sp)
    8000188c:	0800                	addi	s0,sp,16
	initlock(&tickslock, "time");
    8000188e:	00006597          	auipc	a1,0x6
    80001892:	95a58593          	addi	a1,a1,-1702 # 800071e8 <etext+0x1e8>
    80001896:	00011517          	auipc	a0,0x11
    8000189a:	e4a50513          	addi	a0,a0,-438 # 800126e0 <tickslock>
    8000189e:	0d8040ef          	jal	80005976 <initlock>
}
    800018a2:	60a2                	ld	ra,8(sp)
    800018a4:	6402                	ld	s0,0(sp)
    800018a6:	0141                	addi	sp,sp,16
    800018a8:	8082                	ret

00000000800018aa <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void trapinithart(void) {
    800018aa:	1141                	addi	sp,sp,-16
    800018ac:	e406                	sd	ra,8(sp)
    800018ae:	e022                	sd	s0,0(sp)
    800018b0:	0800                	addi	s0,sp,16
	asm volatile("csrw stvec, %0" : : "r"(x));
    800018b2:	00003797          	auipc	a5,0x3
    800018b6:	03e78793          	addi	a5,a5,62 # 800048f0 <kernelvec>
    800018ba:	10579073          	csrw	stvec,a5
	w_stvec((uint64)kernelvec);
}
    800018be:	60a2                	ld	ra,8(sp)
    800018c0:	6402                	ld	s0,0(sp)
    800018c2:	0141                	addi	sp,sp,16
    800018c4:	8082                	ret

00000000800018c6 <prepare_return>:
}

//
// set up trapframe and control registers for a return to user space
//
void prepare_return(void) {
    800018c6:	1141                	addi	sp,sp,-16
    800018c8:	e406                	sd	ra,8(sp)
    800018ca:	e022                	sd	s0,0(sp)
    800018cc:	0800                	addi	s0,sp,16
	struct proc* p = myproc();
    800018ce:	caeff0ef          	jal	80000d7c <myproc>
	asm volatile("csrr %0, sstatus" : "=r"(x));
    800018d2:	100027f3          	csrr	a5,sstatus
	w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800018d6:	9bf5                	andi	a5,a5,-3
	asm volatile("csrw sstatus, %0" : : "r"(x));
    800018d8:	10079073          	csrw	sstatus,a5
	// kerneltrap() to usertrap(). because a trap from kernel
	// code to usertrap would be a disaster, turn off interrupts.
	intr_off();

	// send syscalls, interrupts, and exceptions to uservec in trampoline.S
	uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    800018dc:	04000737          	lui	a4,0x4000
    800018e0:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    800018e2:	0732                	slli	a4,a4,0xc
    800018e4:	00004797          	auipc	a5,0x4
    800018e8:	71c78793          	addi	a5,a5,1820 # 80006000 <_trampoline>
    800018ec:	00004697          	auipc	a3,0x4
    800018f0:	71468693          	addi	a3,a3,1812 # 80006000 <_trampoline>
    800018f4:	8f95                	sub	a5,a5,a3
    800018f6:	97ba                	add	a5,a5,a4
	asm volatile("csrw stvec, %0" : : "r"(x));
    800018f8:	10579073          	csrw	stvec,a5
	w_stvec(trampoline_uservec);

	// set up trapframe values that uservec will need when
	// the process next traps into the kernel.
	p->trapframe->kernel_satp = r_satp();          // kernel page table
    800018fc:	6d3c                	ld	a5,88(a0)
	asm volatile("csrr %0, satp" : "=r"(x));
    800018fe:	18002773          	csrr	a4,satp
    80001902:	e398                	sd	a4,0(a5)
	p->trapframe->kernel_sp = p->kstack + PGSIZE;  // process's kernel stack
    80001904:	6d38                	ld	a4,88(a0)
    80001906:	613c                	ld	a5,64(a0)
    80001908:	6685                	lui	a3,0x1
    8000190a:	97b6                	add	a5,a5,a3
    8000190c:	e71c                	sd	a5,8(a4)
	p->trapframe->kernel_trap = (uint64)usertrap;
    8000190e:	6d3c                	ld	a5,88(a0)
    80001910:	00000717          	auipc	a4,0x0
    80001914:	0fc70713          	addi	a4,a4,252 # 80001a0c <usertrap>
    80001918:	eb98                	sd	a4,16(a5)
	p->trapframe->kernel_hartid = r_tp();  // hartid for cpuid()
    8000191a:	6d3c                	ld	a5,88(a0)
	asm volatile("mv %0, tp" : "=r"(x));
    8000191c:	8712                	mv	a4,tp
    8000191e:	f398                	sd	a4,32(a5)
	asm volatile("csrr %0, sstatus" : "=r"(x));
    80001920:	100027f3          	csrr	a5,sstatus
	// set up the registers that trampoline.S's sret will use
	// to get to user space.

	// set S Previous Privilege mode to User.
	unsigned long x = r_sstatus();
	x &= ~SSTATUS_SPP;  // clear SPP to 0 for user mode
    80001924:	eff7f793          	andi	a5,a5,-257
	x |= SSTATUS_SPIE;  // enable interrupts in user mode
    80001928:	0207e793          	ori	a5,a5,32
	asm volatile("csrw sstatus, %0" : : "r"(x));
    8000192c:	10079073          	csrw	sstatus,a5
	w_sstatus(x);

	// set S Exception Program Counter to the saved user pc.
	w_sepc(p->trapframe->epc);
    80001930:	6d3c                	ld	a5,88(a0)
	asm volatile("csrw sepc, %0" : : "r"(x));
    80001932:	6f9c                	ld	a5,24(a5)
    80001934:	14179073          	csrw	sepc,a5
}
    80001938:	60a2                	ld	ra,8(sp)
    8000193a:	6402                	ld	s0,0(sp)
    8000193c:	0141                	addi	sp,sp,16
    8000193e:	8082                	ret

0000000080001940 <clockintr>:
	// so restore trap registers for use by kernelvec.S's sepc instruction.
	w_sepc(sepc);
	w_sstatus(sstatus);
}

void clockintr() {
    80001940:	1141                	addi	sp,sp,-16
    80001942:	e406                	sd	ra,8(sp)
    80001944:	e022                	sd	s0,0(sp)
    80001946:	0800                	addi	s0,sp,16
	if (cpuid() == 0) {
    80001948:	c00ff0ef          	jal	80000d48 <cpuid>
    8000194c:	cd11                	beqz	a0,80001968 <clockintr+0x28>
	asm volatile("csrr %0, time" : "=r"(x));
    8000194e:	c01027f3          	rdtime	a5
	}

	// ask for the next timer interrupt. this also clears
	// the interrupt request. 1000000 is about a tenth
	// of a second.
	w_stimecmp(r_time() + 1000000);
    80001952:	000f4737          	lui	a4,0xf4
    80001956:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    8000195a:	97ba                	add	a5,a5,a4
	asm volatile("csrw 0x14d, %0" : : "r"(x));
    8000195c:	14d79073          	csrw	stimecmp,a5
}
    80001960:	60a2                	ld	ra,8(sp)
    80001962:	6402                	ld	s0,0(sp)
    80001964:	0141                	addi	sp,sp,16
    80001966:	8082                	ret
		acquire(&tickslock);
    80001968:	00011517          	auipc	a0,0x11
    8000196c:	d7850513          	addi	a0,a0,-648 # 800126e0 <tickslock>
    80001970:	090040ef          	jal	80005a00 <acquire>
		ticks++;
    80001974:	00006717          	auipc	a4,0x6
    80001978:	f0470713          	addi	a4,a4,-252 # 80007878 <ticks>
    8000197c:	431c                	lw	a5,0(a4)
    8000197e:	2785                	addiw	a5,a5,1
    80001980:	c31c                	sw	a5,0(a4)
		wakeup(&ticks);
    80001982:	853a                	mv	a0,a4
    80001984:	a53ff0ef          	jal	800013d6 <wakeup>
		release(&tickslock);
    80001988:	00011517          	auipc	a0,0x11
    8000198c:	d5850513          	addi	a0,a0,-680 # 800126e0 <tickslock>
    80001990:	104040ef          	jal	80005a94 <release>
    80001994:	bf6d                	j	8000194e <clockintr+0xe>

0000000080001996 <devintr>:
// check if it's an external interrupt or software interrupt,
// and handle it.
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int devintr() {
    80001996:	1101                	addi	sp,sp,-32
    80001998:	ec06                	sd	ra,24(sp)
    8000199a:	e822                	sd	s0,16(sp)
    8000199c:	1000                	addi	s0,sp,32
	asm volatile("csrr %0, scause" : "=r"(x));
    8000199e:	14202773          	csrr	a4,scause
	uint64 scause = r_scause();

	if (scause == 0x8000000000000009L) {
    800019a2:	57fd                	li	a5,-1
    800019a4:	17fe                	slli	a5,a5,0x3f
    800019a6:	07a5                	addi	a5,a5,9
    800019a8:	00f70c63          	beq	a4,a5,800019c0 <devintr+0x2a>
		// now allowed to interrupt again.
		if (irq)
			plic_complete(irq);

		return 1;
	} else if (scause == 0x8000000000000005L) {
    800019ac:	57fd                	li	a5,-1
    800019ae:	17fe                	slli	a5,a5,0x3f
    800019b0:	0795                	addi	a5,a5,5
		// timer interrupt.
		clockintr();
		return 2;
	} else {
		return 0;
    800019b2:	4501                	li	a0,0
	} else if (scause == 0x8000000000000005L) {
    800019b4:	04f70863          	beq	a4,a5,80001a04 <devintr+0x6e>
	}
}
    800019b8:	60e2                	ld	ra,24(sp)
    800019ba:	6442                	ld	s0,16(sp)
    800019bc:	6105                	addi	sp,sp,32
    800019be:	8082                	ret
    800019c0:	e426                	sd	s1,8(sp)
		int irq = plic_claim();
    800019c2:	7db020ef          	jal	8000499c <plic_claim>
    800019c6:	872a                	mv	a4,a0
    800019c8:	84aa                	mv	s1,a0
		if (irq == UART0_IRQ) {
    800019ca:	47a9                	li	a5,10
    800019cc:	00f50963          	beq	a0,a5,800019de <devintr+0x48>
		} else if (irq == VIRTIO0_IRQ) {
    800019d0:	4785                	li	a5,1
    800019d2:	00f50963          	beq	a0,a5,800019e4 <devintr+0x4e>
		return 1;
    800019d6:	4505                	li	a0,1
		} else if (irq) {
    800019d8:	eb09                	bnez	a4,800019ea <devintr+0x54>
    800019da:	64a2                	ld	s1,8(sp)
    800019dc:	bff1                	j	800019b8 <devintr+0x22>
			uartintr();
    800019de:	731030ef          	jal	8000590e <uartintr>
		if (irq)
    800019e2:	a819                	j	800019f8 <devintr+0x62>
			virtio_disk_intr();
    800019e4:	44e030ef          	jal	80004e32 <virtio_disk_intr>
		if (irq)
    800019e8:	a801                	j	800019f8 <devintr+0x62>
			printf("unexpected interrupt irq=%d\n", irq);
    800019ea:	85ba                	mv	a1,a4
    800019ec:	00006517          	auipc	a0,0x6
    800019f0:	80450513          	addi	a0,a0,-2044 # 800071f0 <etext+0x1f0>
    800019f4:	1c9030ef          	jal	800053bc <printf>
			plic_complete(irq);
    800019f8:	8526                	mv	a0,s1
    800019fa:	7c3020ef          	jal	800049bc <plic_complete>
		return 1;
    800019fe:	4505                	li	a0,1
    80001a00:	64a2                	ld	s1,8(sp)
    80001a02:	bf5d                	j	800019b8 <devintr+0x22>
		clockintr();
    80001a04:	f3dff0ef          	jal	80001940 <clockintr>
		return 2;
    80001a08:	4509                	li	a0,2
    80001a0a:	b77d                	j	800019b8 <devintr+0x22>

0000000080001a0c <usertrap>:
usertrap(void) {
    80001a0c:	1101                	addi	sp,sp,-32
    80001a0e:	ec06                	sd	ra,24(sp)
    80001a10:	e822                	sd	s0,16(sp)
    80001a12:	e426                	sd	s1,8(sp)
    80001a14:	e04a                	sd	s2,0(sp)
    80001a16:	1000                	addi	s0,sp,32
	asm volatile("csrr %0, sstatus" : "=r"(x));
    80001a18:	100027f3          	csrr	a5,sstatus
	if ((r_sstatus() & SSTATUS_SPP) != 0)
    80001a1c:	1007f793          	andi	a5,a5,256
    80001a20:	eba5                	bnez	a5,80001a90 <usertrap+0x84>
	asm volatile("csrw stvec, %0" : : "r"(x));
    80001a22:	00003797          	auipc	a5,0x3
    80001a26:	ece78793          	addi	a5,a5,-306 # 800048f0 <kernelvec>
    80001a2a:	10579073          	csrw	stvec,a5
	struct proc* p = myproc();
    80001a2e:	b4eff0ef          	jal	80000d7c <myproc>
    80001a32:	84aa                	mv	s1,a0
	p->trapframe->epc = r_sepc();
    80001a34:	6d3c                	ld	a5,88(a0)
	asm volatile("csrr %0, sepc" : "=r"(x));
    80001a36:	14102773          	csrr	a4,sepc
    80001a3a:	ef98                	sd	a4,24(a5)
	asm volatile("csrr %0, scause" : "=r"(x));
    80001a3c:	14202773          	csrr	a4,scause
	if (r_scause() == 8) {
    80001a40:	47a1                	li	a5,8
    80001a42:	04f70d63          	beq	a4,a5,80001a9c <usertrap+0x90>
	} else if ((which_dev = devintr()) != 0) {
    80001a46:	f51ff0ef          	jal	80001996 <devintr>
    80001a4a:	892a                	mv	s2,a0
    80001a4c:	e945                	bnez	a0,80001afc <usertrap+0xf0>
    80001a4e:	14202773          	csrr	a4,scause
	} else if ((r_scause() == 15 || r_scause() == 13) &&
    80001a52:	47bd                	li	a5,15
    80001a54:	08f70863          	beq	a4,a5,80001ae4 <usertrap+0xd8>
    80001a58:	14202773          	csrr	a4,scause
    80001a5c:	47b5                	li	a5,13
    80001a5e:	08f70363          	beq	a4,a5,80001ae4 <usertrap+0xd8>
    80001a62:	142025f3          	csrr	a1,scause
		printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80001a66:	5890                	lw	a2,48(s1)
    80001a68:	00005517          	auipc	a0,0x5
    80001a6c:	7c850513          	addi	a0,a0,1992 # 80007230 <etext+0x230>
    80001a70:	14d030ef          	jal	800053bc <printf>
	asm volatile("csrr %0, sepc" : "=r"(x));
    80001a74:	141025f3          	csrr	a1,sepc
	asm volatile("csrr %0, stval" : "=r"(x));
    80001a78:	14302673          	csrr	a2,stval
		printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80001a7c:	00005517          	auipc	a0,0x5
    80001a80:	7e450513          	addi	a0,a0,2020 # 80007260 <etext+0x260>
    80001a84:	139030ef          	jal	800053bc <printf>
		setkilled(p);
    80001a88:	8526                	mv	a0,s1
    80001a8a:	b19ff0ef          	jal	800015a2 <setkilled>
    80001a8e:	a035                	j	80001aba <usertrap+0xae>
		panic("usertrap: not from user mode");
    80001a90:	00005517          	auipc	a0,0x5
    80001a94:	78050513          	addi	a0,a0,1920 # 80007210 <etext+0x210>
    80001a98:	4c7030ef          	jal	8000575e <panic>
		if (killed(p))
    80001a9c:	b2bff0ef          	jal	800015c6 <killed>
    80001aa0:	ed15                	bnez	a0,80001adc <usertrap+0xd0>
		p->trapframe->epc += 4;
    80001aa2:	6cb8                	ld	a4,88(s1)
    80001aa4:	6f1c                	ld	a5,24(a4)
    80001aa6:	0791                	addi	a5,a5,4
    80001aa8:	ef1c                	sd	a5,24(a4)
	asm volatile("csrr %0, sstatus" : "=r"(x));
    80001aaa:	100027f3          	csrr	a5,sstatus
	w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001aae:	0027e793          	ori	a5,a5,2
	asm volatile("csrw sstatus, %0" : : "r"(x));
    80001ab2:	10079073          	csrw	sstatus,a5
		syscall();
    80001ab6:	27c000ef          	jal	80001d32 <syscall>
	if (killed(p))
    80001aba:	8526                	mv	a0,s1
    80001abc:	b0bff0ef          	jal	800015c6 <killed>
    80001ac0:	e139                	bnez	a0,80001b06 <usertrap+0xfa>
	prepare_return();
    80001ac2:	e05ff0ef          	jal	800018c6 <prepare_return>
	uint64 satp = MAKE_SATP(p->pagetable);
    80001ac6:	68a8                	ld	a0,80(s1)
    80001ac8:	8131                	srli	a0,a0,0xc
    80001aca:	57fd                	li	a5,-1
    80001acc:	17fe                	slli	a5,a5,0x3f
    80001ace:	8d5d                	or	a0,a0,a5
}
    80001ad0:	60e2                	ld	ra,24(sp)
    80001ad2:	6442                	ld	s0,16(sp)
    80001ad4:	64a2                	ld	s1,8(sp)
    80001ad6:	6902                	ld	s2,0(sp)
    80001ad8:	6105                	addi	sp,sp,32
    80001ada:	8082                	ret
			kexit(-1);
    80001adc:	557d                	li	a0,-1
    80001ade:	9b9ff0ef          	jal	80001496 <kexit>
    80001ae2:	b7c1                	j	80001aa2 <usertrap+0x96>
	asm volatile("csrr %0, stval" : "=r"(x));
    80001ae4:	143025f3          	csrr	a1,stval
	asm volatile("csrr %0, scause" : "=r"(x));
    80001ae8:	14202673          	csrr	a2,scause
	           vmfault(p->pagetable, r_stval(), (r_scause() == 13) ? 1 : 0) != 0) {
    80001aec:	164d                	addi	a2,a2,-13 # ff3 <_entry-0x7ffff00d>
    80001aee:	00163613          	seqz	a2,a2
    80001af2:	68a8                	ld	a0,80(s1)
    80001af4:	f43fe0ef          	jal	80000a36 <vmfault>
	} else if ((r_scause() == 15 || r_scause() == 13) &&
    80001af8:	f169                	bnez	a0,80001aba <usertrap+0xae>
    80001afa:	b7a5                	j	80001a62 <usertrap+0x56>
	if (killed(p))
    80001afc:	8526                	mv	a0,s1
    80001afe:	ac9ff0ef          	jal	800015c6 <killed>
    80001b02:	c511                	beqz	a0,80001b0e <usertrap+0x102>
    80001b04:	a011                	j	80001b08 <usertrap+0xfc>
    80001b06:	4901                	li	s2,0
		kexit(-1);
    80001b08:	557d                	li	a0,-1
    80001b0a:	98dff0ef          	jal	80001496 <kexit>
	if (which_dev == 2) {
    80001b0e:	4789                	li	a5,2
    80001b10:	faf919e3          	bne	s2,a5,80001ac2 <usertrap+0xb6>
    p->lasttick++;
    80001b14:	1684b783          	ld	a5,360(s1)
    80001b18:	0785                	addi	a5,a5,1
    80001b1a:	16f4b423          	sd	a5,360(s1)
		if (p->interval != 0 && p->lasttick >= p->interval && !p->alarming) {
    80001b1e:	1704b703          	ld	a4,368(s1)
    80001b22:	177d                	addi	a4,a4,-1
    80001b24:	00f76563          	bltu	a4,a5,80001b2e <usertrap+0x122>
		yield();
    80001b28:	837ff0ef          	jal	8000135e <yield>
    80001b2c:	bf59                	j	80001ac2 <usertrap+0xb6>
		if (p->interval != 0 && p->lasttick >= p->interval && !p->alarming) {
    80001b2e:	1804a783          	lw	a5,384(s1)
    80001b32:	fbfd                	bnez	a5,80001b28 <usertrap+0x11c>
			p->lasttick = 0;
    80001b34:	1604b423          	sd	zero,360(s1)
			memmove(&p->at_trapframe,
    80001b38:	12000613          	li	a2,288
    80001b3c:	6cac                	ld	a1,88(s1)
    80001b3e:	18848513          	addi	a0,s1,392
    80001b42:	e7cfe0ef          	jal	800001be <memmove>
			p->trapframe->epc = (uint64)p->handler;
    80001b46:	6cbc                	ld	a5,88(s1)
    80001b48:	1784b703          	ld	a4,376(s1)
    80001b4c:	ef98                	sd	a4,24(a5)
      p->alarming = 1;
    80001b4e:	4785                	li	a5,1
    80001b50:	18f4a023          	sw	a5,384(s1)
    80001b54:	bfd1                	j	80001b28 <usertrap+0x11c>

0000000080001b56 <kerneltrap>:
void kerneltrap() {
    80001b56:	7179                	addi	sp,sp,-48
    80001b58:	f406                	sd	ra,40(sp)
    80001b5a:	f022                	sd	s0,32(sp)
    80001b5c:	ec26                	sd	s1,24(sp)
    80001b5e:	e84a                	sd	s2,16(sp)
    80001b60:	e44e                	sd	s3,8(sp)
    80001b62:	1800                	addi	s0,sp,48
	asm volatile("csrr %0, sepc" : "=r"(x));
    80001b64:	14102973          	csrr	s2,sepc
	asm volatile("csrr %0, sstatus" : "=r"(x));
    80001b68:	100024f3          	csrr	s1,sstatus
	asm volatile("csrr %0, scause" : "=r"(x));
    80001b6c:	142027f3          	csrr	a5,scause
    80001b70:	89be                	mv	s3,a5
	if ((sstatus & SSTATUS_SPP) == 0)
    80001b72:	1004f793          	andi	a5,s1,256
    80001b76:	c795                	beqz	a5,80001ba2 <kerneltrap+0x4c>
	asm volatile("csrr %0, sstatus" : "=r"(x));
    80001b78:	100027f3          	csrr	a5,sstatus
	return (x & SSTATUS_SIE) != 0;
    80001b7c:	8b89                	andi	a5,a5,2
	if (intr_get() != 0)
    80001b7e:	eb85                	bnez	a5,80001bae <kerneltrap+0x58>
	if ((which_dev = devintr()) == 0) {
    80001b80:	e17ff0ef          	jal	80001996 <devintr>
    80001b84:	c91d                	beqz	a0,80001bba <kerneltrap+0x64>
	if (which_dev == 2 && myproc() != 0)
    80001b86:	4789                	li	a5,2
    80001b88:	04f50a63          	beq	a0,a5,80001bdc <kerneltrap+0x86>
	asm volatile("csrw sepc, %0" : : "r"(x));
    80001b8c:	14191073          	csrw	sepc,s2
	asm volatile("csrw sstatus, %0" : : "r"(x));
    80001b90:	10049073          	csrw	sstatus,s1
}
    80001b94:	70a2                	ld	ra,40(sp)
    80001b96:	7402                	ld	s0,32(sp)
    80001b98:	64e2                	ld	s1,24(sp)
    80001b9a:	6942                	ld	s2,16(sp)
    80001b9c:	69a2                	ld	s3,8(sp)
    80001b9e:	6145                	addi	sp,sp,48
    80001ba0:	8082                	ret
		panic("kerneltrap: not from supervisor mode");
    80001ba2:	00005517          	auipc	a0,0x5
    80001ba6:	6e650513          	addi	a0,a0,1766 # 80007288 <etext+0x288>
    80001baa:	3b5030ef          	jal	8000575e <panic>
		panic("kerneltrap: interrupts enabled");
    80001bae:	00005517          	auipc	a0,0x5
    80001bb2:	70250513          	addi	a0,a0,1794 # 800072b0 <etext+0x2b0>
    80001bb6:	3a9030ef          	jal	8000575e <panic>
	asm volatile("csrr %0, sepc" : "=r"(x));
    80001bba:	14102673          	csrr	a2,sepc
	asm volatile("csrr %0, stval" : "=r"(x));
    80001bbe:	143026f3          	csrr	a3,stval
		printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80001bc2:	85ce                	mv	a1,s3
    80001bc4:	00005517          	auipc	a0,0x5
    80001bc8:	70c50513          	addi	a0,a0,1804 # 800072d0 <etext+0x2d0>
    80001bcc:	7f0030ef          	jal	800053bc <printf>
		panic("kerneltrap");
    80001bd0:	00005517          	auipc	a0,0x5
    80001bd4:	72850513          	addi	a0,a0,1832 # 800072f8 <etext+0x2f8>
    80001bd8:	387030ef          	jal	8000575e <panic>
	if (which_dev == 2 && myproc() != 0)
    80001bdc:	9a0ff0ef          	jal	80000d7c <myproc>
    80001be0:	d555                	beqz	a0,80001b8c <kerneltrap+0x36>
		yield();
    80001be2:	f7cff0ef          	jal	8000135e <yield>
    80001be6:	b75d                	j	80001b8c <kerneltrap+0x36>

0000000080001be8 <argraw>:
		return -1;
	return strlen(buf);
}

static uint64
argraw(int n) {
    80001be8:	1101                	addi	sp,sp,-32
    80001bea:	ec06                	sd	ra,24(sp)
    80001bec:	e822                	sd	s0,16(sp)
    80001bee:	e426                	sd	s1,8(sp)
    80001bf0:	1000                	addi	s0,sp,32
    80001bf2:	84aa                	mv	s1,a0
	struct proc* p = myproc();
    80001bf4:	988ff0ef          	jal	80000d7c <myproc>
	switch (n) {
    80001bf8:	4795                	li	a5,5
    80001bfa:	0497e163          	bltu	a5,s1,80001c3c <argraw+0x54>
    80001bfe:	048a                	slli	s1,s1,0x2
    80001c00:	00006717          	auipc	a4,0x6
    80001c04:	b5870713          	addi	a4,a4,-1192 # 80007758 <states.0+0x30>
    80001c08:	94ba                	add	s1,s1,a4
    80001c0a:	409c                	lw	a5,0(s1)
    80001c0c:	97ba                	add	a5,a5,a4
    80001c0e:	8782                	jr	a5
	case 0:
		return p->trapframe->a0;
    80001c10:	6d3c                	ld	a5,88(a0)
    80001c12:	7ba8                	ld	a0,112(a5)
	case 5:
		return p->trapframe->a5;
	}
	panic("argraw");
	return -1;
}
    80001c14:	60e2                	ld	ra,24(sp)
    80001c16:	6442                	ld	s0,16(sp)
    80001c18:	64a2                	ld	s1,8(sp)
    80001c1a:	6105                	addi	sp,sp,32
    80001c1c:	8082                	ret
		return p->trapframe->a1;
    80001c1e:	6d3c                	ld	a5,88(a0)
    80001c20:	7fa8                	ld	a0,120(a5)
    80001c22:	bfcd                	j	80001c14 <argraw+0x2c>
		return p->trapframe->a2;
    80001c24:	6d3c                	ld	a5,88(a0)
    80001c26:	63c8                	ld	a0,128(a5)
    80001c28:	b7f5                	j	80001c14 <argraw+0x2c>
		return p->trapframe->a3;
    80001c2a:	6d3c                	ld	a5,88(a0)
    80001c2c:	67c8                	ld	a0,136(a5)
    80001c2e:	b7dd                	j	80001c14 <argraw+0x2c>
		return p->trapframe->a4;
    80001c30:	6d3c                	ld	a5,88(a0)
    80001c32:	6bc8                	ld	a0,144(a5)
    80001c34:	b7c5                	j	80001c14 <argraw+0x2c>
		return p->trapframe->a5;
    80001c36:	6d3c                	ld	a5,88(a0)
    80001c38:	6fc8                	ld	a0,152(a5)
    80001c3a:	bfe9                	j	80001c14 <argraw+0x2c>
	panic("argraw");
    80001c3c:	00005517          	auipc	a0,0x5
    80001c40:	6cc50513          	addi	a0,a0,1740 # 80007308 <etext+0x308>
    80001c44:	31b030ef          	jal	8000575e <panic>

0000000080001c48 <fetchaddr>:
int fetchaddr(uint64 addr, uint64* ip) {
    80001c48:	1101                	addi	sp,sp,-32
    80001c4a:	ec06                	sd	ra,24(sp)
    80001c4c:	e822                	sd	s0,16(sp)
    80001c4e:	e426                	sd	s1,8(sp)
    80001c50:	e04a                	sd	s2,0(sp)
    80001c52:	1000                	addi	s0,sp,32
    80001c54:	84aa                	mv	s1,a0
    80001c56:	892e                	mv	s2,a1
	struct proc* p = myproc();
    80001c58:	924ff0ef          	jal	80000d7c <myproc>
	if (addr >= p->sz || addr + sizeof(uint64) > p->sz)  // both tests needed, in case of overflow
    80001c5c:	653c                	ld	a5,72(a0)
    80001c5e:	02f4f663          	bgeu	s1,a5,80001c8a <fetchaddr+0x42>
    80001c62:	00848713          	addi	a4,s1,8
    80001c66:	02e7e463          	bltu	a5,a4,80001c8e <fetchaddr+0x46>
	if (copyin(p->pagetable, (char*)ip, addr, sizeof(*ip)) != 0)
    80001c6a:	46a1                	li	a3,8
    80001c6c:	8626                	mv	a2,s1
    80001c6e:	85ca                	mv	a1,s2
    80001c70:	6928                	ld	a0,80(a0)
    80001c72:	f07fe0ef          	jal	80000b78 <copyin>
    80001c76:	00a03533          	snez	a0,a0
    80001c7a:	40a0053b          	negw	a0,a0
}
    80001c7e:	60e2                	ld	ra,24(sp)
    80001c80:	6442                	ld	s0,16(sp)
    80001c82:	64a2                	ld	s1,8(sp)
    80001c84:	6902                	ld	s2,0(sp)
    80001c86:	6105                	addi	sp,sp,32
    80001c88:	8082                	ret
		return -1;
    80001c8a:	557d                	li	a0,-1
    80001c8c:	bfcd                	j	80001c7e <fetchaddr+0x36>
    80001c8e:	557d                	li	a0,-1
    80001c90:	b7fd                	j	80001c7e <fetchaddr+0x36>

0000000080001c92 <fetchstr>:
int fetchstr(uint64 addr, char* buf, int max) {
    80001c92:	7179                	addi	sp,sp,-48
    80001c94:	f406                	sd	ra,40(sp)
    80001c96:	f022                	sd	s0,32(sp)
    80001c98:	ec26                	sd	s1,24(sp)
    80001c9a:	e84a                	sd	s2,16(sp)
    80001c9c:	e44e                	sd	s3,8(sp)
    80001c9e:	1800                	addi	s0,sp,48
    80001ca0:	89aa                	mv	s3,a0
    80001ca2:	84ae                	mv	s1,a1
    80001ca4:	8932                	mv	s2,a2
	struct proc* p = myproc();
    80001ca6:	8d6ff0ef          	jal	80000d7c <myproc>
	if (copyinstr(p->pagetable, buf, addr, max) < 0)
    80001caa:	86ca                	mv	a3,s2
    80001cac:	864e                	mv	a2,s3
    80001cae:	85a6                	mv	a1,s1
    80001cb0:	6928                	ld	a0,80(a0)
    80001cb2:	cadfe0ef          	jal	8000095e <copyinstr>
    80001cb6:	00054c63          	bltz	a0,80001cce <fetchstr+0x3c>
	return strlen(buf);
    80001cba:	8526                	mv	a0,s1
    80001cbc:	e2cfe0ef          	jal	800002e8 <strlen>
}
    80001cc0:	70a2                	ld	ra,40(sp)
    80001cc2:	7402                	ld	s0,32(sp)
    80001cc4:	64e2                	ld	s1,24(sp)
    80001cc6:	6942                	ld	s2,16(sp)
    80001cc8:	69a2                	ld	s3,8(sp)
    80001cca:	6145                	addi	sp,sp,48
    80001ccc:	8082                	ret
		return -1;
    80001cce:	557d                	li	a0,-1
    80001cd0:	bfc5                	j	80001cc0 <fetchstr+0x2e>

0000000080001cd2 <argint>:

// Fetch the nth 32-bit system call argument.
void argint(int n, int* ip) {
    80001cd2:	1101                	addi	sp,sp,-32
    80001cd4:	ec06                	sd	ra,24(sp)
    80001cd6:	e822                	sd	s0,16(sp)
    80001cd8:	e426                	sd	s1,8(sp)
    80001cda:	1000                	addi	s0,sp,32
    80001cdc:	84ae                	mv	s1,a1
	*ip = argraw(n);
    80001cde:	f0bff0ef          	jal	80001be8 <argraw>
    80001ce2:	c088                	sw	a0,0(s1)
}
    80001ce4:	60e2                	ld	ra,24(sp)
    80001ce6:	6442                	ld	s0,16(sp)
    80001ce8:	64a2                	ld	s1,8(sp)
    80001cea:	6105                	addi	sp,sp,32
    80001cec:	8082                	ret

0000000080001cee <argaddr>:

// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void argaddr(int n, uint64* ip) {
    80001cee:	1101                	addi	sp,sp,-32
    80001cf0:	ec06                	sd	ra,24(sp)
    80001cf2:	e822                	sd	s0,16(sp)
    80001cf4:	e426                	sd	s1,8(sp)
    80001cf6:	1000                	addi	s0,sp,32
    80001cf8:	84ae                	mv	s1,a1
	*ip = argraw(n);
    80001cfa:	eefff0ef          	jal	80001be8 <argraw>
    80001cfe:	e088                	sd	a0,0(s1)
}
    80001d00:	60e2                	ld	ra,24(sp)
    80001d02:	6442                	ld	s0,16(sp)
    80001d04:	64a2                	ld	s1,8(sp)
    80001d06:	6105                	addi	sp,sp,32
    80001d08:	8082                	ret

0000000080001d0a <argstr>:

// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int argstr(int n, char* buf, int max) {
    80001d0a:	1101                	addi	sp,sp,-32
    80001d0c:	ec06                	sd	ra,24(sp)
    80001d0e:	e822                	sd	s0,16(sp)
    80001d10:	e426                	sd	s1,8(sp)
    80001d12:	e04a                	sd	s2,0(sp)
    80001d14:	1000                	addi	s0,sp,32
    80001d16:	892e                	mv	s2,a1
    80001d18:	84b2                	mv	s1,a2
	*ip = argraw(n);
    80001d1a:	ecfff0ef          	jal	80001be8 <argraw>
	uint64 addr;
	argaddr(n, &addr);
	return fetchstr(addr, buf, max);
    80001d1e:	8626                	mv	a2,s1
    80001d20:	85ca                	mv	a1,s2
    80001d22:	f71ff0ef          	jal	80001c92 <fetchstr>
}
    80001d26:	60e2                	ld	ra,24(sp)
    80001d28:	6442                	ld	s0,16(sp)
    80001d2a:	64a2                	ld	s1,8(sp)
    80001d2c:	6902                	ld	s2,0(sp)
    80001d2e:	6105                	addi	sp,sp,32
    80001d30:	8082                	ret

0000000080001d32 <syscall>:
    [SYS_close] sys_close,
    [SYS_sigalarm] sys_sigalarm,
    [SYS_sigreturn] sys_sigreturn,
};

void syscall(void) {
    80001d32:	1101                	addi	sp,sp,-32
    80001d34:	ec06                	sd	ra,24(sp)
    80001d36:	e822                	sd	s0,16(sp)
    80001d38:	e426                	sd	s1,8(sp)
    80001d3a:	e04a                	sd	s2,0(sp)
    80001d3c:	1000                	addi	s0,sp,32
	int num;
	struct proc* p = myproc();
    80001d3e:	83eff0ef          	jal	80000d7c <myproc>
    80001d42:	84aa                	mv	s1,a0

	num = p->trapframe->a7;
    80001d44:	05853903          	ld	s2,88(a0)
    80001d48:	0a893783          	ld	a5,168(s2)
    80001d4c:	0007869b          	sext.w	a3,a5
	if (num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001d50:	37fd                	addiw	a5,a5,-1
    80001d52:	4759                	li	a4,22
    80001d54:	00f76f63          	bltu	a4,a5,80001d72 <syscall+0x40>
    80001d58:	00369713          	slli	a4,a3,0x3
    80001d5c:	00006797          	auipc	a5,0x6
    80001d60:	a1478793          	addi	a5,a5,-1516 # 80007770 <syscalls>
    80001d64:	97ba                	add	a5,a5,a4
    80001d66:	639c                	ld	a5,0(a5)
    80001d68:	c789                	beqz	a5,80001d72 <syscall+0x40>
		// Use num to lookup the system call function for num, call it,
		// and store its return value in p->trapframe->a0
		p->trapframe->a0 = syscalls[num]();
    80001d6a:	9782                	jalr	a5
    80001d6c:	06a93823          	sd	a0,112(s2)
    80001d70:	a829                	j	80001d8a <syscall+0x58>
	} else {
		printf("%d %s: unknown sys call %d\n",
    80001d72:	15848613          	addi	a2,s1,344
    80001d76:	588c                	lw	a1,48(s1)
    80001d78:	00005517          	auipc	a0,0x5
    80001d7c:	59850513          	addi	a0,a0,1432 # 80007310 <etext+0x310>
    80001d80:	63c030ef          	jal	800053bc <printf>
		       p->pid, p->name, num);
		p->trapframe->a0 = -1;
    80001d84:	6cbc                	ld	a5,88(s1)
    80001d86:	577d                	li	a4,-1
    80001d88:	fbb8                	sd	a4,112(a5)
	}
}
    80001d8a:	60e2                	ld	ra,24(sp)
    80001d8c:	6442                	ld	s0,16(sp)
    80001d8e:	64a2                	ld	s1,8(sp)
    80001d90:	6902                	ld	s2,0(sp)
    80001d92:	6105                	addi	sp,sp,32
    80001d94:	8082                	ret

0000000080001d96 <sys_exit>:
#include "spinlock.h"
#include "proc.h"
#include "vm.h"

uint64
sys_exit(void) {
    80001d96:	1101                	addi	sp,sp,-32
    80001d98:	ec06                	sd	ra,24(sp)
    80001d9a:	e822                	sd	s0,16(sp)
    80001d9c:	1000                	addi	s0,sp,32
	int n;
	argint(0, &n);
    80001d9e:	fec40593          	addi	a1,s0,-20
    80001da2:	4501                	li	a0,0
    80001da4:	f2fff0ef          	jal	80001cd2 <argint>
	kexit(n);
    80001da8:	fec42503          	lw	a0,-20(s0)
    80001dac:	eeaff0ef          	jal	80001496 <kexit>
	return 0;  // not reached
}
    80001db0:	4501                	li	a0,0
    80001db2:	60e2                	ld	ra,24(sp)
    80001db4:	6442                	ld	s0,16(sp)
    80001db6:	6105                	addi	sp,sp,32
    80001db8:	8082                	ret

0000000080001dba <sys_getpid>:

uint64
sys_getpid(void) {
    80001dba:	1141                	addi	sp,sp,-16
    80001dbc:	e406                	sd	ra,8(sp)
    80001dbe:	e022                	sd	s0,0(sp)
    80001dc0:	0800                	addi	s0,sp,16
	return myproc()->pid;
    80001dc2:	fbbfe0ef          	jal	80000d7c <myproc>
}
    80001dc6:	5908                	lw	a0,48(a0)
    80001dc8:	60a2                	ld	ra,8(sp)
    80001dca:	6402                	ld	s0,0(sp)
    80001dcc:	0141                	addi	sp,sp,16
    80001dce:	8082                	ret

0000000080001dd0 <sys_fork>:

uint64
sys_fork(void) {
    80001dd0:	1141                	addi	sp,sp,-16
    80001dd2:	e406                	sd	ra,8(sp)
    80001dd4:	e022                	sd	s0,0(sp)
    80001dd6:	0800                	addi	s0,sp,16
	return kfork();
    80001dd8:	b0aff0ef          	jal	800010e2 <kfork>
}
    80001ddc:	60a2                	ld	ra,8(sp)
    80001dde:	6402                	ld	s0,0(sp)
    80001de0:	0141                	addi	sp,sp,16
    80001de2:	8082                	ret

0000000080001de4 <sys_wait>:

uint64
sys_wait(void) {
    80001de4:	1101                	addi	sp,sp,-32
    80001de6:	ec06                	sd	ra,24(sp)
    80001de8:	e822                	sd	s0,16(sp)
    80001dea:	1000                	addi	s0,sp,32
	uint64 p;
	argaddr(0, &p);
    80001dec:	fe840593          	addi	a1,s0,-24
    80001df0:	4501                	li	a0,0
    80001df2:	efdff0ef          	jal	80001cee <argaddr>
	return kwait(p);
    80001df6:	fe843503          	ld	a0,-24(s0)
    80001dfa:	ff6ff0ef          	jal	800015f0 <kwait>
}
    80001dfe:	60e2                	ld	ra,24(sp)
    80001e00:	6442                	ld	s0,16(sp)
    80001e02:	6105                	addi	sp,sp,32
    80001e04:	8082                	ret

0000000080001e06 <sys_sbrk>:

uint64
sys_sbrk(void) {
    80001e06:	7179                	addi	sp,sp,-48
    80001e08:	f406                	sd	ra,40(sp)
    80001e0a:	f022                	sd	s0,32(sp)
    80001e0c:	ec26                	sd	s1,24(sp)
    80001e0e:	1800                	addi	s0,sp,48
	uint64 addr;
	int t;
	int n;

	argint(0, &n);
    80001e10:	fd840593          	addi	a1,s0,-40
    80001e14:	4501                	li	a0,0
    80001e16:	ebdff0ef          	jal	80001cd2 <argint>
	argint(1, &t);
    80001e1a:	fdc40593          	addi	a1,s0,-36
    80001e1e:	4505                	li	a0,1
    80001e20:	eb3ff0ef          	jal	80001cd2 <argint>
	addr = myproc()->sz;
    80001e24:	f59fe0ef          	jal	80000d7c <myproc>
    80001e28:	6524                	ld	s1,72(a0)

	if (t == SBRK_EAGER || n < 0) {
    80001e2a:	fdc42703          	lw	a4,-36(s0)
    80001e2e:	4785                	li	a5,1
    80001e30:	02f70163          	beq	a4,a5,80001e52 <sys_sbrk+0x4c>
    80001e34:	fd842783          	lw	a5,-40(s0)
    80001e38:	0007cd63          	bltz	a5,80001e52 <sys_sbrk+0x4c>
		}
	} else {
		// Lazily allocate memory for this process: increase its memory
		// size but don't allocate memory. If the processes uses the
		// memory, vmfault() will allocate it.
		if (addr + n < addr)
    80001e3c:	97a6                	add	a5,a5,s1
    80001e3e:	0297e863          	bltu	a5,s1,80001e6e <sys_sbrk+0x68>
			return -1;
		myproc()->sz += n;
    80001e42:	f3bfe0ef          	jal	80000d7c <myproc>
    80001e46:	fd842703          	lw	a4,-40(s0)
    80001e4a:	653c                	ld	a5,72(a0)
    80001e4c:	97ba                	add	a5,a5,a4
    80001e4e:	e53c                	sd	a5,72(a0)
    80001e50:	a039                	j	80001e5e <sys_sbrk+0x58>
		if (growproc(n) < 0) {
    80001e52:	fd842503          	lw	a0,-40(s0)
    80001e56:	a3cff0ef          	jal	80001092 <growproc>
    80001e5a:	00054863          	bltz	a0,80001e6a <sys_sbrk+0x64>
	}
	return addr;
}
    80001e5e:	8526                	mv	a0,s1
    80001e60:	70a2                	ld	ra,40(sp)
    80001e62:	7402                	ld	s0,32(sp)
    80001e64:	64e2                	ld	s1,24(sp)
    80001e66:	6145                	addi	sp,sp,48
    80001e68:	8082                	ret
			return -1;
    80001e6a:	54fd                	li	s1,-1
    80001e6c:	bfcd                	j	80001e5e <sys_sbrk+0x58>
			return -1;
    80001e6e:	54fd                	li	s1,-1
    80001e70:	b7fd                	j	80001e5e <sys_sbrk+0x58>

0000000080001e72 <sys_pause>:

uint64
sys_pause(void) {
    80001e72:	7139                	addi	sp,sp,-64
    80001e74:	fc06                	sd	ra,56(sp)
    80001e76:	f822                	sd	s0,48(sp)
    80001e78:	0080                	addi	s0,sp,64
	int n;
	uint ticks0;

	argint(0, &n);
    80001e7a:	fcc40593          	addi	a1,s0,-52
    80001e7e:	4501                	li	a0,0
    80001e80:	e53ff0ef          	jal	80001cd2 <argint>
	if (n < 0)
    80001e84:	fcc42783          	lw	a5,-52(s0)
    80001e88:	0607ca63          	bltz	a5,80001efc <sys_pause+0x8a>
		n = 0;
	acquire(&tickslock);
    80001e8c:	00011517          	auipc	a0,0x11
    80001e90:	85450513          	addi	a0,a0,-1964 # 800126e0 <tickslock>
    80001e94:	36d030ef          	jal	80005a00 <acquire>
	ticks0 = ticks;
	while (ticks - ticks0 < n) {
    80001e98:	fcc42783          	lw	a5,-52(s0)
    80001e9c:	c3b9                	beqz	a5,80001ee2 <sys_pause+0x70>
    80001e9e:	f426                	sd	s1,40(sp)
    80001ea0:	f04a                	sd	s2,32(sp)
    80001ea2:	ec4e                	sd	s3,24(sp)
	ticks0 = ticks;
    80001ea4:	00006997          	auipc	s3,0x6
    80001ea8:	9d49a983          	lw	s3,-1580(s3) # 80007878 <ticks>
		if (killed(myproc())) {
			release(&tickslock);
			return -1;
		}
		sleep(&ticks, &tickslock);
    80001eac:	00011917          	auipc	s2,0x11
    80001eb0:	83490913          	addi	s2,s2,-1996 # 800126e0 <tickslock>
    80001eb4:	00006497          	auipc	s1,0x6
    80001eb8:	9c448493          	addi	s1,s1,-1596 # 80007878 <ticks>
		if (killed(myproc())) {
    80001ebc:	ec1fe0ef          	jal	80000d7c <myproc>
    80001ec0:	f06ff0ef          	jal	800015c6 <killed>
    80001ec4:	ed1d                	bnez	a0,80001f02 <sys_pause+0x90>
		sleep(&ticks, &tickslock);
    80001ec6:	85ca                	mv	a1,s2
    80001ec8:	8526                	mv	a0,s1
    80001eca:	cc0ff0ef          	jal	8000138a <sleep>
	while (ticks - ticks0 < n) {
    80001ece:	409c                	lw	a5,0(s1)
    80001ed0:	413787bb          	subw	a5,a5,s3
    80001ed4:	fcc42703          	lw	a4,-52(s0)
    80001ed8:	fee7e2e3          	bltu	a5,a4,80001ebc <sys_pause+0x4a>
    80001edc:	74a2                	ld	s1,40(sp)
    80001ede:	7902                	ld	s2,32(sp)
    80001ee0:	69e2                	ld	s3,24(sp)
	}
	release(&tickslock);
    80001ee2:	00010517          	auipc	a0,0x10
    80001ee6:	7fe50513          	addi	a0,a0,2046 # 800126e0 <tickslock>
    80001eea:	3ab030ef          	jal	80005a94 <release>
	backtrace();
    80001eee:	01d030ef          	jal	8000570a <backtrace>
	return 0;
    80001ef2:	4501                	li	a0,0
}
    80001ef4:	70e2                	ld	ra,56(sp)
    80001ef6:	7442                	ld	s0,48(sp)
    80001ef8:	6121                	addi	sp,sp,64
    80001efa:	8082                	ret
		n = 0;
    80001efc:	fc042623          	sw	zero,-52(s0)
    80001f00:	b771                	j	80001e8c <sys_pause+0x1a>
			release(&tickslock);
    80001f02:	00010517          	auipc	a0,0x10
    80001f06:	7de50513          	addi	a0,a0,2014 # 800126e0 <tickslock>
    80001f0a:	38b030ef          	jal	80005a94 <release>
			return -1;
    80001f0e:	557d                	li	a0,-1
    80001f10:	74a2                	ld	s1,40(sp)
    80001f12:	7902                	ld	s2,32(sp)
    80001f14:	69e2                	ld	s3,24(sp)
    80001f16:	bff9                	j	80001ef4 <sys_pause+0x82>

0000000080001f18 <sys_kill>:

uint64
sys_kill(void) {
    80001f18:	1101                	addi	sp,sp,-32
    80001f1a:	ec06                	sd	ra,24(sp)
    80001f1c:	e822                	sd	s0,16(sp)
    80001f1e:	1000                	addi	s0,sp,32
	int pid;

	argint(0, &pid);
    80001f20:	fec40593          	addi	a1,s0,-20
    80001f24:	4501                	li	a0,0
    80001f26:	dadff0ef          	jal	80001cd2 <argint>
	return kkill(pid);
    80001f2a:	fec42503          	lw	a0,-20(s0)
    80001f2e:	e0eff0ef          	jal	8000153c <kkill>
}
    80001f32:	60e2                	ld	ra,24(sp)
    80001f34:	6442                	ld	s0,16(sp)
    80001f36:	6105                	addi	sp,sp,32
    80001f38:	8082                	ret

0000000080001f3a <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void) {
    80001f3a:	1101                	addi	sp,sp,-32
    80001f3c:	ec06                	sd	ra,24(sp)
    80001f3e:	e822                	sd	s0,16(sp)
    80001f40:	e426                	sd	s1,8(sp)
    80001f42:	1000                	addi	s0,sp,32
	uint xticks;

	acquire(&tickslock);
    80001f44:	00010517          	auipc	a0,0x10
    80001f48:	79c50513          	addi	a0,a0,1948 # 800126e0 <tickslock>
    80001f4c:	2b5030ef          	jal	80005a00 <acquire>
	xticks = ticks;
    80001f50:	00006797          	auipc	a5,0x6
    80001f54:	9287a783          	lw	a5,-1752(a5) # 80007878 <ticks>
    80001f58:	84be                	mv	s1,a5
	release(&tickslock);
    80001f5a:	00010517          	auipc	a0,0x10
    80001f5e:	78650513          	addi	a0,a0,1926 # 800126e0 <tickslock>
    80001f62:	333030ef          	jal	80005a94 <release>
	return xticks;
}
    80001f66:	02049513          	slli	a0,s1,0x20
    80001f6a:	9101                	srli	a0,a0,0x20
    80001f6c:	60e2                	ld	ra,24(sp)
    80001f6e:	6442                	ld	s0,16(sp)
    80001f70:	64a2                	ld	s1,8(sp)
    80001f72:	6105                	addi	sp,sp,32
    80001f74:	8082                	ret

0000000080001f76 <sys_sigalarm>:

uint64 sys_sigalarm(void) {
    80001f76:	1101                	addi	sp,sp,-32
    80001f78:	ec06                	sd	ra,24(sp)
    80001f7a:	e822                	sd	s0,16(sp)
    80001f7c:	1000                	addi	s0,sp,32
	int m_ticks;
	uint64 hand;

	argint(0, &m_ticks);
    80001f7e:	fec40593          	addi	a1,s0,-20
    80001f82:	4501                	li	a0,0
    80001f84:	d4fff0ef          	jal	80001cd2 <argint>
	argaddr(1, &hand);
    80001f88:	fe040593          	addi	a1,s0,-32
    80001f8c:	4505                	li	a0,1
    80001f8e:	d61ff0ef          	jal	80001cee <argaddr>

	struct proc* p = myproc();
    80001f92:	debfe0ef          	jal	80000d7c <myproc>
	p->interval = m_ticks;
    80001f96:	fec42783          	lw	a5,-20(s0)
    80001f9a:	16f53823          	sd	a5,368(a0)
	p->handler = hand;
    80001f9e:	fe043783          	ld	a5,-32(s0)
    80001fa2:	16f53c23          	sd	a5,376(a0)

	return 0;
}
    80001fa6:	4501                	li	a0,0
    80001fa8:	60e2                	ld	ra,24(sp)
    80001faa:	6442                	ld	s0,16(sp)
    80001fac:	6105                	addi	sp,sp,32
    80001fae:	8082                	ret

0000000080001fb0 <sys_sigreturn>:

uint64 sys_sigreturn(void) {
    80001fb0:	1101                	addi	sp,sp,-32
    80001fb2:	ec06                	sd	ra,24(sp)
    80001fb4:	e822                	sd	s0,16(sp)
    80001fb6:	e426                	sd	s1,8(sp)
    80001fb8:	1000                	addi	s0,sp,32
	struct proc* p = myproc();
    80001fba:	dc3fe0ef          	jal	80000d7c <myproc>
    80001fbe:	84aa                	mv	s1,a0

	memmove(p->trapframe,
    80001fc0:	12000613          	li	a2,288
    80001fc4:	18850593          	addi	a1,a0,392
    80001fc8:	6d28                	ld	a0,88(a0)
    80001fca:	9f4fe0ef          	jal	800001be <memmove>
	        &p->at_trapframe,
	        sizeof(struct trapframe));

	p->alarming = 0;
    80001fce:	1804a023          	sw	zero,384(s1)

	return p->trapframe->a0;
    80001fd2:	6cbc                	ld	a5,88(s1)
    80001fd4:	7ba8                	ld	a0,112(a5)
    80001fd6:	60e2                	ld	ra,24(sp)
    80001fd8:	6442                	ld	s0,16(sp)
    80001fda:	64a2                	ld	s1,8(sp)
    80001fdc:	6105                	addi	sp,sp,32
    80001fde:	8082                	ret

0000000080001fe0 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80001fe0:	7179                	addi	sp,sp,-48
    80001fe2:	f406                	sd	ra,40(sp)
    80001fe4:	f022                	sd	s0,32(sp)
    80001fe6:	ec26                	sd	s1,24(sp)
    80001fe8:	e84a                	sd	s2,16(sp)
    80001fea:	e44e                	sd	s3,8(sp)
    80001fec:	e052                	sd	s4,0(sp)
    80001fee:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80001ff0:	00005597          	auipc	a1,0x5
    80001ff4:	34058593          	addi	a1,a1,832 # 80007330 <etext+0x330>
    80001ff8:	00010517          	auipc	a0,0x10
    80001ffc:	70050513          	addi	a0,a0,1792 # 800126f8 <bcache>
    80002000:	177030ef          	jal	80005976 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002004:	00018797          	auipc	a5,0x18
    80002008:	6f478793          	addi	a5,a5,1780 # 8001a6f8 <bcache+0x8000>
    8000200c:	00019717          	auipc	a4,0x19
    80002010:	95470713          	addi	a4,a4,-1708 # 8001a960 <bcache+0x8268>
    80002014:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002018:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000201c:	00010497          	auipc	s1,0x10
    80002020:	6f448493          	addi	s1,s1,1780 # 80012710 <bcache+0x18>
    b->next = bcache.head.next;
    80002024:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002026:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002028:	00005a17          	auipc	s4,0x5
    8000202c:	310a0a13          	addi	s4,s4,784 # 80007338 <etext+0x338>
    b->next = bcache.head.next;
    80002030:	2b893783          	ld	a5,696(s2)
    80002034:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002036:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000203a:	85d2                	mv	a1,s4
    8000203c:	01048513          	addi	a0,s1,16
    80002040:	328010ef          	jal	80003368 <initsleeplock>
    bcache.head.next->prev = b;
    80002044:	2b893783          	ld	a5,696(s2)
    80002048:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000204a:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000204e:	45848493          	addi	s1,s1,1112
    80002052:	fd349fe3          	bne	s1,s3,80002030 <binit+0x50>
  }
}
    80002056:	70a2                	ld	ra,40(sp)
    80002058:	7402                	ld	s0,32(sp)
    8000205a:	64e2                	ld	s1,24(sp)
    8000205c:	6942                	ld	s2,16(sp)
    8000205e:	69a2                	ld	s3,8(sp)
    80002060:	6a02                	ld	s4,0(sp)
    80002062:	6145                	addi	sp,sp,48
    80002064:	8082                	ret

0000000080002066 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002066:	7179                	addi	sp,sp,-48
    80002068:	f406                	sd	ra,40(sp)
    8000206a:	f022                	sd	s0,32(sp)
    8000206c:	ec26                	sd	s1,24(sp)
    8000206e:	e84a                	sd	s2,16(sp)
    80002070:	e44e                	sd	s3,8(sp)
    80002072:	1800                	addi	s0,sp,48
    80002074:	892a                	mv	s2,a0
    80002076:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002078:	00010517          	auipc	a0,0x10
    8000207c:	68050513          	addi	a0,a0,1664 # 800126f8 <bcache>
    80002080:	181030ef          	jal	80005a00 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002084:	00019497          	auipc	s1,0x19
    80002088:	92c4b483          	ld	s1,-1748(s1) # 8001a9b0 <bcache+0x82b8>
    8000208c:	00019797          	auipc	a5,0x19
    80002090:	8d478793          	addi	a5,a5,-1836 # 8001a960 <bcache+0x8268>
    80002094:	02f48b63          	beq	s1,a5,800020ca <bread+0x64>
    80002098:	873e                	mv	a4,a5
    8000209a:	a021                	j	800020a2 <bread+0x3c>
    8000209c:	68a4                	ld	s1,80(s1)
    8000209e:	02e48663          	beq	s1,a4,800020ca <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    800020a2:	449c                	lw	a5,8(s1)
    800020a4:	ff279ce3          	bne	a5,s2,8000209c <bread+0x36>
    800020a8:	44dc                	lw	a5,12(s1)
    800020aa:	ff3799e3          	bne	a5,s3,8000209c <bread+0x36>
      b->refcnt++;
    800020ae:	40bc                	lw	a5,64(s1)
    800020b0:	2785                	addiw	a5,a5,1
    800020b2:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800020b4:	00010517          	auipc	a0,0x10
    800020b8:	64450513          	addi	a0,a0,1604 # 800126f8 <bcache>
    800020bc:	1d9030ef          	jal	80005a94 <release>
      acquiresleep(&b->lock);
    800020c0:	01048513          	addi	a0,s1,16
    800020c4:	2da010ef          	jal	8000339e <acquiresleep>
      return b;
    800020c8:	a889                	j	8000211a <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800020ca:	00019497          	auipc	s1,0x19
    800020ce:	8de4b483          	ld	s1,-1826(s1) # 8001a9a8 <bcache+0x82b0>
    800020d2:	00019797          	auipc	a5,0x19
    800020d6:	88e78793          	addi	a5,a5,-1906 # 8001a960 <bcache+0x8268>
    800020da:	00f48863          	beq	s1,a5,800020ea <bread+0x84>
    800020de:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800020e0:	40bc                	lw	a5,64(s1)
    800020e2:	cb91                	beqz	a5,800020f6 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800020e4:	64a4                	ld	s1,72(s1)
    800020e6:	fee49de3          	bne	s1,a4,800020e0 <bread+0x7a>
  panic("bget: no buffers");
    800020ea:	00005517          	auipc	a0,0x5
    800020ee:	25650513          	addi	a0,a0,598 # 80007340 <etext+0x340>
    800020f2:	66c030ef          	jal	8000575e <panic>
      b->dev = dev;
    800020f6:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800020fa:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800020fe:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002102:	4785                	li	a5,1
    80002104:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002106:	00010517          	auipc	a0,0x10
    8000210a:	5f250513          	addi	a0,a0,1522 # 800126f8 <bcache>
    8000210e:	187030ef          	jal	80005a94 <release>
      acquiresleep(&b->lock);
    80002112:	01048513          	addi	a0,s1,16
    80002116:	288010ef          	jal	8000339e <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000211a:	409c                	lw	a5,0(s1)
    8000211c:	cb89                	beqz	a5,8000212e <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000211e:	8526                	mv	a0,s1
    80002120:	70a2                	ld	ra,40(sp)
    80002122:	7402                	ld	s0,32(sp)
    80002124:	64e2                	ld	s1,24(sp)
    80002126:	6942                	ld	s2,16(sp)
    80002128:	69a2                	ld	s3,8(sp)
    8000212a:	6145                	addi	sp,sp,48
    8000212c:	8082                	ret
    virtio_disk_rw(b, 0);
    8000212e:	4581                	li	a1,0
    80002130:	8526                	mv	a0,s1
    80002132:	2ef020ef          	jal	80004c20 <virtio_disk_rw>
    b->valid = 1;
    80002136:	4785                	li	a5,1
    80002138:	c09c                	sw	a5,0(s1)
  return b;
    8000213a:	b7d5                	j	8000211e <bread+0xb8>

000000008000213c <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000213c:	1101                	addi	sp,sp,-32
    8000213e:	ec06                	sd	ra,24(sp)
    80002140:	e822                	sd	s0,16(sp)
    80002142:	e426                	sd	s1,8(sp)
    80002144:	1000                	addi	s0,sp,32
    80002146:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002148:	0541                	addi	a0,a0,16
    8000214a:	2d2010ef          	jal	8000341c <holdingsleep>
    8000214e:	c911                	beqz	a0,80002162 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002150:	4585                	li	a1,1
    80002152:	8526                	mv	a0,s1
    80002154:	2cd020ef          	jal	80004c20 <virtio_disk_rw>
}
    80002158:	60e2                	ld	ra,24(sp)
    8000215a:	6442                	ld	s0,16(sp)
    8000215c:	64a2                	ld	s1,8(sp)
    8000215e:	6105                	addi	sp,sp,32
    80002160:	8082                	ret
    panic("bwrite");
    80002162:	00005517          	auipc	a0,0x5
    80002166:	1f650513          	addi	a0,a0,502 # 80007358 <etext+0x358>
    8000216a:	5f4030ef          	jal	8000575e <panic>

000000008000216e <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000216e:	1101                	addi	sp,sp,-32
    80002170:	ec06                	sd	ra,24(sp)
    80002172:	e822                	sd	s0,16(sp)
    80002174:	e426                	sd	s1,8(sp)
    80002176:	e04a                	sd	s2,0(sp)
    80002178:	1000                	addi	s0,sp,32
    8000217a:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000217c:	01050913          	addi	s2,a0,16
    80002180:	854a                	mv	a0,s2
    80002182:	29a010ef          	jal	8000341c <holdingsleep>
    80002186:	c125                	beqz	a0,800021e6 <brelse+0x78>
    panic("brelse");

  releasesleep(&b->lock);
    80002188:	854a                	mv	a0,s2
    8000218a:	25a010ef          	jal	800033e4 <releasesleep>

  acquire(&bcache.lock);
    8000218e:	00010517          	auipc	a0,0x10
    80002192:	56a50513          	addi	a0,a0,1386 # 800126f8 <bcache>
    80002196:	06b030ef          	jal	80005a00 <acquire>
  b->refcnt--;
    8000219a:	40bc                	lw	a5,64(s1)
    8000219c:	37fd                	addiw	a5,a5,-1
    8000219e:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800021a0:	e79d                	bnez	a5,800021ce <brelse+0x60>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800021a2:	68b8                	ld	a4,80(s1)
    800021a4:	64bc                	ld	a5,72(s1)
    800021a6:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    800021a8:	68b8                	ld	a4,80(s1)
    800021aa:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800021ac:	00018797          	auipc	a5,0x18
    800021b0:	54c78793          	addi	a5,a5,1356 # 8001a6f8 <bcache+0x8000>
    800021b4:	2b87b703          	ld	a4,696(a5)
    800021b8:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800021ba:	00018717          	auipc	a4,0x18
    800021be:	7a670713          	addi	a4,a4,1958 # 8001a960 <bcache+0x8268>
    800021c2:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800021c4:	2b87b703          	ld	a4,696(a5)
    800021c8:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800021ca:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800021ce:	00010517          	auipc	a0,0x10
    800021d2:	52a50513          	addi	a0,a0,1322 # 800126f8 <bcache>
    800021d6:	0bf030ef          	jal	80005a94 <release>
}
    800021da:	60e2                	ld	ra,24(sp)
    800021dc:	6442                	ld	s0,16(sp)
    800021de:	64a2                	ld	s1,8(sp)
    800021e0:	6902                	ld	s2,0(sp)
    800021e2:	6105                	addi	sp,sp,32
    800021e4:	8082                	ret
    panic("brelse");
    800021e6:	00005517          	auipc	a0,0x5
    800021ea:	17a50513          	addi	a0,a0,378 # 80007360 <etext+0x360>
    800021ee:	570030ef          	jal	8000575e <panic>

00000000800021f2 <bpin>:

void
bpin(struct buf *b) {
    800021f2:	1101                	addi	sp,sp,-32
    800021f4:	ec06                	sd	ra,24(sp)
    800021f6:	e822                	sd	s0,16(sp)
    800021f8:	e426                	sd	s1,8(sp)
    800021fa:	1000                	addi	s0,sp,32
    800021fc:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800021fe:	00010517          	auipc	a0,0x10
    80002202:	4fa50513          	addi	a0,a0,1274 # 800126f8 <bcache>
    80002206:	7fa030ef          	jal	80005a00 <acquire>
  b->refcnt++;
    8000220a:	40bc                	lw	a5,64(s1)
    8000220c:	2785                	addiw	a5,a5,1
    8000220e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002210:	00010517          	auipc	a0,0x10
    80002214:	4e850513          	addi	a0,a0,1256 # 800126f8 <bcache>
    80002218:	07d030ef          	jal	80005a94 <release>
}
    8000221c:	60e2                	ld	ra,24(sp)
    8000221e:	6442                	ld	s0,16(sp)
    80002220:	64a2                	ld	s1,8(sp)
    80002222:	6105                	addi	sp,sp,32
    80002224:	8082                	ret

0000000080002226 <bunpin>:

void
bunpin(struct buf *b) {
    80002226:	1101                	addi	sp,sp,-32
    80002228:	ec06                	sd	ra,24(sp)
    8000222a:	e822                	sd	s0,16(sp)
    8000222c:	e426                	sd	s1,8(sp)
    8000222e:	1000                	addi	s0,sp,32
    80002230:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002232:	00010517          	auipc	a0,0x10
    80002236:	4c650513          	addi	a0,a0,1222 # 800126f8 <bcache>
    8000223a:	7c6030ef          	jal	80005a00 <acquire>
  b->refcnt--;
    8000223e:	40bc                	lw	a5,64(s1)
    80002240:	37fd                	addiw	a5,a5,-1
    80002242:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002244:	00010517          	auipc	a0,0x10
    80002248:	4b450513          	addi	a0,a0,1204 # 800126f8 <bcache>
    8000224c:	049030ef          	jal	80005a94 <release>
}
    80002250:	60e2                	ld	ra,24(sp)
    80002252:	6442                	ld	s0,16(sp)
    80002254:	64a2                	ld	s1,8(sp)
    80002256:	6105                	addi	sp,sp,32
    80002258:	8082                	ret

000000008000225a <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000225a:	1101                	addi	sp,sp,-32
    8000225c:	ec06                	sd	ra,24(sp)
    8000225e:	e822                	sd	s0,16(sp)
    80002260:	e426                	sd	s1,8(sp)
    80002262:	e04a                	sd	s2,0(sp)
    80002264:	1000                	addi	s0,sp,32
    80002266:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002268:	00d5d79b          	srliw	a5,a1,0xd
    8000226c:	00019597          	auipc	a1,0x19
    80002270:	b685a583          	lw	a1,-1176(a1) # 8001add4 <sb+0x1c>
    80002274:	9dbd                	addw	a1,a1,a5
    80002276:	df1ff0ef          	jal	80002066 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000227a:	0074f713          	andi	a4,s1,7
    8000227e:	4785                	li	a5,1
    80002280:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    80002284:	14ce                	slli	s1,s1,0x33
  if((bp->data[bi/8] & m) == 0)
    80002286:	90d9                	srli	s1,s1,0x36
    80002288:	00950733          	add	a4,a0,s1
    8000228c:	05874703          	lbu	a4,88(a4)
    80002290:	00e7f6b3          	and	a3,a5,a4
    80002294:	c29d                	beqz	a3,800022ba <bfree+0x60>
    80002296:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002298:	94aa                	add	s1,s1,a0
    8000229a:	fff7c793          	not	a5,a5
    8000229e:	8f7d                	and	a4,a4,a5
    800022a0:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800022a4:	000010ef          	jal	800032a4 <log_write>
  brelse(bp);
    800022a8:	854a                	mv	a0,s2
    800022aa:	ec5ff0ef          	jal	8000216e <brelse>
}
    800022ae:	60e2                	ld	ra,24(sp)
    800022b0:	6442                	ld	s0,16(sp)
    800022b2:	64a2                	ld	s1,8(sp)
    800022b4:	6902                	ld	s2,0(sp)
    800022b6:	6105                	addi	sp,sp,32
    800022b8:	8082                	ret
    panic("freeing free block");
    800022ba:	00005517          	auipc	a0,0x5
    800022be:	0ae50513          	addi	a0,a0,174 # 80007368 <etext+0x368>
    800022c2:	49c030ef          	jal	8000575e <panic>

00000000800022c6 <balloc>:
{
    800022c6:	715d                	addi	sp,sp,-80
    800022c8:	e486                	sd	ra,72(sp)
    800022ca:	e0a2                	sd	s0,64(sp)
    800022cc:	fc26                	sd	s1,56(sp)
    800022ce:	0880                	addi	s0,sp,80
  for(b = 0; b < sb.size; b += BPB){
    800022d0:	00019797          	auipc	a5,0x19
    800022d4:	aec7a783          	lw	a5,-1300(a5) # 8001adbc <sb+0x4>
    800022d8:	0e078263          	beqz	a5,800023bc <balloc+0xf6>
    800022dc:	f84a                	sd	s2,48(sp)
    800022de:	f44e                	sd	s3,40(sp)
    800022e0:	f052                	sd	s4,32(sp)
    800022e2:	ec56                	sd	s5,24(sp)
    800022e4:	e85a                	sd	s6,16(sp)
    800022e6:	e45e                	sd	s7,8(sp)
    800022e8:	e062                	sd	s8,0(sp)
    800022ea:	8baa                	mv	s7,a0
    800022ec:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800022ee:	00019b17          	auipc	s6,0x19
    800022f2:	acab0b13          	addi	s6,s6,-1334 # 8001adb8 <sb>
      m = 1 << (bi % 8);
    800022f6:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800022f8:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800022fa:	6c09                	lui	s8,0x2
    800022fc:	a09d                	j	80002362 <balloc+0x9c>
        bp->data[bi/8] |= m;  // Mark block in use.
    800022fe:	97ca                	add	a5,a5,s2
    80002300:	8e55                	or	a2,a2,a3
    80002302:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002306:	854a                	mv	a0,s2
    80002308:	79d000ef          	jal	800032a4 <log_write>
        brelse(bp);
    8000230c:	854a                	mv	a0,s2
    8000230e:	e61ff0ef          	jal	8000216e <brelse>
  bp = bread(dev, bno);
    80002312:	85a6                	mv	a1,s1
    80002314:	855e                	mv	a0,s7
    80002316:	d51ff0ef          	jal	80002066 <bread>
    8000231a:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000231c:	40000613          	li	a2,1024
    80002320:	4581                	li	a1,0
    80002322:	05850513          	addi	a0,a0,88
    80002326:	e39fd0ef          	jal	8000015e <memset>
  log_write(bp);
    8000232a:	854a                	mv	a0,s2
    8000232c:	779000ef          	jal	800032a4 <log_write>
  brelse(bp);
    80002330:	854a                	mv	a0,s2
    80002332:	e3dff0ef          	jal	8000216e <brelse>
}
    80002336:	7942                	ld	s2,48(sp)
    80002338:	79a2                	ld	s3,40(sp)
    8000233a:	7a02                	ld	s4,32(sp)
    8000233c:	6ae2                	ld	s5,24(sp)
    8000233e:	6b42                	ld	s6,16(sp)
    80002340:	6ba2                	ld	s7,8(sp)
    80002342:	6c02                	ld	s8,0(sp)
}
    80002344:	8526                	mv	a0,s1
    80002346:	60a6                	ld	ra,72(sp)
    80002348:	6406                	ld	s0,64(sp)
    8000234a:	74e2                	ld	s1,56(sp)
    8000234c:	6161                	addi	sp,sp,80
    8000234e:	8082                	ret
    brelse(bp);
    80002350:	854a                	mv	a0,s2
    80002352:	e1dff0ef          	jal	8000216e <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002356:	015c0abb          	addw	s5,s8,s5
    8000235a:	004b2783          	lw	a5,4(s6)
    8000235e:	04faf863          	bgeu	s5,a5,800023ae <balloc+0xe8>
    bp = bread(dev, BBLOCK(b, sb));
    80002362:	40dad59b          	sraiw	a1,s5,0xd
    80002366:	01cb2783          	lw	a5,28(s6)
    8000236a:	9dbd                	addw	a1,a1,a5
    8000236c:	855e                	mv	a0,s7
    8000236e:	cf9ff0ef          	jal	80002066 <bread>
    80002372:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002374:	004b2503          	lw	a0,4(s6)
    80002378:	84d6                	mv	s1,s5
    8000237a:	4701                	li	a4,0
    8000237c:	fca4fae3          	bgeu	s1,a0,80002350 <balloc+0x8a>
      m = 1 << (bi % 8);
    80002380:	00777693          	andi	a3,a4,7
    80002384:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002388:	41f7579b          	sraiw	a5,a4,0x1f
    8000238c:	01d7d79b          	srliw	a5,a5,0x1d
    80002390:	9fb9                	addw	a5,a5,a4
    80002392:	4037d79b          	sraiw	a5,a5,0x3
    80002396:	00f90633          	add	a2,s2,a5
    8000239a:	05864603          	lbu	a2,88(a2)
    8000239e:	00c6f5b3          	and	a1,a3,a2
    800023a2:	ddb1                	beqz	a1,800022fe <balloc+0x38>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800023a4:	2705                	addiw	a4,a4,1
    800023a6:	2485                	addiw	s1,s1,1
    800023a8:	fd471ae3          	bne	a4,s4,8000237c <balloc+0xb6>
    800023ac:	b755                	j	80002350 <balloc+0x8a>
    800023ae:	7942                	ld	s2,48(sp)
    800023b0:	79a2                	ld	s3,40(sp)
    800023b2:	7a02                	ld	s4,32(sp)
    800023b4:	6ae2                	ld	s5,24(sp)
    800023b6:	6b42                	ld	s6,16(sp)
    800023b8:	6ba2                	ld	s7,8(sp)
    800023ba:	6c02                	ld	s8,0(sp)
  printf("balloc: out of blocks\n");
    800023bc:	00005517          	auipc	a0,0x5
    800023c0:	fc450513          	addi	a0,a0,-60 # 80007380 <etext+0x380>
    800023c4:	7f9020ef          	jal	800053bc <printf>
  return 0;
    800023c8:	4481                	li	s1,0
    800023ca:	bfad                	j	80002344 <balloc+0x7e>

00000000800023cc <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800023cc:	7179                	addi	sp,sp,-48
    800023ce:	f406                	sd	ra,40(sp)
    800023d0:	f022                	sd	s0,32(sp)
    800023d2:	ec26                	sd	s1,24(sp)
    800023d4:	e84a                	sd	s2,16(sp)
    800023d6:	e44e                	sd	s3,8(sp)
    800023d8:	1800                	addi	s0,sp,48
    800023da:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800023dc:	47ad                	li	a5,11
    800023de:	02b7e363          	bltu	a5,a1,80002404 <bmap+0x38>
    if((addr = ip->addrs[bn]) == 0){
    800023e2:	02059793          	slli	a5,a1,0x20
    800023e6:	01e7d593          	srli	a1,a5,0x1e
    800023ea:	00b509b3          	add	s3,a0,a1
    800023ee:	0509a483          	lw	s1,80(s3)
    800023f2:	e0b5                	bnez	s1,80002456 <bmap+0x8a>
      addr = balloc(ip->dev);
    800023f4:	4108                	lw	a0,0(a0)
    800023f6:	ed1ff0ef          	jal	800022c6 <balloc>
    800023fa:	84aa                	mv	s1,a0
      if(addr == 0)
    800023fc:	cd29                	beqz	a0,80002456 <bmap+0x8a>
        return 0;
      ip->addrs[bn] = addr;
    800023fe:	04a9a823          	sw	a0,80(s3)
    80002402:	a891                	j	80002456 <bmap+0x8a>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002404:	ff45879b          	addiw	a5,a1,-12
    80002408:	873e                	mv	a4,a5
    8000240a:	89be                	mv	s3,a5

  if(bn < NINDIRECT){
    8000240c:	0ff00793          	li	a5,255
    80002410:	06e7e763          	bltu	a5,a4,8000247e <bmap+0xb2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002414:	08052483          	lw	s1,128(a0)
    80002418:	e891                	bnez	s1,8000242c <bmap+0x60>
      addr = balloc(ip->dev);
    8000241a:	4108                	lw	a0,0(a0)
    8000241c:	eabff0ef          	jal	800022c6 <balloc>
    80002420:	84aa                	mv	s1,a0
      if(addr == 0)
    80002422:	c915                	beqz	a0,80002456 <bmap+0x8a>
    80002424:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002426:	08a92023          	sw	a0,128(s2)
    8000242a:	a011                	j	8000242e <bmap+0x62>
    8000242c:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    8000242e:	85a6                	mv	a1,s1
    80002430:	00092503          	lw	a0,0(s2)
    80002434:	c33ff0ef          	jal	80002066 <bread>
    80002438:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000243a:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000243e:	02099713          	slli	a4,s3,0x20
    80002442:	01e75593          	srli	a1,a4,0x1e
    80002446:	97ae                	add	a5,a5,a1
    80002448:	89be                	mv	s3,a5
    8000244a:	4384                	lw	s1,0(a5)
    8000244c:	cc89                	beqz	s1,80002466 <bmap+0x9a>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    8000244e:	8552                	mv	a0,s4
    80002450:	d1fff0ef          	jal	8000216e <brelse>
    return addr;
    80002454:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80002456:	8526                	mv	a0,s1
    80002458:	70a2                	ld	ra,40(sp)
    8000245a:	7402                	ld	s0,32(sp)
    8000245c:	64e2                	ld	s1,24(sp)
    8000245e:	6942                	ld	s2,16(sp)
    80002460:	69a2                	ld	s3,8(sp)
    80002462:	6145                	addi	sp,sp,48
    80002464:	8082                	ret
      addr = balloc(ip->dev);
    80002466:	00092503          	lw	a0,0(s2)
    8000246a:	e5dff0ef          	jal	800022c6 <balloc>
    8000246e:	84aa                	mv	s1,a0
      if(addr){
    80002470:	dd79                	beqz	a0,8000244e <bmap+0x82>
        a[bn] = addr;
    80002472:	00a9a023          	sw	a0,0(s3)
        log_write(bp);
    80002476:	8552                	mv	a0,s4
    80002478:	62d000ef          	jal	800032a4 <log_write>
    8000247c:	bfc9                	j	8000244e <bmap+0x82>
    8000247e:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80002480:	00005517          	auipc	a0,0x5
    80002484:	f1850513          	addi	a0,a0,-232 # 80007398 <etext+0x398>
    80002488:	2d6030ef          	jal	8000575e <panic>

000000008000248c <iget>:
{
    8000248c:	7179                	addi	sp,sp,-48
    8000248e:	f406                	sd	ra,40(sp)
    80002490:	f022                	sd	s0,32(sp)
    80002492:	ec26                	sd	s1,24(sp)
    80002494:	e84a                	sd	s2,16(sp)
    80002496:	e44e                	sd	s3,8(sp)
    80002498:	e052                	sd	s4,0(sp)
    8000249a:	1800                	addi	s0,sp,48
    8000249c:	892a                	mv	s2,a0
    8000249e:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800024a0:	00019517          	auipc	a0,0x19
    800024a4:	93850513          	addi	a0,a0,-1736 # 8001add8 <itable>
    800024a8:	558030ef          	jal	80005a00 <acquire>
  empty = 0;
    800024ac:	4981                	li	s3,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800024ae:	00019497          	auipc	s1,0x19
    800024b2:	94248493          	addi	s1,s1,-1726 # 8001adf0 <itable+0x18>
    800024b6:	0001a697          	auipc	a3,0x1a
    800024ba:	3ca68693          	addi	a3,a3,970 # 8001c880 <log>
    800024be:	a809                	j	800024d0 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800024c0:	e781                	bnez	a5,800024c8 <iget+0x3c>
    800024c2:	00099363          	bnez	s3,800024c8 <iget+0x3c>
      empty = ip;
    800024c6:	89a6                	mv	s3,s1
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800024c8:	08848493          	addi	s1,s1,136
    800024cc:	02d48563          	beq	s1,a3,800024f6 <iget+0x6a>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800024d0:	449c                	lw	a5,8(s1)
    800024d2:	fef057e3          	blez	a5,800024c0 <iget+0x34>
    800024d6:	4098                	lw	a4,0(s1)
    800024d8:	ff2718e3          	bne	a4,s2,800024c8 <iget+0x3c>
    800024dc:	40d8                	lw	a4,4(s1)
    800024de:	ff4715e3          	bne	a4,s4,800024c8 <iget+0x3c>
      ip->ref++;
    800024e2:	2785                	addiw	a5,a5,1
    800024e4:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800024e6:	00019517          	auipc	a0,0x19
    800024ea:	8f250513          	addi	a0,a0,-1806 # 8001add8 <itable>
    800024ee:	5a6030ef          	jal	80005a94 <release>
      return ip;
    800024f2:	89a6                	mv	s3,s1
    800024f4:	a015                	j	80002518 <iget+0x8c>
  if(empty == 0)
    800024f6:	02098a63          	beqz	s3,8000252a <iget+0x9e>
  ip->dev = dev;
    800024fa:	0129a023          	sw	s2,0(s3)
  ip->inum = inum;
    800024fe:	0149a223          	sw	s4,4(s3)
  ip->ref = 1;
    80002502:	4785                	li	a5,1
    80002504:	00f9a423          	sw	a5,8(s3)
  ip->valid = 0;
    80002508:	0409a023          	sw	zero,64(s3)
  release(&itable.lock);
    8000250c:	00019517          	auipc	a0,0x19
    80002510:	8cc50513          	addi	a0,a0,-1844 # 8001add8 <itable>
    80002514:	580030ef          	jal	80005a94 <release>
}
    80002518:	854e                	mv	a0,s3
    8000251a:	70a2                	ld	ra,40(sp)
    8000251c:	7402                	ld	s0,32(sp)
    8000251e:	64e2                	ld	s1,24(sp)
    80002520:	6942                	ld	s2,16(sp)
    80002522:	69a2                	ld	s3,8(sp)
    80002524:	6a02                	ld	s4,0(sp)
    80002526:	6145                	addi	sp,sp,48
    80002528:	8082                	ret
    panic("iget: no inodes");
    8000252a:	00005517          	auipc	a0,0x5
    8000252e:	e8650513          	addi	a0,a0,-378 # 800073b0 <etext+0x3b0>
    80002532:	22c030ef          	jal	8000575e <panic>

0000000080002536 <iinit>:
{
    80002536:	7179                	addi	sp,sp,-48
    80002538:	f406                	sd	ra,40(sp)
    8000253a:	f022                	sd	s0,32(sp)
    8000253c:	ec26                	sd	s1,24(sp)
    8000253e:	e84a                	sd	s2,16(sp)
    80002540:	e44e                	sd	s3,8(sp)
    80002542:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002544:	00005597          	auipc	a1,0x5
    80002548:	e7c58593          	addi	a1,a1,-388 # 800073c0 <etext+0x3c0>
    8000254c:	00019517          	auipc	a0,0x19
    80002550:	88c50513          	addi	a0,a0,-1908 # 8001add8 <itable>
    80002554:	422030ef          	jal	80005976 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002558:	00019497          	auipc	s1,0x19
    8000255c:	8a848493          	addi	s1,s1,-1880 # 8001ae00 <itable+0x28>
    80002560:	0001a997          	auipc	s3,0x1a
    80002564:	33098993          	addi	s3,s3,816 # 8001c890 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002568:	00005917          	auipc	s2,0x5
    8000256c:	e6090913          	addi	s2,s2,-416 # 800073c8 <etext+0x3c8>
    80002570:	85ca                	mv	a1,s2
    80002572:	8526                	mv	a0,s1
    80002574:	5f5000ef          	jal	80003368 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002578:	08848493          	addi	s1,s1,136
    8000257c:	ff349ae3          	bne	s1,s3,80002570 <iinit+0x3a>
}
    80002580:	70a2                	ld	ra,40(sp)
    80002582:	7402                	ld	s0,32(sp)
    80002584:	64e2                	ld	s1,24(sp)
    80002586:	6942                	ld	s2,16(sp)
    80002588:	69a2                	ld	s3,8(sp)
    8000258a:	6145                	addi	sp,sp,48
    8000258c:	8082                	ret

000000008000258e <ialloc>:
{
    8000258e:	7139                	addi	sp,sp,-64
    80002590:	fc06                	sd	ra,56(sp)
    80002592:	f822                	sd	s0,48(sp)
    80002594:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002596:	00019717          	auipc	a4,0x19
    8000259a:	82e72703          	lw	a4,-2002(a4) # 8001adc4 <sb+0xc>
    8000259e:	4785                	li	a5,1
    800025a0:	06e7f063          	bgeu	a5,a4,80002600 <ialloc+0x72>
    800025a4:	f426                	sd	s1,40(sp)
    800025a6:	f04a                	sd	s2,32(sp)
    800025a8:	ec4e                	sd	s3,24(sp)
    800025aa:	e852                	sd	s4,16(sp)
    800025ac:	e456                	sd	s5,8(sp)
    800025ae:	e05a                	sd	s6,0(sp)
    800025b0:	8aaa                	mv	s5,a0
    800025b2:	8b2e                	mv	s6,a1
    800025b4:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    800025b6:	00019a17          	auipc	s4,0x19
    800025ba:	802a0a13          	addi	s4,s4,-2046 # 8001adb8 <sb>
    800025be:	00495593          	srli	a1,s2,0x4
    800025c2:	018a2783          	lw	a5,24(s4)
    800025c6:	9dbd                	addw	a1,a1,a5
    800025c8:	8556                	mv	a0,s5
    800025ca:	a9dff0ef          	jal	80002066 <bread>
    800025ce:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800025d0:	05850993          	addi	s3,a0,88
    800025d4:	00f97793          	andi	a5,s2,15
    800025d8:	079a                	slli	a5,a5,0x6
    800025da:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800025dc:	00099783          	lh	a5,0(s3)
    800025e0:	cb9d                	beqz	a5,80002616 <ialloc+0x88>
    brelse(bp);
    800025e2:	b8dff0ef          	jal	8000216e <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800025e6:	0905                	addi	s2,s2,1
    800025e8:	00ca2703          	lw	a4,12(s4)
    800025ec:	0009079b          	sext.w	a5,s2
    800025f0:	fce7e7e3          	bltu	a5,a4,800025be <ialloc+0x30>
    800025f4:	74a2                	ld	s1,40(sp)
    800025f6:	7902                	ld	s2,32(sp)
    800025f8:	69e2                	ld	s3,24(sp)
    800025fa:	6a42                	ld	s4,16(sp)
    800025fc:	6aa2                	ld	s5,8(sp)
    800025fe:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80002600:	00005517          	auipc	a0,0x5
    80002604:	dd050513          	addi	a0,a0,-560 # 800073d0 <etext+0x3d0>
    80002608:	5b5020ef          	jal	800053bc <printf>
  return 0;
    8000260c:	4501                	li	a0,0
}
    8000260e:	70e2                	ld	ra,56(sp)
    80002610:	7442                	ld	s0,48(sp)
    80002612:	6121                	addi	sp,sp,64
    80002614:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002616:	04000613          	li	a2,64
    8000261a:	4581                	li	a1,0
    8000261c:	854e                	mv	a0,s3
    8000261e:	b41fd0ef          	jal	8000015e <memset>
      dip->type = type;
    80002622:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002626:	8526                	mv	a0,s1
    80002628:	47d000ef          	jal	800032a4 <log_write>
      brelse(bp);
    8000262c:	8526                	mv	a0,s1
    8000262e:	b41ff0ef          	jal	8000216e <brelse>
      return iget(dev, inum);
    80002632:	0009059b          	sext.w	a1,s2
    80002636:	8556                	mv	a0,s5
    80002638:	e55ff0ef          	jal	8000248c <iget>
    8000263c:	74a2                	ld	s1,40(sp)
    8000263e:	7902                	ld	s2,32(sp)
    80002640:	69e2                	ld	s3,24(sp)
    80002642:	6a42                	ld	s4,16(sp)
    80002644:	6aa2                	ld	s5,8(sp)
    80002646:	6b02                	ld	s6,0(sp)
    80002648:	b7d9                	j	8000260e <ialloc+0x80>

000000008000264a <iupdate>:
{
    8000264a:	1101                	addi	sp,sp,-32
    8000264c:	ec06                	sd	ra,24(sp)
    8000264e:	e822                	sd	s0,16(sp)
    80002650:	e426                	sd	s1,8(sp)
    80002652:	e04a                	sd	s2,0(sp)
    80002654:	1000                	addi	s0,sp,32
    80002656:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002658:	415c                	lw	a5,4(a0)
    8000265a:	0047d79b          	srliw	a5,a5,0x4
    8000265e:	00018597          	auipc	a1,0x18
    80002662:	7725a583          	lw	a1,1906(a1) # 8001add0 <sb+0x18>
    80002666:	9dbd                	addw	a1,a1,a5
    80002668:	4108                	lw	a0,0(a0)
    8000266a:	9fdff0ef          	jal	80002066 <bread>
    8000266e:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002670:	05850793          	addi	a5,a0,88
    80002674:	40d8                	lw	a4,4(s1)
    80002676:	8b3d                	andi	a4,a4,15
    80002678:	071a                	slli	a4,a4,0x6
    8000267a:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    8000267c:	04449703          	lh	a4,68(s1)
    80002680:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002684:	04649703          	lh	a4,70(s1)
    80002688:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    8000268c:	04849703          	lh	a4,72(s1)
    80002690:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002694:	04a49703          	lh	a4,74(s1)
    80002698:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    8000269c:	44f8                	lw	a4,76(s1)
    8000269e:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800026a0:	03400613          	li	a2,52
    800026a4:	05048593          	addi	a1,s1,80
    800026a8:	00c78513          	addi	a0,a5,12
    800026ac:	b13fd0ef          	jal	800001be <memmove>
  log_write(bp);
    800026b0:	854a                	mv	a0,s2
    800026b2:	3f3000ef          	jal	800032a4 <log_write>
  brelse(bp);
    800026b6:	854a                	mv	a0,s2
    800026b8:	ab7ff0ef          	jal	8000216e <brelse>
}
    800026bc:	60e2                	ld	ra,24(sp)
    800026be:	6442                	ld	s0,16(sp)
    800026c0:	64a2                	ld	s1,8(sp)
    800026c2:	6902                	ld	s2,0(sp)
    800026c4:	6105                	addi	sp,sp,32
    800026c6:	8082                	ret

00000000800026c8 <idup>:
{
    800026c8:	1101                	addi	sp,sp,-32
    800026ca:	ec06                	sd	ra,24(sp)
    800026cc:	e822                	sd	s0,16(sp)
    800026ce:	e426                	sd	s1,8(sp)
    800026d0:	1000                	addi	s0,sp,32
    800026d2:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800026d4:	00018517          	auipc	a0,0x18
    800026d8:	70450513          	addi	a0,a0,1796 # 8001add8 <itable>
    800026dc:	324030ef          	jal	80005a00 <acquire>
  ip->ref++;
    800026e0:	449c                	lw	a5,8(s1)
    800026e2:	2785                	addiw	a5,a5,1
    800026e4:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800026e6:	00018517          	auipc	a0,0x18
    800026ea:	6f250513          	addi	a0,a0,1778 # 8001add8 <itable>
    800026ee:	3a6030ef          	jal	80005a94 <release>
}
    800026f2:	8526                	mv	a0,s1
    800026f4:	60e2                	ld	ra,24(sp)
    800026f6:	6442                	ld	s0,16(sp)
    800026f8:	64a2                	ld	s1,8(sp)
    800026fa:	6105                	addi	sp,sp,32
    800026fc:	8082                	ret

00000000800026fe <ilock>:
{
    800026fe:	1101                	addi	sp,sp,-32
    80002700:	ec06                	sd	ra,24(sp)
    80002702:	e822                	sd	s0,16(sp)
    80002704:	e426                	sd	s1,8(sp)
    80002706:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002708:	cd19                	beqz	a0,80002726 <ilock+0x28>
    8000270a:	84aa                	mv	s1,a0
    8000270c:	451c                	lw	a5,8(a0)
    8000270e:	00f05c63          	blez	a5,80002726 <ilock+0x28>
  acquiresleep(&ip->lock);
    80002712:	0541                	addi	a0,a0,16
    80002714:	48b000ef          	jal	8000339e <acquiresleep>
  if(ip->valid == 0){
    80002718:	40bc                	lw	a5,64(s1)
    8000271a:	cf89                	beqz	a5,80002734 <ilock+0x36>
}
    8000271c:	60e2                	ld	ra,24(sp)
    8000271e:	6442                	ld	s0,16(sp)
    80002720:	64a2                	ld	s1,8(sp)
    80002722:	6105                	addi	sp,sp,32
    80002724:	8082                	ret
    80002726:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002728:	00005517          	auipc	a0,0x5
    8000272c:	cc050513          	addi	a0,a0,-832 # 800073e8 <etext+0x3e8>
    80002730:	02e030ef          	jal	8000575e <panic>
    80002734:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002736:	40dc                	lw	a5,4(s1)
    80002738:	0047d79b          	srliw	a5,a5,0x4
    8000273c:	00018597          	auipc	a1,0x18
    80002740:	6945a583          	lw	a1,1684(a1) # 8001add0 <sb+0x18>
    80002744:	9dbd                	addw	a1,a1,a5
    80002746:	4088                	lw	a0,0(s1)
    80002748:	91fff0ef          	jal	80002066 <bread>
    8000274c:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000274e:	05850593          	addi	a1,a0,88
    80002752:	40dc                	lw	a5,4(s1)
    80002754:	8bbd                	andi	a5,a5,15
    80002756:	079a                	slli	a5,a5,0x6
    80002758:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    8000275a:	00059783          	lh	a5,0(a1)
    8000275e:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002762:	00259783          	lh	a5,2(a1)
    80002766:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    8000276a:	00459783          	lh	a5,4(a1)
    8000276e:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002772:	00659783          	lh	a5,6(a1)
    80002776:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    8000277a:	459c                	lw	a5,8(a1)
    8000277c:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    8000277e:	03400613          	li	a2,52
    80002782:	05b1                	addi	a1,a1,12
    80002784:	05048513          	addi	a0,s1,80
    80002788:	a37fd0ef          	jal	800001be <memmove>
    brelse(bp);
    8000278c:	854a                	mv	a0,s2
    8000278e:	9e1ff0ef          	jal	8000216e <brelse>
    ip->valid = 1;
    80002792:	4785                	li	a5,1
    80002794:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002796:	04449783          	lh	a5,68(s1)
    8000279a:	c399                	beqz	a5,800027a0 <ilock+0xa2>
    8000279c:	6902                	ld	s2,0(sp)
    8000279e:	bfbd                	j	8000271c <ilock+0x1e>
      panic("ilock: no type");
    800027a0:	00005517          	auipc	a0,0x5
    800027a4:	c5050513          	addi	a0,a0,-944 # 800073f0 <etext+0x3f0>
    800027a8:	7b7020ef          	jal	8000575e <panic>

00000000800027ac <iunlock>:
{
    800027ac:	1101                	addi	sp,sp,-32
    800027ae:	ec06                	sd	ra,24(sp)
    800027b0:	e822                	sd	s0,16(sp)
    800027b2:	e426                	sd	s1,8(sp)
    800027b4:	e04a                	sd	s2,0(sp)
    800027b6:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800027b8:	c505                	beqz	a0,800027e0 <iunlock+0x34>
    800027ba:	84aa                	mv	s1,a0
    800027bc:	01050913          	addi	s2,a0,16
    800027c0:	854a                	mv	a0,s2
    800027c2:	45b000ef          	jal	8000341c <holdingsleep>
    800027c6:	cd09                	beqz	a0,800027e0 <iunlock+0x34>
    800027c8:	449c                	lw	a5,8(s1)
    800027ca:	00f05b63          	blez	a5,800027e0 <iunlock+0x34>
  releasesleep(&ip->lock);
    800027ce:	854a                	mv	a0,s2
    800027d0:	415000ef          	jal	800033e4 <releasesleep>
}
    800027d4:	60e2                	ld	ra,24(sp)
    800027d6:	6442                	ld	s0,16(sp)
    800027d8:	64a2                	ld	s1,8(sp)
    800027da:	6902                	ld	s2,0(sp)
    800027dc:	6105                	addi	sp,sp,32
    800027de:	8082                	ret
    panic("iunlock");
    800027e0:	00005517          	auipc	a0,0x5
    800027e4:	c2050513          	addi	a0,a0,-992 # 80007400 <etext+0x400>
    800027e8:	777020ef          	jal	8000575e <panic>

00000000800027ec <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    800027ec:	7179                	addi	sp,sp,-48
    800027ee:	f406                	sd	ra,40(sp)
    800027f0:	f022                	sd	s0,32(sp)
    800027f2:	ec26                	sd	s1,24(sp)
    800027f4:	e84a                	sd	s2,16(sp)
    800027f6:	e44e                	sd	s3,8(sp)
    800027f8:	1800                	addi	s0,sp,48
    800027fa:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    800027fc:	05050493          	addi	s1,a0,80
    80002800:	08050913          	addi	s2,a0,128
    80002804:	a021                	j	8000280c <itrunc+0x20>
    80002806:	0491                	addi	s1,s1,4
    80002808:	01248b63          	beq	s1,s2,8000281e <itrunc+0x32>
    if(ip->addrs[i]){
    8000280c:	408c                	lw	a1,0(s1)
    8000280e:	dde5                	beqz	a1,80002806 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002810:	0009a503          	lw	a0,0(s3)
    80002814:	a47ff0ef          	jal	8000225a <bfree>
      ip->addrs[i] = 0;
    80002818:	0004a023          	sw	zero,0(s1)
    8000281c:	b7ed                	j	80002806 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    8000281e:	0809a583          	lw	a1,128(s3)
    80002822:	ed89                	bnez	a1,8000283c <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002824:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002828:	854e                	mv	a0,s3
    8000282a:	e21ff0ef          	jal	8000264a <iupdate>
}
    8000282e:	70a2                	ld	ra,40(sp)
    80002830:	7402                	ld	s0,32(sp)
    80002832:	64e2                	ld	s1,24(sp)
    80002834:	6942                	ld	s2,16(sp)
    80002836:	69a2                	ld	s3,8(sp)
    80002838:	6145                	addi	sp,sp,48
    8000283a:	8082                	ret
    8000283c:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    8000283e:	0009a503          	lw	a0,0(s3)
    80002842:	825ff0ef          	jal	80002066 <bread>
    80002846:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002848:	05850493          	addi	s1,a0,88
    8000284c:	45850913          	addi	s2,a0,1112
    80002850:	a021                	j	80002858 <itrunc+0x6c>
    80002852:	0491                	addi	s1,s1,4
    80002854:	01248963          	beq	s1,s2,80002866 <itrunc+0x7a>
      if(a[j])
    80002858:	408c                	lw	a1,0(s1)
    8000285a:	dde5                	beqz	a1,80002852 <itrunc+0x66>
        bfree(ip->dev, a[j]);
    8000285c:	0009a503          	lw	a0,0(s3)
    80002860:	9fbff0ef          	jal	8000225a <bfree>
    80002864:	b7fd                	j	80002852 <itrunc+0x66>
    brelse(bp);
    80002866:	8552                	mv	a0,s4
    80002868:	907ff0ef          	jal	8000216e <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    8000286c:	0809a583          	lw	a1,128(s3)
    80002870:	0009a503          	lw	a0,0(s3)
    80002874:	9e7ff0ef          	jal	8000225a <bfree>
    ip->addrs[NDIRECT] = 0;
    80002878:	0809a023          	sw	zero,128(s3)
    8000287c:	6a02                	ld	s4,0(sp)
    8000287e:	b75d                	j	80002824 <itrunc+0x38>

0000000080002880 <iput>:
{
    80002880:	1101                	addi	sp,sp,-32
    80002882:	ec06                	sd	ra,24(sp)
    80002884:	e822                	sd	s0,16(sp)
    80002886:	e426                	sd	s1,8(sp)
    80002888:	1000                	addi	s0,sp,32
    8000288a:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000288c:	00018517          	auipc	a0,0x18
    80002890:	54c50513          	addi	a0,a0,1356 # 8001add8 <itable>
    80002894:	16c030ef          	jal	80005a00 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002898:	4498                	lw	a4,8(s1)
    8000289a:	4785                	li	a5,1
    8000289c:	02f70063          	beq	a4,a5,800028bc <iput+0x3c>
  ip->ref--;
    800028a0:	449c                	lw	a5,8(s1)
    800028a2:	37fd                	addiw	a5,a5,-1
    800028a4:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800028a6:	00018517          	auipc	a0,0x18
    800028aa:	53250513          	addi	a0,a0,1330 # 8001add8 <itable>
    800028ae:	1e6030ef          	jal	80005a94 <release>
}
    800028b2:	60e2                	ld	ra,24(sp)
    800028b4:	6442                	ld	s0,16(sp)
    800028b6:	64a2                	ld	s1,8(sp)
    800028b8:	6105                	addi	sp,sp,32
    800028ba:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800028bc:	40bc                	lw	a5,64(s1)
    800028be:	d3ed                	beqz	a5,800028a0 <iput+0x20>
    800028c0:	04a49783          	lh	a5,74(s1)
    800028c4:	fff1                	bnez	a5,800028a0 <iput+0x20>
    800028c6:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    800028c8:	01048793          	addi	a5,s1,16
    800028cc:	893e                	mv	s2,a5
    800028ce:	853e                	mv	a0,a5
    800028d0:	2cf000ef          	jal	8000339e <acquiresleep>
    release(&itable.lock);
    800028d4:	00018517          	auipc	a0,0x18
    800028d8:	50450513          	addi	a0,a0,1284 # 8001add8 <itable>
    800028dc:	1b8030ef          	jal	80005a94 <release>
    itrunc(ip);
    800028e0:	8526                	mv	a0,s1
    800028e2:	f0bff0ef          	jal	800027ec <itrunc>
    ip->type = 0;
    800028e6:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    800028ea:	8526                	mv	a0,s1
    800028ec:	d5fff0ef          	jal	8000264a <iupdate>
    ip->valid = 0;
    800028f0:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    800028f4:	854a                	mv	a0,s2
    800028f6:	2ef000ef          	jal	800033e4 <releasesleep>
    acquire(&itable.lock);
    800028fa:	00018517          	auipc	a0,0x18
    800028fe:	4de50513          	addi	a0,a0,1246 # 8001add8 <itable>
    80002902:	0fe030ef          	jal	80005a00 <acquire>
    80002906:	6902                	ld	s2,0(sp)
    80002908:	bf61                	j	800028a0 <iput+0x20>

000000008000290a <iunlockput>:
{
    8000290a:	1101                	addi	sp,sp,-32
    8000290c:	ec06                	sd	ra,24(sp)
    8000290e:	e822                	sd	s0,16(sp)
    80002910:	e426                	sd	s1,8(sp)
    80002912:	1000                	addi	s0,sp,32
    80002914:	84aa                	mv	s1,a0
  iunlock(ip);
    80002916:	e97ff0ef          	jal	800027ac <iunlock>
  iput(ip);
    8000291a:	8526                	mv	a0,s1
    8000291c:	f65ff0ef          	jal	80002880 <iput>
}
    80002920:	60e2                	ld	ra,24(sp)
    80002922:	6442                	ld	s0,16(sp)
    80002924:	64a2                	ld	s1,8(sp)
    80002926:	6105                	addi	sp,sp,32
    80002928:	8082                	ret

000000008000292a <ireclaim>:
  for (int inum = 1; inum < sb.ninodes; inum++) {
    8000292a:	00018717          	auipc	a4,0x18
    8000292e:	49a72703          	lw	a4,1178(a4) # 8001adc4 <sb+0xc>
    80002932:	4785                	li	a5,1
    80002934:	0ae7fe63          	bgeu	a5,a4,800029f0 <ireclaim+0xc6>
{
    80002938:	7139                	addi	sp,sp,-64
    8000293a:	fc06                	sd	ra,56(sp)
    8000293c:	f822                	sd	s0,48(sp)
    8000293e:	f426                	sd	s1,40(sp)
    80002940:	f04a                	sd	s2,32(sp)
    80002942:	ec4e                	sd	s3,24(sp)
    80002944:	e852                	sd	s4,16(sp)
    80002946:	e456                	sd	s5,8(sp)
    80002948:	e05a                	sd	s6,0(sp)
    8000294a:	0080                	addi	s0,sp,64
    8000294c:	8aaa                	mv	s5,a0
  for (int inum = 1; inum < sb.ninodes; inum++) {
    8000294e:	84be                	mv	s1,a5
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80002950:	00018a17          	auipc	s4,0x18
    80002954:	468a0a13          	addi	s4,s4,1128 # 8001adb8 <sb>
      printf("ireclaim: orphaned inode %d\n", inum);
    80002958:	00005b17          	auipc	s6,0x5
    8000295c:	ab0b0b13          	addi	s6,s6,-1360 # 80007408 <etext+0x408>
    80002960:	a099                	j	800029a6 <ireclaim+0x7c>
    80002962:	85ce                	mv	a1,s3
    80002964:	855a                	mv	a0,s6
    80002966:	257020ef          	jal	800053bc <printf>
      ip = iget(dev, inum);
    8000296a:	85ce                	mv	a1,s3
    8000296c:	8556                	mv	a0,s5
    8000296e:	b1fff0ef          	jal	8000248c <iget>
    80002972:	89aa                	mv	s3,a0
    brelse(bp);
    80002974:	854a                	mv	a0,s2
    80002976:	ff8ff0ef          	jal	8000216e <brelse>
    if (ip) {
    8000297a:	00098f63          	beqz	s3,80002998 <ireclaim+0x6e>
      begin_op();
    8000297e:	78c000ef          	jal	8000310a <begin_op>
      ilock(ip);
    80002982:	854e                	mv	a0,s3
    80002984:	d7bff0ef          	jal	800026fe <ilock>
      iunlock(ip);
    80002988:	854e                	mv	a0,s3
    8000298a:	e23ff0ef          	jal	800027ac <iunlock>
      iput(ip);
    8000298e:	854e                	mv	a0,s3
    80002990:	ef1ff0ef          	jal	80002880 <iput>
      end_op();
    80002994:	7e6000ef          	jal	8000317a <end_op>
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80002998:	0485                	addi	s1,s1,1
    8000299a:	00ca2703          	lw	a4,12(s4)
    8000299e:	0004879b          	sext.w	a5,s1
    800029a2:	02e7fd63          	bgeu	a5,a4,800029dc <ireclaim+0xb2>
    800029a6:	0004899b          	sext.w	s3,s1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    800029aa:	0044d593          	srli	a1,s1,0x4
    800029ae:	018a2783          	lw	a5,24(s4)
    800029b2:	9dbd                	addw	a1,a1,a5
    800029b4:	8556                	mv	a0,s5
    800029b6:	eb0ff0ef          	jal	80002066 <bread>
    800029ba:	892a                	mv	s2,a0
    struct dinode *dip = (struct dinode *)bp->data + inum % IPB;
    800029bc:	05850793          	addi	a5,a0,88
    800029c0:	00f9f713          	andi	a4,s3,15
    800029c4:	071a                	slli	a4,a4,0x6
    800029c6:	97ba                	add	a5,a5,a4
    if (dip->type != 0 && dip->nlink == 0) {  // is an orphaned inode
    800029c8:	00079703          	lh	a4,0(a5)
    800029cc:	c701                	beqz	a4,800029d4 <ireclaim+0xaa>
    800029ce:	00679783          	lh	a5,6(a5)
    800029d2:	dbc1                	beqz	a5,80002962 <ireclaim+0x38>
    brelse(bp);
    800029d4:	854a                	mv	a0,s2
    800029d6:	f98ff0ef          	jal	8000216e <brelse>
    if (ip) {
    800029da:	bf7d                	j	80002998 <ireclaim+0x6e>
}
    800029dc:	70e2                	ld	ra,56(sp)
    800029de:	7442                	ld	s0,48(sp)
    800029e0:	74a2                	ld	s1,40(sp)
    800029e2:	7902                	ld	s2,32(sp)
    800029e4:	69e2                	ld	s3,24(sp)
    800029e6:	6a42                	ld	s4,16(sp)
    800029e8:	6aa2                	ld	s5,8(sp)
    800029ea:	6b02                	ld	s6,0(sp)
    800029ec:	6121                	addi	sp,sp,64
    800029ee:	8082                	ret
    800029f0:	8082                	ret

00000000800029f2 <fsinit>:
fsinit(int dev) {
    800029f2:	1101                	addi	sp,sp,-32
    800029f4:	ec06                	sd	ra,24(sp)
    800029f6:	e822                	sd	s0,16(sp)
    800029f8:	e426                	sd	s1,8(sp)
    800029fa:	e04a                	sd	s2,0(sp)
    800029fc:	1000                	addi	s0,sp,32
    800029fe:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002a00:	4585                	li	a1,1
    80002a02:	e64ff0ef          	jal	80002066 <bread>
    80002a06:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002a08:	02000613          	li	a2,32
    80002a0c:	05850593          	addi	a1,a0,88
    80002a10:	00018517          	auipc	a0,0x18
    80002a14:	3a850513          	addi	a0,a0,936 # 8001adb8 <sb>
    80002a18:	fa6fd0ef          	jal	800001be <memmove>
  brelse(bp);
    80002a1c:	8526                	mv	a0,s1
    80002a1e:	f50ff0ef          	jal	8000216e <brelse>
  if(sb.magic != FSMAGIC)
    80002a22:	00018717          	auipc	a4,0x18
    80002a26:	39672703          	lw	a4,918(a4) # 8001adb8 <sb>
    80002a2a:	102037b7          	lui	a5,0x10203
    80002a2e:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002a32:	02f71263          	bne	a4,a5,80002a56 <fsinit+0x64>
  initlog(dev, &sb);
    80002a36:	00018597          	auipc	a1,0x18
    80002a3a:	38258593          	addi	a1,a1,898 # 8001adb8 <sb>
    80002a3e:	854a                	mv	a0,s2
    80002a40:	648000ef          	jal	80003088 <initlog>
  ireclaim(dev);
    80002a44:	854a                	mv	a0,s2
    80002a46:	ee5ff0ef          	jal	8000292a <ireclaim>
}
    80002a4a:	60e2                	ld	ra,24(sp)
    80002a4c:	6442                	ld	s0,16(sp)
    80002a4e:	64a2                	ld	s1,8(sp)
    80002a50:	6902                	ld	s2,0(sp)
    80002a52:	6105                	addi	sp,sp,32
    80002a54:	8082                	ret
    panic("invalid file system");
    80002a56:	00005517          	auipc	a0,0x5
    80002a5a:	9d250513          	addi	a0,a0,-1582 # 80007428 <etext+0x428>
    80002a5e:	501020ef          	jal	8000575e <panic>

0000000080002a62 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002a62:	1141                	addi	sp,sp,-16
    80002a64:	e406                	sd	ra,8(sp)
    80002a66:	e022                	sd	s0,0(sp)
    80002a68:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002a6a:	411c                	lw	a5,0(a0)
    80002a6c:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002a6e:	415c                	lw	a5,4(a0)
    80002a70:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002a72:	04451783          	lh	a5,68(a0)
    80002a76:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002a7a:	04a51783          	lh	a5,74(a0)
    80002a7e:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002a82:	04c56783          	lwu	a5,76(a0)
    80002a86:	e99c                	sd	a5,16(a1)
}
    80002a88:	60a2                	ld	ra,8(sp)
    80002a8a:	6402                	ld	s0,0(sp)
    80002a8c:	0141                	addi	sp,sp,16
    80002a8e:	8082                	ret

0000000080002a90 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002a90:	457c                	lw	a5,76(a0)
    80002a92:	0ed7e663          	bltu	a5,a3,80002b7e <readi+0xee>
{
    80002a96:	7159                	addi	sp,sp,-112
    80002a98:	f486                	sd	ra,104(sp)
    80002a9a:	f0a2                	sd	s0,96(sp)
    80002a9c:	eca6                	sd	s1,88(sp)
    80002a9e:	e0d2                	sd	s4,64(sp)
    80002aa0:	fc56                	sd	s5,56(sp)
    80002aa2:	f85a                	sd	s6,48(sp)
    80002aa4:	f45e                	sd	s7,40(sp)
    80002aa6:	1880                	addi	s0,sp,112
    80002aa8:	8b2a                	mv	s6,a0
    80002aaa:	8bae                	mv	s7,a1
    80002aac:	8a32                	mv	s4,a2
    80002aae:	84b6                	mv	s1,a3
    80002ab0:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002ab2:	9f35                	addw	a4,a4,a3
    return 0;
    80002ab4:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002ab6:	0ad76b63          	bltu	a4,a3,80002b6c <readi+0xdc>
    80002aba:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80002abc:	00e7f463          	bgeu	a5,a4,80002ac4 <readi+0x34>
    n = ip->size - off;
    80002ac0:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ac4:	080a8b63          	beqz	s5,80002b5a <readi+0xca>
    80002ac8:	e8ca                	sd	s2,80(sp)
    80002aca:	f062                	sd	s8,32(sp)
    80002acc:	ec66                	sd	s9,24(sp)
    80002ace:	e86a                	sd	s10,16(sp)
    80002ad0:	e46e                	sd	s11,8(sp)
    80002ad2:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ad4:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002ad8:	5c7d                	li	s8,-1
    80002ada:	a80d                	j	80002b0c <readi+0x7c>
    80002adc:	020d1d93          	slli	s11,s10,0x20
    80002ae0:	020ddd93          	srli	s11,s11,0x20
    80002ae4:	05890613          	addi	a2,s2,88
    80002ae8:	86ee                	mv	a3,s11
    80002aea:	963e                	add	a2,a2,a5
    80002aec:	85d2                	mv	a1,s4
    80002aee:	855e                	mv	a0,s7
    80002af0:	bf5fe0ef          	jal	800016e4 <either_copyout>
    80002af4:	05850363          	beq	a0,s8,80002b3a <readi+0xaa>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002af8:	854a                	mv	a0,s2
    80002afa:	e74ff0ef          	jal	8000216e <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002afe:	013d09bb          	addw	s3,s10,s3
    80002b02:	009d04bb          	addw	s1,s10,s1
    80002b06:	9a6e                	add	s4,s4,s11
    80002b08:	0559f363          	bgeu	s3,s5,80002b4e <readi+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80002b0c:	00a4d59b          	srliw	a1,s1,0xa
    80002b10:	855a                	mv	a0,s6
    80002b12:	8bbff0ef          	jal	800023cc <bmap>
    80002b16:	85aa                	mv	a1,a0
    if(addr == 0)
    80002b18:	c139                	beqz	a0,80002b5e <readi+0xce>
    bp = bread(ip->dev, addr);
    80002b1a:	000b2503          	lw	a0,0(s6)
    80002b1e:	d48ff0ef          	jal	80002066 <bread>
    80002b22:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002b24:	3ff4f793          	andi	a5,s1,1023
    80002b28:	40fc873b          	subw	a4,s9,a5
    80002b2c:	413a86bb          	subw	a3,s5,s3
    80002b30:	8d3a                	mv	s10,a4
    80002b32:	fae6f5e3          	bgeu	a3,a4,80002adc <readi+0x4c>
    80002b36:	8d36                	mv	s10,a3
    80002b38:	b755                	j	80002adc <readi+0x4c>
      brelse(bp);
    80002b3a:	854a                	mv	a0,s2
    80002b3c:	e32ff0ef          	jal	8000216e <brelse>
      tot = -1;
    80002b40:	59fd                	li	s3,-1
      break;
    80002b42:	6946                	ld	s2,80(sp)
    80002b44:	7c02                	ld	s8,32(sp)
    80002b46:	6ce2                	ld	s9,24(sp)
    80002b48:	6d42                	ld	s10,16(sp)
    80002b4a:	6da2                	ld	s11,8(sp)
    80002b4c:	a831                	j	80002b68 <readi+0xd8>
    80002b4e:	6946                	ld	s2,80(sp)
    80002b50:	7c02                	ld	s8,32(sp)
    80002b52:	6ce2                	ld	s9,24(sp)
    80002b54:	6d42                	ld	s10,16(sp)
    80002b56:	6da2                	ld	s11,8(sp)
    80002b58:	a801                	j	80002b68 <readi+0xd8>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002b5a:	89d6                	mv	s3,s5
    80002b5c:	a031                	j	80002b68 <readi+0xd8>
    80002b5e:	6946                	ld	s2,80(sp)
    80002b60:	7c02                	ld	s8,32(sp)
    80002b62:	6ce2                	ld	s9,24(sp)
    80002b64:	6d42                	ld	s10,16(sp)
    80002b66:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80002b68:	854e                	mv	a0,s3
    80002b6a:	69a6                	ld	s3,72(sp)
}
    80002b6c:	70a6                	ld	ra,104(sp)
    80002b6e:	7406                	ld	s0,96(sp)
    80002b70:	64e6                	ld	s1,88(sp)
    80002b72:	6a06                	ld	s4,64(sp)
    80002b74:	7ae2                	ld	s5,56(sp)
    80002b76:	7b42                	ld	s6,48(sp)
    80002b78:	7ba2                	ld	s7,40(sp)
    80002b7a:	6165                	addi	sp,sp,112
    80002b7c:	8082                	ret
    return 0;
    80002b7e:	4501                	li	a0,0
}
    80002b80:	8082                	ret

0000000080002b82 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002b82:	457c                	lw	a5,76(a0)
    80002b84:	0ed7eb63          	bltu	a5,a3,80002c7a <writei+0xf8>
{
    80002b88:	7159                	addi	sp,sp,-112
    80002b8a:	f486                	sd	ra,104(sp)
    80002b8c:	f0a2                	sd	s0,96(sp)
    80002b8e:	e8ca                	sd	s2,80(sp)
    80002b90:	e0d2                	sd	s4,64(sp)
    80002b92:	fc56                	sd	s5,56(sp)
    80002b94:	f85a                	sd	s6,48(sp)
    80002b96:	f45e                	sd	s7,40(sp)
    80002b98:	1880                	addi	s0,sp,112
    80002b9a:	8aaa                	mv	s5,a0
    80002b9c:	8bae                	mv	s7,a1
    80002b9e:	8a32                	mv	s4,a2
    80002ba0:	8936                	mv	s2,a3
    80002ba2:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002ba4:	00e687bb          	addw	a5,a3,a4
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002ba8:	00043737          	lui	a4,0x43
    80002bac:	0cf76963          	bltu	a4,a5,80002c7e <writei+0xfc>
    80002bb0:	0cd7e763          	bltu	a5,a3,80002c7e <writei+0xfc>
    80002bb4:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002bb6:	0a0b0a63          	beqz	s6,80002c6a <writei+0xe8>
    80002bba:	eca6                	sd	s1,88(sp)
    80002bbc:	f062                	sd	s8,32(sp)
    80002bbe:	ec66                	sd	s9,24(sp)
    80002bc0:	e86a                	sd	s10,16(sp)
    80002bc2:	e46e                	sd	s11,8(sp)
    80002bc4:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002bc6:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002bca:	5c7d                	li	s8,-1
    80002bcc:	a825                	j	80002c04 <writei+0x82>
    80002bce:	020d1d93          	slli	s11,s10,0x20
    80002bd2:	020ddd93          	srli	s11,s11,0x20
    80002bd6:	05848513          	addi	a0,s1,88
    80002bda:	86ee                	mv	a3,s11
    80002bdc:	8652                	mv	a2,s4
    80002bde:	85de                	mv	a1,s7
    80002be0:	953e                	add	a0,a0,a5
    80002be2:	b4dfe0ef          	jal	8000172e <either_copyin>
    80002be6:	05850663          	beq	a0,s8,80002c32 <writei+0xb0>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002bea:	8526                	mv	a0,s1
    80002bec:	6b8000ef          	jal	800032a4 <log_write>
    brelse(bp);
    80002bf0:	8526                	mv	a0,s1
    80002bf2:	d7cff0ef          	jal	8000216e <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002bf6:	013d09bb          	addw	s3,s10,s3
    80002bfa:	012d093b          	addw	s2,s10,s2
    80002bfe:	9a6e                	add	s4,s4,s11
    80002c00:	0369fc63          	bgeu	s3,s6,80002c38 <writei+0xb6>
    uint addr = bmap(ip, off/BSIZE);
    80002c04:	00a9559b          	srliw	a1,s2,0xa
    80002c08:	8556                	mv	a0,s5
    80002c0a:	fc2ff0ef          	jal	800023cc <bmap>
    80002c0e:	85aa                	mv	a1,a0
    if(addr == 0)
    80002c10:	c505                	beqz	a0,80002c38 <writei+0xb6>
    bp = bread(ip->dev, addr);
    80002c12:	000aa503          	lw	a0,0(s5)
    80002c16:	c50ff0ef          	jal	80002066 <bread>
    80002c1a:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002c1c:	3ff97793          	andi	a5,s2,1023
    80002c20:	40fc873b          	subw	a4,s9,a5
    80002c24:	413b06bb          	subw	a3,s6,s3
    80002c28:	8d3a                	mv	s10,a4
    80002c2a:	fae6f2e3          	bgeu	a3,a4,80002bce <writei+0x4c>
    80002c2e:	8d36                	mv	s10,a3
    80002c30:	bf79                	j	80002bce <writei+0x4c>
      brelse(bp);
    80002c32:	8526                	mv	a0,s1
    80002c34:	d3aff0ef          	jal	8000216e <brelse>
  }

  if(off > ip->size)
    80002c38:	04caa783          	lw	a5,76(s5)
    80002c3c:	0327f963          	bgeu	a5,s2,80002c6e <writei+0xec>
    ip->size = off;
    80002c40:	052aa623          	sw	s2,76(s5)
    80002c44:	64e6                	ld	s1,88(sp)
    80002c46:	7c02                	ld	s8,32(sp)
    80002c48:	6ce2                	ld	s9,24(sp)
    80002c4a:	6d42                	ld	s10,16(sp)
    80002c4c:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002c4e:	8556                	mv	a0,s5
    80002c50:	9fbff0ef          	jal	8000264a <iupdate>

  return tot;
    80002c54:	854e                	mv	a0,s3
    80002c56:	69a6                	ld	s3,72(sp)
}
    80002c58:	70a6                	ld	ra,104(sp)
    80002c5a:	7406                	ld	s0,96(sp)
    80002c5c:	6946                	ld	s2,80(sp)
    80002c5e:	6a06                	ld	s4,64(sp)
    80002c60:	7ae2                	ld	s5,56(sp)
    80002c62:	7b42                	ld	s6,48(sp)
    80002c64:	7ba2                	ld	s7,40(sp)
    80002c66:	6165                	addi	sp,sp,112
    80002c68:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002c6a:	89da                	mv	s3,s6
    80002c6c:	b7cd                	j	80002c4e <writei+0xcc>
    80002c6e:	64e6                	ld	s1,88(sp)
    80002c70:	7c02                	ld	s8,32(sp)
    80002c72:	6ce2                	ld	s9,24(sp)
    80002c74:	6d42                	ld	s10,16(sp)
    80002c76:	6da2                	ld	s11,8(sp)
    80002c78:	bfd9                	j	80002c4e <writei+0xcc>
    return -1;
    80002c7a:	557d                	li	a0,-1
}
    80002c7c:	8082                	ret
    return -1;
    80002c7e:	557d                	li	a0,-1
    80002c80:	bfe1                	j	80002c58 <writei+0xd6>

0000000080002c82 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002c82:	1141                	addi	sp,sp,-16
    80002c84:	e406                	sd	ra,8(sp)
    80002c86:	e022                	sd	s0,0(sp)
    80002c88:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002c8a:	4639                	li	a2,14
    80002c8c:	da6fd0ef          	jal	80000232 <strncmp>
}
    80002c90:	60a2                	ld	ra,8(sp)
    80002c92:	6402                	ld	s0,0(sp)
    80002c94:	0141                	addi	sp,sp,16
    80002c96:	8082                	ret

0000000080002c98 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002c98:	711d                	addi	sp,sp,-96
    80002c9a:	ec86                	sd	ra,88(sp)
    80002c9c:	e8a2                	sd	s0,80(sp)
    80002c9e:	e4a6                	sd	s1,72(sp)
    80002ca0:	e0ca                	sd	s2,64(sp)
    80002ca2:	fc4e                	sd	s3,56(sp)
    80002ca4:	f852                	sd	s4,48(sp)
    80002ca6:	f456                	sd	s5,40(sp)
    80002ca8:	f05a                	sd	s6,32(sp)
    80002caa:	ec5e                	sd	s7,24(sp)
    80002cac:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002cae:	04451703          	lh	a4,68(a0)
    80002cb2:	4785                	li	a5,1
    80002cb4:	00f71f63          	bne	a4,a5,80002cd2 <dirlookup+0x3a>
    80002cb8:	892a                	mv	s2,a0
    80002cba:	8aae                	mv	s5,a1
    80002cbc:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002cbe:	457c                	lw	a5,76(a0)
    80002cc0:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002cc2:	fa040a13          	addi	s4,s0,-96
    80002cc6:	49c1                	li	s3,16
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
    80002cc8:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002ccc:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002cce:	e39d                	bnez	a5,80002cf4 <dirlookup+0x5c>
    80002cd0:	a8b9                	j	80002d2e <dirlookup+0x96>
    panic("dirlookup not DIR");
    80002cd2:	00004517          	auipc	a0,0x4
    80002cd6:	76e50513          	addi	a0,a0,1902 # 80007440 <etext+0x440>
    80002cda:	285020ef          	jal	8000575e <panic>
      panic("dirlookup read");
    80002cde:	00004517          	auipc	a0,0x4
    80002ce2:	77a50513          	addi	a0,a0,1914 # 80007458 <etext+0x458>
    80002ce6:	279020ef          	jal	8000575e <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002cea:	24c1                	addiw	s1,s1,16
    80002cec:	04c92783          	lw	a5,76(s2)
    80002cf0:	02f4fe63          	bgeu	s1,a5,80002d2c <dirlookup+0x94>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002cf4:	874e                	mv	a4,s3
    80002cf6:	86a6                	mv	a3,s1
    80002cf8:	8652                	mv	a2,s4
    80002cfa:	4581                	li	a1,0
    80002cfc:	854a                	mv	a0,s2
    80002cfe:	d93ff0ef          	jal	80002a90 <readi>
    80002d02:	fd351ee3          	bne	a0,s3,80002cde <dirlookup+0x46>
    if(de.inum == 0)
    80002d06:	fa045783          	lhu	a5,-96(s0)
    80002d0a:	d3e5                	beqz	a5,80002cea <dirlookup+0x52>
    if(namecmp(name, de.name) == 0){
    80002d0c:	85da                	mv	a1,s6
    80002d0e:	8556                	mv	a0,s5
    80002d10:	f73ff0ef          	jal	80002c82 <namecmp>
    80002d14:	f979                	bnez	a0,80002cea <dirlookup+0x52>
      if(poff)
    80002d16:	000b8463          	beqz	s7,80002d1e <dirlookup+0x86>
        *poff = off;
    80002d1a:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    80002d1e:	fa045583          	lhu	a1,-96(s0)
    80002d22:	00092503          	lw	a0,0(s2)
    80002d26:	f66ff0ef          	jal	8000248c <iget>
    80002d2a:	a011                	j	80002d2e <dirlookup+0x96>
  return 0;
    80002d2c:	4501                	li	a0,0
}
    80002d2e:	60e6                	ld	ra,88(sp)
    80002d30:	6446                	ld	s0,80(sp)
    80002d32:	64a6                	ld	s1,72(sp)
    80002d34:	6906                	ld	s2,64(sp)
    80002d36:	79e2                	ld	s3,56(sp)
    80002d38:	7a42                	ld	s4,48(sp)
    80002d3a:	7aa2                	ld	s5,40(sp)
    80002d3c:	7b02                	ld	s6,32(sp)
    80002d3e:	6be2                	ld	s7,24(sp)
    80002d40:	6125                	addi	sp,sp,96
    80002d42:	8082                	ret

0000000080002d44 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80002d44:	711d                	addi	sp,sp,-96
    80002d46:	ec86                	sd	ra,88(sp)
    80002d48:	e8a2                	sd	s0,80(sp)
    80002d4a:	e4a6                	sd	s1,72(sp)
    80002d4c:	e0ca                	sd	s2,64(sp)
    80002d4e:	fc4e                	sd	s3,56(sp)
    80002d50:	f852                	sd	s4,48(sp)
    80002d52:	f456                	sd	s5,40(sp)
    80002d54:	f05a                	sd	s6,32(sp)
    80002d56:	ec5e                	sd	s7,24(sp)
    80002d58:	e862                	sd	s8,16(sp)
    80002d5a:	e466                	sd	s9,8(sp)
    80002d5c:	e06a                	sd	s10,0(sp)
    80002d5e:	1080                	addi	s0,sp,96
    80002d60:	84aa                	mv	s1,a0
    80002d62:	8b2e                	mv	s6,a1
    80002d64:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80002d66:	00054703          	lbu	a4,0(a0)
    80002d6a:	02f00793          	li	a5,47
    80002d6e:	00f70f63          	beq	a4,a5,80002d8c <namex+0x48>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80002d72:	80afe0ef          	jal	80000d7c <myproc>
    80002d76:	15053503          	ld	a0,336(a0)
    80002d7a:	94fff0ef          	jal	800026c8 <idup>
    80002d7e:	8a2a                	mv	s4,a0
  while(*path == '/')
    80002d80:	02f00993          	li	s3,47
  if(len >= DIRSIZ)
    80002d84:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    80002d86:	4cb9                	li	s9,14

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80002d88:	4b85                	li	s7,1
    80002d8a:	a879                	j	80002e28 <namex+0xe4>
    ip = iget(ROOTDEV, ROOTINO);
    80002d8c:	4585                	li	a1,1
    80002d8e:	852e                	mv	a0,a1
    80002d90:	efcff0ef          	jal	8000248c <iget>
    80002d94:	8a2a                	mv	s4,a0
    80002d96:	b7ed                	j	80002d80 <namex+0x3c>
      iunlockput(ip);
    80002d98:	8552                	mv	a0,s4
    80002d9a:	b71ff0ef          	jal	8000290a <iunlockput>
      return 0;
    80002d9e:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80002da0:	8552                	mv	a0,s4
    80002da2:	60e6                	ld	ra,88(sp)
    80002da4:	6446                	ld	s0,80(sp)
    80002da6:	64a6                	ld	s1,72(sp)
    80002da8:	6906                	ld	s2,64(sp)
    80002daa:	79e2                	ld	s3,56(sp)
    80002dac:	7a42                	ld	s4,48(sp)
    80002dae:	7aa2                	ld	s5,40(sp)
    80002db0:	7b02                	ld	s6,32(sp)
    80002db2:	6be2                	ld	s7,24(sp)
    80002db4:	6c42                	ld	s8,16(sp)
    80002db6:	6ca2                	ld	s9,8(sp)
    80002db8:	6d02                	ld	s10,0(sp)
    80002dba:	6125                	addi	sp,sp,96
    80002dbc:	8082                	ret
      iunlock(ip);
    80002dbe:	8552                	mv	a0,s4
    80002dc0:	9edff0ef          	jal	800027ac <iunlock>
      return ip;
    80002dc4:	bff1                	j	80002da0 <namex+0x5c>
      iunlockput(ip);
    80002dc6:	8552                	mv	a0,s4
    80002dc8:	b43ff0ef          	jal	8000290a <iunlockput>
      return 0;
    80002dcc:	8a4a                	mv	s4,s2
    80002dce:	bfc9                	j	80002da0 <namex+0x5c>
  len = path - s;
    80002dd0:	40990633          	sub	a2,s2,s1
    80002dd4:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    80002dd8:	09ac5463          	bge	s8,s10,80002e60 <namex+0x11c>
    memmove(name, s, DIRSIZ);
    80002ddc:	8666                	mv	a2,s9
    80002dde:	85a6                	mv	a1,s1
    80002de0:	8556                	mv	a0,s5
    80002de2:	bdcfd0ef          	jal	800001be <memmove>
    80002de6:	84ca                	mv	s1,s2
  while(*path == '/')
    80002de8:	0004c783          	lbu	a5,0(s1)
    80002dec:	01379763          	bne	a5,s3,80002dfa <namex+0xb6>
    path++;
    80002df0:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002df2:	0004c783          	lbu	a5,0(s1)
    80002df6:	ff378de3          	beq	a5,s3,80002df0 <namex+0xac>
    ilock(ip);
    80002dfa:	8552                	mv	a0,s4
    80002dfc:	903ff0ef          	jal	800026fe <ilock>
    if(ip->type != T_DIR){
    80002e00:	044a1783          	lh	a5,68(s4)
    80002e04:	f9779ae3          	bne	a5,s7,80002d98 <namex+0x54>
    if(nameiparent && *path == '\0'){
    80002e08:	000b0563          	beqz	s6,80002e12 <namex+0xce>
    80002e0c:	0004c783          	lbu	a5,0(s1)
    80002e10:	d7dd                	beqz	a5,80002dbe <namex+0x7a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80002e12:	4601                	li	a2,0
    80002e14:	85d6                	mv	a1,s5
    80002e16:	8552                	mv	a0,s4
    80002e18:	e81ff0ef          	jal	80002c98 <dirlookup>
    80002e1c:	892a                	mv	s2,a0
    80002e1e:	d545                	beqz	a0,80002dc6 <namex+0x82>
    iunlockput(ip);
    80002e20:	8552                	mv	a0,s4
    80002e22:	ae9ff0ef          	jal	8000290a <iunlockput>
    ip = next;
    80002e26:	8a4a                	mv	s4,s2
  while(*path == '/')
    80002e28:	0004c783          	lbu	a5,0(s1)
    80002e2c:	01379763          	bne	a5,s3,80002e3a <namex+0xf6>
    path++;
    80002e30:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002e32:	0004c783          	lbu	a5,0(s1)
    80002e36:	ff378de3          	beq	a5,s3,80002e30 <namex+0xec>
  if(*path == 0)
    80002e3a:	cf8d                	beqz	a5,80002e74 <namex+0x130>
  while(*path != '/' && *path != 0)
    80002e3c:	0004c783          	lbu	a5,0(s1)
    80002e40:	fd178713          	addi	a4,a5,-47
    80002e44:	cb19                	beqz	a4,80002e5a <namex+0x116>
    80002e46:	cb91                	beqz	a5,80002e5a <namex+0x116>
    80002e48:	8926                	mv	s2,s1
    path++;
    80002e4a:	0905                	addi	s2,s2,1
  while(*path != '/' && *path != 0)
    80002e4c:	00094783          	lbu	a5,0(s2)
    80002e50:	fd178713          	addi	a4,a5,-47
    80002e54:	df35                	beqz	a4,80002dd0 <namex+0x8c>
    80002e56:	fbf5                	bnez	a5,80002e4a <namex+0x106>
    80002e58:	bfa5                	j	80002dd0 <namex+0x8c>
    80002e5a:	8926                	mv	s2,s1
  len = path - s;
    80002e5c:	4d01                	li	s10,0
    80002e5e:	4601                	li	a2,0
    memmove(name, s, len);
    80002e60:	2601                	sext.w	a2,a2
    80002e62:	85a6                	mv	a1,s1
    80002e64:	8556                	mv	a0,s5
    80002e66:	b58fd0ef          	jal	800001be <memmove>
    name[len] = 0;
    80002e6a:	9d56                	add	s10,s10,s5
    80002e6c:	000d0023          	sb	zero,0(s10) # fffffffffffff000 <end+0xffffffff7ffd9468>
    80002e70:	84ca                	mv	s1,s2
    80002e72:	bf9d                	j	80002de8 <namex+0xa4>
  if(nameiparent){
    80002e74:	f20b06e3          	beqz	s6,80002da0 <namex+0x5c>
    iput(ip);
    80002e78:	8552                	mv	a0,s4
    80002e7a:	a07ff0ef          	jal	80002880 <iput>
    return 0;
    80002e7e:	4a01                	li	s4,0
    80002e80:	b705                	j	80002da0 <namex+0x5c>

0000000080002e82 <dirlink>:
{
    80002e82:	715d                	addi	sp,sp,-80
    80002e84:	e486                	sd	ra,72(sp)
    80002e86:	e0a2                	sd	s0,64(sp)
    80002e88:	f84a                	sd	s2,48(sp)
    80002e8a:	ec56                	sd	s5,24(sp)
    80002e8c:	e85a                	sd	s6,16(sp)
    80002e8e:	0880                	addi	s0,sp,80
    80002e90:	892a                	mv	s2,a0
    80002e92:	8aae                	mv	s5,a1
    80002e94:	8b32                	mv	s6,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80002e96:	4601                	li	a2,0
    80002e98:	e01ff0ef          	jal	80002c98 <dirlookup>
    80002e9c:	ed1d                	bnez	a0,80002eda <dirlink+0x58>
    80002e9e:	fc26                	sd	s1,56(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002ea0:	04c92483          	lw	s1,76(s2)
    80002ea4:	c4b9                	beqz	s1,80002ef2 <dirlink+0x70>
    80002ea6:	f44e                	sd	s3,40(sp)
    80002ea8:	f052                	sd	s4,32(sp)
    80002eaa:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002eac:	fb040a13          	addi	s4,s0,-80
    80002eb0:	49c1                	li	s3,16
    80002eb2:	874e                	mv	a4,s3
    80002eb4:	86a6                	mv	a3,s1
    80002eb6:	8652                	mv	a2,s4
    80002eb8:	4581                	li	a1,0
    80002eba:	854a                	mv	a0,s2
    80002ebc:	bd5ff0ef          	jal	80002a90 <readi>
    80002ec0:	03351163          	bne	a0,s3,80002ee2 <dirlink+0x60>
    if(de.inum == 0)
    80002ec4:	fb045783          	lhu	a5,-80(s0)
    80002ec8:	c39d                	beqz	a5,80002eee <dirlink+0x6c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002eca:	24c1                	addiw	s1,s1,16
    80002ecc:	04c92783          	lw	a5,76(s2)
    80002ed0:	fef4e1e3          	bltu	s1,a5,80002eb2 <dirlink+0x30>
    80002ed4:	79a2                	ld	s3,40(sp)
    80002ed6:	7a02                	ld	s4,32(sp)
    80002ed8:	a829                	j	80002ef2 <dirlink+0x70>
    iput(ip);
    80002eda:	9a7ff0ef          	jal	80002880 <iput>
    return -1;
    80002ede:	557d                	li	a0,-1
    80002ee0:	a83d                	j	80002f1e <dirlink+0x9c>
      panic("dirlink read");
    80002ee2:	00004517          	auipc	a0,0x4
    80002ee6:	58650513          	addi	a0,a0,1414 # 80007468 <etext+0x468>
    80002eea:	075020ef          	jal	8000575e <panic>
    80002eee:	79a2                	ld	s3,40(sp)
    80002ef0:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    80002ef2:	4639                	li	a2,14
    80002ef4:	85d6                	mv	a1,s5
    80002ef6:	fb240513          	addi	a0,s0,-78
    80002efa:	b72fd0ef          	jal	8000026c <strncpy>
  de.inum = inum;
    80002efe:	fb641823          	sh	s6,-80(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002f02:	4741                	li	a4,16
    80002f04:	86a6                	mv	a3,s1
    80002f06:	fb040613          	addi	a2,s0,-80
    80002f0a:	4581                	li	a1,0
    80002f0c:	854a                	mv	a0,s2
    80002f0e:	c75ff0ef          	jal	80002b82 <writei>
    80002f12:	1541                	addi	a0,a0,-16
    80002f14:	00a03533          	snez	a0,a0
    80002f18:	40a0053b          	negw	a0,a0
    80002f1c:	74e2                	ld	s1,56(sp)
}
    80002f1e:	60a6                	ld	ra,72(sp)
    80002f20:	6406                	ld	s0,64(sp)
    80002f22:	7942                	ld	s2,48(sp)
    80002f24:	6ae2                	ld	s5,24(sp)
    80002f26:	6b42                	ld	s6,16(sp)
    80002f28:	6161                	addi	sp,sp,80
    80002f2a:	8082                	ret

0000000080002f2c <namei>:

struct inode*
namei(char *path)
{
    80002f2c:	1101                	addi	sp,sp,-32
    80002f2e:	ec06                	sd	ra,24(sp)
    80002f30:	e822                	sd	s0,16(sp)
    80002f32:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80002f34:	fe040613          	addi	a2,s0,-32
    80002f38:	4581                	li	a1,0
    80002f3a:	e0bff0ef          	jal	80002d44 <namex>
}
    80002f3e:	60e2                	ld	ra,24(sp)
    80002f40:	6442                	ld	s0,16(sp)
    80002f42:	6105                	addi	sp,sp,32
    80002f44:	8082                	ret

0000000080002f46 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80002f46:	1141                	addi	sp,sp,-16
    80002f48:	e406                	sd	ra,8(sp)
    80002f4a:	e022                	sd	s0,0(sp)
    80002f4c:	0800                	addi	s0,sp,16
    80002f4e:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80002f50:	4585                	li	a1,1
    80002f52:	df3ff0ef          	jal	80002d44 <namex>
}
    80002f56:	60a2                	ld	ra,8(sp)
    80002f58:	6402                	ld	s0,0(sp)
    80002f5a:	0141                	addi	sp,sp,16
    80002f5c:	8082                	ret

0000000080002f5e <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80002f5e:	1101                	addi	sp,sp,-32
    80002f60:	ec06                	sd	ra,24(sp)
    80002f62:	e822                	sd	s0,16(sp)
    80002f64:	e426                	sd	s1,8(sp)
    80002f66:	e04a                	sd	s2,0(sp)
    80002f68:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80002f6a:	0001a917          	auipc	s2,0x1a
    80002f6e:	91690913          	addi	s2,s2,-1770 # 8001c880 <log>
    80002f72:	01892583          	lw	a1,24(s2)
    80002f76:	02492503          	lw	a0,36(s2)
    80002f7a:	8ecff0ef          	jal	80002066 <bread>
    80002f7e:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80002f80:	02892603          	lw	a2,40(s2)
    80002f84:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80002f86:	00c05f63          	blez	a2,80002fa4 <write_head+0x46>
    80002f8a:	0001a717          	auipc	a4,0x1a
    80002f8e:	92270713          	addi	a4,a4,-1758 # 8001c8ac <log+0x2c>
    80002f92:	87aa                	mv	a5,a0
    80002f94:	060a                	slli	a2,a2,0x2
    80002f96:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80002f98:	4314                	lw	a3,0(a4)
    80002f9a:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80002f9c:	0711                	addi	a4,a4,4
    80002f9e:	0791                	addi	a5,a5,4
    80002fa0:	fec79ce3          	bne	a5,a2,80002f98 <write_head+0x3a>
  }
  bwrite(buf);
    80002fa4:	8526                	mv	a0,s1
    80002fa6:	996ff0ef          	jal	8000213c <bwrite>
  brelse(buf);
    80002faa:	8526                	mv	a0,s1
    80002fac:	9c2ff0ef          	jal	8000216e <brelse>
}
    80002fb0:	60e2                	ld	ra,24(sp)
    80002fb2:	6442                	ld	s0,16(sp)
    80002fb4:	64a2                	ld	s1,8(sp)
    80002fb6:	6902                	ld	s2,0(sp)
    80002fb8:	6105                	addi	sp,sp,32
    80002fba:	8082                	ret

0000000080002fbc <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80002fbc:	0001a797          	auipc	a5,0x1a
    80002fc0:	8ec7a783          	lw	a5,-1812(a5) # 8001c8a8 <log+0x28>
    80002fc4:	0cf05163          	blez	a5,80003086 <install_trans+0xca>
{
    80002fc8:	715d                	addi	sp,sp,-80
    80002fca:	e486                	sd	ra,72(sp)
    80002fcc:	e0a2                	sd	s0,64(sp)
    80002fce:	fc26                	sd	s1,56(sp)
    80002fd0:	f84a                	sd	s2,48(sp)
    80002fd2:	f44e                	sd	s3,40(sp)
    80002fd4:	f052                	sd	s4,32(sp)
    80002fd6:	ec56                	sd	s5,24(sp)
    80002fd8:	e85a                	sd	s6,16(sp)
    80002fda:	e45e                	sd	s7,8(sp)
    80002fdc:	e062                	sd	s8,0(sp)
    80002fde:	0880                	addi	s0,sp,80
    80002fe0:	8b2a                	mv	s6,a0
    80002fe2:	0001aa97          	auipc	s5,0x1a
    80002fe6:	8caa8a93          	addi	s5,s5,-1846 # 8001c8ac <log+0x2c>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002fea:	4981                	li	s3,0
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80002fec:	00004c17          	auipc	s8,0x4
    80002ff0:	48cc0c13          	addi	s8,s8,1164 # 80007478 <etext+0x478>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002ff4:	0001aa17          	auipc	s4,0x1a
    80002ff8:	88ca0a13          	addi	s4,s4,-1908 # 8001c880 <log>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80002ffc:	40000b93          	li	s7,1024
    80003000:	a025                	j	80003028 <install_trans+0x6c>
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80003002:	000aa603          	lw	a2,0(s5)
    80003006:	85ce                	mv	a1,s3
    80003008:	8562                	mv	a0,s8
    8000300a:	3b2020ef          	jal	800053bc <printf>
    8000300e:	a839                	j	8000302c <install_trans+0x70>
    brelse(lbuf);
    80003010:	854a                	mv	a0,s2
    80003012:	95cff0ef          	jal	8000216e <brelse>
    brelse(dbuf);
    80003016:	8526                	mv	a0,s1
    80003018:	956ff0ef          	jal	8000216e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000301c:	2985                	addiw	s3,s3,1
    8000301e:	0a91                	addi	s5,s5,4
    80003020:	028a2783          	lw	a5,40(s4)
    80003024:	04f9d563          	bge	s3,a5,8000306e <install_trans+0xb2>
    if(recovering) {
    80003028:	fc0b1de3          	bnez	s6,80003002 <install_trans+0x46>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000302c:	018a2583          	lw	a1,24(s4)
    80003030:	013585bb          	addw	a1,a1,s3
    80003034:	2585                	addiw	a1,a1,1
    80003036:	024a2503          	lw	a0,36(s4)
    8000303a:	82cff0ef          	jal	80002066 <bread>
    8000303e:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003040:	000aa583          	lw	a1,0(s5)
    80003044:	024a2503          	lw	a0,36(s4)
    80003048:	81eff0ef          	jal	80002066 <bread>
    8000304c:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000304e:	865e                	mv	a2,s7
    80003050:	05890593          	addi	a1,s2,88
    80003054:	05850513          	addi	a0,a0,88
    80003058:	966fd0ef          	jal	800001be <memmove>
    bwrite(dbuf);  // write dst to disk
    8000305c:	8526                	mv	a0,s1
    8000305e:	8deff0ef          	jal	8000213c <bwrite>
    if(recovering == 0)
    80003062:	fa0b17e3          	bnez	s6,80003010 <install_trans+0x54>
      bunpin(dbuf);
    80003066:	8526                	mv	a0,s1
    80003068:	9beff0ef          	jal	80002226 <bunpin>
    8000306c:	b755                	j	80003010 <install_trans+0x54>
}
    8000306e:	60a6                	ld	ra,72(sp)
    80003070:	6406                	ld	s0,64(sp)
    80003072:	74e2                	ld	s1,56(sp)
    80003074:	7942                	ld	s2,48(sp)
    80003076:	79a2                	ld	s3,40(sp)
    80003078:	7a02                	ld	s4,32(sp)
    8000307a:	6ae2                	ld	s5,24(sp)
    8000307c:	6b42                	ld	s6,16(sp)
    8000307e:	6ba2                	ld	s7,8(sp)
    80003080:	6c02                	ld	s8,0(sp)
    80003082:	6161                	addi	sp,sp,80
    80003084:	8082                	ret
    80003086:	8082                	ret

0000000080003088 <initlog>:
{
    80003088:	7179                	addi	sp,sp,-48
    8000308a:	f406                	sd	ra,40(sp)
    8000308c:	f022                	sd	s0,32(sp)
    8000308e:	ec26                	sd	s1,24(sp)
    80003090:	e84a                	sd	s2,16(sp)
    80003092:	e44e                	sd	s3,8(sp)
    80003094:	1800                	addi	s0,sp,48
    80003096:	84aa                	mv	s1,a0
    80003098:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000309a:	00019917          	auipc	s2,0x19
    8000309e:	7e690913          	addi	s2,s2,2022 # 8001c880 <log>
    800030a2:	00004597          	auipc	a1,0x4
    800030a6:	3f658593          	addi	a1,a1,1014 # 80007498 <etext+0x498>
    800030aa:	854a                	mv	a0,s2
    800030ac:	0cb020ef          	jal	80005976 <initlock>
  log.start = sb->logstart;
    800030b0:	0149a583          	lw	a1,20(s3)
    800030b4:	00b92c23          	sw	a1,24(s2)
  log.dev = dev;
    800030b8:	02992223          	sw	s1,36(s2)
  struct buf *buf = bread(log.dev, log.start);
    800030bc:	8526                	mv	a0,s1
    800030be:	fa9fe0ef          	jal	80002066 <bread>
  log.lh.n = lh->n;
    800030c2:	4d30                	lw	a2,88(a0)
    800030c4:	02c92423          	sw	a2,40(s2)
  for (i = 0; i < log.lh.n; i++) {
    800030c8:	00c05f63          	blez	a2,800030e6 <initlog+0x5e>
    800030cc:	87aa                	mv	a5,a0
    800030ce:	00019717          	auipc	a4,0x19
    800030d2:	7de70713          	addi	a4,a4,2014 # 8001c8ac <log+0x2c>
    800030d6:	060a                	slli	a2,a2,0x2
    800030d8:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    800030da:	4ff4                	lw	a3,92(a5)
    800030dc:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800030de:	0791                	addi	a5,a5,4
    800030e0:	0711                	addi	a4,a4,4
    800030e2:	fec79ce3          	bne	a5,a2,800030da <initlog+0x52>
  brelse(buf);
    800030e6:	888ff0ef          	jal	8000216e <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800030ea:	4505                	li	a0,1
    800030ec:	ed1ff0ef          	jal	80002fbc <install_trans>
  log.lh.n = 0;
    800030f0:	00019797          	auipc	a5,0x19
    800030f4:	7a07ac23          	sw	zero,1976(a5) # 8001c8a8 <log+0x28>
  write_head(); // clear the log
    800030f8:	e67ff0ef          	jal	80002f5e <write_head>
}
    800030fc:	70a2                	ld	ra,40(sp)
    800030fe:	7402                	ld	s0,32(sp)
    80003100:	64e2                	ld	s1,24(sp)
    80003102:	6942                	ld	s2,16(sp)
    80003104:	69a2                	ld	s3,8(sp)
    80003106:	6145                	addi	sp,sp,48
    80003108:	8082                	ret

000000008000310a <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000310a:	1101                	addi	sp,sp,-32
    8000310c:	ec06                	sd	ra,24(sp)
    8000310e:	e822                	sd	s0,16(sp)
    80003110:	e426                	sd	s1,8(sp)
    80003112:	e04a                	sd	s2,0(sp)
    80003114:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003116:	00019517          	auipc	a0,0x19
    8000311a:	76a50513          	addi	a0,a0,1898 # 8001c880 <log>
    8000311e:	0e3020ef          	jal	80005a00 <acquire>
  while(1){
    if(log.committing){
    80003122:	00019497          	auipc	s1,0x19
    80003126:	75e48493          	addi	s1,s1,1886 # 8001c880 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    8000312a:	4979                	li	s2,30
    8000312c:	a029                	j	80003136 <begin_op+0x2c>
      sleep(&log, &log.lock);
    8000312e:	85a6                	mv	a1,s1
    80003130:	8526                	mv	a0,s1
    80003132:	a58fe0ef          	jal	8000138a <sleep>
    if(log.committing){
    80003136:	509c                	lw	a5,32(s1)
    80003138:	fbfd                	bnez	a5,8000312e <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    8000313a:	4cd8                	lw	a4,28(s1)
    8000313c:	2705                	addiw	a4,a4,1
    8000313e:	0027179b          	slliw	a5,a4,0x2
    80003142:	9fb9                	addw	a5,a5,a4
    80003144:	0017979b          	slliw	a5,a5,0x1
    80003148:	5494                	lw	a3,40(s1)
    8000314a:	9fb5                	addw	a5,a5,a3
    8000314c:	00f95763          	bge	s2,a5,8000315a <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003150:	85a6                	mv	a1,s1
    80003152:	8526                	mv	a0,s1
    80003154:	a36fe0ef          	jal	8000138a <sleep>
    80003158:	bff9                	j	80003136 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    8000315a:	00019797          	auipc	a5,0x19
    8000315e:	74e7a123          	sw	a4,1858(a5) # 8001c89c <log+0x1c>
      release(&log.lock);
    80003162:	00019517          	auipc	a0,0x19
    80003166:	71e50513          	addi	a0,a0,1822 # 8001c880 <log>
    8000316a:	12b020ef          	jal	80005a94 <release>
      break;
    }
  }
}
    8000316e:	60e2                	ld	ra,24(sp)
    80003170:	6442                	ld	s0,16(sp)
    80003172:	64a2                	ld	s1,8(sp)
    80003174:	6902                	ld	s2,0(sp)
    80003176:	6105                	addi	sp,sp,32
    80003178:	8082                	ret

000000008000317a <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000317a:	7139                	addi	sp,sp,-64
    8000317c:	fc06                	sd	ra,56(sp)
    8000317e:	f822                	sd	s0,48(sp)
    80003180:	f426                	sd	s1,40(sp)
    80003182:	f04a                	sd	s2,32(sp)
    80003184:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003186:	00019497          	auipc	s1,0x19
    8000318a:	6fa48493          	addi	s1,s1,1786 # 8001c880 <log>
    8000318e:	8526                	mv	a0,s1
    80003190:	071020ef          	jal	80005a00 <acquire>
  log.outstanding -= 1;
    80003194:	4cdc                	lw	a5,28(s1)
    80003196:	37fd                	addiw	a5,a5,-1
    80003198:	893e                	mv	s2,a5
    8000319a:	ccdc                	sw	a5,28(s1)
  if(log.committing)
    8000319c:	509c                	lw	a5,32(s1)
    8000319e:	e7b1                	bnez	a5,800031ea <end_op+0x70>
    panic("log.committing");
  if(log.outstanding == 0){
    800031a0:	04091e63          	bnez	s2,800031fc <end_op+0x82>
    do_commit = 1;
    log.committing = 1;
    800031a4:	00019497          	auipc	s1,0x19
    800031a8:	6dc48493          	addi	s1,s1,1756 # 8001c880 <log>
    800031ac:	4785                	li	a5,1
    800031ae:	d09c                	sw	a5,32(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800031b0:	8526                	mv	a0,s1
    800031b2:	0e3020ef          	jal	80005a94 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800031b6:	549c                	lw	a5,40(s1)
    800031b8:	06f04463          	bgtz	a5,80003220 <end_op+0xa6>
    acquire(&log.lock);
    800031bc:	00019517          	auipc	a0,0x19
    800031c0:	6c450513          	addi	a0,a0,1732 # 8001c880 <log>
    800031c4:	03d020ef          	jal	80005a00 <acquire>
    log.committing = 0;
    800031c8:	00019797          	auipc	a5,0x19
    800031cc:	6c07ac23          	sw	zero,1752(a5) # 8001c8a0 <log+0x20>
    wakeup(&log);
    800031d0:	00019517          	auipc	a0,0x19
    800031d4:	6b050513          	addi	a0,a0,1712 # 8001c880 <log>
    800031d8:	9fefe0ef          	jal	800013d6 <wakeup>
    release(&log.lock);
    800031dc:	00019517          	auipc	a0,0x19
    800031e0:	6a450513          	addi	a0,a0,1700 # 8001c880 <log>
    800031e4:	0b1020ef          	jal	80005a94 <release>
}
    800031e8:	a035                	j	80003214 <end_op+0x9a>
    800031ea:	ec4e                	sd	s3,24(sp)
    800031ec:	e852                	sd	s4,16(sp)
    800031ee:	e456                	sd	s5,8(sp)
    panic("log.committing");
    800031f0:	00004517          	auipc	a0,0x4
    800031f4:	2b050513          	addi	a0,a0,688 # 800074a0 <etext+0x4a0>
    800031f8:	566020ef          	jal	8000575e <panic>
    wakeup(&log);
    800031fc:	00019517          	auipc	a0,0x19
    80003200:	68450513          	addi	a0,a0,1668 # 8001c880 <log>
    80003204:	9d2fe0ef          	jal	800013d6 <wakeup>
  release(&log.lock);
    80003208:	00019517          	auipc	a0,0x19
    8000320c:	67850513          	addi	a0,a0,1656 # 8001c880 <log>
    80003210:	085020ef          	jal	80005a94 <release>
}
    80003214:	70e2                	ld	ra,56(sp)
    80003216:	7442                	ld	s0,48(sp)
    80003218:	74a2                	ld	s1,40(sp)
    8000321a:	7902                	ld	s2,32(sp)
    8000321c:	6121                	addi	sp,sp,64
    8000321e:	8082                	ret
    80003220:	ec4e                	sd	s3,24(sp)
    80003222:	e852                	sd	s4,16(sp)
    80003224:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003226:	00019a97          	auipc	s5,0x19
    8000322a:	686a8a93          	addi	s5,s5,1670 # 8001c8ac <log+0x2c>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000322e:	00019a17          	auipc	s4,0x19
    80003232:	652a0a13          	addi	s4,s4,1618 # 8001c880 <log>
    80003236:	018a2583          	lw	a1,24(s4)
    8000323a:	012585bb          	addw	a1,a1,s2
    8000323e:	2585                	addiw	a1,a1,1
    80003240:	024a2503          	lw	a0,36(s4)
    80003244:	e23fe0ef          	jal	80002066 <bread>
    80003248:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000324a:	000aa583          	lw	a1,0(s5)
    8000324e:	024a2503          	lw	a0,36(s4)
    80003252:	e15fe0ef          	jal	80002066 <bread>
    80003256:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003258:	40000613          	li	a2,1024
    8000325c:	05850593          	addi	a1,a0,88
    80003260:	05848513          	addi	a0,s1,88
    80003264:	f5bfc0ef          	jal	800001be <memmove>
    bwrite(to);  // write the log
    80003268:	8526                	mv	a0,s1
    8000326a:	ed3fe0ef          	jal	8000213c <bwrite>
    brelse(from);
    8000326e:	854e                	mv	a0,s3
    80003270:	efffe0ef          	jal	8000216e <brelse>
    brelse(to);
    80003274:	8526                	mv	a0,s1
    80003276:	ef9fe0ef          	jal	8000216e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000327a:	2905                	addiw	s2,s2,1
    8000327c:	0a91                	addi	s5,s5,4
    8000327e:	028a2783          	lw	a5,40(s4)
    80003282:	faf94ae3          	blt	s2,a5,80003236 <end_op+0xbc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003286:	cd9ff0ef          	jal	80002f5e <write_head>
    install_trans(0); // Now install writes to home locations
    8000328a:	4501                	li	a0,0
    8000328c:	d31ff0ef          	jal	80002fbc <install_trans>
    log.lh.n = 0;
    80003290:	00019797          	auipc	a5,0x19
    80003294:	6007ac23          	sw	zero,1560(a5) # 8001c8a8 <log+0x28>
    write_head();    // Erase the transaction from the log
    80003298:	cc7ff0ef          	jal	80002f5e <write_head>
    8000329c:	69e2                	ld	s3,24(sp)
    8000329e:	6a42                	ld	s4,16(sp)
    800032a0:	6aa2                	ld	s5,8(sp)
    800032a2:	bf29                	j	800031bc <end_op+0x42>

00000000800032a4 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800032a4:	1101                	addi	sp,sp,-32
    800032a6:	ec06                	sd	ra,24(sp)
    800032a8:	e822                	sd	s0,16(sp)
    800032aa:	e426                	sd	s1,8(sp)
    800032ac:	1000                	addi	s0,sp,32
    800032ae:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800032b0:	00019517          	auipc	a0,0x19
    800032b4:	5d050513          	addi	a0,a0,1488 # 8001c880 <log>
    800032b8:	748020ef          	jal	80005a00 <acquire>
  if (log.lh.n >= LOGBLOCKS)
    800032bc:	00019617          	auipc	a2,0x19
    800032c0:	5ec62603          	lw	a2,1516(a2) # 8001c8a8 <log+0x28>
    800032c4:	47f5                	li	a5,29
    800032c6:	04c7cd63          	blt	a5,a2,80003320 <log_write+0x7c>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800032ca:	00019797          	auipc	a5,0x19
    800032ce:	5d27a783          	lw	a5,1490(a5) # 8001c89c <log+0x1c>
    800032d2:	04f05d63          	blez	a5,8000332c <log_write+0x88>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800032d6:	4781                	li	a5,0
    800032d8:	06c05063          	blez	a2,80003338 <log_write+0x94>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800032dc:	44cc                	lw	a1,12(s1)
    800032de:	00019717          	auipc	a4,0x19
    800032e2:	5ce70713          	addi	a4,a4,1486 # 8001c8ac <log+0x2c>
  for (i = 0; i < log.lh.n; i++) {
    800032e6:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800032e8:	4314                	lw	a3,0(a4)
    800032ea:	04b68763          	beq	a3,a1,80003338 <log_write+0x94>
  for (i = 0; i < log.lh.n; i++) {
    800032ee:	2785                	addiw	a5,a5,1
    800032f0:	0711                	addi	a4,a4,4
    800032f2:	fef61be3          	bne	a2,a5,800032e8 <log_write+0x44>
      break;
  }
  log.lh.block[i] = b->blockno;
    800032f6:	060a                	slli	a2,a2,0x2
    800032f8:	02060613          	addi	a2,a2,32
    800032fc:	00019797          	auipc	a5,0x19
    80003300:	58478793          	addi	a5,a5,1412 # 8001c880 <log>
    80003304:	97b2                	add	a5,a5,a2
    80003306:	44d8                	lw	a4,12(s1)
    80003308:	c7d8                	sw	a4,12(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000330a:	8526                	mv	a0,s1
    8000330c:	ee7fe0ef          	jal	800021f2 <bpin>
    log.lh.n++;
    80003310:	00019717          	auipc	a4,0x19
    80003314:	57070713          	addi	a4,a4,1392 # 8001c880 <log>
    80003318:	571c                	lw	a5,40(a4)
    8000331a:	2785                	addiw	a5,a5,1
    8000331c:	d71c                	sw	a5,40(a4)
    8000331e:	a815                	j	80003352 <log_write+0xae>
    panic("too big a transaction");
    80003320:	00004517          	auipc	a0,0x4
    80003324:	19050513          	addi	a0,a0,400 # 800074b0 <etext+0x4b0>
    80003328:	436020ef          	jal	8000575e <panic>
    panic("log_write outside of trans");
    8000332c:	00004517          	auipc	a0,0x4
    80003330:	19c50513          	addi	a0,a0,412 # 800074c8 <etext+0x4c8>
    80003334:	42a020ef          	jal	8000575e <panic>
  log.lh.block[i] = b->blockno;
    80003338:	00279693          	slli	a3,a5,0x2
    8000333c:	02068693          	addi	a3,a3,32
    80003340:	00019717          	auipc	a4,0x19
    80003344:	54070713          	addi	a4,a4,1344 # 8001c880 <log>
    80003348:	9736                	add	a4,a4,a3
    8000334a:	44d4                	lw	a3,12(s1)
    8000334c:	c754                	sw	a3,12(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000334e:	faf60ee3          	beq	a2,a5,8000330a <log_write+0x66>
  }
  release(&log.lock);
    80003352:	00019517          	auipc	a0,0x19
    80003356:	52e50513          	addi	a0,a0,1326 # 8001c880 <log>
    8000335a:	73a020ef          	jal	80005a94 <release>
}
    8000335e:	60e2                	ld	ra,24(sp)
    80003360:	6442                	ld	s0,16(sp)
    80003362:	64a2                	ld	s1,8(sp)
    80003364:	6105                	addi	sp,sp,32
    80003366:	8082                	ret

0000000080003368 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003368:	1101                	addi	sp,sp,-32
    8000336a:	ec06                	sd	ra,24(sp)
    8000336c:	e822                	sd	s0,16(sp)
    8000336e:	e426                	sd	s1,8(sp)
    80003370:	e04a                	sd	s2,0(sp)
    80003372:	1000                	addi	s0,sp,32
    80003374:	84aa                	mv	s1,a0
    80003376:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003378:	00004597          	auipc	a1,0x4
    8000337c:	17058593          	addi	a1,a1,368 # 800074e8 <etext+0x4e8>
    80003380:	0521                	addi	a0,a0,8
    80003382:	5f4020ef          	jal	80005976 <initlock>
  lk->name = name;
    80003386:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000338a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000338e:	0204a423          	sw	zero,40(s1)
}
    80003392:	60e2                	ld	ra,24(sp)
    80003394:	6442                	ld	s0,16(sp)
    80003396:	64a2                	ld	s1,8(sp)
    80003398:	6902                	ld	s2,0(sp)
    8000339a:	6105                	addi	sp,sp,32
    8000339c:	8082                	ret

000000008000339e <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000339e:	1101                	addi	sp,sp,-32
    800033a0:	ec06                	sd	ra,24(sp)
    800033a2:	e822                	sd	s0,16(sp)
    800033a4:	e426                	sd	s1,8(sp)
    800033a6:	e04a                	sd	s2,0(sp)
    800033a8:	1000                	addi	s0,sp,32
    800033aa:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800033ac:	00850913          	addi	s2,a0,8
    800033b0:	854a                	mv	a0,s2
    800033b2:	64e020ef          	jal	80005a00 <acquire>
  while (lk->locked) {
    800033b6:	409c                	lw	a5,0(s1)
    800033b8:	c799                	beqz	a5,800033c6 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    800033ba:	85ca                	mv	a1,s2
    800033bc:	8526                	mv	a0,s1
    800033be:	fcdfd0ef          	jal	8000138a <sleep>
  while (lk->locked) {
    800033c2:	409c                	lw	a5,0(s1)
    800033c4:	fbfd                	bnez	a5,800033ba <acquiresleep+0x1c>
  }
  lk->locked = 1;
    800033c6:	4785                	li	a5,1
    800033c8:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800033ca:	9b3fd0ef          	jal	80000d7c <myproc>
    800033ce:	591c                	lw	a5,48(a0)
    800033d0:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800033d2:	854a                	mv	a0,s2
    800033d4:	6c0020ef          	jal	80005a94 <release>
}
    800033d8:	60e2                	ld	ra,24(sp)
    800033da:	6442                	ld	s0,16(sp)
    800033dc:	64a2                	ld	s1,8(sp)
    800033de:	6902                	ld	s2,0(sp)
    800033e0:	6105                	addi	sp,sp,32
    800033e2:	8082                	ret

00000000800033e4 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800033e4:	1101                	addi	sp,sp,-32
    800033e6:	ec06                	sd	ra,24(sp)
    800033e8:	e822                	sd	s0,16(sp)
    800033ea:	e426                	sd	s1,8(sp)
    800033ec:	e04a                	sd	s2,0(sp)
    800033ee:	1000                	addi	s0,sp,32
    800033f0:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800033f2:	00850913          	addi	s2,a0,8
    800033f6:	854a                	mv	a0,s2
    800033f8:	608020ef          	jal	80005a00 <acquire>
  lk->locked = 0;
    800033fc:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003400:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003404:	8526                	mv	a0,s1
    80003406:	fd1fd0ef          	jal	800013d6 <wakeup>
  release(&lk->lk);
    8000340a:	854a                	mv	a0,s2
    8000340c:	688020ef          	jal	80005a94 <release>
}
    80003410:	60e2                	ld	ra,24(sp)
    80003412:	6442                	ld	s0,16(sp)
    80003414:	64a2                	ld	s1,8(sp)
    80003416:	6902                	ld	s2,0(sp)
    80003418:	6105                	addi	sp,sp,32
    8000341a:	8082                	ret

000000008000341c <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000341c:	7179                	addi	sp,sp,-48
    8000341e:	f406                	sd	ra,40(sp)
    80003420:	f022                	sd	s0,32(sp)
    80003422:	ec26                	sd	s1,24(sp)
    80003424:	e84a                	sd	s2,16(sp)
    80003426:	1800                	addi	s0,sp,48
    80003428:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000342a:	00850913          	addi	s2,a0,8
    8000342e:	854a                	mv	a0,s2
    80003430:	5d0020ef          	jal	80005a00 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003434:	409c                	lw	a5,0(s1)
    80003436:	ef81                	bnez	a5,8000344e <holdingsleep+0x32>
    80003438:	4481                	li	s1,0
  release(&lk->lk);
    8000343a:	854a                	mv	a0,s2
    8000343c:	658020ef          	jal	80005a94 <release>
  return r;
}
    80003440:	8526                	mv	a0,s1
    80003442:	70a2                	ld	ra,40(sp)
    80003444:	7402                	ld	s0,32(sp)
    80003446:	64e2                	ld	s1,24(sp)
    80003448:	6942                	ld	s2,16(sp)
    8000344a:	6145                	addi	sp,sp,48
    8000344c:	8082                	ret
    8000344e:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80003450:	0284a983          	lw	s3,40(s1)
    80003454:	929fd0ef          	jal	80000d7c <myproc>
    80003458:	5904                	lw	s1,48(a0)
    8000345a:	413484b3          	sub	s1,s1,s3
    8000345e:	0014b493          	seqz	s1,s1
    80003462:	69a2                	ld	s3,8(sp)
    80003464:	bfd9                	j	8000343a <holdingsleep+0x1e>

0000000080003466 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003466:	1141                	addi	sp,sp,-16
    80003468:	e406                	sd	ra,8(sp)
    8000346a:	e022                	sd	s0,0(sp)
    8000346c:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    8000346e:	00004597          	auipc	a1,0x4
    80003472:	08a58593          	addi	a1,a1,138 # 800074f8 <etext+0x4f8>
    80003476:	00019517          	auipc	a0,0x19
    8000347a:	55250513          	addi	a0,a0,1362 # 8001c9c8 <ftable>
    8000347e:	4f8020ef          	jal	80005976 <initlock>
}
    80003482:	60a2                	ld	ra,8(sp)
    80003484:	6402                	ld	s0,0(sp)
    80003486:	0141                	addi	sp,sp,16
    80003488:	8082                	ret

000000008000348a <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    8000348a:	1101                	addi	sp,sp,-32
    8000348c:	ec06                	sd	ra,24(sp)
    8000348e:	e822                	sd	s0,16(sp)
    80003490:	e426                	sd	s1,8(sp)
    80003492:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003494:	00019517          	auipc	a0,0x19
    80003498:	53450513          	addi	a0,a0,1332 # 8001c9c8 <ftable>
    8000349c:	564020ef          	jal	80005a00 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800034a0:	00019497          	auipc	s1,0x19
    800034a4:	54048493          	addi	s1,s1,1344 # 8001c9e0 <ftable+0x18>
    800034a8:	0001a717          	auipc	a4,0x1a
    800034ac:	4d870713          	addi	a4,a4,1240 # 8001d980 <disk>
    if(f->ref == 0){
    800034b0:	40dc                	lw	a5,4(s1)
    800034b2:	cf89                	beqz	a5,800034cc <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800034b4:	02848493          	addi	s1,s1,40
    800034b8:	fee49ce3          	bne	s1,a4,800034b0 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800034bc:	00019517          	auipc	a0,0x19
    800034c0:	50c50513          	addi	a0,a0,1292 # 8001c9c8 <ftable>
    800034c4:	5d0020ef          	jal	80005a94 <release>
  return 0;
    800034c8:	4481                	li	s1,0
    800034ca:	a809                	j	800034dc <filealloc+0x52>
      f->ref = 1;
    800034cc:	4785                	li	a5,1
    800034ce:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800034d0:	00019517          	auipc	a0,0x19
    800034d4:	4f850513          	addi	a0,a0,1272 # 8001c9c8 <ftable>
    800034d8:	5bc020ef          	jal	80005a94 <release>
}
    800034dc:	8526                	mv	a0,s1
    800034de:	60e2                	ld	ra,24(sp)
    800034e0:	6442                	ld	s0,16(sp)
    800034e2:	64a2                	ld	s1,8(sp)
    800034e4:	6105                	addi	sp,sp,32
    800034e6:	8082                	ret

00000000800034e8 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800034e8:	1101                	addi	sp,sp,-32
    800034ea:	ec06                	sd	ra,24(sp)
    800034ec:	e822                	sd	s0,16(sp)
    800034ee:	e426                	sd	s1,8(sp)
    800034f0:	1000                	addi	s0,sp,32
    800034f2:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800034f4:	00019517          	auipc	a0,0x19
    800034f8:	4d450513          	addi	a0,a0,1236 # 8001c9c8 <ftable>
    800034fc:	504020ef          	jal	80005a00 <acquire>
  if(f->ref < 1)
    80003500:	40dc                	lw	a5,4(s1)
    80003502:	02f05063          	blez	a5,80003522 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80003506:	2785                	addiw	a5,a5,1
    80003508:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    8000350a:	00019517          	auipc	a0,0x19
    8000350e:	4be50513          	addi	a0,a0,1214 # 8001c9c8 <ftable>
    80003512:	582020ef          	jal	80005a94 <release>
  return f;
}
    80003516:	8526                	mv	a0,s1
    80003518:	60e2                	ld	ra,24(sp)
    8000351a:	6442                	ld	s0,16(sp)
    8000351c:	64a2                	ld	s1,8(sp)
    8000351e:	6105                	addi	sp,sp,32
    80003520:	8082                	ret
    panic("filedup");
    80003522:	00004517          	auipc	a0,0x4
    80003526:	fde50513          	addi	a0,a0,-34 # 80007500 <etext+0x500>
    8000352a:	234020ef          	jal	8000575e <panic>

000000008000352e <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    8000352e:	7139                	addi	sp,sp,-64
    80003530:	fc06                	sd	ra,56(sp)
    80003532:	f822                	sd	s0,48(sp)
    80003534:	f426                	sd	s1,40(sp)
    80003536:	0080                	addi	s0,sp,64
    80003538:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    8000353a:	00019517          	auipc	a0,0x19
    8000353e:	48e50513          	addi	a0,a0,1166 # 8001c9c8 <ftable>
    80003542:	4be020ef          	jal	80005a00 <acquire>
  if(f->ref < 1)
    80003546:	40dc                	lw	a5,4(s1)
    80003548:	04f05a63          	blez	a5,8000359c <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    8000354c:	37fd                	addiw	a5,a5,-1
    8000354e:	c0dc                	sw	a5,4(s1)
    80003550:	06f04063          	bgtz	a5,800035b0 <fileclose+0x82>
    80003554:	f04a                	sd	s2,32(sp)
    80003556:	ec4e                	sd	s3,24(sp)
    80003558:	e852                	sd	s4,16(sp)
    8000355a:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    8000355c:	0004a903          	lw	s2,0(s1)
    80003560:	0094c783          	lbu	a5,9(s1)
    80003564:	89be                	mv	s3,a5
    80003566:	689c                	ld	a5,16(s1)
    80003568:	8a3e                	mv	s4,a5
    8000356a:	6c9c                	ld	a5,24(s1)
    8000356c:	8abe                	mv	s5,a5
  f->ref = 0;
    8000356e:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003572:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003576:	00019517          	auipc	a0,0x19
    8000357a:	45250513          	addi	a0,a0,1106 # 8001c9c8 <ftable>
    8000357e:	516020ef          	jal	80005a94 <release>

  if(ff.type == FD_PIPE){
    80003582:	4785                	li	a5,1
    80003584:	04f90163          	beq	s2,a5,800035c6 <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003588:	ffe9079b          	addiw	a5,s2,-2
    8000358c:	4705                	li	a4,1
    8000358e:	04f77563          	bgeu	a4,a5,800035d8 <fileclose+0xaa>
    80003592:	7902                	ld	s2,32(sp)
    80003594:	69e2                	ld	s3,24(sp)
    80003596:	6a42                	ld	s4,16(sp)
    80003598:	6aa2                	ld	s5,8(sp)
    8000359a:	a00d                	j	800035bc <fileclose+0x8e>
    8000359c:	f04a                	sd	s2,32(sp)
    8000359e:	ec4e                	sd	s3,24(sp)
    800035a0:	e852                	sd	s4,16(sp)
    800035a2:	e456                	sd	s5,8(sp)
    panic("fileclose");
    800035a4:	00004517          	auipc	a0,0x4
    800035a8:	f6450513          	addi	a0,a0,-156 # 80007508 <etext+0x508>
    800035ac:	1b2020ef          	jal	8000575e <panic>
    release(&ftable.lock);
    800035b0:	00019517          	auipc	a0,0x19
    800035b4:	41850513          	addi	a0,a0,1048 # 8001c9c8 <ftable>
    800035b8:	4dc020ef          	jal	80005a94 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    800035bc:	70e2                	ld	ra,56(sp)
    800035be:	7442                	ld	s0,48(sp)
    800035c0:	74a2                	ld	s1,40(sp)
    800035c2:	6121                	addi	sp,sp,64
    800035c4:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    800035c6:	85ce                	mv	a1,s3
    800035c8:	8552                	mv	a0,s4
    800035ca:	348000ef          	jal	80003912 <pipeclose>
    800035ce:	7902                	ld	s2,32(sp)
    800035d0:	69e2                	ld	s3,24(sp)
    800035d2:	6a42                	ld	s4,16(sp)
    800035d4:	6aa2                	ld	s5,8(sp)
    800035d6:	b7dd                	j	800035bc <fileclose+0x8e>
    begin_op();
    800035d8:	b33ff0ef          	jal	8000310a <begin_op>
    iput(ff.ip);
    800035dc:	8556                	mv	a0,s5
    800035de:	aa2ff0ef          	jal	80002880 <iput>
    end_op();
    800035e2:	b99ff0ef          	jal	8000317a <end_op>
    800035e6:	7902                	ld	s2,32(sp)
    800035e8:	69e2                	ld	s3,24(sp)
    800035ea:	6a42                	ld	s4,16(sp)
    800035ec:	6aa2                	ld	s5,8(sp)
    800035ee:	b7f9                	j	800035bc <fileclose+0x8e>

00000000800035f0 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    800035f0:	715d                	addi	sp,sp,-80
    800035f2:	e486                	sd	ra,72(sp)
    800035f4:	e0a2                	sd	s0,64(sp)
    800035f6:	fc26                	sd	s1,56(sp)
    800035f8:	f052                	sd	s4,32(sp)
    800035fa:	0880                	addi	s0,sp,80
    800035fc:	84aa                	mv	s1,a0
    800035fe:	8a2e                	mv	s4,a1
  struct proc *p = myproc();
    80003600:	f7cfd0ef          	jal	80000d7c <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003604:	409c                	lw	a5,0(s1)
    80003606:	37f9                	addiw	a5,a5,-2
    80003608:	4705                	li	a4,1
    8000360a:	04f76263          	bltu	a4,a5,8000364e <filestat+0x5e>
    8000360e:	f84a                	sd	s2,48(sp)
    80003610:	f44e                	sd	s3,40(sp)
    80003612:	89aa                	mv	s3,a0
    ilock(f->ip);
    80003614:	6c88                	ld	a0,24(s1)
    80003616:	8e8ff0ef          	jal	800026fe <ilock>
    stati(f->ip, &st);
    8000361a:	fb840913          	addi	s2,s0,-72
    8000361e:	85ca                	mv	a1,s2
    80003620:	6c88                	ld	a0,24(s1)
    80003622:	c40ff0ef          	jal	80002a62 <stati>
    iunlock(f->ip);
    80003626:	6c88                	ld	a0,24(s1)
    80003628:	984ff0ef          	jal	800027ac <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    8000362c:	46e1                	li	a3,24
    8000362e:	864a                	mv	a2,s2
    80003630:	85d2                	mv	a1,s4
    80003632:	0509b503          	ld	a0,80(s3)
    80003636:	c84fd0ef          	jal	80000aba <copyout>
    8000363a:	41f5551b          	sraiw	a0,a0,0x1f
    8000363e:	7942                	ld	s2,48(sp)
    80003640:	79a2                	ld	s3,40(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003642:	60a6                	ld	ra,72(sp)
    80003644:	6406                	ld	s0,64(sp)
    80003646:	74e2                	ld	s1,56(sp)
    80003648:	7a02                	ld	s4,32(sp)
    8000364a:	6161                	addi	sp,sp,80
    8000364c:	8082                	ret
  return -1;
    8000364e:	557d                	li	a0,-1
    80003650:	bfcd                	j	80003642 <filestat+0x52>

0000000080003652 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003652:	7179                	addi	sp,sp,-48
    80003654:	f406                	sd	ra,40(sp)
    80003656:	f022                	sd	s0,32(sp)
    80003658:	e84a                	sd	s2,16(sp)
    8000365a:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    8000365c:	00854783          	lbu	a5,8(a0)
    80003660:	cfd1                	beqz	a5,800036fc <fileread+0xaa>
    80003662:	ec26                	sd	s1,24(sp)
    80003664:	e44e                	sd	s3,8(sp)
    80003666:	84aa                	mv	s1,a0
    80003668:	892e                	mv	s2,a1
    8000366a:	89b2                	mv	s3,a2
    return -1;

  if(f->type == FD_PIPE){
    8000366c:	411c                	lw	a5,0(a0)
    8000366e:	4705                	li	a4,1
    80003670:	04e78363          	beq	a5,a4,800036b6 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003674:	470d                	li	a4,3
    80003676:	04e78763          	beq	a5,a4,800036c4 <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    8000367a:	4709                	li	a4,2
    8000367c:	06e79a63          	bne	a5,a4,800036f0 <fileread+0x9e>
    ilock(f->ip);
    80003680:	6d08                	ld	a0,24(a0)
    80003682:	87cff0ef          	jal	800026fe <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003686:	874e                	mv	a4,s3
    80003688:	5094                	lw	a3,32(s1)
    8000368a:	864a                	mv	a2,s2
    8000368c:	4585                	li	a1,1
    8000368e:	6c88                	ld	a0,24(s1)
    80003690:	c00ff0ef          	jal	80002a90 <readi>
    80003694:	892a                	mv	s2,a0
    80003696:	00a05563          	blez	a0,800036a0 <fileread+0x4e>
      f->off += r;
    8000369a:	509c                	lw	a5,32(s1)
    8000369c:	9fa9                	addw	a5,a5,a0
    8000369e:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    800036a0:	6c88                	ld	a0,24(s1)
    800036a2:	90aff0ef          	jal	800027ac <iunlock>
    800036a6:	64e2                	ld	s1,24(sp)
    800036a8:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    800036aa:	854a                	mv	a0,s2
    800036ac:	70a2                	ld	ra,40(sp)
    800036ae:	7402                	ld	s0,32(sp)
    800036b0:	6942                	ld	s2,16(sp)
    800036b2:	6145                	addi	sp,sp,48
    800036b4:	8082                	ret
    r = piperead(f->pipe, addr, n);
    800036b6:	6908                	ld	a0,16(a0)
    800036b8:	3b0000ef          	jal	80003a68 <piperead>
    800036bc:	892a                	mv	s2,a0
    800036be:	64e2                	ld	s1,24(sp)
    800036c0:	69a2                	ld	s3,8(sp)
    800036c2:	b7e5                	j	800036aa <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    800036c4:	02451783          	lh	a5,36(a0)
    800036c8:	03079693          	slli	a3,a5,0x30
    800036cc:	92c1                	srli	a3,a3,0x30
    800036ce:	4725                	li	a4,9
    800036d0:	02d76963          	bltu	a4,a3,80003702 <fileread+0xb0>
    800036d4:	0792                	slli	a5,a5,0x4
    800036d6:	00019717          	auipc	a4,0x19
    800036da:	25270713          	addi	a4,a4,594 # 8001c928 <devsw>
    800036de:	97ba                	add	a5,a5,a4
    800036e0:	639c                	ld	a5,0(a5)
    800036e2:	c78d                	beqz	a5,8000370c <fileread+0xba>
    r = devsw[f->major].read(1, addr, n);
    800036e4:	4505                	li	a0,1
    800036e6:	9782                	jalr	a5
    800036e8:	892a                	mv	s2,a0
    800036ea:	64e2                	ld	s1,24(sp)
    800036ec:	69a2                	ld	s3,8(sp)
    800036ee:	bf75                	j	800036aa <fileread+0x58>
    panic("fileread");
    800036f0:	00004517          	auipc	a0,0x4
    800036f4:	e2850513          	addi	a0,a0,-472 # 80007518 <etext+0x518>
    800036f8:	066020ef          	jal	8000575e <panic>
    return -1;
    800036fc:	57fd                	li	a5,-1
    800036fe:	893e                	mv	s2,a5
    80003700:	b76d                	j	800036aa <fileread+0x58>
      return -1;
    80003702:	57fd                	li	a5,-1
    80003704:	893e                	mv	s2,a5
    80003706:	64e2                	ld	s1,24(sp)
    80003708:	69a2                	ld	s3,8(sp)
    8000370a:	b745                	j	800036aa <fileread+0x58>
    8000370c:	57fd                	li	a5,-1
    8000370e:	893e                	mv	s2,a5
    80003710:	64e2                	ld	s1,24(sp)
    80003712:	69a2                	ld	s3,8(sp)
    80003714:	bf59                	j	800036aa <fileread+0x58>

0000000080003716 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003716:	00954783          	lbu	a5,9(a0)
    8000371a:	10078f63          	beqz	a5,80003838 <filewrite+0x122>
{
    8000371e:	711d                	addi	sp,sp,-96
    80003720:	ec86                	sd	ra,88(sp)
    80003722:	e8a2                	sd	s0,80(sp)
    80003724:	e0ca                	sd	s2,64(sp)
    80003726:	f456                	sd	s5,40(sp)
    80003728:	f05a                	sd	s6,32(sp)
    8000372a:	1080                	addi	s0,sp,96
    8000372c:	892a                	mv	s2,a0
    8000372e:	8b2e                	mv	s6,a1
    80003730:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    80003732:	411c                	lw	a5,0(a0)
    80003734:	4705                	li	a4,1
    80003736:	02e78a63          	beq	a5,a4,8000376a <filewrite+0x54>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000373a:	470d                	li	a4,3
    8000373c:	02e78b63          	beq	a5,a4,80003772 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003740:	4709                	li	a4,2
    80003742:	0ce79f63          	bne	a5,a4,80003820 <filewrite+0x10a>
    80003746:	f852                	sd	s4,48(sp)
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003748:	0ac05a63          	blez	a2,800037fc <filewrite+0xe6>
    8000374c:	e4a6                	sd	s1,72(sp)
    8000374e:	fc4e                	sd	s3,56(sp)
    80003750:	ec5e                	sd	s7,24(sp)
    80003752:	e862                	sd	s8,16(sp)
    80003754:	e466                	sd	s9,8(sp)
    int i = 0;
    80003756:	4a01                	li	s4,0
      int n1 = n - i;
      if(n1 > max)
    80003758:	6b85                	lui	s7,0x1
    8000375a:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    8000375e:	6785                	lui	a5,0x1
    80003760:	c007879b          	addiw	a5,a5,-1024 # c00 <_entry-0x7ffff400>
    80003764:	8cbe                	mv	s9,a5
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003766:	4c05                	li	s8,1
    80003768:	a8ad                	j	800037e2 <filewrite+0xcc>
    ret = pipewrite(f->pipe, addr, n);
    8000376a:	6908                	ld	a0,16(a0)
    8000376c:	204000ef          	jal	80003970 <pipewrite>
    80003770:	a04d                	j	80003812 <filewrite+0xfc>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003772:	02451783          	lh	a5,36(a0)
    80003776:	03079693          	slli	a3,a5,0x30
    8000377a:	92c1                	srli	a3,a3,0x30
    8000377c:	4725                	li	a4,9
    8000377e:	0ad76f63          	bltu	a4,a3,8000383c <filewrite+0x126>
    80003782:	0792                	slli	a5,a5,0x4
    80003784:	00019717          	auipc	a4,0x19
    80003788:	1a470713          	addi	a4,a4,420 # 8001c928 <devsw>
    8000378c:	97ba                	add	a5,a5,a4
    8000378e:	679c                	ld	a5,8(a5)
    80003790:	cbc5                	beqz	a5,80003840 <filewrite+0x12a>
    ret = devsw[f->major].write(1, addr, n);
    80003792:	4505                	li	a0,1
    80003794:	9782                	jalr	a5
    80003796:	a8b5                	j	80003812 <filewrite+0xfc>
      if(n1 > max)
    80003798:	2981                	sext.w	s3,s3
      begin_op();
    8000379a:	971ff0ef          	jal	8000310a <begin_op>
      ilock(f->ip);
    8000379e:	01893503          	ld	a0,24(s2)
    800037a2:	f5dfe0ef          	jal	800026fe <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800037a6:	874e                	mv	a4,s3
    800037a8:	02092683          	lw	a3,32(s2)
    800037ac:	016a0633          	add	a2,s4,s6
    800037b0:	85e2                	mv	a1,s8
    800037b2:	01893503          	ld	a0,24(s2)
    800037b6:	bccff0ef          	jal	80002b82 <writei>
    800037ba:	84aa                	mv	s1,a0
    800037bc:	00a05763          	blez	a0,800037ca <filewrite+0xb4>
        f->off += r;
    800037c0:	02092783          	lw	a5,32(s2)
    800037c4:	9fa9                	addw	a5,a5,a0
    800037c6:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    800037ca:	01893503          	ld	a0,24(s2)
    800037ce:	fdffe0ef          	jal	800027ac <iunlock>
      end_op();
    800037d2:	9a9ff0ef          	jal	8000317a <end_op>

      if(r != n1){
    800037d6:	02999563          	bne	s3,s1,80003800 <filewrite+0xea>
        // error from writei
        break;
      }
      i += r;
    800037da:	01448a3b          	addw	s4,s1,s4
    while(i < n){
    800037de:	015a5963          	bge	s4,s5,800037f0 <filewrite+0xda>
      int n1 = n - i;
    800037e2:	414a87bb          	subw	a5,s5,s4
    800037e6:	89be                	mv	s3,a5
      if(n1 > max)
    800037e8:	fafbd8e3          	bge	s7,a5,80003798 <filewrite+0x82>
    800037ec:	89e6                	mv	s3,s9
    800037ee:	b76d                	j	80003798 <filewrite+0x82>
    800037f0:	64a6                	ld	s1,72(sp)
    800037f2:	79e2                	ld	s3,56(sp)
    800037f4:	6be2                	ld	s7,24(sp)
    800037f6:	6c42                	ld	s8,16(sp)
    800037f8:	6ca2                	ld	s9,8(sp)
    800037fa:	a801                	j	8000380a <filewrite+0xf4>
    int i = 0;
    800037fc:	4a01                	li	s4,0
    800037fe:	a031                	j	8000380a <filewrite+0xf4>
    80003800:	64a6                	ld	s1,72(sp)
    80003802:	79e2                	ld	s3,56(sp)
    80003804:	6be2                	ld	s7,24(sp)
    80003806:	6c42                	ld	s8,16(sp)
    80003808:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    8000380a:	034a9d63          	bne	s5,s4,80003844 <filewrite+0x12e>
    8000380e:	8556                	mv	a0,s5
    80003810:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003812:	60e6                	ld	ra,88(sp)
    80003814:	6446                	ld	s0,80(sp)
    80003816:	6906                	ld	s2,64(sp)
    80003818:	7aa2                	ld	s5,40(sp)
    8000381a:	7b02                	ld	s6,32(sp)
    8000381c:	6125                	addi	sp,sp,96
    8000381e:	8082                	ret
    80003820:	e4a6                	sd	s1,72(sp)
    80003822:	fc4e                	sd	s3,56(sp)
    80003824:	f852                	sd	s4,48(sp)
    80003826:	ec5e                	sd	s7,24(sp)
    80003828:	e862                	sd	s8,16(sp)
    8000382a:	e466                	sd	s9,8(sp)
    panic("filewrite");
    8000382c:	00004517          	auipc	a0,0x4
    80003830:	cfc50513          	addi	a0,a0,-772 # 80007528 <etext+0x528>
    80003834:	72b010ef          	jal	8000575e <panic>
    return -1;
    80003838:	557d                	li	a0,-1
}
    8000383a:	8082                	ret
      return -1;
    8000383c:	557d                	li	a0,-1
    8000383e:	bfd1                	j	80003812 <filewrite+0xfc>
    80003840:	557d                	li	a0,-1
    80003842:	bfc1                	j	80003812 <filewrite+0xfc>
    ret = (i == n ? n : -1);
    80003844:	557d                	li	a0,-1
    80003846:	7a42                	ld	s4,48(sp)
    80003848:	b7e9                	j	80003812 <filewrite+0xfc>

000000008000384a <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    8000384a:	7179                	addi	sp,sp,-48
    8000384c:	f406                	sd	ra,40(sp)
    8000384e:	f022                	sd	s0,32(sp)
    80003850:	ec26                	sd	s1,24(sp)
    80003852:	e052                	sd	s4,0(sp)
    80003854:	1800                	addi	s0,sp,48
    80003856:	84aa                	mv	s1,a0
    80003858:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    8000385a:	0005b023          	sd	zero,0(a1)
    8000385e:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003862:	c29ff0ef          	jal	8000348a <filealloc>
    80003866:	e088                	sd	a0,0(s1)
    80003868:	c549                	beqz	a0,800038f2 <pipealloc+0xa8>
    8000386a:	c21ff0ef          	jal	8000348a <filealloc>
    8000386e:	00aa3023          	sd	a0,0(s4)
    80003872:	cd25                	beqz	a0,800038ea <pipealloc+0xa0>
    80003874:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003876:	88ffc0ef          	jal	80000104 <kalloc>
    8000387a:	892a                	mv	s2,a0
    8000387c:	c12d                	beqz	a0,800038de <pipealloc+0x94>
    8000387e:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80003880:	4985                	li	s3,1
    80003882:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003886:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    8000388a:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    8000388e:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003892:	00004597          	auipc	a1,0x4
    80003896:	ca658593          	addi	a1,a1,-858 # 80007538 <etext+0x538>
    8000389a:	0dc020ef          	jal	80005976 <initlock>
  (*f0)->type = FD_PIPE;
    8000389e:	609c                	ld	a5,0(s1)
    800038a0:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800038a4:	609c                	ld	a5,0(s1)
    800038a6:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    800038aa:	609c                	ld	a5,0(s1)
    800038ac:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    800038b0:	609c                	ld	a5,0(s1)
    800038b2:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    800038b6:	000a3783          	ld	a5,0(s4)
    800038ba:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800038be:	000a3783          	ld	a5,0(s4)
    800038c2:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800038c6:	000a3783          	ld	a5,0(s4)
    800038ca:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800038ce:	000a3783          	ld	a5,0(s4)
    800038d2:	0127b823          	sd	s2,16(a5)
  return 0;
    800038d6:	4501                	li	a0,0
    800038d8:	6942                	ld	s2,16(sp)
    800038da:	69a2                	ld	s3,8(sp)
    800038dc:	a01d                	j	80003902 <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800038de:	6088                	ld	a0,0(s1)
    800038e0:	c119                	beqz	a0,800038e6 <pipealloc+0x9c>
    800038e2:	6942                	ld	s2,16(sp)
    800038e4:	a029                	j	800038ee <pipealloc+0xa4>
    800038e6:	6942                	ld	s2,16(sp)
    800038e8:	a029                	j	800038f2 <pipealloc+0xa8>
    800038ea:	6088                	ld	a0,0(s1)
    800038ec:	c10d                	beqz	a0,8000390e <pipealloc+0xc4>
    fileclose(*f0);
    800038ee:	c41ff0ef          	jal	8000352e <fileclose>
  if(*f1)
    800038f2:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800038f6:	557d                	li	a0,-1
  if(*f1)
    800038f8:	c789                	beqz	a5,80003902 <pipealloc+0xb8>
    fileclose(*f1);
    800038fa:	853e                	mv	a0,a5
    800038fc:	c33ff0ef          	jal	8000352e <fileclose>
  return -1;
    80003900:	557d                	li	a0,-1
}
    80003902:	70a2                	ld	ra,40(sp)
    80003904:	7402                	ld	s0,32(sp)
    80003906:	64e2                	ld	s1,24(sp)
    80003908:	6a02                	ld	s4,0(sp)
    8000390a:	6145                	addi	sp,sp,48
    8000390c:	8082                	ret
  return -1;
    8000390e:	557d                	li	a0,-1
    80003910:	bfcd                	j	80003902 <pipealloc+0xb8>

0000000080003912 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003912:	1101                	addi	sp,sp,-32
    80003914:	ec06                	sd	ra,24(sp)
    80003916:	e822                	sd	s0,16(sp)
    80003918:	e426                	sd	s1,8(sp)
    8000391a:	e04a                	sd	s2,0(sp)
    8000391c:	1000                	addi	s0,sp,32
    8000391e:	84aa                	mv	s1,a0
    80003920:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003922:	0de020ef          	jal	80005a00 <acquire>
  if(writable){
    80003926:	02090763          	beqz	s2,80003954 <pipeclose+0x42>
    pi->writeopen = 0;
    8000392a:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    8000392e:	21848513          	addi	a0,s1,536
    80003932:	aa5fd0ef          	jal	800013d6 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003936:	2204a783          	lw	a5,544(s1)
    8000393a:	e781                	bnez	a5,80003942 <pipeclose+0x30>
    8000393c:	2244a783          	lw	a5,548(s1)
    80003940:	c38d                	beqz	a5,80003962 <pipeclose+0x50>
    release(&pi->lock);
    kfree((char*)pi);
  } else
    release(&pi->lock);
    80003942:	8526                	mv	a0,s1
    80003944:	150020ef          	jal	80005a94 <release>
}
    80003948:	60e2                	ld	ra,24(sp)
    8000394a:	6442                	ld	s0,16(sp)
    8000394c:	64a2                	ld	s1,8(sp)
    8000394e:	6902                	ld	s2,0(sp)
    80003950:	6105                	addi	sp,sp,32
    80003952:	8082                	ret
    pi->readopen = 0;
    80003954:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003958:	21c48513          	addi	a0,s1,540
    8000395c:	a7bfd0ef          	jal	800013d6 <wakeup>
    80003960:	bfd9                	j	80003936 <pipeclose+0x24>
    release(&pi->lock);
    80003962:	8526                	mv	a0,s1
    80003964:	130020ef          	jal	80005a94 <release>
    kfree((char*)pi);
    80003968:	8526                	mv	a0,s1
    8000396a:	eb2fc0ef          	jal	8000001c <kfree>
    8000396e:	bfe9                	j	80003948 <pipeclose+0x36>

0000000080003970 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003970:	7159                	addi	sp,sp,-112
    80003972:	f486                	sd	ra,104(sp)
    80003974:	f0a2                	sd	s0,96(sp)
    80003976:	eca6                	sd	s1,88(sp)
    80003978:	e8ca                	sd	s2,80(sp)
    8000397a:	e4ce                	sd	s3,72(sp)
    8000397c:	e0d2                	sd	s4,64(sp)
    8000397e:	fc56                	sd	s5,56(sp)
    80003980:	1880                	addi	s0,sp,112
    80003982:	84aa                	mv	s1,a0
    80003984:	8aae                	mv	s5,a1
    80003986:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003988:	bf4fd0ef          	jal	80000d7c <myproc>
    8000398c:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    8000398e:	8526                	mv	a0,s1
    80003990:	070020ef          	jal	80005a00 <acquire>
  while(i < n){
    80003994:	0d405263          	blez	s4,80003a58 <pipewrite+0xe8>
    80003998:	f85a                	sd	s6,48(sp)
    8000399a:	f45e                	sd	s7,40(sp)
    8000399c:	f062                	sd	s8,32(sp)
    8000399e:	ec66                	sd	s9,24(sp)
    800039a0:	e86a                	sd	s10,16(sp)
  int i = 0;
    800039a2:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800039a4:	f9f40c13          	addi	s8,s0,-97
    800039a8:	4b85                	li	s7,1
    800039aa:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800039ac:	21848d13          	addi	s10,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800039b0:	21c48c93          	addi	s9,s1,540
    800039b4:	a82d                	j	800039ee <pipewrite+0x7e>
      release(&pi->lock);
    800039b6:	8526                	mv	a0,s1
    800039b8:	0dc020ef          	jal	80005a94 <release>
      return -1;
    800039bc:	597d                	li	s2,-1
    800039be:	7b42                	ld	s6,48(sp)
    800039c0:	7ba2                	ld	s7,40(sp)
    800039c2:	7c02                	ld	s8,32(sp)
    800039c4:	6ce2                	ld	s9,24(sp)
    800039c6:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800039c8:	854a                	mv	a0,s2
    800039ca:	70a6                	ld	ra,104(sp)
    800039cc:	7406                	ld	s0,96(sp)
    800039ce:	64e6                	ld	s1,88(sp)
    800039d0:	6946                	ld	s2,80(sp)
    800039d2:	69a6                	ld	s3,72(sp)
    800039d4:	6a06                	ld	s4,64(sp)
    800039d6:	7ae2                	ld	s5,56(sp)
    800039d8:	6165                	addi	sp,sp,112
    800039da:	8082                	ret
      wakeup(&pi->nread);
    800039dc:	856a                	mv	a0,s10
    800039de:	9f9fd0ef          	jal	800013d6 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800039e2:	85a6                	mv	a1,s1
    800039e4:	8566                	mv	a0,s9
    800039e6:	9a5fd0ef          	jal	8000138a <sleep>
  while(i < n){
    800039ea:	05495a63          	bge	s2,s4,80003a3e <pipewrite+0xce>
    if(pi->readopen == 0 || killed(pr)){
    800039ee:	2204a783          	lw	a5,544(s1)
    800039f2:	d3f1                	beqz	a5,800039b6 <pipewrite+0x46>
    800039f4:	854e                	mv	a0,s3
    800039f6:	bd1fd0ef          	jal	800015c6 <killed>
    800039fa:	fd55                	bnez	a0,800039b6 <pipewrite+0x46>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800039fc:	2184a783          	lw	a5,536(s1)
    80003a00:	21c4a703          	lw	a4,540(s1)
    80003a04:	2007879b          	addiw	a5,a5,512
    80003a08:	fcf70ae3          	beq	a4,a5,800039dc <pipewrite+0x6c>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003a0c:	86de                	mv	a3,s7
    80003a0e:	01590633          	add	a2,s2,s5
    80003a12:	85e2                	mv	a1,s8
    80003a14:	0509b503          	ld	a0,80(s3)
    80003a18:	960fd0ef          	jal	80000b78 <copyin>
    80003a1c:	05650063          	beq	a0,s6,80003a5c <pipewrite+0xec>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003a20:	21c4a783          	lw	a5,540(s1)
    80003a24:	0017871b          	addiw	a4,a5,1
    80003a28:	20e4ae23          	sw	a4,540(s1)
    80003a2c:	1ff7f793          	andi	a5,a5,511
    80003a30:	97a6                	add	a5,a5,s1
    80003a32:	f9f44703          	lbu	a4,-97(s0)
    80003a36:	00e78c23          	sb	a4,24(a5)
      i++;
    80003a3a:	2905                	addiw	s2,s2,1
    80003a3c:	b77d                	j	800039ea <pipewrite+0x7a>
    80003a3e:	7b42                	ld	s6,48(sp)
    80003a40:	7ba2                	ld	s7,40(sp)
    80003a42:	7c02                	ld	s8,32(sp)
    80003a44:	6ce2                	ld	s9,24(sp)
    80003a46:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    80003a48:	21848513          	addi	a0,s1,536
    80003a4c:	98bfd0ef          	jal	800013d6 <wakeup>
  release(&pi->lock);
    80003a50:	8526                	mv	a0,s1
    80003a52:	042020ef          	jal	80005a94 <release>
  return i;
    80003a56:	bf8d                	j	800039c8 <pipewrite+0x58>
  int i = 0;
    80003a58:	4901                	li	s2,0
    80003a5a:	b7fd                	j	80003a48 <pipewrite+0xd8>
    80003a5c:	7b42                	ld	s6,48(sp)
    80003a5e:	7ba2                	ld	s7,40(sp)
    80003a60:	7c02                	ld	s8,32(sp)
    80003a62:	6ce2                	ld	s9,24(sp)
    80003a64:	6d42                	ld	s10,16(sp)
    80003a66:	b7cd                	j	80003a48 <pipewrite+0xd8>

0000000080003a68 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003a68:	711d                	addi	sp,sp,-96
    80003a6a:	ec86                	sd	ra,88(sp)
    80003a6c:	e8a2                	sd	s0,80(sp)
    80003a6e:	e4a6                	sd	s1,72(sp)
    80003a70:	e0ca                	sd	s2,64(sp)
    80003a72:	fc4e                	sd	s3,56(sp)
    80003a74:	f852                	sd	s4,48(sp)
    80003a76:	f456                	sd	s5,40(sp)
    80003a78:	1080                	addi	s0,sp,96
    80003a7a:	84aa                	mv	s1,a0
    80003a7c:	892e                	mv	s2,a1
    80003a7e:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003a80:	afcfd0ef          	jal	80000d7c <myproc>
    80003a84:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003a86:	8526                	mv	a0,s1
    80003a88:	779010ef          	jal	80005a00 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003a8c:	2184a703          	lw	a4,536(s1)
    80003a90:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003a94:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003a98:	02f71763          	bne	a4,a5,80003ac6 <piperead+0x5e>
    80003a9c:	2244a783          	lw	a5,548(s1)
    80003aa0:	cf85                	beqz	a5,80003ad8 <piperead+0x70>
    if(killed(pr)){
    80003aa2:	8552                	mv	a0,s4
    80003aa4:	b23fd0ef          	jal	800015c6 <killed>
    80003aa8:	e11d                	bnez	a0,80003ace <piperead+0x66>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003aaa:	85a6                	mv	a1,s1
    80003aac:	854e                	mv	a0,s3
    80003aae:	8ddfd0ef          	jal	8000138a <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003ab2:	2184a703          	lw	a4,536(s1)
    80003ab6:	21c4a783          	lw	a5,540(s1)
    80003aba:	fef701e3          	beq	a4,a5,80003a9c <piperead+0x34>
    80003abe:	f05a                	sd	s6,32(sp)
    80003ac0:	ec5e                	sd	s7,24(sp)
    80003ac2:	e862                	sd	s8,16(sp)
    80003ac4:	a829                	j	80003ade <piperead+0x76>
    80003ac6:	f05a                	sd	s6,32(sp)
    80003ac8:	ec5e                	sd	s7,24(sp)
    80003aca:	e862                	sd	s8,16(sp)
    80003acc:	a809                	j	80003ade <piperead+0x76>
      release(&pi->lock);
    80003ace:	8526                	mv	a0,s1
    80003ad0:	7c5010ef          	jal	80005a94 <release>
      return -1;
    80003ad4:	59fd                	li	s3,-1
    80003ad6:	a09d                	j	80003b3c <piperead+0xd4>
    80003ad8:	f05a                	sd	s6,32(sp)
    80003ada:	ec5e                	sd	s7,24(sp)
    80003adc:	e862                	sd	s8,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003ade:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003ae0:	faf40c13          	addi	s8,s0,-81
    80003ae4:	4b85                	li	s7,1
    80003ae6:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003ae8:	05505063          	blez	s5,80003b28 <piperead+0xc0>
    if(pi->nread == pi->nwrite)
    80003aec:	2184a783          	lw	a5,536(s1)
    80003af0:	21c4a703          	lw	a4,540(s1)
    80003af4:	02f70a63          	beq	a4,a5,80003b28 <piperead+0xc0>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003af8:	0017871b          	addiw	a4,a5,1
    80003afc:	20e4ac23          	sw	a4,536(s1)
    80003b00:	1ff7f793          	andi	a5,a5,511
    80003b04:	97a6                	add	a5,a5,s1
    80003b06:	0187c783          	lbu	a5,24(a5)
    80003b0a:	faf407a3          	sb	a5,-81(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003b0e:	86de                	mv	a3,s7
    80003b10:	8662                	mv	a2,s8
    80003b12:	85ca                	mv	a1,s2
    80003b14:	050a3503          	ld	a0,80(s4)
    80003b18:	fa3fc0ef          	jal	80000aba <copyout>
    80003b1c:	01650663          	beq	a0,s6,80003b28 <piperead+0xc0>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003b20:	2985                	addiw	s3,s3,1
    80003b22:	0905                	addi	s2,s2,1
    80003b24:	fd3a94e3          	bne	s5,s3,80003aec <piperead+0x84>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80003b28:	21c48513          	addi	a0,s1,540
    80003b2c:	8abfd0ef          	jal	800013d6 <wakeup>
  release(&pi->lock);
    80003b30:	8526                	mv	a0,s1
    80003b32:	763010ef          	jal	80005a94 <release>
    80003b36:	7b02                	ld	s6,32(sp)
    80003b38:	6be2                	ld	s7,24(sp)
    80003b3a:	6c42                	ld	s8,16(sp)
  return i;
}
    80003b3c:	854e                	mv	a0,s3
    80003b3e:	60e6                	ld	ra,88(sp)
    80003b40:	6446                	ld	s0,80(sp)
    80003b42:	64a6                	ld	s1,72(sp)
    80003b44:	6906                	ld	s2,64(sp)
    80003b46:	79e2                	ld	s3,56(sp)
    80003b48:	7a42                	ld	s4,48(sp)
    80003b4a:	7aa2                	ld	s5,40(sp)
    80003b4c:	6125                	addi	sp,sp,96
    80003b4e:	8082                	ret

0000000080003b50 <flags2perm>:

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

// map ELF permissions to PTE permission bits.
int flags2perm(int flags)
{
    80003b50:	1141                	addi	sp,sp,-16
    80003b52:	e406                	sd	ra,8(sp)
    80003b54:	e022                	sd	s0,0(sp)
    80003b56:	0800                	addi	s0,sp,16
    80003b58:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80003b5a:	0035151b          	slliw	a0,a0,0x3
    80003b5e:	8921                	andi	a0,a0,8
      perm = PTE_X;
    if(flags & 0x2)
    80003b60:	8b89                	andi	a5,a5,2
    80003b62:	c399                	beqz	a5,80003b68 <flags2perm+0x18>
      perm |= PTE_W;
    80003b64:	00456513          	ori	a0,a0,4
    return perm;
}
    80003b68:	60a2                	ld	ra,8(sp)
    80003b6a:	6402                	ld	s0,0(sp)
    80003b6c:	0141                	addi	sp,sp,16
    80003b6e:	8082                	ret

0000000080003b70 <kexec>:
//
// the implementation of the exec() system call
//
int
kexec(char *path, char **argv)
{
    80003b70:	de010113          	addi	sp,sp,-544
    80003b74:	20113c23          	sd	ra,536(sp)
    80003b78:	20813823          	sd	s0,528(sp)
    80003b7c:	20913423          	sd	s1,520(sp)
    80003b80:	21213023          	sd	s2,512(sp)
    80003b84:	1400                	addi	s0,sp,544
    80003b86:	892a                	mv	s2,a0
    80003b88:	dea43823          	sd	a0,-528(s0)
    80003b8c:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80003b90:	9ecfd0ef          	jal	80000d7c <myproc>
    80003b94:	84aa                	mv	s1,a0

  begin_op();
    80003b96:	d74ff0ef          	jal	8000310a <begin_op>

  // Open the executable file.
  if((ip = namei(path)) == 0){
    80003b9a:	854a                	mv	a0,s2
    80003b9c:	b90ff0ef          	jal	80002f2c <namei>
    80003ba0:	cd21                	beqz	a0,80003bf8 <kexec+0x88>
    80003ba2:	fbd2                	sd	s4,496(sp)
    80003ba4:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80003ba6:	b59fe0ef          	jal	800026fe <ilock>

  // Read the ELF header.
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80003baa:	04000713          	li	a4,64
    80003bae:	4681                	li	a3,0
    80003bb0:	e5040613          	addi	a2,s0,-432
    80003bb4:	4581                	li	a1,0
    80003bb6:	8552                	mv	a0,s4
    80003bb8:	ed9fe0ef          	jal	80002a90 <readi>
    80003bbc:	04000793          	li	a5,64
    80003bc0:	00f51a63          	bne	a0,a5,80003bd4 <kexec+0x64>
    goto bad;

  // Is this really an ELF file?
  if(elf.magic != ELF_MAGIC)
    80003bc4:	e5042703          	lw	a4,-432(s0)
    80003bc8:	464c47b7          	lui	a5,0x464c4
    80003bcc:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80003bd0:	02f70863          	beq	a4,a5,80003c00 <kexec+0x90>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80003bd4:	8552                	mv	a0,s4
    80003bd6:	d35fe0ef          	jal	8000290a <iunlockput>
    end_op();
    80003bda:	da0ff0ef          	jal	8000317a <end_op>
  }
  return -1;
    80003bde:	557d                	li	a0,-1
    80003be0:	7a5e                	ld	s4,496(sp)
}
    80003be2:	21813083          	ld	ra,536(sp)
    80003be6:	21013403          	ld	s0,528(sp)
    80003bea:	20813483          	ld	s1,520(sp)
    80003bee:	20013903          	ld	s2,512(sp)
    80003bf2:	22010113          	addi	sp,sp,544
    80003bf6:	8082                	ret
    end_op();
    80003bf8:	d82ff0ef          	jal	8000317a <end_op>
    return -1;
    80003bfc:	557d                	li	a0,-1
    80003bfe:	b7d5                	j	80003be2 <kexec+0x72>
    80003c00:	f3da                	sd	s6,480(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80003c02:	8526                	mv	a0,s1
    80003c04:	a82fd0ef          	jal	80000e86 <proc_pagetable>
    80003c08:	8b2a                	mv	s6,a0
    80003c0a:	26050f63          	beqz	a0,80003e88 <kexec+0x318>
    80003c0e:	ffce                	sd	s3,504(sp)
    80003c10:	f7d6                	sd	s5,488(sp)
    80003c12:	efde                	sd	s7,472(sp)
    80003c14:	ebe2                	sd	s8,464(sp)
    80003c16:	e7e6                	sd	s9,456(sp)
    80003c18:	e3ea                	sd	s10,448(sp)
    80003c1a:	ff6e                	sd	s11,440(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003c1c:	e8845783          	lhu	a5,-376(s0)
    80003c20:	0e078963          	beqz	a5,80003d12 <kexec+0x1a2>
    80003c24:	e7042683          	lw	a3,-400(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003c28:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003c2a:	4d01                	li	s10,0
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003c2c:	03800d93          	li	s11,56
    if(ph.vaddr % PGSIZE != 0)
    80003c30:	6c85                	lui	s9,0x1
    80003c32:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80003c36:	def43423          	sd	a5,-536(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80003c3a:	6a85                	lui	s5,0x1
    80003c3c:	a085                	j	80003c9c <kexec+0x12c>
      panic("loadseg: address should exist");
    80003c3e:	00004517          	auipc	a0,0x4
    80003c42:	90250513          	addi	a0,a0,-1790 # 80007540 <etext+0x540>
    80003c46:	319010ef          	jal	8000575e <panic>
    if(sz - i < PGSIZE)
    80003c4a:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80003c4c:	874a                	mv	a4,s2
    80003c4e:	009b86bb          	addw	a3,s7,s1
    80003c52:	4581                	li	a1,0
    80003c54:	8552                	mv	a0,s4
    80003c56:	e3bfe0ef          	jal	80002a90 <readi>
    80003c5a:	22a91b63          	bne	s2,a0,80003e90 <kexec+0x320>
  for(i = 0; i < sz; i += PGSIZE){
    80003c5e:	009a84bb          	addw	s1,s5,s1
    80003c62:	0334f263          	bgeu	s1,s3,80003c86 <kexec+0x116>
    pa = walkaddr(pagetable, va + i);
    80003c66:	02049593          	slli	a1,s1,0x20
    80003c6a:	9181                	srli	a1,a1,0x20
    80003c6c:	95e2                	add	a1,a1,s8
    80003c6e:	855a                	mv	a0,s6
    80003c70:	81dfc0ef          	jal	8000048c <walkaddr>
    80003c74:	862a                	mv	a2,a0
    if(pa == 0)
    80003c76:	d561                	beqz	a0,80003c3e <kexec+0xce>
    if(sz - i < PGSIZE)
    80003c78:	409987bb          	subw	a5,s3,s1
    80003c7c:	893e                	mv	s2,a5
    80003c7e:	fcfcf6e3          	bgeu	s9,a5,80003c4a <kexec+0xda>
    80003c82:	8956                	mv	s2,s5
    80003c84:	b7d9                	j	80003c4a <kexec+0xda>
    sz = sz1;
    80003c86:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003c8a:	2d05                	addiw	s10,s10,1
    80003c8c:	e0843783          	ld	a5,-504(s0)
    80003c90:	0387869b          	addiw	a3,a5,56
    80003c94:	e8845783          	lhu	a5,-376(s0)
    80003c98:	06fd5e63          	bge	s10,a5,80003d14 <kexec+0x1a4>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003c9c:	e0d43423          	sd	a3,-504(s0)
    80003ca0:	876e                	mv	a4,s11
    80003ca2:	e1840613          	addi	a2,s0,-488
    80003ca6:	4581                	li	a1,0
    80003ca8:	8552                	mv	a0,s4
    80003caa:	de7fe0ef          	jal	80002a90 <readi>
    80003cae:	1db51f63          	bne	a0,s11,80003e8c <kexec+0x31c>
    if(ph.type != ELF_PROG_LOAD)
    80003cb2:	e1842783          	lw	a5,-488(s0)
    80003cb6:	4705                	li	a4,1
    80003cb8:	fce799e3          	bne	a5,a4,80003c8a <kexec+0x11a>
    if(ph.memsz < ph.filesz)
    80003cbc:	e4043483          	ld	s1,-448(s0)
    80003cc0:	e3843783          	ld	a5,-456(s0)
    80003cc4:	1ef4e463          	bltu	s1,a5,80003eac <kexec+0x33c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80003cc8:	e2843783          	ld	a5,-472(s0)
    80003ccc:	94be                	add	s1,s1,a5
    80003cce:	1ef4e263          	bltu	s1,a5,80003eb2 <kexec+0x342>
    if(ph.vaddr % PGSIZE != 0)
    80003cd2:	de843703          	ld	a4,-536(s0)
    80003cd6:	8ff9                	and	a5,a5,a4
    80003cd8:	1e079063          	bnez	a5,80003eb8 <kexec+0x348>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80003cdc:	e1c42503          	lw	a0,-484(s0)
    80003ce0:	e71ff0ef          	jal	80003b50 <flags2perm>
    80003ce4:	86aa                	mv	a3,a0
    80003ce6:	8626                	mv	a2,s1
    80003ce8:	85ca                	mv	a1,s2
    80003cea:	855a                	mv	a0,s6
    80003cec:	a77fc0ef          	jal	80000762 <uvmalloc>
    80003cf0:	dea43c23          	sd	a0,-520(s0)
    80003cf4:	1c050563          	beqz	a0,80003ebe <kexec+0x34e>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80003cf8:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80003cfc:	00098863          	beqz	s3,80003d0c <kexec+0x19c>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80003d00:	e2843c03          	ld	s8,-472(s0)
    80003d04:	e2042b83          	lw	s7,-480(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80003d08:	4481                	li	s1,0
    80003d0a:	bfb1                	j	80003c66 <kexec+0xf6>
    sz = sz1;
    80003d0c:	df843903          	ld	s2,-520(s0)
    80003d10:	bfad                	j	80003c8a <kexec+0x11a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003d12:	4901                	li	s2,0
  iunlockput(ip);
    80003d14:	8552                	mv	a0,s4
    80003d16:	bf5fe0ef          	jal	8000290a <iunlockput>
  end_op();
    80003d1a:	c60ff0ef          	jal	8000317a <end_op>
  p = myproc();
    80003d1e:	85efd0ef          	jal	80000d7c <myproc>
    80003d22:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80003d24:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80003d28:	6985                	lui	s3,0x1
    80003d2a:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80003d2c:	99ca                	add	s3,s3,s2
    80003d2e:	77fd                	lui	a5,0xfffff
    80003d30:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80003d34:	4691                	li	a3,4
    80003d36:	6609                	lui	a2,0x2
    80003d38:	964e                	add	a2,a2,s3
    80003d3a:	85ce                	mv	a1,s3
    80003d3c:	855a                	mv	a0,s6
    80003d3e:	a25fc0ef          	jal	80000762 <uvmalloc>
    80003d42:	8a2a                	mv	s4,a0
    80003d44:	e105                	bnez	a0,80003d64 <kexec+0x1f4>
    proc_freepagetable(pagetable, sz);
    80003d46:	85ce                	mv	a1,s3
    80003d48:	855a                	mv	a0,s6
    80003d4a:	9c0fd0ef          	jal	80000f0a <proc_freepagetable>
  return -1;
    80003d4e:	557d                	li	a0,-1
    80003d50:	79fe                	ld	s3,504(sp)
    80003d52:	7a5e                	ld	s4,496(sp)
    80003d54:	7abe                	ld	s5,488(sp)
    80003d56:	7b1e                	ld	s6,480(sp)
    80003d58:	6bfe                	ld	s7,472(sp)
    80003d5a:	6c5e                	ld	s8,464(sp)
    80003d5c:	6cbe                	ld	s9,456(sp)
    80003d5e:	6d1e                	ld	s10,448(sp)
    80003d60:	7dfa                	ld	s11,440(sp)
    80003d62:	b541                	j	80003be2 <kexec+0x72>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80003d64:	75f9                	lui	a1,0xffffe
    80003d66:	95aa                	add	a1,a1,a0
    80003d68:	855a                	mv	a0,s6
    80003d6a:	bcbfc0ef          	jal	80000934 <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80003d6e:	800a0b93          	addi	s7,s4,-2048
    80003d72:	800b8b93          	addi	s7,s7,-2048
  for(argc = 0; argv[argc]; argc++) {
    80003d76:	e0043783          	ld	a5,-512(s0)
    80003d7a:	6388                	ld	a0,0(a5)
  sp = sz;
    80003d7c:	8952                	mv	s2,s4
  for(argc = 0; argv[argc]; argc++) {
    80003d7e:	4481                	li	s1,0
    ustack[argc] = sp;
    80003d80:	e9040c93          	addi	s9,s0,-368
    if(argc >= MAXARG)
    80003d84:	02000c13          	li	s8,32
  for(argc = 0; argv[argc]; argc++) {
    80003d88:	cd21                	beqz	a0,80003de0 <kexec+0x270>
    sp -= strlen(argv[argc]) + 1;
    80003d8a:	d5efc0ef          	jal	800002e8 <strlen>
    80003d8e:	0015079b          	addiw	a5,a0,1
    80003d92:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80003d96:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80003d9a:	13796563          	bltu	s2,s7,80003ec4 <kexec+0x354>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80003d9e:	e0043d83          	ld	s11,-512(s0)
    80003da2:	000db983          	ld	s3,0(s11)
    80003da6:	854e                	mv	a0,s3
    80003da8:	d40fc0ef          	jal	800002e8 <strlen>
    80003dac:	0015069b          	addiw	a3,a0,1
    80003db0:	864e                	mv	a2,s3
    80003db2:	85ca                	mv	a1,s2
    80003db4:	855a                	mv	a0,s6
    80003db6:	d05fc0ef          	jal	80000aba <copyout>
    80003dba:	10054763          	bltz	a0,80003ec8 <kexec+0x358>
    ustack[argc] = sp;
    80003dbe:	00349793          	slli	a5,s1,0x3
    80003dc2:	97e6                	add	a5,a5,s9
    80003dc4:	0127b023          	sd	s2,0(a5) # fffffffffffff000 <end+0xffffffff7ffd9468>
  for(argc = 0; argv[argc]; argc++) {
    80003dc8:	0485                	addi	s1,s1,1
    80003dca:	008d8793          	addi	a5,s11,8
    80003dce:	e0f43023          	sd	a5,-512(s0)
    80003dd2:	008db503          	ld	a0,8(s11)
    80003dd6:	c509                	beqz	a0,80003de0 <kexec+0x270>
    if(argc >= MAXARG)
    80003dd8:	fb8499e3          	bne	s1,s8,80003d8a <kexec+0x21a>
  sz = sz1;
    80003ddc:	89d2                	mv	s3,s4
    80003dde:	b7a5                	j	80003d46 <kexec+0x1d6>
  ustack[argc] = 0;
    80003de0:	00349793          	slli	a5,s1,0x3
    80003de4:	f9078793          	addi	a5,a5,-112
    80003de8:	97a2                	add	a5,a5,s0
    80003dea:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80003dee:	00349693          	slli	a3,s1,0x3
    80003df2:	06a1                	addi	a3,a3,8
    80003df4:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80003df8:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80003dfc:	89d2                	mv	s3,s4
  if(sp < stackbase)
    80003dfe:	f57964e3          	bltu	s2,s7,80003d46 <kexec+0x1d6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80003e02:	e9040613          	addi	a2,s0,-368
    80003e06:	85ca                	mv	a1,s2
    80003e08:	855a                	mv	a0,s6
    80003e0a:	cb1fc0ef          	jal	80000aba <copyout>
    80003e0e:	f2054ce3          	bltz	a0,80003d46 <kexec+0x1d6>
  p->trapframe->a1 = sp;
    80003e12:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80003e16:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80003e1a:	df043783          	ld	a5,-528(s0)
    80003e1e:	0007c703          	lbu	a4,0(a5)
    80003e22:	cf11                	beqz	a4,80003e3e <kexec+0x2ce>
    80003e24:	0785                	addi	a5,a5,1
    if(*s == '/')
    80003e26:	02f00693          	li	a3,47
    80003e2a:	a029                	j	80003e34 <kexec+0x2c4>
  for(last=s=path; *s; s++)
    80003e2c:	0785                	addi	a5,a5,1
    80003e2e:	fff7c703          	lbu	a4,-1(a5)
    80003e32:	c711                	beqz	a4,80003e3e <kexec+0x2ce>
    if(*s == '/')
    80003e34:	fed71ce3          	bne	a4,a3,80003e2c <kexec+0x2bc>
      last = s+1;
    80003e38:	def43823          	sd	a5,-528(s0)
    80003e3c:	bfc5                	j	80003e2c <kexec+0x2bc>
  safestrcpy(p->name, last, sizeof(p->name));
    80003e3e:	4641                	li	a2,16
    80003e40:	df043583          	ld	a1,-528(s0)
    80003e44:	158a8513          	addi	a0,s5,344
    80003e48:	c6afc0ef          	jal	800002b2 <safestrcpy>
  oldpagetable = p->pagetable;
    80003e4c:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80003e50:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80003e54:	054ab423          	sd	s4,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = ulib.c:start()
    80003e58:	058ab783          	ld	a5,88(s5)
    80003e5c:	e6843703          	ld	a4,-408(s0)
    80003e60:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80003e62:	058ab783          	ld	a5,88(s5)
    80003e66:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80003e6a:	85ea                	mv	a1,s10
    80003e6c:	89efd0ef          	jal	80000f0a <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80003e70:	0004851b          	sext.w	a0,s1
    80003e74:	79fe                	ld	s3,504(sp)
    80003e76:	7a5e                	ld	s4,496(sp)
    80003e78:	7abe                	ld	s5,488(sp)
    80003e7a:	7b1e                	ld	s6,480(sp)
    80003e7c:	6bfe                	ld	s7,472(sp)
    80003e7e:	6c5e                	ld	s8,464(sp)
    80003e80:	6cbe                	ld	s9,456(sp)
    80003e82:	6d1e                	ld	s10,448(sp)
    80003e84:	7dfa                	ld	s11,440(sp)
    80003e86:	bbb1                	j	80003be2 <kexec+0x72>
    80003e88:	7b1e                	ld	s6,480(sp)
    80003e8a:	b3a9                	j	80003bd4 <kexec+0x64>
    80003e8c:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80003e90:	df843583          	ld	a1,-520(s0)
    80003e94:	855a                	mv	a0,s6
    80003e96:	874fd0ef          	jal	80000f0a <proc_freepagetable>
  if(ip){
    80003e9a:	79fe                	ld	s3,504(sp)
    80003e9c:	7abe                	ld	s5,488(sp)
    80003e9e:	7b1e                	ld	s6,480(sp)
    80003ea0:	6bfe                	ld	s7,472(sp)
    80003ea2:	6c5e                	ld	s8,464(sp)
    80003ea4:	6cbe                	ld	s9,456(sp)
    80003ea6:	6d1e                	ld	s10,448(sp)
    80003ea8:	7dfa                	ld	s11,440(sp)
    80003eaa:	b32d                	j	80003bd4 <kexec+0x64>
    80003eac:	df243c23          	sd	s2,-520(s0)
    80003eb0:	b7c5                	j	80003e90 <kexec+0x320>
    80003eb2:	df243c23          	sd	s2,-520(s0)
    80003eb6:	bfe9                	j	80003e90 <kexec+0x320>
    80003eb8:	df243c23          	sd	s2,-520(s0)
    80003ebc:	bfd1                	j	80003e90 <kexec+0x320>
    80003ebe:	df243c23          	sd	s2,-520(s0)
    80003ec2:	b7f9                	j	80003e90 <kexec+0x320>
  sz = sz1;
    80003ec4:	89d2                	mv	s3,s4
    80003ec6:	b541                	j	80003d46 <kexec+0x1d6>
    80003ec8:	89d2                	mv	s3,s4
    80003eca:	bdb5                	j	80003d46 <kexec+0x1d6>

0000000080003ecc <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80003ecc:	7179                	addi	sp,sp,-48
    80003ece:	f406                	sd	ra,40(sp)
    80003ed0:	f022                	sd	s0,32(sp)
    80003ed2:	ec26                	sd	s1,24(sp)
    80003ed4:	e84a                	sd	s2,16(sp)
    80003ed6:	1800                	addi	s0,sp,48
    80003ed8:	892e                	mv	s2,a1
    80003eda:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80003edc:	fdc40593          	addi	a1,s0,-36
    80003ee0:	df3fd0ef          	jal	80001cd2 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80003ee4:	fdc42703          	lw	a4,-36(s0)
    80003ee8:	47bd                	li	a5,15
    80003eea:	02e7ea63          	bltu	a5,a4,80003f1e <argfd+0x52>
    80003eee:	e8ffc0ef          	jal	80000d7c <myproc>
    80003ef2:	fdc42703          	lw	a4,-36(s0)
    80003ef6:	00371793          	slli	a5,a4,0x3
    80003efa:	0d078793          	addi	a5,a5,208
    80003efe:	953e                	add	a0,a0,a5
    80003f00:	611c                	ld	a5,0(a0)
    80003f02:	c385                	beqz	a5,80003f22 <argfd+0x56>
    return -1;
  if(pfd)
    80003f04:	00090463          	beqz	s2,80003f0c <argfd+0x40>
    *pfd = fd;
    80003f08:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80003f0c:	4501                	li	a0,0
  if(pf)
    80003f0e:	c091                	beqz	s1,80003f12 <argfd+0x46>
    *pf = f;
    80003f10:	e09c                	sd	a5,0(s1)
}
    80003f12:	70a2                	ld	ra,40(sp)
    80003f14:	7402                	ld	s0,32(sp)
    80003f16:	64e2                	ld	s1,24(sp)
    80003f18:	6942                	ld	s2,16(sp)
    80003f1a:	6145                	addi	sp,sp,48
    80003f1c:	8082                	ret
    return -1;
    80003f1e:	557d                	li	a0,-1
    80003f20:	bfcd                	j	80003f12 <argfd+0x46>
    80003f22:	557d                	li	a0,-1
    80003f24:	b7fd                	j	80003f12 <argfd+0x46>

0000000080003f26 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80003f26:	1101                	addi	sp,sp,-32
    80003f28:	ec06                	sd	ra,24(sp)
    80003f2a:	e822                	sd	s0,16(sp)
    80003f2c:	e426                	sd	s1,8(sp)
    80003f2e:	1000                	addi	s0,sp,32
    80003f30:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80003f32:	e4bfc0ef          	jal	80000d7c <myproc>
    80003f36:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80003f38:	0d050793          	addi	a5,a0,208
    80003f3c:	4501                	li	a0,0
    80003f3e:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80003f40:	6398                	ld	a4,0(a5)
    80003f42:	cb19                	beqz	a4,80003f58 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80003f44:	2505                	addiw	a0,a0,1
    80003f46:	07a1                	addi	a5,a5,8
    80003f48:	fed51ce3          	bne	a0,a3,80003f40 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80003f4c:	557d                	li	a0,-1
}
    80003f4e:	60e2                	ld	ra,24(sp)
    80003f50:	6442                	ld	s0,16(sp)
    80003f52:	64a2                	ld	s1,8(sp)
    80003f54:	6105                	addi	sp,sp,32
    80003f56:	8082                	ret
      p->ofile[fd] = f;
    80003f58:	00351793          	slli	a5,a0,0x3
    80003f5c:	0d078793          	addi	a5,a5,208
    80003f60:	963e                	add	a2,a2,a5
    80003f62:	e204                	sd	s1,0(a2)
      return fd;
    80003f64:	b7ed                	j	80003f4e <fdalloc+0x28>

0000000080003f66 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80003f66:	715d                	addi	sp,sp,-80
    80003f68:	e486                	sd	ra,72(sp)
    80003f6a:	e0a2                	sd	s0,64(sp)
    80003f6c:	fc26                	sd	s1,56(sp)
    80003f6e:	f84a                	sd	s2,48(sp)
    80003f70:	f44e                	sd	s3,40(sp)
    80003f72:	f052                	sd	s4,32(sp)
    80003f74:	ec56                	sd	s5,24(sp)
    80003f76:	e85a                	sd	s6,16(sp)
    80003f78:	0880                	addi	s0,sp,80
    80003f7a:	892e                	mv	s2,a1
    80003f7c:	8a2e                	mv	s4,a1
    80003f7e:	8ab2                	mv	s5,a2
    80003f80:	8b36                	mv	s6,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80003f82:	fb040593          	addi	a1,s0,-80
    80003f86:	fc1fe0ef          	jal	80002f46 <nameiparent>
    80003f8a:	84aa                	mv	s1,a0
    80003f8c:	10050763          	beqz	a0,8000409a <create+0x134>
    return 0;

  ilock(dp);
    80003f90:	f6efe0ef          	jal	800026fe <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80003f94:	4601                	li	a2,0
    80003f96:	fb040593          	addi	a1,s0,-80
    80003f9a:	8526                	mv	a0,s1
    80003f9c:	cfdfe0ef          	jal	80002c98 <dirlookup>
    80003fa0:	89aa                	mv	s3,a0
    80003fa2:	c131                	beqz	a0,80003fe6 <create+0x80>
    iunlockput(dp);
    80003fa4:	8526                	mv	a0,s1
    80003fa6:	965fe0ef          	jal	8000290a <iunlockput>
    ilock(ip);
    80003faa:	854e                	mv	a0,s3
    80003fac:	f52fe0ef          	jal	800026fe <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80003fb0:	4789                	li	a5,2
    80003fb2:	02f91563          	bne	s2,a5,80003fdc <create+0x76>
    80003fb6:	0449d783          	lhu	a5,68(s3)
    80003fba:	37f9                	addiw	a5,a5,-2
    80003fbc:	17c2                	slli	a5,a5,0x30
    80003fbe:	93c1                	srli	a5,a5,0x30
    80003fc0:	4705                	li	a4,1
    80003fc2:	00f76d63          	bltu	a4,a5,80003fdc <create+0x76>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80003fc6:	854e                	mv	a0,s3
    80003fc8:	60a6                	ld	ra,72(sp)
    80003fca:	6406                	ld	s0,64(sp)
    80003fcc:	74e2                	ld	s1,56(sp)
    80003fce:	7942                	ld	s2,48(sp)
    80003fd0:	79a2                	ld	s3,40(sp)
    80003fd2:	7a02                	ld	s4,32(sp)
    80003fd4:	6ae2                	ld	s5,24(sp)
    80003fd6:	6b42                	ld	s6,16(sp)
    80003fd8:	6161                	addi	sp,sp,80
    80003fda:	8082                	ret
    iunlockput(ip);
    80003fdc:	854e                	mv	a0,s3
    80003fde:	92dfe0ef          	jal	8000290a <iunlockput>
    return 0;
    80003fe2:	4981                	li	s3,0
    80003fe4:	b7cd                	j	80003fc6 <create+0x60>
  if((ip = ialloc(dp->dev, type)) == 0){
    80003fe6:	85ca                	mv	a1,s2
    80003fe8:	4088                	lw	a0,0(s1)
    80003fea:	da4fe0ef          	jal	8000258e <ialloc>
    80003fee:	892a                	mv	s2,a0
    80003ff0:	cd15                	beqz	a0,8000402c <create+0xc6>
  ilock(ip);
    80003ff2:	f0cfe0ef          	jal	800026fe <ilock>
  ip->major = major;
    80003ff6:	05591323          	sh	s5,70(s2)
  ip->minor = minor;
    80003ffa:	05691423          	sh	s6,72(s2)
  ip->nlink = 1;
    80003ffe:	4785                	li	a5,1
    80004000:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004004:	854a                	mv	a0,s2
    80004006:	e44fe0ef          	jal	8000264a <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000400a:	4705                	li	a4,1
    8000400c:	02ea0463          	beq	s4,a4,80004034 <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80004010:	00492603          	lw	a2,4(s2)
    80004014:	fb040593          	addi	a1,s0,-80
    80004018:	8526                	mv	a0,s1
    8000401a:	e69fe0ef          	jal	80002e82 <dirlink>
    8000401e:	06054263          	bltz	a0,80004082 <create+0x11c>
  iunlockput(dp);
    80004022:	8526                	mv	a0,s1
    80004024:	8e7fe0ef          	jal	8000290a <iunlockput>
  return ip;
    80004028:	89ca                	mv	s3,s2
    8000402a:	bf71                	j	80003fc6 <create+0x60>
    iunlockput(dp);
    8000402c:	8526                	mv	a0,s1
    8000402e:	8ddfe0ef          	jal	8000290a <iunlockput>
    return 0;
    80004032:	bf51                	j	80003fc6 <create+0x60>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004034:	00492603          	lw	a2,4(s2)
    80004038:	00003597          	auipc	a1,0x3
    8000403c:	52858593          	addi	a1,a1,1320 # 80007560 <etext+0x560>
    80004040:	854a                	mv	a0,s2
    80004042:	e41fe0ef          	jal	80002e82 <dirlink>
    80004046:	02054e63          	bltz	a0,80004082 <create+0x11c>
    8000404a:	40d0                	lw	a2,4(s1)
    8000404c:	00003597          	auipc	a1,0x3
    80004050:	51c58593          	addi	a1,a1,1308 # 80007568 <etext+0x568>
    80004054:	854a                	mv	a0,s2
    80004056:	e2dfe0ef          	jal	80002e82 <dirlink>
    8000405a:	02054463          	bltz	a0,80004082 <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    8000405e:	00492603          	lw	a2,4(s2)
    80004062:	fb040593          	addi	a1,s0,-80
    80004066:	8526                	mv	a0,s1
    80004068:	e1bfe0ef          	jal	80002e82 <dirlink>
    8000406c:	00054b63          	bltz	a0,80004082 <create+0x11c>
    dp->nlink++;  // for ".."
    80004070:	04a4d783          	lhu	a5,74(s1)
    80004074:	2785                	addiw	a5,a5,1
    80004076:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000407a:	8526                	mv	a0,s1
    8000407c:	dcefe0ef          	jal	8000264a <iupdate>
    80004080:	b74d                	j	80004022 <create+0xbc>
  ip->nlink = 0;
    80004082:	04091523          	sh	zero,74(s2)
  iupdate(ip);
    80004086:	854a                	mv	a0,s2
    80004088:	dc2fe0ef          	jal	8000264a <iupdate>
  iunlockput(ip);
    8000408c:	854a                	mv	a0,s2
    8000408e:	87dfe0ef          	jal	8000290a <iunlockput>
  iunlockput(dp);
    80004092:	8526                	mv	a0,s1
    80004094:	877fe0ef          	jal	8000290a <iunlockput>
  return 0;
    80004098:	b73d                	j	80003fc6 <create+0x60>
    return 0;
    8000409a:	89aa                	mv	s3,a0
    8000409c:	b72d                	j	80003fc6 <create+0x60>

000000008000409e <sys_dup>:
{
    8000409e:	7179                	addi	sp,sp,-48
    800040a0:	f406                	sd	ra,40(sp)
    800040a2:	f022                	sd	s0,32(sp)
    800040a4:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800040a6:	fd840613          	addi	a2,s0,-40
    800040aa:	4581                	li	a1,0
    800040ac:	4501                	li	a0,0
    800040ae:	e1fff0ef          	jal	80003ecc <argfd>
    return -1;
    800040b2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800040b4:	02054363          	bltz	a0,800040da <sys_dup+0x3c>
    800040b8:	ec26                	sd	s1,24(sp)
    800040ba:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    800040bc:	fd843483          	ld	s1,-40(s0)
    800040c0:	8526                	mv	a0,s1
    800040c2:	e65ff0ef          	jal	80003f26 <fdalloc>
    800040c6:	892a                	mv	s2,a0
    return -1;
    800040c8:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800040ca:	00054d63          	bltz	a0,800040e4 <sys_dup+0x46>
  filedup(f);
    800040ce:	8526                	mv	a0,s1
    800040d0:	c18ff0ef          	jal	800034e8 <filedup>
  return fd;
    800040d4:	87ca                	mv	a5,s2
    800040d6:	64e2                	ld	s1,24(sp)
    800040d8:	6942                	ld	s2,16(sp)
}
    800040da:	853e                	mv	a0,a5
    800040dc:	70a2                	ld	ra,40(sp)
    800040de:	7402                	ld	s0,32(sp)
    800040e0:	6145                	addi	sp,sp,48
    800040e2:	8082                	ret
    800040e4:	64e2                	ld	s1,24(sp)
    800040e6:	6942                	ld	s2,16(sp)
    800040e8:	bfcd                	j	800040da <sys_dup+0x3c>

00000000800040ea <sys_read>:
{
    800040ea:	7179                	addi	sp,sp,-48
    800040ec:	f406                	sd	ra,40(sp)
    800040ee:	f022                	sd	s0,32(sp)
    800040f0:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800040f2:	fd840593          	addi	a1,s0,-40
    800040f6:	4505                	li	a0,1
    800040f8:	bf7fd0ef          	jal	80001cee <argaddr>
  argint(2, &n);
    800040fc:	fe440593          	addi	a1,s0,-28
    80004100:	4509                	li	a0,2
    80004102:	bd1fd0ef          	jal	80001cd2 <argint>
  if(argfd(0, 0, &f) < 0)
    80004106:	fe840613          	addi	a2,s0,-24
    8000410a:	4581                	li	a1,0
    8000410c:	4501                	li	a0,0
    8000410e:	dbfff0ef          	jal	80003ecc <argfd>
    80004112:	87aa                	mv	a5,a0
    return -1;
    80004114:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004116:	0007ca63          	bltz	a5,8000412a <sys_read+0x40>
  return fileread(f, p, n);
    8000411a:	fe442603          	lw	a2,-28(s0)
    8000411e:	fd843583          	ld	a1,-40(s0)
    80004122:	fe843503          	ld	a0,-24(s0)
    80004126:	d2cff0ef          	jal	80003652 <fileread>
}
    8000412a:	70a2                	ld	ra,40(sp)
    8000412c:	7402                	ld	s0,32(sp)
    8000412e:	6145                	addi	sp,sp,48
    80004130:	8082                	ret

0000000080004132 <sys_write>:
{
    80004132:	7179                	addi	sp,sp,-48
    80004134:	f406                	sd	ra,40(sp)
    80004136:	f022                	sd	s0,32(sp)
    80004138:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000413a:	fd840593          	addi	a1,s0,-40
    8000413e:	4505                	li	a0,1
    80004140:	baffd0ef          	jal	80001cee <argaddr>
  argint(2, &n);
    80004144:	fe440593          	addi	a1,s0,-28
    80004148:	4509                	li	a0,2
    8000414a:	b89fd0ef          	jal	80001cd2 <argint>
  if(argfd(0, 0, &f) < 0)
    8000414e:	fe840613          	addi	a2,s0,-24
    80004152:	4581                	li	a1,0
    80004154:	4501                	li	a0,0
    80004156:	d77ff0ef          	jal	80003ecc <argfd>
    8000415a:	87aa                	mv	a5,a0
    return -1;
    8000415c:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000415e:	0007ca63          	bltz	a5,80004172 <sys_write+0x40>
  return filewrite(f, p, n);
    80004162:	fe442603          	lw	a2,-28(s0)
    80004166:	fd843583          	ld	a1,-40(s0)
    8000416a:	fe843503          	ld	a0,-24(s0)
    8000416e:	da8ff0ef          	jal	80003716 <filewrite>
}
    80004172:	70a2                	ld	ra,40(sp)
    80004174:	7402                	ld	s0,32(sp)
    80004176:	6145                	addi	sp,sp,48
    80004178:	8082                	ret

000000008000417a <sys_close>:
{
    8000417a:	1101                	addi	sp,sp,-32
    8000417c:	ec06                	sd	ra,24(sp)
    8000417e:	e822                	sd	s0,16(sp)
    80004180:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004182:	fe040613          	addi	a2,s0,-32
    80004186:	fec40593          	addi	a1,s0,-20
    8000418a:	4501                	li	a0,0
    8000418c:	d41ff0ef          	jal	80003ecc <argfd>
    return -1;
    80004190:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004192:	02054163          	bltz	a0,800041b4 <sys_close+0x3a>
  myproc()->ofile[fd] = 0;
    80004196:	be7fc0ef          	jal	80000d7c <myproc>
    8000419a:	fec42783          	lw	a5,-20(s0)
    8000419e:	078e                	slli	a5,a5,0x3
    800041a0:	0d078793          	addi	a5,a5,208
    800041a4:	953e                	add	a0,a0,a5
    800041a6:	00053023          	sd	zero,0(a0)
  fileclose(f);
    800041aa:	fe043503          	ld	a0,-32(s0)
    800041ae:	b80ff0ef          	jal	8000352e <fileclose>
  return 0;
    800041b2:	4781                	li	a5,0
}
    800041b4:	853e                	mv	a0,a5
    800041b6:	60e2                	ld	ra,24(sp)
    800041b8:	6442                	ld	s0,16(sp)
    800041ba:	6105                	addi	sp,sp,32
    800041bc:	8082                	ret

00000000800041be <sys_fstat>:
{
    800041be:	1101                	addi	sp,sp,-32
    800041c0:	ec06                	sd	ra,24(sp)
    800041c2:	e822                	sd	s0,16(sp)
    800041c4:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    800041c6:	fe040593          	addi	a1,s0,-32
    800041ca:	4505                	li	a0,1
    800041cc:	b23fd0ef          	jal	80001cee <argaddr>
  if(argfd(0, 0, &f) < 0)
    800041d0:	fe840613          	addi	a2,s0,-24
    800041d4:	4581                	li	a1,0
    800041d6:	4501                	li	a0,0
    800041d8:	cf5ff0ef          	jal	80003ecc <argfd>
    800041dc:	87aa                	mv	a5,a0
    return -1;
    800041de:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800041e0:	0007c863          	bltz	a5,800041f0 <sys_fstat+0x32>
  return filestat(f, st);
    800041e4:	fe043583          	ld	a1,-32(s0)
    800041e8:	fe843503          	ld	a0,-24(s0)
    800041ec:	c04ff0ef          	jal	800035f0 <filestat>
}
    800041f0:	60e2                	ld	ra,24(sp)
    800041f2:	6442                	ld	s0,16(sp)
    800041f4:	6105                	addi	sp,sp,32
    800041f6:	8082                	ret

00000000800041f8 <sys_link>:
{
    800041f8:	7169                	addi	sp,sp,-304
    800041fa:	f606                	sd	ra,296(sp)
    800041fc:	f222                	sd	s0,288(sp)
    800041fe:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004200:	08000613          	li	a2,128
    80004204:	ed040593          	addi	a1,s0,-304
    80004208:	4501                	li	a0,0
    8000420a:	b01fd0ef          	jal	80001d0a <argstr>
    return -1;
    8000420e:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004210:	0c054e63          	bltz	a0,800042ec <sys_link+0xf4>
    80004214:	08000613          	li	a2,128
    80004218:	f5040593          	addi	a1,s0,-176
    8000421c:	4505                	li	a0,1
    8000421e:	aedfd0ef          	jal	80001d0a <argstr>
    return -1;
    80004222:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004224:	0c054463          	bltz	a0,800042ec <sys_link+0xf4>
    80004228:	ee26                	sd	s1,280(sp)
  begin_op();
    8000422a:	ee1fe0ef          	jal	8000310a <begin_op>
  if((ip = namei(old)) == 0){
    8000422e:	ed040513          	addi	a0,s0,-304
    80004232:	cfbfe0ef          	jal	80002f2c <namei>
    80004236:	84aa                	mv	s1,a0
    80004238:	c53d                	beqz	a0,800042a6 <sys_link+0xae>
  ilock(ip);
    8000423a:	cc4fe0ef          	jal	800026fe <ilock>
  if(ip->type == T_DIR){
    8000423e:	04449703          	lh	a4,68(s1)
    80004242:	4785                	li	a5,1
    80004244:	06f70663          	beq	a4,a5,800042b0 <sys_link+0xb8>
    80004248:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    8000424a:	04a4d783          	lhu	a5,74(s1)
    8000424e:	2785                	addiw	a5,a5,1
    80004250:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004254:	8526                	mv	a0,s1
    80004256:	bf4fe0ef          	jal	8000264a <iupdate>
  iunlock(ip);
    8000425a:	8526                	mv	a0,s1
    8000425c:	d50fe0ef          	jal	800027ac <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004260:	fd040593          	addi	a1,s0,-48
    80004264:	f5040513          	addi	a0,s0,-176
    80004268:	cdffe0ef          	jal	80002f46 <nameiparent>
    8000426c:	892a                	mv	s2,a0
    8000426e:	cd21                	beqz	a0,800042c6 <sys_link+0xce>
  ilock(dp);
    80004270:	c8efe0ef          	jal	800026fe <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004274:	854a                	mv	a0,s2
    80004276:	00092703          	lw	a4,0(s2)
    8000427a:	409c                	lw	a5,0(s1)
    8000427c:	04f71263          	bne	a4,a5,800042c0 <sys_link+0xc8>
    80004280:	40d0                	lw	a2,4(s1)
    80004282:	fd040593          	addi	a1,s0,-48
    80004286:	bfdfe0ef          	jal	80002e82 <dirlink>
    8000428a:	02054b63          	bltz	a0,800042c0 <sys_link+0xc8>
  iunlockput(dp);
    8000428e:	854a                	mv	a0,s2
    80004290:	e7afe0ef          	jal	8000290a <iunlockput>
  iput(ip);
    80004294:	8526                	mv	a0,s1
    80004296:	deafe0ef          	jal	80002880 <iput>
  end_op();
    8000429a:	ee1fe0ef          	jal	8000317a <end_op>
  return 0;
    8000429e:	4781                	li	a5,0
    800042a0:	64f2                	ld	s1,280(sp)
    800042a2:	6952                	ld	s2,272(sp)
    800042a4:	a0a1                	j	800042ec <sys_link+0xf4>
    end_op();
    800042a6:	ed5fe0ef          	jal	8000317a <end_op>
    return -1;
    800042aa:	57fd                	li	a5,-1
    800042ac:	64f2                	ld	s1,280(sp)
    800042ae:	a83d                	j	800042ec <sys_link+0xf4>
    iunlockput(ip);
    800042b0:	8526                	mv	a0,s1
    800042b2:	e58fe0ef          	jal	8000290a <iunlockput>
    end_op();
    800042b6:	ec5fe0ef          	jal	8000317a <end_op>
    return -1;
    800042ba:	57fd                	li	a5,-1
    800042bc:	64f2                	ld	s1,280(sp)
    800042be:	a03d                	j	800042ec <sys_link+0xf4>
    iunlockput(dp);
    800042c0:	854a                	mv	a0,s2
    800042c2:	e48fe0ef          	jal	8000290a <iunlockput>
  ilock(ip);
    800042c6:	8526                	mv	a0,s1
    800042c8:	c36fe0ef          	jal	800026fe <ilock>
  ip->nlink--;
    800042cc:	04a4d783          	lhu	a5,74(s1)
    800042d0:	37fd                	addiw	a5,a5,-1
    800042d2:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800042d6:	8526                	mv	a0,s1
    800042d8:	b72fe0ef          	jal	8000264a <iupdate>
  iunlockput(ip);
    800042dc:	8526                	mv	a0,s1
    800042de:	e2cfe0ef          	jal	8000290a <iunlockput>
  end_op();
    800042e2:	e99fe0ef          	jal	8000317a <end_op>
  return -1;
    800042e6:	57fd                	li	a5,-1
    800042e8:	64f2                	ld	s1,280(sp)
    800042ea:	6952                	ld	s2,272(sp)
}
    800042ec:	853e                	mv	a0,a5
    800042ee:	70b2                	ld	ra,296(sp)
    800042f0:	7412                	ld	s0,288(sp)
    800042f2:	6155                	addi	sp,sp,304
    800042f4:	8082                	ret

00000000800042f6 <sys_unlink>:
{
    800042f6:	7151                	addi	sp,sp,-240
    800042f8:	f586                	sd	ra,232(sp)
    800042fa:	f1a2                	sd	s0,224(sp)
    800042fc:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800042fe:	08000613          	li	a2,128
    80004302:	f3040593          	addi	a1,s0,-208
    80004306:	4501                	li	a0,0
    80004308:	a03fd0ef          	jal	80001d0a <argstr>
    8000430c:	14054d63          	bltz	a0,80004466 <sys_unlink+0x170>
    80004310:	eda6                	sd	s1,216(sp)
  begin_op();
    80004312:	df9fe0ef          	jal	8000310a <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004316:	fb040593          	addi	a1,s0,-80
    8000431a:	f3040513          	addi	a0,s0,-208
    8000431e:	c29fe0ef          	jal	80002f46 <nameiparent>
    80004322:	84aa                	mv	s1,a0
    80004324:	c955                	beqz	a0,800043d8 <sys_unlink+0xe2>
  ilock(dp);
    80004326:	bd8fe0ef          	jal	800026fe <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    8000432a:	00003597          	auipc	a1,0x3
    8000432e:	23658593          	addi	a1,a1,566 # 80007560 <etext+0x560>
    80004332:	fb040513          	addi	a0,s0,-80
    80004336:	94dfe0ef          	jal	80002c82 <namecmp>
    8000433a:	10050b63          	beqz	a0,80004450 <sys_unlink+0x15a>
    8000433e:	00003597          	auipc	a1,0x3
    80004342:	22a58593          	addi	a1,a1,554 # 80007568 <etext+0x568>
    80004346:	fb040513          	addi	a0,s0,-80
    8000434a:	939fe0ef          	jal	80002c82 <namecmp>
    8000434e:	10050163          	beqz	a0,80004450 <sys_unlink+0x15a>
    80004352:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004354:	f2c40613          	addi	a2,s0,-212
    80004358:	fb040593          	addi	a1,s0,-80
    8000435c:	8526                	mv	a0,s1
    8000435e:	93bfe0ef          	jal	80002c98 <dirlookup>
    80004362:	892a                	mv	s2,a0
    80004364:	0e050563          	beqz	a0,8000444e <sys_unlink+0x158>
    80004368:	e5ce                	sd	s3,200(sp)
  ilock(ip);
    8000436a:	b94fe0ef          	jal	800026fe <ilock>
  if(ip->nlink < 1)
    8000436e:	04a91783          	lh	a5,74(s2)
    80004372:	06f05863          	blez	a5,800043e2 <sys_unlink+0xec>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004376:	04491703          	lh	a4,68(s2)
    8000437a:	4785                	li	a5,1
    8000437c:	06f70963          	beq	a4,a5,800043ee <sys_unlink+0xf8>
  memset(&de, 0, sizeof(de));
    80004380:	fc040993          	addi	s3,s0,-64
    80004384:	4641                	li	a2,16
    80004386:	4581                	li	a1,0
    80004388:	854e                	mv	a0,s3
    8000438a:	dd5fb0ef          	jal	8000015e <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000438e:	4741                	li	a4,16
    80004390:	f2c42683          	lw	a3,-212(s0)
    80004394:	864e                	mv	a2,s3
    80004396:	4581                	li	a1,0
    80004398:	8526                	mv	a0,s1
    8000439a:	fe8fe0ef          	jal	80002b82 <writei>
    8000439e:	47c1                	li	a5,16
    800043a0:	08f51863          	bne	a0,a5,80004430 <sys_unlink+0x13a>
  if(ip->type == T_DIR){
    800043a4:	04491703          	lh	a4,68(s2)
    800043a8:	4785                	li	a5,1
    800043aa:	08f70963          	beq	a4,a5,8000443c <sys_unlink+0x146>
  iunlockput(dp);
    800043ae:	8526                	mv	a0,s1
    800043b0:	d5afe0ef          	jal	8000290a <iunlockput>
  ip->nlink--;
    800043b4:	04a95783          	lhu	a5,74(s2)
    800043b8:	37fd                	addiw	a5,a5,-1
    800043ba:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800043be:	854a                	mv	a0,s2
    800043c0:	a8afe0ef          	jal	8000264a <iupdate>
  iunlockput(ip);
    800043c4:	854a                	mv	a0,s2
    800043c6:	d44fe0ef          	jal	8000290a <iunlockput>
  end_op();
    800043ca:	db1fe0ef          	jal	8000317a <end_op>
  return 0;
    800043ce:	4501                	li	a0,0
    800043d0:	64ee                	ld	s1,216(sp)
    800043d2:	694e                	ld	s2,208(sp)
    800043d4:	69ae                	ld	s3,200(sp)
    800043d6:	a061                	j	8000445e <sys_unlink+0x168>
    end_op();
    800043d8:	da3fe0ef          	jal	8000317a <end_op>
    return -1;
    800043dc:	557d                	li	a0,-1
    800043de:	64ee                	ld	s1,216(sp)
    800043e0:	a8bd                	j	8000445e <sys_unlink+0x168>
    panic("unlink: nlink < 1");
    800043e2:	00003517          	auipc	a0,0x3
    800043e6:	18e50513          	addi	a0,a0,398 # 80007570 <etext+0x570>
    800043ea:	374010ef          	jal	8000575e <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800043ee:	04c92703          	lw	a4,76(s2)
    800043f2:	02000793          	li	a5,32
    800043f6:	f8e7f5e3          	bgeu	a5,a4,80004380 <sys_unlink+0x8a>
    800043fa:	89be                	mv	s3,a5
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800043fc:	4741                	li	a4,16
    800043fe:	86ce                	mv	a3,s3
    80004400:	f1840613          	addi	a2,s0,-232
    80004404:	4581                	li	a1,0
    80004406:	854a                	mv	a0,s2
    80004408:	e88fe0ef          	jal	80002a90 <readi>
    8000440c:	47c1                	li	a5,16
    8000440e:	00f51b63          	bne	a0,a5,80004424 <sys_unlink+0x12e>
    if(de.inum != 0)
    80004412:	f1845783          	lhu	a5,-232(s0)
    80004416:	ebb1                	bnez	a5,8000446a <sys_unlink+0x174>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004418:	29c1                	addiw	s3,s3,16
    8000441a:	04c92783          	lw	a5,76(s2)
    8000441e:	fcf9efe3          	bltu	s3,a5,800043fc <sys_unlink+0x106>
    80004422:	bfb9                	j	80004380 <sys_unlink+0x8a>
      panic("isdirempty: readi");
    80004424:	00003517          	auipc	a0,0x3
    80004428:	16450513          	addi	a0,a0,356 # 80007588 <etext+0x588>
    8000442c:	332010ef          	jal	8000575e <panic>
    panic("unlink: writei");
    80004430:	00003517          	auipc	a0,0x3
    80004434:	17050513          	addi	a0,a0,368 # 800075a0 <etext+0x5a0>
    80004438:	326010ef          	jal	8000575e <panic>
    dp->nlink--;
    8000443c:	04a4d783          	lhu	a5,74(s1)
    80004440:	37fd                	addiw	a5,a5,-1
    80004442:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004446:	8526                	mv	a0,s1
    80004448:	a02fe0ef          	jal	8000264a <iupdate>
    8000444c:	b78d                	j	800043ae <sys_unlink+0xb8>
    8000444e:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004450:	8526                	mv	a0,s1
    80004452:	cb8fe0ef          	jal	8000290a <iunlockput>
  end_op();
    80004456:	d25fe0ef          	jal	8000317a <end_op>
  return -1;
    8000445a:	557d                	li	a0,-1
    8000445c:	64ee                	ld	s1,216(sp)
}
    8000445e:	70ae                	ld	ra,232(sp)
    80004460:	740e                	ld	s0,224(sp)
    80004462:	616d                	addi	sp,sp,240
    80004464:	8082                	ret
    return -1;
    80004466:	557d                	li	a0,-1
    80004468:	bfdd                	j	8000445e <sys_unlink+0x168>
    iunlockput(ip);
    8000446a:	854a                	mv	a0,s2
    8000446c:	c9efe0ef          	jal	8000290a <iunlockput>
    goto bad;
    80004470:	694e                	ld	s2,208(sp)
    80004472:	69ae                	ld	s3,200(sp)
    80004474:	bff1                	j	80004450 <sys_unlink+0x15a>

0000000080004476 <sys_open>:

uint64
sys_open(void)
{
    80004476:	7131                	addi	sp,sp,-192
    80004478:	fd06                	sd	ra,184(sp)
    8000447a:	f922                	sd	s0,176(sp)
    8000447c:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    8000447e:	f4c40593          	addi	a1,s0,-180
    80004482:	4505                	li	a0,1
    80004484:	84ffd0ef          	jal	80001cd2 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004488:	08000613          	li	a2,128
    8000448c:	f5040593          	addi	a1,s0,-176
    80004490:	4501                	li	a0,0
    80004492:	879fd0ef          	jal	80001d0a <argstr>
    80004496:	87aa                	mv	a5,a0
    return -1;
    80004498:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    8000449a:	0a07c363          	bltz	a5,80004540 <sys_open+0xca>
    8000449e:	f526                	sd	s1,168(sp)

  begin_op();
    800044a0:	c6bfe0ef          	jal	8000310a <begin_op>

  if(omode & O_CREATE){
    800044a4:	f4c42783          	lw	a5,-180(s0)
    800044a8:	2007f793          	andi	a5,a5,512
    800044ac:	c3dd                	beqz	a5,80004552 <sys_open+0xdc>
    ip = create(path, T_FILE, 0, 0);
    800044ae:	4681                	li	a3,0
    800044b0:	4601                	li	a2,0
    800044b2:	4589                	li	a1,2
    800044b4:	f5040513          	addi	a0,s0,-176
    800044b8:	aafff0ef          	jal	80003f66 <create>
    800044bc:	84aa                	mv	s1,a0
    if(ip == 0){
    800044be:	c549                	beqz	a0,80004548 <sys_open+0xd2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    800044c0:	04449703          	lh	a4,68(s1)
    800044c4:	478d                	li	a5,3
    800044c6:	00f71763          	bne	a4,a5,800044d4 <sys_open+0x5e>
    800044ca:	0464d703          	lhu	a4,70(s1)
    800044ce:	47a5                	li	a5,9
    800044d0:	0ae7ee63          	bltu	a5,a4,8000458c <sys_open+0x116>
    800044d4:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    800044d6:	fb5fe0ef          	jal	8000348a <filealloc>
    800044da:	892a                	mv	s2,a0
    800044dc:	c561                	beqz	a0,800045a4 <sys_open+0x12e>
    800044de:	ed4e                	sd	s3,152(sp)
    800044e0:	a47ff0ef          	jal	80003f26 <fdalloc>
    800044e4:	89aa                	mv	s3,a0
    800044e6:	0a054b63          	bltz	a0,8000459c <sys_open+0x126>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    800044ea:	04449703          	lh	a4,68(s1)
    800044ee:	478d                	li	a5,3
    800044f0:	0cf70363          	beq	a4,a5,800045b6 <sys_open+0x140>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    800044f4:	4789                	li	a5,2
    800044f6:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    800044fa:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    800044fe:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004502:	f4c42783          	lw	a5,-180(s0)
    80004506:	0017f713          	andi	a4,a5,1
    8000450a:	00174713          	xori	a4,a4,1
    8000450e:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004512:	0037f713          	andi	a4,a5,3
    80004516:	00e03733          	snez	a4,a4
    8000451a:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    8000451e:	4007f793          	andi	a5,a5,1024
    80004522:	c791                	beqz	a5,8000452e <sys_open+0xb8>
    80004524:	04449703          	lh	a4,68(s1)
    80004528:	4789                	li	a5,2
    8000452a:	08f70d63          	beq	a4,a5,800045c4 <sys_open+0x14e>
    itrunc(ip);
  }

  iunlock(ip);
    8000452e:	8526                	mv	a0,s1
    80004530:	a7cfe0ef          	jal	800027ac <iunlock>
  end_op();
    80004534:	c47fe0ef          	jal	8000317a <end_op>

  return fd;
    80004538:	854e                	mv	a0,s3
    8000453a:	74aa                	ld	s1,168(sp)
    8000453c:	790a                	ld	s2,160(sp)
    8000453e:	69ea                	ld	s3,152(sp)
}
    80004540:	70ea                	ld	ra,184(sp)
    80004542:	744a                	ld	s0,176(sp)
    80004544:	6129                	addi	sp,sp,192
    80004546:	8082                	ret
      end_op();
    80004548:	c33fe0ef          	jal	8000317a <end_op>
      return -1;
    8000454c:	557d                	li	a0,-1
    8000454e:	74aa                	ld	s1,168(sp)
    80004550:	bfc5                	j	80004540 <sys_open+0xca>
    if((ip = namei(path)) == 0){
    80004552:	f5040513          	addi	a0,s0,-176
    80004556:	9d7fe0ef          	jal	80002f2c <namei>
    8000455a:	84aa                	mv	s1,a0
    8000455c:	c11d                	beqz	a0,80004582 <sys_open+0x10c>
    ilock(ip);
    8000455e:	9a0fe0ef          	jal	800026fe <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004562:	04449703          	lh	a4,68(s1)
    80004566:	4785                	li	a5,1
    80004568:	f4f71ce3          	bne	a4,a5,800044c0 <sys_open+0x4a>
    8000456c:	f4c42783          	lw	a5,-180(s0)
    80004570:	d3b5                	beqz	a5,800044d4 <sys_open+0x5e>
      iunlockput(ip);
    80004572:	8526                	mv	a0,s1
    80004574:	b96fe0ef          	jal	8000290a <iunlockput>
      end_op();
    80004578:	c03fe0ef          	jal	8000317a <end_op>
      return -1;
    8000457c:	557d                	li	a0,-1
    8000457e:	74aa                	ld	s1,168(sp)
    80004580:	b7c1                	j	80004540 <sys_open+0xca>
      end_op();
    80004582:	bf9fe0ef          	jal	8000317a <end_op>
      return -1;
    80004586:	557d                	li	a0,-1
    80004588:	74aa                	ld	s1,168(sp)
    8000458a:	bf5d                	j	80004540 <sys_open+0xca>
    iunlockput(ip);
    8000458c:	8526                	mv	a0,s1
    8000458e:	b7cfe0ef          	jal	8000290a <iunlockput>
    end_op();
    80004592:	be9fe0ef          	jal	8000317a <end_op>
    return -1;
    80004596:	557d                	li	a0,-1
    80004598:	74aa                	ld	s1,168(sp)
    8000459a:	b75d                	j	80004540 <sys_open+0xca>
      fileclose(f);
    8000459c:	854a                	mv	a0,s2
    8000459e:	f91fe0ef          	jal	8000352e <fileclose>
    800045a2:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    800045a4:	8526                	mv	a0,s1
    800045a6:	b64fe0ef          	jal	8000290a <iunlockput>
    end_op();
    800045aa:	bd1fe0ef          	jal	8000317a <end_op>
    return -1;
    800045ae:	557d                	li	a0,-1
    800045b0:	74aa                	ld	s1,168(sp)
    800045b2:	790a                	ld	s2,160(sp)
    800045b4:	b771                	j	80004540 <sys_open+0xca>
    f->type = FD_DEVICE;
    800045b6:	00e92023          	sw	a4,0(s2)
    f->major = ip->major;
    800045ba:	04649783          	lh	a5,70(s1)
    800045be:	02f91223          	sh	a5,36(s2)
    800045c2:	bf35                	j	800044fe <sys_open+0x88>
    itrunc(ip);
    800045c4:	8526                	mv	a0,s1
    800045c6:	a26fe0ef          	jal	800027ec <itrunc>
    800045ca:	b795                	j	8000452e <sys_open+0xb8>

00000000800045cc <sys_mkdir>:

uint64
sys_mkdir(void)
{
    800045cc:	7175                	addi	sp,sp,-144
    800045ce:	e506                	sd	ra,136(sp)
    800045d0:	e122                	sd	s0,128(sp)
    800045d2:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    800045d4:	b37fe0ef          	jal	8000310a <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    800045d8:	08000613          	li	a2,128
    800045dc:	f7040593          	addi	a1,s0,-144
    800045e0:	4501                	li	a0,0
    800045e2:	f28fd0ef          	jal	80001d0a <argstr>
    800045e6:	02054363          	bltz	a0,8000460c <sys_mkdir+0x40>
    800045ea:	4681                	li	a3,0
    800045ec:	4601                	li	a2,0
    800045ee:	4585                	li	a1,1
    800045f0:	f7040513          	addi	a0,s0,-144
    800045f4:	973ff0ef          	jal	80003f66 <create>
    800045f8:	c911                	beqz	a0,8000460c <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800045fa:	b10fe0ef          	jal	8000290a <iunlockput>
  end_op();
    800045fe:	b7dfe0ef          	jal	8000317a <end_op>
  return 0;
    80004602:	4501                	li	a0,0
}
    80004604:	60aa                	ld	ra,136(sp)
    80004606:	640a                	ld	s0,128(sp)
    80004608:	6149                	addi	sp,sp,144
    8000460a:	8082                	ret
    end_op();
    8000460c:	b6ffe0ef          	jal	8000317a <end_op>
    return -1;
    80004610:	557d                	li	a0,-1
    80004612:	bfcd                	j	80004604 <sys_mkdir+0x38>

0000000080004614 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004614:	7135                	addi	sp,sp,-160
    80004616:	ed06                	sd	ra,152(sp)
    80004618:	e922                	sd	s0,144(sp)
    8000461a:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    8000461c:	aeffe0ef          	jal	8000310a <begin_op>
  argint(1, &major);
    80004620:	f6c40593          	addi	a1,s0,-148
    80004624:	4505                	li	a0,1
    80004626:	eacfd0ef          	jal	80001cd2 <argint>
  argint(2, &minor);
    8000462a:	f6840593          	addi	a1,s0,-152
    8000462e:	4509                	li	a0,2
    80004630:	ea2fd0ef          	jal	80001cd2 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004634:	08000613          	li	a2,128
    80004638:	f7040593          	addi	a1,s0,-144
    8000463c:	4501                	li	a0,0
    8000463e:	eccfd0ef          	jal	80001d0a <argstr>
    80004642:	02054563          	bltz	a0,8000466c <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004646:	f6841683          	lh	a3,-152(s0)
    8000464a:	f6c41603          	lh	a2,-148(s0)
    8000464e:	458d                	li	a1,3
    80004650:	f7040513          	addi	a0,s0,-144
    80004654:	913ff0ef          	jal	80003f66 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004658:	c911                	beqz	a0,8000466c <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000465a:	ab0fe0ef          	jal	8000290a <iunlockput>
  end_op();
    8000465e:	b1dfe0ef          	jal	8000317a <end_op>
  return 0;
    80004662:	4501                	li	a0,0
}
    80004664:	60ea                	ld	ra,152(sp)
    80004666:	644a                	ld	s0,144(sp)
    80004668:	610d                	addi	sp,sp,160
    8000466a:	8082                	ret
    end_op();
    8000466c:	b0ffe0ef          	jal	8000317a <end_op>
    return -1;
    80004670:	557d                	li	a0,-1
    80004672:	bfcd                	j	80004664 <sys_mknod+0x50>

0000000080004674 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004674:	7135                	addi	sp,sp,-160
    80004676:	ed06                	sd	ra,152(sp)
    80004678:	e922                	sd	s0,144(sp)
    8000467a:	e14a                	sd	s2,128(sp)
    8000467c:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    8000467e:	efefc0ef          	jal	80000d7c <myproc>
    80004682:	892a                	mv	s2,a0
  
  begin_op();
    80004684:	a87fe0ef          	jal	8000310a <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004688:	08000613          	li	a2,128
    8000468c:	f6040593          	addi	a1,s0,-160
    80004690:	4501                	li	a0,0
    80004692:	e78fd0ef          	jal	80001d0a <argstr>
    80004696:	04054363          	bltz	a0,800046dc <sys_chdir+0x68>
    8000469a:	e526                	sd	s1,136(sp)
    8000469c:	f6040513          	addi	a0,s0,-160
    800046a0:	88dfe0ef          	jal	80002f2c <namei>
    800046a4:	84aa                	mv	s1,a0
    800046a6:	c915                	beqz	a0,800046da <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    800046a8:	856fe0ef          	jal	800026fe <ilock>
  if(ip->type != T_DIR){
    800046ac:	04449703          	lh	a4,68(s1)
    800046b0:	4785                	li	a5,1
    800046b2:	02f71963          	bne	a4,a5,800046e4 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800046b6:	8526                	mv	a0,s1
    800046b8:	8f4fe0ef          	jal	800027ac <iunlock>
  iput(p->cwd);
    800046bc:	15093503          	ld	a0,336(s2)
    800046c0:	9c0fe0ef          	jal	80002880 <iput>
  end_op();
    800046c4:	ab7fe0ef          	jal	8000317a <end_op>
  p->cwd = ip;
    800046c8:	14993823          	sd	s1,336(s2)
  return 0;
    800046cc:	4501                	li	a0,0
    800046ce:	64aa                	ld	s1,136(sp)
}
    800046d0:	60ea                	ld	ra,152(sp)
    800046d2:	644a                	ld	s0,144(sp)
    800046d4:	690a                	ld	s2,128(sp)
    800046d6:	610d                	addi	sp,sp,160
    800046d8:	8082                	ret
    800046da:	64aa                	ld	s1,136(sp)
    end_op();
    800046dc:	a9ffe0ef          	jal	8000317a <end_op>
    return -1;
    800046e0:	557d                	li	a0,-1
    800046e2:	b7fd                	j	800046d0 <sys_chdir+0x5c>
    iunlockput(ip);
    800046e4:	8526                	mv	a0,s1
    800046e6:	a24fe0ef          	jal	8000290a <iunlockput>
    end_op();
    800046ea:	a91fe0ef          	jal	8000317a <end_op>
    return -1;
    800046ee:	557d                	li	a0,-1
    800046f0:	64aa                	ld	s1,136(sp)
    800046f2:	bff9                	j	800046d0 <sys_chdir+0x5c>

00000000800046f4 <sys_exec>:

uint64
sys_exec(void)
{
    800046f4:	7105                	addi	sp,sp,-480
    800046f6:	ef86                	sd	ra,472(sp)
    800046f8:	eba2                	sd	s0,464(sp)
    800046fa:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    800046fc:	e2840593          	addi	a1,s0,-472
    80004700:	4505                	li	a0,1
    80004702:	decfd0ef          	jal	80001cee <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004706:	08000613          	li	a2,128
    8000470a:	f3040593          	addi	a1,s0,-208
    8000470e:	4501                	li	a0,0
    80004710:	dfafd0ef          	jal	80001d0a <argstr>
    80004714:	87aa                	mv	a5,a0
    return -1;
    80004716:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004718:	0e07c063          	bltz	a5,800047f8 <sys_exec+0x104>
    8000471c:	e7a6                	sd	s1,456(sp)
    8000471e:	e3ca                	sd	s2,448(sp)
    80004720:	ff4e                	sd	s3,440(sp)
    80004722:	fb52                	sd	s4,432(sp)
    80004724:	f756                	sd	s5,424(sp)
    80004726:	f35a                	sd	s6,416(sp)
    80004728:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    8000472a:	e3040a13          	addi	s4,s0,-464
    8000472e:	10000613          	li	a2,256
    80004732:	4581                	li	a1,0
    80004734:	8552                	mv	a0,s4
    80004736:	a29fb0ef          	jal	8000015e <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    8000473a:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    8000473c:	89d2                	mv	s3,s4
    8000473e:	4901                	li	s2,0
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004740:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004744:	6b05                	lui	s6,0x1
    if(i >= NELEM(argv)){
    80004746:	02000b93          	li	s7,32
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    8000474a:	00391513          	slli	a0,s2,0x3
    8000474e:	85d6                	mv	a1,s5
    80004750:	e2843783          	ld	a5,-472(s0)
    80004754:	953e                	add	a0,a0,a5
    80004756:	cf2fd0ef          	jal	80001c48 <fetchaddr>
    8000475a:	02054663          	bltz	a0,80004786 <sys_exec+0x92>
    if(uarg == 0){
    8000475e:	e2043783          	ld	a5,-480(s0)
    80004762:	c7a1                	beqz	a5,800047aa <sys_exec+0xb6>
    argv[i] = kalloc();
    80004764:	9a1fb0ef          	jal	80000104 <kalloc>
    80004768:	85aa                	mv	a1,a0
    8000476a:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    8000476e:	cd01                	beqz	a0,80004786 <sys_exec+0x92>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004770:	865a                	mv	a2,s6
    80004772:	e2043503          	ld	a0,-480(s0)
    80004776:	d1cfd0ef          	jal	80001c92 <fetchstr>
    8000477a:	00054663          	bltz	a0,80004786 <sys_exec+0x92>
    if(i >= NELEM(argv)){
    8000477e:	0905                	addi	s2,s2,1
    80004780:	09a1                	addi	s3,s3,8
    80004782:	fd7914e3          	bne	s2,s7,8000474a <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004786:	100a0a13          	addi	s4,s4,256
    8000478a:	6088                	ld	a0,0(s1)
    8000478c:	cd31                	beqz	a0,800047e8 <sys_exec+0xf4>
    kfree(argv[i]);
    8000478e:	88ffb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004792:	04a1                	addi	s1,s1,8
    80004794:	ff449be3          	bne	s1,s4,8000478a <sys_exec+0x96>
  return -1;
    80004798:	557d                	li	a0,-1
    8000479a:	64be                	ld	s1,456(sp)
    8000479c:	691e                	ld	s2,448(sp)
    8000479e:	79fa                	ld	s3,440(sp)
    800047a0:	7a5a                	ld	s4,432(sp)
    800047a2:	7aba                	ld	s5,424(sp)
    800047a4:	7b1a                	ld	s6,416(sp)
    800047a6:	6bfa                	ld	s7,408(sp)
    800047a8:	a881                	j	800047f8 <sys_exec+0x104>
      argv[i] = 0;
    800047aa:	0009079b          	sext.w	a5,s2
    800047ae:	e3040593          	addi	a1,s0,-464
    800047b2:	078e                	slli	a5,a5,0x3
    800047b4:	97ae                	add	a5,a5,a1
    800047b6:	0007b023          	sd	zero,0(a5)
  int ret = kexec(path, argv);
    800047ba:	f3040513          	addi	a0,s0,-208
    800047be:	bb2ff0ef          	jal	80003b70 <kexec>
    800047c2:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800047c4:	100a0a13          	addi	s4,s4,256
    800047c8:	6088                	ld	a0,0(s1)
    800047ca:	c511                	beqz	a0,800047d6 <sys_exec+0xe2>
    kfree(argv[i]);
    800047cc:	851fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800047d0:	04a1                	addi	s1,s1,8
    800047d2:	ff449be3          	bne	s1,s4,800047c8 <sys_exec+0xd4>
  return ret;
    800047d6:	854a                	mv	a0,s2
    800047d8:	64be                	ld	s1,456(sp)
    800047da:	691e                	ld	s2,448(sp)
    800047dc:	79fa                	ld	s3,440(sp)
    800047de:	7a5a                	ld	s4,432(sp)
    800047e0:	7aba                	ld	s5,424(sp)
    800047e2:	7b1a                	ld	s6,416(sp)
    800047e4:	6bfa                	ld	s7,408(sp)
    800047e6:	a809                	j	800047f8 <sys_exec+0x104>
  return -1;
    800047e8:	557d                	li	a0,-1
    800047ea:	64be                	ld	s1,456(sp)
    800047ec:	691e                	ld	s2,448(sp)
    800047ee:	79fa                	ld	s3,440(sp)
    800047f0:	7a5a                	ld	s4,432(sp)
    800047f2:	7aba                	ld	s5,424(sp)
    800047f4:	7b1a                	ld	s6,416(sp)
    800047f6:	6bfa                	ld	s7,408(sp)
}
    800047f8:	60fe                	ld	ra,472(sp)
    800047fa:	645e                	ld	s0,464(sp)
    800047fc:	613d                	addi	sp,sp,480
    800047fe:	8082                	ret

0000000080004800 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004800:	7139                	addi	sp,sp,-64
    80004802:	fc06                	sd	ra,56(sp)
    80004804:	f822                	sd	s0,48(sp)
    80004806:	f426                	sd	s1,40(sp)
    80004808:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    8000480a:	d72fc0ef          	jal	80000d7c <myproc>
    8000480e:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80004810:	fd840593          	addi	a1,s0,-40
    80004814:	4501                	li	a0,0
    80004816:	cd8fd0ef          	jal	80001cee <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    8000481a:	fc840593          	addi	a1,s0,-56
    8000481e:	fd040513          	addi	a0,s0,-48
    80004822:	828ff0ef          	jal	8000384a <pipealloc>
    return -1;
    80004826:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004828:	0a054763          	bltz	a0,800048d6 <sys_pipe+0xd6>
  fd0 = -1;
    8000482c:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004830:	fd043503          	ld	a0,-48(s0)
    80004834:	ef2ff0ef          	jal	80003f26 <fdalloc>
    80004838:	fca42223          	sw	a0,-60(s0)
    8000483c:	08054463          	bltz	a0,800048c4 <sys_pipe+0xc4>
    80004840:	fc843503          	ld	a0,-56(s0)
    80004844:	ee2ff0ef          	jal	80003f26 <fdalloc>
    80004848:	fca42023          	sw	a0,-64(s0)
    8000484c:	06054263          	bltz	a0,800048b0 <sys_pipe+0xb0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004850:	4691                	li	a3,4
    80004852:	fc440613          	addi	a2,s0,-60
    80004856:	fd843583          	ld	a1,-40(s0)
    8000485a:	68a8                	ld	a0,80(s1)
    8000485c:	a5efc0ef          	jal	80000aba <copyout>
    80004860:	00054e63          	bltz	a0,8000487c <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004864:	4691                	li	a3,4
    80004866:	fc040613          	addi	a2,s0,-64
    8000486a:	fd843583          	ld	a1,-40(s0)
    8000486e:	95b6                	add	a1,a1,a3
    80004870:	68a8                	ld	a0,80(s1)
    80004872:	a48fc0ef          	jal	80000aba <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004876:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004878:	04055f63          	bgez	a0,800048d6 <sys_pipe+0xd6>
    p->ofile[fd0] = 0;
    8000487c:	fc442783          	lw	a5,-60(s0)
    80004880:	078e                	slli	a5,a5,0x3
    80004882:	0d078793          	addi	a5,a5,208
    80004886:	97a6                	add	a5,a5,s1
    80004888:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    8000488c:	fc042783          	lw	a5,-64(s0)
    80004890:	078e                	slli	a5,a5,0x3
    80004892:	0d078793          	addi	a5,a5,208
    80004896:	97a6                	add	a5,a5,s1
    80004898:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    8000489c:	fd043503          	ld	a0,-48(s0)
    800048a0:	c8ffe0ef          	jal	8000352e <fileclose>
    fileclose(wf);
    800048a4:	fc843503          	ld	a0,-56(s0)
    800048a8:	c87fe0ef          	jal	8000352e <fileclose>
    return -1;
    800048ac:	57fd                	li	a5,-1
    800048ae:	a025                	j	800048d6 <sys_pipe+0xd6>
    if(fd0 >= 0)
    800048b0:	fc442783          	lw	a5,-60(s0)
    800048b4:	0007c863          	bltz	a5,800048c4 <sys_pipe+0xc4>
      p->ofile[fd0] = 0;
    800048b8:	078e                	slli	a5,a5,0x3
    800048ba:	0d078793          	addi	a5,a5,208
    800048be:	97a6                	add	a5,a5,s1
    800048c0:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800048c4:	fd043503          	ld	a0,-48(s0)
    800048c8:	c67fe0ef          	jal	8000352e <fileclose>
    fileclose(wf);
    800048cc:	fc843503          	ld	a0,-56(s0)
    800048d0:	c5ffe0ef          	jal	8000352e <fileclose>
    return -1;
    800048d4:	57fd                	li	a5,-1
}
    800048d6:	853e                	mv	a0,a5
    800048d8:	70e2                	ld	ra,56(sp)
    800048da:	7442                	ld	s0,48(sp)
    800048dc:	74a2                	ld	s1,40(sp)
    800048de:	6121                	addi	sp,sp,64
    800048e0:	8082                	ret
	...

00000000800048f0 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256
    800048f0:	7111                	addi	sp,sp,-256

        # save caller-saved registers.
        sd ra, 0(sp)
    800048f2:	e006                	sd	ra,0(sp)
        # sd sp, 8(sp)
        sd gp, 16(sp)
    800048f4:	e80e                	sd	gp,16(sp)
        sd tp, 24(sp)
    800048f6:	ec12                	sd	tp,24(sp)
        sd t0, 32(sp)
    800048f8:	f016                	sd	t0,32(sp)
        sd t1, 40(sp)
    800048fa:	f41a                	sd	t1,40(sp)
        sd t2, 48(sp)
    800048fc:	f81e                	sd	t2,48(sp)
        sd a0, 72(sp)
    800048fe:	e4aa                	sd	a0,72(sp)
        sd a1, 80(sp)
    80004900:	e8ae                	sd	a1,80(sp)
        sd a2, 88(sp)
    80004902:	ecb2                	sd	a2,88(sp)
        sd a3, 96(sp)
    80004904:	f0b6                	sd	a3,96(sp)
        sd a4, 104(sp)
    80004906:	f4ba                	sd	a4,104(sp)
        sd a5, 112(sp)
    80004908:	f8be                	sd	a5,112(sp)
        sd a6, 120(sp)
    8000490a:	fcc2                	sd	a6,120(sp)
        sd a7, 128(sp)
    8000490c:	e146                	sd	a7,128(sp)
        sd t3, 216(sp)
    8000490e:	edf2                	sd	t3,216(sp)
        sd t4, 224(sp)
    80004910:	f1f6                	sd	t4,224(sp)
        sd t5, 232(sp)
    80004912:	f5fa                	sd	t5,232(sp)
        sd t6, 240(sp)
    80004914:	f9fe                	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call kerneltrap
    80004916:	a40fd0ef          	jal	80001b56 <kerneltrap>

        # restore registers.
        ld ra, 0(sp)
    8000491a:	6082                	ld	ra,0(sp)
        # ld sp, 8(sp)
        ld gp, 16(sp)
    8000491c:	61c2                	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    8000491e:	7282                	ld	t0,32(sp)
        ld t1, 40(sp)
    80004920:	7322                	ld	t1,40(sp)
        ld t2, 48(sp)
    80004922:	73c2                	ld	t2,48(sp)
        ld a0, 72(sp)
    80004924:	6526                	ld	a0,72(sp)
        ld a1, 80(sp)
    80004926:	65c6                	ld	a1,80(sp)
        ld a2, 88(sp)
    80004928:	6666                	ld	a2,88(sp)
        ld a3, 96(sp)
    8000492a:	7686                	ld	a3,96(sp)
        ld a4, 104(sp)
    8000492c:	7726                	ld	a4,104(sp)
        ld a5, 112(sp)
    8000492e:	77c6                	ld	a5,112(sp)
        ld a6, 120(sp)
    80004930:	7866                	ld	a6,120(sp)
        ld a7, 128(sp)
    80004932:	688a                	ld	a7,128(sp)
        ld t3, 216(sp)
    80004934:	6e6e                	ld	t3,216(sp)
        ld t4, 224(sp)
    80004936:	7e8e                	ld	t4,224(sp)
        ld t5, 232(sp)
    80004938:	7f2e                	ld	t5,232(sp)
        ld t6, 240(sp)
    8000493a:	7fce                	ld	t6,240(sp)

        addi sp, sp, 256
    8000493c:	6111                	addi	sp,sp,256

        # return to whatever we were doing in the kernel.
        sret
    8000493e:	10200073          	sret
    80004942:	00000013          	nop
    80004946:	00000013          	nop
    8000494a:	00000013          	nop

000000008000494e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000494e:	1141                	addi	sp,sp,-16
    80004950:	e406                	sd	ra,8(sp)
    80004952:	e022                	sd	s0,0(sp)
    80004954:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80004956:	0c000737          	lui	a4,0xc000
    8000495a:	4785                	li	a5,1
    8000495c:	d71c                	sw	a5,40(a4)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8000495e:	c35c                	sw	a5,4(a4)
}
    80004960:	60a2                	ld	ra,8(sp)
    80004962:	6402                	ld	s0,0(sp)
    80004964:	0141                	addi	sp,sp,16
    80004966:	8082                	ret

0000000080004968 <plicinithart>:

void
plicinithart(void)
{
    80004968:	1141                	addi	sp,sp,-16
    8000496a:	e406                	sd	ra,8(sp)
    8000496c:	e022                	sd	s0,0(sp)
    8000496e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004970:	bd8fc0ef          	jal	80000d48 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80004974:	0085171b          	slliw	a4,a0,0x8
    80004978:	0c0027b7          	lui	a5,0xc002
    8000497c:	97ba                	add	a5,a5,a4
    8000497e:	40200713          	li	a4,1026
    80004982:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80004986:	00d5151b          	slliw	a0,a0,0xd
    8000498a:	0c2017b7          	lui	a5,0xc201
    8000498e:	97aa                	add	a5,a5,a0
    80004990:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80004994:	60a2                	ld	ra,8(sp)
    80004996:	6402                	ld	s0,0(sp)
    80004998:	0141                	addi	sp,sp,16
    8000499a:	8082                	ret

000000008000499c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000499c:	1141                	addi	sp,sp,-16
    8000499e:	e406                	sd	ra,8(sp)
    800049a0:	e022                	sd	s0,0(sp)
    800049a2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800049a4:	ba4fc0ef          	jal	80000d48 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800049a8:	00d5151b          	slliw	a0,a0,0xd
    800049ac:	0c2017b7          	lui	a5,0xc201
    800049b0:	97aa                	add	a5,a5,a0
  return irq;
}
    800049b2:	43c8                	lw	a0,4(a5)
    800049b4:	60a2                	ld	ra,8(sp)
    800049b6:	6402                	ld	s0,0(sp)
    800049b8:	0141                	addi	sp,sp,16
    800049ba:	8082                	ret

00000000800049bc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800049bc:	1101                	addi	sp,sp,-32
    800049be:	ec06                	sd	ra,24(sp)
    800049c0:	e822                	sd	s0,16(sp)
    800049c2:	e426                	sd	s1,8(sp)
    800049c4:	1000                	addi	s0,sp,32
    800049c6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800049c8:	b80fc0ef          	jal	80000d48 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800049cc:	00d5179b          	slliw	a5,a0,0xd
    800049d0:	0c201737          	lui	a4,0xc201
    800049d4:	97ba                	add	a5,a5,a4
    800049d6:	c3c4                	sw	s1,4(a5)
}
    800049d8:	60e2                	ld	ra,24(sp)
    800049da:	6442                	ld	s0,16(sp)
    800049dc:	64a2                	ld	s1,8(sp)
    800049de:	6105                	addi	sp,sp,32
    800049e0:	8082                	ret

00000000800049e2 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800049e2:	1141                	addi	sp,sp,-16
    800049e4:	e406                	sd	ra,8(sp)
    800049e6:	e022                	sd	s0,0(sp)
    800049e8:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800049ea:	479d                	li	a5,7
    800049ec:	04a7ca63          	blt	a5,a0,80004a40 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    800049f0:	00019797          	auipc	a5,0x19
    800049f4:	f9078793          	addi	a5,a5,-112 # 8001d980 <disk>
    800049f8:	97aa                	add	a5,a5,a0
    800049fa:	0187c783          	lbu	a5,24(a5)
    800049fe:	e7b9                	bnez	a5,80004a4c <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80004a00:	00451693          	slli	a3,a0,0x4
    80004a04:	00019797          	auipc	a5,0x19
    80004a08:	f7c78793          	addi	a5,a5,-132 # 8001d980 <disk>
    80004a0c:	6398                	ld	a4,0(a5)
    80004a0e:	9736                	add	a4,a4,a3
    80004a10:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x73dff000>
  disk.desc[i].len = 0;
    80004a14:	6398                	ld	a4,0(a5)
    80004a16:	9736                	add	a4,a4,a3
    80004a18:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80004a1c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80004a20:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80004a24:	97aa                	add	a5,a5,a0
    80004a26:	4705                	li	a4,1
    80004a28:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80004a2c:	00019517          	auipc	a0,0x19
    80004a30:	f6c50513          	addi	a0,a0,-148 # 8001d998 <disk+0x18>
    80004a34:	9a3fc0ef          	jal	800013d6 <wakeup>
}
    80004a38:	60a2                	ld	ra,8(sp)
    80004a3a:	6402                	ld	s0,0(sp)
    80004a3c:	0141                	addi	sp,sp,16
    80004a3e:	8082                	ret
    panic("free_desc 1");
    80004a40:	00003517          	auipc	a0,0x3
    80004a44:	b7050513          	addi	a0,a0,-1168 # 800075b0 <etext+0x5b0>
    80004a48:	517000ef          	jal	8000575e <panic>
    panic("free_desc 2");
    80004a4c:	00003517          	auipc	a0,0x3
    80004a50:	b7450513          	addi	a0,a0,-1164 # 800075c0 <etext+0x5c0>
    80004a54:	50b000ef          	jal	8000575e <panic>

0000000080004a58 <virtio_disk_init>:
{
    80004a58:	1101                	addi	sp,sp,-32
    80004a5a:	ec06                	sd	ra,24(sp)
    80004a5c:	e822                	sd	s0,16(sp)
    80004a5e:	e426                	sd	s1,8(sp)
    80004a60:	e04a                	sd	s2,0(sp)
    80004a62:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80004a64:	00003597          	auipc	a1,0x3
    80004a68:	b6c58593          	addi	a1,a1,-1172 # 800075d0 <etext+0x5d0>
    80004a6c:	00019517          	auipc	a0,0x19
    80004a70:	03c50513          	addi	a0,a0,60 # 8001daa8 <disk+0x128>
    80004a74:	703000ef          	jal	80005976 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004a78:	100017b7          	lui	a5,0x10001
    80004a7c:	4398                	lw	a4,0(a5)
    80004a7e:	2701                	sext.w	a4,a4
    80004a80:	747277b7          	lui	a5,0x74727
    80004a84:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80004a88:	14f71863          	bne	a4,a5,80004bd8 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80004a8c:	100017b7          	lui	a5,0x10001
    80004a90:	43dc                	lw	a5,4(a5)
    80004a92:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004a94:	4709                	li	a4,2
    80004a96:	14e79163          	bne	a5,a4,80004bd8 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80004a9a:	100017b7          	lui	a5,0x10001
    80004a9e:	479c                	lw	a5,8(a5)
    80004aa0:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80004aa2:	12e79b63          	bne	a5,a4,80004bd8 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80004aa6:	100017b7          	lui	a5,0x10001
    80004aaa:	47d8                	lw	a4,12(a5)
    80004aac:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80004aae:	554d47b7          	lui	a5,0x554d4
    80004ab2:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80004ab6:	12f71163          	bne	a4,a5,80004bd8 <virtio_disk_init+0x180>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004aba:	100017b7          	lui	a5,0x10001
    80004abe:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004ac2:	4705                	li	a4,1
    80004ac4:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004ac6:	470d                	li	a4,3
    80004ac8:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80004aca:	10001737          	lui	a4,0x10001
    80004ace:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80004ad0:	c7ffe6b7          	lui	a3,0xc7ffe
    80004ad4:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fd8bc7>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80004ad8:	8f75                	and	a4,a4,a3
    80004ada:	100016b7          	lui	a3,0x10001
    80004ade:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004ae0:	472d                	li	a4,11
    80004ae2:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004ae4:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80004ae8:	439c                	lw	a5,0(a5)
    80004aea:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80004aee:	8ba1                	andi	a5,a5,8
    80004af0:	0e078a63          	beqz	a5,80004be4 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80004af4:	100017b7          	lui	a5,0x10001
    80004af8:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80004afc:	43fc                	lw	a5,68(a5)
    80004afe:	2781                	sext.w	a5,a5
    80004b00:	0e079863          	bnez	a5,80004bf0 <virtio_disk_init+0x198>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80004b04:	100017b7          	lui	a5,0x10001
    80004b08:	5bdc                	lw	a5,52(a5)
    80004b0a:	2781                	sext.w	a5,a5
  if(max == 0)
    80004b0c:	0e078863          	beqz	a5,80004bfc <virtio_disk_init+0x1a4>
  if(max < NUM)
    80004b10:	471d                	li	a4,7
    80004b12:	0ef77b63          	bgeu	a4,a5,80004c08 <virtio_disk_init+0x1b0>
  disk.desc = kalloc();
    80004b16:	deefb0ef          	jal	80000104 <kalloc>
    80004b1a:	00019497          	auipc	s1,0x19
    80004b1e:	e6648493          	addi	s1,s1,-410 # 8001d980 <disk>
    80004b22:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80004b24:	de0fb0ef          	jal	80000104 <kalloc>
    80004b28:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80004b2a:	ddafb0ef          	jal	80000104 <kalloc>
    80004b2e:	87aa                	mv	a5,a0
    80004b30:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80004b32:	6088                	ld	a0,0(s1)
    80004b34:	0e050063          	beqz	a0,80004c14 <virtio_disk_init+0x1bc>
    80004b38:	00019717          	auipc	a4,0x19
    80004b3c:	e5073703          	ld	a4,-432(a4) # 8001d988 <disk+0x8>
    80004b40:	cb71                	beqz	a4,80004c14 <virtio_disk_init+0x1bc>
    80004b42:	cbe9                	beqz	a5,80004c14 <virtio_disk_init+0x1bc>
  memset(disk.desc, 0, PGSIZE);
    80004b44:	6605                	lui	a2,0x1
    80004b46:	4581                	li	a1,0
    80004b48:	e16fb0ef          	jal	8000015e <memset>
  memset(disk.avail, 0, PGSIZE);
    80004b4c:	00019497          	auipc	s1,0x19
    80004b50:	e3448493          	addi	s1,s1,-460 # 8001d980 <disk>
    80004b54:	6605                	lui	a2,0x1
    80004b56:	4581                	li	a1,0
    80004b58:	6488                	ld	a0,8(s1)
    80004b5a:	e04fb0ef          	jal	8000015e <memset>
  memset(disk.used, 0, PGSIZE);
    80004b5e:	6605                	lui	a2,0x1
    80004b60:	4581                	li	a1,0
    80004b62:	6888                	ld	a0,16(s1)
    80004b64:	dfafb0ef          	jal	8000015e <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80004b68:	100017b7          	lui	a5,0x10001
    80004b6c:	4721                	li	a4,8
    80004b6e:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80004b70:	4098                	lw	a4,0(s1)
    80004b72:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80004b76:	40d8                	lw	a4,4(s1)
    80004b78:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80004b7c:	649c                	ld	a5,8(s1)
    80004b7e:	0007869b          	sext.w	a3,a5
    80004b82:	10001737          	lui	a4,0x10001
    80004b86:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80004b8a:	9781                	srai	a5,a5,0x20
    80004b8c:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80004b90:	689c                	ld	a5,16(s1)
    80004b92:	0007869b          	sext.w	a3,a5
    80004b96:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80004b9a:	9781                	srai	a5,a5,0x20
    80004b9c:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80004ba0:	4785                	li	a5,1
    80004ba2:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80004ba4:	00f48c23          	sb	a5,24(s1)
    80004ba8:	00f48ca3          	sb	a5,25(s1)
    80004bac:	00f48d23          	sb	a5,26(s1)
    80004bb0:	00f48da3          	sb	a5,27(s1)
    80004bb4:	00f48e23          	sb	a5,28(s1)
    80004bb8:	00f48ea3          	sb	a5,29(s1)
    80004bbc:	00f48f23          	sb	a5,30(s1)
    80004bc0:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80004bc4:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80004bc8:	07272823          	sw	s2,112(a4)
}
    80004bcc:	60e2                	ld	ra,24(sp)
    80004bce:	6442                	ld	s0,16(sp)
    80004bd0:	64a2                	ld	s1,8(sp)
    80004bd2:	6902                	ld	s2,0(sp)
    80004bd4:	6105                	addi	sp,sp,32
    80004bd6:	8082                	ret
    panic("could not find virtio disk");
    80004bd8:	00003517          	auipc	a0,0x3
    80004bdc:	a0850513          	addi	a0,a0,-1528 # 800075e0 <etext+0x5e0>
    80004be0:	37f000ef          	jal	8000575e <panic>
    panic("virtio disk FEATURES_OK unset");
    80004be4:	00003517          	auipc	a0,0x3
    80004be8:	a1c50513          	addi	a0,a0,-1508 # 80007600 <etext+0x600>
    80004bec:	373000ef          	jal	8000575e <panic>
    panic("virtio disk should not be ready");
    80004bf0:	00003517          	auipc	a0,0x3
    80004bf4:	a3050513          	addi	a0,a0,-1488 # 80007620 <etext+0x620>
    80004bf8:	367000ef          	jal	8000575e <panic>
    panic("virtio disk has no queue 0");
    80004bfc:	00003517          	auipc	a0,0x3
    80004c00:	a4450513          	addi	a0,a0,-1468 # 80007640 <etext+0x640>
    80004c04:	35b000ef          	jal	8000575e <panic>
    panic("virtio disk max queue too short");
    80004c08:	00003517          	auipc	a0,0x3
    80004c0c:	a5850513          	addi	a0,a0,-1448 # 80007660 <etext+0x660>
    80004c10:	34f000ef          	jal	8000575e <panic>
    panic("virtio disk kalloc");
    80004c14:	00003517          	auipc	a0,0x3
    80004c18:	a6c50513          	addi	a0,a0,-1428 # 80007680 <etext+0x680>
    80004c1c:	343000ef          	jal	8000575e <panic>

0000000080004c20 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80004c20:	711d                	addi	sp,sp,-96
    80004c22:	ec86                	sd	ra,88(sp)
    80004c24:	e8a2                	sd	s0,80(sp)
    80004c26:	e4a6                	sd	s1,72(sp)
    80004c28:	e0ca                	sd	s2,64(sp)
    80004c2a:	fc4e                	sd	s3,56(sp)
    80004c2c:	f852                	sd	s4,48(sp)
    80004c2e:	f456                	sd	s5,40(sp)
    80004c30:	f05a                	sd	s6,32(sp)
    80004c32:	ec5e                	sd	s7,24(sp)
    80004c34:	e862                	sd	s8,16(sp)
    80004c36:	1080                	addi	s0,sp,96
    80004c38:	89aa                	mv	s3,a0
    80004c3a:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80004c3c:	00c52b83          	lw	s7,12(a0)
    80004c40:	001b9b9b          	slliw	s7,s7,0x1
    80004c44:	1b82                	slli	s7,s7,0x20
    80004c46:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    80004c4a:	00019517          	auipc	a0,0x19
    80004c4e:	e5e50513          	addi	a0,a0,-418 # 8001daa8 <disk+0x128>
    80004c52:	5af000ef          	jal	80005a00 <acquire>
  for(int i = 0; i < NUM; i++){
    80004c56:	44a1                	li	s1,8
      disk.free[i] = 0;
    80004c58:	00019a97          	auipc	s5,0x19
    80004c5c:	d28a8a93          	addi	s5,s5,-728 # 8001d980 <disk>
  for(int i = 0; i < 3; i++){
    80004c60:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    80004c62:	5c7d                	li	s8,-1
    80004c64:	a095                	j	80004cc8 <virtio_disk_rw+0xa8>
      disk.free[i] = 0;
    80004c66:	00fa8733          	add	a4,s5,a5
    80004c6a:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80004c6e:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80004c70:	0207c563          	bltz	a5,80004c9a <virtio_disk_rw+0x7a>
  for(int i = 0; i < 3; i++){
    80004c74:	2905                	addiw	s2,s2,1
    80004c76:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80004c78:	05490c63          	beq	s2,s4,80004cd0 <virtio_disk_rw+0xb0>
    idx[i] = alloc_desc();
    80004c7c:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80004c7e:	00019717          	auipc	a4,0x19
    80004c82:	d0270713          	addi	a4,a4,-766 # 8001d980 <disk>
    80004c86:	4781                	li	a5,0
    if(disk.free[i]){
    80004c88:	01874683          	lbu	a3,24(a4)
    80004c8c:	fee9                	bnez	a3,80004c66 <virtio_disk_rw+0x46>
  for(int i = 0; i < NUM; i++){
    80004c8e:	2785                	addiw	a5,a5,1
    80004c90:	0705                	addi	a4,a4,1
    80004c92:	fe979be3          	bne	a5,s1,80004c88 <virtio_disk_rw+0x68>
    idx[i] = alloc_desc();
    80004c96:	0185a023          	sw	s8,0(a1)
      for(int j = 0; j < i; j++)
    80004c9a:	01205d63          	blez	s2,80004cb4 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    80004c9e:	fa042503          	lw	a0,-96(s0)
    80004ca2:	d41ff0ef          	jal	800049e2 <free_desc>
      for(int j = 0; j < i; j++)
    80004ca6:	4785                	li	a5,1
    80004ca8:	0127d663          	bge	a5,s2,80004cb4 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    80004cac:	fa442503          	lw	a0,-92(s0)
    80004cb0:	d33ff0ef          	jal	800049e2 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004cb4:	00019597          	auipc	a1,0x19
    80004cb8:	df458593          	addi	a1,a1,-524 # 8001daa8 <disk+0x128>
    80004cbc:	00019517          	auipc	a0,0x19
    80004cc0:	cdc50513          	addi	a0,a0,-804 # 8001d998 <disk+0x18>
    80004cc4:	ec6fc0ef          	jal	8000138a <sleep>
  for(int i = 0; i < 3; i++){
    80004cc8:	fa040613          	addi	a2,s0,-96
    80004ccc:	4901                	li	s2,0
    80004cce:	b77d                	j	80004c7c <virtio_disk_rw+0x5c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004cd0:	fa042503          	lw	a0,-96(s0)
    80004cd4:	00451693          	slli	a3,a0,0x4

  if(write)
    80004cd8:	00019797          	auipc	a5,0x19
    80004cdc:	ca878793          	addi	a5,a5,-856 # 8001d980 <disk>
    80004ce0:	00451713          	slli	a4,a0,0x4
    80004ce4:	0a070713          	addi	a4,a4,160
    80004ce8:	973e                	add	a4,a4,a5
    80004cea:	01603633          	snez	a2,s6
    80004cee:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80004cf0:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80004cf4:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80004cf8:	6398                	ld	a4,0(a5)
    80004cfa:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004cfc:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x6fffef58>
    80004d00:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80004d02:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80004d04:	6390                	ld	a2,0(a5)
    80004d06:	00d60833          	add	a6,a2,a3
    80004d0a:	4741                	li	a4,16
    80004d0c:	00e82423          	sw	a4,8(a6)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80004d10:	4585                	li	a1,1
    80004d12:	00b81623          	sh	a1,12(a6)
  disk.desc[idx[0]].next = idx[1];
    80004d16:	fa442703          	lw	a4,-92(s0)
    80004d1a:	00e81723          	sh	a4,14(a6)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80004d1e:	0712                	slli	a4,a4,0x4
    80004d20:	963a                	add	a2,a2,a4
    80004d22:	05898813          	addi	a6,s3,88
    80004d26:	01063023          	sd	a6,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80004d2a:	0007b883          	ld	a7,0(a5)
    80004d2e:	9746                	add	a4,a4,a7
    80004d30:	40000613          	li	a2,1024
    80004d34:	c710                	sw	a2,8(a4)
  if(write)
    80004d36:	001b3613          	seqz	a2,s6
    80004d3a:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80004d3e:	8e4d                	or	a2,a2,a1
    80004d40:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80004d44:	fa842603          	lw	a2,-88(s0)
    80004d48:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80004d4c:	00451813          	slli	a6,a0,0x4
    80004d50:	02080813          	addi	a6,a6,32
    80004d54:	983e                	add	a6,a6,a5
    80004d56:	577d                	li	a4,-1
    80004d58:	00e80823          	sb	a4,16(a6)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80004d5c:	0612                	slli	a2,a2,0x4
    80004d5e:	98b2                	add	a7,a7,a2
    80004d60:	03068713          	addi	a4,a3,48
    80004d64:	973e                	add	a4,a4,a5
    80004d66:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80004d6a:	6398                	ld	a4,0(a5)
    80004d6c:	9732                	add	a4,a4,a2
    80004d6e:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80004d70:	4689                	li	a3,2
    80004d72:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80004d76:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80004d7a:	00b9a223          	sw	a1,4(s3)
  disk.info[idx[0]].b = b;
    80004d7e:	01383423          	sd	s3,8(a6)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80004d82:	6794                	ld	a3,8(a5)
    80004d84:	0026d703          	lhu	a4,2(a3)
    80004d88:	8b1d                	andi	a4,a4,7
    80004d8a:	0706                	slli	a4,a4,0x1
    80004d8c:	96ba                	add	a3,a3,a4
    80004d8e:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80004d92:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80004d96:	6798                	ld	a4,8(a5)
    80004d98:	00275783          	lhu	a5,2(a4)
    80004d9c:	2785                	addiw	a5,a5,1
    80004d9e:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80004da2:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80004da6:	100017b7          	lui	a5,0x10001
    80004daa:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80004dae:	0049a783          	lw	a5,4(s3)
    sleep(b, &disk.vdisk_lock);
    80004db2:	00019917          	auipc	s2,0x19
    80004db6:	cf690913          	addi	s2,s2,-778 # 8001daa8 <disk+0x128>
  while(b->disk == 1) {
    80004dba:	84ae                	mv	s1,a1
    80004dbc:	00b79a63          	bne	a5,a1,80004dd0 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80004dc0:	85ca                	mv	a1,s2
    80004dc2:	854e                	mv	a0,s3
    80004dc4:	dc6fc0ef          	jal	8000138a <sleep>
  while(b->disk == 1) {
    80004dc8:	0049a783          	lw	a5,4(s3)
    80004dcc:	fe978ae3          	beq	a5,s1,80004dc0 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80004dd0:	fa042903          	lw	s2,-96(s0)
    80004dd4:	00491713          	slli	a4,s2,0x4
    80004dd8:	02070713          	addi	a4,a4,32
    80004ddc:	00019797          	auipc	a5,0x19
    80004de0:	ba478793          	addi	a5,a5,-1116 # 8001d980 <disk>
    80004de4:	97ba                	add	a5,a5,a4
    80004de6:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80004dea:	00019997          	auipc	s3,0x19
    80004dee:	b9698993          	addi	s3,s3,-1130 # 8001d980 <disk>
    80004df2:	00491713          	slli	a4,s2,0x4
    80004df6:	0009b783          	ld	a5,0(s3)
    80004dfa:	97ba                	add	a5,a5,a4
    80004dfc:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80004e00:	854a                	mv	a0,s2
    80004e02:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80004e06:	bddff0ef          	jal	800049e2 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80004e0a:	8885                	andi	s1,s1,1
    80004e0c:	f0fd                	bnez	s1,80004df2 <virtio_disk_rw+0x1d2>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80004e0e:	00019517          	auipc	a0,0x19
    80004e12:	c9a50513          	addi	a0,a0,-870 # 8001daa8 <disk+0x128>
    80004e16:	47f000ef          	jal	80005a94 <release>
}
    80004e1a:	60e6                	ld	ra,88(sp)
    80004e1c:	6446                	ld	s0,80(sp)
    80004e1e:	64a6                	ld	s1,72(sp)
    80004e20:	6906                	ld	s2,64(sp)
    80004e22:	79e2                	ld	s3,56(sp)
    80004e24:	7a42                	ld	s4,48(sp)
    80004e26:	7aa2                	ld	s5,40(sp)
    80004e28:	7b02                	ld	s6,32(sp)
    80004e2a:	6be2                	ld	s7,24(sp)
    80004e2c:	6c42                	ld	s8,16(sp)
    80004e2e:	6125                	addi	sp,sp,96
    80004e30:	8082                	ret

0000000080004e32 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80004e32:	1101                	addi	sp,sp,-32
    80004e34:	ec06                	sd	ra,24(sp)
    80004e36:	e822                	sd	s0,16(sp)
    80004e38:	e426                	sd	s1,8(sp)
    80004e3a:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80004e3c:	00019497          	auipc	s1,0x19
    80004e40:	b4448493          	addi	s1,s1,-1212 # 8001d980 <disk>
    80004e44:	00019517          	auipc	a0,0x19
    80004e48:	c6450513          	addi	a0,a0,-924 # 8001daa8 <disk+0x128>
    80004e4c:	3b5000ef          	jal	80005a00 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80004e50:	100017b7          	lui	a5,0x10001
    80004e54:	53bc                	lw	a5,96(a5)
    80004e56:	8b8d                	andi	a5,a5,3
    80004e58:	10001737          	lui	a4,0x10001
    80004e5c:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80004e5e:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80004e62:	689c                	ld	a5,16(s1)
    80004e64:	0204d703          	lhu	a4,32(s1)
    80004e68:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80004e6c:	04f70863          	beq	a4,a5,80004ebc <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80004e70:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80004e74:	6898                	ld	a4,16(s1)
    80004e76:	0204d783          	lhu	a5,32(s1)
    80004e7a:	8b9d                	andi	a5,a5,7
    80004e7c:	078e                	slli	a5,a5,0x3
    80004e7e:	97ba                	add	a5,a5,a4
    80004e80:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80004e82:	00479713          	slli	a4,a5,0x4
    80004e86:	02070713          	addi	a4,a4,32 # 10001020 <_entry-0x6fffefe0>
    80004e8a:	9726                	add	a4,a4,s1
    80004e8c:	01074703          	lbu	a4,16(a4)
    80004e90:	e329                	bnez	a4,80004ed2 <virtio_disk_intr+0xa0>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80004e92:	0792                	slli	a5,a5,0x4
    80004e94:	02078793          	addi	a5,a5,32
    80004e98:	97a6                	add	a5,a5,s1
    80004e9a:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80004e9c:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80004ea0:	d36fc0ef          	jal	800013d6 <wakeup>

    disk.used_idx += 1;
    80004ea4:	0204d783          	lhu	a5,32(s1)
    80004ea8:	2785                	addiw	a5,a5,1
    80004eaa:	17c2                	slli	a5,a5,0x30
    80004eac:	93c1                	srli	a5,a5,0x30
    80004eae:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80004eb2:	6898                	ld	a4,16(s1)
    80004eb4:	00275703          	lhu	a4,2(a4)
    80004eb8:	faf71ce3          	bne	a4,a5,80004e70 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80004ebc:	00019517          	auipc	a0,0x19
    80004ec0:	bec50513          	addi	a0,a0,-1044 # 8001daa8 <disk+0x128>
    80004ec4:	3d1000ef          	jal	80005a94 <release>
}
    80004ec8:	60e2                	ld	ra,24(sp)
    80004eca:	6442                	ld	s0,16(sp)
    80004ecc:	64a2                	ld	s1,8(sp)
    80004ece:	6105                	addi	sp,sp,32
    80004ed0:	8082                	ret
      panic("virtio_disk_intr status");
    80004ed2:	00002517          	auipc	a0,0x2
    80004ed6:	7c650513          	addi	a0,a0,1990 # 80007698 <etext+0x698>
    80004eda:	085000ef          	jal	8000575e <panic>

0000000080004ede <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    80004ede:	1141                	addi	sp,sp,-16
    80004ee0:	e406                	sd	ra,8(sp)
    80004ee2:	e022                	sd	s0,0(sp)
    80004ee4:	0800                	addi	s0,sp,16
	asm volatile("csrr %0, mie" : "=r"(x));
    80004ee6:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80004eea:	0207e793          	ori	a5,a5,32
	asm volatile("csrw mie, %0" : : "r"(x));
    80004eee:	30479073          	csrw	mie,a5
	asm volatile("csrr %0, 0x30a" : "=r"(x));
    80004ef2:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80004ef6:	577d                	li	a4,-1
    80004ef8:	177e                	slli	a4,a4,0x3f
    80004efa:	8fd9                	or	a5,a5,a4
	asm volatile("csrw 0x30a, %0" : : "r"(x));
    80004efc:	30a79073          	csrw	0x30a,a5
	asm volatile("csrr %0, mcounteren" : "=r"(x));
    80004f00:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80004f04:	0027e793          	ori	a5,a5,2
	asm volatile("csrw mcounteren, %0" : : "r"(x));
    80004f08:	30679073          	csrw	mcounteren,a5
	asm volatile("csrr %0, time" : "=r"(x));
    80004f0c:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    80004f10:	000f4737          	lui	a4,0xf4
    80004f14:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80004f18:	97ba                	add	a5,a5,a4
	asm volatile("csrw 0x14d, %0" : : "r"(x));
    80004f1a:	14d79073          	csrw	stimecmp,a5
}
    80004f1e:	60a2                	ld	ra,8(sp)
    80004f20:	6402                	ld	s0,0(sp)
    80004f22:	0141                	addi	sp,sp,16
    80004f24:	8082                	ret

0000000080004f26 <start>:
{
    80004f26:	1141                	addi	sp,sp,-16
    80004f28:	e406                	sd	ra,8(sp)
    80004f2a:	e022                	sd	s0,0(sp)
    80004f2c:	0800                	addi	s0,sp,16
	asm volatile("csrr %0, mstatus" : "=r"(x));
    80004f2e:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80004f32:	7779                	lui	a4,0xffffe
    80004f34:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd8c67>
    80004f38:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80004f3a:	6705                	lui	a4,0x1
    80004f3c:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80004f40:	8fd9                	or	a5,a5,a4
	asm volatile("csrw mstatus, %0" : : "r"(x));
    80004f42:	30079073          	csrw	mstatus,a5
	asm volatile("csrw mepc, %0" : : "r"(x));
    80004f46:	ffffb797          	auipc	a5,0xffffb
    80004f4a:	3ce78793          	addi	a5,a5,974 # 80000314 <main>
    80004f4e:	34179073          	csrw	mepc,a5
	asm volatile("csrw satp, %0" : : "r"(x));
    80004f52:	4781                	li	a5,0
    80004f54:	18079073          	csrw	satp,a5
	asm volatile("csrw medeleg, %0" : : "r"(x));
    80004f58:	67c1                	lui	a5,0x10
    80004f5a:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80004f5c:	30279073          	csrw	medeleg,a5
	asm volatile("csrw mideleg, %0" : : "r"(x));
    80004f60:	30379073          	csrw	mideleg,a5
	asm volatile("csrr %0, sie" : "=r"(x));
    80004f64:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE);
    80004f68:	2207e793          	ori	a5,a5,544
	asm volatile("csrw sie, %0" : : "r"(x));
    80004f6c:	10479073          	csrw	sie,a5
	asm volatile("csrw pmpaddr0, %0" : : "r"(x));
    80004f70:	57fd                	li	a5,-1
    80004f72:	83a9                	srli	a5,a5,0xa
    80004f74:	3b079073          	csrw	pmpaddr0,a5
	asm volatile("csrw pmpcfg0, %0" : : "r"(x));
    80004f78:	47bd                	li	a5,15
    80004f7a:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80004f7e:	f61ff0ef          	jal	80004ede <timerinit>
	asm volatile("csrr %0, mhartid" : "=r"(x));
    80004f82:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80004f86:	2781                	sext.w	a5,a5
	asm volatile("mv tp, %0" : : "r"(x));
    80004f88:	823e                	mv	tp,a5
  asm volatile("mret");
    80004f8a:	30200073          	mret
}
    80004f8e:	60a2                	ld	ra,8(sp)
    80004f90:	6402                	ld	s0,0(sp)
    80004f92:	0141                	addi	sp,sp,16
    80004f94:	8082                	ret

0000000080004f96 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80004f96:	7119                	addi	sp,sp,-128
    80004f98:	fc86                	sd	ra,120(sp)
    80004f9a:	f8a2                	sd	s0,112(sp)
    80004f9c:	f4a6                	sd	s1,104(sp)
    80004f9e:	0100                	addi	s0,sp,128
  char buf[32];
  int i = 0;

  while(i < n){
    80004fa0:	06c05b63          	blez	a2,80005016 <consolewrite+0x80>
    80004fa4:	f0ca                	sd	s2,96(sp)
    80004fa6:	ecce                	sd	s3,88(sp)
    80004fa8:	e8d2                	sd	s4,80(sp)
    80004faa:	e4d6                	sd	s5,72(sp)
    80004fac:	e0da                	sd	s6,64(sp)
    80004fae:	fc5e                	sd	s7,56(sp)
    80004fb0:	f862                	sd	s8,48(sp)
    80004fb2:	f466                	sd	s9,40(sp)
    80004fb4:	f06a                	sd	s10,32(sp)
    80004fb6:	8b2a                	mv	s6,a0
    80004fb8:	8bae                	mv	s7,a1
    80004fba:	8a32                	mv	s4,a2
  int i = 0;
    80004fbc:	4481                	li	s1,0
    int nn = sizeof(buf);
    if(nn > n - i)
    80004fbe:	02000c93          	li	s9,32
    80004fc2:	02000d13          	li	s10,32
      nn = n - i;
    if(either_copyin(buf, user_src, src+i, nn) == -1)
    80004fc6:	f8040a93          	addi	s5,s0,-128
    80004fca:	5c7d                	li	s8,-1
    80004fcc:	a025                	j	80004ff4 <consolewrite+0x5e>
    if(nn > n - i)
    80004fce:	0009099b          	sext.w	s3,s2
    if(either_copyin(buf, user_src, src+i, nn) == -1)
    80004fd2:	86ce                	mv	a3,s3
    80004fd4:	01748633          	add	a2,s1,s7
    80004fd8:	85da                	mv	a1,s6
    80004fda:	8556                	mv	a0,s5
    80004fdc:	f52fc0ef          	jal	8000172e <either_copyin>
    80004fe0:	03850d63          	beq	a0,s8,8000501a <consolewrite+0x84>
      break;
    uartwrite(buf, nn);
    80004fe4:	85ce                	mv	a1,s3
    80004fe6:	8556                	mv	a0,s5
    80004fe8:	00d000ef          	jal	800057f4 <uartwrite>
    i += nn;
    80004fec:	009904bb          	addw	s1,s2,s1
  while(i < n){
    80004ff0:	0144d963          	bge	s1,s4,80005002 <consolewrite+0x6c>
    if(nn > n - i)
    80004ff4:	409a07bb          	subw	a5,s4,s1
    80004ff8:	893e                	mv	s2,a5
    80004ffa:	fcfcdae3          	bge	s9,a5,80004fce <consolewrite+0x38>
    80004ffe:	896a                	mv	s2,s10
    80005000:	b7f9                	j	80004fce <consolewrite+0x38>
    80005002:	7906                	ld	s2,96(sp)
    80005004:	69e6                	ld	s3,88(sp)
    80005006:	6a46                	ld	s4,80(sp)
    80005008:	6aa6                	ld	s5,72(sp)
    8000500a:	6b06                	ld	s6,64(sp)
    8000500c:	7be2                	ld	s7,56(sp)
    8000500e:	7c42                	ld	s8,48(sp)
    80005010:	7ca2                	ld	s9,40(sp)
    80005012:	7d02                	ld	s10,32(sp)
    80005014:	a821                	j	8000502c <consolewrite+0x96>
  int i = 0;
    80005016:	4481                	li	s1,0
    80005018:	a811                	j	8000502c <consolewrite+0x96>
    8000501a:	7906                	ld	s2,96(sp)
    8000501c:	69e6                	ld	s3,88(sp)
    8000501e:	6a46                	ld	s4,80(sp)
    80005020:	6aa6                	ld	s5,72(sp)
    80005022:	6b06                	ld	s6,64(sp)
    80005024:	7be2                	ld	s7,56(sp)
    80005026:	7c42                	ld	s8,48(sp)
    80005028:	7ca2                	ld	s9,40(sp)
    8000502a:	7d02                	ld	s10,32(sp)
  }

  return i;
}
    8000502c:	8526                	mv	a0,s1
    8000502e:	70e6                	ld	ra,120(sp)
    80005030:	7446                	ld	s0,112(sp)
    80005032:	74a6                	ld	s1,104(sp)
    80005034:	6109                	addi	sp,sp,128
    80005036:	8082                	ret

0000000080005038 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005038:	711d                	addi	sp,sp,-96
    8000503a:	ec86                	sd	ra,88(sp)
    8000503c:	e8a2                	sd	s0,80(sp)
    8000503e:	e4a6                	sd	s1,72(sp)
    80005040:	e0ca                	sd	s2,64(sp)
    80005042:	fc4e                	sd	s3,56(sp)
    80005044:	f852                	sd	s4,48(sp)
    80005046:	f05a                	sd	s6,32(sp)
    80005048:	ec5e                	sd	s7,24(sp)
    8000504a:	1080                	addi	s0,sp,96
    8000504c:	8b2a                	mv	s6,a0
    8000504e:	8a2e                	mv	s4,a1
    80005050:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005052:	8bb2                	mv	s7,a2
  acquire(&cons.lock);
    80005054:	00021517          	auipc	a0,0x21
    80005058:	a6c50513          	addi	a0,a0,-1428 # 80025ac0 <cons>
    8000505c:	1a5000ef          	jal	80005a00 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005060:	00021497          	auipc	s1,0x21
    80005064:	a6048493          	addi	s1,s1,-1440 # 80025ac0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005068:	00021917          	auipc	s2,0x21
    8000506c:	af090913          	addi	s2,s2,-1296 # 80025b58 <cons+0x98>
  while(n > 0){
    80005070:	0b305b63          	blez	s3,80005126 <consoleread+0xee>
    while(cons.r == cons.w){
    80005074:	0984a783          	lw	a5,152(s1)
    80005078:	09c4a703          	lw	a4,156(s1)
    8000507c:	0af71063          	bne	a4,a5,8000511c <consoleread+0xe4>
      if(killed(myproc())){
    80005080:	cfdfb0ef          	jal	80000d7c <myproc>
    80005084:	d42fc0ef          	jal	800015c6 <killed>
    80005088:	e12d                	bnez	a0,800050ea <consoleread+0xb2>
      sleep(&cons.r, &cons.lock);
    8000508a:	85a6                	mv	a1,s1
    8000508c:	854a                	mv	a0,s2
    8000508e:	afcfc0ef          	jal	8000138a <sleep>
    while(cons.r == cons.w){
    80005092:	0984a783          	lw	a5,152(s1)
    80005096:	09c4a703          	lw	a4,156(s1)
    8000509a:	fef703e3          	beq	a4,a5,80005080 <consoleread+0x48>
    8000509e:	f456                	sd	s5,40(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800050a0:	00021717          	auipc	a4,0x21
    800050a4:	a2070713          	addi	a4,a4,-1504 # 80025ac0 <cons>
    800050a8:	0017869b          	addiw	a3,a5,1
    800050ac:	08d72c23          	sw	a3,152(a4)
    800050b0:	07f7f693          	andi	a3,a5,127
    800050b4:	9736                	add	a4,a4,a3
    800050b6:	01874703          	lbu	a4,24(a4)
    800050ba:	00070a9b          	sext.w	s5,a4

    if(c == C('D')){  // end-of-file
    800050be:	4691                	li	a3,4
    800050c0:	04da8663          	beq	s5,a3,8000510c <consoleread+0xd4>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    800050c4:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800050c8:	4685                	li	a3,1
    800050ca:	faf40613          	addi	a2,s0,-81
    800050ce:	85d2                	mv	a1,s4
    800050d0:	855a                	mv	a0,s6
    800050d2:	e12fc0ef          	jal	800016e4 <either_copyout>
    800050d6:	57fd                	li	a5,-1
    800050d8:	04f50663          	beq	a0,a5,80005124 <consoleread+0xec>
      break;

    dst++;
    800050dc:	0a05                	addi	s4,s4,1
    --n;
    800050de:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    800050e0:	47a9                	li	a5,10
    800050e2:	04fa8b63          	beq	s5,a5,80005138 <consoleread+0x100>
    800050e6:	7aa2                	ld	s5,40(sp)
    800050e8:	b761                	j	80005070 <consoleread+0x38>
        release(&cons.lock);
    800050ea:	00021517          	auipc	a0,0x21
    800050ee:	9d650513          	addi	a0,a0,-1578 # 80025ac0 <cons>
    800050f2:	1a3000ef          	jal	80005a94 <release>
        return -1;
    800050f6:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    800050f8:	60e6                	ld	ra,88(sp)
    800050fa:	6446                	ld	s0,80(sp)
    800050fc:	64a6                	ld	s1,72(sp)
    800050fe:	6906                	ld	s2,64(sp)
    80005100:	79e2                	ld	s3,56(sp)
    80005102:	7a42                	ld	s4,48(sp)
    80005104:	7b02                	ld	s6,32(sp)
    80005106:	6be2                	ld	s7,24(sp)
    80005108:	6125                	addi	sp,sp,96
    8000510a:	8082                	ret
      if(n < target){
    8000510c:	0179fa63          	bgeu	s3,s7,80005120 <consoleread+0xe8>
        cons.r--;
    80005110:	00021717          	auipc	a4,0x21
    80005114:	a4f72423          	sw	a5,-1464(a4) # 80025b58 <cons+0x98>
    80005118:	7aa2                	ld	s5,40(sp)
    8000511a:	a031                	j	80005126 <consoleread+0xee>
    8000511c:	f456                	sd	s5,40(sp)
    8000511e:	b749                	j	800050a0 <consoleread+0x68>
    80005120:	7aa2                	ld	s5,40(sp)
    80005122:	a011                	j	80005126 <consoleread+0xee>
    80005124:	7aa2                	ld	s5,40(sp)
  release(&cons.lock);
    80005126:	00021517          	auipc	a0,0x21
    8000512a:	99a50513          	addi	a0,a0,-1638 # 80025ac0 <cons>
    8000512e:	167000ef          	jal	80005a94 <release>
  return target - n;
    80005132:	413b853b          	subw	a0,s7,s3
    80005136:	b7c9                	j	800050f8 <consoleread+0xc0>
    80005138:	7aa2                	ld	s5,40(sp)
    8000513a:	b7f5                	j	80005126 <consoleread+0xee>

000000008000513c <consputc>:
{
    8000513c:	1141                	addi	sp,sp,-16
    8000513e:	e406                	sd	ra,8(sp)
    80005140:	e022                	sd	s0,0(sp)
    80005142:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005144:	10000793          	li	a5,256
    80005148:	00f50863          	beq	a0,a5,80005158 <consputc+0x1c>
    uartputc_sync(c);
    8000514c:	73c000ef          	jal	80005888 <uartputc_sync>
}
    80005150:	60a2                	ld	ra,8(sp)
    80005152:	6402                	ld	s0,0(sp)
    80005154:	0141                	addi	sp,sp,16
    80005156:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005158:	4521                	li	a0,8
    8000515a:	72e000ef          	jal	80005888 <uartputc_sync>
    8000515e:	02000513          	li	a0,32
    80005162:	726000ef          	jal	80005888 <uartputc_sync>
    80005166:	4521                	li	a0,8
    80005168:	720000ef          	jal	80005888 <uartputc_sync>
    8000516c:	b7d5                	j	80005150 <consputc+0x14>

000000008000516e <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    8000516e:	1101                	addi	sp,sp,-32
    80005170:	ec06                	sd	ra,24(sp)
    80005172:	e822                	sd	s0,16(sp)
    80005174:	e426                	sd	s1,8(sp)
    80005176:	1000                	addi	s0,sp,32
    80005178:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    8000517a:	00021517          	auipc	a0,0x21
    8000517e:	94650513          	addi	a0,a0,-1722 # 80025ac0 <cons>
    80005182:	07f000ef          	jal	80005a00 <acquire>

  switch(c){
    80005186:	47d5                	li	a5,21
    80005188:	08f48d63          	beq	s1,a5,80005222 <consoleintr+0xb4>
    8000518c:	0297c563          	blt	a5,s1,800051b6 <consoleintr+0x48>
    80005190:	47a1                	li	a5,8
    80005192:	0ef48263          	beq	s1,a5,80005276 <consoleintr+0x108>
    80005196:	47c1                	li	a5,16
    80005198:	10f49363          	bne	s1,a5,8000529e <consoleintr+0x130>
  case C('P'):  // Print process list.
    procdump();
    8000519c:	ddcfc0ef          	jal	80001778 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800051a0:	00021517          	auipc	a0,0x21
    800051a4:	92050513          	addi	a0,a0,-1760 # 80025ac0 <cons>
    800051a8:	0ed000ef          	jal	80005a94 <release>
}
    800051ac:	60e2                	ld	ra,24(sp)
    800051ae:	6442                	ld	s0,16(sp)
    800051b0:	64a2                	ld	s1,8(sp)
    800051b2:	6105                	addi	sp,sp,32
    800051b4:	8082                	ret
  switch(c){
    800051b6:	07f00793          	li	a5,127
    800051ba:	0af48e63          	beq	s1,a5,80005276 <consoleintr+0x108>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800051be:	00021717          	auipc	a4,0x21
    800051c2:	90270713          	addi	a4,a4,-1790 # 80025ac0 <cons>
    800051c6:	0a072783          	lw	a5,160(a4)
    800051ca:	09872703          	lw	a4,152(a4)
    800051ce:	9f99                	subw	a5,a5,a4
    800051d0:	07f00713          	li	a4,127
    800051d4:	fcf766e3          	bltu	a4,a5,800051a0 <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    800051d8:	47b5                	li	a5,13
    800051da:	0cf48563          	beq	s1,a5,800052a4 <consoleintr+0x136>
      consputc(c);
    800051de:	8526                	mv	a0,s1
    800051e0:	f5dff0ef          	jal	8000513c <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800051e4:	00021717          	auipc	a4,0x21
    800051e8:	8dc70713          	addi	a4,a4,-1828 # 80025ac0 <cons>
    800051ec:	0a072683          	lw	a3,160(a4)
    800051f0:	0016879b          	addiw	a5,a3,1
    800051f4:	863e                	mv	a2,a5
    800051f6:	0af72023          	sw	a5,160(a4)
    800051fa:	07f6f693          	andi	a3,a3,127
    800051fe:	9736                	add	a4,a4,a3
    80005200:	00970c23          	sb	s1,24(a4)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005204:	ff648713          	addi	a4,s1,-10
    80005208:	c371                	beqz	a4,800052cc <consoleintr+0x15e>
    8000520a:	14f1                	addi	s1,s1,-4
    8000520c:	c0e1                	beqz	s1,800052cc <consoleintr+0x15e>
    8000520e:	00021717          	auipc	a4,0x21
    80005212:	94a72703          	lw	a4,-1718(a4) # 80025b58 <cons+0x98>
    80005216:	9f99                	subw	a5,a5,a4
    80005218:	08000713          	li	a4,128
    8000521c:	f8e792e3          	bne	a5,a4,800051a0 <consoleintr+0x32>
    80005220:	a075                	j	800052cc <consoleintr+0x15e>
    80005222:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80005224:	00021717          	auipc	a4,0x21
    80005228:	89c70713          	addi	a4,a4,-1892 # 80025ac0 <cons>
    8000522c:	0a072783          	lw	a5,160(a4)
    80005230:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005234:	00021497          	auipc	s1,0x21
    80005238:	88c48493          	addi	s1,s1,-1908 # 80025ac0 <cons>
    while(cons.e != cons.w &&
    8000523c:	4929                	li	s2,10
    8000523e:	02f70863          	beq	a4,a5,8000526e <consoleintr+0x100>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005242:	37fd                	addiw	a5,a5,-1
    80005244:	07f7f713          	andi	a4,a5,127
    80005248:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    8000524a:	01874703          	lbu	a4,24(a4)
    8000524e:	03270263          	beq	a4,s2,80005272 <consoleintr+0x104>
      cons.e--;
    80005252:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005256:	10000513          	li	a0,256
    8000525a:	ee3ff0ef          	jal	8000513c <consputc>
    while(cons.e != cons.w &&
    8000525e:	0a04a783          	lw	a5,160(s1)
    80005262:	09c4a703          	lw	a4,156(s1)
    80005266:	fcf71ee3          	bne	a4,a5,80005242 <consoleintr+0xd4>
    8000526a:	6902                	ld	s2,0(sp)
    8000526c:	bf15                	j	800051a0 <consoleintr+0x32>
    8000526e:	6902                	ld	s2,0(sp)
    80005270:	bf05                	j	800051a0 <consoleintr+0x32>
    80005272:	6902                	ld	s2,0(sp)
    80005274:	b735                	j	800051a0 <consoleintr+0x32>
    if(cons.e != cons.w){
    80005276:	00021717          	auipc	a4,0x21
    8000527a:	84a70713          	addi	a4,a4,-1974 # 80025ac0 <cons>
    8000527e:	0a072783          	lw	a5,160(a4)
    80005282:	09c72703          	lw	a4,156(a4)
    80005286:	f0f70de3          	beq	a4,a5,800051a0 <consoleintr+0x32>
      cons.e--;
    8000528a:	37fd                	addiw	a5,a5,-1
    8000528c:	00021717          	auipc	a4,0x21
    80005290:	8cf72a23          	sw	a5,-1836(a4) # 80025b60 <cons+0xa0>
      consputc(BACKSPACE);
    80005294:	10000513          	li	a0,256
    80005298:	ea5ff0ef          	jal	8000513c <consputc>
    8000529c:	b711                	j	800051a0 <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    8000529e:	f00481e3          	beqz	s1,800051a0 <consoleintr+0x32>
    800052a2:	bf31                	j	800051be <consoleintr+0x50>
      consputc(c);
    800052a4:	4529                	li	a0,10
    800052a6:	e97ff0ef          	jal	8000513c <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800052aa:	00021797          	auipc	a5,0x21
    800052ae:	81678793          	addi	a5,a5,-2026 # 80025ac0 <cons>
    800052b2:	0a07a703          	lw	a4,160(a5)
    800052b6:	0017069b          	addiw	a3,a4,1
    800052ba:	8636                	mv	a2,a3
    800052bc:	0ad7a023          	sw	a3,160(a5)
    800052c0:	07f77713          	andi	a4,a4,127
    800052c4:	97ba                	add	a5,a5,a4
    800052c6:	4729                	li	a4,10
    800052c8:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    800052cc:	00021797          	auipc	a5,0x21
    800052d0:	88c7a823          	sw	a2,-1904(a5) # 80025b5c <cons+0x9c>
        wakeup(&cons.r);
    800052d4:	00021517          	auipc	a0,0x21
    800052d8:	88450513          	addi	a0,a0,-1916 # 80025b58 <cons+0x98>
    800052dc:	8fafc0ef          	jal	800013d6 <wakeup>
    800052e0:	b5c1                	j	800051a0 <consoleintr+0x32>

00000000800052e2 <consoleinit>:

void
consoleinit(void)
{
    800052e2:	1141                	addi	sp,sp,-16
    800052e4:	e406                	sd	ra,8(sp)
    800052e6:	e022                	sd	s0,0(sp)
    800052e8:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    800052ea:	00002597          	auipc	a1,0x2
    800052ee:	3c658593          	addi	a1,a1,966 # 800076b0 <etext+0x6b0>
    800052f2:	00020517          	auipc	a0,0x20
    800052f6:	7ce50513          	addi	a0,a0,1998 # 80025ac0 <cons>
    800052fa:	67c000ef          	jal	80005976 <initlock>

  uartinit();
    800052fe:	4a0000ef          	jal	8000579e <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005302:	00017797          	auipc	a5,0x17
    80005306:	62678793          	addi	a5,a5,1574 # 8001c928 <devsw>
    8000530a:	00000717          	auipc	a4,0x0
    8000530e:	d2e70713          	addi	a4,a4,-722 # 80005038 <consoleread>
    80005312:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005314:	00000717          	auipc	a4,0x0
    80005318:	c8270713          	addi	a4,a4,-894 # 80004f96 <consolewrite>
    8000531c:	ef98                	sd	a4,24(a5)
}
    8000531e:	60a2                	ld	ra,8(sp)
    80005320:	6402                	ld	s0,0(sp)
    80005322:	0141                	addi	sp,sp,16
    80005324:	8082                	ret

0000000080005326 <printint>:
} pr;

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign) {
    80005326:	7139                	addi	sp,sp,-64
    80005328:	fc06                	sd	ra,56(sp)
    8000532a:	f822                	sd	s0,48(sp)
    8000532c:	f04a                	sd	s2,32(sp)
    8000532e:	0080                	addi	s0,sp,64
	char buf[20];
	int i;
	unsigned long long x;

	if (sign && (sign = (xx < 0)))
    80005330:	c219                	beqz	a2,80005336 <printint+0x10>
    80005332:	08054163          	bltz	a0,800053b4 <printint+0x8e>
		x = -xx;
	else
		x = xx;
    80005336:	4301                	li	t1,0

	i = 0;
    80005338:	fc840913          	addi	s2,s0,-56
		x = xx;
    8000533c:	86ca                	mv	a3,s2
	i = 0;
    8000533e:	4701                	li	a4,0
	do {
		buf[i++] = digits[x % base];
    80005340:	00002817          	auipc	a6,0x2
    80005344:	4f080813          	addi	a6,a6,1264 # 80007830 <digits>
    80005348:	88ba                	mv	a7,a4
    8000534a:	0017061b          	addiw	a2,a4,1
    8000534e:	8732                	mv	a4,a2
    80005350:	02b577b3          	remu	a5,a0,a1
    80005354:	97c2                	add	a5,a5,a6
    80005356:	0007c783          	lbu	a5,0(a5)
    8000535a:	00f68023          	sb	a5,0(a3)
	} while ((x /= base) != 0);
    8000535e:	87aa                	mv	a5,a0
    80005360:	02b55533          	divu	a0,a0,a1
    80005364:	0685                	addi	a3,a3,1
    80005366:	feb7f1e3          	bgeu	a5,a1,80005348 <printint+0x22>

	if (sign)
    8000536a:	00030c63          	beqz	t1,80005382 <printint+0x5c>
		buf[i++] = '-';
    8000536e:	fe060793          	addi	a5,a2,-32
    80005372:	00878633          	add	a2,a5,s0
    80005376:	02d00793          	li	a5,45
    8000537a:	fef60423          	sb	a5,-24(a2)
    8000537e:	0028871b          	addiw	a4,a7,2

	while (--i >= 0)
    80005382:	02e05463          	blez	a4,800053aa <printint+0x84>
    80005386:	f426                	sd	s1,40(sp)
    80005388:	377d                	addiw	a4,a4,-1
    8000538a:	00e904b3          	add	s1,s2,a4
    8000538e:	197d                	addi	s2,s2,-1
    80005390:	993a                	add	s2,s2,a4
    80005392:	1702                	slli	a4,a4,0x20
    80005394:	9301                	srli	a4,a4,0x20
    80005396:	40e90933          	sub	s2,s2,a4
		consputc(buf[i]);
    8000539a:	0004c503          	lbu	a0,0(s1)
    8000539e:	d9fff0ef          	jal	8000513c <consputc>
	while (--i >= 0)
    800053a2:	14fd                	addi	s1,s1,-1
    800053a4:	ff249be3          	bne	s1,s2,8000539a <printint+0x74>
    800053a8:	74a2                	ld	s1,40(sp)
}
    800053aa:	70e2                	ld	ra,56(sp)
    800053ac:	7442                	ld	s0,48(sp)
    800053ae:	7902                	ld	s2,32(sp)
    800053b0:	6121                	addi	sp,sp,64
    800053b2:	8082                	ret
		x = -xx;
    800053b4:	40a00533          	neg	a0,a0
	if (sign && (sign = (xx < 0)))
    800053b8:	4305                	li	t1,1
		x = -xx;
    800053ba:	bfbd                	j	80005338 <printint+0x12>

00000000800053bc <printf>:
	for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
		consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
}

// Print to the console.
int printf(char* fmt, ...) {
    800053bc:	7131                	addi	sp,sp,-192
    800053be:	fc86                	sd	ra,120(sp)
    800053c0:	f8a2                	sd	s0,112(sp)
    800053c2:	f0ca                	sd	s2,96(sp)
    800053c4:	0100                	addi	s0,sp,128
    800053c6:	892a                	mv	s2,a0
    800053c8:	e40c                	sd	a1,8(s0)
    800053ca:	e810                	sd	a2,16(s0)
    800053cc:	ec14                	sd	a3,24(s0)
    800053ce:	f018                	sd	a4,32(s0)
    800053d0:	f41c                	sd	a5,40(s0)
    800053d2:	03043823          	sd	a6,48(s0)
    800053d6:	03143c23          	sd	a7,56(s0)
	va_list ap;
	int i, cx, c0, c1, c2;
	char* s;

	if (panicking == 0)
    800053da:	00002797          	auipc	a5,0x2
    800053de:	4a67a783          	lw	a5,1190(a5) # 80007880 <panicking>
    800053e2:	cf9d                	beqz	a5,80005420 <printf+0x64>
		acquire(&pr.lock);

	va_start(ap, fmt);
    800053e4:	00840793          	addi	a5,s0,8
    800053e8:	f8f43423          	sd	a5,-120(s0)
	for (i = 0; (cx = fmt[i] & 0xff) != 0; i++) {
    800053ec:	00094503          	lbu	a0,0(s2)
    800053f0:	22050663          	beqz	a0,8000561c <printf+0x260>
    800053f4:	f4a6                	sd	s1,104(sp)
    800053f6:	ecce                	sd	s3,88(sp)
    800053f8:	e8d2                	sd	s4,80(sp)
    800053fa:	e4d6                	sd	s5,72(sp)
    800053fc:	e0da                	sd	s6,64(sp)
    800053fe:	fc5e                	sd	s7,56(sp)
    80005400:	f862                	sd	s8,48(sp)
    80005402:	f06a                	sd	s10,32(sp)
    80005404:	ec6e                	sd	s11,24(sp)
    80005406:	4a01                	li	s4,0
		if (cx != '%') {
    80005408:	02500993          	li	s3,37
			printint(va_arg(ap, uint64), 10, 1);
			i += 1;
		} else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
			printint(va_arg(ap, uint64), 10, 1);
			i += 2;
		} else if (c0 == 'u') {
    8000540c:	07500c13          	li	s8,117
			printint(va_arg(ap, uint64), 10, 0);
			i += 1;
		} else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
			printint(va_arg(ap, uint64), 10, 0);
			i += 2;
		} else if (c0 == 'x') {
    80005410:	07800d13          	li	s10,120
			printint(va_arg(ap, uint64), 16, 0);
			i += 1;
		} else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
			printint(va_arg(ap, uint64), 16, 0);
			i += 2;
		} else if (c0 == 'p') {
    80005414:	07000d93          	li	s11,112
			printint(va_arg(ap, uint64), 10, 0);
    80005418:	4b29                	li	s6,10
		if (c0 == 'd') {
    8000541a:	06400b93          	li	s7,100
    8000541e:	a015                	j	80005442 <printf+0x86>
		acquire(&pr.lock);
    80005420:	00020517          	auipc	a0,0x20
    80005424:	74850513          	addi	a0,a0,1864 # 80025b68 <pr>
    80005428:	5d8000ef          	jal	80005a00 <acquire>
    8000542c:	bf65                	j	800053e4 <printf+0x28>
			consputc(cx);
    8000542e:	d0fff0ef          	jal	8000513c <consputc>
			continue;
    80005432:	84d2                	mv	s1,s4
	for (i = 0; (cx = fmt[i] & 0xff) != 0; i++) {
    80005434:	2485                	addiw	s1,s1,1
    80005436:	8a26                	mv	s4,s1
    80005438:	94ca                	add	s1,s1,s2
    8000543a:	0004c503          	lbu	a0,0(s1)
    8000543e:	1c050663          	beqz	a0,8000560a <printf+0x24e>
		if (cx != '%') {
    80005442:	ff3516e3          	bne	a0,s3,8000542e <printf+0x72>
		i++;
    80005446:	001a079b          	addiw	a5,s4,1
    8000544a:	84be                	mv	s1,a5
		c0 = fmt[i + 0] & 0xff;
    8000544c:	00f90733          	add	a4,s2,a5
    80005450:	00074a83          	lbu	s5,0(a4)
		if (c0) c1 = fmt[i + 1] & 0xff;
    80005454:	200a8963          	beqz	s5,80005666 <printf+0x2aa>
    80005458:	00174683          	lbu	a3,1(a4)
		if (c1) c2 = fmt[i + 2] & 0xff;
    8000545c:	1e068c63          	beqz	a3,80005654 <printf+0x298>
		if (c0 == 'd') {
    80005460:	037a8863          	beq	s5,s7,80005490 <printf+0xd4>
		} else if (c0 == 'l' && c1 == 'd') {
    80005464:	f94a8713          	addi	a4,s5,-108
    80005468:	00173713          	seqz	a4,a4
    8000546c:	f9c68613          	addi	a2,a3,-100
    80005470:	ee05                	bnez	a2,800054a8 <printf+0xec>
    80005472:	cb1d                	beqz	a4,800054a8 <printf+0xec>
			printint(va_arg(ap, uint64), 10, 1);
    80005474:	f8843783          	ld	a5,-120(s0)
    80005478:	00878713          	addi	a4,a5,8
    8000547c:	f8e43423          	sd	a4,-120(s0)
    80005480:	4605                	li	a2,1
    80005482:	85da                	mv	a1,s6
    80005484:	6388                	ld	a0,0(a5)
    80005486:	ea1ff0ef          	jal	80005326 <printint>
			i += 1;
    8000548a:	002a049b          	addiw	s1,s4,2
    8000548e:	b75d                	j	80005434 <printf+0x78>
			printint(va_arg(ap, int), 10, 1);
    80005490:	f8843783          	ld	a5,-120(s0)
    80005494:	00878713          	addi	a4,a5,8
    80005498:	f8e43423          	sd	a4,-120(s0)
    8000549c:	4605                	li	a2,1
    8000549e:	85da                	mv	a1,s6
    800054a0:	4388                	lw	a0,0(a5)
    800054a2:	e85ff0ef          	jal	80005326 <printint>
    800054a6:	b779                	j	80005434 <printf+0x78>
		if (c1) c2 = fmt[i + 2] & 0xff;
    800054a8:	97ca                	add	a5,a5,s2
    800054aa:	8636                	mv	a2,a3
    800054ac:	0027c683          	lbu	a3,2(a5)
    800054b0:	a2c9                	j	80005672 <printf+0x2b6>
			printint(va_arg(ap, uint64), 10, 1);
    800054b2:	f8843783          	ld	a5,-120(s0)
    800054b6:	00878713          	addi	a4,a5,8
    800054ba:	f8e43423          	sd	a4,-120(s0)
    800054be:	4605                	li	a2,1
    800054c0:	45a9                	li	a1,10
    800054c2:	6388                	ld	a0,0(a5)
    800054c4:	e63ff0ef          	jal	80005326 <printint>
			i += 2;
    800054c8:	003a049b          	addiw	s1,s4,3
    800054cc:	b7a5                	j	80005434 <printf+0x78>
			printint(va_arg(ap, uint32), 10, 0);
    800054ce:	f8843783          	ld	a5,-120(s0)
    800054d2:	00878713          	addi	a4,a5,8
    800054d6:	f8e43423          	sd	a4,-120(s0)
    800054da:	4601                	li	a2,0
    800054dc:	85da                	mv	a1,s6
    800054de:	0007e503          	lwu	a0,0(a5)
    800054e2:	e45ff0ef          	jal	80005326 <printint>
    800054e6:	b7b9                	j	80005434 <printf+0x78>
			printint(va_arg(ap, uint64), 10, 0);
    800054e8:	f8843783          	ld	a5,-120(s0)
    800054ec:	00878713          	addi	a4,a5,8
    800054f0:	f8e43423          	sd	a4,-120(s0)
    800054f4:	4601                	li	a2,0
    800054f6:	85da                	mv	a1,s6
    800054f8:	6388                	ld	a0,0(a5)
    800054fa:	e2dff0ef          	jal	80005326 <printint>
			i += 1;
    800054fe:	002a049b          	addiw	s1,s4,2
    80005502:	bf0d                	j	80005434 <printf+0x78>
			printint(va_arg(ap, uint64), 10, 0);
    80005504:	f8843783          	ld	a5,-120(s0)
    80005508:	00878713          	addi	a4,a5,8
    8000550c:	f8e43423          	sd	a4,-120(s0)
    80005510:	4601                	li	a2,0
    80005512:	45a9                	li	a1,10
    80005514:	6388                	ld	a0,0(a5)
    80005516:	e11ff0ef          	jal	80005326 <printint>
			i += 2;
    8000551a:	003a049b          	addiw	s1,s4,3
    8000551e:	bf19                	j	80005434 <printf+0x78>
			printint(va_arg(ap, uint32), 16, 0);
    80005520:	f8843783          	ld	a5,-120(s0)
    80005524:	00878713          	addi	a4,a5,8
    80005528:	f8e43423          	sd	a4,-120(s0)
    8000552c:	4601                	li	a2,0
    8000552e:	45c1                	li	a1,16
    80005530:	0007e503          	lwu	a0,0(a5)
    80005534:	df3ff0ef          	jal	80005326 <printint>
    80005538:	bdf5                	j	80005434 <printf+0x78>
			printint(va_arg(ap, uint64), 16, 0);
    8000553a:	f8843783          	ld	a5,-120(s0)
    8000553e:	00878713          	addi	a4,a5,8
    80005542:	f8e43423          	sd	a4,-120(s0)
    80005546:	45c1                	li	a1,16
    80005548:	6388                	ld	a0,0(a5)
    8000554a:	dddff0ef          	jal	80005326 <printint>
			i += 1;
    8000554e:	002a049b          	addiw	s1,s4,2
    80005552:	b5cd                	j	80005434 <printf+0x78>
			printint(va_arg(ap, uint64), 16, 0);
    80005554:	f8843783          	ld	a5,-120(s0)
    80005558:	00878713          	addi	a4,a5,8
    8000555c:	f8e43423          	sd	a4,-120(s0)
    80005560:	4601                	li	a2,0
    80005562:	45c1                	li	a1,16
    80005564:	6388                	ld	a0,0(a5)
    80005566:	dc1ff0ef          	jal	80005326 <printint>
			i += 2;
    8000556a:	003a049b          	addiw	s1,s4,3
    8000556e:	b5d9                	j	80005434 <printf+0x78>
    80005570:	f466                	sd	s9,40(sp)
			printptr(va_arg(ap, uint64));
    80005572:	f8843783          	ld	a5,-120(s0)
    80005576:	00878713          	addi	a4,a5,8
    8000557a:	f8e43423          	sd	a4,-120(s0)
    8000557e:	0007ba83          	ld	s5,0(a5)
	consputc('0');
    80005582:	03000513          	li	a0,48
    80005586:	bb7ff0ef          	jal	8000513c <consputc>
	consputc('x');
    8000558a:	07800513          	li	a0,120
    8000558e:	bafff0ef          	jal	8000513c <consputc>
    80005592:	4a41                	li	s4,16
		consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005594:	00002c97          	auipc	s9,0x2
    80005598:	29cc8c93          	addi	s9,s9,668 # 80007830 <digits>
    8000559c:	03cad793          	srli	a5,s5,0x3c
    800055a0:	97e6                	add	a5,a5,s9
    800055a2:	0007c503          	lbu	a0,0(a5)
    800055a6:	b97ff0ef          	jal	8000513c <consputc>
	for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800055aa:	0a92                	slli	s5,s5,0x4
    800055ac:	3a7d                	addiw	s4,s4,-1
    800055ae:	fe0a17e3          	bnez	s4,8000559c <printf+0x1e0>
    800055b2:	7ca2                	ld	s9,40(sp)
    800055b4:	b541                	j	80005434 <printf+0x78>
		} else if (c0 == 'c') {
			consputc(va_arg(ap, uint));
    800055b6:	f8843783          	ld	a5,-120(s0)
    800055ba:	00878713          	addi	a4,a5,8
    800055be:	f8e43423          	sd	a4,-120(s0)
    800055c2:	4388                	lw	a0,0(a5)
    800055c4:	b79ff0ef          	jal	8000513c <consputc>
    800055c8:	b5b5                	j	80005434 <printf+0x78>
		} else if (c0 == 's') {
			if ((s = va_arg(ap, char*)) == 0)
    800055ca:	f8843783          	ld	a5,-120(s0)
    800055ce:	00878713          	addi	a4,a5,8
    800055d2:	f8e43423          	sd	a4,-120(s0)
    800055d6:	0007ba03          	ld	s4,0(a5)
    800055da:	000a0d63          	beqz	s4,800055f4 <printf+0x238>
				s = "(null)";
			for (; *s; s++)
    800055de:	000a4503          	lbu	a0,0(s4)
    800055e2:	e40509e3          	beqz	a0,80005434 <printf+0x78>
				consputc(*s);
    800055e6:	b57ff0ef          	jal	8000513c <consputc>
			for (; *s; s++)
    800055ea:	0a05                	addi	s4,s4,1
    800055ec:	000a4503          	lbu	a0,0(s4)
    800055f0:	f97d                	bnez	a0,800055e6 <printf+0x22a>
    800055f2:	b589                	j	80005434 <printf+0x78>
				s = "(null)";
    800055f4:	00002a17          	auipc	s4,0x2
    800055f8:	0c4a0a13          	addi	s4,s4,196 # 800076b8 <etext+0x6b8>
			for (; *s; s++)
    800055fc:	02800513          	li	a0,40
    80005600:	b7dd                	j	800055e6 <printf+0x22a>
		} else if (c0 == '%') {
			consputc('%');
    80005602:	8556                	mv	a0,s5
    80005604:	b39ff0ef          	jal	8000513c <consputc>
    80005608:	b535                	j	80005434 <printf+0x78>
    8000560a:	74a6                	ld	s1,104(sp)
    8000560c:	69e6                	ld	s3,88(sp)
    8000560e:	6a46                	ld	s4,80(sp)
    80005610:	6aa6                	ld	s5,72(sp)
    80005612:	6b06                	ld	s6,64(sp)
    80005614:	7be2                	ld	s7,56(sp)
    80005616:	7c42                	ld	s8,48(sp)
    80005618:	7d02                	ld	s10,32(sp)
    8000561a:	6de2                	ld	s11,24(sp)
			consputc(c0);
		}
	}
	va_end(ap);

	if (panicking == 0)
    8000561c:	00002797          	auipc	a5,0x2
    80005620:	2647a783          	lw	a5,612(a5) # 80007880 <panicking>
    80005624:	c38d                	beqz	a5,80005646 <printf+0x28a>
		release(&pr.lock);

	return 0;
}
    80005626:	4501                	li	a0,0
    80005628:	70e6                	ld	ra,120(sp)
    8000562a:	7446                	ld	s0,112(sp)
    8000562c:	7906                	ld	s2,96(sp)
    8000562e:	6129                	addi	sp,sp,192
    80005630:	8082                	ret
    80005632:	74a6                	ld	s1,104(sp)
    80005634:	69e6                	ld	s3,88(sp)
    80005636:	6a46                	ld	s4,80(sp)
    80005638:	6aa6                	ld	s5,72(sp)
    8000563a:	6b06                	ld	s6,64(sp)
    8000563c:	7be2                	ld	s7,56(sp)
    8000563e:	7c42                	ld	s8,48(sp)
    80005640:	7d02                	ld	s10,32(sp)
    80005642:	6de2                	ld	s11,24(sp)
    80005644:	bfe1                	j	8000561c <printf+0x260>
		release(&pr.lock);
    80005646:	00020517          	auipc	a0,0x20
    8000564a:	52250513          	addi	a0,a0,1314 # 80025b68 <pr>
    8000564e:	446000ef          	jal	80005a94 <release>
	return 0;
    80005652:	bfd1                	j	80005626 <printf+0x26a>
		if (c0 == 'd') {
    80005654:	e37a8ee3          	beq	s5,s7,80005490 <printf+0xd4>
		} else if (c0 == 'l' && c1 == 'd') {
    80005658:	f94a8713          	addi	a4,s5,-108
    8000565c:	00173713          	seqz	a4,a4
    80005660:	8636                	mv	a2,a3
		} else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
    80005662:	4781                	li	a5,0
    80005664:	a00d                	j	80005686 <printf+0x2ca>
		} else if (c0 == 'l' && c1 == 'd') {
    80005666:	f94a8713          	addi	a4,s5,-108
    8000566a:	00173713          	seqz	a4,a4
		c1 = c2 = 0;
    8000566e:	8656                	mv	a2,s5
    80005670:	86d6                	mv	a3,s5
		} else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
    80005672:	f9460793          	addi	a5,a2,-108
    80005676:	0017b793          	seqz	a5,a5
    8000567a:	8ff9                	and	a5,a5,a4
    8000567c:	f9c68593          	addi	a1,a3,-100
    80005680:	e199                	bnez	a1,80005686 <printf+0x2ca>
    80005682:	e20798e3          	bnez	a5,800054b2 <printf+0xf6>
		} else if (c0 == 'u') {
    80005686:	e58a84e3          	beq	s5,s8,800054ce <printf+0x112>
		} else if (c0 == 'l' && c1 == 'u') {
    8000568a:	f8b60593          	addi	a1,a2,-117
    8000568e:	e199                	bnez	a1,80005694 <printf+0x2d8>
    80005690:	e4071ce3          	bnez	a4,800054e8 <printf+0x12c>
		} else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
    80005694:	f8b68593          	addi	a1,a3,-117
    80005698:	e199                	bnez	a1,8000569e <printf+0x2e2>
    8000569a:	e60795e3          	bnez	a5,80005504 <printf+0x148>
		} else if (c0 == 'x') {
    8000569e:	e9aa81e3          	beq	s5,s10,80005520 <printf+0x164>
		} else if (c0 == 'l' && c1 == 'x') {
    800056a2:	f8860613          	addi	a2,a2,-120
    800056a6:	e219                	bnez	a2,800056ac <printf+0x2f0>
    800056a8:	e80719e3          	bnez	a4,8000553a <printf+0x17e>
		} else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
    800056ac:	f8868693          	addi	a3,a3,-120
    800056b0:	e299                	bnez	a3,800056b6 <printf+0x2fa>
    800056b2:	ea0791e3          	bnez	a5,80005554 <printf+0x198>
		} else if (c0 == 'p') {
    800056b6:	ebba8de3          	beq	s5,s11,80005570 <printf+0x1b4>
		} else if (c0 == 'c') {
    800056ba:	06300793          	li	a5,99
    800056be:	eefa8ce3          	beq	s5,a5,800055b6 <printf+0x1fa>
		} else if (c0 == 's') {
    800056c2:	07300793          	li	a5,115
    800056c6:	f0fa82e3          	beq	s5,a5,800055ca <printf+0x20e>
		} else if (c0 == '%') {
    800056ca:	02500793          	li	a5,37
    800056ce:	f2fa8ae3          	beq	s5,a5,80005602 <printf+0x246>
		} else if (c0 == 0) {
    800056d2:	f60a80e3          	beqz	s5,80005632 <printf+0x276>
			consputc('%');
    800056d6:	02500513          	li	a0,37
    800056da:	a63ff0ef          	jal	8000513c <consputc>
			consputc(c0);
    800056de:	8556                	mv	a0,s5
    800056e0:	a5dff0ef          	jal	8000513c <consputc>
    800056e4:	bb81                	j	80005434 <printf+0x78>

00000000800056e6 <printfinit>:
	backtrace();
	panicked = 1;  // freeze uart output from other CPUs
	for (;;);
}

void printfinit(void) {
    800056e6:	1141                	addi	sp,sp,-16
    800056e8:	e406                	sd	ra,8(sp)
    800056ea:	e022                	sd	s0,0(sp)
    800056ec:	0800                	addi	s0,sp,16
	initlock(&pr.lock, "pr");
    800056ee:	00002597          	auipc	a1,0x2
    800056f2:	fd258593          	addi	a1,a1,-46 # 800076c0 <etext+0x6c0>
    800056f6:	00020517          	auipc	a0,0x20
    800056fa:	47250513          	addi	a0,a0,1138 # 80025b68 <pr>
    800056fe:	278000ef          	jal	80005976 <initlock>
}
    80005702:	60a2                	ld	ra,8(sp)
    80005704:	6402                	ld	s0,0(sp)
    80005706:	0141                	addi	sp,sp,16
    80005708:	8082                	ret

000000008000570a <backtrace>:

void backtrace() {
    8000570a:	7179                	addi	sp,sp,-48
    8000570c:	f406                	sd	ra,40(sp)
    8000570e:	f022                	sd	s0,32(sp)
    80005710:	ec26                	sd	s1,24(sp)
    80005712:	e84a                	sd	s2,16(sp)
    80005714:	1800                	addi	s0,sp,48
	printf("backtrace:\n");
    80005716:	00002517          	auipc	a0,0x2
    8000571a:	fb250513          	addi	a0,a0,-78 # 800076c8 <etext+0x6c8>
    8000571e:	c9fff0ef          	jal	800053bc <printf>
typedef uint64* pagetable_t;  // 512 PTEs

static inline uint64
r_fp() {
	uint64 x;
	asm volatile("mv %0, s0" : "=r"(x));
    80005722:	84a2                	mv	s1,s0
	uint64 fp = r_fp();
	uint64 top = PGROUNDUP(fp);  // All stack frames are in the same page
    80005724:	6905                	lui	s2,0x1
    80005726:	197d                	addi	s2,s2,-1 # fff <_entry-0x7ffff001>
    80005728:	9926                	add	s2,s2,s1
    8000572a:	77fd                	lui	a5,0xfffff
    8000572c:	00f97933          	and	s2,s2,a5
	while (fp < top) {
    80005730:	0324f163          	bgeu	s1,s2,80005752 <backtrace+0x48>
    80005734:	e44e                	sd	s3,8(sp)
		printf("%p\n", (void*)*(uint64*)(fp - 8));  // 64 bit pointers are 8 bytes
    80005736:	00002997          	auipc	s3,0x2
    8000573a:	fa298993          	addi	s3,s3,-94 # 800076d8 <etext+0x6d8>
    8000573e:	ff84b583          	ld	a1,-8(s1)
    80005742:	854e                	mv	a0,s3
    80005744:	c79ff0ef          	jal	800053bc <printf>
		fp = *(uint64*)(fp - 16);
    80005748:	ff04b483          	ld	s1,-16(s1)
	while (fp < top) {
    8000574c:	ff24e9e3          	bltu	s1,s2,8000573e <backtrace+0x34>
    80005750:	69a2                	ld	s3,8(sp)
	}
    80005752:	70a2                	ld	ra,40(sp)
    80005754:	7402                	ld	s0,32(sp)
    80005756:	64e2                	ld	s1,24(sp)
    80005758:	6942                	ld	s2,16(sp)
    8000575a:	6145                	addi	sp,sp,48
    8000575c:	8082                	ret

000000008000575e <panic>:
void panic(char* s) {
    8000575e:	1101                	addi	sp,sp,-32
    80005760:	ec06                	sd	ra,24(sp)
    80005762:	e822                	sd	s0,16(sp)
    80005764:	e426                	sd	s1,8(sp)
    80005766:	e04a                	sd	s2,0(sp)
    80005768:	1000                	addi	s0,sp,32
    8000576a:	892a                	mv	s2,a0
	panicking = 1;
    8000576c:	4485                	li	s1,1
    8000576e:	00002797          	auipc	a5,0x2
    80005772:	1097a923          	sw	s1,274(a5) # 80007880 <panicking>
	printf("panic: ");
    80005776:	00002517          	auipc	a0,0x2
    8000577a:	f6a50513          	addi	a0,a0,-150 # 800076e0 <etext+0x6e0>
    8000577e:	c3fff0ef          	jal	800053bc <printf>
	printf("%s\n", s);
    80005782:	85ca                	mv	a1,s2
    80005784:	00002517          	auipc	a0,0x2
    80005788:	f6450513          	addi	a0,a0,-156 # 800076e8 <etext+0x6e8>
    8000578c:	c31ff0ef          	jal	800053bc <printf>
	backtrace();
    80005790:	f7bff0ef          	jal	8000570a <backtrace>
	panicked = 1;  // freeze uart output from other CPUs
    80005794:	00002797          	auipc	a5,0x2
    80005798:	0e97a423          	sw	s1,232(a5) # 8000787c <panicked>
	for (;;);
    8000579c:	a001                	j	8000579c <panic+0x3e>

000000008000579e <uartinit>:
extern volatile int panicking; // from printf.c
extern volatile int panicked; // from printf.c

void
uartinit(void)
{
    8000579e:	1141                	addi	sp,sp,-16
    800057a0:	e406                	sd	ra,8(sp)
    800057a2:	e022                	sd	s0,0(sp)
    800057a4:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800057a6:	100007b7          	lui	a5,0x10000
    800057aa:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800057ae:	10000737          	lui	a4,0x10000
    800057b2:	f8000693          	li	a3,-128
    800057b6:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800057ba:	468d                	li	a3,3
    800057bc:	10000637          	lui	a2,0x10000
    800057c0:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800057c4:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800057c8:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800057cc:	8732                	mv	a4,a2
    800057ce:	461d                	li	a2,7
    800057d0:	00c70123          	sb	a2,2(a4)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800057d4:	00d780a3          	sb	a3,1(a5)

  initlock(&tx_lock, "uart");
    800057d8:	00002597          	auipc	a1,0x2
    800057dc:	f1858593          	addi	a1,a1,-232 # 800076f0 <etext+0x6f0>
    800057e0:	00020517          	auipc	a0,0x20
    800057e4:	3a050513          	addi	a0,a0,928 # 80025b80 <tx_lock>
    800057e8:	18e000ef          	jal	80005976 <initlock>
}
    800057ec:	60a2                	ld	ra,8(sp)
    800057ee:	6402                	ld	s0,0(sp)
    800057f0:	0141                	addi	sp,sp,16
    800057f2:	8082                	ret

00000000800057f4 <uartwrite>:
// transmit buf[] to the uart. it blocks if the
// uart is busy, so it cannot be called from
// interrupts, only from write() system calls.
void
uartwrite(char buf[], int n)
{
    800057f4:	715d                	addi	sp,sp,-80
    800057f6:	e486                	sd	ra,72(sp)
    800057f8:	e0a2                	sd	s0,64(sp)
    800057fa:	fc26                	sd	s1,56(sp)
    800057fc:	ec56                	sd	s5,24(sp)
    800057fe:	0880                	addi	s0,sp,80
    80005800:	8aaa                	mv	s5,a0
    80005802:	84ae                	mv	s1,a1
  acquire(&tx_lock);
    80005804:	00020517          	auipc	a0,0x20
    80005808:	37c50513          	addi	a0,a0,892 # 80025b80 <tx_lock>
    8000580c:	1f4000ef          	jal	80005a00 <acquire>

  int i = 0;
  while(i < n){ 
    80005810:	06905063          	blez	s1,80005870 <uartwrite+0x7c>
    80005814:	f84a                	sd	s2,48(sp)
    80005816:	f44e                	sd	s3,40(sp)
    80005818:	f052                	sd	s4,32(sp)
    8000581a:	e85a                	sd	s6,16(sp)
    8000581c:	e45e                	sd	s7,8(sp)
    8000581e:	8a56                	mv	s4,s5
    80005820:	9aa6                	add	s5,s5,s1
    while(tx_busy != 0){
    80005822:	00002497          	auipc	s1,0x2
    80005826:	06648493          	addi	s1,s1,102 # 80007888 <tx_busy>
      // wait for a UART transmit-complete interrupt
      // to set tx_busy to 0.
      sleep(&tx_chan, &tx_lock);
    8000582a:	00020997          	auipc	s3,0x20
    8000582e:	35698993          	addi	s3,s3,854 # 80025b80 <tx_lock>
    80005832:	00002917          	auipc	s2,0x2
    80005836:	05290913          	addi	s2,s2,82 # 80007884 <tx_chan>
    }   
      
    WriteReg(THR, buf[i]);
    8000583a:	10000bb7          	lui	s7,0x10000
    i += 1;
    tx_busy = 1;
    8000583e:	4b05                	li	s6,1
    80005840:	a005                	j	80005860 <uartwrite+0x6c>
      sleep(&tx_chan, &tx_lock);
    80005842:	85ce                	mv	a1,s3
    80005844:	854a                	mv	a0,s2
    80005846:	b45fb0ef          	jal	8000138a <sleep>
    while(tx_busy != 0){
    8000584a:	409c                	lw	a5,0(s1)
    8000584c:	fbfd                	bnez	a5,80005842 <uartwrite+0x4e>
    WriteReg(THR, buf[i]);
    8000584e:	000a4783          	lbu	a5,0(s4)
    80005852:	00fb8023          	sb	a5,0(s7) # 10000000 <_entry-0x70000000>
    tx_busy = 1;
    80005856:	0164a023          	sw	s6,0(s1)
  while(i < n){ 
    8000585a:	0a05                	addi	s4,s4,1
    8000585c:	015a0563          	beq	s4,s5,80005866 <uartwrite+0x72>
    while(tx_busy != 0){
    80005860:	409c                	lw	a5,0(s1)
    80005862:	f3e5                	bnez	a5,80005842 <uartwrite+0x4e>
    80005864:	b7ed                	j	8000584e <uartwrite+0x5a>
    80005866:	7942                	ld	s2,48(sp)
    80005868:	79a2                	ld	s3,40(sp)
    8000586a:	7a02                	ld	s4,32(sp)
    8000586c:	6b42                	ld	s6,16(sp)
    8000586e:	6ba2                	ld	s7,8(sp)
  }

  release(&tx_lock);
    80005870:	00020517          	auipc	a0,0x20
    80005874:	31050513          	addi	a0,a0,784 # 80025b80 <tx_lock>
    80005878:	21c000ef          	jal	80005a94 <release>
}
    8000587c:	60a6                	ld	ra,72(sp)
    8000587e:	6406                	ld	s0,64(sp)
    80005880:	74e2                	ld	s1,56(sp)
    80005882:	6ae2                	ld	s5,24(sp)
    80005884:	6161                	addi	sp,sp,80
    80005886:	8082                	ret

0000000080005888 <uartputc_sync>:
// interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005888:	1101                	addi	sp,sp,-32
    8000588a:	ec06                	sd	ra,24(sp)
    8000588c:	e822                	sd	s0,16(sp)
    8000588e:	e426                	sd	s1,8(sp)
    80005890:	1000                	addi	s0,sp,32
    80005892:	84aa                	mv	s1,a0
  if(panicking == 0)
    80005894:	00002797          	auipc	a5,0x2
    80005898:	fec7a783          	lw	a5,-20(a5) # 80007880 <panicking>
    8000589c:	cf95                	beqz	a5,800058d8 <uartputc_sync+0x50>
    push_off();

  if(panicked){
    8000589e:	00002797          	auipc	a5,0x2
    800058a2:	fde7a783          	lw	a5,-34(a5) # 8000787c <panicked>
    800058a6:	ef85                	bnez	a5,800058de <uartputc_sync+0x56>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800058a8:	10000737          	lui	a4,0x10000
    800058ac:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    800058ae:	00074783          	lbu	a5,0(a4)
    800058b2:	0207f793          	andi	a5,a5,32
    800058b6:	dfe5                	beqz	a5,800058ae <uartputc_sync+0x26>
    ;
  WriteReg(THR, c);
    800058b8:	0ff4f513          	zext.b	a0,s1
    800058bc:	100007b7          	lui	a5,0x10000
    800058c0:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  if(panicking == 0)
    800058c4:	00002797          	auipc	a5,0x2
    800058c8:	fbc7a783          	lw	a5,-68(a5) # 80007880 <panicking>
    800058cc:	cb91                	beqz	a5,800058e0 <uartputc_sync+0x58>
    pop_off();
}
    800058ce:	60e2                	ld	ra,24(sp)
    800058d0:	6442                	ld	s0,16(sp)
    800058d2:	64a2                	ld	s1,8(sp)
    800058d4:	6105                	addi	sp,sp,32
    800058d6:	8082                	ret
    push_off();
    800058d8:	0e4000ef          	jal	800059bc <push_off>
    800058dc:	b7c9                	j	8000589e <uartputc_sync+0x16>
    for(;;)
    800058de:	a001                	j	800058de <uartputc_sync+0x56>
    pop_off();
    800058e0:	164000ef          	jal	80005a44 <pop_off>
}
    800058e4:	b7ed                	j	800058ce <uartputc_sync+0x46>

00000000800058e6 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800058e6:	1141                	addi	sp,sp,-16
    800058e8:	e406                	sd	ra,8(sp)
    800058ea:	e022                	sd	s0,0(sp)
    800058ec:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & LSR_RX_READY){
    800058ee:	100007b7          	lui	a5,0x10000
    800058f2:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800058f6:	8b85                	andi	a5,a5,1
    800058f8:	cb89                	beqz	a5,8000590a <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800058fa:	100007b7          	lui	a5,0x10000
    800058fe:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80005902:	60a2                	ld	ra,8(sp)
    80005904:	6402                	ld	s0,0(sp)
    80005906:	0141                	addi	sp,sp,16
    80005908:	8082                	ret
    return -1;
    8000590a:	557d                	li	a0,-1
    8000590c:	bfdd                	j	80005902 <uartgetc+0x1c>

000000008000590e <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    8000590e:	1101                	addi	sp,sp,-32
    80005910:	ec06                	sd	ra,24(sp)
    80005912:	e822                	sd	s0,16(sp)
    80005914:	e426                	sd	s1,8(sp)
    80005916:	1000                	addi	s0,sp,32
  ReadReg(ISR); // acknowledge the interrupt
    80005918:	100007b7          	lui	a5,0x10000
    8000591c:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>

  acquire(&tx_lock);
    80005920:	00020517          	auipc	a0,0x20
    80005924:	26050513          	addi	a0,a0,608 # 80025b80 <tx_lock>
    80005928:	0d8000ef          	jal	80005a00 <acquire>
  if(ReadReg(LSR) & LSR_TX_IDLE){
    8000592c:	100007b7          	lui	a5,0x10000
    80005930:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80005934:	0207f793          	andi	a5,a5,32
    80005938:	ef99                	bnez	a5,80005956 <uartintr+0x48>
    // UART finished transmitting; wake up sending thread.
    tx_busy = 0;
    wakeup(&tx_chan);
  }
  release(&tx_lock);
    8000593a:	00020517          	auipc	a0,0x20
    8000593e:	24650513          	addi	a0,a0,582 # 80025b80 <tx_lock>
    80005942:	152000ef          	jal	80005a94 <release>

  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80005946:	54fd                	li	s1,-1
    int c = uartgetc();
    80005948:	f9fff0ef          	jal	800058e6 <uartgetc>
    if(c == -1)
    8000594c:	02950063          	beq	a0,s1,8000596c <uartintr+0x5e>
      break;
    consoleintr(c);
    80005950:	81fff0ef          	jal	8000516e <consoleintr>
  while(1){
    80005954:	bfd5                	j	80005948 <uartintr+0x3a>
    tx_busy = 0;
    80005956:	00002797          	auipc	a5,0x2
    8000595a:	f207a923          	sw	zero,-206(a5) # 80007888 <tx_busy>
    wakeup(&tx_chan);
    8000595e:	00002517          	auipc	a0,0x2
    80005962:	f2650513          	addi	a0,a0,-218 # 80007884 <tx_chan>
    80005966:	a71fb0ef          	jal	800013d6 <wakeup>
    8000596a:	bfc1                	j	8000593a <uartintr+0x2c>
  }
}
    8000596c:	60e2                	ld	ra,24(sp)
    8000596e:	6442                	ld	s0,16(sp)
    80005970:	64a2                	ld	s1,8(sp)
    80005972:	6105                	addi	sp,sp,32
    80005974:	8082                	ret

0000000080005976 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80005976:	1141                	addi	sp,sp,-16
    80005978:	e406                	sd	ra,8(sp)
    8000597a:	e022                	sd	s0,0(sp)
    8000597c:	0800                	addi	s0,sp,16
  lk->name = name;
    8000597e:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80005980:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80005984:	00053823          	sd	zero,16(a0)
}
    80005988:	60a2                	ld	ra,8(sp)
    8000598a:	6402                	ld	s0,0(sp)
    8000598c:	0141                	addi	sp,sp,16
    8000598e:	8082                	ret

0000000080005990 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80005990:	411c                	lw	a5,0(a0)
    80005992:	e399                	bnez	a5,80005998 <holding+0x8>
    80005994:	4501                	li	a0,0
  return r;
}
    80005996:	8082                	ret
{
    80005998:	1101                	addi	sp,sp,-32
    8000599a:	ec06                	sd	ra,24(sp)
    8000599c:	e822                	sd	s0,16(sp)
    8000599e:	e426                	sd	s1,8(sp)
    800059a0:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800059a2:	691c                	ld	a5,16(a0)
    800059a4:	84be                	mv	s1,a5
    800059a6:	bb6fb0ef          	jal	80000d5c <mycpu>
    800059aa:	40a48533          	sub	a0,s1,a0
    800059ae:	00153513          	seqz	a0,a0
}
    800059b2:	60e2                	ld	ra,24(sp)
    800059b4:	6442                	ld	s0,16(sp)
    800059b6:	64a2                	ld	s1,8(sp)
    800059b8:	6105                	addi	sp,sp,32
    800059ba:	8082                	ret

00000000800059bc <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800059bc:	1101                	addi	sp,sp,-32
    800059be:	ec06                	sd	ra,24(sp)
    800059c0:	e822                	sd	s0,16(sp)
    800059c2:	e426                	sd	s1,8(sp)
    800059c4:	1000                	addi	s0,sp,32
	asm volatile("csrr %0, sstatus" : "=r"(x));
    800059c6:	100027f3          	csrr	a5,sstatus
    800059ca:	84be                	mv	s1,a5
    800059cc:	100027f3          	csrr	a5,sstatus
	w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800059d0:	9bf5                	andi	a5,a5,-3
	asm volatile("csrw sstatus, %0" : : "r"(x));
    800059d2:	10079073          	csrw	sstatus,a5

  // disable interrupts to prevent an involuntary context
  // switch while using mycpu().
  intr_off();

  if(mycpu()->noff == 0)
    800059d6:	b86fb0ef          	jal	80000d5c <mycpu>
    800059da:	5d3c                	lw	a5,120(a0)
    800059dc:	cb99                	beqz	a5,800059f2 <push_off+0x36>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800059de:	b7efb0ef          	jal	80000d5c <mycpu>
    800059e2:	5d3c                	lw	a5,120(a0)
    800059e4:	2785                	addiw	a5,a5,1
    800059e6:	dd3c                	sw	a5,120(a0)
}
    800059e8:	60e2                	ld	ra,24(sp)
    800059ea:	6442                	ld	s0,16(sp)
    800059ec:	64a2                	ld	s1,8(sp)
    800059ee:	6105                	addi	sp,sp,32
    800059f0:	8082                	ret
    mycpu()->intena = old;
    800059f2:	b6afb0ef          	jal	80000d5c <mycpu>
	return (x & SSTATUS_SIE) != 0;
    800059f6:	0014d793          	srli	a5,s1,0x1
    800059fa:	8b85                	andi	a5,a5,1
    800059fc:	dd7c                	sw	a5,124(a0)
    800059fe:	b7c5                	j	800059de <push_off+0x22>

0000000080005a00 <acquire>:
{
    80005a00:	1101                	addi	sp,sp,-32
    80005a02:	ec06                	sd	ra,24(sp)
    80005a04:	e822                	sd	s0,16(sp)
    80005a06:	e426                	sd	s1,8(sp)
    80005a08:	1000                	addi	s0,sp,32
    80005a0a:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80005a0c:	fb1ff0ef          	jal	800059bc <push_off>
  if(holding(lk))
    80005a10:	8526                	mv	a0,s1
    80005a12:	f7fff0ef          	jal	80005990 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80005a16:	4705                	li	a4,1
  if(holding(lk))
    80005a18:	e105                	bnez	a0,80005a38 <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80005a1a:	87ba                	mv	a5,a4
    80005a1c:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80005a20:	2781                	sext.w	a5,a5
    80005a22:	ffe5                	bnez	a5,80005a1a <acquire+0x1a>
  __sync_synchronize();
    80005a24:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80005a28:	b34fb0ef          	jal	80000d5c <mycpu>
    80005a2c:	e888                	sd	a0,16(s1)
}
    80005a2e:	60e2                	ld	ra,24(sp)
    80005a30:	6442                	ld	s0,16(sp)
    80005a32:	64a2                	ld	s1,8(sp)
    80005a34:	6105                	addi	sp,sp,32
    80005a36:	8082                	ret
    panic("acquire");
    80005a38:	00002517          	auipc	a0,0x2
    80005a3c:	cc050513          	addi	a0,a0,-832 # 800076f8 <etext+0x6f8>
    80005a40:	d1fff0ef          	jal	8000575e <panic>

0000000080005a44 <pop_off>:

void
pop_off(void)
{
    80005a44:	1141                	addi	sp,sp,-16
    80005a46:	e406                	sd	ra,8(sp)
    80005a48:	e022                	sd	s0,0(sp)
    80005a4a:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80005a4c:	b10fb0ef          	jal	80000d5c <mycpu>
	asm volatile("csrr %0, sstatus" : "=r"(x));
    80005a50:	100027f3          	csrr	a5,sstatus
	return (x & SSTATUS_SIE) != 0;
    80005a54:	8b89                	andi	a5,a5,2
  if(intr_get())
    80005a56:	e39d                	bnez	a5,80005a7c <pop_off+0x38>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80005a58:	5d3c                	lw	a5,120(a0)
    80005a5a:	02f05763          	blez	a5,80005a88 <pop_off+0x44>
    panic("pop_off");
  c->noff -= 1;
    80005a5e:	37fd                	addiw	a5,a5,-1
    80005a60:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80005a62:	eb89                	bnez	a5,80005a74 <pop_off+0x30>
    80005a64:	5d7c                	lw	a5,124(a0)
    80005a66:	c799                	beqz	a5,80005a74 <pop_off+0x30>
	asm volatile("csrr %0, sstatus" : "=r"(x));
    80005a68:	100027f3          	csrr	a5,sstatus
	w_sstatus(r_sstatus() | SSTATUS_SIE);
    80005a6c:	0027e793          	ori	a5,a5,2
	asm volatile("csrw sstatus, %0" : : "r"(x));
    80005a70:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80005a74:	60a2                	ld	ra,8(sp)
    80005a76:	6402                	ld	s0,0(sp)
    80005a78:	0141                	addi	sp,sp,16
    80005a7a:	8082                	ret
    panic("pop_off - interruptible");
    80005a7c:	00002517          	auipc	a0,0x2
    80005a80:	c8450513          	addi	a0,a0,-892 # 80007700 <etext+0x700>
    80005a84:	cdbff0ef          	jal	8000575e <panic>
    panic("pop_off");
    80005a88:	00002517          	auipc	a0,0x2
    80005a8c:	c9050513          	addi	a0,a0,-880 # 80007718 <etext+0x718>
    80005a90:	ccfff0ef          	jal	8000575e <panic>

0000000080005a94 <release>:
{
    80005a94:	1101                	addi	sp,sp,-32
    80005a96:	ec06                	sd	ra,24(sp)
    80005a98:	e822                	sd	s0,16(sp)
    80005a9a:	e426                	sd	s1,8(sp)
    80005a9c:	1000                	addi	s0,sp,32
    80005a9e:	84aa                	mv	s1,a0
  if(!holding(lk))
    80005aa0:	ef1ff0ef          	jal	80005990 <holding>
    80005aa4:	c105                	beqz	a0,80005ac4 <release+0x30>
  lk->cpu = 0;
    80005aa6:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80005aaa:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80005aae:	0310000f          	fence	rw,w
    80005ab2:	0004a023          	sw	zero,0(s1)
  pop_off();
    80005ab6:	f8fff0ef          	jal	80005a44 <pop_off>
}
    80005aba:	60e2                	ld	ra,24(sp)
    80005abc:	6442                	ld	s0,16(sp)
    80005abe:	64a2                	ld	s1,8(sp)
    80005ac0:	6105                	addi	sp,sp,32
    80005ac2:	8082                	ret
    panic("release");
    80005ac4:	00002517          	auipc	a0,0x2
    80005ac8:	c5c50513          	addi	a0,a0,-932 # 80007720 <etext+0x720>
    80005acc:	c93ff0ef          	jal	8000575e <panic>
	...

0000000080006000 <_trampoline>:
    80006000:	14051073          	csrw	sscratch,a0
    80006004:	02000537          	lui	a0,0x2000
    80006008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000600a:	0536                	slli	a0,a0,0xd
    8000600c:	02153423          	sd	ra,40(a0)
    80006010:	02253823          	sd	sp,48(a0)
    80006014:	02353c23          	sd	gp,56(a0)
    80006018:	04453023          	sd	tp,64(a0)
    8000601c:	04553423          	sd	t0,72(a0)
    80006020:	04653823          	sd	t1,80(a0)
    80006024:	04753c23          	sd	t2,88(a0)
    80006028:	f120                	sd	s0,96(a0)
    8000602a:	f524                	sd	s1,104(a0)
    8000602c:	fd2c                	sd	a1,120(a0)
    8000602e:	e150                	sd	a2,128(a0)
    80006030:	e554                	sd	a3,136(a0)
    80006032:	e958                	sd	a4,144(a0)
    80006034:	ed5c                	sd	a5,152(a0)
    80006036:	0b053023          	sd	a6,160(a0)
    8000603a:	0b153423          	sd	a7,168(a0)
    8000603e:	0b253823          	sd	s2,176(a0)
    80006042:	0b353c23          	sd	s3,184(a0)
    80006046:	0d453023          	sd	s4,192(a0)
    8000604a:	0d553423          	sd	s5,200(a0)
    8000604e:	0d653823          	sd	s6,208(a0)
    80006052:	0d753c23          	sd	s7,216(a0)
    80006056:	0f853023          	sd	s8,224(a0)
    8000605a:	0f953423          	sd	s9,232(a0)
    8000605e:	0fa53823          	sd	s10,240(a0)
    80006062:	0fb53c23          	sd	s11,248(a0)
    80006066:	11c53023          	sd	t3,256(a0)
    8000606a:	11d53423          	sd	t4,264(a0)
    8000606e:	11e53823          	sd	t5,272(a0)
    80006072:	11f53c23          	sd	t6,280(a0)
    80006076:	140022f3          	csrr	t0,sscratch
    8000607a:	06553823          	sd	t0,112(a0)
    8000607e:	00853103          	ld	sp,8(a0)
    80006082:	02053203          	ld	tp,32(a0)
    80006086:	01053283          	ld	t0,16(a0)
    8000608a:	00053303          	ld	t1,0(a0)
    8000608e:	12000073          	sfence.vma
    80006092:	18031073          	csrw	satp,t1
    80006096:	12000073          	sfence.vma
    8000609a:	9282                	jalr	t0

000000008000609c <userret>:
    8000609c:	12000073          	sfence.vma
    800060a0:	18051073          	csrw	satp,a0
    800060a4:	12000073          	sfence.vma
    800060a8:	02000537          	lui	a0,0x2000
    800060ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800060ae:	0536                	slli	a0,a0,0xd
    800060b0:	02853083          	ld	ra,40(a0)
    800060b4:	03053103          	ld	sp,48(a0)
    800060b8:	03853183          	ld	gp,56(a0)
    800060bc:	04053203          	ld	tp,64(a0)
    800060c0:	04853283          	ld	t0,72(a0)
    800060c4:	05053303          	ld	t1,80(a0)
    800060c8:	05853383          	ld	t2,88(a0)
    800060cc:	7120                	ld	s0,96(a0)
    800060ce:	7524                	ld	s1,104(a0)
    800060d0:	7d2c                	ld	a1,120(a0)
    800060d2:	6150                	ld	a2,128(a0)
    800060d4:	6554                	ld	a3,136(a0)
    800060d6:	6958                	ld	a4,144(a0)
    800060d8:	6d5c                	ld	a5,152(a0)
    800060da:	0a053803          	ld	a6,160(a0)
    800060de:	0a853883          	ld	a7,168(a0)
    800060e2:	0b053903          	ld	s2,176(a0)
    800060e6:	0b853983          	ld	s3,184(a0)
    800060ea:	0c053a03          	ld	s4,192(a0)
    800060ee:	0c853a83          	ld	s5,200(a0)
    800060f2:	0d053b03          	ld	s6,208(a0)
    800060f6:	0d853b83          	ld	s7,216(a0)
    800060fa:	0e053c03          	ld	s8,224(a0)
    800060fe:	0e853c83          	ld	s9,232(a0)
    80006102:	0f053d03          	ld	s10,240(a0)
    80006106:	0f853d83          	ld	s11,248(a0)
    8000610a:	10053e03          	ld	t3,256(a0)
    8000610e:	10853e83          	ld	t4,264(a0)
    80006112:	11053f03          	ld	t5,272(a0)
    80006116:	11853f83          	ld	t6,280(a0)
    8000611a:	7928                	ld	a0,112(a0)
    8000611c:	10200073          	sret
	...
