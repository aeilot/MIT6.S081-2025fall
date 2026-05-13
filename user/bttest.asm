
user/_bttest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  pause(1);
   8:	4505                	li	a0,1
   a:	350000ef          	jal	35a <pause>
  exit(0);
   e:	4501                	li	a0,0
  10:	2ba000ef          	jal	2ca <exit>

0000000000000014 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  14:	1141                	addi	sp,sp,-16
  16:	e406                	sd	ra,8(sp)
  18:	e022                	sd	s0,0(sp)
  1a:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  1c:	fe5ff0ef          	jal	0 <main>
  exit(r);
  20:	2aa000ef          	jal	2ca <exit>

0000000000000024 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  24:	1141                	addi	sp,sp,-16
  26:	e406                	sd	ra,8(sp)
  28:	e022                	sd	s0,0(sp)
  2a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  2c:	87aa                	mv	a5,a0
  2e:	0585                	addi	a1,a1,1
  30:	0785                	addi	a5,a5,1
  32:	fff5c703          	lbu	a4,-1(a1)
  36:	fee78fa3          	sb	a4,-1(a5)
  3a:	fb75                	bnez	a4,2e <strcpy+0xa>
    ;
  return os;
}
  3c:	60a2                	ld	ra,8(sp)
  3e:	6402                	ld	s0,0(sp)
  40:	0141                	addi	sp,sp,16
  42:	8082                	ret

0000000000000044 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  44:	1141                	addi	sp,sp,-16
  46:	e406                	sd	ra,8(sp)
  48:	e022                	sd	s0,0(sp)
  4a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  4c:	00054783          	lbu	a5,0(a0)
  50:	cb91                	beqz	a5,64 <strcmp+0x20>
  52:	0005c703          	lbu	a4,0(a1)
  56:	00f71763          	bne	a4,a5,64 <strcmp+0x20>
    p++, q++;
  5a:	0505                	addi	a0,a0,1
  5c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  5e:	00054783          	lbu	a5,0(a0)
  62:	fbe5                	bnez	a5,52 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  64:	0005c503          	lbu	a0,0(a1)
}
  68:	40a7853b          	subw	a0,a5,a0
  6c:	60a2                	ld	ra,8(sp)
  6e:	6402                	ld	s0,0(sp)
  70:	0141                	addi	sp,sp,16
  72:	8082                	ret

0000000000000074 <strlen>:

uint
strlen(const char *s)
{
  74:	1141                	addi	sp,sp,-16
  76:	e406                	sd	ra,8(sp)
  78:	e022                	sd	s0,0(sp)
  7a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  7c:	00054783          	lbu	a5,0(a0)
  80:	cf91                	beqz	a5,9c <strlen+0x28>
  82:	00150793          	addi	a5,a0,1
  86:	86be                	mv	a3,a5
  88:	0785                	addi	a5,a5,1
  8a:	fff7c703          	lbu	a4,-1(a5)
  8e:	ff65                	bnez	a4,86 <strlen+0x12>
  90:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
  94:	60a2                	ld	ra,8(sp)
  96:	6402                	ld	s0,0(sp)
  98:	0141                	addi	sp,sp,16
  9a:	8082                	ret
  for(n = 0; s[n]; n++)
  9c:	4501                	li	a0,0
  9e:	bfdd                	j	94 <strlen+0x20>

00000000000000a0 <memset>:

void*
memset(void *dst, int c, uint n)
{
  a0:	1141                	addi	sp,sp,-16
  a2:	e406                	sd	ra,8(sp)
  a4:	e022                	sd	s0,0(sp)
  a6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  a8:	ca19                	beqz	a2,be <memset+0x1e>
  aa:	87aa                	mv	a5,a0
  ac:	1602                	slli	a2,a2,0x20
  ae:	9201                	srli	a2,a2,0x20
  b0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  b4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  b8:	0785                	addi	a5,a5,1
  ba:	fee79de3          	bne	a5,a4,b4 <memset+0x14>
  }
  return dst;
}
  be:	60a2                	ld	ra,8(sp)
  c0:	6402                	ld	s0,0(sp)
  c2:	0141                	addi	sp,sp,16
  c4:	8082                	ret

00000000000000c6 <strchr>:

char*
strchr(const char *s, char c)
{
  c6:	1141                	addi	sp,sp,-16
  c8:	e406                	sd	ra,8(sp)
  ca:	e022                	sd	s0,0(sp)
  cc:	0800                	addi	s0,sp,16
  for(; *s; s++)
  ce:	00054783          	lbu	a5,0(a0)
  d2:	cf81                	beqz	a5,ea <strchr+0x24>
    if(*s == c)
  d4:	00f58763          	beq	a1,a5,e2 <strchr+0x1c>
  for(; *s; s++)
  d8:	0505                	addi	a0,a0,1
  da:	00054783          	lbu	a5,0(a0)
  de:	fbfd                	bnez	a5,d4 <strchr+0xe>
      return (char*)s;
  return 0;
  e0:	4501                	li	a0,0
}
  e2:	60a2                	ld	ra,8(sp)
  e4:	6402                	ld	s0,0(sp)
  e6:	0141                	addi	sp,sp,16
  e8:	8082                	ret
  return 0;
  ea:	4501                	li	a0,0
  ec:	bfdd                	j	e2 <strchr+0x1c>

00000000000000ee <gets>:

