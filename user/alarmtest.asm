
user/_alarmtest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <periodic>:
#define S11_CHECKVAL 6181
register int s11_var asm("s11");

void
periodic()
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  s11_var = ~S11_CHECKVAL;
   8:	7df9                	lui	s11,0xffffe
   a:	7dad8d9b          	addiw	s11,s11,2010 # ffffffffffffe7da <base+0xffffffffffffd7ca>
  count = count + 1;
   e:	00001797          	auipc	a5,0x1
  12:	ff27a783          	lw	a5,-14(a5) # 1000 <count>
  16:	2785                	addiw	a5,a5,1
  18:	00001717          	auipc	a4,0x1
  1c:	fef72423          	sw	a5,-24(a4) # 1000 <count>
  printf("alarm!\n");
  20:	00001517          	auipc	a0,0x1
  24:	d1050513          	addi	a0,a0,-752 # d30 <malloc+0xf6>
  28:	35b000ef          	jal	b82 <printf>
  sigreturn();
  2c:	7a8000ef          	jal	7d4 <sigreturn>
  printf("oops, sigreturn returned!\n");
  30:	00001517          	auipc	a0,0x1
  34:	d0850513          	addi	a0,a0,-760 # d38 <malloc+0xfe>
  38:	34b000ef          	jal	b82 <printf>
  exit(1);
  3c:	4505                	li	a0,1
  3e:	6ee000ef          	jal	72c <exit>

0000000000000042 <slow_handler>:
  }
}