char*
gets(char *buf, int max)
{
  ee:	711d                	addi	sp,sp,-96
  f0:	ec86                	sd	ra,88(sp)
  f2:	e8a2                	sd	s0,80(sp)
  f4:	e4a6                	sd	s1,72(sp)
  f6:	e0ca                	sd	s2,64(sp)
  f8:	fc4e                	sd	s3,56(sp)
  fa:	f852                	sd	s4,48(sp)
  fc:	f456                	sd	s5,40(sp)
  fe:	f05a                	sd	s6,32(sp)
 100:	ec5e                	sd	s7,24(sp)
 102:	e862                	sd	s8,16(sp)
 104:	1080                	addi	s0,sp,96
 106:	8baa                	mv	s7,a0
 108:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 10a:	892a                	mv	s2,a0
 10c:	4481                	li	s1,0
    cc = read(0, &c, 1);
 10e:	faf40b13          	addi	s6,s0,-81
 112:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 114:	8c26                	mv	s8,s1
 116:	0014899b          	addiw	s3,s1,1
 11a:	84ce                	mv	s1,s3
 11c:	0349d463          	bge	s3,s4,144 <gets+0x56>
    cc = read(0, &c, 1);
 120:	8656                	mv	a2,s5
 122:	85da                	mv	a1,s6
 124:	4501                	li	a0,0
 126:	1bc000ef          	jal	2e2 <read>
    if(cc < 1)
 12a:	00a05d63          	blez	a0,144 <gets+0x56>
      break;
    buf[i++] = c;
 12e:	faf44783          	lbu	a5,-81(s0)
 132:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 136:	0905                	addi	s2,s2,1
 138:	ff678713          	addi	a4,a5,-10
 13c:	c319                	beqz	a4,142 <gets+0x54>
 13e:	17cd                	addi	a5,a5,-13
 140:	fbf1                	bnez	a5,114 <gets+0x26>
    buf[i++] = c;
 142:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 144:	9c5e                	add	s8,s8,s7
 146:	000c0023          	sb	zero,0(s8)
  return buf;
}
 14a:	855e                	mv	a0,s7
 14c:	60e6                	ld	ra,88(sp)
 14e:	6446                	ld	s0,80(sp)
 150:	64a6                	ld	s1,72(sp)
 152:	6906                	ld	s2,64(sp)
 154:	79e2                	ld	s3,56(sp)
 156:	7a42                	ld	s4,48(sp)
 158:	7aa2                	ld	s5,40(sp)
 15a:	7b02                	ld	s6,32(sp)
 15c:	6be2                	ld	s7,24(sp)
 15e:	6c42                	ld	s8,16(sp)
 160:	6125                	addi	sp,sp,96
 162:	8082                	ret

0000000000000164 <stat>:

int
stat(const char *n, struct stat *st)
{
 164:	1101                	addi	sp,sp,-32
 166:	ec06                	sd	ra,24(sp)
 168:	e822                	sd	s0,16(sp)
 16a:	e04a                	sd	s2,0(sp)
 16c:	1000                	addi	s0,sp,32
 16e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 170:	4581                	li	a1,0
 172:	198000ef          	jal	30a <open>
  if(fd < 0)
 176:	02054263          	bltz	a0,19a <stat+0x36>
 17a:	e426                	sd	s1,8(sp)
 17c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 17e:	85ca                	mv	a1,s2
 180:	1a2000ef          	jal	322 <fstat>
 184:	892a                	mv	s2,a0
  close(fd);
 186:	8526                	mv	a0,s1
 188:	16a000ef          	jal	2f2 <close>
  return r;
 18c:	64a2                	ld	s1,8(sp)
}
 18e:	854a                	mv	a0,s2
 190:	60e2                	ld	ra,24(sp)
 192:	6442                	ld	s0,16(sp)
 194:	6902                	ld	s2,0(sp)
 196:	6105                	addi	sp,sp,32
 198:	8082                	ret
    return -1;
 19a:	57fd                	li	a5,-1
 19c:	893e                	mv	s2,a5
 19e:	bfc5                	j	18e <stat+0x2a>

00000000000001a0 <atoi>:

int
atoi(const char *s)
{
 1a0:	1141                	addi	sp,sp,-16
 1a2:	e406                	sd	ra,8(sp)
 1a4:	e022                	sd	s0,0(sp)
 1a6:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1a8:	00054683          	lbu	a3,0(a0)
 1ac:	fd06879b          	addiw	a5,a3,-48
 1b0:	0ff7f793          	zext.b	a5,a5
 1b4:	4625                	li	a2,9
 1b6:	02f66963          	bltu	a2,a5,1e8 <atoi+0x48>
 1ba:	872a                	mv	a4,a0
  n = 0;
 1bc:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1be:	0705                	addi	a4,a4,1
 1c0:	0025179b          	slliw	a5,a0,0x2
 1c4:	9fa9                	addw	a5,a5,a0
 1c6:	0017979b          	slliw	a5,a5,0x1
 1ca:	9fb5                	addw	a5,a5,a3
 1cc:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1d0:	00074683          	lbu	a3,0(a4)
 1d4:	fd06879b          	addiw	a5,a3,-48
 1d8:	0ff7f793          	zext.b	a5,a5
 1dc:	fef671e3          	bgeu	a2,a5,1be <atoi+0x1e>
  return n;
}
 1e0:	60a2                	ld	ra,8(sp)
 1e2:	6402                	ld	s0,0(sp)
 1e4:	0141                	addi	sp,sp,16
 1e6:	8082                	ret
  n = 0;
 1e8:	4501                	li	a0,0
 1ea:	bfdd                	j	1e0 <atoi+0x40>

00000000000001ec <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1ec:	1141                	addi	sp,sp,-16
 1ee:	e406                	sd	ra,8(sp)
 1f0:	e022                	sd	s0,0(sp)
 1f2:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 1f4:	02b57563          	bgeu	a0,a1,21e <memmove+0x32>
    while(n-- > 0)
 1f8:	00c05f63          	blez	a2,216 <memmove+0x2a>
 1fc:	1602                	slli	a2,a2,0x20
 1fe:	9201                	srli	a2,a2,0x20
 200:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 204:	872a                	mv	a4,a0
      *dst++ = *src++;
 206:	0585                	addi	a1,a1,1
 208:	0705                	addi	a4,a4,1
 20a:	fff5c683          	lbu	a3,-1(a1)
 20e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 212:	fee79ae3          	bne	a5,a4,206 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 216:	60a2                	ld	ra,8(sp)
 218:	6402                	ld	s0,0(sp)
 21a:	0141                	addi	sp,sp,16
 21c:	8082                	ret
    while(n-- > 0)
 21e:	fec05ce3          	blez	a2,216 <memmove+0x2a>
    dst += n;
 222:	00c50733          	add	a4,a0,a2
    src += n;
 226:	95b2                	add	a1,a1,a2
 228:	fff6079b          	addiw	a5,a2,-1
 22c:	1782                	slli	a5,a5,0x20
 22e:	9381                	srli	a5,a5,0x20
 230:	fff7c793          	not	a5,a5
 234:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 236:	15fd                	addi	a1,a1,-1
 238:	177d                	addi	a4,a4,-1
 23a:	0005c683          	lbu	a3,0(a1)
 23e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 242:	fef71ae3          	bne	a4,a5,236 <memmove+0x4a>
 246:	bfc1                	j	216 <memmove+0x2a>

0000000000000248 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 248:	1141                	addi	sp,sp,-16
 24a:	e406                	sd	ra,8(sp)
 24c:	e022                	sd	s0,0(sp)
 24e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 250:	c61d                	beqz	a2,27e <memcmp+0x36>
 252:	1602                	slli	a2,a2,0x20
 254:	9201                	srli	a2,a2,0x20
 256:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 25a:	00054783          	lbu	a5,0(a0)
 25e:	0005c703          	lbu	a4,0(a1)
 262:	00e79863          	bne	a5,a4,272 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 266:	0505                	addi	a0,a0,1
    p2++;
 268:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 26a:	fed518e3          	bne	a0,a3,25a <memcmp+0x12>
  }
  return 0;
 26e:	4501                	li	a0,0
 270:	a019                	j	276 <memcmp+0x2e>
      return *p1 - *p2;
 272:	40e7853b          	subw	a0,a5,a4
}
 276:	60a2                	ld	ra,8(sp)
 278:	6402                	ld	s0,0(sp)
 27a:	0141                	addi	sp,sp,16
 27c:	8082                	ret
  return 0;
 27e:	4501                	li	a0,0
 280:	bfdd                	j	276 <memcmp+0x2e>

0000000000000282 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 282:	1141                	addi	sp,sp,-16
 284:	e406                	sd	ra,8(sp)
 286:	e022                	sd	s0,0(sp)
 288:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 28a:	f63ff0ef          	jal	1ec <memmove>
}
 28e:	60a2                	ld	ra,8(sp)
 290:	6402                	ld	s0,0(sp)
 292:	0141                	addi	sp,sp,16
 294:	8082                	ret

0000000000000296 <sbrk>:

char *
sbrk(int n) {
 296:	1141                	addi	sp,sp,-16
 298:	e406                	sd	ra,8(sp)
 29a:	e022                	sd	s0,0(sp)
 29c:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 29e:	4585                	li	a1,1
 2a0:	0b2000ef          	jal	352 <sys_sbrk>
}
 2a4:	60a2                	ld	ra,8(sp)
 2a6:	6402                	ld	s0,0(sp)
 2a8:	0141                	addi	sp,sp,16
 2aa:	8082                	ret

00000000000002ac <sbrklazy>:

char *
sbrklazy(int n) {
 2ac:	1141                	addi	sp,sp,-16
 2ae:	e406                	sd	ra,8(sp)
 2b0:	e022                	sd	s0,0(sp)
 2b2:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 2b4:	4589                	li	a1,2
 2b6:	09c000ef          	jal	352 <sys_sbrk>
}
 2ba:	60a2                	ld	ra,8(sp)
 2bc:	6402                	ld	s0,0(sp)
 2be:	0141                	addi	sp,sp,16
 2c0:	8082                	ret

00000000000002c2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2c2:	4885                	li	a7,1
 ecall
 2c4:	00000073          	ecall
 ret
 2c8:	8082                	ret

00000000000002ca <exit>:
.global exit
exit:
 li a7, SYS_exit
 2ca:	4889                	li	a7,2
 ecall
 2cc:	00000073          	ecall
 ret
 2d0:	8082                	ret

00000000000002d2 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2d2:	488d                	li	a7,3
 ecall
 2d4:	00000073          	ecall
 ret
 2d8:	8082                	ret

00000000000002da <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2da:	4891                	li	a7,4
 ecall
 2dc:	00000073          	ecall
 ret
 2e0:	8082                	ret

00000000000002e2 <read>:
.global read
read:
 li a7, SYS_read
 2e2:	4895                	li	a7,5
 ecall
 2e4:	00000073          	ecall
 ret
 2e8:	8082                	ret

00000000000002ea <write>:
.global write
write:
 li a7, SYS_write
 2ea:	48c1                	li	a7,16
 ecall
 2ec:	00000073          	ecall
 ret
 2f0:	8082                	ret

00000000000002f2 <close>:
.global close
close:
 li a7, SYS_close
 2f2:	48d5                	li	a7,21
 ecall
 2f4:	00000073          	ecall
 ret
 2f8:	8082                	ret

00000000000002fa <kill>:
.global kill
kill:
 li a7, SYS_kill
 2fa:	4899                	li	a7,6
 ecall
 2fc:	00000073          	ecall
 ret
 300:	8082                	ret