void
slow_handler()
{
  42:	1101                	addi	sp,sp,-32
  44:	ec06                	sd	ra,24(sp)
  46:	e822                	sd	s0,16(sp)
  48:	e426                	sd	s1,8(sp)
  4a:	1000                	addi	s0,sp,32
  count++;
  4c:	00001497          	auipc	s1,0x1
  50:	fb448493          	addi	s1,s1,-76 # 1000 <count>
  54:	00001797          	auipc	a5,0x1
  58:	fac7a783          	lw	a5,-84(a5) # 1000 <count>
  5c:	2785                	addiw	a5,a5,1
  5e:	c09c                	sw	a5,0(s1)
  printf("alarm!\n");
  60:	00001517          	auipc	a0,0x1
  64:	cd050513          	addi	a0,a0,-816 # d30 <malloc+0xf6>
  68:	31b000ef          	jal	b82 <printf>
  if (count > 1) {
  6c:	4098                	lw	a4,0(s1)
  6e:	2701                	sext.w	a4,a4
  70:	4685                	li	a3,1
  72:	1dcd67b7          	lui	a5,0x1dcd6
  76:	50078793          	addi	a5,a5,1280 # 1dcd6500 <base+0x1dcd54f0>
  7a:	02e6c063          	blt	a3,a4,9a <slow_handler+0x58>
    printf("test2 failed: alarm handler called more than once\n");
    exit(1);
  }
  for (int i = 0; i < 1000*500000; i++) {
    asm volatile("nop"); // avoid compiler optimizing away loop
  7e:	0001                	nop
  for (int i = 0; i < 1000*500000; i++) {
  80:	37fd                	addiw	a5,a5,-1
  82:	fff5                	bnez	a5,7e <slow_handler+0x3c>
  }
  sigalarm(0, 0);
  84:	4581                	li	a1,0
  86:	4501                	li	a0,0
  88:	744000ef          	jal	7cc <sigalarm>
  sigreturn();
  8c:	748000ef          	jal	7d4 <sigreturn>
}
  90:	60e2                	ld	ra,24(sp)
  92:	6442                	ld	s0,16(sp)
  94:	64a2                	ld	s1,8(sp)
  96:	6105                	addi	sp,sp,32
  98:	8082                	ret
    printf("test2 failed: alarm handler called more than once\n");
  9a:	00001517          	auipc	a0,0x1
  9e:	cbe50513          	addi	a0,a0,-834 # d58 <malloc+0x11e>
  a2:	2e1000ef          	jal	b82 <printf>
    exit(1);
  a6:	4505                	li	a0,1
  a8:	684000ef          	jal	72c <exit>

00000000000000ac <dummy_handler>:
//
// dummy alarm handler; after running immediately uninstall
// itself and finish signal handling
void
dummy_handler()
{
  ac:	1141                	addi	sp,sp,-16
  ae:	e406                	sd	ra,8(sp)
  b0:	e022                	sd	s0,0(sp)
  b2:	0800                	addi	s0,sp,16
  sigalarm(0, 0);
  b4:	4581                	li	a1,0
  b6:	4501                	li	a0,0
  b8:	714000ef          	jal	7cc <sigalarm>
  sigreturn();
  bc:	718000ef          	jal	7d4 <sigreturn>
}
  c0:	60a2                	ld	ra,8(sp)
  c2:	6402                	ld	s0,0(sp)
  c4:	0141                	addi	sp,sp,16
  c6:	8082                	ret

00000000000000c8 <test0>:
{
  c8:	715d                	addi	sp,sp,-80
  ca:	e486                	sd	ra,72(sp)
  cc:	e0a2                	sd	s0,64(sp)
  ce:	fc26                	sd	s1,56(sp)
  d0:	f84a                	sd	s2,48(sp)
  d2:	f44e                	sd	s3,40(sp)
  d4:	f052                	sd	s4,32(sp)
  d6:	ec56                	sd	s5,24(sp)
  d8:	e85a                	sd	s6,16(sp)
  da:	e45e                	sd	s7,8(sp)
  dc:	0880                	addi	s0,sp,80
  printf("test0 start\n");
  de:	00001517          	auipc	a0,0x1
  e2:	cb250513          	addi	a0,a0,-846 # d90 <malloc+0x156>
  e6:	29d000ef          	jal	b82 <printf>
  count = 0;
  ea:	00001797          	auipc	a5,0x1
  ee:	f007ab23          	sw	zero,-234(a5) # 1000 <count>
  sigalarm(2, periodic);
  f2:	00000597          	auipc	a1,0x0
  f6:	f0e58593          	addi	a1,a1,-242 # 0 <periodic>
  fa:	4509                	li	a0,2
  fc:	6d0000ef          	jal	7cc <sigalarm>
  for(i = 0; i < 1000*500000; i++){
 100:	4481                	li	s1,0
    if((i % 1000000) == 0)
 102:	431be9b7          	lui	s3,0x431be
 106:	e8398993          	addi	s3,s3,-381 # 431bde83 <base+0x431bce73>
 10a:	000f4937          	lui	s2,0xf4
 10e:	2409091b          	addiw	s2,s2,576 # f4240 <base+0xf3230>
      write(2, ".", 1);
 112:	4b85                	li	s7,1
 114:	00001b17          	auipc	s6,0x1
 118:	c8cb0b13          	addi	s6,s6,-884 # da0 <malloc+0x166>
 11c:	4a89                	li	s5,2
    if(count > 0)
 11e:	00001a17          	auipc	s4,0x1
 122:	ee2a0a13          	addi	s4,s4,-286 # 1000 <count>
 126:	a829                	j	140 <test0+0x78>
 128:	000a2783          	lw	a5,0(s4)
 12c:	2781                	sext.w	a5,a5
 12e:	02f04a63          	bgtz	a5,162 <test0+0x9a>
  for(i = 0; i < 1000*500000; i++){
 132:	2485                	addiw	s1,s1,1
 134:	1dcd67b7          	lui	a5,0x1dcd6
 138:	50078793          	addi	a5,a5,1280 # 1dcd6500 <base+0x1dcd54f0>
 13c:	02f48363          	beq	s1,a5,162 <test0+0x9a>
    if((i % 1000000) == 0)
 140:	033487b3          	mul	a5,s1,s3
 144:	97c9                	srai	a5,a5,0x32
 146:	41f4d71b          	sraiw	a4,s1,0x1f
 14a:	9f99                	subw	a5,a5,a4
 14c:	02f907bb          	mulw	a5,s2,a5
 150:	40f487bb          	subw	a5,s1,a5
 154:	fbf1                	bnez	a5,128 <test0+0x60>
      write(2, ".", 1);
 156:	865e                	mv	a2,s7
 158:	85da                	mv	a1,s6
 15a:	8556                	mv	a0,s5
 15c:	5f0000ef          	jal	74c <write>
 160:	b7e1                	j	128 <test0+0x60>
  sigalarm(0, 0);
 162:	4581                	li	a1,0
 164:	4501                	li	a0,0
 166:	666000ef          	jal	7cc <sigalarm>
  if(count > 0){
 16a:	00001797          	auipc	a5,0x1
 16e:	e967a783          	lw	a5,-362(a5) # 1000 <count>
 172:	02f05363          	blez	a5,198 <test0+0xd0>
    printf("test0 passed\n");
 176:	00001517          	auipc	a0,0x1
 17a:	c3250513          	addi	a0,a0,-974 # da8 <malloc+0x16e>
 17e:	205000ef          	jal	b82 <printf>
}
 182:	60a6                	ld	ra,72(sp)
 184:	6406                	ld	s0,64(sp)
 186:	74e2                	ld	s1,56(sp)
 188:	7942                	ld	s2,48(sp)
 18a:	79a2                	ld	s3,40(sp)
 18c:	7a02                	ld	s4,32(sp)
 18e:	6ae2                	ld	s5,24(sp)
 190:	6b42                	ld	s6,16(sp)
 192:	6ba2                	ld	s7,8(sp)
 194:	6161                	addi	sp,sp,80
 196:	8082                	ret
    printf("\ntest0 failed: the kernel never called the alarm handler\n");
 198:	00001517          	auipc	a0,0x1
 19c:	c2050513          	addi	a0,a0,-992 # db8 <malloc+0x17e>
 1a0:	1e3000ef          	jal	b82 <printf>
}
 1a4:	bff9                	j	182 <test0+0xba>

00000000000001a6 <foo>:
int __attribute__ ((noinline)) foo(int i, int *j) {
 1a6:	1101                	addi	sp,sp,-32
 1a8:	ec06                	sd	ra,24(sp)
 1aa:	e822                	sd	s0,16(sp)
 1ac:	e426                	sd	s1,8(sp)
 1ae:	1000                	addi	s0,sp,32
 1b0:	84ae                	mv	s1,a1
  if((i % 2500000) == 0) {
 1b2:	6b5fd7b7          	lui	a5,0x6b5fd
 1b6:	a6b78793          	addi	a5,a5,-1429 # 6b5fca6b <base+0x6b5fba5b>
 1ba:	02f507b3          	mul	a5,a0,a5
 1be:	97d1                	srai	a5,a5,0x34
 1c0:	41f5571b          	sraiw	a4,a0,0x1f
 1c4:	9f99                	subw	a5,a5,a4
 1c6:	00262737          	lui	a4,0x262
 1ca:	5a07071b          	addiw	a4,a4,1440 # 2625a0 <base+0x261590>
 1ce:	02f707bb          	mulw	a5,a4,a5
 1d2:	9d1d                	subw	a0,a0,a5
 1d4:	c919                	beqz	a0,1ea <foo+0x44>
  *j += 1;
 1d6:	409c                	lw	a5,0(s1)
 1d8:	2785                	addiw	a5,a5,1
 1da:	c09c                	sw	a5,0(s1)
}
 1dc:	53900513          	li	a0,1337
 1e0:	60e2                	ld	ra,24(sp)
 1e2:	6442                	ld	s0,16(sp)
 1e4:	64a2                	ld	s1,8(sp)
 1e6:	6105                	addi	sp,sp,32
 1e8:	8082                	ret
    write(2, ".", 1);
 1ea:	4605                	li	a2,1
 1ec:	00001597          	auipc	a1,0x1
 1f0:	bb458593          	addi	a1,a1,-1100 # da0 <malloc+0x166>
 1f4:	4509                	li	a0,2
 1f6:	556000ef          	jal	74c <write>
 1fa:	bff1                	j	1d6 <foo+0x30>

00000000000001fc <test1>:
{
 1fc:	711d                	addi	sp,sp,-96
 1fe:	ec86                	sd	ra,88(sp)
 200:	e8a2                	sd	s0,80(sp)
 202:	e4a6                	sd	s1,72(sp)
 204:	e0ca                	sd	s2,64(sp)
 206:	fc4e                	sd	s3,56(sp)
 208:	f852                	sd	s4,48(sp)
 20a:	f456                	sd	s5,40(sp)
 20c:	f05a                	sd	s6,32(sp)
 20e:	ec5e                	sd	s7,24(sp)
 210:	1080                	addi	s0,sp,96
  printf("test1 start\n");
 212:	00001517          	auipc	a0,0x1
 216:	be650513          	addi	a0,a0,-1050 # df8 <malloc+0x1be>
 21a:	169000ef          	jal	b82 <printf>
  s11_var = S11_CHECKVAL;
 21e:	6d89                	lui	s11,0x2
 220:	825d8d9b          	addiw	s11,s11,-2011 # 1825 <base+0x815>
  count = 0;
 224:	00001797          	auipc	a5,0x1
 228:	dc07ae23          	sw	zero,-548(a5) # 1000 <count>
  j = 0;
 22c:	fa042623          	sw	zero,-84(s0)
  sigalarm(2, periodic);
 230:	00000597          	auipc	a1,0x0
 234:	dd058593          	addi	a1,a1,-560 # 0 <periodic>
 238:	4509                	li	a0,2
 23a:	592000ef          	jal	7cc <sigalarm>
  for(i = 0; i < 500000000; i++){
 23e:	4481                	li	s1,0
    if(count >= 10)
 240:	00001a97          	auipc	s5,0x1
 244:	dc0a8a93          	addi	s5,s5,-576 # 1000 <count>
 248:	4a25                	li	s4,9
    if(foo(i, &j) != A0_CHECKVAL){
 24a:	fac40b93          	addi	s7,s0,-84
 24e:	53900b13          	li	s6,1337
    if(s11_var != S11_CHECKVAL){
 252:	6989                	lui	s3,0x2
 254:	82598993          	addi	s3,s3,-2011 # 1825 <base+0x815>
  for(i = 0; i < 500000000; i++){
 258:	1dcd6937          	lui	s2,0x1dcd6
 25c:	50090913          	addi	s2,s2,1280 # 1dcd6500 <base+0x1dcd54f0>
    if(count >= 10)
 260:	000aa783          	lw	a5,0(s5)
 264:	2781                	sext.w	a5,a5
 266:	00fa4f63          	blt	s4,a5,284 <test1+0x88>
    if(foo(i, &j) != A0_CHECKVAL){
 26a:	85de                	mv	a1,s7
 26c:	8526                	mv	a0,s1
 26e:	f39ff0ef          	jal	1a6 <foo>
 272:	05651563          	bne	a0,s6,2bc <test1+0xc0>
    if(s11_var != S11_CHECKVAL){
 276:	000d879b          	sext.w	a5,s11
 27a:	05379a63          	bne	a5,s3,2ce <test1+0xd2>
  for(i = 0; i < 500000000; i++){
 27e:	2485                	addiw	s1,s1,1
 280:	ff2490e3          	bne	s1,s2,260 <test1+0x64>
  if(count < 10){
 284:	00001717          	auipc	a4,0x1
 288:	d7c72703          	lw	a4,-644(a4) # 1000 <count>
 28c:	47a5                	li	a5,9
 28e:	04e7d963          	bge	a5,a4,2e0 <test1+0xe4>
  } else if(i != j){
 292:	fac42783          	lw	a5,-84(s0)
 296:	04978c63          	beq	a5,s1,2ee <test1+0xf2>
    printf("\ntest1 failed: foo() executed fewer times than it was called\n");
 29a:	00001517          	auipc	a0,0x1
 29e:	bf650513          	addi	a0,a0,-1034 # e90 <malloc+0x256>
 2a2:	0e1000ef          	jal	b82 <printf>
}
 2a6:	60e6                	ld	ra,88(sp)
 2a8:	6446                	ld	s0,80(sp)
 2aa:	64a6                	ld	s1,72(sp)
 2ac:	6906                	ld	s2,64(sp)
 2ae:	79e2                	ld	s3,56(sp)
 2b0:	7a42                	ld	s4,48(sp)
 2b2:	7aa2                	ld	s5,40(sp)
 2b4:	7b02                	ld	s6,32(sp)
 2b6:	6be2                	ld	s7,24(sp)
 2b8:	6125                	addi	sp,sp,96
 2ba:	8082                	ret
      printf("\ntest1 failed: a0 not preserved\n");
 2bc:	00001517          	auipc	a0,0x1
 2c0:	b4c50513          	addi	a0,a0,-1204 # e08 <malloc+0x1ce>
 2c4:	0bf000ef          	jal	b82 <printf>
      exit(1);
 2c8:	4505                	li	a0,1
 2ca:	462000ef          	jal	72c <exit>
      printf("\ntest1 failed: register s11 not preserved\n");
 2ce:	00001517          	auipc	a0,0x1
 2d2:	b6250513          	addi	a0,a0,-1182 # e30 <malloc+0x1f6>
 2d6:	0ad000ef          	jal	b82 <printf>
      exit(1);
 2da:	4505                	li	a0,1
 2dc:	450000ef          	jal	72c <exit>
    printf("\ntest1 failed: too few calls to the handler\n");
 2e0:	00001517          	auipc	a0,0x1
 2e4:	b8050513          	addi	a0,a0,-1152 # e60 <malloc+0x226>
 2e8:	09b000ef          	jal	b82 <printf>
 2ec:	bf6d                	j	2a6 <test1+0xaa>
    printf("test1 passed\n");
 2ee:	00001517          	auipc	a0,0x1
 2f2:	be250513          	addi	a0,a0,-1054 # ed0 <malloc+0x296>
 2f6:	08d000ef          	jal	b82 <printf>
}
 2fa:	b775                	j	2a6 <test1+0xaa>

00000000000002fc <test2>:
{
 2fc:	711d                	addi	sp,sp,-96
 2fe:	ec86                	sd	ra,88(sp)
 300:	e8a2                	sd	s0,80(sp)
 302:	1080                	addi	s0,sp,96
  printf("test2 start\n");
 304:	00001517          	auipc	a0,0x1
 308:	bdc50513          	addi	a0,a0,-1060 # ee0 <malloc+0x2a6>
 30c:	077000ef          	jal	b82 <printf>
  if ((pid = fork()) < 0) {
 310:	414000ef          	jal	724 <fork>
 314:	04054963          	bltz	a0,366 <test2+0x6a>
 318:	e4a6                	sd	s1,72(sp)
 31a:	84aa                	mv	s1,a0
  if (pid == 0) {
 31c:	e561                	bnez	a0,3e4 <test2+0xe8>
 31e:	e0ca                	sd	s2,64(sp)
 320:	fc4e                	sd	s3,56(sp)
 322:	f852                	sd	s4,48(sp)
 324:	f456                	sd	s5,40(sp)
 326:	f05a                	sd	s6,32(sp)
 328:	ec5e                	sd	s7,24(sp)
    count = 0;
 32a:	00001797          	auipc	a5,0x1
 32e:	cc07ab23          	sw	zero,-810(a5) # 1000 <count>
    sigalarm(2, slow_handler);
 332:	00000597          	auipc	a1,0x0
 336:	d1058593          	addi	a1,a1,-752 # 42 <slow_handler>
 33a:	4509                	li	a0,2
 33c:	490000ef          	jal	7cc <sigalarm>
      if((i % 1000000) == 0)
 340:	431be9b7          	lui	s3,0x431be
 344:	e8398993          	addi	s3,s3,-381 # 431bde83 <base+0x431bce73>
 348:	000f4937          	lui	s2,0xf4
 34c:	2409091b          	addiw	s2,s2,576 # f4240 <base+0xf3230>
        write(2, ".", 1);
 350:	4b85                	li	s7,1
 352:	00001b17          	auipc	s6,0x1
 356:	a4eb0b13          	addi	s6,s6,-1458 # da0 <malloc+0x166>
 35a:	4a89                	li	s5,2
      if(count > 0)
 35c:	00001a17          	auipc	s4,0x1
 360:	ca4a0a13          	addi	s4,s4,-860 # 1000 <count>
 364:	a835                	j	3a0 <test2+0xa4>
    printf("test2: fork failed\n");
 366:	00001517          	auipc	a0,0x1
 36a:	b8a50513          	addi	a0,a0,-1142 # ef0 <malloc+0x2b6>
 36e:	015000ef          	jal	b82 <printf>
  wait(&status);
 372:	fac40513          	addi	a0,s0,-84
 376:	3be000ef          	jal	734 <wait>
  if (status == 0) {
 37a:	fac42783          	lw	a5,-84(s0)
 37e:	c7ad                	beqz	a5,3e8 <test2+0xec>
}
 380:	60e6                	ld	ra,88(sp)
 382:	6446                	ld	s0,80(sp)
 384:	6125                	addi	sp,sp,96
 386:	8082                	ret
      if(count > 0)
 388:	000a2783          	lw	a5,0(s4)
 38c:	2781                	sext.w	a5,a5
 38e:	02f04a63          	bgtz	a5,3c2 <test2+0xc6>
    for(i = 0; i < 1000*500000; i++){
 392:	2485                	addiw	s1,s1,1
 394:	1dcd67b7          	lui	a5,0x1dcd6
 398:	50078793          	addi	a5,a5,1280 # 1dcd6500 <base+0x1dcd54f0>
 39c:	02f48363          	beq	s1,a5,3c2 <test2+0xc6>
      if((i % 1000000) == 0)
 3a0:	033487b3          	mul	a5,s1,s3
 3a4:	97c9                	srai	a5,a5,0x32
 3a6:	41f4d71b          	sraiw	a4,s1,0x1f
 3aa:	9f99                	subw	a5,a5,a4
 3ac:	02f907bb          	mulw	a5,s2,a5
 3b0:	40f487bb          	subw	a5,s1,a5
 3b4:	fbf1                	bnez	a5,388 <test2+0x8c>
        write(2, ".", 1);
 3b6:	865e                	mv	a2,s7
 3b8:	85da                	mv	a1,s6
 3ba:	8556                	mv	a0,s5
 3bc:	390000ef          	jal	74c <write>
 3c0:	b7e1                	j	388 <test2+0x8c>
    if (count == 0) {
 3c2:	00001797          	auipc	a5,0x1
 3c6:	c3e7a783          	lw	a5,-962(a5) # 1000 <count>
 3ca:	eb91                	bnez	a5,3de <test2+0xe2>
      printf("\ntest2 failed: alarm not called\n");
 3cc:	00001517          	auipc	a0,0x1
 3d0:	b3c50513          	addi	a0,a0,-1220 # f08 <malloc+0x2ce>
 3d4:	7ae000ef          	jal	b82 <printf>
      exit(1);
 3d8:	4505                	li	a0,1
 3da:	352000ef          	jal	72c <exit>
    exit(0);
 3de:	4501                	li	a0,0
 3e0:	34c000ef          	jal	72c <exit>
 3e4:	64a6                	ld	s1,72(sp)
 3e6:	b771                	j	372 <test2+0x76>
    printf("test2 passed\n");
 3e8:	00001517          	auipc	a0,0x1
 3ec:	b4850513          	addi	a0,a0,-1208 # f30 <malloc+0x2f6>
 3f0:	792000ef          	jal	b82 <printf>
}
 3f4:	b771                	j	380 <test2+0x84>

00000000000003f6 <test3>:
//
// tests that the return from sys_sigreturn() does not
// modify the a0 register
void
test3()
{
 3f6:	1141                	addi	sp,sp,-16
 3f8:	e406                	sd	ra,8(sp)
 3fa:	e022                	sd	s0,0(sp)
 3fc:	0800                	addi	s0,sp,16
  uint64 a0;

  sigalarm(1, dummy_handler);
 3fe:	00000597          	auipc	a1,0x0
 402:	cae58593          	addi	a1,a1,-850 # ac <dummy_handler>
 406:	4505                	li	a0,1
 408:	3c4000ef          	jal	7cc <sigalarm>
  printf("test3 start\n");
 40c:	00001517          	auipc	a0,0x1
 410:	b3450513          	addi	a0,a0,-1228 # f40 <malloc+0x306>
 414:	76e000ef          	jal	b82 <printf>

  asm volatile("lui a5, 0");
 418:	000007b7          	lui	a5,0x0
  asm volatile("addi a0, a5, 0xac" : : : "a0");
 41c:	0ac78513          	addi	a0,a5,172 # ac <dummy_handler>
 420:	1dcd67b7          	lui	a5,0x1dcd6
 424:	50078793          	addi	a5,a5,1280 # 1dcd6500 <base+0x1dcd54f0>
  for(int i = 0; i < 500000000; i++)
 428:	37fd                	addiw	a5,a5,-1
 42a:	fffd                	bnez	a5,428 <test3+0x32>
    ;
  asm volatile("mv %0, a0" : "=r" (a0) );
 42c:	872a                	mv	a4,a0

  if(a0 != 0xac)
 42e:	0ac00793          	li	a5,172
 432:	00f70c63          	beq	a4,a5,44a <test3+0x54>
    printf("test3 failed: register a0 changed\n");
 436:	00001517          	auipc	a0,0x1
 43a:	b1a50513          	addi	a0,a0,-1254 # f50 <malloc+0x316>
 43e:	744000ef          	jal	b82 <printf>
  else
    printf("test3 passed\n");
}
 442:	60a2                	ld	ra,8(sp)
 444:	6402                	ld	s0,0(sp)
 446:	0141                	addi	sp,sp,16
 448:	8082                	ret
    printf("test3 passed\n");
 44a:	00001517          	auipc	a0,0x1
 44e:	b2e50513          	addi	a0,a0,-1234 # f78 <malloc+0x33e>
 452:	730000ef          	jal	b82 <printf>
}
 456:	b7f5                	j	442 <test3+0x4c>

0000000000000458 <main>:
{
 458:	1141                	addi	sp,sp,-16
 45a:	e406                	sd	ra,8(sp)
 45c:	e022                	sd	s0,0(sp)
 45e:	0800                	addi	s0,sp,16
  test0();
 460:	c69ff0ef          	jal	c8 <test0>
  test1();
 464:	d99ff0ef          	jal	1fc <test1>
  test2();
 468:	e95ff0ef          	jal	2fc <test2>
  test3();
 46c:	f8bff0ef          	jal	3f6 <test3>
  exit(0);
 470:	4501                	li	a0,0
 472:	2ba000ef          	jal	72c <exit>

0000000000000476 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 476:	1141                	addi	sp,sp,-16
 478:	e406                	sd	ra,8(sp)
 47a:	e022                	sd	s0,0(sp)
 47c:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 47e:	fdbff0ef          	jal	458 <main>
  exit(r);
 482:	2aa000ef          	jal	72c <exit>

0000000000000486 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 486:	1141                	addi	sp,sp,-16
 488:	e406                	sd	ra,8(sp)
 48a:	e022                	sd	s0,0(sp)
 48c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 48e:	87aa                	mv	a5,a0
 490:	0585                	addi	a1,a1,1
 492:	0785                	addi	a5,a5,1
 494:	fff5c703          	lbu	a4,-1(a1)
 498:	fee78fa3          	sb	a4,-1(a5)
 49c:	fb75                	bnez	a4,490 <strcpy+0xa>
    ;
  return os;
}
 49e:	60a2                	ld	ra,8(sp)
 4a0:	6402                	ld	s0,0(sp)
 4a2:	0141                	addi	sp,sp,16
 4a4:	8082                	ret

00000000000004a6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 4a6:	1141                	addi	sp,sp,-16
 4a8:	e406                	sd	ra,8(sp)
 4aa:	e022                	sd	s0,0(sp)
 4ac:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 4ae:	00054783          	lbu	a5,0(a0)
 4b2:	cb91                	beqz	a5,4c6 <strcmp+0x20>
 4b4:	0005c703          	lbu	a4,0(a1)
 4b8:	00f71763          	bne	a4,a5,4c6 <strcmp+0x20>
    p++, q++;
 4bc:	0505                	addi	a0,a0,1
 4be:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 4c0:	00054783          	lbu	a5,0(a0)
 4c4:	fbe5                	bnez	a5,4b4 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 4c6:	0005c503          	lbu	a0,0(a1)
}
 4ca:	40a7853b          	subw	a0,a5,a0
 4ce:	60a2                	ld	ra,8(sp)
 4d0:	6402                	ld	s0,0(sp)
 4d2:	0141                	addi	sp,sp,16
 4d4:	8082                	ret

00000000000004d6 <strlen>:

uint
strlen(const char *s)
{
 4d6:	1141                	addi	sp,sp,-16
 4d8:	e406                	sd	ra,8(sp)
 4da:	e022                	sd	s0,0(sp)
 4dc:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 4de:	00054783          	lbu	a5,0(a0)
 4e2:	cf91                	beqz	a5,4fe <strlen+0x28>
 4e4:	00150793          	addi	a5,a0,1
 4e8:	86be                	mv	a3,a5
 4ea:	0785                	addi	a5,a5,1
 4ec:	fff7c703          	lbu	a4,-1(a5)
 4f0:	ff65                	bnez	a4,4e8 <strlen+0x12>
 4f2:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 4f6:	60a2                	ld	ra,8(sp)
 4f8:	6402                	ld	s0,0(sp)
 4fa:	0141                	addi	sp,sp,16
 4fc:	8082                	ret
  for(n = 0; s[n]; n++)
 4fe:	4501                	li	a0,0
 500:	bfdd                	j	4f6 <strlen+0x20>

0000000000000502 <memset>:

void*
memset(void *dst, int c, uint n)
{
 502:	1141                	addi	sp,sp,-16
 504:	e406                	sd	ra,8(sp)
 506:	e022                	sd	s0,0(sp)
 508:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 50a:	ca19                	beqz	a2,520 <memset+0x1e>
 50c:	87aa                	mv	a5,a0
 50e:	1602                	slli	a2,a2,0x20
 510:	9201                	srli	a2,a2,0x20
 512:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 516:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 51a:	0785                	addi	a5,a5,1
 51c:	fee79de3          	bne	a5,a4,516 <memset+0x14>
  }
  return dst;
}
 520:	60a2                	ld	ra,8(sp)
 522:	6402                	ld	s0,0(sp)
 524:	0141                	addi	sp,sp,16
 526:	8082                	ret

0000000000000528 <strchr>:

char*
strchr(const char *s, char c)
{
 528:	1141                	addi	sp,sp,-16
 52a:	e406                	sd	ra,8(sp)
 52c:	e022                	sd	s0,0(sp)
 52e:	0800                	addi	s0,sp,16
  for(; *s; s++)
 530:	00054783          	lbu	a5,0(a0)
 534:	cf81                	beqz	a5,54c <strchr+0x24>
    if(*s == c)
 536:	00f58763          	beq	a1,a5,544 <strchr+0x1c>
  for(; *s; s++)
 53a:	0505                	addi	a0,a0,1
 53c:	00054783          	lbu	a5,0(a0)
 540:	fbfd                	bnez	a5,536 <strchr+0xe>
      return (char*)s;
  return 0;
 542:	4501                	li	a0,0
}
 544:	60a2                	ld	ra,8(sp)
 546:	6402                	ld	s0,0(sp)
 548:	0141                	addi	sp,sp,16
 54a:	8082                	ret
  return 0;
 54c:	4501                	li	a0,0
 54e:	bfdd                	j	544 <strchr+0x1c>

0000000000000550 <gets>:

char*
gets(char *buf, int max)
{
 550:	711d                	addi	sp,sp,-96
 552:	ec86                	sd	ra,88(sp)
 554:	e8a2                	sd	s0,80(sp)
 556:	e4a6                	sd	s1,72(sp)
 558:	e0ca                	sd	s2,64(sp)
 55a:	fc4e                	sd	s3,56(sp)
 55c:	f852                	sd	s4,48(sp)
 55e:	f456                	sd	s5,40(sp)
 560:	f05a                	sd	s6,32(sp)
 562:	ec5e                	sd	s7,24(sp)
 564:	e862                	sd	s8,16(sp)
 566:	1080                	addi	s0,sp,96
 568:	8baa                	mv	s7,a0
 56a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 56c:	892a                	mv	s2,a0
 56e:	4481                	li	s1,0
    cc = read(0, &c, 1);
 570:	faf40b13          	addi	s6,s0,-81
 574:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 576:	8c26                	mv	s8,s1
 578:	0014899b          	addiw	s3,s1,1
 57c:	84ce                	mv	s1,s3
 57e:	0349d463          	bge	s3,s4,5a6 <gets+0x56>
    cc = read(0, &c, 1);
 582:	8656                	mv	a2,s5
 584:	85da                	mv	a1,s6
 586:	4501                	li	a0,0
 588:	1bc000ef          	jal	744 <read>
    if(cc < 1)
 58c:	00a05d63          	blez	a0,5a6 <gets+0x56>
      break;
    buf[i++] = c;
 590:	faf44783          	lbu	a5,-81(s0)
 594:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 598:	0905                	addi	s2,s2,1
 59a:	ff678713          	addi	a4,a5,-10
 59e:	c319                	beqz	a4,5a4 <gets+0x54>
 5a0:	17cd                	addi	a5,a5,-13
 5a2:	fbf1                	bnez	a5,576 <gets+0x26>
    buf[i++] = c;
 5a4:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 5a6:	9c5e                	add	s8,s8,s7
 5a8:	000c0023          	sb	zero,0(s8)
  return buf;
}
 5ac:	855e                	mv	a0,s7
 5ae:	60e6                	ld	ra,88(sp)
 5b0:	6446                	ld	s0,80(sp)
 5b2:	64a6                	ld	s1,72(sp)
 5b4:	6906                	ld	s2,64(sp)
 5b6:	79e2                	ld	s3,56(sp)
 5b8:	7a42                	ld	s4,48(sp)
 5ba:	7aa2                	ld	s5,40(sp)
 5bc:	7b02                	ld	s6,32(sp)
 5be:	6be2                	ld	s7,24(sp)
 5c0:	6c42                	ld	s8,16(sp)
 5c2:	6125                	addi	sp,sp,96
 5c4:	8082                	ret

00000000000005c6 <stat>:

int
stat(const char *n, struct stat *st)
{
 5c6:	1101                	addi	sp,sp,-32
 5c8:	ec06                	sd	ra,24(sp)
 5ca:	e822                	sd	s0,16(sp)
 5cc:	e04a                	sd	s2,0(sp)
 5ce:	1000                	addi	s0,sp,32
 5d0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 5d2:	4581                	li	a1,0
 5d4:	198000ef          	jal	76c <open>
  if(fd < 0)
 5d8:	02054263          	bltz	a0,5fc <stat+0x36>
 5dc:	e426                	sd	s1,8(sp)
 5de:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 5e0:	85ca                	mv	a1,s2
 5e2:	1a2000ef          	jal	784 <fstat>
 5e6:	892a                	mv	s2,a0
  close(fd);
 5e8:	8526                	mv	a0,s1
 5ea:	16a000ef          	jal	754 <close>
  return r;
 5ee:	64a2                	ld	s1,8(sp)
}
 5f0:	854a                	mv	a0,s2
 5f2:	60e2                	ld	ra,24(sp)
 5f4:	6442                	ld	s0,16(sp)
 5f6:	6902                	ld	s2,0(sp)
 5f8:	6105                	addi	sp,sp,32
 5fa:	8082                	ret
    return -1;
 5fc:	57fd                	li	a5,-1
 5fe:	893e                	mv	s2,a5
 600:	bfc5                	j	5f0 <stat+0x2a>

0000000000000602 <atoi>:

int
atoi(const char *s)
{
 602:	1141                	addi	sp,sp,-16
 604:	e406                	sd	ra,8(sp)
 606:	e022                	sd	s0,0(sp)
 608:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 60a:	00054683          	lbu	a3,0(a0)
 60e:	fd06879b          	addiw	a5,a3,-48
 612:	0ff7f793          	zext.b	a5,a5
 616:	4625                	li	a2,9
 618:	02f66963          	bltu	a2,a5,64a <atoi+0x48>
 61c:	872a                	mv	a4,a0
  n = 0;
 61e:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 620:	0705                	addi	a4,a4,1
 622:	0025179b          	slliw	a5,a0,0x2
 626:	9fa9                	addw	a5,a5,a0
 628:	0017979b          	slliw	a5,a5,0x1
 62c:	9fb5                	addw	a5,a5,a3
 62e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 632:	00074683          	lbu	a3,0(a4)
 636:	fd06879b          	addiw	a5,a3,-48
 63a:	0ff7f793          	zext.b	a5,a5
 63e:	fef671e3          	bgeu	a2,a5,620 <atoi+0x1e>
  return n;
}
 642:	60a2                	ld	ra,8(sp)
 644:	6402                	ld	s0,0(sp)
 646:	0141                	addi	sp,sp,16
 648:	8082                	ret
  n = 0;
 64a:	4501                	li	a0,0
 64c:	bfdd                	j	642 <atoi+0x40>

000000000000064e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 64e:	1141                	addi	sp,sp,-16
 650:	e406                	sd	ra,8(sp)
 652:	e022                	sd	s0,0(sp)
 654:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 656:	02b57563          	bgeu	a0,a1,680 <memmove+0x32>
    while(n-- > 0)
 65a:	00c05f63          	blez	a2,678 <memmove+0x2a>
 65e:	1602                	slli	a2,a2,0x20
 660:	9201                	srli	a2,a2,0x20
 662:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 666:	872a                	mv	a4,a0
      *dst++ = *src++;
 668:	0585                	addi	a1,a1,1
 66a:	0705                	addi	a4,a4,1
 66c:	fff5c683          	lbu	a3,-1(a1)
 670:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 674:	fee79ae3          	bne	a5,a4,668 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 678:	60a2                	ld	ra,8(sp)
 67a:	6402                	ld	s0,0(sp)
 67c:	0141                	addi	sp,sp,16
 67e:	8082                	ret
    while(n-- > 0)
 680:	fec05ce3          	blez	a2,678 <memmove+0x2a>
    dst += n;
 684:	00c50733          	add	a4,a0,a2
    src += n;
 688:	95b2                	add	a1,a1,a2
 68a:	fff6079b          	addiw	a5,a2,-1
 68e:	1782                	slli	a5,a5,0x20
 690:	9381                	srli	a5,a5,0x20
 692:	fff7c793          	not	a5,a5
 696:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 698:	15fd                	addi	a1,a1,-1
 69a:	177d                	addi	a4,a4,-1
 69c:	0005c683          	lbu	a3,0(a1)
 6a0:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 6a4:	fef71ae3          	bne	a4,a5,698 <memmove+0x4a>
 6a8:	bfc1                	j	678 <memmove+0x2a>

00000000000006aa <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 6aa:	1141                	addi	sp,sp,-16
 6ac:	e406                	sd	ra,8(sp)
 6ae:	e022                	sd	s0,0(sp)
 6b0:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 6b2:	c61d                	beqz	a2,6e0 <memcmp+0x36>
 6b4:	1602                	slli	a2,a2,0x20
 6b6:	9201                	srli	a2,a2,0x20
 6b8:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 6bc:	00054783          	lbu	a5,0(a0)
 6c0:	0005c703          	lbu	a4,0(a1)
 6c4:	00e79863          	bne	a5,a4,6d4 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 6c8:	0505                	addi	a0,a0,1
    p2++;
 6ca:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 6cc:	fed518e3          	bne	a0,a3,6bc <memcmp+0x12>
  }
  return 0;
 6d0:	4501                	li	a0,0
 6d2:	a019                	j	6d8 <memcmp+0x2e>
      return *p1 - *p2;
 6d4:	40e7853b          	subw	a0,a5,a4
}
 6d8:	60a2                	ld	ra,8(sp)
 6da:	6402                	ld	s0,0(sp)
 6dc:	0141                	addi	sp,sp,16
 6de:	8082                	ret
  return 0;
 6e0:	4501                	li	a0,0
 6e2:	bfdd                	j	6d8 <memcmp+0x2e>

00000000000006e4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 6e4:	1141                	addi	sp,sp,-16
 6e6:	e406                	sd	ra,8(sp)
 6e8:	e022                	sd	s0,0(sp)
 6ea:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 6ec:	f63ff0ef          	jal	64e <memmove>
}
 6f0:	60a2                	ld	ra,8(sp)
 6f2:	6402                	ld	s0,0(sp)
 6f4:	0141                	addi	sp,sp,16
 6f6:	8082                	ret

00000000000006f8 <sbrk>:

char *
sbrk(int n) {
 6f8:	1141                	addi	sp,sp,-16
 6fa:	e406                	sd	ra,8(sp)
 6fc:	e022                	sd	s0,0(sp)
 6fe:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 700:	4585                	li	a1,1
 702:	0b2000ef          	jal	7b4 <sys_sbrk>
}
 706:	60a2                	ld	ra,8(sp)
 708:	6402                	ld	s0,0(sp)
 70a:	0141                	addi	sp,sp,16
 70c:	8082                	ret

000000000000070e <sbrklazy>:

char *
sbrklazy(int n) {
 70e:	1141                	addi	sp,sp,-16
 710:	e406                	sd	ra,8(sp)
 712:	e022                	sd	s0,0(sp)
 714:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 716:	4589                	li	a1,2
 718:	09c000ef          	jal	7b4 <sys_sbrk>
}
 71c:	60a2                	ld	ra,8(sp)
 71e:	6402                	ld	s0,0(sp)
 720:	0141                	addi	sp,sp,16
 722:	8082                	ret

0000000000000724 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 724:	4885                	li	a7,1
 ecall
 726:	00000073          	ecall
 ret
 72a:	8082                	ret

000000000000072c <exit>:
.global exit
exit:
 li a7, SYS_exit
 72c:	4889                	li	a7,2
 ecall
 72e:	00000073          	ecall
 ret
 732:	8082                	ret

0000000000000734 <wait>:
.global wait
wait:
 li a7, SYS_wait
 734:	488d                	li	a7,3
 ecall
 736:	00000073          	ecall
 ret
 73a:	8082                	ret

000000000000073c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 73c:	4891                	li	a7,4
 ecall
 73e:	00000073          	ecall
 ret
 742:	8082                	ret

0000000000000744 <read>:
.global read
read:
 li a7, SYS_read
 744:	4895                	li	a7,5
 ecall
 746:	00000073          	ecall
 ret
 74a:	8082                	ret

000000000000074c <write>:
.global write
write:
 li a7, SYS_write
 74c:	48c1                	li	a7,16
 ecall
 74e:	00000073          	ecall
 ret
 752:	8082                	ret

0000000000000754 <close>:
.global close
close:
 li a7, SYS_close
 754:	48d5                	li	a7,21
 ecall
 756:	00000073          	ecall
 ret
 75a:	8082                	ret

000000000000075c <kill>:
.global kill
kill:
 li a7, SYS_kill
 75c:	4899                	li	a7,6
 ecall
 75e:	00000073          	ecall
 ret
 762:	8082                	ret

0000000000000764 <exec>:
.global exec
exec:
 li a7, SYS_exec
 764:	489d                	li	a7,7
 ecall
 766:	00000073          	ecall
 ret
 76a:	8082                	ret

000000000000076c <open>:
.global open
open:
 li a7, SYS_open
 76c:	48bd                	li	a7,15
 ecall
 76e:	00000073          	ecall
 ret
 772:	8082                	ret

0000000000000774 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 774:	48c5                	li	a7,17
 ecall
 776:	00000073          	ecall
 ret
 77a:	8082                	ret

000000000000077c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 77c:	48c9                	li	a7,18
 ecall
 77e:	00000073          	ecall
 ret
 782:	8082                	ret

0000000000000784 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 784:	48a1                	li	a7,8
 ecall
 786:	00000073          	ecall
 ret
 78a:	8082                	ret

000000000000078c <link>:
.global link
link:
 li a7, SYS_link
 78c:	48cd                	li	a7,19
 ecall
 78e:	00000073          	ecall
 ret
 792:	8082                	ret

0000000000000794 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 794:	48d1                	li	a7,20
 ecall
 796:	00000073          	ecall
 ret
 79a:	8082                	ret

000000000000079c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 79c:	48a5                	li	a7,9
 ecall
 79e:	00000073          	ecall
 ret
 7a2:	8082                	ret

00000000000007a4 <dup>:
.global dup
dup:
 li a7, SYS_dup
 7a4:	48a9                	li	a7,10
 ecall
 7a6:	00000073          	ecall
 ret
 7aa:	8082                	ret

00000000000007ac <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 7ac:	48ad                	li	a7,11
 ecall
 7ae:	00000073          	ecall
 ret
 7b2:	8082                	ret

00000000000007b4 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 7b4:	48b1                	li	a7,12
 ecall
 7b6:	00000073          	ecall
 ret
 7ba:	8082                	ret

00000000000007bc <pause>:
.global pause
pause:
 li a7, SYS_pause
 7bc:	48b5                	li	a7,13
 ecall
 7be:	00000073          	ecall
 ret
 7c2:	8082                	ret

00000000000007c4 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 7c4:	48b9                	li	a7,14
 ecall
 7c6:	00000073          	ecall
 ret
 7ca:	8082                	ret

00000000000007cc <sigalarm>:
.global sigalarm
sigalarm:
 li a7, SYS_sigalarm
 7cc:	48d9                	li	a7,22
 ecall
 7ce:	00000073          	ecall
 ret
 7d2:	8082                	ret

00000000000007d4 <sigreturn>:
.global sigreturn
sigreturn:
 li a7, SYS_sigreturn
 7d4:	48dd                	li	a7,23
 ecall
 7d6:	00000073          	ecall
 ret
 7da:	8082                	ret

00000000000007dc <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 7dc:	1101                	addi	sp,sp,-32
 7de:	ec06                	sd	ra,24(sp)
 7e0:	e822                	sd	s0,16(sp)
 7e2:	1000                	addi	s0,sp,32
 7e4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 7e8:	4605                	li	a2,1
 7ea:	fef40593          	addi	a1,s0,-17
 7ee:	f5fff0ef          	jal	74c <write>
}
 7f2:	60e2                	ld	ra,24(sp)
 7f4:	6442                	ld	s0,16(sp)
 7f6:	6105                	addi	sp,sp,32
 7f8:	8082                	ret

00000000000007fa <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 7fa:	715d                	addi	sp,sp,-80
 7fc:	e486                	sd	ra,72(sp)
 7fe:	e0a2                	sd	s0,64(sp)
 800:	f84a                	sd	s2,48(sp)
 802:	f44e                	sd	s3,40(sp)
 804:	0880                	addi	s0,sp,80
 806:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 808:	c6d1                	beqz	a3,894 <printint+0x9a>
 80a:	0805d563          	bgez	a1,894 <printint+0x9a>
    neg = 1;
    x = -xx;
 80e:	40b005b3          	neg	a1,a1
    neg = 1;
 812:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 814:	fb840993          	addi	s3,s0,-72
  neg = 0;
 818:	86ce                	mv	a3,s3
  i = 0;
 81a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 81c:	00000817          	auipc	a6,0x0
 820:	77480813          	addi	a6,a6,1908 # f90 <digits>
 824:	88ba                	mv	a7,a4
 826:	0017051b          	addiw	a0,a4,1
 82a:	872a                	mv	a4,a0
 82c:	02c5f7b3          	remu	a5,a1,a2
 830:	97c2                	add	a5,a5,a6
 832:	0007c783          	lbu	a5,0(a5)
 836:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 83a:	87ae                	mv	a5,a1
 83c:	02c5d5b3          	divu	a1,a1,a2
 840:	0685                	addi	a3,a3,1
 842:	fec7f1e3          	bgeu	a5,a2,824 <printint+0x2a>
  if(neg)
 846:	00030c63          	beqz	t1,85e <printint+0x64>
    buf[i++] = '-';
 84a:	fd050793          	addi	a5,a0,-48
 84e:	00878533          	add	a0,a5,s0
 852:	02d00793          	li	a5,45
 856:	fef50423          	sb	a5,-24(a0)
 85a:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 85e:	02e05563          	blez	a4,888 <printint+0x8e>
 862:	fc26                	sd	s1,56(sp)
 864:	377d                	addiw	a4,a4,-1
 866:	00e984b3          	add	s1,s3,a4
 86a:	19fd                	addi	s3,s3,-1
 86c:	99ba                	add	s3,s3,a4
 86e:	1702                	slli	a4,a4,0x20
 870:	9301                	srli	a4,a4,0x20
 872:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 876:	0004c583          	lbu	a1,0(s1)
 87a:	854a                	mv	a0,s2
 87c:	f61ff0ef          	jal	7dc <putc>
  while(--i >= 0)
 880:	14fd                	addi	s1,s1,-1
 882:	ff349ae3          	bne	s1,s3,876 <printint+0x7c>
 886:	74e2                	ld	s1,56(sp)
}
 888:	60a6                	ld	ra,72(sp)
 88a:	6406                	ld	s0,64(sp)
 88c:	7942                	ld	s2,48(sp)
 88e:	79a2                	ld	s3,40(sp)
 890:	6161                	addi	sp,sp,80
 892:	8082                	ret
  neg = 0;
 894:	4301                	li	t1,0
 896:	bfbd                	j	814 <printint+0x1a>

0000000000000898 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 898:	711d                	addi	sp,sp,-96
 89a:	ec86                	sd	ra,88(sp)
 89c:	e8a2                	sd	s0,80(sp)
 89e:	e4a6                	sd	s1,72(sp)
 8a0:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 8a2:	0005c483          	lbu	s1,0(a1)
 8a6:	22048363          	beqz	s1,acc <vprintf+0x234>
 8aa:	e0ca                	sd	s2,64(sp)
 8ac:	fc4e                	sd	s3,56(sp)
 8ae:	f852                	sd	s4,48(sp)
 8b0:	f456                	sd	s5,40(sp)
 8b2:	f05a                	sd	s6,32(sp)
 8b4:	ec5e                	sd	s7,24(sp)
 8b6:	e862                	sd	s8,16(sp)
 8b8:	8b2a                	mv	s6,a0
 8ba:	8a2e                	mv	s4,a1
 8bc:	8bb2                	mv	s7,a2
  state = 0;
 8be:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 8c0:	4901                	li	s2,0
 8c2:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 8c4:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 8c8:	06400c13          	li	s8,100
 8cc:	a00d                	j	8ee <vprintf+0x56>
        putc(fd, c0);
 8ce:	85a6                	mv	a1,s1
 8d0:	855a                	mv	a0,s6
 8d2:	f0bff0ef          	jal	7dc <putc>
 8d6:	a019                	j	8dc <vprintf+0x44>
    } else if(state == '%'){
 8d8:	03598363          	beq	s3,s5,8fe <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 8dc:	0019079b          	addiw	a5,s2,1
 8e0:	893e                	mv	s2,a5
 8e2:	873e                	mv	a4,a5
 8e4:	97d2                	add	a5,a5,s4
 8e6:	0007c483          	lbu	s1,0(a5)
 8ea:	1c048a63          	beqz	s1,abe <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 8ee:	0004879b          	sext.w	a5,s1
    if(state == 0){
 8f2:	fe0993e3          	bnez	s3,8d8 <vprintf+0x40>
      if(c0 == '%'){
 8f6:	fd579ce3          	bne	a5,s5,8ce <vprintf+0x36>
        state = '%';
 8fa:	89be                	mv	s3,a5
 8fc:	b7c5                	j	8dc <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 8fe:	00ea06b3          	add	a3,s4,a4
 902:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 906:	1c060863          	beqz	a2,ad6 <vprintf+0x23e>
      if(c0 == 'd'){
 90a:	03878763          	beq	a5,s8,938 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 90e:	f9478693          	addi	a3,a5,-108
 912:	0016b693          	seqz	a3,a3
 916:	f9c60593          	addi	a1,a2,-100
 91a:	e99d                	bnez	a1,950 <vprintf+0xb8>
 91c:	ca95                	beqz	a3,950 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 91e:	008b8493          	addi	s1,s7,8
 922:	4685                	li	a3,1
 924:	4629                	li	a2,10
 926:	000bb583          	ld	a1,0(s7)
 92a:	855a                	mv	a0,s6
 92c:	ecfff0ef          	jal	7fa <printint>
        i += 1;
 930:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 932:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 934:	4981                	li	s3,0
 936:	b75d                	j	8dc <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 938:	008b8493          	addi	s1,s7,8
 93c:	4685                	li	a3,1
 93e:	4629                	li	a2,10
 940:	000ba583          	lw	a1,0(s7)
 944:	855a                	mv	a0,s6
 946:	eb5ff0ef          	jal	7fa <printint>
 94a:	8ba6                	mv	s7,s1
      state = 0;
 94c:	4981                	li	s3,0
 94e:	b779                	j	8dc <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 950:	9752                	add	a4,a4,s4
 952:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 956:	f9460713          	addi	a4,a2,-108
 95a:	00173713          	seqz	a4,a4
 95e:	8f75                	and	a4,a4,a3
 960:	f9c58513          	addi	a0,a1,-100
 964:	18051363          	bnez	a0,aea <vprintf+0x252>
 968:	18070163          	beqz	a4,aea <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 96c:	008b8493          	addi	s1,s7,8
 970:	4685                	li	a3,1
 972:	4629                	li	a2,10
 974:	000bb583          	ld	a1,0(s7)
 978:	855a                	mv	a0,s6
 97a:	e81ff0ef          	jal	7fa <printint>
        i += 2;
 97e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 980:	8ba6                	mv	s7,s1
      state = 0;
 982:	4981                	li	s3,0
        i += 2;
 984:	bfa1                	j	8dc <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 986:	008b8493          	addi	s1,s7,8
 98a:	4681                	li	a3,0
 98c:	4629                	li	a2,10
 98e:	000be583          	lwu	a1,0(s7)
 992:	855a                	mv	a0,s6
 994:	e67ff0ef          	jal	7fa <printint>
 998:	8ba6                	mv	s7,s1
      state = 0;
 99a:	4981                	li	s3,0
 99c:	b781                	j	8dc <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 99e:	008b8493          	addi	s1,s7,8
 9a2:	4681                	li	a3,0
 9a4:	4629                	li	a2,10
 9a6:	000bb583          	ld	a1,0(s7)
 9aa:	855a                	mv	a0,s6
 9ac:	e4fff0ef          	jal	7fa <printint>
        i += 1;
 9b0:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 9b2:	8ba6                	mv	s7,s1
      state = 0;
 9b4:	4981                	li	s3,0
 9b6:	b71d                	j	8dc <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 9b8:	008b8493          	addi	s1,s7,8
 9bc:	4681                	li	a3,0
 9be:	4629                	li	a2,10
 9c0:	000bb583          	ld	a1,0(s7)
 9c4:	855a                	mv	a0,s6
 9c6:	e35ff0ef          	jal	7fa <printint>
        i += 2;
 9ca:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 9cc:	8ba6                	mv	s7,s1
      state = 0;
 9ce:	4981                	li	s3,0
        i += 2;
 9d0:	b731                	j	8dc <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 9d2:	008b8493          	addi	s1,s7,8
 9d6:	4681                	li	a3,0
 9d8:	4641                	li	a2,16
 9da:	000be583          	lwu	a1,0(s7)
 9de:	855a                	mv	a0,s6
 9e0:	e1bff0ef          	jal	7fa <printint>
 9e4:	8ba6                	mv	s7,s1
      state = 0;
 9e6:	4981                	li	s3,0
 9e8:	bdd5                	j	8dc <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 9ea:	008b8493          	addi	s1,s7,8
 9ee:	4681                	li	a3,0
 9f0:	4641                	li	a2,16
 9f2:	000bb583          	ld	a1,0(s7)
 9f6:	855a                	mv	a0,s6
 9f8:	e03ff0ef          	jal	7fa <printint>
        i += 1;
 9fc:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 9fe:	8ba6                	mv	s7,s1
      state = 0;
 a00:	4981                	li	s3,0
 a02:	bde9                	j	8dc <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 a04:	008b8493          	addi	s1,s7,8
 a08:	4681                	li	a3,0
 a0a:	4641                	li	a2,16
 a0c:	000bb583          	ld	a1,0(s7)
 a10:	855a                	mv	a0,s6
 a12:	de9ff0ef          	jal	7fa <printint>
        i += 2;
 a16:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 a18:	8ba6                	mv	s7,s1
      state = 0;
 a1a:	4981                	li	s3,0
        i += 2;
 a1c:	b5c1                	j	8dc <vprintf+0x44>
 a1e:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 a20:	008b8793          	addi	a5,s7,8
 a24:	8cbe                	mv	s9,a5
 a26:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 a2a:	03000593          	li	a1,48
 a2e:	855a                	mv	a0,s6
 a30:	dadff0ef          	jal	7dc <putc>
  putc(fd, 'x');
 a34:	07800593          	li	a1,120
 a38:	855a                	mv	a0,s6
 a3a:	da3ff0ef          	jal	7dc <putc>
 a3e:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 a40:	00000b97          	auipc	s7,0x0
 a44:	550b8b93          	addi	s7,s7,1360 # f90 <digits>
 a48:	03c9d793          	srli	a5,s3,0x3c
 a4c:	97de                	add	a5,a5,s7
 a4e:	0007c583          	lbu	a1,0(a5)
 a52:	855a                	mv	a0,s6
 a54:	d89ff0ef          	jal	7dc <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 a58:	0992                	slli	s3,s3,0x4
 a5a:	34fd                	addiw	s1,s1,-1
 a5c:	f4f5                	bnez	s1,a48 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 a5e:	8be6                	mv	s7,s9
      state = 0;
 a60:	4981                	li	s3,0
 a62:	6ca2                	ld	s9,8(sp)
 a64:	bda5                	j	8dc <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 a66:	008b8493          	addi	s1,s7,8
 a6a:	000bc583          	lbu	a1,0(s7)
 a6e:	855a                	mv	a0,s6
 a70:	d6dff0ef          	jal	7dc <putc>
 a74:	8ba6                	mv	s7,s1
      state = 0;
 a76:	4981                	li	s3,0
 a78:	b595                	j	8dc <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 a7a:	008b8993          	addi	s3,s7,8
 a7e:	000bb483          	ld	s1,0(s7)
 a82:	cc91                	beqz	s1,a9e <vprintf+0x206>
        for(; *s; s++)
 a84:	0004c583          	lbu	a1,0(s1)
 a88:	c985                	beqz	a1,ab8 <vprintf+0x220>
          putc(fd, *s);
 a8a:	855a                	mv	a0,s6
 a8c:	d51ff0ef          	jal	7dc <putc>
        for(; *s; s++)
 a90:	0485                	addi	s1,s1,1
 a92:	0004c583          	lbu	a1,0(s1)
 a96:	f9f5                	bnez	a1,a8a <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 a98:	8bce                	mv	s7,s3
      state = 0;
 a9a:	4981                	li	s3,0
 a9c:	b581                	j	8dc <vprintf+0x44>
          s = "(null)";
 a9e:	00000497          	auipc	s1,0x0
 aa2:	4ea48493          	addi	s1,s1,1258 # f88 <malloc+0x34e>
        for(; *s; s++)
 aa6:	02800593          	li	a1,40
 aaa:	b7c5                	j	a8a <vprintf+0x1f2>
        putc(fd, '%');
 aac:	85be                	mv	a1,a5
 aae:	855a                	mv	a0,s6
 ab0:	d2dff0ef          	jal	7dc <putc>
      state = 0;
 ab4:	4981                	li	s3,0
 ab6:	b51d                	j	8dc <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 ab8:	8bce                	mv	s7,s3
      state = 0;
 aba:	4981                	li	s3,0
 abc:	b505                	j	8dc <vprintf+0x44>
 abe:	6906                	ld	s2,64(sp)
 ac0:	79e2                	ld	s3,56(sp)
 ac2:	7a42                	ld	s4,48(sp)
 ac4:	7aa2                	ld	s5,40(sp)
 ac6:	7b02                	ld	s6,32(sp)
 ac8:	6be2                	ld	s7,24(sp)
 aca:	6c42                	ld	s8,16(sp)
    }
  }
}
 acc:	60e6                	ld	ra,88(sp)
 ace:	6446                	ld	s0,80(sp)
 ad0:	64a6                	ld	s1,72(sp)
 ad2:	6125                	addi	sp,sp,96
 ad4:	8082                	ret
      if(c0 == 'd'){
 ad6:	06400713          	li	a4,100
 ada:	e4e78fe3          	beq	a5,a4,938 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 ade:	f9478693          	addi	a3,a5,-108
 ae2:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 ae6:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 ae8:	4701                	li	a4,0
      } else if(c0 == 'u'){
 aea:	07500513          	li	a0,117
 aee:	e8a78ce3          	beq	a5,a0,986 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 af2:	f8b60513          	addi	a0,a2,-117
 af6:	e119                	bnez	a0,afc <vprintf+0x264>
 af8:	ea0693e3          	bnez	a3,99e <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 afc:	f8b58513          	addi	a0,a1,-117
 b00:	e119                	bnez	a0,b06 <vprintf+0x26e>
 b02:	ea071be3          	bnez	a4,9b8 <vprintf+0x120>
      } else if(c0 == 'x'){
 b06:	07800513          	li	a0,120
 b0a:	eca784e3          	beq	a5,a0,9d2 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 b0e:	f8860613          	addi	a2,a2,-120
 b12:	e219                	bnez	a2,b18 <vprintf+0x280>
 b14:	ec069be3          	bnez	a3,9ea <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 b18:	f8858593          	addi	a1,a1,-120
 b1c:	e199                	bnez	a1,b22 <vprintf+0x28a>
 b1e:	ee0713e3          	bnez	a4,a04 <vprintf+0x16c>
      } else if(c0 == 'p'){
 b22:	07000713          	li	a4,112
 b26:	eee78ce3          	beq	a5,a4,a1e <vprintf+0x186>
      } else if(c0 == 'c'){
 b2a:	06300713          	li	a4,99
 b2e:	f2e78ce3          	beq	a5,a4,a66 <vprintf+0x1ce>
      } else if(c0 == 's'){
 b32:	07300713          	li	a4,115
 b36:	f4e782e3          	beq	a5,a4,a7a <vprintf+0x1e2>
      } else if(c0 == '%'){
 b3a:	02500713          	li	a4,37
 b3e:	f6e787e3          	beq	a5,a4,aac <vprintf+0x214>
        putc(fd, '%');
 b42:	02500593          	li	a1,37
 b46:	855a                	mv	a0,s6
 b48:	c95ff0ef          	jal	7dc <putc>
        putc(fd, c0);
 b4c:	85a6                	mv	a1,s1
 b4e:	855a                	mv	a0,s6
 b50:	c8dff0ef          	jal	7dc <putc>
      state = 0;
 b54:	4981                	li	s3,0
 b56:	b359                	j	8dc <vprintf+0x44>

0000000000000b58 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 b58:	715d                	addi	sp,sp,-80
 b5a:	ec06                	sd	ra,24(sp)
 b5c:	e822                	sd	s0,16(sp)
 b5e:	1000                	addi	s0,sp,32
 b60:	e010                	sd	a2,0(s0)
 b62:	e414                	sd	a3,8(s0)
 b64:	e818                	sd	a4,16(s0)
 b66:	ec1c                	sd	a5,24(s0)
 b68:	03043023          	sd	a6,32(s0)
 b6c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 b70:	8622                	mv	a2,s0
 b72:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 b76:	d23ff0ef          	jal	898 <vprintf>
}
 b7a:	60e2                	ld	ra,24(sp)
 b7c:	6442                	ld	s0,16(sp)
 b7e:	6161                	addi	sp,sp,80
 b80:	8082                	ret

0000000000000b82 <printf>:

void
printf(const char *fmt, ...)
{
 b82:	711d                	addi	sp,sp,-96
 b84:	ec06                	sd	ra,24(sp)
 b86:	e822                	sd	s0,16(sp)
 b88:	1000                	addi	s0,sp,32
 b8a:	e40c                	sd	a1,8(s0)
 b8c:	e810                	sd	a2,16(s0)
 b8e:	ec14                	sd	a3,24(s0)
 b90:	f018                	sd	a4,32(s0)
 b92:	f41c                	sd	a5,40(s0)
 b94:	03043823          	sd	a6,48(s0)
 b98:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 b9c:	00840613          	addi	a2,s0,8
 ba0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 ba4:	85aa                	mv	a1,a0
 ba6:	4505                	li	a0,1
 ba8:	cf1ff0ef          	jal	898 <vprintf>
}
 bac:	60e2                	ld	ra,24(sp)
 bae:	6442                	ld	s0,16(sp)
 bb0:	6125                	addi	sp,sp,96
 bb2:	8082                	ret

0000000000000bb4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 bb4:	1141                	addi	sp,sp,-16
 bb6:	e406                	sd	ra,8(sp)
 bb8:	e022                	sd	s0,0(sp)
 bba:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 bbc:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 bc0:	00000797          	auipc	a5,0x0
 bc4:	4487b783          	ld	a5,1096(a5) # 1008 <freep>
 bc8:	a039                	j	bd6 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 bca:	6398                	ld	a4,0(a5)
 bcc:	00e7e463          	bltu	a5,a4,bd4 <free+0x20>
 bd0:	00e6ea63          	bltu	a3,a4,be4 <free+0x30>
{
 bd4:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 bd6:	fed7fae3          	bgeu	a5,a3,bca <free+0x16>
 bda:	6398                	ld	a4,0(a5)
 bdc:	00e6e463          	bltu	a3,a4,be4 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 be0:	fee7eae3          	bltu	a5,a4,bd4 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 be4:	ff852583          	lw	a1,-8(a0)
 be8:	6390                	ld	a2,0(a5)
 bea:	02059813          	slli	a6,a1,0x20
 bee:	01c85713          	srli	a4,a6,0x1c
 bf2:	9736                	add	a4,a4,a3
 bf4:	02e60563          	beq	a2,a4,c1e <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 bf8:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 bfc:	4790                	lw	a2,8(a5)
 bfe:	02061593          	slli	a1,a2,0x20
 c02:	01c5d713          	srli	a4,a1,0x1c
 c06:	973e                	add	a4,a4,a5
 c08:	02e68263          	beq	a3,a4,c2c <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 c0c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 c0e:	00000717          	auipc	a4,0x0
 c12:	3ef73d23          	sd	a5,1018(a4) # 1008 <freep>
}
 c16:	60a2                	ld	ra,8(sp)
 c18:	6402                	ld	s0,0(sp)
 c1a:	0141                	addi	sp,sp,16
 c1c:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 c1e:	4618                	lw	a4,8(a2)
 c20:	9f2d                	addw	a4,a4,a1
 c22:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 c26:	6398                	ld	a4,0(a5)
 c28:	6310                	ld	a2,0(a4)
 c2a:	b7f9                	j	bf8 <free+0x44>
    p->s.size += bp->s.size;
 c2c:	ff852703          	lw	a4,-8(a0)
 c30:	9f31                	addw	a4,a4,a2
 c32:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 c34:	ff053683          	ld	a3,-16(a0)
 c38:	bfd1                	j	c0c <free+0x58>

0000000000000c3a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 c3a:	7139                	addi	sp,sp,-64
 c3c:	fc06                	sd	ra,56(sp)
 c3e:	f822                	sd	s0,48(sp)
 c40:	f04a                	sd	s2,32(sp)
 c42:	ec4e                	sd	s3,24(sp)
 c44:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 c46:	02051993          	slli	s3,a0,0x20
 c4a:	0209d993          	srli	s3,s3,0x20
 c4e:	09bd                	addi	s3,s3,15
 c50:	0049d993          	srli	s3,s3,0x4
 c54:	2985                	addiw	s3,s3,1
 c56:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 c58:	00000517          	auipc	a0,0x0
 c5c:	3b053503          	ld	a0,944(a0) # 1008 <freep>
 c60:	c905                	beqz	a0,c90 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c62:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 c64:	4798                	lw	a4,8(a5)
 c66:	09377663          	bgeu	a4,s3,cf2 <malloc+0xb8>
 c6a:	f426                	sd	s1,40(sp)
 c6c:	e852                	sd	s4,16(sp)
 c6e:	e456                	sd	s5,8(sp)
 c70:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 c72:	8a4e                	mv	s4,s3
 c74:	6705                	lui	a4,0x1
 c76:	00e9f363          	bgeu	s3,a4,c7c <malloc+0x42>
 c7a:	6a05                	lui	s4,0x1
 c7c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 c80:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 c84:	00000497          	auipc	s1,0x0
 c88:	38448493          	addi	s1,s1,900 # 1008 <freep>
  if(p == SBRK_ERROR)
 c8c:	5afd                	li	s5,-1
 c8e:	a83d                	j	ccc <malloc+0x92>
 c90:	f426                	sd	s1,40(sp)
 c92:	e852                	sd	s4,16(sp)
 c94:	e456                	sd	s5,8(sp)
 c96:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 c98:	00000797          	auipc	a5,0x0
 c9c:	37878793          	addi	a5,a5,888 # 1010 <base>
 ca0:	00000717          	auipc	a4,0x0
 ca4:	36f73423          	sd	a5,872(a4) # 1008 <freep>
 ca8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 caa:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 cae:	b7d1                	j	c72 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 cb0:	6398                	ld	a4,0(a5)
 cb2:	e118                	sd	a4,0(a0)
 cb4:	a899                	j	d0a <malloc+0xd0>
  hp->s.size = nu;
 cb6:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 cba:	0541                	addi	a0,a0,16
 cbc:	ef9ff0ef          	jal	bb4 <free>
  return freep;
 cc0:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 cc2:	c125                	beqz	a0,d22 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 cc4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 cc6:	4798                	lw	a4,8(a5)
 cc8:	03277163          	bgeu	a4,s2,cea <malloc+0xb0>
    if(p == freep)
 ccc:	6098                	ld	a4,0(s1)
 cce:	853e                	mv	a0,a5
 cd0:	fef71ae3          	bne	a4,a5,cc4 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 cd4:	8552                	mv	a0,s4
 cd6:	a23ff0ef          	jal	6f8 <sbrk>
  if(p == SBRK_ERROR)
 cda:	fd551ee3          	bne	a0,s5,cb6 <malloc+0x7c>
        return 0;
 cde:	4501                	li	a0,0
 ce0:	74a2                	ld	s1,40(sp)
 ce2:	6a42                	ld	s4,16(sp)
 ce4:	6aa2                	ld	s5,8(sp)
 ce6:	6b02                	ld	s6,0(sp)
 ce8:	a03d                	j	d16 <malloc+0xdc>
 cea:	74a2                	ld	s1,40(sp)
 cec:	6a42                	ld	s4,16(sp)
 cee:	6aa2                	ld	s5,8(sp)
 cf0:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 cf2:	fae90fe3          	beq	s2,a4,cb0 <malloc+0x76>
        p->s.size -= nunits;
 cf6:	4137073b          	subw	a4,a4,s3
 cfa:	c798                	sw	a4,8(a5)
        p += p->s.size;
 cfc:	02071693          	slli	a3,a4,0x20
 d00:	01c6d713          	srli	a4,a3,0x1c
 d04:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 d06:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 d0a:	00000717          	auipc	a4,0x0
 d0e:	2ea73f23          	sd	a0,766(a4) # 1008 <freep>
      return (void*)(p + 1);
 d12:	01078513          	addi	a0,a5,16
  }
}
 d16:	70e2                	ld	ra,56(sp)
 d18:	7442                	ld	s0,48(sp)
 d1a:	7902                	ld	s2,32(sp)
 d1c:	69e2                	ld	s3,24(sp)
 d1e:	6121                	addi	sp,sp,64
 d20:	8082                	ret
 d22:	74a2                	ld	s1,40(sp)
 d24:	6a42                	ld	s4,16(sp)
 d26:	6aa2                	ld	s5,8(sp)
 d28:	6b02                	ld	s6,0(sp)
 d2a:	b7f5                	j	d16 <malloc+0xdc>