0000000000000302 <exec>:
.global exec
exec:
 li a7, SYS_exec
 302:	489d                	li	a7,7
 ecall
 304:	00000073          	ecall
 ret
 308:	8082                	ret

000000000000030a <open>:
.global open
open:
 li a7, SYS_open
 30a:	48bd                	li	a7,15
 ecall
 30c:	00000073          	ecall
 ret
 310:	8082                	ret

0000000000000312 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 312:	48c5                	li	a7,17
 ecall
 314:	00000073          	ecall
 ret
 318:	8082                	ret

000000000000031a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 31a:	48c9                	li	a7,18
 ecall
 31c:	00000073          	ecall
 ret
 320:	8082                	ret

0000000000000322 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 322:	48a1                	li	a7,8
 ecall
 324:	00000073          	ecall
 ret
 328:	8082                	ret

000000000000032a <link>:
.global link
link:
 li a7, SYS_link
 32a:	48cd                	li	a7,19
 ecall
 32c:	00000073          	ecall
 ret
 330:	8082                	ret

0000000000000332 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 332:	48d1                	li	a7,20
 ecall
 334:	00000073          	ecall
 ret
 338:	8082                	ret

000000000000033a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 33a:	48a5                	li	a7,9
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <dup>:
.global dup
dup:
 li a7, SYS_dup
 342:	48a9                	li	a7,10
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 34a:	48ad                	li	a7,11
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 352:	48b1                	li	a7,12
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <pause>:
.global pause
pause:
 li a7, SYS_pause
 35a:	48b5                	li	a7,13
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 362:	48b9                	li	a7,14
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <sigalarm>:
.global sigalarm
sigalarm:
 li a7, SYS_sigalarm
 36a:	48d9                	li	a7,22
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <sigreturn>:
.global sigreturn
sigreturn:
 li a7, SYS_sigreturn
 372:	48dd                	li	a7,23
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 37a:	1101                	addi	sp,sp,-32
 37c:	ec06                	sd	ra,24(sp)
 37e:	e822                	sd	s0,16(sp)
 380:	1000                	addi	s0,sp,32
 382:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 386:	4605                	li	a2,1
 388:	fef40593          	addi	a1,s0,-17
 38c:	f5fff0ef          	jal	2ea <write>
}
 390:	60e2                	ld	ra,24(sp)
 392:	6442                	ld	s0,16(sp)
 394:	6105                	addi	sp,sp,32
 396:	8082                	ret

0000000000000398 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 398:	715d                	addi	sp,sp,-80
 39a:	e486                	sd	ra,72(sp)
 39c:	e0a2                	sd	s0,64(sp)
 39e:	f84a                	sd	s2,48(sp)
 3a0:	f44e                	sd	s3,40(sp)
 3a2:	0880                	addi	s0,sp,80
 3a4:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 3a6:	c6d1                	beqz	a3,432 <printint+0x9a>
 3a8:	0805d563          	bgez	a1,432 <printint+0x9a>
    neg = 1;
    x = -xx;
 3ac:	40b005b3          	neg	a1,a1
    neg = 1;
 3b0:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 3b2:	fb840993          	addi	s3,s0,-72
  neg = 0;
 3b6:	86ce                	mv	a3,s3
  i = 0;
 3b8:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3ba:	00000817          	auipc	a6,0x0
 3be:	51e80813          	addi	a6,a6,1310 # 8d8 <digits>
 3c2:	88ba                	mv	a7,a4
 3c4:	0017051b          	addiw	a0,a4,1
 3c8:	872a                	mv	a4,a0
 3ca:	02c5f7b3          	remu	a5,a1,a2
 3ce:	97c2                	add	a5,a5,a6
 3d0:	0007c783          	lbu	a5,0(a5)
 3d4:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3d8:	87ae                	mv	a5,a1
 3da:	02c5d5b3          	divu	a1,a1,a2
 3de:	0685                	addi	a3,a3,1
 3e0:	fec7f1e3          	bgeu	a5,a2,3c2 <printint+0x2a>
  if(neg)
 3e4:	00030c63          	beqz	t1,3fc <printint+0x64>
    buf[i++] = '-';
 3e8:	fd050793          	addi	a5,a0,-48
 3ec:	00878533          	add	a0,a5,s0
 3f0:	02d00793          	li	a5,45
 3f4:	fef50423          	sb	a5,-24(a0)
 3f8:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 3fc:	02e05563          	blez	a4,426 <printint+0x8e>
 400:	fc26                	sd	s1,56(sp)
 402:	377d                	addiw	a4,a4,-1
 404:	00e984b3          	add	s1,s3,a4
 408:	19fd                	addi	s3,s3,-1
 40a:	99ba                	add	s3,s3,a4
 40c:	1702                	slli	a4,a4,0x20
 40e:	9301                	srli	a4,a4,0x20
 410:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 414:	0004c583          	lbu	a1,0(s1)
 418:	854a                	mv	a0,s2
 41a:	f61ff0ef          	jal	37a <putc>
  while(--i >= 0)
 41e:	14fd                	addi	s1,s1,-1
 420:	ff349ae3          	bne	s1,s3,414 <printint+0x7c>
 424:	74e2                	ld	s1,56(sp)
}
 426:	60a6                	ld	ra,72(sp)
 428:	6406                	ld	s0,64(sp)
 42a:	7942                	ld	s2,48(sp)
 42c:	79a2                	ld	s3,40(sp)
 42e:	6161                	addi	sp,sp,80
 430:	8082                	ret
  neg = 0;
 432:	4301                	li	t1,0
 434:	bfbd                	j	3b2 <printint+0x1a>

0000000000000436 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 436:	711d                	addi	sp,sp,-96
 438:	ec86                	sd	ra,88(sp)
 43a:	e8a2                	sd	s0,80(sp)
 43c:	e4a6                	sd	s1,72(sp)
 43e:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 440:	0005c483          	lbu	s1,0(a1)
 444:	22048363          	beqz	s1,66a <vprintf+0x234>
 448:	e0ca                	sd	s2,64(sp)
 44a:	fc4e                	sd	s3,56(sp)
 44c:	f852                	sd	s4,48(sp)
 44e:	f456                	sd	s5,40(sp)
 450:	f05a                	sd	s6,32(sp)
 452:	ec5e                	sd	s7,24(sp)
 454:	e862                	sd	s8,16(sp)
 456:	8b2a                	mv	s6,a0
 458:	8a2e                	mv	s4,a1
 45a:	8bb2                	mv	s7,a2
  state = 0;
 45c:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 45e:	4901                	li	s2,0
 460:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 462:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 466:	06400c13          	li	s8,100
 46a:	a00d                	j	48c <vprintf+0x56>
        putc(fd, c0);
 46c:	85a6                	mv	a1,s1
 46e:	855a                	mv	a0,s6
 470:	f0bff0ef          	jal	37a <putc>
 474:	a019                	j	47a <vprintf+0x44>
    } else if(state == '%'){
 476:	03598363          	beq	s3,s5,49c <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 47a:	0019079b          	addiw	a5,s2,1
 47e:	893e                	mv	s2,a5
 480:	873e                	mv	a4,a5
 482:	97d2                	add	a5,a5,s4
 484:	0007c483          	lbu	s1,0(a5)
 488:	1c048a63          	beqz	s1,65c <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 48c:	0004879b          	sext.w	a5,s1
    if(state == 0){
 490:	fe0993e3          	bnez	s3,476 <vprintf+0x40>
      if(c0 == '%'){
 494:	fd579ce3          	bne	a5,s5,46c <vprintf+0x36>
        state = '%';
 498:	89be                	mv	s3,a5
 49a:	b7c5                	j	47a <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 49c:	00ea06b3          	add	a3,s4,a4
 4a0:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 4a4:	1c060863          	beqz	a2,674 <vprintf+0x23e>
      if(c0 == 'd'){
 4a8:	03878763          	beq	a5,s8,4d6 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4ac:	f9478693          	addi	a3,a5,-108
 4b0:	0016b693          	seqz	a3,a3
 4b4:	f9c60593          	addi	a1,a2,-100
 4b8:	e99d                	bnez	a1,4ee <vprintf+0xb8>
 4ba:	ca95                	beqz	a3,4ee <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 4bc:	008b8493          	addi	s1,s7,8
 4c0:	4685                	li	a3,1
 4c2:	4629                	li	a2,10
 4c4:	000bb583          	ld	a1,0(s7)
 4c8:	855a                	mv	a0,s6
 4ca:	ecfff0ef          	jal	398 <printint>
        i += 1;
 4ce:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 4d0:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 4d2:	4981                	li	s3,0
 4d4:	b75d                	j	47a <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 4d6:	008b8493          	addi	s1,s7,8
 4da:	4685                	li	a3,1
 4dc:	4629                	li	a2,10
 4de:	000ba583          	lw	a1,0(s7)
 4e2:	855a                	mv	a0,s6
 4e4:	eb5ff0ef          	jal	398 <printint>
 4e8:	8ba6                	mv	s7,s1
      state = 0;
 4ea:	4981                	li	s3,0
 4ec:	b779                	j	47a <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 4ee:	9752                	add	a4,a4,s4
 4f0:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 4f4:	f9460713          	addi	a4,a2,-108
 4f8:	00173713          	seqz	a4,a4
 4fc:	8f75                	and	a4,a4,a3
 4fe:	f9c58513          	addi	a0,a1,-100
 502:	18051363          	bnez	a0,688 <vprintf+0x252>
 506:	18070163          	beqz	a4,688 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 50a:	008b8493          	addi	s1,s7,8
 50e:	4685                	li	a3,1
 510:	4629                	li	a2,10
 512:	000bb583          	ld	a1,0(s7)
 516:	855a                	mv	a0,s6
 518:	e81ff0ef          	jal	398 <printint>
        i += 2;
 51c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 51e:	8ba6                	mv	s7,s1
      state = 0;
 520:	4981                	li	s3,0
        i += 2;
 522:	bfa1                	j	47a <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 524:	008b8493          	addi	s1,s7,8
 528:	4681                	li	a3,0
 52a:	4629                	li	a2,10
 52c:	000be583          	lwu	a1,0(s7)
 530:	855a                	mv	a0,s6
 532:	e67ff0ef          	jal	398 <printint>
 536:	8ba6                	mv	s7,s1
      state = 0;
 538:	4981                	li	s3,0
 53a:	b781                	j	47a <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 53c:	008b8493          	addi	s1,s7,8
 540:	4681                	li	a3,0
 542:	4629                	li	a2,10
 544:	000bb583          	ld	a1,0(s7)
 548:	855a                	mv	a0,s6
 54a:	e4fff0ef          	jal	398 <printint>
        i += 1;
 54e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 550:	8ba6                	mv	s7,s1
      state = 0;
 552:	4981                	li	s3,0
 554:	b71d                	j	47a <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 556:	008b8493          	addi	s1,s7,8
 55a:	4681                	li	a3,0
 55c:	4629                	li	a2,10
 55e:	000bb583          	ld	a1,0(s7)
 562:	855a                	mv	a0,s6
 564:	e35ff0ef          	jal	398 <printint>
        i += 2;
 568:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 56a:	8ba6                	mv	s7,s1
      state = 0;
 56c:	4981                	li	s3,0
        i += 2;
 56e:	b731                	j	47a <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 570:	008b8493          	addi	s1,s7,8
 574:	4681                	li	a3,0
 576:	4641                	li	a2,16
 578:	000be583          	lwu	a1,0(s7)
 57c:	855a                	mv	a0,s6
 57e:	e1bff0ef          	jal	398 <printint>
 582:	8ba6                	mv	s7,s1
      state = 0;
 584:	4981                	li	s3,0
 586:	bdd5                	j	47a <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 588:	008b8493          	addi	s1,s7,8
 58c:	4681                	li	a3,0
 58e:	4641                	li	a2,16
 590:	000bb583          	ld	a1,0(s7)
 594:	855a                	mv	a0,s6
 596:	e03ff0ef          	jal	398 <printint>
        i += 1;
 59a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 59c:	8ba6                	mv	s7,s1
      state = 0;
 59e:	4981                	li	s3,0
 5a0:	bde9                	j	47a <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5a2:	008b8493          	addi	s1,s7,8
 5a6:	4681                	li	a3,0
 5a8:	4641                	li	a2,16
 5aa:	000bb583          	ld	a1,0(s7)
 5ae:	855a                	mv	a0,s6
 5b0:	de9ff0ef          	jal	398 <printint>
        i += 2;
 5b4:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5b6:	8ba6                	mv	s7,s1
      state = 0;
 5b8:	4981                	li	s3,0
        i += 2;
 5ba:	b5c1                	j	47a <vprintf+0x44>
 5bc:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 5be:	008b8793          	addi	a5,s7,8
 5c2:	8cbe                	mv	s9,a5
 5c4:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5c8:	03000593          	li	a1,48
 5cc:	855a                	mv	a0,s6
 5ce:	dadff0ef          	jal	37a <putc>
  putc(fd, 'x');
 5d2:	07800593          	li	a1,120
 5d6:	855a                	mv	a0,s6
 5d8:	da3ff0ef          	jal	37a <putc>
 5dc:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5de:	00000b97          	auipc	s7,0x0
 5e2:	2fab8b93          	addi	s7,s7,762 # 8d8 <digits>
 5e6:	03c9d793          	srli	a5,s3,0x3c
 5ea:	97de                	add	a5,a5,s7
 5ec:	0007c583          	lbu	a1,0(a5)
 5f0:	855a                	mv	a0,s6
 5f2:	d89ff0ef          	jal	37a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5f6:	0992                	slli	s3,s3,0x4
 5f8:	34fd                	addiw	s1,s1,-1
 5fa:	f4f5                	bnez	s1,5e6 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 5fc:	8be6                	mv	s7,s9
      state = 0;
 5fe:	4981                	li	s3,0
 600:	6ca2                	ld	s9,8(sp)
 602:	bda5                	j	47a <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 604:	008b8493          	addi	s1,s7,8
 608:	000bc583          	lbu	a1,0(s7)
 60c:	855a                	mv	a0,s6
 60e:	d6dff0ef          	jal	37a <putc>
 612:	8ba6                	mv	s7,s1
      state = 0;
 614:	4981                	li	s3,0
 616:	b595                	j	47a <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 618:	008b8993          	addi	s3,s7,8
 61c:	000bb483          	ld	s1,0(s7)
 620:	cc91                	beqz	s1,63c <vprintf+0x206>
        for(; *s; s++)
 622:	0004c583          	lbu	a1,0(s1)
 626:	c985                	beqz	a1,656 <vprintf+0x220>
          putc(fd, *s);
 628:	855a                	mv	a0,s6
 62a:	d51ff0ef          	jal	37a <putc>
        for(; *s; s++)
 62e:	0485                	addi	s1,s1,1
 630:	0004c583          	lbu	a1,0(s1)
 634:	f9f5                	bnez	a1,628 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 636:	8bce                	mv	s7,s3
      state = 0;
 638:	4981                	li	s3,0
 63a:	b581                	j	47a <vprintf+0x44>
          s = "(null)";
 63c:	00000497          	auipc	s1,0x0
 640:	29448493          	addi	s1,s1,660 # 8d0 <malloc+0xf8>
        for(; *s; s++)
 644:	02800593          	li	a1,40
 648:	b7c5                	j	628 <vprintf+0x1f2>
        putc(fd, '%');
 64a:	85be                	mv	a1,a5
 64c:	855a                	mv	a0,s6
 64e:	d2dff0ef          	jal	37a <putc>
      state = 0;
 652:	4981                	li	s3,0
 654:	b51d                	j	47a <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 656:	8bce                	mv	s7,s3
      state = 0;
 658:	4981                	li	s3,0
 65a:	b505                	j	47a <vprintf+0x44>
 65c:	6906                	ld	s2,64(sp)
 65e:	79e2                	ld	s3,56(sp)
 660:	7a42                	ld	s4,48(sp)
 662:	7aa2                	ld	s5,40(sp)
 664:	7b02                	ld	s6,32(sp)
 666:	6be2                	ld	s7,24(sp)
 668:	6c42                	ld	s8,16(sp)
    }
  }
}
 66a:	60e6                	ld	ra,88(sp)
 66c:	6446                	ld	s0,80(sp)
 66e:	64a6                	ld	s1,72(sp)
 670:	6125                	addi	sp,sp,96
 672:	8082                	ret
      if(c0 == 'd'){
 674:	06400713          	li	a4,100
 678:	e4e78fe3          	beq	a5,a4,4d6 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 67c:	f9478693          	addi	a3,a5,-108
 680:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 684:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 686:	4701                	li	a4,0
      } else if(c0 == 'u'){
 688:	07500513          	li	a0,117
 68c:	e8a78ce3          	beq	a5,a0,524 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 690:	f8b60513          	addi	a0,a2,-117
 694:	e119                	bnez	a0,69a <vprintf+0x264>
 696:	ea0693e3          	bnez	a3,53c <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 69a:	f8b58513          	addi	a0,a1,-117
 69e:	e119                	bnez	a0,6a4 <vprintf+0x26e>
 6a0:	ea071be3          	bnez	a4,556 <vprintf+0x120>
      } else if(c0 == 'x'){
 6a4:	07800513          	li	a0,120
 6a8:	eca784e3          	beq	a5,a0,570 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 6ac:	f8860613          	addi	a2,a2,-120
 6b0:	e219                	bnez	a2,6b6 <vprintf+0x280>
 6b2:	ec069be3          	bnez	a3,588 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 6b6:	f8858593          	addi	a1,a1,-120
 6ba:	e199                	bnez	a1,6c0 <vprintf+0x28a>
 6bc:	ee0713e3          	bnez	a4,5a2 <vprintf+0x16c>
      } else if(c0 == 'p'){
 6c0:	07000713          	li	a4,112
 6c4:	eee78ce3          	beq	a5,a4,5bc <vprintf+0x186>
      } else if(c0 == 'c'){
 6c8:	06300713          	li	a4,99
 6cc:	f2e78ce3          	beq	a5,a4,604 <vprintf+0x1ce>
      } else if(c0 == 's'){
 6d0:	07300713          	li	a4,115
 6d4:	f4e782e3          	beq	a5,a4,618 <vprintf+0x1e2>
      } else if(c0 == '%'){
 6d8:	02500713          	li	a4,37
 6dc:	f6e787e3          	beq	a5,a4,64a <vprintf+0x214>
        putc(fd, '%');
 6e0:	02500593          	li	a1,37
 6e4:	855a                	mv	a0,s6
 6e6:	c95ff0ef          	jal	37a <putc>
        putc(fd, c0);
 6ea:	85a6                	mv	a1,s1
 6ec:	855a                	mv	a0,s6
 6ee:	c8dff0ef          	jal	37a <putc>
      state = 0;
 6f2:	4981                	li	s3,0
 6f4:	b359                	j	47a <vprintf+0x44>

00000000000006f6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6f6:	715d                	addi	sp,sp,-80
 6f8:	ec06                	sd	ra,24(sp)
 6fa:	e822                	sd	s0,16(sp)
 6fc:	1000                	addi	s0,sp,32
 6fe:	e010                	sd	a2,0(s0)
 700:	e414                	sd	a3,8(s0)
 702:	e818                	sd	a4,16(s0)
 704:	ec1c                	sd	a5,24(s0)
 706:	03043023          	sd	a6,32(s0)
 70a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 70e:	8622                	mv	a2,s0
 710:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 714:	d23ff0ef          	jal	436 <vprintf>
}
 718:	60e2                	ld	ra,24(sp)
 71a:	6442                	ld	s0,16(sp)
 71c:	6161                	addi	sp,sp,80
 71e:	8082                	ret

0000000000000720 <printf>:

void
printf(const char *fmt, ...)
{
 720:	711d                	addi	sp,sp,-96
 722:	ec06                	sd	ra,24(sp)
 724:	e822                	sd	s0,16(sp)
 726:	1000                	addi	s0,sp,32
 728:	e40c                	sd	a1,8(s0)
 72a:	e810                	sd	a2,16(s0)
 72c:	ec14                	sd	a3,24(s0)
 72e:	f018                	sd	a4,32(s0)
 730:	f41c                	sd	a5,40(s0)
 732:	03043823          	sd	a6,48(s0)
 736:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 73a:	00840613          	addi	a2,s0,8
 73e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 742:	85aa                	mv	a1,a0
 744:	4505                	li	a0,1
 746:	cf1ff0ef          	jal	436 <vprintf>
}
 74a:	60e2                	ld	ra,24(sp)
 74c:	6442                	ld	s0,16(sp)
 74e:	6125                	addi	sp,sp,96
 750:	8082                	ret

0000000000000752 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 752:	1141                	addi	sp,sp,-16
 754:	e406                	sd	ra,8(sp)
 756:	e022                	sd	s0,0(sp)
 758:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 75a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 75e:	00001797          	auipc	a5,0x1
 762:	8a27b783          	ld	a5,-1886(a5) # 1000 <freep>
 766:	a039                	j	774 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 768:	6398                	ld	a4,0(a5)
 76a:	00e7e463          	bltu	a5,a4,772 <free+0x20>
 76e:	00e6ea63          	bltu	a3,a4,782 <free+0x30>
{
 772:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 774:	fed7fae3          	bgeu	a5,a3,768 <free+0x16>
 778:	6398                	ld	a4,0(a5)
 77a:	00e6e463          	bltu	a3,a4,782 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 77e:	fee7eae3          	bltu	a5,a4,772 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 782:	ff852583          	lw	a1,-8(a0)
 786:	6390                	ld	a2,0(a5)
 788:	02059813          	slli	a6,a1,0x20
 78c:	01c85713          	srli	a4,a6,0x1c
 790:	9736                	add	a4,a4,a3
 792:	02e60563          	beq	a2,a4,7bc <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 796:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 79a:	4790                	lw	a2,8(a5)
 79c:	02061593          	slli	a1,a2,0x20
 7a0:	01c5d713          	srli	a4,a1,0x1c
 7a4:	973e                	add	a4,a4,a5
 7a6:	02e68263          	beq	a3,a4,7ca <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 7aa:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7ac:	00001717          	auipc	a4,0x1
 7b0:	84f73a23          	sd	a5,-1964(a4) # 1000 <freep>
}
 7b4:	60a2                	ld	ra,8(sp)
 7b6:	6402                	ld	s0,0(sp)
 7b8:	0141                	addi	sp,sp,16
 7ba:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 7bc:	4618                	lw	a4,8(a2)
 7be:	9f2d                	addw	a4,a4,a1
 7c0:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7c4:	6398                	ld	a4,0(a5)
 7c6:	6310                	ld	a2,0(a4)
 7c8:	b7f9                	j	796 <free+0x44>
    p->s.size += bp->s.size;
 7ca:	ff852703          	lw	a4,-8(a0)
 7ce:	9f31                	addw	a4,a4,a2
 7d0:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7d2:	ff053683          	ld	a3,-16(a0)
 7d6:	bfd1                	j	7aa <free+0x58>

00000000000007d8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7d8:	7139                	addi	sp,sp,-64
 7da:	fc06                	sd	ra,56(sp)
 7dc:	f822                	sd	s0,48(sp)
 7de:	f04a                	sd	s2,32(sp)
 7e0:	ec4e                	sd	s3,24(sp)
 7e2:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7e4:	02051993          	slli	s3,a0,0x20
 7e8:	0209d993          	srli	s3,s3,0x20
 7ec:	09bd                	addi	s3,s3,15
 7ee:	0049d993          	srli	s3,s3,0x4
 7f2:	2985                	addiw	s3,s3,1
 7f4:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 7f6:	00001517          	auipc	a0,0x1
 7fa:	80a53503          	ld	a0,-2038(a0) # 1000 <freep>
 7fe:	c905                	beqz	a0,82e <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 800:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 802:	4798                	lw	a4,8(a5)
 804:	09377663          	bgeu	a4,s3,890 <malloc+0xb8>
 808:	f426                	sd	s1,40(sp)
 80a:	e852                	sd	s4,16(sp)
 80c:	e456                	sd	s5,8(sp)
 80e:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 810:	8a4e                	mv	s4,s3
 812:	6705                	lui	a4,0x1
 814:	00e9f363          	bgeu	s3,a4,81a <malloc+0x42>
 818:	6a05                	lui	s4,0x1
 81a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 81e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 822:	00000497          	auipc	s1,0x0
 826:	7de48493          	addi	s1,s1,2014 # 1000 <freep>
  if(p == SBRK_ERROR)
 82a:	5afd                	li	s5,-1
 82c:	a83d                	j	86a <malloc+0x92>
 82e:	f426                	sd	s1,40(sp)
 830:	e852                	sd	s4,16(sp)
 832:	e456                	sd	s5,8(sp)
 834:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 836:	00000797          	auipc	a5,0x0
 83a:	7da78793          	addi	a5,a5,2010 # 1010 <base>
 83e:	00000717          	auipc	a4,0x0
 842:	7cf73123          	sd	a5,1986(a4) # 1000 <freep>
 846:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 848:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 84c:	b7d1                	j	810 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 84e:	6398                	ld	a4,0(a5)
 850:	e118                	sd	a4,0(a0)
 852:	a899                	j	8a8 <malloc+0xd0>
  hp->s.size = nu;
 854:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 858:	0541                	addi	a0,a0,16
 85a:	ef9ff0ef          	jal	752 <free>
  return freep;
 85e:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 860:	c125                	beqz	a0,8c0 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 862:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 864:	4798                	lw	a4,8(a5)
 866:	03277163          	bgeu	a4,s2,888 <malloc+0xb0>
    if(p == freep)
 86a:	6098                	ld	a4,0(s1)
 86c:	853e                	mv	a0,a5
 86e:	fef71ae3          	bne	a4,a5,862 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 872:	8552                	mv	a0,s4
 874:	a23ff0ef          	jal	296 <sbrk>
  if(p == SBRK_ERROR)
 878:	fd551ee3          	bne	a0,s5,854 <malloc+0x7c>
        return 0;
 87c:	4501                	li	a0,0
 87e:	74a2                	ld	s1,40(sp)
 880:	6a42                	ld	s4,16(sp)
 882:	6aa2                	ld	s5,8(sp)
 884:	6b02                	ld	s6,0(sp)
 886:	a03d                	j	8b4 <malloc+0xdc>
 888:	74a2                	ld	s1,40(sp)
 88a:	6a42                	ld	s4,16(sp)
 88c:	6aa2                	ld	s5,8(sp)
 88e:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 890:	fae90fe3          	beq	s2,a4,84e <malloc+0x76>
        p->s.size -= nunits;
 894:	4137073b          	subw	a4,a4,s3
 898:	c798                	sw	a4,8(a5)
        p += p->s.size;
 89a:	02071693          	slli	a3,a4,0x20
 89e:	01c6d713          	srli	a4,a3,0x1c
 8a2:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8a4:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8a8:	00000717          	auipc	a4,0x0
 8ac:	74a73c23          	sd	a0,1880(a4) # 1000 <freep>
      return (void*)(p + 1);
 8b0:	01078513          	addi	a0,a5,16
  }
}
 8b4:	70e2                	ld	ra,56(sp)
 8b6:	7442                	ld	s0,48(sp)
 8b8:	7902                	ld	s2,32(sp)
 8ba:	69e2                	ld	s3,24(sp)
 8bc:	6121                	addi	sp,sp,64
 8be:	8082                	ret
 8c0:	74a2                	ld	s1,40(sp)
 8c2:	6a42                	ld	s4,16(sp)
 8c4:	6aa2                	ld	s5,8(sp)
 8c6:	6b02                	ld	s6,0(sp)
 8c8:	b7f5                	j	8b4 <malloc+0xdc>
