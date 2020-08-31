
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:
ffffffffc0200000:	c02082b7          	lui	t0,0xc0208
ffffffffc0200004:	ffd0031b          	addiw	t1,zero,-3
ffffffffc0200008:	01e31313          	slli	t1,t1,0x1e
ffffffffc020000c:	406282b3          	sub	t0,t0,t1
ffffffffc0200010:	00c2d293          	srli	t0,t0,0xc
ffffffffc0200014:	fff0031b          	addiw	t1,zero,-1
ffffffffc0200018:	03f31313          	slli	t1,t1,0x3f
ffffffffc020001c:	0062e2b3          	or	t0,t0,t1
ffffffffc0200020:	18029073          	csrw	satp,t0
ffffffffc0200024:	12000073          	sfence.vma
ffffffffc0200028:	c0208137          	lui	sp,0xc0208
ffffffffc020002c:	c02002b7          	lui	t0,0xc0200
ffffffffc0200030:	03628293          	addi	t0,t0,54 # ffffffffc0200036 <kern_init>
ffffffffc0200034:	8282                	jr	t0

ffffffffc0200036 <kern_init>:
ffffffffc0200036:	00009517          	auipc	a0,0x9
ffffffffc020003a:	00a50513          	addi	a0,a0,10 # ffffffffc0209040 <edata>
ffffffffc020003e:	00010617          	auipc	a2,0x10
ffffffffc0200042:	54a60613          	addi	a2,a2,1354 # ffffffffc0210588 <end>
ffffffffc0200046:	1141                	addi	sp,sp,-16
ffffffffc0200048:	8e09                	sub	a2,a2,a0
ffffffffc020004a:	4581                	li	a1,0
ffffffffc020004c:	e406                	sd	ra,8(sp)
ffffffffc020004e:	333030ef          	jal	ra,ffffffffc0203b80 <memset>
ffffffffc0200052:	00004597          	auipc	a1,0x4
ffffffffc0200056:	00658593          	addi	a1,a1,6 # ffffffffc0204058 <etext+0x4>
ffffffffc020005a:	00004517          	auipc	a0,0x4
ffffffffc020005e:	01e50513          	addi	a0,a0,30 # ffffffffc0204078 <etext+0x24>
ffffffffc0200062:	05c000ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc0200066:	0fe000ef          	jal	ra,ffffffffc0200164 <print_kerninfo>
ffffffffc020006a:	537020ef          	jal	ra,ffffffffc0202da0 <pmm_init>
ffffffffc020006e:	4fc000ef          	jal	ra,ffffffffc020056a <idt_init>
ffffffffc0200072:	41f000ef          	jal	ra,ffffffffc0200c90 <vmm_init>
ffffffffc0200076:	35a000ef          	jal	ra,ffffffffc02003d0 <ide_init>
ffffffffc020007a:	228010ef          	jal	ra,ffffffffc02012a2 <swap_init>
ffffffffc020007e:	3aa000ef          	jal	ra,ffffffffc0200428 <clock_init>
ffffffffc0200082:	a001                	j	ffffffffc0200082 <kern_init+0x4c>

ffffffffc0200084 <cputch>:
ffffffffc0200084:	1141                	addi	sp,sp,-16
ffffffffc0200086:	e022                	sd	s0,0(sp)
ffffffffc0200088:	e406                	sd	ra,8(sp)
ffffffffc020008a:	842e                	mv	s0,a1
ffffffffc020008c:	3f0000ef          	jal	ra,ffffffffc020047c <cons_putc>
ffffffffc0200090:	401c                	lw	a5,0(s0)
ffffffffc0200092:	60a2                	ld	ra,8(sp)
ffffffffc0200094:	2785                	addiw	a5,a5,1
ffffffffc0200096:	c01c                	sw	a5,0(s0)
ffffffffc0200098:	6402                	ld	s0,0(sp)
ffffffffc020009a:	0141                	addi	sp,sp,16
ffffffffc020009c:	8082                	ret

ffffffffc020009e <vcprintf>:
ffffffffc020009e:	1101                	addi	sp,sp,-32
ffffffffc02000a0:	86ae                	mv	a3,a1
ffffffffc02000a2:	862a                	mv	a2,a0
ffffffffc02000a4:	006c                	addi	a1,sp,12
ffffffffc02000a6:	00000517          	auipc	a0,0x0
ffffffffc02000aa:	fde50513          	addi	a0,a0,-34 # ffffffffc0200084 <cputch>
ffffffffc02000ae:	ec06                	sd	ra,24(sp)
ffffffffc02000b0:	c602                	sw	zero,12(sp)
ffffffffc02000b2:	365030ef          	jal	ra,ffffffffc0203c16 <vprintfmt>
ffffffffc02000b6:	60e2                	ld	ra,24(sp)
ffffffffc02000b8:	4532                	lw	a0,12(sp)
ffffffffc02000ba:	6105                	addi	sp,sp,32
ffffffffc02000bc:	8082                	ret

ffffffffc02000be <cprintf>:
ffffffffc02000be:	711d                	addi	sp,sp,-96
ffffffffc02000c0:	02810313          	addi	t1,sp,40 # ffffffffc0208028 <boot_page_table_sv39+0x28>
ffffffffc02000c4:	f42e                	sd	a1,40(sp)
ffffffffc02000c6:	f832                	sd	a2,48(sp)
ffffffffc02000c8:	fc36                	sd	a3,56(sp)
ffffffffc02000ca:	862a                	mv	a2,a0
ffffffffc02000cc:	004c                	addi	a1,sp,4
ffffffffc02000ce:	00000517          	auipc	a0,0x0
ffffffffc02000d2:	fb650513          	addi	a0,a0,-74 # ffffffffc0200084 <cputch>
ffffffffc02000d6:	869a                	mv	a3,t1
ffffffffc02000d8:	ec06                	sd	ra,24(sp)
ffffffffc02000da:	e0ba                	sd	a4,64(sp)
ffffffffc02000dc:	e4be                	sd	a5,72(sp)
ffffffffc02000de:	e8c2                	sd	a6,80(sp)
ffffffffc02000e0:	ecc6                	sd	a7,88(sp)
ffffffffc02000e2:	e41a                	sd	t1,8(sp)
ffffffffc02000e4:	c202                	sw	zero,4(sp)
ffffffffc02000e6:	331030ef          	jal	ra,ffffffffc0203c16 <vprintfmt>
ffffffffc02000ea:	60e2                	ld	ra,24(sp)
ffffffffc02000ec:	4512                	lw	a0,4(sp)
ffffffffc02000ee:	6125                	addi	sp,sp,96
ffffffffc02000f0:	8082                	ret

ffffffffc02000f2 <cputchar>:
ffffffffc02000f2:	a669                	j	ffffffffc020047c <cons_putc>

ffffffffc02000f4 <getchar>:
ffffffffc02000f4:	1141                	addi	sp,sp,-16
ffffffffc02000f6:	e406                	sd	ra,8(sp)
ffffffffc02000f8:	3b8000ef          	jal	ra,ffffffffc02004b0 <cons_getc>
ffffffffc02000fc:	dd75                	beqz	a0,ffffffffc02000f8 <getchar+0x4>
ffffffffc02000fe:	60a2                	ld	ra,8(sp)
ffffffffc0200100:	0141                	addi	sp,sp,16
ffffffffc0200102:	8082                	ret

ffffffffc0200104 <__panic>:
ffffffffc0200104:	00010317          	auipc	t1,0x10
ffffffffc0200108:	33c30313          	addi	t1,t1,828 # ffffffffc0210440 <is_panic>
ffffffffc020010c:	00032303          	lw	t1,0(t1)
ffffffffc0200110:	715d                	addi	sp,sp,-80
ffffffffc0200112:	ec06                	sd	ra,24(sp)
ffffffffc0200114:	e822                	sd	s0,16(sp)
ffffffffc0200116:	f436                	sd	a3,40(sp)
ffffffffc0200118:	f83a                	sd	a4,48(sp)
ffffffffc020011a:	fc3e                	sd	a5,56(sp)
ffffffffc020011c:	e0c2                	sd	a6,64(sp)
ffffffffc020011e:	e4c6                	sd	a7,72(sp)
ffffffffc0200120:	02031c63          	bnez	t1,ffffffffc0200158 <__panic+0x54>
ffffffffc0200124:	4785                	li	a5,1
ffffffffc0200126:	8432                	mv	s0,a2
ffffffffc0200128:	00010717          	auipc	a4,0x10
ffffffffc020012c:	30f72c23          	sw	a5,792(a4) # ffffffffc0210440 <is_panic>
ffffffffc0200130:	862e                	mv	a2,a1
ffffffffc0200132:	103c                	addi	a5,sp,40
ffffffffc0200134:	85aa                	mv	a1,a0
ffffffffc0200136:	00004517          	auipc	a0,0x4
ffffffffc020013a:	f4a50513          	addi	a0,a0,-182 # ffffffffc0204080 <etext+0x2c>
ffffffffc020013e:	e43e                	sd	a5,8(sp)
ffffffffc0200140:	f7fff0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc0200144:	65a2                	ld	a1,8(sp)
ffffffffc0200146:	8522                	mv	a0,s0
ffffffffc0200148:	f57ff0ef          	jal	ra,ffffffffc020009e <vcprintf>
ffffffffc020014c:	00006517          	auipc	a0,0x6
ffffffffc0200150:	82c50513          	addi	a0,a0,-2004 # ffffffffc0205978 <default_pmm_manager+0x4e8>
ffffffffc0200154:	f6bff0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc0200158:	39a000ef          	jal	ra,ffffffffc02004f2 <intr_disable>
ffffffffc020015c:	4501                	li	a0,0
ffffffffc020015e:	130000ef          	jal	ra,ffffffffc020028e <kmonitor>
ffffffffc0200162:	bfed                	j	ffffffffc020015c <__panic+0x58>

ffffffffc0200164 <print_kerninfo>:
ffffffffc0200164:	1141                	addi	sp,sp,-16
ffffffffc0200166:	00004517          	auipc	a0,0x4
ffffffffc020016a:	f6a50513          	addi	a0,a0,-150 # ffffffffc02040d0 <etext+0x7c>
ffffffffc020016e:	e406                	sd	ra,8(sp)
ffffffffc0200170:	f4fff0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc0200174:	00000597          	auipc	a1,0x0
ffffffffc0200178:	ec258593          	addi	a1,a1,-318 # ffffffffc0200036 <kern_init>
ffffffffc020017c:	00004517          	auipc	a0,0x4
ffffffffc0200180:	f7450513          	addi	a0,a0,-140 # ffffffffc02040f0 <etext+0x9c>
ffffffffc0200184:	f3bff0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc0200188:	00004597          	auipc	a1,0x4
ffffffffc020018c:	ecc58593          	addi	a1,a1,-308 # ffffffffc0204054 <etext>
ffffffffc0200190:	00004517          	auipc	a0,0x4
ffffffffc0200194:	f8050513          	addi	a0,a0,-128 # ffffffffc0204110 <etext+0xbc>
ffffffffc0200198:	f27ff0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc020019c:	00009597          	auipc	a1,0x9
ffffffffc02001a0:	ea458593          	addi	a1,a1,-348 # ffffffffc0209040 <edata>
ffffffffc02001a4:	00004517          	auipc	a0,0x4
ffffffffc02001a8:	f8c50513          	addi	a0,a0,-116 # ffffffffc0204130 <etext+0xdc>
ffffffffc02001ac:	f13ff0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc02001b0:	00010597          	auipc	a1,0x10
ffffffffc02001b4:	3d858593          	addi	a1,a1,984 # ffffffffc0210588 <end>
ffffffffc02001b8:	00004517          	auipc	a0,0x4
ffffffffc02001bc:	f9850513          	addi	a0,a0,-104 # ffffffffc0204150 <etext+0xfc>
ffffffffc02001c0:	effff0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc02001c4:	00010597          	auipc	a1,0x10
ffffffffc02001c8:	7c358593          	addi	a1,a1,1987 # ffffffffc0210987 <end+0x3ff>
ffffffffc02001cc:	00000797          	auipc	a5,0x0
ffffffffc02001d0:	e6a78793          	addi	a5,a5,-406 # ffffffffc0200036 <kern_init>
ffffffffc02001d4:	40f587b3          	sub	a5,a1,a5
ffffffffc02001d8:	43f7d593          	srai	a1,a5,0x3f
ffffffffc02001dc:	60a2                	ld	ra,8(sp)
ffffffffc02001de:	3ff5f593          	andi	a1,a1,1023
ffffffffc02001e2:	95be                	add	a1,a1,a5
ffffffffc02001e4:	85a9                	srai	a1,a1,0xa
ffffffffc02001e6:	00004517          	auipc	a0,0x4
ffffffffc02001ea:	f8a50513          	addi	a0,a0,-118 # ffffffffc0204170 <etext+0x11c>
ffffffffc02001ee:	0141                	addi	sp,sp,16
ffffffffc02001f0:	b5f9                	j	ffffffffc02000be <cprintf>

ffffffffc02001f2 <print_stackframe>:
ffffffffc02001f2:	1141                	addi	sp,sp,-16
ffffffffc02001f4:	00004617          	auipc	a2,0x4
ffffffffc02001f8:	eac60613          	addi	a2,a2,-340 # ffffffffc02040a0 <etext+0x4c>
ffffffffc02001fc:	05b00593          	li	a1,91
ffffffffc0200200:	00004517          	auipc	a0,0x4
ffffffffc0200204:	eb850513          	addi	a0,a0,-328 # ffffffffc02040b8 <etext+0x64>
ffffffffc0200208:	e406                	sd	ra,8(sp)
ffffffffc020020a:	efbff0ef          	jal	ra,ffffffffc0200104 <__panic>

ffffffffc020020e <mon_help>:
ffffffffc020020e:	1141                	addi	sp,sp,-16
ffffffffc0200210:	00004617          	auipc	a2,0x4
ffffffffc0200214:	06860613          	addi	a2,a2,104 # ffffffffc0204278 <commands+0xd8>
ffffffffc0200218:	00004597          	auipc	a1,0x4
ffffffffc020021c:	08058593          	addi	a1,a1,128 # ffffffffc0204298 <commands+0xf8>
ffffffffc0200220:	00004517          	auipc	a0,0x4
ffffffffc0200224:	08050513          	addi	a0,a0,128 # ffffffffc02042a0 <commands+0x100>
ffffffffc0200228:	e406                	sd	ra,8(sp)
ffffffffc020022a:	e95ff0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc020022e:	00004617          	auipc	a2,0x4
ffffffffc0200232:	08260613          	addi	a2,a2,130 # ffffffffc02042b0 <commands+0x110>
ffffffffc0200236:	00004597          	auipc	a1,0x4
ffffffffc020023a:	0a258593          	addi	a1,a1,162 # ffffffffc02042d8 <commands+0x138>
ffffffffc020023e:	00004517          	auipc	a0,0x4
ffffffffc0200242:	06250513          	addi	a0,a0,98 # ffffffffc02042a0 <commands+0x100>
ffffffffc0200246:	e79ff0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc020024a:	00004617          	auipc	a2,0x4
ffffffffc020024e:	09e60613          	addi	a2,a2,158 # ffffffffc02042e8 <commands+0x148>
ffffffffc0200252:	00004597          	auipc	a1,0x4
ffffffffc0200256:	0b658593          	addi	a1,a1,182 # ffffffffc0204308 <commands+0x168>
ffffffffc020025a:	00004517          	auipc	a0,0x4
ffffffffc020025e:	04650513          	addi	a0,a0,70 # ffffffffc02042a0 <commands+0x100>
ffffffffc0200262:	e5dff0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc0200266:	60a2                	ld	ra,8(sp)
ffffffffc0200268:	4501                	li	a0,0
ffffffffc020026a:	0141                	addi	sp,sp,16
ffffffffc020026c:	8082                	ret

ffffffffc020026e <mon_kerninfo>:
ffffffffc020026e:	1141                	addi	sp,sp,-16
ffffffffc0200270:	e406                	sd	ra,8(sp)
ffffffffc0200272:	ef3ff0ef          	jal	ra,ffffffffc0200164 <print_kerninfo>
ffffffffc0200276:	60a2                	ld	ra,8(sp)
ffffffffc0200278:	4501                	li	a0,0
ffffffffc020027a:	0141                	addi	sp,sp,16
ffffffffc020027c:	8082                	ret

ffffffffc020027e <mon_backtrace>:
ffffffffc020027e:	1141                	addi	sp,sp,-16
ffffffffc0200280:	e406                	sd	ra,8(sp)
ffffffffc0200282:	f71ff0ef          	jal	ra,ffffffffc02001f2 <print_stackframe>
ffffffffc0200286:	60a2                	ld	ra,8(sp)
ffffffffc0200288:	4501                	li	a0,0
ffffffffc020028a:	0141                	addi	sp,sp,16
ffffffffc020028c:	8082                	ret

ffffffffc020028e <kmonitor>:
ffffffffc020028e:	7115                	addi	sp,sp,-224
ffffffffc0200290:	e962                	sd	s8,144(sp)
ffffffffc0200292:	8c2a                	mv	s8,a0
ffffffffc0200294:	00004517          	auipc	a0,0x4
ffffffffc0200298:	f5450513          	addi	a0,a0,-172 # ffffffffc02041e8 <commands+0x48>
ffffffffc020029c:	ed86                	sd	ra,216(sp)
ffffffffc020029e:	e9a2                	sd	s0,208(sp)
ffffffffc02002a0:	e5a6                	sd	s1,200(sp)
ffffffffc02002a2:	e1ca                	sd	s2,192(sp)
ffffffffc02002a4:	fd4e                	sd	s3,184(sp)
ffffffffc02002a6:	f952                	sd	s4,176(sp)
ffffffffc02002a8:	f556                	sd	s5,168(sp)
ffffffffc02002aa:	f15a                	sd	s6,160(sp)
ffffffffc02002ac:	ed5e                	sd	s7,152(sp)
ffffffffc02002ae:	e566                	sd	s9,136(sp)
ffffffffc02002b0:	e16a                	sd	s10,128(sp)
ffffffffc02002b2:	e0dff0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc02002b6:	00004517          	auipc	a0,0x4
ffffffffc02002ba:	f5a50513          	addi	a0,a0,-166 # ffffffffc0204210 <commands+0x70>
ffffffffc02002be:	e01ff0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc02002c2:	000c0563          	beqz	s8,ffffffffc02002cc <kmonitor+0x3e>
ffffffffc02002c6:	8562                	mv	a0,s8
ffffffffc02002c8:	48c000ef          	jal	ra,ffffffffc0200754 <print_trapframe>
ffffffffc02002cc:	00004c97          	auipc	s9,0x4
ffffffffc02002d0:	ed4c8c93          	addi	s9,s9,-300 # ffffffffc02041a0 <commands>
ffffffffc02002d4:	00005997          	auipc	s3,0x5
ffffffffc02002d8:	dbc98993          	addi	s3,s3,-580 # ffffffffc0205090 <commands+0xef0>
ffffffffc02002dc:	00004917          	auipc	s2,0x4
ffffffffc02002e0:	f5c90913          	addi	s2,s2,-164 # ffffffffc0204238 <commands+0x98>
ffffffffc02002e4:	4a3d                	li	s4,15
ffffffffc02002e6:	00004b17          	auipc	s6,0x4
ffffffffc02002ea:	f5ab0b13          	addi	s6,s6,-166 # ffffffffc0204240 <commands+0xa0>
ffffffffc02002ee:	00004a97          	auipc	s5,0x4
ffffffffc02002f2:	faaa8a93          	addi	s5,s5,-86 # ffffffffc0204298 <commands+0xf8>
ffffffffc02002f6:	4b8d                	li	s7,3
ffffffffc02002f8:	854e                	mv	a0,s3
ffffffffc02002fa:	49d030ef          	jal	ra,ffffffffc0203f96 <readline>
ffffffffc02002fe:	842a                	mv	s0,a0
ffffffffc0200300:	dd65                	beqz	a0,ffffffffc02002f8 <kmonitor+0x6a>
ffffffffc0200302:	00054583          	lbu	a1,0(a0)
ffffffffc0200306:	4481                	li	s1,0
ffffffffc0200308:	c999                	beqz	a1,ffffffffc020031e <kmonitor+0x90>
ffffffffc020030a:	854a                	mv	a0,s2
ffffffffc020030c:	057030ef          	jal	ra,ffffffffc0203b62 <strchr>
ffffffffc0200310:	c925                	beqz	a0,ffffffffc0200380 <kmonitor+0xf2>
ffffffffc0200312:	00144583          	lbu	a1,1(s0)
ffffffffc0200316:	00040023          	sb	zero,0(s0)
ffffffffc020031a:	0405                	addi	s0,s0,1
ffffffffc020031c:	f5fd                	bnez	a1,ffffffffc020030a <kmonitor+0x7c>
ffffffffc020031e:	dce9                	beqz	s1,ffffffffc02002f8 <kmonitor+0x6a>
ffffffffc0200320:	6582                	ld	a1,0(sp)
ffffffffc0200322:	00004d17          	auipc	s10,0x4
ffffffffc0200326:	e7ed0d13          	addi	s10,s10,-386 # ffffffffc02041a0 <commands>
ffffffffc020032a:	8556                	mv	a0,s5
ffffffffc020032c:	4401                	li	s0,0
ffffffffc020032e:	0d61                	addi	s10,s10,24
ffffffffc0200330:	009030ef          	jal	ra,ffffffffc0203b38 <strcmp>
ffffffffc0200334:	c919                	beqz	a0,ffffffffc020034a <kmonitor+0xbc>
ffffffffc0200336:	2405                	addiw	s0,s0,1
ffffffffc0200338:	09740463          	beq	s0,s7,ffffffffc02003c0 <kmonitor+0x132>
ffffffffc020033c:	000d3503          	ld	a0,0(s10)
ffffffffc0200340:	6582                	ld	a1,0(sp)
ffffffffc0200342:	0d61                	addi	s10,s10,24
ffffffffc0200344:	7f4030ef          	jal	ra,ffffffffc0203b38 <strcmp>
ffffffffc0200348:	f57d                	bnez	a0,ffffffffc0200336 <kmonitor+0xa8>
ffffffffc020034a:	00141793          	slli	a5,s0,0x1
ffffffffc020034e:	97a2                	add	a5,a5,s0
ffffffffc0200350:	078e                	slli	a5,a5,0x3
ffffffffc0200352:	97e6                	add	a5,a5,s9
ffffffffc0200354:	6b9c                	ld	a5,16(a5)
ffffffffc0200356:	8662                	mv	a2,s8
ffffffffc0200358:	002c                	addi	a1,sp,8
ffffffffc020035a:	fff4851b          	addiw	a0,s1,-1
ffffffffc020035e:	9782                	jalr	a5
ffffffffc0200360:	f8055ce3          	bgez	a0,ffffffffc02002f8 <kmonitor+0x6a>
ffffffffc0200364:	60ee                	ld	ra,216(sp)
ffffffffc0200366:	644e                	ld	s0,208(sp)
ffffffffc0200368:	64ae                	ld	s1,200(sp)
ffffffffc020036a:	690e                	ld	s2,192(sp)
ffffffffc020036c:	79ea                	ld	s3,184(sp)
ffffffffc020036e:	7a4a                	ld	s4,176(sp)
ffffffffc0200370:	7aaa                	ld	s5,168(sp)
ffffffffc0200372:	7b0a                	ld	s6,160(sp)
ffffffffc0200374:	6bea                	ld	s7,152(sp)
ffffffffc0200376:	6c4a                	ld	s8,144(sp)
ffffffffc0200378:	6caa                	ld	s9,136(sp)
ffffffffc020037a:	6d0a                	ld	s10,128(sp)
ffffffffc020037c:	612d                	addi	sp,sp,224
ffffffffc020037e:	8082                	ret
ffffffffc0200380:	00044783          	lbu	a5,0(s0)
ffffffffc0200384:	dfc9                	beqz	a5,ffffffffc020031e <kmonitor+0x90>
ffffffffc0200386:	03448863          	beq	s1,s4,ffffffffc02003b6 <kmonitor+0x128>
ffffffffc020038a:	00349793          	slli	a5,s1,0x3
ffffffffc020038e:	0118                	addi	a4,sp,128
ffffffffc0200390:	97ba                	add	a5,a5,a4
ffffffffc0200392:	f887b023          	sd	s0,-128(a5)
ffffffffc0200396:	00044583          	lbu	a1,0(s0)
ffffffffc020039a:	2485                	addiw	s1,s1,1
ffffffffc020039c:	e591                	bnez	a1,ffffffffc02003a8 <kmonitor+0x11a>
ffffffffc020039e:	b749                	j	ffffffffc0200320 <kmonitor+0x92>
ffffffffc02003a0:	0405                	addi	s0,s0,1
ffffffffc02003a2:	00044583          	lbu	a1,0(s0)
ffffffffc02003a6:	ddad                	beqz	a1,ffffffffc0200320 <kmonitor+0x92>
ffffffffc02003a8:	854a                	mv	a0,s2
ffffffffc02003aa:	7b8030ef          	jal	ra,ffffffffc0203b62 <strchr>
ffffffffc02003ae:	d96d                	beqz	a0,ffffffffc02003a0 <kmonitor+0x112>
ffffffffc02003b0:	00044583          	lbu	a1,0(s0)
ffffffffc02003b4:	bf91                	j	ffffffffc0200308 <kmonitor+0x7a>
ffffffffc02003b6:	45c1                	li	a1,16
ffffffffc02003b8:	855a                	mv	a0,s6
ffffffffc02003ba:	d05ff0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc02003be:	b7f1                	j	ffffffffc020038a <kmonitor+0xfc>
ffffffffc02003c0:	6582                	ld	a1,0(sp)
ffffffffc02003c2:	00004517          	auipc	a0,0x4
ffffffffc02003c6:	e9e50513          	addi	a0,a0,-354 # ffffffffc0204260 <commands+0xc0>
ffffffffc02003ca:	cf5ff0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc02003ce:	b72d                	j	ffffffffc02002f8 <kmonitor+0x6a>

ffffffffc02003d0 <ide_init>:
ffffffffc02003d0:	8082                	ret

ffffffffc02003d2 <ide_device_valid>:
ffffffffc02003d2:	00253513          	sltiu	a0,a0,2
ffffffffc02003d6:	8082                	ret

ffffffffc02003d8 <ide_device_size>:
ffffffffc02003d8:	03800513          	li	a0,56
ffffffffc02003dc:	8082                	ret

ffffffffc02003de <ide_read_secs>:
ffffffffc02003de:	00009797          	auipc	a5,0x9
ffffffffc02003e2:	c6278793          	addi	a5,a5,-926 # ffffffffc0209040 <edata>
ffffffffc02003e6:	0095959b          	slliw	a1,a1,0x9
ffffffffc02003ea:	1141                	addi	sp,sp,-16
ffffffffc02003ec:	8532                	mv	a0,a2
ffffffffc02003ee:	95be                	add	a1,a1,a5
ffffffffc02003f0:	00969613          	slli	a2,a3,0x9
ffffffffc02003f4:	e406                	sd	ra,8(sp)
ffffffffc02003f6:	79c030ef          	jal	ra,ffffffffc0203b92 <memcpy>
ffffffffc02003fa:	60a2                	ld	ra,8(sp)
ffffffffc02003fc:	4501                	li	a0,0
ffffffffc02003fe:	0141                	addi	sp,sp,16
ffffffffc0200400:	8082                	ret

ffffffffc0200402 <ide_write_secs>:
ffffffffc0200402:	8732                	mv	a4,a2
ffffffffc0200404:	0095979b          	slliw	a5,a1,0x9
ffffffffc0200408:	00009517          	auipc	a0,0x9
ffffffffc020040c:	c3850513          	addi	a0,a0,-968 # ffffffffc0209040 <edata>
ffffffffc0200410:	1141                	addi	sp,sp,-16
ffffffffc0200412:	00969613          	slli	a2,a3,0x9
ffffffffc0200416:	85ba                	mv	a1,a4
ffffffffc0200418:	953e                	add	a0,a0,a5
ffffffffc020041a:	e406                	sd	ra,8(sp)
ffffffffc020041c:	776030ef          	jal	ra,ffffffffc0203b92 <memcpy>
ffffffffc0200420:	60a2                	ld	ra,8(sp)
ffffffffc0200422:	4501                	li	a0,0
ffffffffc0200424:	0141                	addi	sp,sp,16
ffffffffc0200426:	8082                	ret

ffffffffc0200428 <clock_init>:
ffffffffc0200428:	67e1                	lui	a5,0x18
ffffffffc020042a:	6a078793          	addi	a5,a5,1696 # 186a0 <BASE_ADDRESS-0xffffffffc01e7960>
ffffffffc020042e:	00010717          	auipc	a4,0x10
ffffffffc0200432:	00f73d23          	sd	a5,26(a4) # ffffffffc0210448 <timebase>
ffffffffc0200436:	c0102573          	rdtime	a0
ffffffffc020043a:	4581                	li	a1,0
ffffffffc020043c:	953e                	add	a0,a0,a5
ffffffffc020043e:	4601                	li	a2,0
ffffffffc0200440:	4881                	li	a7,0
ffffffffc0200442:	00000073          	ecall
ffffffffc0200446:	02000793          	li	a5,32
ffffffffc020044a:	1047a7f3          	csrrs	a5,sie,a5
ffffffffc020044e:	00004517          	auipc	a0,0x4
ffffffffc0200452:	eca50513          	addi	a0,a0,-310 # ffffffffc0204318 <commands+0x178>
ffffffffc0200456:	00010797          	auipc	a5,0x10
ffffffffc020045a:	0207b123          	sd	zero,34(a5) # ffffffffc0210478 <ticks>
ffffffffc020045e:	b185                	j	ffffffffc02000be <cprintf>

ffffffffc0200460 <clock_set_next_event>:
ffffffffc0200460:	c0102573          	rdtime	a0
ffffffffc0200464:	00010797          	auipc	a5,0x10
ffffffffc0200468:	fe478793          	addi	a5,a5,-28 # ffffffffc0210448 <timebase>
ffffffffc020046c:	639c                	ld	a5,0(a5)
ffffffffc020046e:	4581                	li	a1,0
ffffffffc0200470:	4601                	li	a2,0
ffffffffc0200472:	953e                	add	a0,a0,a5
ffffffffc0200474:	4881                	li	a7,0
ffffffffc0200476:	00000073          	ecall
ffffffffc020047a:	8082                	ret

ffffffffc020047c <cons_putc>:
ffffffffc020047c:	100027f3          	csrr	a5,sstatus
ffffffffc0200480:	8b89                	andi	a5,a5,2
ffffffffc0200482:	0ff57513          	andi	a0,a0,255
ffffffffc0200486:	e799                	bnez	a5,ffffffffc0200494 <cons_putc+0x18>
ffffffffc0200488:	4581                	li	a1,0
ffffffffc020048a:	4601                	li	a2,0
ffffffffc020048c:	4885                	li	a7,1
ffffffffc020048e:	00000073          	ecall
ffffffffc0200492:	8082                	ret
ffffffffc0200494:	1101                	addi	sp,sp,-32
ffffffffc0200496:	ec06                	sd	ra,24(sp)
ffffffffc0200498:	e42a                	sd	a0,8(sp)
ffffffffc020049a:	058000ef          	jal	ra,ffffffffc02004f2 <intr_disable>
ffffffffc020049e:	6522                	ld	a0,8(sp)
ffffffffc02004a0:	4581                	li	a1,0
ffffffffc02004a2:	4601                	li	a2,0
ffffffffc02004a4:	4885                	li	a7,1
ffffffffc02004a6:	00000073          	ecall
ffffffffc02004aa:	60e2                	ld	ra,24(sp)
ffffffffc02004ac:	6105                	addi	sp,sp,32
ffffffffc02004ae:	a83d                	j	ffffffffc02004ec <intr_enable>

ffffffffc02004b0 <cons_getc>:
ffffffffc02004b0:	100027f3          	csrr	a5,sstatus
ffffffffc02004b4:	8b89                	andi	a5,a5,2
ffffffffc02004b6:	eb89                	bnez	a5,ffffffffc02004c8 <cons_getc+0x18>
ffffffffc02004b8:	4501                	li	a0,0
ffffffffc02004ba:	4581                	li	a1,0
ffffffffc02004bc:	4601                	li	a2,0
ffffffffc02004be:	4889                	li	a7,2
ffffffffc02004c0:	00000073          	ecall
ffffffffc02004c4:	2501                	sext.w	a0,a0
ffffffffc02004c6:	8082                	ret
ffffffffc02004c8:	1101                	addi	sp,sp,-32
ffffffffc02004ca:	ec06                	sd	ra,24(sp)
ffffffffc02004cc:	026000ef          	jal	ra,ffffffffc02004f2 <intr_disable>
ffffffffc02004d0:	4501                	li	a0,0
ffffffffc02004d2:	4581                	li	a1,0
ffffffffc02004d4:	4601                	li	a2,0
ffffffffc02004d6:	4889                	li	a7,2
ffffffffc02004d8:	00000073          	ecall
ffffffffc02004dc:	2501                	sext.w	a0,a0
ffffffffc02004de:	e42a                	sd	a0,8(sp)
ffffffffc02004e0:	00c000ef          	jal	ra,ffffffffc02004ec <intr_enable>
ffffffffc02004e4:	60e2                	ld	ra,24(sp)
ffffffffc02004e6:	6522                	ld	a0,8(sp)
ffffffffc02004e8:	6105                	addi	sp,sp,32
ffffffffc02004ea:	8082                	ret

ffffffffc02004ec <intr_enable>:
ffffffffc02004ec:	100167f3          	csrrsi	a5,sstatus,2
ffffffffc02004f0:	8082                	ret

ffffffffc02004f2 <intr_disable>:
ffffffffc02004f2:	100177f3          	csrrci	a5,sstatus,2
ffffffffc02004f6:	8082                	ret

ffffffffc02004f8 <pgfault_handler>:
ffffffffc02004f8:	10053783          	ld	a5,256(a0)
ffffffffc02004fc:	1141                	addi	sp,sp,-16
ffffffffc02004fe:	e022                	sd	s0,0(sp)
ffffffffc0200500:	e406                	sd	ra,8(sp)
ffffffffc0200502:	1007f793          	andi	a5,a5,256
ffffffffc0200506:	842a                	mv	s0,a0
ffffffffc0200508:	11053583          	ld	a1,272(a0)
ffffffffc020050c:	05500613          	li	a2,85
ffffffffc0200510:	c399                	beqz	a5,ffffffffc0200516 <pgfault_handler+0x1e>
ffffffffc0200512:	04b00613          	li	a2,75
ffffffffc0200516:	11843703          	ld	a4,280(s0)
ffffffffc020051a:	47bd                	li	a5,15
ffffffffc020051c:	05700693          	li	a3,87
ffffffffc0200520:	00f70463          	beq	a4,a5,ffffffffc0200528 <pgfault_handler+0x30>
ffffffffc0200524:	05200693          	li	a3,82
ffffffffc0200528:	00004517          	auipc	a0,0x4
ffffffffc020052c:	0e850513          	addi	a0,a0,232 # ffffffffc0204610 <commands+0x470>
ffffffffc0200530:	b8fff0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc0200534:	00010797          	auipc	a5,0x10
ffffffffc0200538:	f4c78793          	addi	a5,a5,-180 # ffffffffc0210480 <check_mm_struct>
ffffffffc020053c:	6388                	ld	a0,0(a5)
ffffffffc020053e:	c911                	beqz	a0,ffffffffc0200552 <pgfault_handler+0x5a>
ffffffffc0200540:	11043603          	ld	a2,272(s0)
ffffffffc0200544:	11843583          	ld	a1,280(s0)
ffffffffc0200548:	6402                	ld	s0,0(sp)
ffffffffc020054a:	60a2                	ld	ra,8(sp)
ffffffffc020054c:	0141                	addi	sp,sp,16
ffffffffc020054e:	4810006f          	j	ffffffffc02011ce <do_pgfault>
ffffffffc0200552:	00004617          	auipc	a2,0x4
ffffffffc0200556:	0de60613          	addi	a2,a2,222 # ffffffffc0204630 <commands+0x490>
ffffffffc020055a:	07700593          	li	a1,119
ffffffffc020055e:	00004517          	auipc	a0,0x4
ffffffffc0200562:	0ea50513          	addi	a0,a0,234 # ffffffffc0204648 <commands+0x4a8>
ffffffffc0200566:	b9fff0ef          	jal	ra,ffffffffc0200104 <__panic>

ffffffffc020056a <idt_init>:
ffffffffc020056a:	14005073          	csrwi	sscratch,0
ffffffffc020056e:	00000797          	auipc	a5,0x0
ffffffffc0200572:	48278793          	addi	a5,a5,1154 # ffffffffc02009f0 <__alltraps>
ffffffffc0200576:	10579073          	csrw	stvec,a5
ffffffffc020057a:	100167f3          	csrrsi	a5,sstatus,2
ffffffffc020057e:	000407b7          	lui	a5,0x40
ffffffffc0200582:	1007a7f3          	csrrs	a5,sstatus,a5
ffffffffc0200586:	8082                	ret

ffffffffc0200588 <print_regs>:
ffffffffc0200588:	610c                	ld	a1,0(a0)
ffffffffc020058a:	1141                	addi	sp,sp,-16
ffffffffc020058c:	e022                	sd	s0,0(sp)
ffffffffc020058e:	842a                	mv	s0,a0
ffffffffc0200590:	00004517          	auipc	a0,0x4
ffffffffc0200594:	0d050513          	addi	a0,a0,208 # ffffffffc0204660 <commands+0x4c0>
ffffffffc0200598:	e406                	sd	ra,8(sp)
ffffffffc020059a:	b25ff0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc020059e:	640c                	ld	a1,8(s0)
ffffffffc02005a0:	00004517          	auipc	a0,0x4
ffffffffc02005a4:	0d850513          	addi	a0,a0,216 # ffffffffc0204678 <commands+0x4d8>
ffffffffc02005a8:	b17ff0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc02005ac:	680c                	ld	a1,16(s0)
ffffffffc02005ae:	00004517          	auipc	a0,0x4
ffffffffc02005b2:	0e250513          	addi	a0,a0,226 # ffffffffc0204690 <commands+0x4f0>
ffffffffc02005b6:	b09ff0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc02005ba:	6c0c                	ld	a1,24(s0)
ffffffffc02005bc:	00004517          	auipc	a0,0x4
ffffffffc02005c0:	0ec50513          	addi	a0,a0,236 # ffffffffc02046a8 <commands+0x508>
ffffffffc02005c4:	afbff0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc02005c8:	700c                	ld	a1,32(s0)
ffffffffc02005ca:	00004517          	auipc	a0,0x4
ffffffffc02005ce:	0f650513          	addi	a0,a0,246 # ffffffffc02046c0 <commands+0x520>
ffffffffc02005d2:	aedff0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc02005d6:	740c                	ld	a1,40(s0)
ffffffffc02005d8:	00004517          	auipc	a0,0x4
ffffffffc02005dc:	10050513          	addi	a0,a0,256 # ffffffffc02046d8 <commands+0x538>
ffffffffc02005e0:	adfff0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc02005e4:	780c                	ld	a1,48(s0)
ffffffffc02005e6:	00004517          	auipc	a0,0x4
ffffffffc02005ea:	10a50513          	addi	a0,a0,266 # ffffffffc02046f0 <commands+0x550>
ffffffffc02005ee:	ad1ff0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc02005f2:	7c0c                	ld	a1,56(s0)
ffffffffc02005f4:	00004517          	auipc	a0,0x4
ffffffffc02005f8:	11450513          	addi	a0,a0,276 # ffffffffc0204708 <commands+0x568>
ffffffffc02005fc:	ac3ff0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc0200600:	602c                	ld	a1,64(s0)
ffffffffc0200602:	00004517          	auipc	a0,0x4
ffffffffc0200606:	11e50513          	addi	a0,a0,286 # ffffffffc0204720 <commands+0x580>
ffffffffc020060a:	ab5ff0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc020060e:	642c                	ld	a1,72(s0)
ffffffffc0200610:	00004517          	auipc	a0,0x4
ffffffffc0200614:	12850513          	addi	a0,a0,296 # ffffffffc0204738 <commands+0x598>
ffffffffc0200618:	aa7ff0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc020061c:	682c                	ld	a1,80(s0)
ffffffffc020061e:	00004517          	auipc	a0,0x4
ffffffffc0200622:	13250513          	addi	a0,a0,306 # ffffffffc0204750 <commands+0x5b0>
ffffffffc0200626:	a99ff0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc020062a:	6c2c                	ld	a1,88(s0)
ffffffffc020062c:	00004517          	auipc	a0,0x4
ffffffffc0200630:	13c50513          	addi	a0,a0,316 # ffffffffc0204768 <commands+0x5c8>
ffffffffc0200634:	a8bff0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc0200638:	702c                	ld	a1,96(s0)
ffffffffc020063a:	00004517          	auipc	a0,0x4
ffffffffc020063e:	14650513          	addi	a0,a0,326 # ffffffffc0204780 <commands+0x5e0>
ffffffffc0200642:	a7dff0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc0200646:	742c                	ld	a1,104(s0)
ffffffffc0200648:	00004517          	auipc	a0,0x4
ffffffffc020064c:	15050513          	addi	a0,a0,336 # ffffffffc0204798 <commands+0x5f8>
ffffffffc0200650:	a6fff0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc0200654:	782c                	ld	a1,112(s0)
ffffffffc0200656:	00004517          	auipc	a0,0x4
ffffffffc020065a:	15a50513          	addi	a0,a0,346 # ffffffffc02047b0 <commands+0x610>
ffffffffc020065e:	a61ff0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc0200662:	7c2c                	ld	a1,120(s0)
ffffffffc0200664:	00004517          	auipc	a0,0x4
ffffffffc0200668:	16450513          	addi	a0,a0,356 # ffffffffc02047c8 <commands+0x628>
ffffffffc020066c:	a53ff0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc0200670:	604c                	ld	a1,128(s0)
ffffffffc0200672:	00004517          	auipc	a0,0x4
ffffffffc0200676:	16e50513          	addi	a0,a0,366 # ffffffffc02047e0 <commands+0x640>
ffffffffc020067a:	a45ff0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc020067e:	644c                	ld	a1,136(s0)
ffffffffc0200680:	00004517          	auipc	a0,0x4
ffffffffc0200684:	17850513          	addi	a0,a0,376 # ffffffffc02047f8 <commands+0x658>
ffffffffc0200688:	a37ff0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc020068c:	684c                	ld	a1,144(s0)
ffffffffc020068e:	00004517          	auipc	a0,0x4
ffffffffc0200692:	18250513          	addi	a0,a0,386 # ffffffffc0204810 <commands+0x670>
ffffffffc0200696:	a29ff0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc020069a:	6c4c                	ld	a1,152(s0)
ffffffffc020069c:	00004517          	auipc	a0,0x4
ffffffffc02006a0:	18c50513          	addi	a0,a0,396 # ffffffffc0204828 <commands+0x688>
ffffffffc02006a4:	a1bff0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc02006a8:	704c                	ld	a1,160(s0)
ffffffffc02006aa:	00004517          	auipc	a0,0x4
ffffffffc02006ae:	19650513          	addi	a0,a0,406 # ffffffffc0204840 <commands+0x6a0>
ffffffffc02006b2:	a0dff0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc02006b6:	744c                	ld	a1,168(s0)
ffffffffc02006b8:	00004517          	auipc	a0,0x4
ffffffffc02006bc:	1a050513          	addi	a0,a0,416 # ffffffffc0204858 <commands+0x6b8>
ffffffffc02006c0:	9ffff0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc02006c4:	784c                	ld	a1,176(s0)
ffffffffc02006c6:	00004517          	auipc	a0,0x4
ffffffffc02006ca:	1aa50513          	addi	a0,a0,426 # ffffffffc0204870 <commands+0x6d0>
ffffffffc02006ce:	9f1ff0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc02006d2:	7c4c                	ld	a1,184(s0)
ffffffffc02006d4:	00004517          	auipc	a0,0x4
ffffffffc02006d8:	1b450513          	addi	a0,a0,436 # ffffffffc0204888 <commands+0x6e8>
ffffffffc02006dc:	9e3ff0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc02006e0:	606c                	ld	a1,192(s0)
ffffffffc02006e2:	00004517          	auipc	a0,0x4
ffffffffc02006e6:	1be50513          	addi	a0,a0,446 # ffffffffc02048a0 <commands+0x700>
ffffffffc02006ea:	9d5ff0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc02006ee:	646c                	ld	a1,200(s0)
ffffffffc02006f0:	00004517          	auipc	a0,0x4
ffffffffc02006f4:	1c850513          	addi	a0,a0,456 # ffffffffc02048b8 <commands+0x718>
ffffffffc02006f8:	9c7ff0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc02006fc:	686c                	ld	a1,208(s0)
ffffffffc02006fe:	00004517          	auipc	a0,0x4
ffffffffc0200702:	1d250513          	addi	a0,a0,466 # ffffffffc02048d0 <commands+0x730>
ffffffffc0200706:	9b9ff0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc020070a:	6c6c                	ld	a1,216(s0)
ffffffffc020070c:	00004517          	auipc	a0,0x4
ffffffffc0200710:	1dc50513          	addi	a0,a0,476 # ffffffffc02048e8 <commands+0x748>
ffffffffc0200714:	9abff0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc0200718:	706c                	ld	a1,224(s0)
ffffffffc020071a:	00004517          	auipc	a0,0x4
ffffffffc020071e:	1e650513          	addi	a0,a0,486 # ffffffffc0204900 <commands+0x760>
ffffffffc0200722:	99dff0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc0200726:	746c                	ld	a1,232(s0)
ffffffffc0200728:	00004517          	auipc	a0,0x4
ffffffffc020072c:	1f050513          	addi	a0,a0,496 # ffffffffc0204918 <commands+0x778>
ffffffffc0200730:	98fff0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc0200734:	786c                	ld	a1,240(s0)
ffffffffc0200736:	00004517          	auipc	a0,0x4
ffffffffc020073a:	1fa50513          	addi	a0,a0,506 # ffffffffc0204930 <commands+0x790>
ffffffffc020073e:	981ff0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc0200742:	7c6c                	ld	a1,248(s0)
ffffffffc0200744:	6402                	ld	s0,0(sp)
ffffffffc0200746:	60a2                	ld	ra,8(sp)
ffffffffc0200748:	00004517          	auipc	a0,0x4
ffffffffc020074c:	20050513          	addi	a0,a0,512 # ffffffffc0204948 <commands+0x7a8>
ffffffffc0200750:	0141                	addi	sp,sp,16
ffffffffc0200752:	b2b5                	j	ffffffffc02000be <cprintf>

ffffffffc0200754 <print_trapframe>:
ffffffffc0200754:	1141                	addi	sp,sp,-16
ffffffffc0200756:	e022                	sd	s0,0(sp)
ffffffffc0200758:	85aa                	mv	a1,a0
ffffffffc020075a:	842a                	mv	s0,a0
ffffffffc020075c:	00004517          	auipc	a0,0x4
ffffffffc0200760:	20450513          	addi	a0,a0,516 # ffffffffc0204960 <commands+0x7c0>
ffffffffc0200764:	e406                	sd	ra,8(sp)
ffffffffc0200766:	959ff0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc020076a:	8522                	mv	a0,s0
ffffffffc020076c:	e1dff0ef          	jal	ra,ffffffffc0200588 <print_regs>
ffffffffc0200770:	10043583          	ld	a1,256(s0)
ffffffffc0200774:	00004517          	auipc	a0,0x4
ffffffffc0200778:	20450513          	addi	a0,a0,516 # ffffffffc0204978 <commands+0x7d8>
ffffffffc020077c:	943ff0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc0200780:	10843583          	ld	a1,264(s0)
ffffffffc0200784:	00004517          	auipc	a0,0x4
ffffffffc0200788:	20c50513          	addi	a0,a0,524 # ffffffffc0204990 <commands+0x7f0>
ffffffffc020078c:	933ff0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc0200790:	11043583          	ld	a1,272(s0)
ffffffffc0200794:	00004517          	auipc	a0,0x4
ffffffffc0200798:	21450513          	addi	a0,a0,532 # ffffffffc02049a8 <commands+0x808>
ffffffffc020079c:	923ff0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc02007a0:	11843583          	ld	a1,280(s0)
ffffffffc02007a4:	6402                	ld	s0,0(sp)
ffffffffc02007a6:	60a2                	ld	ra,8(sp)
ffffffffc02007a8:	00004517          	auipc	a0,0x4
ffffffffc02007ac:	21850513          	addi	a0,a0,536 # ffffffffc02049c0 <commands+0x820>
ffffffffc02007b0:	0141                	addi	sp,sp,16
ffffffffc02007b2:	90dff06f          	j	ffffffffc02000be <cprintf>

ffffffffc02007b6 <interrupt_handler>:
ffffffffc02007b6:	11853783          	ld	a5,280(a0)
ffffffffc02007ba:	472d                	li	a4,11
ffffffffc02007bc:	0786                	slli	a5,a5,0x1
ffffffffc02007be:	8385                	srli	a5,a5,0x1
ffffffffc02007c0:	06f76f63          	bltu	a4,a5,ffffffffc020083e <interrupt_handler+0x88>
ffffffffc02007c4:	00004717          	auipc	a4,0x4
ffffffffc02007c8:	b7070713          	addi	a4,a4,-1168 # ffffffffc0204334 <commands+0x194>
ffffffffc02007cc:	078a                	slli	a5,a5,0x2
ffffffffc02007ce:	97ba                	add	a5,a5,a4
ffffffffc02007d0:	439c                	lw	a5,0(a5)
ffffffffc02007d2:	97ba                	add	a5,a5,a4
ffffffffc02007d4:	8782                	jr	a5
ffffffffc02007d6:	00004517          	auipc	a0,0x4
ffffffffc02007da:	dea50513          	addi	a0,a0,-534 # ffffffffc02045c0 <commands+0x420>
ffffffffc02007de:	8e1ff06f          	j	ffffffffc02000be <cprintf>
ffffffffc02007e2:	00004517          	auipc	a0,0x4
ffffffffc02007e6:	dbe50513          	addi	a0,a0,-578 # ffffffffc02045a0 <commands+0x400>
ffffffffc02007ea:	8d5ff06f          	j	ffffffffc02000be <cprintf>
ffffffffc02007ee:	00004517          	auipc	a0,0x4
ffffffffc02007f2:	d7250513          	addi	a0,a0,-654 # ffffffffc0204560 <commands+0x3c0>
ffffffffc02007f6:	8c9ff06f          	j	ffffffffc02000be <cprintf>
ffffffffc02007fa:	00004517          	auipc	a0,0x4
ffffffffc02007fe:	d8650513          	addi	a0,a0,-634 # ffffffffc0204580 <commands+0x3e0>
ffffffffc0200802:	8bdff06f          	j	ffffffffc02000be <cprintf>
ffffffffc0200806:	00004517          	auipc	a0,0x4
ffffffffc020080a:	dea50513          	addi	a0,a0,-534 # ffffffffc02045f0 <commands+0x450>
ffffffffc020080e:	8b1ff06f          	j	ffffffffc02000be <cprintf>
ffffffffc0200812:	1141                	addi	sp,sp,-16
ffffffffc0200814:	e406                	sd	ra,8(sp)
ffffffffc0200816:	c4bff0ef          	jal	ra,ffffffffc0200460 <clock_set_next_event>
ffffffffc020081a:	00010797          	auipc	a5,0x10
ffffffffc020081e:	c5e78793          	addi	a5,a5,-930 # ffffffffc0210478 <ticks>
ffffffffc0200822:	639c                	ld	a5,0(a5)
ffffffffc0200824:	06400713          	li	a4,100
ffffffffc0200828:	0785                	addi	a5,a5,1
ffffffffc020082a:	02e7f733          	remu	a4,a5,a4
ffffffffc020082e:	00010697          	auipc	a3,0x10
ffffffffc0200832:	c4f6b523          	sd	a5,-950(a3) # ffffffffc0210478 <ticks>
ffffffffc0200836:	c709                	beqz	a4,ffffffffc0200840 <interrupt_handler+0x8a>
ffffffffc0200838:	60a2                	ld	ra,8(sp)
ffffffffc020083a:	0141                	addi	sp,sp,16
ffffffffc020083c:	8082                	ret
ffffffffc020083e:	bf19                	j	ffffffffc0200754 <print_trapframe>
ffffffffc0200840:	60a2                	ld	ra,8(sp)
ffffffffc0200842:	06400593          	li	a1,100
ffffffffc0200846:	00004517          	auipc	a0,0x4
ffffffffc020084a:	d9a50513          	addi	a0,a0,-614 # ffffffffc02045e0 <commands+0x440>
ffffffffc020084e:	0141                	addi	sp,sp,16
ffffffffc0200850:	86fff06f          	j	ffffffffc02000be <cprintf>

ffffffffc0200854 <exception_handler>:
ffffffffc0200854:	11853783          	ld	a5,280(a0)
ffffffffc0200858:	473d                	li	a4,15
ffffffffc020085a:	16f76463          	bltu	a4,a5,ffffffffc02009c2 <exception_handler+0x16e>
ffffffffc020085e:	00004717          	auipc	a4,0x4
ffffffffc0200862:	b0670713          	addi	a4,a4,-1274 # ffffffffc0204364 <commands+0x1c4>
ffffffffc0200866:	078a                	slli	a5,a5,0x2
ffffffffc0200868:	97ba                	add	a5,a5,a4
ffffffffc020086a:	439c                	lw	a5,0(a5)
ffffffffc020086c:	1101                	addi	sp,sp,-32
ffffffffc020086e:	e822                	sd	s0,16(sp)
ffffffffc0200870:	ec06                	sd	ra,24(sp)
ffffffffc0200872:	e426                	sd	s1,8(sp)
ffffffffc0200874:	97ba                	add	a5,a5,a4
ffffffffc0200876:	842a                	mv	s0,a0
ffffffffc0200878:	8782                	jr	a5
ffffffffc020087a:	00004517          	auipc	a0,0x4
ffffffffc020087e:	cce50513          	addi	a0,a0,-818 # ffffffffc0204548 <commands+0x3a8>
ffffffffc0200882:	83dff0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc0200886:	8522                	mv	a0,s0
ffffffffc0200888:	c71ff0ef          	jal	ra,ffffffffc02004f8 <pgfault_handler>
ffffffffc020088c:	84aa                	mv	s1,a0
ffffffffc020088e:	12051b63          	bnez	a0,ffffffffc02009c4 <exception_handler+0x170>
ffffffffc0200892:	60e2                	ld	ra,24(sp)
ffffffffc0200894:	6442                	ld	s0,16(sp)
ffffffffc0200896:	64a2                	ld	s1,8(sp)
ffffffffc0200898:	6105                	addi	sp,sp,32
ffffffffc020089a:	8082                	ret
ffffffffc020089c:	00004517          	auipc	a0,0x4
ffffffffc02008a0:	b0c50513          	addi	a0,a0,-1268 # ffffffffc02043a8 <commands+0x208>
ffffffffc02008a4:	6442                	ld	s0,16(sp)
ffffffffc02008a6:	60e2                	ld	ra,24(sp)
ffffffffc02008a8:	64a2                	ld	s1,8(sp)
ffffffffc02008aa:	6105                	addi	sp,sp,32
ffffffffc02008ac:	813ff06f          	j	ffffffffc02000be <cprintf>
ffffffffc02008b0:	00004517          	auipc	a0,0x4
ffffffffc02008b4:	b1850513          	addi	a0,a0,-1256 # ffffffffc02043c8 <commands+0x228>
ffffffffc02008b8:	b7f5                	j	ffffffffc02008a4 <exception_handler+0x50>
ffffffffc02008ba:	00004517          	auipc	a0,0x4
ffffffffc02008be:	b2e50513          	addi	a0,a0,-1234 # ffffffffc02043e8 <commands+0x248>
ffffffffc02008c2:	b7cd                	j	ffffffffc02008a4 <exception_handler+0x50>
ffffffffc02008c4:	00004517          	auipc	a0,0x4
ffffffffc02008c8:	b3c50513          	addi	a0,a0,-1220 # ffffffffc0204400 <commands+0x260>
ffffffffc02008cc:	bfe1                	j	ffffffffc02008a4 <exception_handler+0x50>
ffffffffc02008ce:	00004517          	auipc	a0,0x4
ffffffffc02008d2:	b4250513          	addi	a0,a0,-1214 # ffffffffc0204410 <commands+0x270>
ffffffffc02008d6:	b7f9                	j	ffffffffc02008a4 <exception_handler+0x50>
ffffffffc02008d8:	00004517          	auipc	a0,0x4
ffffffffc02008dc:	b5850513          	addi	a0,a0,-1192 # ffffffffc0204430 <commands+0x290>
ffffffffc02008e0:	fdeff0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc02008e4:	8522                	mv	a0,s0
ffffffffc02008e6:	c13ff0ef          	jal	ra,ffffffffc02004f8 <pgfault_handler>
ffffffffc02008ea:	84aa                	mv	s1,a0
ffffffffc02008ec:	d15d                	beqz	a0,ffffffffc0200892 <exception_handler+0x3e>
ffffffffc02008ee:	8522                	mv	a0,s0
ffffffffc02008f0:	e65ff0ef          	jal	ra,ffffffffc0200754 <print_trapframe>
ffffffffc02008f4:	86a6                	mv	a3,s1
ffffffffc02008f6:	00004617          	auipc	a2,0x4
ffffffffc02008fa:	b5260613          	addi	a2,a2,-1198 # ffffffffc0204448 <commands+0x2a8>
ffffffffc02008fe:	0c800593          	li	a1,200
ffffffffc0200902:	00004517          	auipc	a0,0x4
ffffffffc0200906:	d4650513          	addi	a0,a0,-698 # ffffffffc0204648 <commands+0x4a8>
ffffffffc020090a:	ffaff0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc020090e:	00004517          	auipc	a0,0x4
ffffffffc0200912:	b5a50513          	addi	a0,a0,-1190 # ffffffffc0204468 <commands+0x2c8>
ffffffffc0200916:	b779                	j	ffffffffc02008a4 <exception_handler+0x50>
ffffffffc0200918:	00004517          	auipc	a0,0x4
ffffffffc020091c:	b6850513          	addi	a0,a0,-1176 # ffffffffc0204480 <commands+0x2e0>
ffffffffc0200920:	f9eff0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc0200924:	8522                	mv	a0,s0
ffffffffc0200926:	bd3ff0ef          	jal	ra,ffffffffc02004f8 <pgfault_handler>
ffffffffc020092a:	84aa                	mv	s1,a0
ffffffffc020092c:	d13d                	beqz	a0,ffffffffc0200892 <exception_handler+0x3e>
ffffffffc020092e:	8522                	mv	a0,s0
ffffffffc0200930:	e25ff0ef          	jal	ra,ffffffffc0200754 <print_trapframe>
ffffffffc0200934:	86a6                	mv	a3,s1
ffffffffc0200936:	00004617          	auipc	a2,0x4
ffffffffc020093a:	b1260613          	addi	a2,a2,-1262 # ffffffffc0204448 <commands+0x2a8>
ffffffffc020093e:	0d200593          	li	a1,210
ffffffffc0200942:	00004517          	auipc	a0,0x4
ffffffffc0200946:	d0650513          	addi	a0,a0,-762 # ffffffffc0204648 <commands+0x4a8>
ffffffffc020094a:	fbaff0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc020094e:	00004517          	auipc	a0,0x4
ffffffffc0200952:	b4a50513          	addi	a0,a0,-1206 # ffffffffc0204498 <commands+0x2f8>
ffffffffc0200956:	b7b9                	j	ffffffffc02008a4 <exception_handler+0x50>
ffffffffc0200958:	00004517          	auipc	a0,0x4
ffffffffc020095c:	b6050513          	addi	a0,a0,-1184 # ffffffffc02044b8 <commands+0x318>
ffffffffc0200960:	b791                	j	ffffffffc02008a4 <exception_handler+0x50>
ffffffffc0200962:	00004517          	auipc	a0,0x4
ffffffffc0200966:	b7650513          	addi	a0,a0,-1162 # ffffffffc02044d8 <commands+0x338>
ffffffffc020096a:	bf2d                	j	ffffffffc02008a4 <exception_handler+0x50>
ffffffffc020096c:	00004517          	auipc	a0,0x4
ffffffffc0200970:	b8c50513          	addi	a0,a0,-1140 # ffffffffc02044f8 <commands+0x358>
ffffffffc0200974:	bf05                	j	ffffffffc02008a4 <exception_handler+0x50>
ffffffffc0200976:	00004517          	auipc	a0,0x4
ffffffffc020097a:	ba250513          	addi	a0,a0,-1118 # ffffffffc0204518 <commands+0x378>
ffffffffc020097e:	b71d                	j	ffffffffc02008a4 <exception_handler+0x50>
ffffffffc0200980:	00004517          	auipc	a0,0x4
ffffffffc0200984:	bb050513          	addi	a0,a0,-1104 # ffffffffc0204530 <commands+0x390>
ffffffffc0200988:	f36ff0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc020098c:	8522                	mv	a0,s0
ffffffffc020098e:	b6bff0ef          	jal	ra,ffffffffc02004f8 <pgfault_handler>
ffffffffc0200992:	84aa                	mv	s1,a0
ffffffffc0200994:	ee050fe3          	beqz	a0,ffffffffc0200892 <exception_handler+0x3e>
ffffffffc0200998:	8522                	mv	a0,s0
ffffffffc020099a:	dbbff0ef          	jal	ra,ffffffffc0200754 <print_trapframe>
ffffffffc020099e:	86a6                	mv	a3,s1
ffffffffc02009a0:	00004617          	auipc	a2,0x4
ffffffffc02009a4:	aa860613          	addi	a2,a2,-1368 # ffffffffc0204448 <commands+0x2a8>
ffffffffc02009a8:	0e800593          	li	a1,232
ffffffffc02009ac:	00004517          	auipc	a0,0x4
ffffffffc02009b0:	c9c50513          	addi	a0,a0,-868 # ffffffffc0204648 <commands+0x4a8>
ffffffffc02009b4:	f50ff0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc02009b8:	6442                	ld	s0,16(sp)
ffffffffc02009ba:	60e2                	ld	ra,24(sp)
ffffffffc02009bc:	64a2                	ld	s1,8(sp)
ffffffffc02009be:	6105                	addi	sp,sp,32
ffffffffc02009c0:	bb51                	j	ffffffffc0200754 <print_trapframe>
ffffffffc02009c2:	bb49                	j	ffffffffc0200754 <print_trapframe>
ffffffffc02009c4:	8522                	mv	a0,s0
ffffffffc02009c6:	d8fff0ef          	jal	ra,ffffffffc0200754 <print_trapframe>
ffffffffc02009ca:	86a6                	mv	a3,s1
ffffffffc02009cc:	00004617          	auipc	a2,0x4
ffffffffc02009d0:	a7c60613          	addi	a2,a2,-1412 # ffffffffc0204448 <commands+0x2a8>
ffffffffc02009d4:	0ef00593          	li	a1,239
ffffffffc02009d8:	00004517          	auipc	a0,0x4
ffffffffc02009dc:	c7050513          	addi	a0,a0,-912 # ffffffffc0204648 <commands+0x4a8>
ffffffffc02009e0:	f24ff0ef          	jal	ra,ffffffffc0200104 <__panic>

ffffffffc02009e4 <trap>:
ffffffffc02009e4:	11853783          	ld	a5,280(a0)
ffffffffc02009e8:	0007c363          	bltz	a5,ffffffffc02009ee <trap+0xa>
ffffffffc02009ec:	b5a5                	j	ffffffffc0200854 <exception_handler>
ffffffffc02009ee:	b3e1                	j	ffffffffc02007b6 <interrupt_handler>

ffffffffc02009f0 <__alltraps>:
ffffffffc02009f0:	14011073          	csrw	sscratch,sp
ffffffffc02009f4:	712d                	addi	sp,sp,-288
ffffffffc02009f6:	e406                	sd	ra,8(sp)
ffffffffc02009f8:	ec0e                	sd	gp,24(sp)
ffffffffc02009fa:	f012                	sd	tp,32(sp)
ffffffffc02009fc:	f416                	sd	t0,40(sp)
ffffffffc02009fe:	f81a                	sd	t1,48(sp)
ffffffffc0200a00:	fc1e                	sd	t2,56(sp)
ffffffffc0200a02:	e0a2                	sd	s0,64(sp)
ffffffffc0200a04:	e4a6                	sd	s1,72(sp)
ffffffffc0200a06:	e8aa                	sd	a0,80(sp)
ffffffffc0200a08:	ecae                	sd	a1,88(sp)
ffffffffc0200a0a:	f0b2                	sd	a2,96(sp)
ffffffffc0200a0c:	f4b6                	sd	a3,104(sp)
ffffffffc0200a0e:	f8ba                	sd	a4,112(sp)
ffffffffc0200a10:	fcbe                	sd	a5,120(sp)
ffffffffc0200a12:	e142                	sd	a6,128(sp)
ffffffffc0200a14:	e546                	sd	a7,136(sp)
ffffffffc0200a16:	e94a                	sd	s2,144(sp)
ffffffffc0200a18:	ed4e                	sd	s3,152(sp)
ffffffffc0200a1a:	f152                	sd	s4,160(sp)
ffffffffc0200a1c:	f556                	sd	s5,168(sp)
ffffffffc0200a1e:	f95a                	sd	s6,176(sp)
ffffffffc0200a20:	fd5e                	sd	s7,184(sp)
ffffffffc0200a22:	e1e2                	sd	s8,192(sp)
ffffffffc0200a24:	e5e6                	sd	s9,200(sp)
ffffffffc0200a26:	e9ea                	sd	s10,208(sp)
ffffffffc0200a28:	edee                	sd	s11,216(sp)
ffffffffc0200a2a:	f1f2                	sd	t3,224(sp)
ffffffffc0200a2c:	f5f6                	sd	t4,232(sp)
ffffffffc0200a2e:	f9fa                	sd	t5,240(sp)
ffffffffc0200a30:	fdfe                	sd	t6,248(sp)
ffffffffc0200a32:	14002473          	csrr	s0,sscratch
ffffffffc0200a36:	100024f3          	csrr	s1,sstatus
ffffffffc0200a3a:	14102973          	csrr	s2,sepc
ffffffffc0200a3e:	143029f3          	csrr	s3,stval
ffffffffc0200a42:	14202a73          	csrr	s4,scause
ffffffffc0200a46:	e822                	sd	s0,16(sp)
ffffffffc0200a48:	e226                	sd	s1,256(sp)
ffffffffc0200a4a:	e64a                	sd	s2,264(sp)
ffffffffc0200a4c:	ea4e                	sd	s3,272(sp)
ffffffffc0200a4e:	ee52                	sd	s4,280(sp)
ffffffffc0200a50:	850a                	mv	a0,sp
ffffffffc0200a52:	f93ff0ef          	jal	ra,ffffffffc02009e4 <trap>

ffffffffc0200a56 <__trapret>:
ffffffffc0200a56:	6492                	ld	s1,256(sp)
ffffffffc0200a58:	6932                	ld	s2,264(sp)
ffffffffc0200a5a:	10049073          	csrw	sstatus,s1
ffffffffc0200a5e:	14191073          	csrw	sepc,s2
ffffffffc0200a62:	60a2                	ld	ra,8(sp)
ffffffffc0200a64:	61e2                	ld	gp,24(sp)
ffffffffc0200a66:	7202                	ld	tp,32(sp)
ffffffffc0200a68:	72a2                	ld	t0,40(sp)
ffffffffc0200a6a:	7342                	ld	t1,48(sp)
ffffffffc0200a6c:	73e2                	ld	t2,56(sp)
ffffffffc0200a6e:	6406                	ld	s0,64(sp)
ffffffffc0200a70:	64a6                	ld	s1,72(sp)
ffffffffc0200a72:	6546                	ld	a0,80(sp)
ffffffffc0200a74:	65e6                	ld	a1,88(sp)
ffffffffc0200a76:	7606                	ld	a2,96(sp)
ffffffffc0200a78:	76a6                	ld	a3,104(sp)
ffffffffc0200a7a:	7746                	ld	a4,112(sp)
ffffffffc0200a7c:	77e6                	ld	a5,120(sp)
ffffffffc0200a7e:	680a                	ld	a6,128(sp)
ffffffffc0200a80:	68aa                	ld	a7,136(sp)
ffffffffc0200a82:	694a                	ld	s2,144(sp)
ffffffffc0200a84:	69ea                	ld	s3,152(sp)
ffffffffc0200a86:	7a0a                	ld	s4,160(sp)
ffffffffc0200a88:	7aaa                	ld	s5,168(sp)
ffffffffc0200a8a:	7b4a                	ld	s6,176(sp)
ffffffffc0200a8c:	7bea                	ld	s7,184(sp)
ffffffffc0200a8e:	6c0e                	ld	s8,192(sp)
ffffffffc0200a90:	6cae                	ld	s9,200(sp)
ffffffffc0200a92:	6d4e                	ld	s10,208(sp)
ffffffffc0200a94:	6dee                	ld	s11,216(sp)
ffffffffc0200a96:	7e0e                	ld	t3,224(sp)
ffffffffc0200a98:	7eae                	ld	t4,232(sp)
ffffffffc0200a9a:	7f4e                	ld	t5,240(sp)
ffffffffc0200a9c:	7fee                	ld	t6,248(sp)
ffffffffc0200a9e:	6142                	ld	sp,16(sp)
ffffffffc0200aa0:	10200073          	sret
	...

ffffffffc0200ab0 <check_vma_overlap.isra.0.part.1>:
ffffffffc0200ab0:	1141                	addi	sp,sp,-16
ffffffffc0200ab2:	00004697          	auipc	a3,0x4
ffffffffc0200ab6:	f2668693          	addi	a3,a3,-218 # ffffffffc02049d8 <commands+0x838>
ffffffffc0200aba:	00004617          	auipc	a2,0x4
ffffffffc0200abe:	f3e60613          	addi	a2,a2,-194 # ffffffffc02049f8 <commands+0x858>
ffffffffc0200ac2:	07d00593          	li	a1,125
ffffffffc0200ac6:	00004517          	auipc	a0,0x4
ffffffffc0200aca:	f4a50513          	addi	a0,a0,-182 # ffffffffc0204a10 <commands+0x870>
ffffffffc0200ace:	e406                	sd	ra,8(sp)
ffffffffc0200ad0:	e34ff0ef          	jal	ra,ffffffffc0200104 <__panic>

ffffffffc0200ad4 <mm_create>:
ffffffffc0200ad4:	1141                	addi	sp,sp,-16
ffffffffc0200ad6:	03000513          	li	a0,48
ffffffffc0200ada:	e022                	sd	s0,0(sp)
ffffffffc0200adc:	e406                	sd	ra,8(sp)
ffffffffc0200ade:	4ff020ef          	jal	ra,ffffffffc02037dc <kmalloc>
ffffffffc0200ae2:	842a                	mv	s0,a0
ffffffffc0200ae4:	c115                	beqz	a0,ffffffffc0200b08 <mm_create+0x34>
ffffffffc0200ae6:	00010797          	auipc	a5,0x10
ffffffffc0200aea:	97a78793          	addi	a5,a5,-1670 # ffffffffc0210460 <swap_init_ok>
ffffffffc0200aee:	439c                	lw	a5,0(a5)
ffffffffc0200af0:	e408                	sd	a0,8(s0)
ffffffffc0200af2:	e008                	sd	a0,0(s0)
ffffffffc0200af4:	00053823          	sd	zero,16(a0)
ffffffffc0200af8:	00053c23          	sd	zero,24(a0)
ffffffffc0200afc:	02052023          	sw	zero,32(a0)
ffffffffc0200b00:	2781                	sext.w	a5,a5
ffffffffc0200b02:	eb81                	bnez	a5,ffffffffc0200b12 <mm_create+0x3e>
ffffffffc0200b04:	02053423          	sd	zero,40(a0)
ffffffffc0200b08:	8522                	mv	a0,s0
ffffffffc0200b0a:	60a2                	ld	ra,8(sp)
ffffffffc0200b0c:	6402                	ld	s0,0(sp)
ffffffffc0200b0e:	0141                	addi	sp,sp,16
ffffffffc0200b10:	8082                	ret
ffffffffc0200b12:	631000ef          	jal	ra,ffffffffc0201942 <swap_init_mm>
ffffffffc0200b16:	8522                	mv	a0,s0
ffffffffc0200b18:	60a2                	ld	ra,8(sp)
ffffffffc0200b1a:	6402                	ld	s0,0(sp)
ffffffffc0200b1c:	0141                	addi	sp,sp,16
ffffffffc0200b1e:	8082                	ret

ffffffffc0200b20 <vma_create>:
ffffffffc0200b20:	1101                	addi	sp,sp,-32
ffffffffc0200b22:	e04a                	sd	s2,0(sp)
ffffffffc0200b24:	892a                	mv	s2,a0
ffffffffc0200b26:	03000513          	li	a0,48
ffffffffc0200b2a:	e822                	sd	s0,16(sp)
ffffffffc0200b2c:	e426                	sd	s1,8(sp)
ffffffffc0200b2e:	ec06                	sd	ra,24(sp)
ffffffffc0200b30:	84ae                	mv	s1,a1
ffffffffc0200b32:	8432                	mv	s0,a2
ffffffffc0200b34:	4a9020ef          	jal	ra,ffffffffc02037dc <kmalloc>
ffffffffc0200b38:	c509                	beqz	a0,ffffffffc0200b42 <vma_create+0x22>
ffffffffc0200b3a:	01253423          	sd	s2,8(a0)
ffffffffc0200b3e:	e904                	sd	s1,16(a0)
ffffffffc0200b40:	ed00                	sd	s0,24(a0)
ffffffffc0200b42:	60e2                	ld	ra,24(sp)
ffffffffc0200b44:	6442                	ld	s0,16(sp)
ffffffffc0200b46:	64a2                	ld	s1,8(sp)
ffffffffc0200b48:	6902                	ld	s2,0(sp)
ffffffffc0200b4a:	6105                	addi	sp,sp,32
ffffffffc0200b4c:	8082                	ret

ffffffffc0200b4e <find_vma>:
ffffffffc0200b4e:	c51d                	beqz	a0,ffffffffc0200b7c <find_vma+0x2e>
ffffffffc0200b50:	691c                	ld	a5,16(a0)
ffffffffc0200b52:	c781                	beqz	a5,ffffffffc0200b5a <find_vma+0xc>
ffffffffc0200b54:	6798                	ld	a4,8(a5)
ffffffffc0200b56:	02e5f663          	bgeu	a1,a4,ffffffffc0200b82 <find_vma+0x34>
ffffffffc0200b5a:	87aa                	mv	a5,a0
ffffffffc0200b5c:	679c                	ld	a5,8(a5)
ffffffffc0200b5e:	00f50f63          	beq	a0,a5,ffffffffc0200b7c <find_vma+0x2e>
ffffffffc0200b62:	fe87b703          	ld	a4,-24(a5)
ffffffffc0200b66:	fee5ebe3          	bltu	a1,a4,ffffffffc0200b5c <find_vma+0xe>
ffffffffc0200b6a:	ff07b703          	ld	a4,-16(a5)
ffffffffc0200b6e:	fee5f7e3          	bgeu	a1,a4,ffffffffc0200b5c <find_vma+0xe>
ffffffffc0200b72:	1781                	addi	a5,a5,-32
ffffffffc0200b74:	c781                	beqz	a5,ffffffffc0200b7c <find_vma+0x2e>
ffffffffc0200b76:	e91c                	sd	a5,16(a0)
ffffffffc0200b78:	853e                	mv	a0,a5
ffffffffc0200b7a:	8082                	ret
ffffffffc0200b7c:	4781                	li	a5,0
ffffffffc0200b7e:	853e                	mv	a0,a5
ffffffffc0200b80:	8082                	ret
ffffffffc0200b82:	6b98                	ld	a4,16(a5)
ffffffffc0200b84:	fce5fbe3          	bgeu	a1,a4,ffffffffc0200b5a <find_vma+0xc>
ffffffffc0200b88:	e91c                	sd	a5,16(a0)
ffffffffc0200b8a:	b7fd                	j	ffffffffc0200b78 <find_vma+0x2a>

ffffffffc0200b8c <insert_vma_struct>:
ffffffffc0200b8c:	6590                	ld	a2,8(a1)
ffffffffc0200b8e:	0105b803          	ld	a6,16(a1)
ffffffffc0200b92:	1141                	addi	sp,sp,-16
ffffffffc0200b94:	e406                	sd	ra,8(sp)
ffffffffc0200b96:	872a                	mv	a4,a0
ffffffffc0200b98:	01066863          	bltu	a2,a6,ffffffffc0200ba8 <insert_vma_struct+0x1c>
ffffffffc0200b9c:	a8b9                	j	ffffffffc0200bfa <insert_vma_struct+0x6e>
ffffffffc0200b9e:	fe87b683          	ld	a3,-24(a5)
ffffffffc0200ba2:	04d66763          	bltu	a2,a3,ffffffffc0200bf0 <insert_vma_struct+0x64>
ffffffffc0200ba6:	873e                	mv	a4,a5
ffffffffc0200ba8:	671c                	ld	a5,8(a4)
ffffffffc0200baa:	fef51ae3          	bne	a0,a5,ffffffffc0200b9e <insert_vma_struct+0x12>
ffffffffc0200bae:	02a70463          	beq	a4,a0,ffffffffc0200bd6 <insert_vma_struct+0x4a>
ffffffffc0200bb2:	ff073683          	ld	a3,-16(a4)
ffffffffc0200bb6:	fe873883          	ld	a7,-24(a4)
ffffffffc0200bba:	08d8f063          	bgeu	a7,a3,ffffffffc0200c3a <insert_vma_struct+0xae>
ffffffffc0200bbe:	04d66e63          	bltu	a2,a3,ffffffffc0200c1a <insert_vma_struct+0x8e>
ffffffffc0200bc2:	00f50a63          	beq	a0,a5,ffffffffc0200bd6 <insert_vma_struct+0x4a>
ffffffffc0200bc6:	fe87b683          	ld	a3,-24(a5)
ffffffffc0200bca:	0506e863          	bltu	a3,a6,ffffffffc0200c1a <insert_vma_struct+0x8e>
ffffffffc0200bce:	ff07b603          	ld	a2,-16(a5)
ffffffffc0200bd2:	02c6f263          	bgeu	a3,a2,ffffffffc0200bf6 <insert_vma_struct+0x6a>
ffffffffc0200bd6:	5114                	lw	a3,32(a0)
ffffffffc0200bd8:	e188                	sd	a0,0(a1)
ffffffffc0200bda:	02058613          	addi	a2,a1,32
ffffffffc0200bde:	e390                	sd	a2,0(a5)
ffffffffc0200be0:	e710                	sd	a2,8(a4)
ffffffffc0200be2:	60a2                	ld	ra,8(sp)
ffffffffc0200be4:	f59c                	sd	a5,40(a1)
ffffffffc0200be6:	f198                	sd	a4,32(a1)
ffffffffc0200be8:	2685                	addiw	a3,a3,1
ffffffffc0200bea:	d114                	sw	a3,32(a0)
ffffffffc0200bec:	0141                	addi	sp,sp,16
ffffffffc0200bee:	8082                	ret
ffffffffc0200bf0:	fca711e3          	bne	a4,a0,ffffffffc0200bb2 <insert_vma_struct+0x26>
ffffffffc0200bf4:	bfd9                	j	ffffffffc0200bca <insert_vma_struct+0x3e>
ffffffffc0200bf6:	ebbff0ef          	jal	ra,ffffffffc0200ab0 <check_vma_overlap.isra.0.part.1>
ffffffffc0200bfa:	00004697          	auipc	a3,0x4
ffffffffc0200bfe:	ea668693          	addi	a3,a3,-346 # ffffffffc0204aa0 <commands+0x900>
ffffffffc0200c02:	00004617          	auipc	a2,0x4
ffffffffc0200c06:	df660613          	addi	a2,a2,-522 # ffffffffc02049f8 <commands+0x858>
ffffffffc0200c0a:	08400593          	li	a1,132
ffffffffc0200c0e:	00004517          	auipc	a0,0x4
ffffffffc0200c12:	e0250513          	addi	a0,a0,-510 # ffffffffc0204a10 <commands+0x870>
ffffffffc0200c16:	ceeff0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0200c1a:	00004697          	auipc	a3,0x4
ffffffffc0200c1e:	ec668693          	addi	a3,a3,-314 # ffffffffc0204ae0 <commands+0x940>
ffffffffc0200c22:	00004617          	auipc	a2,0x4
ffffffffc0200c26:	dd660613          	addi	a2,a2,-554 # ffffffffc02049f8 <commands+0x858>
ffffffffc0200c2a:	07c00593          	li	a1,124
ffffffffc0200c2e:	00004517          	auipc	a0,0x4
ffffffffc0200c32:	de250513          	addi	a0,a0,-542 # ffffffffc0204a10 <commands+0x870>
ffffffffc0200c36:	cceff0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0200c3a:	00004697          	auipc	a3,0x4
ffffffffc0200c3e:	e8668693          	addi	a3,a3,-378 # ffffffffc0204ac0 <commands+0x920>
ffffffffc0200c42:	00004617          	auipc	a2,0x4
ffffffffc0200c46:	db660613          	addi	a2,a2,-586 # ffffffffc02049f8 <commands+0x858>
ffffffffc0200c4a:	07b00593          	li	a1,123
ffffffffc0200c4e:	00004517          	auipc	a0,0x4
ffffffffc0200c52:	dc250513          	addi	a0,a0,-574 # ffffffffc0204a10 <commands+0x870>
ffffffffc0200c56:	caeff0ef          	jal	ra,ffffffffc0200104 <__panic>

ffffffffc0200c5a <mm_destroy>:
ffffffffc0200c5a:	1141                	addi	sp,sp,-16
ffffffffc0200c5c:	e022                	sd	s0,0(sp)
ffffffffc0200c5e:	842a                	mv	s0,a0
ffffffffc0200c60:	6508                	ld	a0,8(a0)
ffffffffc0200c62:	e406                	sd	ra,8(sp)
ffffffffc0200c64:	00a40e63          	beq	s0,a0,ffffffffc0200c80 <mm_destroy+0x26>
ffffffffc0200c68:	6118                	ld	a4,0(a0)
ffffffffc0200c6a:	651c                	ld	a5,8(a0)
ffffffffc0200c6c:	03000593          	li	a1,48
ffffffffc0200c70:	1501                	addi	a0,a0,-32
ffffffffc0200c72:	e71c                	sd	a5,8(a4)
ffffffffc0200c74:	e398                	sd	a4,0(a5)
ffffffffc0200c76:	429020ef          	jal	ra,ffffffffc020389e <kfree>
ffffffffc0200c7a:	6408                	ld	a0,8(s0)
ffffffffc0200c7c:	fea416e3          	bne	s0,a0,ffffffffc0200c68 <mm_destroy+0xe>
ffffffffc0200c80:	8522                	mv	a0,s0
ffffffffc0200c82:	6402                	ld	s0,0(sp)
ffffffffc0200c84:	60a2                	ld	ra,8(sp)
ffffffffc0200c86:	03000593          	li	a1,48
ffffffffc0200c8a:	0141                	addi	sp,sp,16
ffffffffc0200c8c:	4130206f          	j	ffffffffc020389e <kfree>

ffffffffc0200c90 <vmm_init>:
ffffffffc0200c90:	715d                	addi	sp,sp,-80
ffffffffc0200c92:	e486                	sd	ra,72(sp)
ffffffffc0200c94:	e0a2                	sd	s0,64(sp)
ffffffffc0200c96:	fc26                	sd	s1,56(sp)
ffffffffc0200c98:	f84a                	sd	s2,48(sp)
ffffffffc0200c9a:	f052                	sd	s4,32(sp)
ffffffffc0200c9c:	f44e                	sd	s3,40(sp)
ffffffffc0200c9e:	ec56                	sd	s5,24(sp)
ffffffffc0200ca0:	e85a                	sd	s6,16(sp)
ffffffffc0200ca2:	e45e                	sd	s7,8(sp)
ffffffffc0200ca4:	51d010ef          	jal	ra,ffffffffc02029c0 <nr_free_pages>
ffffffffc0200ca8:	892a                	mv	s2,a0
ffffffffc0200caa:	517010ef          	jal	ra,ffffffffc02029c0 <nr_free_pages>
ffffffffc0200cae:	8a2a                	mv	s4,a0
ffffffffc0200cb0:	e25ff0ef          	jal	ra,ffffffffc0200ad4 <mm_create>
ffffffffc0200cb4:	842a                	mv	s0,a0
ffffffffc0200cb6:	03200493          	li	s1,50
ffffffffc0200cba:	e919                	bnez	a0,ffffffffc0200cd0 <vmm_init+0x40>
ffffffffc0200cbc:	aeed                	j	ffffffffc02010b6 <vmm_init+0x426>
ffffffffc0200cbe:	e504                	sd	s1,8(a0)
ffffffffc0200cc0:	e91c                	sd	a5,16(a0)
ffffffffc0200cc2:	00053c23          	sd	zero,24(a0)
ffffffffc0200cc6:	14ed                	addi	s1,s1,-5
ffffffffc0200cc8:	8522                	mv	a0,s0
ffffffffc0200cca:	ec3ff0ef          	jal	ra,ffffffffc0200b8c <insert_vma_struct>
ffffffffc0200cce:	c88d                	beqz	s1,ffffffffc0200d00 <vmm_init+0x70>
ffffffffc0200cd0:	03000513          	li	a0,48
ffffffffc0200cd4:	309020ef          	jal	ra,ffffffffc02037dc <kmalloc>
ffffffffc0200cd8:	85aa                	mv	a1,a0
ffffffffc0200cda:	00248793          	addi	a5,s1,2
ffffffffc0200cde:	f165                	bnez	a0,ffffffffc0200cbe <vmm_init+0x2e>
ffffffffc0200ce0:	00004697          	auipc	a3,0x4
ffffffffc0200ce4:	07868693          	addi	a3,a3,120 # ffffffffc0204d58 <commands+0xbb8>
ffffffffc0200ce8:	00004617          	auipc	a2,0x4
ffffffffc0200cec:	d1060613          	addi	a2,a2,-752 # ffffffffc02049f8 <commands+0x858>
ffffffffc0200cf0:	0ce00593          	li	a1,206
ffffffffc0200cf4:	00004517          	auipc	a0,0x4
ffffffffc0200cf8:	d1c50513          	addi	a0,a0,-740 # ffffffffc0204a10 <commands+0x870>
ffffffffc0200cfc:	c08ff0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0200d00:	03700493          	li	s1,55
ffffffffc0200d04:	1f900993          	li	s3,505
ffffffffc0200d08:	a819                	j	ffffffffc0200d1e <vmm_init+0x8e>
ffffffffc0200d0a:	e504                	sd	s1,8(a0)
ffffffffc0200d0c:	e91c                	sd	a5,16(a0)
ffffffffc0200d0e:	00053c23          	sd	zero,24(a0)
ffffffffc0200d12:	0495                	addi	s1,s1,5
ffffffffc0200d14:	8522                	mv	a0,s0
ffffffffc0200d16:	e77ff0ef          	jal	ra,ffffffffc0200b8c <insert_vma_struct>
ffffffffc0200d1a:	03348a63          	beq	s1,s3,ffffffffc0200d4e <vmm_init+0xbe>
ffffffffc0200d1e:	03000513          	li	a0,48
ffffffffc0200d22:	2bb020ef          	jal	ra,ffffffffc02037dc <kmalloc>
ffffffffc0200d26:	85aa                	mv	a1,a0
ffffffffc0200d28:	00248793          	addi	a5,s1,2
ffffffffc0200d2c:	fd79                	bnez	a0,ffffffffc0200d0a <vmm_init+0x7a>
ffffffffc0200d2e:	00004697          	auipc	a3,0x4
ffffffffc0200d32:	02a68693          	addi	a3,a3,42 # ffffffffc0204d58 <commands+0xbb8>
ffffffffc0200d36:	00004617          	auipc	a2,0x4
ffffffffc0200d3a:	cc260613          	addi	a2,a2,-830 # ffffffffc02049f8 <commands+0x858>
ffffffffc0200d3e:	0d400593          	li	a1,212
ffffffffc0200d42:	00004517          	auipc	a0,0x4
ffffffffc0200d46:	cce50513          	addi	a0,a0,-818 # ffffffffc0204a10 <commands+0x870>
ffffffffc0200d4a:	bbaff0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0200d4e:	6418                	ld	a4,8(s0)
ffffffffc0200d50:	479d                	li	a5,7
ffffffffc0200d52:	1fb00593          	li	a1,507
ffffffffc0200d56:	2ae40063          	beq	s0,a4,ffffffffc0200ff6 <vmm_init+0x366>
ffffffffc0200d5a:	fe873603          	ld	a2,-24(a4)
ffffffffc0200d5e:	ffe78693          	addi	a3,a5,-2
ffffffffc0200d62:	20d61a63          	bne	a2,a3,ffffffffc0200f76 <vmm_init+0x2e6>
ffffffffc0200d66:	ff073683          	ld	a3,-16(a4)
ffffffffc0200d6a:	20d79663          	bne	a5,a3,ffffffffc0200f76 <vmm_init+0x2e6>
ffffffffc0200d6e:	0795                	addi	a5,a5,5
ffffffffc0200d70:	6718                	ld	a4,8(a4)
ffffffffc0200d72:	feb792e3          	bne	a5,a1,ffffffffc0200d56 <vmm_init+0xc6>
ffffffffc0200d76:	499d                	li	s3,7
ffffffffc0200d78:	4495                	li	s1,5
ffffffffc0200d7a:	1f900b93          	li	s7,505
ffffffffc0200d7e:	85a6                	mv	a1,s1
ffffffffc0200d80:	8522                	mv	a0,s0
ffffffffc0200d82:	dcdff0ef          	jal	ra,ffffffffc0200b4e <find_vma>
ffffffffc0200d86:	8b2a                	mv	s6,a0
ffffffffc0200d88:	2e050763          	beqz	a0,ffffffffc0201076 <vmm_init+0x3e6>
ffffffffc0200d8c:	00148593          	addi	a1,s1,1
ffffffffc0200d90:	8522                	mv	a0,s0
ffffffffc0200d92:	dbdff0ef          	jal	ra,ffffffffc0200b4e <find_vma>
ffffffffc0200d96:	8aaa                	mv	s5,a0
ffffffffc0200d98:	2a050f63          	beqz	a0,ffffffffc0201056 <vmm_init+0x3c6>
ffffffffc0200d9c:	85ce                	mv	a1,s3
ffffffffc0200d9e:	8522                	mv	a0,s0
ffffffffc0200da0:	dafff0ef          	jal	ra,ffffffffc0200b4e <find_vma>
ffffffffc0200da4:	28051963          	bnez	a0,ffffffffc0201036 <vmm_init+0x3a6>
ffffffffc0200da8:	00348593          	addi	a1,s1,3
ffffffffc0200dac:	8522                	mv	a0,s0
ffffffffc0200dae:	da1ff0ef          	jal	ra,ffffffffc0200b4e <find_vma>
ffffffffc0200db2:	26051263          	bnez	a0,ffffffffc0201016 <vmm_init+0x386>
ffffffffc0200db6:	00448593          	addi	a1,s1,4
ffffffffc0200dba:	8522                	mv	a0,s0
ffffffffc0200dbc:	d93ff0ef          	jal	ra,ffffffffc0200b4e <find_vma>
ffffffffc0200dc0:	2c051b63          	bnez	a0,ffffffffc0201096 <vmm_init+0x406>
ffffffffc0200dc4:	008b3783          	ld	a5,8(s6)
ffffffffc0200dc8:	1c979763          	bne	a5,s1,ffffffffc0200f96 <vmm_init+0x306>
ffffffffc0200dcc:	010b3783          	ld	a5,16(s6)
ffffffffc0200dd0:	1d379363          	bne	a5,s3,ffffffffc0200f96 <vmm_init+0x306>
ffffffffc0200dd4:	008ab783          	ld	a5,8(s5)
ffffffffc0200dd8:	1c979f63          	bne	a5,s1,ffffffffc0200fb6 <vmm_init+0x326>
ffffffffc0200ddc:	010ab783          	ld	a5,16(s5)
ffffffffc0200de0:	1d379b63          	bne	a5,s3,ffffffffc0200fb6 <vmm_init+0x326>
ffffffffc0200de4:	0495                	addi	s1,s1,5
ffffffffc0200de6:	0995                	addi	s3,s3,5
ffffffffc0200de8:	f9749be3          	bne	s1,s7,ffffffffc0200d7e <vmm_init+0xee>
ffffffffc0200dec:	4491                	li	s1,4
ffffffffc0200dee:	59fd                	li	s3,-1
ffffffffc0200df0:	85a6                	mv	a1,s1
ffffffffc0200df2:	8522                	mv	a0,s0
ffffffffc0200df4:	d5bff0ef          	jal	ra,ffffffffc0200b4e <find_vma>
ffffffffc0200df8:	0004859b          	sext.w	a1,s1
ffffffffc0200dfc:	c90d                	beqz	a0,ffffffffc0200e2e <vmm_init+0x19e>
ffffffffc0200dfe:	6914                	ld	a3,16(a0)
ffffffffc0200e00:	6510                	ld	a2,8(a0)
ffffffffc0200e02:	00004517          	auipc	a0,0x4
ffffffffc0200e06:	e0e50513          	addi	a0,a0,-498 # ffffffffc0204c10 <commands+0xa70>
ffffffffc0200e0a:	ab4ff0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc0200e0e:	00004697          	auipc	a3,0x4
ffffffffc0200e12:	e2a68693          	addi	a3,a3,-470 # ffffffffc0204c38 <commands+0xa98>
ffffffffc0200e16:	00004617          	auipc	a2,0x4
ffffffffc0200e1a:	be260613          	addi	a2,a2,-1054 # ffffffffc02049f8 <commands+0x858>
ffffffffc0200e1e:	0f600593          	li	a1,246
ffffffffc0200e22:	00004517          	auipc	a0,0x4
ffffffffc0200e26:	bee50513          	addi	a0,a0,-1042 # ffffffffc0204a10 <commands+0x870>
ffffffffc0200e2a:	adaff0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0200e2e:	14fd                	addi	s1,s1,-1
ffffffffc0200e30:	fd3490e3          	bne	s1,s3,ffffffffc0200df0 <vmm_init+0x160>
ffffffffc0200e34:	8522                	mv	a0,s0
ffffffffc0200e36:	e25ff0ef          	jal	ra,ffffffffc0200c5a <mm_destroy>
ffffffffc0200e3a:	387010ef          	jal	ra,ffffffffc02029c0 <nr_free_pages>
ffffffffc0200e3e:	28aa1c63          	bne	s4,a0,ffffffffc02010d6 <vmm_init+0x446>
ffffffffc0200e42:	00004517          	auipc	a0,0x4
ffffffffc0200e46:	e3650513          	addi	a0,a0,-458 # ffffffffc0204c78 <commands+0xad8>
ffffffffc0200e4a:	a74ff0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc0200e4e:	373010ef          	jal	ra,ffffffffc02029c0 <nr_free_pages>
ffffffffc0200e52:	89aa                	mv	s3,a0
ffffffffc0200e54:	c81ff0ef          	jal	ra,ffffffffc0200ad4 <mm_create>
ffffffffc0200e58:	0000f797          	auipc	a5,0xf
ffffffffc0200e5c:	62a7b423          	sd	a0,1576(a5) # ffffffffc0210480 <check_mm_struct>
ffffffffc0200e60:	842a                	mv	s0,a0
ffffffffc0200e62:	2a050a63          	beqz	a0,ffffffffc0201116 <vmm_init+0x486>
ffffffffc0200e66:	0000f797          	auipc	a5,0xf
ffffffffc0200e6a:	60278793          	addi	a5,a5,1538 # ffffffffc0210468 <boot_pgdir>
ffffffffc0200e6e:	6384                	ld	s1,0(a5)
ffffffffc0200e70:	609c                	ld	a5,0(s1)
ffffffffc0200e72:	ed04                	sd	s1,24(a0)
ffffffffc0200e74:	32079d63          	bnez	a5,ffffffffc02011ae <vmm_init+0x51e>
ffffffffc0200e78:	03000513          	li	a0,48
ffffffffc0200e7c:	161020ef          	jal	ra,ffffffffc02037dc <kmalloc>
ffffffffc0200e80:	8a2a                	mv	s4,a0
ffffffffc0200e82:	14050a63          	beqz	a0,ffffffffc0200fd6 <vmm_init+0x346>
ffffffffc0200e86:	002007b7          	lui	a5,0x200
ffffffffc0200e8a:	00fa3823          	sd	a5,16(s4)
ffffffffc0200e8e:	4789                	li	a5,2
ffffffffc0200e90:	85aa                	mv	a1,a0
ffffffffc0200e92:	00fa3c23          	sd	a5,24(s4)
ffffffffc0200e96:	8522                	mv	a0,s0
ffffffffc0200e98:	000a3423          	sd	zero,8(s4)
ffffffffc0200e9c:	cf1ff0ef          	jal	ra,ffffffffc0200b8c <insert_vma_struct>
ffffffffc0200ea0:	10000593          	li	a1,256
ffffffffc0200ea4:	8522                	mv	a0,s0
ffffffffc0200ea6:	ca9ff0ef          	jal	ra,ffffffffc0200b4e <find_vma>
ffffffffc0200eaa:	10000793          	li	a5,256
ffffffffc0200eae:	16400713          	li	a4,356
ffffffffc0200eb2:	2aaa1263          	bne	s4,a0,ffffffffc0201156 <vmm_init+0x4c6>
ffffffffc0200eb6:	00f78023          	sb	a5,0(a5) # 200000 <BASE_ADDRESS-0xffffffffc0000000>
ffffffffc0200eba:	0785                	addi	a5,a5,1
ffffffffc0200ebc:	fee79de3          	bne	a5,a4,ffffffffc0200eb6 <vmm_init+0x226>
ffffffffc0200ec0:	6705                	lui	a4,0x1
ffffffffc0200ec2:	10000793          	li	a5,256
ffffffffc0200ec6:	35670713          	addi	a4,a4,854 # 1356 <BASE_ADDRESS-0xffffffffc01fecaa>
ffffffffc0200eca:	16400613          	li	a2,356
ffffffffc0200ece:	0007c683          	lbu	a3,0(a5)
ffffffffc0200ed2:	0785                	addi	a5,a5,1
ffffffffc0200ed4:	9f15                	subw	a4,a4,a3
ffffffffc0200ed6:	fec79ce3          	bne	a5,a2,ffffffffc0200ece <vmm_init+0x23e>
ffffffffc0200eda:	2a071a63          	bnez	a4,ffffffffc020118e <vmm_init+0x4fe>
ffffffffc0200ede:	4581                	li	a1,0
ffffffffc0200ee0:	8526                	mv	a0,s1
ffffffffc0200ee2:	57b010ef          	jal	ra,ffffffffc0202c5c <page_remove>
ffffffffc0200ee6:	609c                	ld	a5,0(s1)
ffffffffc0200ee8:	0000f717          	auipc	a4,0xf
ffffffffc0200eec:	58870713          	addi	a4,a4,1416 # ffffffffc0210470 <npage>
ffffffffc0200ef0:	6318                	ld	a4,0(a4)
ffffffffc0200ef2:	078a                	slli	a5,a5,0x2
ffffffffc0200ef4:	83b1                	srli	a5,a5,0xc
ffffffffc0200ef6:	28e7f063          	bgeu	a5,a4,ffffffffc0201176 <vmm_init+0x4e6>
ffffffffc0200efa:	00005717          	auipc	a4,0x5
ffffffffc0200efe:	ed670713          	addi	a4,a4,-298 # ffffffffc0205dd0 <nbase>
ffffffffc0200f02:	6318                	ld	a4,0(a4)
ffffffffc0200f04:	0000f697          	auipc	a3,0xf
ffffffffc0200f08:	67c68693          	addi	a3,a3,1660 # ffffffffc0210580 <pages>
ffffffffc0200f0c:	6288                	ld	a0,0(a3)
ffffffffc0200f0e:	8f99                	sub	a5,a5,a4
ffffffffc0200f10:	00379713          	slli	a4,a5,0x3
ffffffffc0200f14:	97ba                	add	a5,a5,a4
ffffffffc0200f16:	078e                	slli	a5,a5,0x3
ffffffffc0200f18:	953e                	add	a0,a0,a5
ffffffffc0200f1a:	4585                	li	a1,1
ffffffffc0200f1c:	25f010ef          	jal	ra,ffffffffc020297a <free_pages>
ffffffffc0200f20:	0004b023          	sd	zero,0(s1)
ffffffffc0200f24:	8522                	mv	a0,s0
ffffffffc0200f26:	00043c23          	sd	zero,24(s0)
ffffffffc0200f2a:	d31ff0ef          	jal	ra,ffffffffc0200c5a <mm_destroy>
ffffffffc0200f2e:	19fd                	addi	s3,s3,-1
ffffffffc0200f30:	0000f797          	auipc	a5,0xf
ffffffffc0200f34:	5407b823          	sd	zero,1360(a5) # ffffffffc0210480 <check_mm_struct>
ffffffffc0200f38:	289010ef          	jal	ra,ffffffffc02029c0 <nr_free_pages>
ffffffffc0200f3c:	1aa99d63          	bne	s3,a0,ffffffffc02010f6 <vmm_init+0x466>
ffffffffc0200f40:	00004517          	auipc	a0,0x4
ffffffffc0200f44:	de050513          	addi	a0,a0,-544 # ffffffffc0204d20 <commands+0xb80>
ffffffffc0200f48:	976ff0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc0200f4c:	275010ef          	jal	ra,ffffffffc02029c0 <nr_free_pages>
ffffffffc0200f50:	197d                	addi	s2,s2,-1
ffffffffc0200f52:	1ea91263          	bne	s2,a0,ffffffffc0201136 <vmm_init+0x4a6>
ffffffffc0200f56:	6406                	ld	s0,64(sp)
ffffffffc0200f58:	60a6                	ld	ra,72(sp)
ffffffffc0200f5a:	74e2                	ld	s1,56(sp)
ffffffffc0200f5c:	7942                	ld	s2,48(sp)
ffffffffc0200f5e:	79a2                	ld	s3,40(sp)
ffffffffc0200f60:	7a02                	ld	s4,32(sp)
ffffffffc0200f62:	6ae2                	ld	s5,24(sp)
ffffffffc0200f64:	6b42                	ld	s6,16(sp)
ffffffffc0200f66:	6ba2                	ld	s7,8(sp)
ffffffffc0200f68:	00004517          	auipc	a0,0x4
ffffffffc0200f6c:	dd850513          	addi	a0,a0,-552 # ffffffffc0204d40 <commands+0xba0>
ffffffffc0200f70:	6161                	addi	sp,sp,80
ffffffffc0200f72:	94cff06f          	j	ffffffffc02000be <cprintf>
ffffffffc0200f76:	00004697          	auipc	a3,0x4
ffffffffc0200f7a:	bb268693          	addi	a3,a3,-1102 # ffffffffc0204b28 <commands+0x988>
ffffffffc0200f7e:	00004617          	auipc	a2,0x4
ffffffffc0200f82:	a7a60613          	addi	a2,a2,-1414 # ffffffffc02049f8 <commands+0x858>
ffffffffc0200f86:	0dd00593          	li	a1,221
ffffffffc0200f8a:	00004517          	auipc	a0,0x4
ffffffffc0200f8e:	a8650513          	addi	a0,a0,-1402 # ffffffffc0204a10 <commands+0x870>
ffffffffc0200f92:	972ff0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0200f96:	00004697          	auipc	a3,0x4
ffffffffc0200f9a:	c1a68693          	addi	a3,a3,-998 # ffffffffc0204bb0 <commands+0xa10>
ffffffffc0200f9e:	00004617          	auipc	a2,0x4
ffffffffc0200fa2:	a5a60613          	addi	a2,a2,-1446 # ffffffffc02049f8 <commands+0x858>
ffffffffc0200fa6:	0ed00593          	li	a1,237
ffffffffc0200faa:	00004517          	auipc	a0,0x4
ffffffffc0200fae:	a6650513          	addi	a0,a0,-1434 # ffffffffc0204a10 <commands+0x870>
ffffffffc0200fb2:	952ff0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0200fb6:	00004697          	auipc	a3,0x4
ffffffffc0200fba:	c2a68693          	addi	a3,a3,-982 # ffffffffc0204be0 <commands+0xa40>
ffffffffc0200fbe:	00004617          	auipc	a2,0x4
ffffffffc0200fc2:	a3a60613          	addi	a2,a2,-1478 # ffffffffc02049f8 <commands+0x858>
ffffffffc0200fc6:	0ee00593          	li	a1,238
ffffffffc0200fca:	00004517          	auipc	a0,0x4
ffffffffc0200fce:	a4650513          	addi	a0,a0,-1466 # ffffffffc0204a10 <commands+0x870>
ffffffffc0200fd2:	932ff0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0200fd6:	00004697          	auipc	a3,0x4
ffffffffc0200fda:	d8268693          	addi	a3,a3,-638 # ffffffffc0204d58 <commands+0xbb8>
ffffffffc0200fde:	00004617          	auipc	a2,0x4
ffffffffc0200fe2:	a1a60613          	addi	a2,a2,-1510 # ffffffffc02049f8 <commands+0x858>
ffffffffc0200fe6:	11100593          	li	a1,273
ffffffffc0200fea:	00004517          	auipc	a0,0x4
ffffffffc0200fee:	a2650513          	addi	a0,a0,-1498 # ffffffffc0204a10 <commands+0x870>
ffffffffc0200ff2:	912ff0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0200ff6:	00004697          	auipc	a3,0x4
ffffffffc0200ffa:	b1a68693          	addi	a3,a3,-1254 # ffffffffc0204b10 <commands+0x970>
ffffffffc0200ffe:	00004617          	auipc	a2,0x4
ffffffffc0201002:	9fa60613          	addi	a2,a2,-1542 # ffffffffc02049f8 <commands+0x858>
ffffffffc0201006:	0db00593          	li	a1,219
ffffffffc020100a:	00004517          	auipc	a0,0x4
ffffffffc020100e:	a0650513          	addi	a0,a0,-1530 # ffffffffc0204a10 <commands+0x870>
ffffffffc0201012:	8f2ff0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0201016:	00004697          	auipc	a3,0x4
ffffffffc020101a:	b7a68693          	addi	a3,a3,-1158 # ffffffffc0204b90 <commands+0x9f0>
ffffffffc020101e:	00004617          	auipc	a2,0x4
ffffffffc0201022:	9da60613          	addi	a2,a2,-1574 # ffffffffc02049f8 <commands+0x858>
ffffffffc0201026:	0e900593          	li	a1,233
ffffffffc020102a:	00004517          	auipc	a0,0x4
ffffffffc020102e:	9e650513          	addi	a0,a0,-1562 # ffffffffc0204a10 <commands+0x870>
ffffffffc0201032:	8d2ff0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0201036:	00004697          	auipc	a3,0x4
ffffffffc020103a:	b4a68693          	addi	a3,a3,-1206 # ffffffffc0204b80 <commands+0x9e0>
ffffffffc020103e:	00004617          	auipc	a2,0x4
ffffffffc0201042:	9ba60613          	addi	a2,a2,-1606 # ffffffffc02049f8 <commands+0x858>
ffffffffc0201046:	0e700593          	li	a1,231
ffffffffc020104a:	00004517          	auipc	a0,0x4
ffffffffc020104e:	9c650513          	addi	a0,a0,-1594 # ffffffffc0204a10 <commands+0x870>
ffffffffc0201052:	8b2ff0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0201056:	00004697          	auipc	a3,0x4
ffffffffc020105a:	b1a68693          	addi	a3,a3,-1254 # ffffffffc0204b70 <commands+0x9d0>
ffffffffc020105e:	00004617          	auipc	a2,0x4
ffffffffc0201062:	99a60613          	addi	a2,a2,-1638 # ffffffffc02049f8 <commands+0x858>
ffffffffc0201066:	0e500593          	li	a1,229
ffffffffc020106a:	00004517          	auipc	a0,0x4
ffffffffc020106e:	9a650513          	addi	a0,a0,-1626 # ffffffffc0204a10 <commands+0x870>
ffffffffc0201072:	892ff0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0201076:	00004697          	auipc	a3,0x4
ffffffffc020107a:	aea68693          	addi	a3,a3,-1302 # ffffffffc0204b60 <commands+0x9c0>
ffffffffc020107e:	00004617          	auipc	a2,0x4
ffffffffc0201082:	97a60613          	addi	a2,a2,-1670 # ffffffffc02049f8 <commands+0x858>
ffffffffc0201086:	0e300593          	li	a1,227
ffffffffc020108a:	00004517          	auipc	a0,0x4
ffffffffc020108e:	98650513          	addi	a0,a0,-1658 # ffffffffc0204a10 <commands+0x870>
ffffffffc0201092:	872ff0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0201096:	00004697          	auipc	a3,0x4
ffffffffc020109a:	b0a68693          	addi	a3,a3,-1270 # ffffffffc0204ba0 <commands+0xa00>
ffffffffc020109e:	00004617          	auipc	a2,0x4
ffffffffc02010a2:	95a60613          	addi	a2,a2,-1702 # ffffffffc02049f8 <commands+0x858>
ffffffffc02010a6:	0eb00593          	li	a1,235
ffffffffc02010aa:	00004517          	auipc	a0,0x4
ffffffffc02010ae:	96650513          	addi	a0,a0,-1690 # ffffffffc0204a10 <commands+0x870>
ffffffffc02010b2:	852ff0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc02010b6:	00004697          	auipc	a3,0x4
ffffffffc02010ba:	a4a68693          	addi	a3,a3,-1462 # ffffffffc0204b00 <commands+0x960>
ffffffffc02010be:	00004617          	auipc	a2,0x4
ffffffffc02010c2:	93a60613          	addi	a2,a2,-1734 # ffffffffc02049f8 <commands+0x858>
ffffffffc02010c6:	0c700593          	li	a1,199
ffffffffc02010ca:	00004517          	auipc	a0,0x4
ffffffffc02010ce:	94650513          	addi	a0,a0,-1722 # ffffffffc0204a10 <commands+0x870>
ffffffffc02010d2:	832ff0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc02010d6:	00004697          	auipc	a3,0x4
ffffffffc02010da:	b7a68693          	addi	a3,a3,-1158 # ffffffffc0204c50 <commands+0xab0>
ffffffffc02010de:	00004617          	auipc	a2,0x4
ffffffffc02010e2:	91a60613          	addi	a2,a2,-1766 # ffffffffc02049f8 <commands+0x858>
ffffffffc02010e6:	0fb00593          	li	a1,251
ffffffffc02010ea:	00004517          	auipc	a0,0x4
ffffffffc02010ee:	92650513          	addi	a0,a0,-1754 # ffffffffc0204a10 <commands+0x870>
ffffffffc02010f2:	812ff0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc02010f6:	00004697          	auipc	a3,0x4
ffffffffc02010fa:	b5a68693          	addi	a3,a3,-1190 # ffffffffc0204c50 <commands+0xab0>
ffffffffc02010fe:	00004617          	auipc	a2,0x4
ffffffffc0201102:	8fa60613          	addi	a2,a2,-1798 # ffffffffc02049f8 <commands+0x858>
ffffffffc0201106:	12e00593          	li	a1,302
ffffffffc020110a:	00004517          	auipc	a0,0x4
ffffffffc020110e:	90650513          	addi	a0,a0,-1786 # ffffffffc0204a10 <commands+0x870>
ffffffffc0201112:	ff3fe0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0201116:	00004697          	auipc	a3,0x4
ffffffffc020111a:	b8268693          	addi	a3,a3,-1150 # ffffffffc0204c98 <commands+0xaf8>
ffffffffc020111e:	00004617          	auipc	a2,0x4
ffffffffc0201122:	8da60613          	addi	a2,a2,-1830 # ffffffffc02049f8 <commands+0x858>
ffffffffc0201126:	10a00593          	li	a1,266
ffffffffc020112a:	00004517          	auipc	a0,0x4
ffffffffc020112e:	8e650513          	addi	a0,a0,-1818 # ffffffffc0204a10 <commands+0x870>
ffffffffc0201132:	fd3fe0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0201136:	00004697          	auipc	a3,0x4
ffffffffc020113a:	b1a68693          	addi	a3,a3,-1254 # ffffffffc0204c50 <commands+0xab0>
ffffffffc020113e:	00004617          	auipc	a2,0x4
ffffffffc0201142:	8ba60613          	addi	a2,a2,-1862 # ffffffffc02049f8 <commands+0x858>
ffffffffc0201146:	0bd00593          	li	a1,189
ffffffffc020114a:	00004517          	auipc	a0,0x4
ffffffffc020114e:	8c650513          	addi	a0,a0,-1850 # ffffffffc0204a10 <commands+0x870>
ffffffffc0201152:	fb3fe0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0201156:	00004697          	auipc	a3,0x4
ffffffffc020115a:	b6a68693          	addi	a3,a3,-1174 # ffffffffc0204cc0 <commands+0xb20>
ffffffffc020115e:	00004617          	auipc	a2,0x4
ffffffffc0201162:	89a60613          	addi	a2,a2,-1894 # ffffffffc02049f8 <commands+0x858>
ffffffffc0201166:	11600593          	li	a1,278
ffffffffc020116a:	00004517          	auipc	a0,0x4
ffffffffc020116e:	8a650513          	addi	a0,a0,-1882 # ffffffffc0204a10 <commands+0x870>
ffffffffc0201172:	f93fe0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0201176:	00004617          	auipc	a2,0x4
ffffffffc020117a:	b7a60613          	addi	a2,a2,-1158 # ffffffffc0204cf0 <commands+0xb50>
ffffffffc020117e:	06500593          	li	a1,101
ffffffffc0201182:	00004517          	auipc	a0,0x4
ffffffffc0201186:	b8e50513          	addi	a0,a0,-1138 # ffffffffc0204d10 <commands+0xb70>
ffffffffc020118a:	f7bfe0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc020118e:	00004697          	auipc	a3,0x4
ffffffffc0201192:	b5268693          	addi	a3,a3,-1198 # ffffffffc0204ce0 <commands+0xb40>
ffffffffc0201196:	00004617          	auipc	a2,0x4
ffffffffc020119a:	86260613          	addi	a2,a2,-1950 # ffffffffc02049f8 <commands+0x858>
ffffffffc020119e:	12000593          	li	a1,288
ffffffffc02011a2:	00004517          	auipc	a0,0x4
ffffffffc02011a6:	86e50513          	addi	a0,a0,-1938 # ffffffffc0204a10 <commands+0x870>
ffffffffc02011aa:	f5bfe0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc02011ae:	00004697          	auipc	a3,0x4
ffffffffc02011b2:	b0268693          	addi	a3,a3,-1278 # ffffffffc0204cb0 <commands+0xb10>
ffffffffc02011b6:	00004617          	auipc	a2,0x4
ffffffffc02011ba:	84260613          	addi	a2,a2,-1982 # ffffffffc02049f8 <commands+0x858>
ffffffffc02011be:	10d00593          	li	a1,269
ffffffffc02011c2:	00004517          	auipc	a0,0x4
ffffffffc02011c6:	84e50513          	addi	a0,a0,-1970 # ffffffffc0204a10 <commands+0x870>
ffffffffc02011ca:	f3bfe0ef          	jal	ra,ffffffffc0200104 <__panic>

ffffffffc02011ce <do_pgfault>:
ffffffffc02011ce:	7179                	addi	sp,sp,-48
ffffffffc02011d0:	85b2                	mv	a1,a2
ffffffffc02011d2:	f022                	sd	s0,32(sp)
ffffffffc02011d4:	ec26                	sd	s1,24(sp)
ffffffffc02011d6:	f406                	sd	ra,40(sp)
ffffffffc02011d8:	e84a                	sd	s2,16(sp)
ffffffffc02011da:	8432                	mv	s0,a2
ffffffffc02011dc:	84aa                	mv	s1,a0
ffffffffc02011de:	971ff0ef          	jal	ra,ffffffffc0200b4e <find_vma>
ffffffffc02011e2:	0000f797          	auipc	a5,0xf
ffffffffc02011e6:	26e78793          	addi	a5,a5,622 # ffffffffc0210450 <pgfault_num>
ffffffffc02011ea:	439c                	lw	a5,0(a5)
ffffffffc02011ec:	2785                	addiw	a5,a5,1
ffffffffc02011ee:	0000f717          	auipc	a4,0xf
ffffffffc02011f2:	26f72123          	sw	a5,610(a4) # ffffffffc0210450 <pgfault_num>
ffffffffc02011f6:	c549                	beqz	a0,ffffffffc0201280 <do_pgfault+0xb2>
ffffffffc02011f8:	651c                	ld	a5,8(a0)
ffffffffc02011fa:	08f46363          	bltu	s0,a5,ffffffffc0201280 <do_pgfault+0xb2>
ffffffffc02011fe:	6d1c                	ld	a5,24(a0)
ffffffffc0201200:	4941                	li	s2,16
ffffffffc0201202:	8b89                	andi	a5,a5,2
ffffffffc0201204:	efa9                	bnez	a5,ffffffffc020125e <do_pgfault+0x90>
ffffffffc0201206:	767d                	lui	a2,0xfffff
ffffffffc0201208:	6c88                	ld	a0,24(s1)
ffffffffc020120a:	8c71                	and	s0,s0,a2
ffffffffc020120c:	85a2                	mv	a1,s0
ffffffffc020120e:	4605                	li	a2,1
ffffffffc0201210:	7f0010ef          	jal	ra,ffffffffc0202a00 <get_pte>
ffffffffc0201214:	610c                	ld	a1,0(a0)
ffffffffc0201216:	c5b1                	beqz	a1,ffffffffc0201262 <do_pgfault+0x94>
ffffffffc0201218:	0000f797          	auipc	a5,0xf
ffffffffc020121c:	24878793          	addi	a5,a5,584 # ffffffffc0210460 <swap_init_ok>
ffffffffc0201220:	439c                	lw	a5,0(a5)
ffffffffc0201222:	2781                	sext.w	a5,a5
ffffffffc0201224:	c7bd                	beqz	a5,ffffffffc0201292 <do_pgfault+0xc4>
ffffffffc0201226:	85a2                	mv	a1,s0
ffffffffc0201228:	0030                	addi	a2,sp,8
ffffffffc020122a:	8526                	mv	a0,s1
ffffffffc020122c:	e402                	sd	zero,8(sp)
ffffffffc020122e:	049000ef          	jal	ra,ffffffffc0201a76 <swap_in>
ffffffffc0201232:	65a2                	ld	a1,8(sp)
ffffffffc0201234:	6c88                	ld	a0,24(s1)
ffffffffc0201236:	86ca                	mv	a3,s2
ffffffffc0201238:	8622                	mv	a2,s0
ffffffffc020123a:	295010ef          	jal	ra,ffffffffc0202cce <page_insert>
ffffffffc020123e:	6622                	ld	a2,8(sp)
ffffffffc0201240:	4685                	li	a3,1
ffffffffc0201242:	85a2                	mv	a1,s0
ffffffffc0201244:	8526                	mv	a0,s1
ffffffffc0201246:	70c000ef          	jal	ra,ffffffffc0201952 <swap_map_swappable>
ffffffffc020124a:	6722                	ld	a4,8(sp)
ffffffffc020124c:	4781                	li	a5,0
ffffffffc020124e:	e320                	sd	s0,64(a4)
ffffffffc0201250:	70a2                	ld	ra,40(sp)
ffffffffc0201252:	7402                	ld	s0,32(sp)
ffffffffc0201254:	64e2                	ld	s1,24(sp)
ffffffffc0201256:	6942                	ld	s2,16(sp)
ffffffffc0201258:	853e                	mv	a0,a5
ffffffffc020125a:	6145                	addi	sp,sp,48
ffffffffc020125c:	8082                	ret
ffffffffc020125e:	4959                	li	s2,22
ffffffffc0201260:	b75d                	j	ffffffffc0201206 <do_pgfault+0x38>
ffffffffc0201262:	6c88                	ld	a0,24(s1)
ffffffffc0201264:	864a                	mv	a2,s2
ffffffffc0201266:	85a2                	mv	a1,s0
ffffffffc0201268:	4e2020ef          	jal	ra,ffffffffc020374a <pgdir_alloc_page>
ffffffffc020126c:	4781                	li	a5,0
ffffffffc020126e:	f16d                	bnez	a0,ffffffffc0201250 <do_pgfault+0x82>
ffffffffc0201270:	00003517          	auipc	a0,0x3
ffffffffc0201274:	7e050513          	addi	a0,a0,2016 # ffffffffc0204a50 <commands+0x8b0>
ffffffffc0201278:	e47fe0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc020127c:	57f1                	li	a5,-4
ffffffffc020127e:	bfc9                	j	ffffffffc0201250 <do_pgfault+0x82>
ffffffffc0201280:	85a2                	mv	a1,s0
ffffffffc0201282:	00003517          	auipc	a0,0x3
ffffffffc0201286:	79e50513          	addi	a0,a0,1950 # ffffffffc0204a20 <commands+0x880>
ffffffffc020128a:	e35fe0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc020128e:	57f5                	li	a5,-3
ffffffffc0201290:	b7c1                	j	ffffffffc0201250 <do_pgfault+0x82>
ffffffffc0201292:	00003517          	auipc	a0,0x3
ffffffffc0201296:	7e650513          	addi	a0,a0,2022 # ffffffffc0204a78 <commands+0x8d8>
ffffffffc020129a:	e25fe0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc020129e:	57f1                	li	a5,-4
ffffffffc02012a0:	bf45                	j	ffffffffc0201250 <do_pgfault+0x82>

ffffffffc02012a2 <swap_init>:
ffffffffc02012a2:	7135                	addi	sp,sp,-160
ffffffffc02012a4:	ed06                	sd	ra,152(sp)
ffffffffc02012a6:	e922                	sd	s0,144(sp)
ffffffffc02012a8:	e526                	sd	s1,136(sp)
ffffffffc02012aa:	e14a                	sd	s2,128(sp)
ffffffffc02012ac:	fcce                	sd	s3,120(sp)
ffffffffc02012ae:	f8d2                	sd	s4,112(sp)
ffffffffc02012b0:	f4d6                	sd	s5,104(sp)
ffffffffc02012b2:	f0da                	sd	s6,96(sp)
ffffffffc02012b4:	ecde                	sd	s7,88(sp)
ffffffffc02012b6:	e8e2                	sd	s8,80(sp)
ffffffffc02012b8:	e4e6                	sd	s9,72(sp)
ffffffffc02012ba:	e0ea                	sd	s10,64(sp)
ffffffffc02012bc:	fc6e                	sd	s11,56(sp)
ffffffffc02012be:	6a0020ef          	jal	ra,ffffffffc020395e <swapfs_init>
ffffffffc02012c2:	0000f797          	auipc	a5,0xf
ffffffffc02012c6:	24e78793          	addi	a5,a5,590 # ffffffffc0210510 <max_swap_offset>
ffffffffc02012ca:	6394                	ld	a3,0(a5)
ffffffffc02012cc:	010007b7          	lui	a5,0x1000
ffffffffc02012d0:	17e1                	addi	a5,a5,-8
ffffffffc02012d2:	ff968713          	addi	a4,a3,-7
ffffffffc02012d6:	42e7ea63          	bltu	a5,a4,ffffffffc020170a <swap_init+0x468>
ffffffffc02012da:	00008797          	auipc	a5,0x8
ffffffffc02012de:	d2678793          	addi	a5,a5,-730 # ffffffffc0209000 <swap_manager_clock>
ffffffffc02012e2:	6798                	ld	a4,8(a5)
ffffffffc02012e4:	0000f697          	auipc	a3,0xf
ffffffffc02012e8:	16f6ba23          	sd	a5,372(a3) # ffffffffc0210458 <sm>
ffffffffc02012ec:	9702                	jalr	a4
ffffffffc02012ee:	8b2a                	mv	s6,a0
ffffffffc02012f0:	c10d                	beqz	a0,ffffffffc0201312 <swap_init+0x70>
ffffffffc02012f2:	60ea                	ld	ra,152(sp)
ffffffffc02012f4:	644a                	ld	s0,144(sp)
ffffffffc02012f6:	855a                	mv	a0,s6
ffffffffc02012f8:	64aa                	ld	s1,136(sp)
ffffffffc02012fa:	690a                	ld	s2,128(sp)
ffffffffc02012fc:	79e6                	ld	s3,120(sp)
ffffffffc02012fe:	7a46                	ld	s4,112(sp)
ffffffffc0201300:	7aa6                	ld	s5,104(sp)
ffffffffc0201302:	7b06                	ld	s6,96(sp)
ffffffffc0201304:	6be6                	ld	s7,88(sp)
ffffffffc0201306:	6c46                	ld	s8,80(sp)
ffffffffc0201308:	6ca6                	ld	s9,72(sp)
ffffffffc020130a:	6d06                	ld	s10,64(sp)
ffffffffc020130c:	7de2                	ld	s11,56(sp)
ffffffffc020130e:	610d                	addi	sp,sp,160
ffffffffc0201310:	8082                	ret
ffffffffc0201312:	0000f797          	auipc	a5,0xf
ffffffffc0201316:	14678793          	addi	a5,a5,326 # ffffffffc0210458 <sm>
ffffffffc020131a:	639c                	ld	a5,0(a5)
ffffffffc020131c:	00004517          	auipc	a0,0x4
ffffffffc0201320:	acc50513          	addi	a0,a0,-1332 # ffffffffc0204de8 <commands+0xc48>
ffffffffc0201324:	0000f417          	auipc	s0,0xf
ffffffffc0201328:	22c40413          	addi	s0,s0,556 # ffffffffc0210550 <free_area>
ffffffffc020132c:	638c                	ld	a1,0(a5)
ffffffffc020132e:	4785                	li	a5,1
ffffffffc0201330:	0000f717          	auipc	a4,0xf
ffffffffc0201334:	12f72823          	sw	a5,304(a4) # ffffffffc0210460 <swap_init_ok>
ffffffffc0201338:	d87fe0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc020133c:	641c                	ld	a5,8(s0)
ffffffffc020133e:	2e878a63          	beq	a5,s0,ffffffffc0201632 <swap_init+0x390>
ffffffffc0201342:	fe87b703          	ld	a4,-24(a5)
ffffffffc0201346:	8305                	srli	a4,a4,0x1
ffffffffc0201348:	8b05                	andi	a4,a4,1
ffffffffc020134a:	2e070863          	beqz	a4,ffffffffc020163a <swap_init+0x398>
ffffffffc020134e:	4481                	li	s1,0
ffffffffc0201350:	4901                	li	s2,0
ffffffffc0201352:	a031                	j	ffffffffc020135e <swap_init+0xbc>
ffffffffc0201354:	fe87b703          	ld	a4,-24(a5)
ffffffffc0201358:	8b09                	andi	a4,a4,2
ffffffffc020135a:	2e070063          	beqz	a4,ffffffffc020163a <swap_init+0x398>
ffffffffc020135e:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201362:	679c                	ld	a5,8(a5)
ffffffffc0201364:	2905                	addiw	s2,s2,1
ffffffffc0201366:	9cb9                	addw	s1,s1,a4
ffffffffc0201368:	fe8796e3          	bne	a5,s0,ffffffffc0201354 <swap_init+0xb2>
ffffffffc020136c:	89a6                	mv	s3,s1
ffffffffc020136e:	652010ef          	jal	ra,ffffffffc02029c0 <nr_free_pages>
ffffffffc0201372:	5b351863          	bne	a0,s3,ffffffffc0201922 <swap_init+0x680>
ffffffffc0201376:	8626                	mv	a2,s1
ffffffffc0201378:	85ca                	mv	a1,s2
ffffffffc020137a:	00004517          	auipc	a0,0x4
ffffffffc020137e:	ab650513          	addi	a0,a0,-1354 # ffffffffc0204e30 <commands+0xc90>
ffffffffc0201382:	d3dfe0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc0201386:	f4eff0ef          	jal	ra,ffffffffc0200ad4 <mm_create>
ffffffffc020138a:	8baa                	mv	s7,a0
ffffffffc020138c:	50050b63          	beqz	a0,ffffffffc02018a2 <swap_init+0x600>
ffffffffc0201390:	0000f797          	auipc	a5,0xf
ffffffffc0201394:	0f078793          	addi	a5,a5,240 # ffffffffc0210480 <check_mm_struct>
ffffffffc0201398:	639c                	ld	a5,0(a5)
ffffffffc020139a:	52079463          	bnez	a5,ffffffffc02018c2 <swap_init+0x620>
ffffffffc020139e:	0000f797          	auipc	a5,0xf
ffffffffc02013a2:	0ca78793          	addi	a5,a5,202 # ffffffffc0210468 <boot_pgdir>
ffffffffc02013a6:	6398                	ld	a4,0(a5)
ffffffffc02013a8:	0000f797          	auipc	a5,0xf
ffffffffc02013ac:	0ca7bc23          	sd	a0,216(a5) # ffffffffc0210480 <check_mm_struct>
ffffffffc02013b0:	631c                	ld	a5,0(a4)
ffffffffc02013b2:	ec3a                	sd	a4,24(sp)
ffffffffc02013b4:	ed18                	sd	a4,24(a0)
ffffffffc02013b6:	52079663          	bnez	a5,ffffffffc02018e2 <swap_init+0x640>
ffffffffc02013ba:	6599                	lui	a1,0x6
ffffffffc02013bc:	460d                	li	a2,3
ffffffffc02013be:	6505                	lui	a0,0x1
ffffffffc02013c0:	f60ff0ef          	jal	ra,ffffffffc0200b20 <vma_create>
ffffffffc02013c4:	85aa                	mv	a1,a0
ffffffffc02013c6:	52050e63          	beqz	a0,ffffffffc0201902 <swap_init+0x660>
ffffffffc02013ca:	855e                	mv	a0,s7
ffffffffc02013cc:	fc0ff0ef          	jal	ra,ffffffffc0200b8c <insert_vma_struct>
ffffffffc02013d0:	00004517          	auipc	a0,0x4
ffffffffc02013d4:	aa050513          	addi	a0,a0,-1376 # ffffffffc0204e70 <commands+0xcd0>
ffffffffc02013d8:	ce7fe0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc02013dc:	018bb503          	ld	a0,24(s7)
ffffffffc02013e0:	4605                	li	a2,1
ffffffffc02013e2:	6585                	lui	a1,0x1
ffffffffc02013e4:	61c010ef          	jal	ra,ffffffffc0202a00 <get_pte>
ffffffffc02013e8:	40050d63          	beqz	a0,ffffffffc0201802 <swap_init+0x560>
ffffffffc02013ec:	00004517          	auipc	a0,0x4
ffffffffc02013f0:	ad450513          	addi	a0,a0,-1324 # ffffffffc0204ec0 <commands+0xd20>
ffffffffc02013f4:	0000fa17          	auipc	s4,0xf
ffffffffc02013f8:	094a0a13          	addi	s4,s4,148 # ffffffffc0210488 <check_rp>
ffffffffc02013fc:	cc3fe0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc0201400:	0000fa97          	auipc	s5,0xf
ffffffffc0201404:	0a8a8a93          	addi	s5,s5,168 # ffffffffc02104a8 <swap_in_seq_no>
ffffffffc0201408:	89d2                	mv	s3,s4
ffffffffc020140a:	4505                	li	a0,1
ffffffffc020140c:	4e6010ef          	jal	ra,ffffffffc02028f2 <alloc_pages>
ffffffffc0201410:	00a9b023          	sd	a0,0(s3)
ffffffffc0201414:	2a050b63          	beqz	a0,ffffffffc02016ca <swap_init+0x428>
ffffffffc0201418:	651c                	ld	a5,8(a0)
ffffffffc020141a:	8b89                	andi	a5,a5,2
ffffffffc020141c:	28079763          	bnez	a5,ffffffffc02016aa <swap_init+0x408>
ffffffffc0201420:	09a1                	addi	s3,s3,8
ffffffffc0201422:	ff5994e3          	bne	s3,s5,ffffffffc020140a <swap_init+0x168>
ffffffffc0201426:	601c                	ld	a5,0(s0)
ffffffffc0201428:	00843983          	ld	s3,8(s0)
ffffffffc020142c:	0000fd17          	auipc	s10,0xf
ffffffffc0201430:	05cd0d13          	addi	s10,s10,92 # ffffffffc0210488 <check_rp>
ffffffffc0201434:	f03e                	sd	a5,32(sp)
ffffffffc0201436:	481c                	lw	a5,16(s0)
ffffffffc0201438:	f43e                	sd	a5,40(sp)
ffffffffc020143a:	0000f797          	auipc	a5,0xf
ffffffffc020143e:	1087bf23          	sd	s0,286(a5) # ffffffffc0210558 <free_area+0x8>
ffffffffc0201442:	0000f797          	auipc	a5,0xf
ffffffffc0201446:	1087b723          	sd	s0,270(a5) # ffffffffc0210550 <free_area>
ffffffffc020144a:	0000f797          	auipc	a5,0xf
ffffffffc020144e:	1007ab23          	sw	zero,278(a5) # ffffffffc0210560 <free_area+0x10>
ffffffffc0201452:	000d3503          	ld	a0,0(s10)
ffffffffc0201456:	4585                	li	a1,1
ffffffffc0201458:	0d21                	addi	s10,s10,8
ffffffffc020145a:	520010ef          	jal	ra,ffffffffc020297a <free_pages>
ffffffffc020145e:	ff5d1ae3          	bne	s10,s5,ffffffffc0201452 <swap_init+0x1b0>
ffffffffc0201462:	01042d03          	lw	s10,16(s0)
ffffffffc0201466:	4791                	li	a5,4
ffffffffc0201468:	36fd1d63          	bne	s10,a5,ffffffffc02017e2 <swap_init+0x540>
ffffffffc020146c:	00004517          	auipc	a0,0x4
ffffffffc0201470:	adc50513          	addi	a0,a0,-1316 # ffffffffc0204f48 <commands+0xda8>
ffffffffc0201474:	c4bfe0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc0201478:	6685                	lui	a3,0x1
ffffffffc020147a:	0000f797          	auipc	a5,0xf
ffffffffc020147e:	fc07ab23          	sw	zero,-42(a5) # ffffffffc0210450 <pgfault_num>
ffffffffc0201482:	4629                	li	a2,10
ffffffffc0201484:	0000f797          	auipc	a5,0xf
ffffffffc0201488:	fcc78793          	addi	a5,a5,-52 # ffffffffc0210450 <pgfault_num>
ffffffffc020148c:	00c68023          	sb	a2,0(a3) # 1000 <BASE_ADDRESS-0xffffffffc01ff000>
ffffffffc0201490:	4398                	lw	a4,0(a5)
ffffffffc0201492:	4585                	li	a1,1
ffffffffc0201494:	2701                	sext.w	a4,a4
ffffffffc0201496:	30b71663          	bne	a4,a1,ffffffffc02017a2 <swap_init+0x500>
ffffffffc020149a:	00c68823          	sb	a2,16(a3)
ffffffffc020149e:	4394                	lw	a3,0(a5)
ffffffffc02014a0:	2681                	sext.w	a3,a3
ffffffffc02014a2:	32e69063          	bne	a3,a4,ffffffffc02017c2 <swap_init+0x520>
ffffffffc02014a6:	6689                	lui	a3,0x2
ffffffffc02014a8:	462d                	li	a2,11
ffffffffc02014aa:	00c68023          	sb	a2,0(a3) # 2000 <BASE_ADDRESS-0xffffffffc01fe000>
ffffffffc02014ae:	4398                	lw	a4,0(a5)
ffffffffc02014b0:	4589                	li	a1,2
ffffffffc02014b2:	2701                	sext.w	a4,a4
ffffffffc02014b4:	26b71763          	bne	a4,a1,ffffffffc0201722 <swap_init+0x480>
ffffffffc02014b8:	00c68823          	sb	a2,16(a3)
ffffffffc02014bc:	4394                	lw	a3,0(a5)
ffffffffc02014be:	2681                	sext.w	a3,a3
ffffffffc02014c0:	28e69163          	bne	a3,a4,ffffffffc0201742 <swap_init+0x4a0>
ffffffffc02014c4:	668d                	lui	a3,0x3
ffffffffc02014c6:	4631                	li	a2,12
ffffffffc02014c8:	00c68023          	sb	a2,0(a3) # 3000 <BASE_ADDRESS-0xffffffffc01fd000>
ffffffffc02014cc:	4398                	lw	a4,0(a5)
ffffffffc02014ce:	458d                	li	a1,3
ffffffffc02014d0:	2701                	sext.w	a4,a4
ffffffffc02014d2:	28b71863          	bne	a4,a1,ffffffffc0201762 <swap_init+0x4c0>
ffffffffc02014d6:	00c68823          	sb	a2,16(a3)
ffffffffc02014da:	4394                	lw	a3,0(a5)
ffffffffc02014dc:	2681                	sext.w	a3,a3
ffffffffc02014de:	2ae69263          	bne	a3,a4,ffffffffc0201782 <swap_init+0x4e0>
ffffffffc02014e2:	6691                	lui	a3,0x4
ffffffffc02014e4:	4635                	li	a2,13
ffffffffc02014e6:	00c68023          	sb	a2,0(a3) # 4000 <BASE_ADDRESS-0xffffffffc01fc000>
ffffffffc02014ea:	4398                	lw	a4,0(a5)
ffffffffc02014ec:	2701                	sext.w	a4,a4
ffffffffc02014ee:	33a71a63          	bne	a4,s10,ffffffffc0201822 <swap_init+0x580>
ffffffffc02014f2:	00c68823          	sb	a2,16(a3)
ffffffffc02014f6:	439c                	lw	a5,0(a5)
ffffffffc02014f8:	2781                	sext.w	a5,a5
ffffffffc02014fa:	34e79463          	bne	a5,a4,ffffffffc0201842 <swap_init+0x5a0>
ffffffffc02014fe:	481c                	lw	a5,16(s0)
ffffffffc0201500:	36079163          	bnez	a5,ffffffffc0201862 <swap_init+0x5c0>
ffffffffc0201504:	0000f797          	auipc	a5,0xf
ffffffffc0201508:	fa478793          	addi	a5,a5,-92 # ffffffffc02104a8 <swap_in_seq_no>
ffffffffc020150c:	0000f717          	auipc	a4,0xf
ffffffffc0201510:	fc470713          	addi	a4,a4,-60 # ffffffffc02104d0 <swap_out_seq_no>
ffffffffc0201514:	0000f617          	auipc	a2,0xf
ffffffffc0201518:	fbc60613          	addi	a2,a2,-68 # ffffffffc02104d0 <swap_out_seq_no>
ffffffffc020151c:	56fd                	li	a3,-1
ffffffffc020151e:	c394                	sw	a3,0(a5)
ffffffffc0201520:	c314                	sw	a3,0(a4)
ffffffffc0201522:	0791                	addi	a5,a5,4
ffffffffc0201524:	0711                	addi	a4,a4,4
ffffffffc0201526:	fec79ce3          	bne	a5,a2,ffffffffc020151e <swap_init+0x27c>
ffffffffc020152a:	0000f697          	auipc	a3,0xf
ffffffffc020152e:	00668693          	addi	a3,a3,6 # ffffffffc0210530 <check_ptep>
ffffffffc0201532:	0000f817          	auipc	a6,0xf
ffffffffc0201536:	f5680813          	addi	a6,a6,-170 # ffffffffc0210488 <check_rp>
ffffffffc020153a:	6c05                	lui	s8,0x1
ffffffffc020153c:	0000fc97          	auipc	s9,0xf
ffffffffc0201540:	f34c8c93          	addi	s9,s9,-204 # ffffffffc0210470 <npage>
ffffffffc0201544:	0000fd97          	auipc	s11,0xf
ffffffffc0201548:	03cd8d93          	addi	s11,s11,60 # ffffffffc0210580 <pages>
ffffffffc020154c:	00005d17          	auipc	s10,0x5
ffffffffc0201550:	884d0d13          	addi	s10,s10,-1916 # ffffffffc0205dd0 <nbase>
ffffffffc0201554:	6562                	ld	a0,24(sp)
ffffffffc0201556:	0006b023          	sd	zero,0(a3)
ffffffffc020155a:	4601                	li	a2,0
ffffffffc020155c:	85e2                	mv	a1,s8
ffffffffc020155e:	e842                	sd	a6,16(sp)
ffffffffc0201560:	e436                	sd	a3,8(sp)
ffffffffc0201562:	49e010ef          	jal	ra,ffffffffc0202a00 <get_pte>
ffffffffc0201566:	66a2                	ld	a3,8(sp)
ffffffffc0201568:	6842                	ld	a6,16(sp)
ffffffffc020156a:	e288                	sd	a0,0(a3)
ffffffffc020156c:	16050f63          	beqz	a0,ffffffffc02016ea <swap_init+0x448>
ffffffffc0201570:	611c                	ld	a5,0(a0)
ffffffffc0201572:	0017f613          	andi	a2,a5,1
ffffffffc0201576:	10060263          	beqz	a2,ffffffffc020167a <swap_init+0x3d8>
ffffffffc020157a:	000cb603          	ld	a2,0(s9)
ffffffffc020157e:	078a                	slli	a5,a5,0x2
ffffffffc0201580:	83b1                	srli	a5,a5,0xc
ffffffffc0201582:	10c7f863          	bgeu	a5,a2,ffffffffc0201692 <swap_init+0x3f0>
ffffffffc0201586:	000d3603          	ld	a2,0(s10)
ffffffffc020158a:	000db583          	ld	a1,0(s11)
ffffffffc020158e:	00083503          	ld	a0,0(a6)
ffffffffc0201592:	8f91                	sub	a5,a5,a2
ffffffffc0201594:	00379613          	slli	a2,a5,0x3
ffffffffc0201598:	97b2                	add	a5,a5,a2
ffffffffc020159a:	078e                	slli	a5,a5,0x3
ffffffffc020159c:	97ae                	add	a5,a5,a1
ffffffffc020159e:	0af51e63          	bne	a0,a5,ffffffffc020165a <swap_init+0x3b8>
ffffffffc02015a2:	6785                	lui	a5,0x1
ffffffffc02015a4:	9c3e                	add	s8,s8,a5
ffffffffc02015a6:	6795                	lui	a5,0x5
ffffffffc02015a8:	06a1                	addi	a3,a3,8
ffffffffc02015aa:	0821                	addi	a6,a6,8
ffffffffc02015ac:	fafc14e3          	bne	s8,a5,ffffffffc0201554 <swap_init+0x2b2>
ffffffffc02015b0:	00004517          	auipc	a0,0x4
ffffffffc02015b4:	a7850513          	addi	a0,a0,-1416 # ffffffffc0205028 <commands+0xe88>
ffffffffc02015b8:	b07fe0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc02015bc:	0000f797          	auipc	a5,0xf
ffffffffc02015c0:	e9c78793          	addi	a5,a5,-356 # ffffffffc0210458 <sm>
ffffffffc02015c4:	639c                	ld	a5,0(a5)
ffffffffc02015c6:	7f9c                	ld	a5,56(a5)
ffffffffc02015c8:	9782                	jalr	a5
ffffffffc02015ca:	2a051c63          	bnez	a0,ffffffffc0201882 <swap_init+0x5e0>
ffffffffc02015ce:	000a3503          	ld	a0,0(s4)
ffffffffc02015d2:	4585                	li	a1,1
ffffffffc02015d4:	0a21                	addi	s4,s4,8
ffffffffc02015d6:	3a4010ef          	jal	ra,ffffffffc020297a <free_pages>
ffffffffc02015da:	ff5a1ae3          	bne	s4,s5,ffffffffc02015ce <swap_init+0x32c>
ffffffffc02015de:	855e                	mv	a0,s7
ffffffffc02015e0:	e7aff0ef          	jal	ra,ffffffffc0200c5a <mm_destroy>
ffffffffc02015e4:	77a2                	ld	a5,40(sp)
ffffffffc02015e6:	0000f717          	auipc	a4,0xf
ffffffffc02015ea:	f6f72d23          	sw	a5,-134(a4) # ffffffffc0210560 <free_area+0x10>
ffffffffc02015ee:	7782                	ld	a5,32(sp)
ffffffffc02015f0:	0000f717          	auipc	a4,0xf
ffffffffc02015f4:	f6f73023          	sd	a5,-160(a4) # ffffffffc0210550 <free_area>
ffffffffc02015f8:	0000f797          	auipc	a5,0xf
ffffffffc02015fc:	f737b023          	sd	s3,-160(a5) # ffffffffc0210558 <free_area+0x8>
ffffffffc0201600:	00898a63          	beq	s3,s0,ffffffffc0201614 <swap_init+0x372>
ffffffffc0201604:	ff89a783          	lw	a5,-8(s3)
ffffffffc0201608:	0089b983          	ld	s3,8(s3)
ffffffffc020160c:	397d                	addiw	s2,s2,-1
ffffffffc020160e:	9c9d                	subw	s1,s1,a5
ffffffffc0201610:	fe899ae3          	bne	s3,s0,ffffffffc0201604 <swap_init+0x362>
ffffffffc0201614:	8626                	mv	a2,s1
ffffffffc0201616:	85ca                	mv	a1,s2
ffffffffc0201618:	00004517          	auipc	a0,0x4
ffffffffc020161c:	a4050513          	addi	a0,a0,-1472 # ffffffffc0205058 <commands+0xeb8>
ffffffffc0201620:	a9ffe0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc0201624:	00004517          	auipc	a0,0x4
ffffffffc0201628:	a5450513          	addi	a0,a0,-1452 # ffffffffc0205078 <commands+0xed8>
ffffffffc020162c:	a93fe0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc0201630:	b1c9                	j	ffffffffc02012f2 <swap_init+0x50>
ffffffffc0201632:	4481                	li	s1,0
ffffffffc0201634:	4901                	li	s2,0
ffffffffc0201636:	4981                	li	s3,0
ffffffffc0201638:	bb1d                	j	ffffffffc020136e <swap_init+0xcc>
ffffffffc020163a:	00003697          	auipc	a3,0x3
ffffffffc020163e:	7c668693          	addi	a3,a3,1990 # ffffffffc0204e00 <commands+0xc60>
ffffffffc0201642:	00003617          	auipc	a2,0x3
ffffffffc0201646:	3b660613          	addi	a2,a2,950 # ffffffffc02049f8 <commands+0x858>
ffffffffc020164a:	0ba00593          	li	a1,186
ffffffffc020164e:	00003517          	auipc	a0,0x3
ffffffffc0201652:	78a50513          	addi	a0,a0,1930 # ffffffffc0204dd8 <commands+0xc38>
ffffffffc0201656:	aaffe0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc020165a:	00004697          	auipc	a3,0x4
ffffffffc020165e:	9a668693          	addi	a3,a3,-1626 # ffffffffc0205000 <commands+0xe60>
ffffffffc0201662:	00003617          	auipc	a2,0x3
ffffffffc0201666:	39660613          	addi	a2,a2,918 # ffffffffc02049f8 <commands+0x858>
ffffffffc020166a:	0fa00593          	li	a1,250
ffffffffc020166e:	00003517          	auipc	a0,0x3
ffffffffc0201672:	76a50513          	addi	a0,a0,1898 # ffffffffc0204dd8 <commands+0xc38>
ffffffffc0201676:	a8ffe0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc020167a:	00004617          	auipc	a2,0x4
ffffffffc020167e:	95e60613          	addi	a2,a2,-1698 # ffffffffc0204fd8 <commands+0xe38>
ffffffffc0201682:	07000593          	li	a1,112
ffffffffc0201686:	00003517          	auipc	a0,0x3
ffffffffc020168a:	68a50513          	addi	a0,a0,1674 # ffffffffc0204d10 <commands+0xb70>
ffffffffc020168e:	a77fe0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0201692:	00003617          	auipc	a2,0x3
ffffffffc0201696:	65e60613          	addi	a2,a2,1630 # ffffffffc0204cf0 <commands+0xb50>
ffffffffc020169a:	06500593          	li	a1,101
ffffffffc020169e:	00003517          	auipc	a0,0x3
ffffffffc02016a2:	67250513          	addi	a0,a0,1650 # ffffffffc0204d10 <commands+0xb70>
ffffffffc02016a6:	a5ffe0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc02016aa:	00004697          	auipc	a3,0x4
ffffffffc02016ae:	85668693          	addi	a3,a3,-1962 # ffffffffc0204f00 <commands+0xd60>
ffffffffc02016b2:	00003617          	auipc	a2,0x3
ffffffffc02016b6:	34660613          	addi	a2,a2,838 # ffffffffc02049f8 <commands+0x858>
ffffffffc02016ba:	0db00593          	li	a1,219
ffffffffc02016be:	00003517          	auipc	a0,0x3
ffffffffc02016c2:	71a50513          	addi	a0,a0,1818 # ffffffffc0204dd8 <commands+0xc38>
ffffffffc02016c6:	a3ffe0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc02016ca:	00004697          	auipc	a3,0x4
ffffffffc02016ce:	81e68693          	addi	a3,a3,-2018 # ffffffffc0204ee8 <commands+0xd48>
ffffffffc02016d2:	00003617          	auipc	a2,0x3
ffffffffc02016d6:	32660613          	addi	a2,a2,806 # ffffffffc02049f8 <commands+0x858>
ffffffffc02016da:	0da00593          	li	a1,218
ffffffffc02016de:	00003517          	auipc	a0,0x3
ffffffffc02016e2:	6fa50513          	addi	a0,a0,1786 # ffffffffc0204dd8 <commands+0xc38>
ffffffffc02016e6:	a1ffe0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc02016ea:	00004697          	auipc	a3,0x4
ffffffffc02016ee:	8d668693          	addi	a3,a3,-1834 # ffffffffc0204fc0 <commands+0xe20>
ffffffffc02016f2:	00003617          	auipc	a2,0x3
ffffffffc02016f6:	30660613          	addi	a2,a2,774 # ffffffffc02049f8 <commands+0x858>
ffffffffc02016fa:	0f900593          	li	a1,249
ffffffffc02016fe:	00003517          	auipc	a0,0x3
ffffffffc0201702:	6da50513          	addi	a0,a0,1754 # ffffffffc0204dd8 <commands+0xc38>
ffffffffc0201706:	9fffe0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc020170a:	00003617          	auipc	a2,0x3
ffffffffc020170e:	6ae60613          	addi	a2,a2,1710 # ffffffffc0204db8 <commands+0xc18>
ffffffffc0201712:	02700593          	li	a1,39
ffffffffc0201716:	00003517          	auipc	a0,0x3
ffffffffc020171a:	6c250513          	addi	a0,a0,1730 # ffffffffc0204dd8 <commands+0xc38>
ffffffffc020171e:	9e7fe0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0201722:	00004697          	auipc	a3,0x4
ffffffffc0201726:	85e68693          	addi	a3,a3,-1954 # ffffffffc0204f80 <commands+0xde0>
ffffffffc020172a:	00003617          	auipc	a2,0x3
ffffffffc020172e:	2ce60613          	addi	a2,a2,718 # ffffffffc02049f8 <commands+0x858>
ffffffffc0201732:	09500593          	li	a1,149
ffffffffc0201736:	00003517          	auipc	a0,0x3
ffffffffc020173a:	6a250513          	addi	a0,a0,1698 # ffffffffc0204dd8 <commands+0xc38>
ffffffffc020173e:	9c7fe0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0201742:	00004697          	auipc	a3,0x4
ffffffffc0201746:	83e68693          	addi	a3,a3,-1986 # ffffffffc0204f80 <commands+0xde0>
ffffffffc020174a:	00003617          	auipc	a2,0x3
ffffffffc020174e:	2ae60613          	addi	a2,a2,686 # ffffffffc02049f8 <commands+0x858>
ffffffffc0201752:	09700593          	li	a1,151
ffffffffc0201756:	00003517          	auipc	a0,0x3
ffffffffc020175a:	68250513          	addi	a0,a0,1666 # ffffffffc0204dd8 <commands+0xc38>
ffffffffc020175e:	9a7fe0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0201762:	00004697          	auipc	a3,0x4
ffffffffc0201766:	82e68693          	addi	a3,a3,-2002 # ffffffffc0204f90 <commands+0xdf0>
ffffffffc020176a:	00003617          	auipc	a2,0x3
ffffffffc020176e:	28e60613          	addi	a2,a2,654 # ffffffffc02049f8 <commands+0x858>
ffffffffc0201772:	09900593          	li	a1,153
ffffffffc0201776:	00003517          	auipc	a0,0x3
ffffffffc020177a:	66250513          	addi	a0,a0,1634 # ffffffffc0204dd8 <commands+0xc38>
ffffffffc020177e:	987fe0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0201782:	00004697          	auipc	a3,0x4
ffffffffc0201786:	80e68693          	addi	a3,a3,-2034 # ffffffffc0204f90 <commands+0xdf0>
ffffffffc020178a:	00003617          	auipc	a2,0x3
ffffffffc020178e:	26e60613          	addi	a2,a2,622 # ffffffffc02049f8 <commands+0x858>
ffffffffc0201792:	09b00593          	li	a1,155
ffffffffc0201796:	00003517          	auipc	a0,0x3
ffffffffc020179a:	64250513          	addi	a0,a0,1602 # ffffffffc0204dd8 <commands+0xc38>
ffffffffc020179e:	967fe0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc02017a2:	00003697          	auipc	a3,0x3
ffffffffc02017a6:	7ce68693          	addi	a3,a3,1998 # ffffffffc0204f70 <commands+0xdd0>
ffffffffc02017aa:	00003617          	auipc	a2,0x3
ffffffffc02017ae:	24e60613          	addi	a2,a2,590 # ffffffffc02049f8 <commands+0x858>
ffffffffc02017b2:	09100593          	li	a1,145
ffffffffc02017b6:	00003517          	auipc	a0,0x3
ffffffffc02017ba:	62250513          	addi	a0,a0,1570 # ffffffffc0204dd8 <commands+0xc38>
ffffffffc02017be:	947fe0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc02017c2:	00003697          	auipc	a3,0x3
ffffffffc02017c6:	7ae68693          	addi	a3,a3,1966 # ffffffffc0204f70 <commands+0xdd0>
ffffffffc02017ca:	00003617          	auipc	a2,0x3
ffffffffc02017ce:	22e60613          	addi	a2,a2,558 # ffffffffc02049f8 <commands+0x858>
ffffffffc02017d2:	09300593          	li	a1,147
ffffffffc02017d6:	00003517          	auipc	a0,0x3
ffffffffc02017da:	60250513          	addi	a0,a0,1538 # ffffffffc0204dd8 <commands+0xc38>
ffffffffc02017de:	927fe0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc02017e2:	00003697          	auipc	a3,0x3
ffffffffc02017e6:	73e68693          	addi	a3,a3,1854 # ffffffffc0204f20 <commands+0xd80>
ffffffffc02017ea:	00003617          	auipc	a2,0x3
ffffffffc02017ee:	20e60613          	addi	a2,a2,526 # ffffffffc02049f8 <commands+0x858>
ffffffffc02017f2:	0e800593          	li	a1,232
ffffffffc02017f6:	00003517          	auipc	a0,0x3
ffffffffc02017fa:	5e250513          	addi	a0,a0,1506 # ffffffffc0204dd8 <commands+0xc38>
ffffffffc02017fe:	907fe0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0201802:	00003697          	auipc	a3,0x3
ffffffffc0201806:	6a668693          	addi	a3,a3,1702 # ffffffffc0204ea8 <commands+0xd08>
ffffffffc020180a:	00003617          	auipc	a2,0x3
ffffffffc020180e:	1ee60613          	addi	a2,a2,494 # ffffffffc02049f8 <commands+0x858>
ffffffffc0201812:	0d500593          	li	a1,213
ffffffffc0201816:	00003517          	auipc	a0,0x3
ffffffffc020181a:	5c250513          	addi	a0,a0,1474 # ffffffffc0204dd8 <commands+0xc38>
ffffffffc020181e:	8e7fe0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0201822:	00003697          	auipc	a3,0x3
ffffffffc0201826:	77e68693          	addi	a3,a3,1918 # ffffffffc0204fa0 <commands+0xe00>
ffffffffc020182a:	00003617          	auipc	a2,0x3
ffffffffc020182e:	1ce60613          	addi	a2,a2,462 # ffffffffc02049f8 <commands+0x858>
ffffffffc0201832:	09d00593          	li	a1,157
ffffffffc0201836:	00003517          	auipc	a0,0x3
ffffffffc020183a:	5a250513          	addi	a0,a0,1442 # ffffffffc0204dd8 <commands+0xc38>
ffffffffc020183e:	8c7fe0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0201842:	00003697          	auipc	a3,0x3
ffffffffc0201846:	75e68693          	addi	a3,a3,1886 # ffffffffc0204fa0 <commands+0xe00>
ffffffffc020184a:	00003617          	auipc	a2,0x3
ffffffffc020184e:	1ae60613          	addi	a2,a2,430 # ffffffffc02049f8 <commands+0x858>
ffffffffc0201852:	09f00593          	li	a1,159
ffffffffc0201856:	00003517          	auipc	a0,0x3
ffffffffc020185a:	58250513          	addi	a0,a0,1410 # ffffffffc0204dd8 <commands+0xc38>
ffffffffc020185e:	8a7fe0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0201862:	00003697          	auipc	a3,0x3
ffffffffc0201866:	74e68693          	addi	a3,a3,1870 # ffffffffc0204fb0 <commands+0xe10>
ffffffffc020186a:	00003617          	auipc	a2,0x3
ffffffffc020186e:	18e60613          	addi	a2,a2,398 # ffffffffc02049f8 <commands+0x858>
ffffffffc0201872:	0f100593          	li	a1,241
ffffffffc0201876:	00003517          	auipc	a0,0x3
ffffffffc020187a:	56250513          	addi	a0,a0,1378 # ffffffffc0204dd8 <commands+0xc38>
ffffffffc020187e:	887fe0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0201882:	00003697          	auipc	a3,0x3
ffffffffc0201886:	7ce68693          	addi	a3,a3,1998 # ffffffffc0205050 <commands+0xeb0>
ffffffffc020188a:	00003617          	auipc	a2,0x3
ffffffffc020188e:	16e60613          	addi	a2,a2,366 # ffffffffc02049f8 <commands+0x858>
ffffffffc0201892:	10000593          	li	a1,256
ffffffffc0201896:	00003517          	auipc	a0,0x3
ffffffffc020189a:	54250513          	addi	a0,a0,1346 # ffffffffc0204dd8 <commands+0xc38>
ffffffffc020189e:	867fe0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc02018a2:	00003697          	auipc	a3,0x3
ffffffffc02018a6:	25e68693          	addi	a3,a3,606 # ffffffffc0204b00 <commands+0x960>
ffffffffc02018aa:	00003617          	auipc	a2,0x3
ffffffffc02018ae:	14e60613          	addi	a2,a2,334 # ffffffffc02049f8 <commands+0x858>
ffffffffc02018b2:	0c200593          	li	a1,194
ffffffffc02018b6:	00003517          	auipc	a0,0x3
ffffffffc02018ba:	52250513          	addi	a0,a0,1314 # ffffffffc0204dd8 <commands+0xc38>
ffffffffc02018be:	847fe0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc02018c2:	00003697          	auipc	a3,0x3
ffffffffc02018c6:	59668693          	addi	a3,a3,1430 # ffffffffc0204e58 <commands+0xcb8>
ffffffffc02018ca:	00003617          	auipc	a2,0x3
ffffffffc02018ce:	12e60613          	addi	a2,a2,302 # ffffffffc02049f8 <commands+0x858>
ffffffffc02018d2:	0c500593          	li	a1,197
ffffffffc02018d6:	00003517          	auipc	a0,0x3
ffffffffc02018da:	50250513          	addi	a0,a0,1282 # ffffffffc0204dd8 <commands+0xc38>
ffffffffc02018de:	827fe0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc02018e2:	00003697          	auipc	a3,0x3
ffffffffc02018e6:	3ce68693          	addi	a3,a3,974 # ffffffffc0204cb0 <commands+0xb10>
ffffffffc02018ea:	00003617          	auipc	a2,0x3
ffffffffc02018ee:	10e60613          	addi	a2,a2,270 # ffffffffc02049f8 <commands+0x858>
ffffffffc02018f2:	0ca00593          	li	a1,202
ffffffffc02018f6:	00003517          	auipc	a0,0x3
ffffffffc02018fa:	4e250513          	addi	a0,a0,1250 # ffffffffc0204dd8 <commands+0xc38>
ffffffffc02018fe:	807fe0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0201902:	00003697          	auipc	a3,0x3
ffffffffc0201906:	45668693          	addi	a3,a3,1110 # ffffffffc0204d58 <commands+0xbb8>
ffffffffc020190a:	00003617          	auipc	a2,0x3
ffffffffc020190e:	0ee60613          	addi	a2,a2,238 # ffffffffc02049f8 <commands+0x858>
ffffffffc0201912:	0cd00593          	li	a1,205
ffffffffc0201916:	00003517          	auipc	a0,0x3
ffffffffc020191a:	4c250513          	addi	a0,a0,1218 # ffffffffc0204dd8 <commands+0xc38>
ffffffffc020191e:	fe6fe0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0201922:	00003697          	auipc	a3,0x3
ffffffffc0201926:	4ee68693          	addi	a3,a3,1262 # ffffffffc0204e10 <commands+0xc70>
ffffffffc020192a:	00003617          	auipc	a2,0x3
ffffffffc020192e:	0ce60613          	addi	a2,a2,206 # ffffffffc02049f8 <commands+0x858>
ffffffffc0201932:	0bd00593          	li	a1,189
ffffffffc0201936:	00003517          	auipc	a0,0x3
ffffffffc020193a:	4a250513          	addi	a0,a0,1186 # ffffffffc0204dd8 <commands+0xc38>
ffffffffc020193e:	fc6fe0ef          	jal	ra,ffffffffc0200104 <__panic>

ffffffffc0201942 <swap_init_mm>:
ffffffffc0201942:	0000f797          	auipc	a5,0xf
ffffffffc0201946:	b1678793          	addi	a5,a5,-1258 # ffffffffc0210458 <sm>
ffffffffc020194a:	639c                	ld	a5,0(a5)
ffffffffc020194c:	0107b303          	ld	t1,16(a5)
ffffffffc0201950:	8302                	jr	t1

ffffffffc0201952 <swap_map_swappable>:
ffffffffc0201952:	0000f797          	auipc	a5,0xf
ffffffffc0201956:	b0678793          	addi	a5,a5,-1274 # ffffffffc0210458 <sm>
ffffffffc020195a:	639c                	ld	a5,0(a5)
ffffffffc020195c:	0207b303          	ld	t1,32(a5)
ffffffffc0201960:	8302                	jr	t1

ffffffffc0201962 <swap_out>:
ffffffffc0201962:	711d                	addi	sp,sp,-96
ffffffffc0201964:	ec86                	sd	ra,88(sp)
ffffffffc0201966:	e8a2                	sd	s0,80(sp)
ffffffffc0201968:	e4a6                	sd	s1,72(sp)
ffffffffc020196a:	e0ca                	sd	s2,64(sp)
ffffffffc020196c:	fc4e                	sd	s3,56(sp)
ffffffffc020196e:	f852                	sd	s4,48(sp)
ffffffffc0201970:	f456                	sd	s5,40(sp)
ffffffffc0201972:	f05a                	sd	s6,32(sp)
ffffffffc0201974:	ec5e                	sd	s7,24(sp)
ffffffffc0201976:	e862                	sd	s8,16(sp)
ffffffffc0201978:	cde9                	beqz	a1,ffffffffc0201a52 <swap_out+0xf0>
ffffffffc020197a:	8ab2                	mv	s5,a2
ffffffffc020197c:	892a                	mv	s2,a0
ffffffffc020197e:	8a2e                	mv	s4,a1
ffffffffc0201980:	4401                	li	s0,0
ffffffffc0201982:	0000f997          	auipc	s3,0xf
ffffffffc0201986:	ad698993          	addi	s3,s3,-1322 # ffffffffc0210458 <sm>
ffffffffc020198a:	00003b17          	auipc	s6,0x3
ffffffffc020198e:	76eb0b13          	addi	s6,s6,1902 # ffffffffc02050f8 <commands+0xf58>
ffffffffc0201992:	00003b97          	auipc	s7,0x3
ffffffffc0201996:	74eb8b93          	addi	s7,s7,1870 # ffffffffc02050e0 <commands+0xf40>
ffffffffc020199a:	a825                	j	ffffffffc02019d2 <swap_out+0x70>
ffffffffc020199c:	67a2                	ld	a5,8(sp)
ffffffffc020199e:	8626                	mv	a2,s1
ffffffffc02019a0:	85a2                	mv	a1,s0
ffffffffc02019a2:	63b4                	ld	a3,64(a5)
ffffffffc02019a4:	855a                	mv	a0,s6
ffffffffc02019a6:	2405                	addiw	s0,s0,1
ffffffffc02019a8:	82b1                	srli	a3,a3,0xc
ffffffffc02019aa:	0685                	addi	a3,a3,1
ffffffffc02019ac:	f12fe0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc02019b0:	6522                	ld	a0,8(sp)
ffffffffc02019b2:	4585                	li	a1,1
ffffffffc02019b4:	613c                	ld	a5,64(a0)
ffffffffc02019b6:	83b1                	srli	a5,a5,0xc
ffffffffc02019b8:	0785                	addi	a5,a5,1
ffffffffc02019ba:	07a2                	slli	a5,a5,0x8
ffffffffc02019bc:	00fc3023          	sd	a5,0(s8) # 1000 <BASE_ADDRESS-0xffffffffc01ff000>
ffffffffc02019c0:	7bb000ef          	jal	ra,ffffffffc020297a <free_pages>
ffffffffc02019c4:	01893503          	ld	a0,24(s2)
ffffffffc02019c8:	85a6                	mv	a1,s1
ffffffffc02019ca:	57b010ef          	jal	ra,ffffffffc0203744 <tlb_invalidate>
ffffffffc02019ce:	048a0d63          	beq	s4,s0,ffffffffc0201a28 <swap_out+0xc6>
ffffffffc02019d2:	0009b783          	ld	a5,0(s3)
ffffffffc02019d6:	8656                	mv	a2,s5
ffffffffc02019d8:	002c                	addi	a1,sp,8
ffffffffc02019da:	7b9c                	ld	a5,48(a5)
ffffffffc02019dc:	854a                	mv	a0,s2
ffffffffc02019de:	9782                	jalr	a5
ffffffffc02019e0:	e12d                	bnez	a0,ffffffffc0201a42 <swap_out+0xe0>
ffffffffc02019e2:	67a2                	ld	a5,8(sp)
ffffffffc02019e4:	01893503          	ld	a0,24(s2)
ffffffffc02019e8:	4601                	li	a2,0
ffffffffc02019ea:	63a4                	ld	s1,64(a5)
ffffffffc02019ec:	85a6                	mv	a1,s1
ffffffffc02019ee:	012010ef          	jal	ra,ffffffffc0202a00 <get_pte>
ffffffffc02019f2:	611c                	ld	a5,0(a0)
ffffffffc02019f4:	8c2a                	mv	s8,a0
ffffffffc02019f6:	8b85                	andi	a5,a5,1
ffffffffc02019f8:	cfb9                	beqz	a5,ffffffffc0201a56 <swap_out+0xf4>
ffffffffc02019fa:	65a2                	ld	a1,8(sp)
ffffffffc02019fc:	61bc                	ld	a5,64(a1)
ffffffffc02019fe:	83b1                	srli	a5,a5,0xc
ffffffffc0201a00:	00178513          	addi	a0,a5,1
ffffffffc0201a04:	0522                	slli	a0,a0,0x8
ffffffffc0201a06:	036020ef          	jal	ra,ffffffffc0203a3c <swapfs_write>
ffffffffc0201a0a:	d949                	beqz	a0,ffffffffc020199c <swap_out+0x3a>
ffffffffc0201a0c:	855e                	mv	a0,s7
ffffffffc0201a0e:	eb0fe0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc0201a12:	0009b783          	ld	a5,0(s3)
ffffffffc0201a16:	6622                	ld	a2,8(sp)
ffffffffc0201a18:	4681                	li	a3,0
ffffffffc0201a1a:	739c                	ld	a5,32(a5)
ffffffffc0201a1c:	85a6                	mv	a1,s1
ffffffffc0201a1e:	854a                	mv	a0,s2
ffffffffc0201a20:	2405                	addiw	s0,s0,1
ffffffffc0201a22:	9782                	jalr	a5
ffffffffc0201a24:	fa8a17e3          	bne	s4,s0,ffffffffc02019d2 <swap_out+0x70>
ffffffffc0201a28:	8522                	mv	a0,s0
ffffffffc0201a2a:	60e6                	ld	ra,88(sp)
ffffffffc0201a2c:	6446                	ld	s0,80(sp)
ffffffffc0201a2e:	64a6                	ld	s1,72(sp)
ffffffffc0201a30:	6906                	ld	s2,64(sp)
ffffffffc0201a32:	79e2                	ld	s3,56(sp)
ffffffffc0201a34:	7a42                	ld	s4,48(sp)
ffffffffc0201a36:	7aa2                	ld	s5,40(sp)
ffffffffc0201a38:	7b02                	ld	s6,32(sp)
ffffffffc0201a3a:	6be2                	ld	s7,24(sp)
ffffffffc0201a3c:	6c42                	ld	s8,16(sp)
ffffffffc0201a3e:	6125                	addi	sp,sp,96
ffffffffc0201a40:	8082                	ret
ffffffffc0201a42:	85a2                	mv	a1,s0
ffffffffc0201a44:	00003517          	auipc	a0,0x3
ffffffffc0201a48:	65450513          	addi	a0,a0,1620 # ffffffffc0205098 <commands+0xef8>
ffffffffc0201a4c:	e72fe0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc0201a50:	bfe1                	j	ffffffffc0201a28 <swap_out+0xc6>
ffffffffc0201a52:	4401                	li	s0,0
ffffffffc0201a54:	bfd1                	j	ffffffffc0201a28 <swap_out+0xc6>
ffffffffc0201a56:	00003697          	auipc	a3,0x3
ffffffffc0201a5a:	67268693          	addi	a3,a3,1650 # ffffffffc02050c8 <commands+0xf28>
ffffffffc0201a5e:	00003617          	auipc	a2,0x3
ffffffffc0201a62:	f9a60613          	addi	a2,a2,-102 # ffffffffc02049f8 <commands+0x858>
ffffffffc0201a66:	06600593          	li	a1,102
ffffffffc0201a6a:	00003517          	auipc	a0,0x3
ffffffffc0201a6e:	36e50513          	addi	a0,a0,878 # ffffffffc0204dd8 <commands+0xc38>
ffffffffc0201a72:	e92fe0ef          	jal	ra,ffffffffc0200104 <__panic>

ffffffffc0201a76 <swap_in>:
ffffffffc0201a76:	7179                	addi	sp,sp,-48
ffffffffc0201a78:	e84a                	sd	s2,16(sp)
ffffffffc0201a7a:	892a                	mv	s2,a0
ffffffffc0201a7c:	4505                	li	a0,1
ffffffffc0201a7e:	ec26                	sd	s1,24(sp)
ffffffffc0201a80:	e44e                	sd	s3,8(sp)
ffffffffc0201a82:	f406                	sd	ra,40(sp)
ffffffffc0201a84:	f022                	sd	s0,32(sp)
ffffffffc0201a86:	84ae                	mv	s1,a1
ffffffffc0201a88:	89b2                	mv	s3,a2
ffffffffc0201a8a:	669000ef          	jal	ra,ffffffffc02028f2 <alloc_pages>
ffffffffc0201a8e:	c129                	beqz	a0,ffffffffc0201ad0 <swap_in+0x5a>
ffffffffc0201a90:	842a                	mv	s0,a0
ffffffffc0201a92:	01893503          	ld	a0,24(s2)
ffffffffc0201a96:	4601                	li	a2,0
ffffffffc0201a98:	85a6                	mv	a1,s1
ffffffffc0201a9a:	767000ef          	jal	ra,ffffffffc0202a00 <get_pte>
ffffffffc0201a9e:	892a                	mv	s2,a0
ffffffffc0201aa0:	6108                	ld	a0,0(a0)
ffffffffc0201aa2:	85a2                	mv	a1,s0
ffffffffc0201aa4:	6f3010ef          	jal	ra,ffffffffc0203996 <swapfs_read>
ffffffffc0201aa8:	00093583          	ld	a1,0(s2)
ffffffffc0201aac:	8626                	mv	a2,s1
ffffffffc0201aae:	00003517          	auipc	a0,0x3
ffffffffc0201ab2:	2ca50513          	addi	a0,a0,714 # ffffffffc0204d78 <commands+0xbd8>
ffffffffc0201ab6:	81a1                	srli	a1,a1,0x8
ffffffffc0201ab8:	e06fe0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc0201abc:	70a2                	ld	ra,40(sp)
ffffffffc0201abe:	0089b023          	sd	s0,0(s3)
ffffffffc0201ac2:	7402                	ld	s0,32(sp)
ffffffffc0201ac4:	64e2                	ld	s1,24(sp)
ffffffffc0201ac6:	6942                	ld	s2,16(sp)
ffffffffc0201ac8:	69a2                	ld	s3,8(sp)
ffffffffc0201aca:	4501                	li	a0,0
ffffffffc0201acc:	6145                	addi	sp,sp,48
ffffffffc0201ace:	8082                	ret
ffffffffc0201ad0:	00003697          	auipc	a3,0x3
ffffffffc0201ad4:	29868693          	addi	a3,a3,664 # ffffffffc0204d68 <commands+0xbc8>
ffffffffc0201ad8:	00003617          	auipc	a2,0x3
ffffffffc0201adc:	f2060613          	addi	a2,a2,-224 # ffffffffc02049f8 <commands+0x858>
ffffffffc0201ae0:	07c00593          	li	a1,124
ffffffffc0201ae4:	00003517          	auipc	a0,0x3
ffffffffc0201ae8:	2f450513          	addi	a0,a0,756 # ffffffffc0204dd8 <commands+0xc38>
ffffffffc0201aec:	e18fe0ef          	jal	ra,ffffffffc0200104 <__panic>

ffffffffc0201af0 <default_init>:
ffffffffc0201af0:	0000f797          	auipc	a5,0xf
ffffffffc0201af4:	a6078793          	addi	a5,a5,-1440 # ffffffffc0210550 <free_area>
ffffffffc0201af8:	e79c                	sd	a5,8(a5)
ffffffffc0201afa:	e39c                	sd	a5,0(a5)
ffffffffc0201afc:	0007a823          	sw	zero,16(a5)
ffffffffc0201b00:	8082                	ret

ffffffffc0201b02 <default_nr_free_pages>:
ffffffffc0201b02:	0000f517          	auipc	a0,0xf
ffffffffc0201b06:	a5e56503          	lwu	a0,-1442(a0) # ffffffffc0210560 <free_area+0x10>
ffffffffc0201b0a:	8082                	ret

ffffffffc0201b0c <default_check>:
ffffffffc0201b0c:	715d                	addi	sp,sp,-80
ffffffffc0201b0e:	f84a                	sd	s2,48(sp)
ffffffffc0201b10:	0000f917          	auipc	s2,0xf
ffffffffc0201b14:	a4090913          	addi	s2,s2,-1472 # ffffffffc0210550 <free_area>
ffffffffc0201b18:	00893783          	ld	a5,8(s2)
ffffffffc0201b1c:	e486                	sd	ra,72(sp)
ffffffffc0201b1e:	e0a2                	sd	s0,64(sp)
ffffffffc0201b20:	fc26                	sd	s1,56(sp)
ffffffffc0201b22:	f44e                	sd	s3,40(sp)
ffffffffc0201b24:	f052                	sd	s4,32(sp)
ffffffffc0201b26:	ec56                	sd	s5,24(sp)
ffffffffc0201b28:	e85a                	sd	s6,16(sp)
ffffffffc0201b2a:	e45e                	sd	s7,8(sp)
ffffffffc0201b2c:	e062                	sd	s8,0(sp)
ffffffffc0201b2e:	31278f63          	beq	a5,s2,ffffffffc0201e4c <default_check+0x340>
ffffffffc0201b32:	fe87b703          	ld	a4,-24(a5)
ffffffffc0201b36:	8305                	srli	a4,a4,0x1
ffffffffc0201b38:	8b05                	andi	a4,a4,1
ffffffffc0201b3a:	30070d63          	beqz	a4,ffffffffc0201e54 <default_check+0x348>
ffffffffc0201b3e:	4401                	li	s0,0
ffffffffc0201b40:	4481                	li	s1,0
ffffffffc0201b42:	a031                	j	ffffffffc0201b4e <default_check+0x42>
ffffffffc0201b44:	fe87b703          	ld	a4,-24(a5)
ffffffffc0201b48:	8b09                	andi	a4,a4,2
ffffffffc0201b4a:	30070563          	beqz	a4,ffffffffc0201e54 <default_check+0x348>
ffffffffc0201b4e:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201b52:	679c                	ld	a5,8(a5)
ffffffffc0201b54:	2485                	addiw	s1,s1,1
ffffffffc0201b56:	9c39                	addw	s0,s0,a4
ffffffffc0201b58:	ff2796e3          	bne	a5,s2,ffffffffc0201b44 <default_check+0x38>
ffffffffc0201b5c:	89a2                	mv	s3,s0
ffffffffc0201b5e:	663000ef          	jal	ra,ffffffffc02029c0 <nr_free_pages>
ffffffffc0201b62:	75351963          	bne	a0,s3,ffffffffc02022b4 <default_check+0x7a8>
ffffffffc0201b66:	4505                	li	a0,1
ffffffffc0201b68:	58b000ef          	jal	ra,ffffffffc02028f2 <alloc_pages>
ffffffffc0201b6c:	8a2a                	mv	s4,a0
ffffffffc0201b6e:	48050363          	beqz	a0,ffffffffc0201ff4 <default_check+0x4e8>
ffffffffc0201b72:	4505                	li	a0,1
ffffffffc0201b74:	57f000ef          	jal	ra,ffffffffc02028f2 <alloc_pages>
ffffffffc0201b78:	89aa                	mv	s3,a0
ffffffffc0201b7a:	74050d63          	beqz	a0,ffffffffc02022d4 <default_check+0x7c8>
ffffffffc0201b7e:	4505                	li	a0,1
ffffffffc0201b80:	573000ef          	jal	ra,ffffffffc02028f2 <alloc_pages>
ffffffffc0201b84:	8aaa                	mv	s5,a0
ffffffffc0201b86:	4e050763          	beqz	a0,ffffffffc0202074 <default_check+0x568>
ffffffffc0201b8a:	2f3a0563          	beq	s4,s3,ffffffffc0201e74 <default_check+0x368>
ffffffffc0201b8e:	2eaa0363          	beq	s4,a0,ffffffffc0201e74 <default_check+0x368>
ffffffffc0201b92:	2ea98163          	beq	s3,a0,ffffffffc0201e74 <default_check+0x368>
ffffffffc0201b96:	000a2783          	lw	a5,0(s4)
ffffffffc0201b9a:	2e079d63          	bnez	a5,ffffffffc0201e94 <default_check+0x388>
ffffffffc0201b9e:	0009a783          	lw	a5,0(s3)
ffffffffc0201ba2:	2e079963          	bnez	a5,ffffffffc0201e94 <default_check+0x388>
ffffffffc0201ba6:	411c                	lw	a5,0(a0)
ffffffffc0201ba8:	2e079663          	bnez	a5,ffffffffc0201e94 <default_check+0x388>
ffffffffc0201bac:	0000f797          	auipc	a5,0xf
ffffffffc0201bb0:	9d478793          	addi	a5,a5,-1580 # ffffffffc0210580 <pages>
ffffffffc0201bb4:	639c                	ld	a5,0(a5)
ffffffffc0201bb6:	00003717          	auipc	a4,0x3
ffffffffc0201bba:	58270713          	addi	a4,a4,1410 # ffffffffc0205138 <commands+0xf98>
ffffffffc0201bbe:	630c                	ld	a1,0(a4)
ffffffffc0201bc0:	40fa0733          	sub	a4,s4,a5
ffffffffc0201bc4:	870d                	srai	a4,a4,0x3
ffffffffc0201bc6:	02b70733          	mul	a4,a4,a1
ffffffffc0201bca:	00004697          	auipc	a3,0x4
ffffffffc0201bce:	20668693          	addi	a3,a3,518 # ffffffffc0205dd0 <nbase>
ffffffffc0201bd2:	6290                	ld	a2,0(a3)
ffffffffc0201bd4:	0000f697          	auipc	a3,0xf
ffffffffc0201bd8:	89c68693          	addi	a3,a3,-1892 # ffffffffc0210470 <npage>
ffffffffc0201bdc:	6294                	ld	a3,0(a3)
ffffffffc0201bde:	06b2                	slli	a3,a3,0xc
ffffffffc0201be0:	9732                	add	a4,a4,a2
ffffffffc0201be2:	0732                	slli	a4,a4,0xc
ffffffffc0201be4:	2cd77863          	bgeu	a4,a3,ffffffffc0201eb4 <default_check+0x3a8>
ffffffffc0201be8:	40f98733          	sub	a4,s3,a5
ffffffffc0201bec:	870d                	srai	a4,a4,0x3
ffffffffc0201bee:	02b70733          	mul	a4,a4,a1
ffffffffc0201bf2:	9732                	add	a4,a4,a2
ffffffffc0201bf4:	0732                	slli	a4,a4,0xc
ffffffffc0201bf6:	4ed77f63          	bgeu	a4,a3,ffffffffc02020f4 <default_check+0x5e8>
ffffffffc0201bfa:	40f507b3          	sub	a5,a0,a5
ffffffffc0201bfe:	878d                	srai	a5,a5,0x3
ffffffffc0201c00:	02b787b3          	mul	a5,a5,a1
ffffffffc0201c04:	97b2                	add	a5,a5,a2
ffffffffc0201c06:	07b2                	slli	a5,a5,0xc
ffffffffc0201c08:	34d7f663          	bgeu	a5,a3,ffffffffc0201f54 <default_check+0x448>
ffffffffc0201c0c:	4505                	li	a0,1
ffffffffc0201c0e:	00093c03          	ld	s8,0(s2)
ffffffffc0201c12:	00893b83          	ld	s7,8(s2)
ffffffffc0201c16:	01092b03          	lw	s6,16(s2)
ffffffffc0201c1a:	0000f797          	auipc	a5,0xf
ffffffffc0201c1e:	9327bf23          	sd	s2,-1730(a5) # ffffffffc0210558 <free_area+0x8>
ffffffffc0201c22:	0000f797          	auipc	a5,0xf
ffffffffc0201c26:	9327b723          	sd	s2,-1746(a5) # ffffffffc0210550 <free_area>
ffffffffc0201c2a:	0000f797          	auipc	a5,0xf
ffffffffc0201c2e:	9207ab23          	sw	zero,-1738(a5) # ffffffffc0210560 <free_area+0x10>
ffffffffc0201c32:	4c1000ef          	jal	ra,ffffffffc02028f2 <alloc_pages>
ffffffffc0201c36:	2e051f63          	bnez	a0,ffffffffc0201f34 <default_check+0x428>
ffffffffc0201c3a:	4585                	li	a1,1
ffffffffc0201c3c:	8552                	mv	a0,s4
ffffffffc0201c3e:	53d000ef          	jal	ra,ffffffffc020297a <free_pages>
ffffffffc0201c42:	4585                	li	a1,1
ffffffffc0201c44:	854e                	mv	a0,s3
ffffffffc0201c46:	535000ef          	jal	ra,ffffffffc020297a <free_pages>
ffffffffc0201c4a:	4585                	li	a1,1
ffffffffc0201c4c:	8556                	mv	a0,s5
ffffffffc0201c4e:	52d000ef          	jal	ra,ffffffffc020297a <free_pages>
ffffffffc0201c52:	01092703          	lw	a4,16(s2)
ffffffffc0201c56:	478d                	li	a5,3
ffffffffc0201c58:	2af71e63          	bne	a4,a5,ffffffffc0201f14 <default_check+0x408>
ffffffffc0201c5c:	4505                	li	a0,1
ffffffffc0201c5e:	495000ef          	jal	ra,ffffffffc02028f2 <alloc_pages>
ffffffffc0201c62:	89aa                	mv	s3,a0
ffffffffc0201c64:	28050863          	beqz	a0,ffffffffc0201ef4 <default_check+0x3e8>
ffffffffc0201c68:	4505                	li	a0,1
ffffffffc0201c6a:	489000ef          	jal	ra,ffffffffc02028f2 <alloc_pages>
ffffffffc0201c6e:	8aaa                	mv	s5,a0
ffffffffc0201c70:	3e050263          	beqz	a0,ffffffffc0202054 <default_check+0x548>
ffffffffc0201c74:	4505                	li	a0,1
ffffffffc0201c76:	47d000ef          	jal	ra,ffffffffc02028f2 <alloc_pages>
ffffffffc0201c7a:	8a2a                	mv	s4,a0
ffffffffc0201c7c:	3a050c63          	beqz	a0,ffffffffc0202034 <default_check+0x528>
ffffffffc0201c80:	4505                	li	a0,1
ffffffffc0201c82:	471000ef          	jal	ra,ffffffffc02028f2 <alloc_pages>
ffffffffc0201c86:	38051763          	bnez	a0,ffffffffc0202014 <default_check+0x508>
ffffffffc0201c8a:	4585                	li	a1,1
ffffffffc0201c8c:	854e                	mv	a0,s3
ffffffffc0201c8e:	4ed000ef          	jal	ra,ffffffffc020297a <free_pages>
ffffffffc0201c92:	00893783          	ld	a5,8(s2)
ffffffffc0201c96:	23278f63          	beq	a5,s2,ffffffffc0201ed4 <default_check+0x3c8>
ffffffffc0201c9a:	4505                	li	a0,1
ffffffffc0201c9c:	457000ef          	jal	ra,ffffffffc02028f2 <alloc_pages>
ffffffffc0201ca0:	32a99a63          	bne	s3,a0,ffffffffc0201fd4 <default_check+0x4c8>
ffffffffc0201ca4:	4505                	li	a0,1
ffffffffc0201ca6:	44d000ef          	jal	ra,ffffffffc02028f2 <alloc_pages>
ffffffffc0201caa:	30051563          	bnez	a0,ffffffffc0201fb4 <default_check+0x4a8>
ffffffffc0201cae:	01092783          	lw	a5,16(s2)
ffffffffc0201cb2:	2e079163          	bnez	a5,ffffffffc0201f94 <default_check+0x488>
ffffffffc0201cb6:	854e                	mv	a0,s3
ffffffffc0201cb8:	4585                	li	a1,1
ffffffffc0201cba:	0000f797          	auipc	a5,0xf
ffffffffc0201cbe:	8987bb23          	sd	s8,-1898(a5) # ffffffffc0210550 <free_area>
ffffffffc0201cc2:	0000f797          	auipc	a5,0xf
ffffffffc0201cc6:	8977bb23          	sd	s7,-1898(a5) # ffffffffc0210558 <free_area+0x8>
ffffffffc0201cca:	0000f797          	auipc	a5,0xf
ffffffffc0201cce:	8967ab23          	sw	s6,-1898(a5) # ffffffffc0210560 <free_area+0x10>
ffffffffc0201cd2:	4a9000ef          	jal	ra,ffffffffc020297a <free_pages>
ffffffffc0201cd6:	4585                	li	a1,1
ffffffffc0201cd8:	8556                	mv	a0,s5
ffffffffc0201cda:	4a1000ef          	jal	ra,ffffffffc020297a <free_pages>
ffffffffc0201cde:	4585                	li	a1,1
ffffffffc0201ce0:	8552                	mv	a0,s4
ffffffffc0201ce2:	499000ef          	jal	ra,ffffffffc020297a <free_pages>
ffffffffc0201ce6:	4515                	li	a0,5
ffffffffc0201ce8:	40b000ef          	jal	ra,ffffffffc02028f2 <alloc_pages>
ffffffffc0201cec:	89aa                	mv	s3,a0
ffffffffc0201cee:	28050363          	beqz	a0,ffffffffc0201f74 <default_check+0x468>
ffffffffc0201cf2:	651c                	ld	a5,8(a0)
ffffffffc0201cf4:	8385                	srli	a5,a5,0x1
ffffffffc0201cf6:	8b85                	andi	a5,a5,1
ffffffffc0201cf8:	54079e63          	bnez	a5,ffffffffc0202254 <default_check+0x748>
ffffffffc0201cfc:	4505                	li	a0,1
ffffffffc0201cfe:	00093b03          	ld	s6,0(s2)
ffffffffc0201d02:	00893a83          	ld	s5,8(s2)
ffffffffc0201d06:	0000f797          	auipc	a5,0xf
ffffffffc0201d0a:	8527b523          	sd	s2,-1974(a5) # ffffffffc0210550 <free_area>
ffffffffc0201d0e:	0000f797          	auipc	a5,0xf
ffffffffc0201d12:	8527b523          	sd	s2,-1974(a5) # ffffffffc0210558 <free_area+0x8>
ffffffffc0201d16:	3dd000ef          	jal	ra,ffffffffc02028f2 <alloc_pages>
ffffffffc0201d1a:	50051d63          	bnez	a0,ffffffffc0202234 <default_check+0x728>
ffffffffc0201d1e:	09098a13          	addi	s4,s3,144
ffffffffc0201d22:	8552                	mv	a0,s4
ffffffffc0201d24:	458d                	li	a1,3
ffffffffc0201d26:	01092b83          	lw	s7,16(s2)
ffffffffc0201d2a:	0000f797          	auipc	a5,0xf
ffffffffc0201d2e:	8207ab23          	sw	zero,-1994(a5) # ffffffffc0210560 <free_area+0x10>
ffffffffc0201d32:	449000ef          	jal	ra,ffffffffc020297a <free_pages>
ffffffffc0201d36:	4511                	li	a0,4
ffffffffc0201d38:	3bb000ef          	jal	ra,ffffffffc02028f2 <alloc_pages>
ffffffffc0201d3c:	4c051c63          	bnez	a0,ffffffffc0202214 <default_check+0x708>
ffffffffc0201d40:	0989b783          	ld	a5,152(s3)
ffffffffc0201d44:	8385                	srli	a5,a5,0x1
ffffffffc0201d46:	8b85                	andi	a5,a5,1
ffffffffc0201d48:	4a078663          	beqz	a5,ffffffffc02021f4 <default_check+0x6e8>
ffffffffc0201d4c:	0a89a703          	lw	a4,168(s3)
ffffffffc0201d50:	478d                	li	a5,3
ffffffffc0201d52:	4af71163          	bne	a4,a5,ffffffffc02021f4 <default_check+0x6e8>
ffffffffc0201d56:	450d                	li	a0,3
ffffffffc0201d58:	39b000ef          	jal	ra,ffffffffc02028f2 <alloc_pages>
ffffffffc0201d5c:	8c2a                	mv	s8,a0
ffffffffc0201d5e:	46050b63          	beqz	a0,ffffffffc02021d4 <default_check+0x6c8>
ffffffffc0201d62:	4505                	li	a0,1
ffffffffc0201d64:	38f000ef          	jal	ra,ffffffffc02028f2 <alloc_pages>
ffffffffc0201d68:	44051663          	bnez	a0,ffffffffc02021b4 <default_check+0x6a8>
ffffffffc0201d6c:	438a1463          	bne	s4,s8,ffffffffc0202194 <default_check+0x688>
ffffffffc0201d70:	4585                	li	a1,1
ffffffffc0201d72:	854e                	mv	a0,s3
ffffffffc0201d74:	407000ef          	jal	ra,ffffffffc020297a <free_pages>
ffffffffc0201d78:	458d                	li	a1,3
ffffffffc0201d7a:	8552                	mv	a0,s4
ffffffffc0201d7c:	3ff000ef          	jal	ra,ffffffffc020297a <free_pages>
ffffffffc0201d80:	0089b783          	ld	a5,8(s3)
ffffffffc0201d84:	04898c13          	addi	s8,s3,72
ffffffffc0201d88:	8385                	srli	a5,a5,0x1
ffffffffc0201d8a:	8b85                	andi	a5,a5,1
ffffffffc0201d8c:	3e078463          	beqz	a5,ffffffffc0202174 <default_check+0x668>
ffffffffc0201d90:	0189a703          	lw	a4,24(s3)
ffffffffc0201d94:	4785                	li	a5,1
ffffffffc0201d96:	3cf71f63          	bne	a4,a5,ffffffffc0202174 <default_check+0x668>
ffffffffc0201d9a:	008a3783          	ld	a5,8(s4)
ffffffffc0201d9e:	8385                	srli	a5,a5,0x1
ffffffffc0201da0:	8b85                	andi	a5,a5,1
ffffffffc0201da2:	3a078963          	beqz	a5,ffffffffc0202154 <default_check+0x648>
ffffffffc0201da6:	018a2703          	lw	a4,24(s4)
ffffffffc0201daa:	478d                	li	a5,3
ffffffffc0201dac:	3af71463          	bne	a4,a5,ffffffffc0202154 <default_check+0x648>
ffffffffc0201db0:	4505                	li	a0,1
ffffffffc0201db2:	341000ef          	jal	ra,ffffffffc02028f2 <alloc_pages>
ffffffffc0201db6:	36a99f63          	bne	s3,a0,ffffffffc0202134 <default_check+0x628>
ffffffffc0201dba:	4585                	li	a1,1
ffffffffc0201dbc:	3bf000ef          	jal	ra,ffffffffc020297a <free_pages>
ffffffffc0201dc0:	4509                	li	a0,2
ffffffffc0201dc2:	331000ef          	jal	ra,ffffffffc02028f2 <alloc_pages>
ffffffffc0201dc6:	34aa1763          	bne	s4,a0,ffffffffc0202114 <default_check+0x608>
ffffffffc0201dca:	4589                	li	a1,2
ffffffffc0201dcc:	3af000ef          	jal	ra,ffffffffc020297a <free_pages>
ffffffffc0201dd0:	4585                	li	a1,1
ffffffffc0201dd2:	8562                	mv	a0,s8
ffffffffc0201dd4:	3a7000ef          	jal	ra,ffffffffc020297a <free_pages>
ffffffffc0201dd8:	4515                	li	a0,5
ffffffffc0201dda:	319000ef          	jal	ra,ffffffffc02028f2 <alloc_pages>
ffffffffc0201dde:	89aa                	mv	s3,a0
ffffffffc0201de0:	48050a63          	beqz	a0,ffffffffc0202274 <default_check+0x768>
ffffffffc0201de4:	4505                	li	a0,1
ffffffffc0201de6:	30d000ef          	jal	ra,ffffffffc02028f2 <alloc_pages>
ffffffffc0201dea:	2e051563          	bnez	a0,ffffffffc02020d4 <default_check+0x5c8>
ffffffffc0201dee:	01092783          	lw	a5,16(s2)
ffffffffc0201df2:	2c079163          	bnez	a5,ffffffffc02020b4 <default_check+0x5a8>
ffffffffc0201df6:	4595                	li	a1,5
ffffffffc0201df8:	854e                	mv	a0,s3
ffffffffc0201dfa:	0000e797          	auipc	a5,0xe
ffffffffc0201dfe:	7777a323          	sw	s7,1894(a5) # ffffffffc0210560 <free_area+0x10>
ffffffffc0201e02:	0000e797          	auipc	a5,0xe
ffffffffc0201e06:	7567b723          	sd	s6,1870(a5) # ffffffffc0210550 <free_area>
ffffffffc0201e0a:	0000e797          	auipc	a5,0xe
ffffffffc0201e0e:	7557b723          	sd	s5,1870(a5) # ffffffffc0210558 <free_area+0x8>
ffffffffc0201e12:	369000ef          	jal	ra,ffffffffc020297a <free_pages>
ffffffffc0201e16:	00893783          	ld	a5,8(s2)
ffffffffc0201e1a:	01278963          	beq	a5,s2,ffffffffc0201e2c <default_check+0x320>
ffffffffc0201e1e:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201e22:	679c                	ld	a5,8(a5)
ffffffffc0201e24:	34fd                	addiw	s1,s1,-1
ffffffffc0201e26:	9c19                	subw	s0,s0,a4
ffffffffc0201e28:	ff279be3          	bne	a5,s2,ffffffffc0201e1e <default_check+0x312>
ffffffffc0201e2c:	26049463          	bnez	s1,ffffffffc0202094 <default_check+0x588>
ffffffffc0201e30:	46041263          	bnez	s0,ffffffffc0202294 <default_check+0x788>
ffffffffc0201e34:	60a6                	ld	ra,72(sp)
ffffffffc0201e36:	6406                	ld	s0,64(sp)
ffffffffc0201e38:	74e2                	ld	s1,56(sp)
ffffffffc0201e3a:	7942                	ld	s2,48(sp)
ffffffffc0201e3c:	79a2                	ld	s3,40(sp)
ffffffffc0201e3e:	7a02                	ld	s4,32(sp)
ffffffffc0201e40:	6ae2                	ld	s5,24(sp)
ffffffffc0201e42:	6b42                	ld	s6,16(sp)
ffffffffc0201e44:	6ba2                	ld	s7,8(sp)
ffffffffc0201e46:	6c02                	ld	s8,0(sp)
ffffffffc0201e48:	6161                	addi	sp,sp,80
ffffffffc0201e4a:	8082                	ret
ffffffffc0201e4c:	4981                	li	s3,0
ffffffffc0201e4e:	4401                	li	s0,0
ffffffffc0201e50:	4481                	li	s1,0
ffffffffc0201e52:	b331                	j	ffffffffc0201b5e <default_check+0x52>
ffffffffc0201e54:	00003697          	auipc	a3,0x3
ffffffffc0201e58:	fac68693          	addi	a3,a3,-84 # ffffffffc0204e00 <commands+0xc60>
ffffffffc0201e5c:	00003617          	auipc	a2,0x3
ffffffffc0201e60:	b9c60613          	addi	a2,a2,-1124 # ffffffffc02049f8 <commands+0x858>
ffffffffc0201e64:	0f000593          	li	a1,240
ffffffffc0201e68:	00003517          	auipc	a0,0x3
ffffffffc0201e6c:	2d850513          	addi	a0,a0,728 # ffffffffc0205140 <commands+0xfa0>
ffffffffc0201e70:	a94fe0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0201e74:	00003697          	auipc	a3,0x3
ffffffffc0201e78:	34468693          	addi	a3,a3,836 # ffffffffc02051b8 <commands+0x1018>
ffffffffc0201e7c:	00003617          	auipc	a2,0x3
ffffffffc0201e80:	b7c60613          	addi	a2,a2,-1156 # ffffffffc02049f8 <commands+0x858>
ffffffffc0201e84:	0bd00593          	li	a1,189
ffffffffc0201e88:	00003517          	auipc	a0,0x3
ffffffffc0201e8c:	2b850513          	addi	a0,a0,696 # ffffffffc0205140 <commands+0xfa0>
ffffffffc0201e90:	a74fe0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0201e94:	00003697          	auipc	a3,0x3
ffffffffc0201e98:	34c68693          	addi	a3,a3,844 # ffffffffc02051e0 <commands+0x1040>
ffffffffc0201e9c:	00003617          	auipc	a2,0x3
ffffffffc0201ea0:	b5c60613          	addi	a2,a2,-1188 # ffffffffc02049f8 <commands+0x858>
ffffffffc0201ea4:	0be00593          	li	a1,190
ffffffffc0201ea8:	00003517          	auipc	a0,0x3
ffffffffc0201eac:	29850513          	addi	a0,a0,664 # ffffffffc0205140 <commands+0xfa0>
ffffffffc0201eb0:	a54fe0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0201eb4:	00003697          	auipc	a3,0x3
ffffffffc0201eb8:	36c68693          	addi	a3,a3,876 # ffffffffc0205220 <commands+0x1080>
ffffffffc0201ebc:	00003617          	auipc	a2,0x3
ffffffffc0201ec0:	b3c60613          	addi	a2,a2,-1220 # ffffffffc02049f8 <commands+0x858>
ffffffffc0201ec4:	0c000593          	li	a1,192
ffffffffc0201ec8:	00003517          	auipc	a0,0x3
ffffffffc0201ecc:	27850513          	addi	a0,a0,632 # ffffffffc0205140 <commands+0xfa0>
ffffffffc0201ed0:	a34fe0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0201ed4:	00003697          	auipc	a3,0x3
ffffffffc0201ed8:	3d468693          	addi	a3,a3,980 # ffffffffc02052a8 <commands+0x1108>
ffffffffc0201edc:	00003617          	auipc	a2,0x3
ffffffffc0201ee0:	b1c60613          	addi	a2,a2,-1252 # ffffffffc02049f8 <commands+0x858>
ffffffffc0201ee4:	0d900593          	li	a1,217
ffffffffc0201ee8:	00003517          	auipc	a0,0x3
ffffffffc0201eec:	25850513          	addi	a0,a0,600 # ffffffffc0205140 <commands+0xfa0>
ffffffffc0201ef0:	a14fe0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0201ef4:	00003697          	auipc	a3,0x3
ffffffffc0201ef8:	26468693          	addi	a3,a3,612 # ffffffffc0205158 <commands+0xfb8>
ffffffffc0201efc:	00003617          	auipc	a2,0x3
ffffffffc0201f00:	afc60613          	addi	a2,a2,-1284 # ffffffffc02049f8 <commands+0x858>
ffffffffc0201f04:	0d200593          	li	a1,210
ffffffffc0201f08:	00003517          	auipc	a0,0x3
ffffffffc0201f0c:	23850513          	addi	a0,a0,568 # ffffffffc0205140 <commands+0xfa0>
ffffffffc0201f10:	9f4fe0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0201f14:	00003697          	auipc	a3,0x3
ffffffffc0201f18:	38468693          	addi	a3,a3,900 # ffffffffc0205298 <commands+0x10f8>
ffffffffc0201f1c:	00003617          	auipc	a2,0x3
ffffffffc0201f20:	adc60613          	addi	a2,a2,-1316 # ffffffffc02049f8 <commands+0x858>
ffffffffc0201f24:	0d000593          	li	a1,208
ffffffffc0201f28:	00003517          	auipc	a0,0x3
ffffffffc0201f2c:	21850513          	addi	a0,a0,536 # ffffffffc0205140 <commands+0xfa0>
ffffffffc0201f30:	9d4fe0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0201f34:	00003697          	auipc	a3,0x3
ffffffffc0201f38:	34c68693          	addi	a3,a3,844 # ffffffffc0205280 <commands+0x10e0>
ffffffffc0201f3c:	00003617          	auipc	a2,0x3
ffffffffc0201f40:	abc60613          	addi	a2,a2,-1348 # ffffffffc02049f8 <commands+0x858>
ffffffffc0201f44:	0cb00593          	li	a1,203
ffffffffc0201f48:	00003517          	auipc	a0,0x3
ffffffffc0201f4c:	1f850513          	addi	a0,a0,504 # ffffffffc0205140 <commands+0xfa0>
ffffffffc0201f50:	9b4fe0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0201f54:	00003697          	auipc	a3,0x3
ffffffffc0201f58:	30c68693          	addi	a3,a3,780 # ffffffffc0205260 <commands+0x10c0>
ffffffffc0201f5c:	00003617          	auipc	a2,0x3
ffffffffc0201f60:	a9c60613          	addi	a2,a2,-1380 # ffffffffc02049f8 <commands+0x858>
ffffffffc0201f64:	0c200593          	li	a1,194
ffffffffc0201f68:	00003517          	auipc	a0,0x3
ffffffffc0201f6c:	1d850513          	addi	a0,a0,472 # ffffffffc0205140 <commands+0xfa0>
ffffffffc0201f70:	994fe0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0201f74:	00003697          	auipc	a3,0x3
ffffffffc0201f78:	36c68693          	addi	a3,a3,876 # ffffffffc02052e0 <commands+0x1140>
ffffffffc0201f7c:	00003617          	auipc	a2,0x3
ffffffffc0201f80:	a7c60613          	addi	a2,a2,-1412 # ffffffffc02049f8 <commands+0x858>
ffffffffc0201f84:	0f800593          	li	a1,248
ffffffffc0201f88:	00003517          	auipc	a0,0x3
ffffffffc0201f8c:	1b850513          	addi	a0,a0,440 # ffffffffc0205140 <commands+0xfa0>
ffffffffc0201f90:	974fe0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0201f94:	00003697          	auipc	a3,0x3
ffffffffc0201f98:	01c68693          	addi	a3,a3,28 # ffffffffc0204fb0 <commands+0xe10>
ffffffffc0201f9c:	00003617          	auipc	a2,0x3
ffffffffc0201fa0:	a5c60613          	addi	a2,a2,-1444 # ffffffffc02049f8 <commands+0x858>
ffffffffc0201fa4:	0df00593          	li	a1,223
ffffffffc0201fa8:	00003517          	auipc	a0,0x3
ffffffffc0201fac:	19850513          	addi	a0,a0,408 # ffffffffc0205140 <commands+0xfa0>
ffffffffc0201fb0:	954fe0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0201fb4:	00003697          	auipc	a3,0x3
ffffffffc0201fb8:	2cc68693          	addi	a3,a3,716 # ffffffffc0205280 <commands+0x10e0>
ffffffffc0201fbc:	00003617          	auipc	a2,0x3
ffffffffc0201fc0:	a3c60613          	addi	a2,a2,-1476 # ffffffffc02049f8 <commands+0x858>
ffffffffc0201fc4:	0dd00593          	li	a1,221
ffffffffc0201fc8:	00003517          	auipc	a0,0x3
ffffffffc0201fcc:	17850513          	addi	a0,a0,376 # ffffffffc0205140 <commands+0xfa0>
ffffffffc0201fd0:	934fe0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0201fd4:	00003697          	auipc	a3,0x3
ffffffffc0201fd8:	2ec68693          	addi	a3,a3,748 # ffffffffc02052c0 <commands+0x1120>
ffffffffc0201fdc:	00003617          	auipc	a2,0x3
ffffffffc0201fe0:	a1c60613          	addi	a2,a2,-1508 # ffffffffc02049f8 <commands+0x858>
ffffffffc0201fe4:	0dc00593          	li	a1,220
ffffffffc0201fe8:	00003517          	auipc	a0,0x3
ffffffffc0201fec:	15850513          	addi	a0,a0,344 # ffffffffc0205140 <commands+0xfa0>
ffffffffc0201ff0:	914fe0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0201ff4:	00003697          	auipc	a3,0x3
ffffffffc0201ff8:	16468693          	addi	a3,a3,356 # ffffffffc0205158 <commands+0xfb8>
ffffffffc0201ffc:	00003617          	auipc	a2,0x3
ffffffffc0202000:	9fc60613          	addi	a2,a2,-1540 # ffffffffc02049f8 <commands+0x858>
ffffffffc0202004:	0b900593          	li	a1,185
ffffffffc0202008:	00003517          	auipc	a0,0x3
ffffffffc020200c:	13850513          	addi	a0,a0,312 # ffffffffc0205140 <commands+0xfa0>
ffffffffc0202010:	8f4fe0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0202014:	00003697          	auipc	a3,0x3
ffffffffc0202018:	26c68693          	addi	a3,a3,620 # ffffffffc0205280 <commands+0x10e0>
ffffffffc020201c:	00003617          	auipc	a2,0x3
ffffffffc0202020:	9dc60613          	addi	a2,a2,-1572 # ffffffffc02049f8 <commands+0x858>
ffffffffc0202024:	0d600593          	li	a1,214
ffffffffc0202028:	00003517          	auipc	a0,0x3
ffffffffc020202c:	11850513          	addi	a0,a0,280 # ffffffffc0205140 <commands+0xfa0>
ffffffffc0202030:	8d4fe0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0202034:	00003697          	auipc	a3,0x3
ffffffffc0202038:	16468693          	addi	a3,a3,356 # ffffffffc0205198 <commands+0xff8>
ffffffffc020203c:	00003617          	auipc	a2,0x3
ffffffffc0202040:	9bc60613          	addi	a2,a2,-1604 # ffffffffc02049f8 <commands+0x858>
ffffffffc0202044:	0d400593          	li	a1,212
ffffffffc0202048:	00003517          	auipc	a0,0x3
ffffffffc020204c:	0f850513          	addi	a0,a0,248 # ffffffffc0205140 <commands+0xfa0>
ffffffffc0202050:	8b4fe0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0202054:	00003697          	auipc	a3,0x3
ffffffffc0202058:	12468693          	addi	a3,a3,292 # ffffffffc0205178 <commands+0xfd8>
ffffffffc020205c:	00003617          	auipc	a2,0x3
ffffffffc0202060:	99c60613          	addi	a2,a2,-1636 # ffffffffc02049f8 <commands+0x858>
ffffffffc0202064:	0d300593          	li	a1,211
ffffffffc0202068:	00003517          	auipc	a0,0x3
ffffffffc020206c:	0d850513          	addi	a0,a0,216 # ffffffffc0205140 <commands+0xfa0>
ffffffffc0202070:	894fe0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0202074:	00003697          	auipc	a3,0x3
ffffffffc0202078:	12468693          	addi	a3,a3,292 # ffffffffc0205198 <commands+0xff8>
ffffffffc020207c:	00003617          	auipc	a2,0x3
ffffffffc0202080:	97c60613          	addi	a2,a2,-1668 # ffffffffc02049f8 <commands+0x858>
ffffffffc0202084:	0bb00593          	li	a1,187
ffffffffc0202088:	00003517          	auipc	a0,0x3
ffffffffc020208c:	0b850513          	addi	a0,a0,184 # ffffffffc0205140 <commands+0xfa0>
ffffffffc0202090:	874fe0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0202094:	00003697          	auipc	a3,0x3
ffffffffc0202098:	39c68693          	addi	a3,a3,924 # ffffffffc0205430 <commands+0x1290>
ffffffffc020209c:	00003617          	auipc	a2,0x3
ffffffffc02020a0:	95c60613          	addi	a2,a2,-1700 # ffffffffc02049f8 <commands+0x858>
ffffffffc02020a4:	12500593          	li	a1,293
ffffffffc02020a8:	00003517          	auipc	a0,0x3
ffffffffc02020ac:	09850513          	addi	a0,a0,152 # ffffffffc0205140 <commands+0xfa0>
ffffffffc02020b0:	854fe0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc02020b4:	00003697          	auipc	a3,0x3
ffffffffc02020b8:	efc68693          	addi	a3,a3,-260 # ffffffffc0204fb0 <commands+0xe10>
ffffffffc02020bc:	00003617          	auipc	a2,0x3
ffffffffc02020c0:	93c60613          	addi	a2,a2,-1732 # ffffffffc02049f8 <commands+0x858>
ffffffffc02020c4:	11a00593          	li	a1,282
ffffffffc02020c8:	00003517          	auipc	a0,0x3
ffffffffc02020cc:	07850513          	addi	a0,a0,120 # ffffffffc0205140 <commands+0xfa0>
ffffffffc02020d0:	834fe0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc02020d4:	00003697          	auipc	a3,0x3
ffffffffc02020d8:	1ac68693          	addi	a3,a3,428 # ffffffffc0205280 <commands+0x10e0>
ffffffffc02020dc:	00003617          	auipc	a2,0x3
ffffffffc02020e0:	91c60613          	addi	a2,a2,-1764 # ffffffffc02049f8 <commands+0x858>
ffffffffc02020e4:	11800593          	li	a1,280
ffffffffc02020e8:	00003517          	auipc	a0,0x3
ffffffffc02020ec:	05850513          	addi	a0,a0,88 # ffffffffc0205140 <commands+0xfa0>
ffffffffc02020f0:	814fe0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc02020f4:	00003697          	auipc	a3,0x3
ffffffffc02020f8:	14c68693          	addi	a3,a3,332 # ffffffffc0205240 <commands+0x10a0>
ffffffffc02020fc:	00003617          	auipc	a2,0x3
ffffffffc0202100:	8fc60613          	addi	a2,a2,-1796 # ffffffffc02049f8 <commands+0x858>
ffffffffc0202104:	0c100593          	li	a1,193
ffffffffc0202108:	00003517          	auipc	a0,0x3
ffffffffc020210c:	03850513          	addi	a0,a0,56 # ffffffffc0205140 <commands+0xfa0>
ffffffffc0202110:	ff5fd0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0202114:	00003697          	auipc	a3,0x3
ffffffffc0202118:	2dc68693          	addi	a3,a3,732 # ffffffffc02053f0 <commands+0x1250>
ffffffffc020211c:	00003617          	auipc	a2,0x3
ffffffffc0202120:	8dc60613          	addi	a2,a2,-1828 # ffffffffc02049f8 <commands+0x858>
ffffffffc0202124:	11200593          	li	a1,274
ffffffffc0202128:	00003517          	auipc	a0,0x3
ffffffffc020212c:	01850513          	addi	a0,a0,24 # ffffffffc0205140 <commands+0xfa0>
ffffffffc0202130:	fd5fd0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0202134:	00003697          	auipc	a3,0x3
ffffffffc0202138:	29c68693          	addi	a3,a3,668 # ffffffffc02053d0 <commands+0x1230>
ffffffffc020213c:	00003617          	auipc	a2,0x3
ffffffffc0202140:	8bc60613          	addi	a2,a2,-1860 # ffffffffc02049f8 <commands+0x858>
ffffffffc0202144:	11000593          	li	a1,272
ffffffffc0202148:	00003517          	auipc	a0,0x3
ffffffffc020214c:	ff850513          	addi	a0,a0,-8 # ffffffffc0205140 <commands+0xfa0>
ffffffffc0202150:	fb5fd0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0202154:	00003697          	auipc	a3,0x3
ffffffffc0202158:	25468693          	addi	a3,a3,596 # ffffffffc02053a8 <commands+0x1208>
ffffffffc020215c:	00003617          	auipc	a2,0x3
ffffffffc0202160:	89c60613          	addi	a2,a2,-1892 # ffffffffc02049f8 <commands+0x858>
ffffffffc0202164:	10e00593          	li	a1,270
ffffffffc0202168:	00003517          	auipc	a0,0x3
ffffffffc020216c:	fd850513          	addi	a0,a0,-40 # ffffffffc0205140 <commands+0xfa0>
ffffffffc0202170:	f95fd0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0202174:	00003697          	auipc	a3,0x3
ffffffffc0202178:	20c68693          	addi	a3,a3,524 # ffffffffc0205380 <commands+0x11e0>
ffffffffc020217c:	00003617          	auipc	a2,0x3
ffffffffc0202180:	87c60613          	addi	a2,a2,-1924 # ffffffffc02049f8 <commands+0x858>
ffffffffc0202184:	10d00593          	li	a1,269
ffffffffc0202188:	00003517          	auipc	a0,0x3
ffffffffc020218c:	fb850513          	addi	a0,a0,-72 # ffffffffc0205140 <commands+0xfa0>
ffffffffc0202190:	f75fd0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0202194:	00003697          	auipc	a3,0x3
ffffffffc0202198:	1dc68693          	addi	a3,a3,476 # ffffffffc0205370 <commands+0x11d0>
ffffffffc020219c:	00003617          	auipc	a2,0x3
ffffffffc02021a0:	85c60613          	addi	a2,a2,-1956 # ffffffffc02049f8 <commands+0x858>
ffffffffc02021a4:	10800593          	li	a1,264
ffffffffc02021a8:	00003517          	auipc	a0,0x3
ffffffffc02021ac:	f9850513          	addi	a0,a0,-104 # ffffffffc0205140 <commands+0xfa0>
ffffffffc02021b0:	f55fd0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc02021b4:	00003697          	auipc	a3,0x3
ffffffffc02021b8:	0cc68693          	addi	a3,a3,204 # ffffffffc0205280 <commands+0x10e0>
ffffffffc02021bc:	00003617          	auipc	a2,0x3
ffffffffc02021c0:	83c60613          	addi	a2,a2,-1988 # ffffffffc02049f8 <commands+0x858>
ffffffffc02021c4:	10700593          	li	a1,263
ffffffffc02021c8:	00003517          	auipc	a0,0x3
ffffffffc02021cc:	f7850513          	addi	a0,a0,-136 # ffffffffc0205140 <commands+0xfa0>
ffffffffc02021d0:	f35fd0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc02021d4:	00003697          	auipc	a3,0x3
ffffffffc02021d8:	17c68693          	addi	a3,a3,380 # ffffffffc0205350 <commands+0x11b0>
ffffffffc02021dc:	00003617          	auipc	a2,0x3
ffffffffc02021e0:	81c60613          	addi	a2,a2,-2020 # ffffffffc02049f8 <commands+0x858>
ffffffffc02021e4:	10600593          	li	a1,262
ffffffffc02021e8:	00003517          	auipc	a0,0x3
ffffffffc02021ec:	f5850513          	addi	a0,a0,-168 # ffffffffc0205140 <commands+0xfa0>
ffffffffc02021f0:	f15fd0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc02021f4:	00003697          	auipc	a3,0x3
ffffffffc02021f8:	12c68693          	addi	a3,a3,300 # ffffffffc0205320 <commands+0x1180>
ffffffffc02021fc:	00002617          	auipc	a2,0x2
ffffffffc0202200:	7fc60613          	addi	a2,a2,2044 # ffffffffc02049f8 <commands+0x858>
ffffffffc0202204:	10500593          	li	a1,261
ffffffffc0202208:	00003517          	auipc	a0,0x3
ffffffffc020220c:	f3850513          	addi	a0,a0,-200 # ffffffffc0205140 <commands+0xfa0>
ffffffffc0202210:	ef5fd0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0202214:	00003697          	auipc	a3,0x3
ffffffffc0202218:	0f468693          	addi	a3,a3,244 # ffffffffc0205308 <commands+0x1168>
ffffffffc020221c:	00002617          	auipc	a2,0x2
ffffffffc0202220:	7dc60613          	addi	a2,a2,2012 # ffffffffc02049f8 <commands+0x858>
ffffffffc0202224:	10400593          	li	a1,260
ffffffffc0202228:	00003517          	auipc	a0,0x3
ffffffffc020222c:	f1850513          	addi	a0,a0,-232 # ffffffffc0205140 <commands+0xfa0>
ffffffffc0202230:	ed5fd0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0202234:	00003697          	auipc	a3,0x3
ffffffffc0202238:	04c68693          	addi	a3,a3,76 # ffffffffc0205280 <commands+0x10e0>
ffffffffc020223c:	00002617          	auipc	a2,0x2
ffffffffc0202240:	7bc60613          	addi	a2,a2,1980 # ffffffffc02049f8 <commands+0x858>
ffffffffc0202244:	0fe00593          	li	a1,254
ffffffffc0202248:	00003517          	auipc	a0,0x3
ffffffffc020224c:	ef850513          	addi	a0,a0,-264 # ffffffffc0205140 <commands+0xfa0>
ffffffffc0202250:	eb5fd0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0202254:	00003697          	auipc	a3,0x3
ffffffffc0202258:	09c68693          	addi	a3,a3,156 # ffffffffc02052f0 <commands+0x1150>
ffffffffc020225c:	00002617          	auipc	a2,0x2
ffffffffc0202260:	79c60613          	addi	a2,a2,1948 # ffffffffc02049f8 <commands+0x858>
ffffffffc0202264:	0f900593          	li	a1,249
ffffffffc0202268:	00003517          	auipc	a0,0x3
ffffffffc020226c:	ed850513          	addi	a0,a0,-296 # ffffffffc0205140 <commands+0xfa0>
ffffffffc0202270:	e95fd0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0202274:	00003697          	auipc	a3,0x3
ffffffffc0202278:	19c68693          	addi	a3,a3,412 # ffffffffc0205410 <commands+0x1270>
ffffffffc020227c:	00002617          	auipc	a2,0x2
ffffffffc0202280:	77c60613          	addi	a2,a2,1916 # ffffffffc02049f8 <commands+0x858>
ffffffffc0202284:	11700593          	li	a1,279
ffffffffc0202288:	00003517          	auipc	a0,0x3
ffffffffc020228c:	eb850513          	addi	a0,a0,-328 # ffffffffc0205140 <commands+0xfa0>
ffffffffc0202290:	e75fd0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0202294:	00003697          	auipc	a3,0x3
ffffffffc0202298:	1ac68693          	addi	a3,a3,428 # ffffffffc0205440 <commands+0x12a0>
ffffffffc020229c:	00002617          	auipc	a2,0x2
ffffffffc02022a0:	75c60613          	addi	a2,a2,1884 # ffffffffc02049f8 <commands+0x858>
ffffffffc02022a4:	12600593          	li	a1,294
ffffffffc02022a8:	00003517          	auipc	a0,0x3
ffffffffc02022ac:	e9850513          	addi	a0,a0,-360 # ffffffffc0205140 <commands+0xfa0>
ffffffffc02022b0:	e55fd0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc02022b4:	00003697          	auipc	a3,0x3
ffffffffc02022b8:	b5c68693          	addi	a3,a3,-1188 # ffffffffc0204e10 <commands+0xc70>
ffffffffc02022bc:	00002617          	auipc	a2,0x2
ffffffffc02022c0:	73c60613          	addi	a2,a2,1852 # ffffffffc02049f8 <commands+0x858>
ffffffffc02022c4:	0f300593          	li	a1,243
ffffffffc02022c8:	00003517          	auipc	a0,0x3
ffffffffc02022cc:	e7850513          	addi	a0,a0,-392 # ffffffffc0205140 <commands+0xfa0>
ffffffffc02022d0:	e35fd0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc02022d4:	00003697          	auipc	a3,0x3
ffffffffc02022d8:	ea468693          	addi	a3,a3,-348 # ffffffffc0205178 <commands+0xfd8>
ffffffffc02022dc:	00002617          	auipc	a2,0x2
ffffffffc02022e0:	71c60613          	addi	a2,a2,1820 # ffffffffc02049f8 <commands+0x858>
ffffffffc02022e4:	0ba00593          	li	a1,186
ffffffffc02022e8:	00003517          	auipc	a0,0x3
ffffffffc02022ec:	e5850513          	addi	a0,a0,-424 # ffffffffc0205140 <commands+0xfa0>
ffffffffc02022f0:	e15fd0ef          	jal	ra,ffffffffc0200104 <__panic>

ffffffffc02022f4 <default_free_pages>:
ffffffffc02022f4:	1141                	addi	sp,sp,-16
ffffffffc02022f6:	e406                	sd	ra,8(sp)
ffffffffc02022f8:	18058063          	beqz	a1,ffffffffc0202478 <default_free_pages+0x184>
ffffffffc02022fc:	00359693          	slli	a3,a1,0x3
ffffffffc0202300:	96ae                	add	a3,a3,a1
ffffffffc0202302:	068e                	slli	a3,a3,0x3
ffffffffc0202304:	96aa                	add	a3,a3,a0
ffffffffc0202306:	02d50d63          	beq	a0,a3,ffffffffc0202340 <default_free_pages+0x4c>
ffffffffc020230a:	651c                	ld	a5,8(a0)
ffffffffc020230c:	8b85                	andi	a5,a5,1
ffffffffc020230e:	14079563          	bnez	a5,ffffffffc0202458 <default_free_pages+0x164>
ffffffffc0202312:	651c                	ld	a5,8(a0)
ffffffffc0202314:	8385                	srli	a5,a5,0x1
ffffffffc0202316:	8b85                	andi	a5,a5,1
ffffffffc0202318:	14079063          	bnez	a5,ffffffffc0202458 <default_free_pages+0x164>
ffffffffc020231c:	87aa                	mv	a5,a0
ffffffffc020231e:	a809                	j	ffffffffc0202330 <default_free_pages+0x3c>
ffffffffc0202320:	6798                	ld	a4,8(a5)
ffffffffc0202322:	8b05                	andi	a4,a4,1
ffffffffc0202324:	12071a63          	bnez	a4,ffffffffc0202458 <default_free_pages+0x164>
ffffffffc0202328:	6798                	ld	a4,8(a5)
ffffffffc020232a:	8b09                	andi	a4,a4,2
ffffffffc020232c:	12071663          	bnez	a4,ffffffffc0202458 <default_free_pages+0x164>
ffffffffc0202330:	0007b423          	sd	zero,8(a5)
ffffffffc0202334:	0007a023          	sw	zero,0(a5)
ffffffffc0202338:	04878793          	addi	a5,a5,72
ffffffffc020233c:	fed792e3          	bne	a5,a3,ffffffffc0202320 <default_free_pages+0x2c>
ffffffffc0202340:	2581                	sext.w	a1,a1
ffffffffc0202342:	cd0c                	sw	a1,24(a0)
ffffffffc0202344:	00850893          	addi	a7,a0,8
ffffffffc0202348:	4789                	li	a5,2
ffffffffc020234a:	40f8b02f          	amoor.d	zero,a5,(a7)
ffffffffc020234e:	0000e697          	auipc	a3,0xe
ffffffffc0202352:	20268693          	addi	a3,a3,514 # ffffffffc0210550 <free_area>
ffffffffc0202356:	4a98                	lw	a4,16(a3)
ffffffffc0202358:	669c                	ld	a5,8(a3)
ffffffffc020235a:	9db9                	addw	a1,a1,a4
ffffffffc020235c:	0000e717          	auipc	a4,0xe
ffffffffc0202360:	20b72223          	sw	a1,516(a4) # ffffffffc0210560 <free_area+0x10>
ffffffffc0202364:	08d78f63          	beq	a5,a3,ffffffffc0202402 <default_free_pages+0x10e>
ffffffffc0202368:	fe078713          	addi	a4,a5,-32
ffffffffc020236c:	628c                	ld	a1,0(a3)
ffffffffc020236e:	4801                	li	a6,0
ffffffffc0202370:	02050613          	addi	a2,a0,32
ffffffffc0202374:	00e56a63          	bltu	a0,a4,ffffffffc0202388 <default_free_pages+0x94>
ffffffffc0202378:	6798                	ld	a4,8(a5)
ffffffffc020237a:	02d70563          	beq	a4,a3,ffffffffc02023a4 <default_free_pages+0xb0>
ffffffffc020237e:	87ba                	mv	a5,a4
ffffffffc0202380:	fe078713          	addi	a4,a5,-32
ffffffffc0202384:	fee57ae3          	bgeu	a0,a4,ffffffffc0202378 <default_free_pages+0x84>
ffffffffc0202388:	00080663          	beqz	a6,ffffffffc0202394 <default_free_pages+0xa0>
ffffffffc020238c:	0000e817          	auipc	a6,0xe
ffffffffc0202390:	1cb83223          	sd	a1,452(a6) # ffffffffc0210550 <free_area>
ffffffffc0202394:	638c                	ld	a1,0(a5)
ffffffffc0202396:	e390                	sd	a2,0(a5)
ffffffffc0202398:	e590                	sd	a2,8(a1)
ffffffffc020239a:	f51c                	sd	a5,40(a0)
ffffffffc020239c:	f10c                	sd	a1,32(a0)
ffffffffc020239e:	02d59163          	bne	a1,a3,ffffffffc02023c0 <default_free_pages+0xcc>
ffffffffc02023a2:	a091                	j	ffffffffc02023e6 <default_free_pages+0xf2>
ffffffffc02023a4:	e790                	sd	a2,8(a5)
ffffffffc02023a6:	f514                	sd	a3,40(a0)
ffffffffc02023a8:	6798                	ld	a4,8(a5)
ffffffffc02023aa:	f11c                	sd	a5,32(a0)
ffffffffc02023ac:	85b2                	mv	a1,a2
ffffffffc02023ae:	00d70563          	beq	a4,a3,ffffffffc02023b8 <default_free_pages+0xc4>
ffffffffc02023b2:	4805                	li	a6,1
ffffffffc02023b4:	87ba                	mv	a5,a4
ffffffffc02023b6:	b7e9                	j	ffffffffc0202380 <default_free_pages+0x8c>
ffffffffc02023b8:	e290                	sd	a2,0(a3)
ffffffffc02023ba:	85be                	mv	a1,a5
ffffffffc02023bc:	02d78163          	beq	a5,a3,ffffffffc02023de <default_free_pages+0xea>
ffffffffc02023c0:	ff85a803          	lw	a6,-8(a1) # ff8 <BASE_ADDRESS-0xffffffffc01ff008>
ffffffffc02023c4:	fe058613          	addi	a2,a1,-32
ffffffffc02023c8:	02081713          	slli	a4,a6,0x20
ffffffffc02023cc:	9301                	srli	a4,a4,0x20
ffffffffc02023ce:	00371793          	slli	a5,a4,0x3
ffffffffc02023d2:	97ba                	add	a5,a5,a4
ffffffffc02023d4:	078e                	slli	a5,a5,0x3
ffffffffc02023d6:	97b2                	add	a5,a5,a2
ffffffffc02023d8:	02f50e63          	beq	a0,a5,ffffffffc0202414 <default_free_pages+0x120>
ffffffffc02023dc:	751c                	ld	a5,40(a0)
ffffffffc02023de:	fe078713          	addi	a4,a5,-32
ffffffffc02023e2:	00d78d63          	beq	a5,a3,ffffffffc02023fc <default_free_pages+0x108>
ffffffffc02023e6:	4d0c                	lw	a1,24(a0)
ffffffffc02023e8:	02059613          	slli	a2,a1,0x20
ffffffffc02023ec:	9201                	srli	a2,a2,0x20
ffffffffc02023ee:	00361693          	slli	a3,a2,0x3
ffffffffc02023f2:	96b2                	add	a3,a3,a2
ffffffffc02023f4:	068e                	slli	a3,a3,0x3
ffffffffc02023f6:	96aa                	add	a3,a3,a0
ffffffffc02023f8:	04d70063          	beq	a4,a3,ffffffffc0202438 <default_free_pages+0x144>
ffffffffc02023fc:	60a2                	ld	ra,8(sp)
ffffffffc02023fe:	0141                	addi	sp,sp,16
ffffffffc0202400:	8082                	ret
ffffffffc0202402:	60a2                	ld	ra,8(sp)
ffffffffc0202404:	02050713          	addi	a4,a0,32
ffffffffc0202408:	e398                	sd	a4,0(a5)
ffffffffc020240a:	e798                	sd	a4,8(a5)
ffffffffc020240c:	f51c                	sd	a5,40(a0)
ffffffffc020240e:	f11c                	sd	a5,32(a0)
ffffffffc0202410:	0141                	addi	sp,sp,16
ffffffffc0202412:	8082                	ret
ffffffffc0202414:	4d1c                	lw	a5,24(a0)
ffffffffc0202416:	0107883b          	addw	a6,a5,a6
ffffffffc020241a:	ff05ac23          	sw	a6,-8(a1)
ffffffffc020241e:	57f5                	li	a5,-3
ffffffffc0202420:	60f8b02f          	amoand.d	zero,a5,(a7)
ffffffffc0202424:	02053803          	ld	a6,32(a0)
ffffffffc0202428:	7518                	ld	a4,40(a0)
ffffffffc020242a:	8532                	mv	a0,a2
ffffffffc020242c:	00e83423          	sd	a4,8(a6)
ffffffffc0202430:	659c                	ld	a5,8(a1)
ffffffffc0202432:	01073023          	sd	a6,0(a4)
ffffffffc0202436:	b765                	j	ffffffffc02023de <default_free_pages+0xea>
ffffffffc0202438:	ff87a703          	lw	a4,-8(a5)
ffffffffc020243c:	fe878693          	addi	a3,a5,-24
ffffffffc0202440:	9db9                	addw	a1,a1,a4
ffffffffc0202442:	cd0c                	sw	a1,24(a0)
ffffffffc0202444:	5775                	li	a4,-3
ffffffffc0202446:	60e6b02f          	amoand.d	zero,a4,(a3)
ffffffffc020244a:	6398                	ld	a4,0(a5)
ffffffffc020244c:	679c                	ld	a5,8(a5)
ffffffffc020244e:	60a2                	ld	ra,8(sp)
ffffffffc0202450:	e71c                	sd	a5,8(a4)
ffffffffc0202452:	e398                	sd	a4,0(a5)
ffffffffc0202454:	0141                	addi	sp,sp,16
ffffffffc0202456:	8082                	ret
ffffffffc0202458:	00003697          	auipc	a3,0x3
ffffffffc020245c:	ff868693          	addi	a3,a3,-8 # ffffffffc0205450 <commands+0x12b0>
ffffffffc0202460:	00002617          	auipc	a2,0x2
ffffffffc0202464:	59860613          	addi	a2,a2,1432 # ffffffffc02049f8 <commands+0x858>
ffffffffc0202468:	08300593          	li	a1,131
ffffffffc020246c:	00003517          	auipc	a0,0x3
ffffffffc0202470:	cd450513          	addi	a0,a0,-812 # ffffffffc0205140 <commands+0xfa0>
ffffffffc0202474:	c91fd0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0202478:	00003697          	auipc	a3,0x3
ffffffffc020247c:	00068693          	mv	a3,a3
ffffffffc0202480:	00002617          	auipc	a2,0x2
ffffffffc0202484:	57860613          	addi	a2,a2,1400 # ffffffffc02049f8 <commands+0x858>
ffffffffc0202488:	08000593          	li	a1,128
ffffffffc020248c:	00003517          	auipc	a0,0x3
ffffffffc0202490:	cb450513          	addi	a0,a0,-844 # ffffffffc0205140 <commands+0xfa0>
ffffffffc0202494:	c71fd0ef          	jal	ra,ffffffffc0200104 <__panic>

ffffffffc0202498 <default_alloc_pages>:
ffffffffc0202498:	cd51                	beqz	a0,ffffffffc0202534 <default_alloc_pages+0x9c>
ffffffffc020249a:	0000e597          	auipc	a1,0xe
ffffffffc020249e:	0b658593          	addi	a1,a1,182 # ffffffffc0210550 <free_area>
ffffffffc02024a2:	0105a803          	lw	a6,16(a1)
ffffffffc02024a6:	862a                	mv	a2,a0
ffffffffc02024a8:	02081793          	slli	a5,a6,0x20
ffffffffc02024ac:	9381                	srli	a5,a5,0x20
ffffffffc02024ae:	00a7ee63          	bltu	a5,a0,ffffffffc02024ca <default_alloc_pages+0x32>
ffffffffc02024b2:	87ae                	mv	a5,a1
ffffffffc02024b4:	a801                	j	ffffffffc02024c4 <default_alloc_pages+0x2c>
ffffffffc02024b6:	ff87a703          	lw	a4,-8(a5)
ffffffffc02024ba:	02071693          	slli	a3,a4,0x20
ffffffffc02024be:	9281                	srli	a3,a3,0x20
ffffffffc02024c0:	00c6f763          	bgeu	a3,a2,ffffffffc02024ce <default_alloc_pages+0x36>
ffffffffc02024c4:	679c                	ld	a5,8(a5)
ffffffffc02024c6:	feb798e3          	bne	a5,a1,ffffffffc02024b6 <default_alloc_pages+0x1e>
ffffffffc02024ca:	4501                	li	a0,0
ffffffffc02024cc:	8082                	ret
ffffffffc02024ce:	fe078513          	addi	a0,a5,-32
ffffffffc02024d2:	dd6d                	beqz	a0,ffffffffc02024cc <default_alloc_pages+0x34>
ffffffffc02024d4:	0007b883          	ld	a7,0(a5)
ffffffffc02024d8:	0087b303          	ld	t1,8(a5)
ffffffffc02024dc:	00060e1b          	sext.w	t3,a2
ffffffffc02024e0:	0068b423          	sd	t1,8(a7)
ffffffffc02024e4:	01133023          	sd	a7,0(t1)
ffffffffc02024e8:	02d67b63          	bgeu	a2,a3,ffffffffc020251e <default_alloc_pages+0x86>
ffffffffc02024ec:	00361693          	slli	a3,a2,0x3
ffffffffc02024f0:	96b2                	add	a3,a3,a2
ffffffffc02024f2:	068e                	slli	a3,a3,0x3
ffffffffc02024f4:	96aa                	add	a3,a3,a0
ffffffffc02024f6:	41c7073b          	subw	a4,a4,t3
ffffffffc02024fa:	ce98                	sw	a4,24(a3)
ffffffffc02024fc:	00868613          	addi	a2,a3,8 # ffffffffc0205480 <commands+0x12e0>
ffffffffc0202500:	4709                	li	a4,2
ffffffffc0202502:	40e6302f          	amoor.d	zero,a4,(a2)
ffffffffc0202506:	0088b703          	ld	a4,8(a7)
ffffffffc020250a:	02068613          	addi	a2,a3,32
ffffffffc020250e:	0105a803          	lw	a6,16(a1)
ffffffffc0202512:	e310                	sd	a2,0(a4)
ffffffffc0202514:	00c8b423          	sd	a2,8(a7)
ffffffffc0202518:	f698                	sd	a4,40(a3)
ffffffffc020251a:	0316b023          	sd	a7,32(a3)
ffffffffc020251e:	41c8083b          	subw	a6,a6,t3
ffffffffc0202522:	0000e717          	auipc	a4,0xe
ffffffffc0202526:	03072f23          	sw	a6,62(a4) # ffffffffc0210560 <free_area+0x10>
ffffffffc020252a:	5775                	li	a4,-3
ffffffffc020252c:	17a1                	addi	a5,a5,-24
ffffffffc020252e:	60e7b02f          	amoand.d	zero,a4,(a5)
ffffffffc0202532:	8082                	ret
ffffffffc0202534:	1141                	addi	sp,sp,-16
ffffffffc0202536:	00003697          	auipc	a3,0x3
ffffffffc020253a:	f4268693          	addi	a3,a3,-190 # ffffffffc0205478 <commands+0x12d8>
ffffffffc020253e:	00002617          	auipc	a2,0x2
ffffffffc0202542:	4ba60613          	addi	a2,a2,1210 # ffffffffc02049f8 <commands+0x858>
ffffffffc0202546:	06200593          	li	a1,98
ffffffffc020254a:	00003517          	auipc	a0,0x3
ffffffffc020254e:	bf650513          	addi	a0,a0,-1034 # ffffffffc0205140 <commands+0xfa0>
ffffffffc0202552:	e406                	sd	ra,8(sp)
ffffffffc0202554:	bb1fd0ef          	jal	ra,ffffffffc0200104 <__panic>

ffffffffc0202558 <default_init_memmap>:
ffffffffc0202558:	1141                	addi	sp,sp,-16
ffffffffc020255a:	e406                	sd	ra,8(sp)
ffffffffc020255c:	c1fd                	beqz	a1,ffffffffc0202642 <default_init_memmap+0xea>
ffffffffc020255e:	00359693          	slli	a3,a1,0x3
ffffffffc0202562:	96ae                	add	a3,a3,a1
ffffffffc0202564:	068e                	slli	a3,a3,0x3
ffffffffc0202566:	96aa                	add	a3,a3,a0
ffffffffc0202568:	02d50463          	beq	a0,a3,ffffffffc0202590 <default_init_memmap+0x38>
ffffffffc020256c:	6518                	ld	a4,8(a0)
ffffffffc020256e:	87aa                	mv	a5,a0
ffffffffc0202570:	8b05                	andi	a4,a4,1
ffffffffc0202572:	e709                	bnez	a4,ffffffffc020257c <default_init_memmap+0x24>
ffffffffc0202574:	a07d                	j	ffffffffc0202622 <default_init_memmap+0xca>
ffffffffc0202576:	6798                	ld	a4,8(a5)
ffffffffc0202578:	8b05                	andi	a4,a4,1
ffffffffc020257a:	c745                	beqz	a4,ffffffffc0202622 <default_init_memmap+0xca>
ffffffffc020257c:	0007ac23          	sw	zero,24(a5)
ffffffffc0202580:	0007b423          	sd	zero,8(a5)
ffffffffc0202584:	0007a023          	sw	zero,0(a5)
ffffffffc0202588:	04878793          	addi	a5,a5,72
ffffffffc020258c:	fed795e3          	bne	a5,a3,ffffffffc0202576 <default_init_memmap+0x1e>
ffffffffc0202590:	2581                	sext.w	a1,a1
ffffffffc0202592:	cd0c                	sw	a1,24(a0)
ffffffffc0202594:	4789                	li	a5,2
ffffffffc0202596:	00850713          	addi	a4,a0,8
ffffffffc020259a:	40f7302f          	amoor.d	zero,a5,(a4)
ffffffffc020259e:	0000e697          	auipc	a3,0xe
ffffffffc02025a2:	fb268693          	addi	a3,a3,-78 # ffffffffc0210550 <free_area>
ffffffffc02025a6:	4a98                	lw	a4,16(a3)
ffffffffc02025a8:	669c                	ld	a5,8(a3)
ffffffffc02025aa:	9db9                	addw	a1,a1,a4
ffffffffc02025ac:	0000e717          	auipc	a4,0xe
ffffffffc02025b0:	fab72a23          	sw	a1,-76(a4) # ffffffffc0210560 <free_area+0x10>
ffffffffc02025b4:	04d78a63          	beq	a5,a3,ffffffffc0202608 <default_init_memmap+0xb0>
ffffffffc02025b8:	fe078713          	addi	a4,a5,-32
ffffffffc02025bc:	628c                	ld	a1,0(a3)
ffffffffc02025be:	4801                	li	a6,0
ffffffffc02025c0:	02050613          	addi	a2,a0,32
ffffffffc02025c4:	00e56a63          	bltu	a0,a4,ffffffffc02025d8 <default_init_memmap+0x80>
ffffffffc02025c8:	6798                	ld	a4,8(a5)
ffffffffc02025ca:	02d70563          	beq	a4,a3,ffffffffc02025f4 <default_init_memmap+0x9c>
ffffffffc02025ce:	87ba                	mv	a5,a4
ffffffffc02025d0:	fe078713          	addi	a4,a5,-32
ffffffffc02025d4:	fee57ae3          	bgeu	a0,a4,ffffffffc02025c8 <default_init_memmap+0x70>
ffffffffc02025d8:	00080663          	beqz	a6,ffffffffc02025e4 <default_init_memmap+0x8c>
ffffffffc02025dc:	0000e717          	auipc	a4,0xe
ffffffffc02025e0:	f6b73a23          	sd	a1,-140(a4) # ffffffffc0210550 <free_area>
ffffffffc02025e4:	6398                	ld	a4,0(a5)
ffffffffc02025e6:	60a2                	ld	ra,8(sp)
ffffffffc02025e8:	e390                	sd	a2,0(a5)
ffffffffc02025ea:	e710                	sd	a2,8(a4)
ffffffffc02025ec:	f51c                	sd	a5,40(a0)
ffffffffc02025ee:	f118                	sd	a4,32(a0)
ffffffffc02025f0:	0141                	addi	sp,sp,16
ffffffffc02025f2:	8082                	ret
ffffffffc02025f4:	e790                	sd	a2,8(a5)
ffffffffc02025f6:	f514                	sd	a3,40(a0)
ffffffffc02025f8:	6798                	ld	a4,8(a5)
ffffffffc02025fa:	f11c                	sd	a5,32(a0)
ffffffffc02025fc:	85b2                	mv	a1,a2
ffffffffc02025fe:	00d70e63          	beq	a4,a3,ffffffffc020261a <default_init_memmap+0xc2>
ffffffffc0202602:	4805                	li	a6,1
ffffffffc0202604:	87ba                	mv	a5,a4
ffffffffc0202606:	b7e9                	j	ffffffffc02025d0 <default_init_memmap+0x78>
ffffffffc0202608:	60a2                	ld	ra,8(sp)
ffffffffc020260a:	02050713          	addi	a4,a0,32
ffffffffc020260e:	e398                	sd	a4,0(a5)
ffffffffc0202610:	e798                	sd	a4,8(a5)
ffffffffc0202612:	f51c                	sd	a5,40(a0)
ffffffffc0202614:	f11c                	sd	a5,32(a0)
ffffffffc0202616:	0141                	addi	sp,sp,16
ffffffffc0202618:	8082                	ret
ffffffffc020261a:	60a2                	ld	ra,8(sp)
ffffffffc020261c:	e290                	sd	a2,0(a3)
ffffffffc020261e:	0141                	addi	sp,sp,16
ffffffffc0202620:	8082                	ret
ffffffffc0202622:	00003697          	auipc	a3,0x3
ffffffffc0202626:	e5e68693          	addi	a3,a3,-418 # ffffffffc0205480 <commands+0x12e0>
ffffffffc020262a:	00002617          	auipc	a2,0x2
ffffffffc020262e:	3ce60613          	addi	a2,a2,974 # ffffffffc02049f8 <commands+0x858>
ffffffffc0202632:	04900593          	li	a1,73
ffffffffc0202636:	00003517          	auipc	a0,0x3
ffffffffc020263a:	b0a50513          	addi	a0,a0,-1270 # ffffffffc0205140 <commands+0xfa0>
ffffffffc020263e:	ac7fd0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0202642:	00003697          	auipc	a3,0x3
ffffffffc0202646:	e3668693          	addi	a3,a3,-458 # ffffffffc0205478 <commands+0x12d8>
ffffffffc020264a:	00002617          	auipc	a2,0x2
ffffffffc020264e:	3ae60613          	addi	a2,a2,942 # ffffffffc02049f8 <commands+0x858>
ffffffffc0202652:	04600593          	li	a1,70
ffffffffc0202656:	00003517          	auipc	a0,0x3
ffffffffc020265a:	aea50513          	addi	a0,a0,-1302 # ffffffffc0205140 <commands+0xfa0>
ffffffffc020265e:	aa7fd0ef          	jal	ra,ffffffffc0200104 <__panic>

ffffffffc0202662 <_clock_init_mm>:
ffffffffc0202662:	4501                	li	a0,0
ffffffffc0202664:	8082                	ret

ffffffffc0202666 <_clock_map_swappable>:
ffffffffc0202666:	4785                	li	a5,1
ffffffffc0202668:	ea1c                	sd	a5,16(a2)
ffffffffc020266a:	4501                	li	a0,0
ffffffffc020266c:	8082                	ret

ffffffffc020266e <_clock_swap_out_victim>:
ffffffffc020266e:	4501                	li	a0,0
ffffffffc0202670:	8082                	ret

ffffffffc0202672 <_clock_init>:
ffffffffc0202672:	4501                	li	a0,0
ffffffffc0202674:	8082                	ret

ffffffffc0202676 <_clock_set_unswappable>:
ffffffffc0202676:	4501                	li	a0,0
ffffffffc0202678:	8082                	ret

ffffffffc020267a <_clock_check_swap>:
ffffffffc020267a:	1141                	addi	sp,sp,-16
ffffffffc020267c:	678d                	lui	a5,0x3
ffffffffc020267e:	4731                	li	a4,12
ffffffffc0202680:	e406                	sd	ra,8(sp)
ffffffffc0202682:	00e78023          	sb	a4,0(a5) # 3000 <BASE_ADDRESS-0xffffffffc01fd000>
ffffffffc0202686:	0000e797          	auipc	a5,0xe
ffffffffc020268a:	dca78793          	addi	a5,a5,-566 # ffffffffc0210450 <pgfault_num>
ffffffffc020268e:	4398                	lw	a4,0(a5)
ffffffffc0202690:	4691                	li	a3,4
ffffffffc0202692:	2701                	sext.w	a4,a4
ffffffffc0202694:	08d71f63          	bne	a4,a3,ffffffffc0202732 <_clock_check_swap+0xb8>
ffffffffc0202698:	6685                	lui	a3,0x1
ffffffffc020269a:	4629                	li	a2,10
ffffffffc020269c:	00c68023          	sb	a2,0(a3) # 1000 <BASE_ADDRESS-0xffffffffc01ff000>
ffffffffc02026a0:	4394                	lw	a3,0(a5)
ffffffffc02026a2:	2681                	sext.w	a3,a3
ffffffffc02026a4:	20e69763          	bne	a3,a4,ffffffffc02028b2 <_clock_check_swap+0x238>
ffffffffc02026a8:	6711                	lui	a4,0x4
ffffffffc02026aa:	4635                	li	a2,13
ffffffffc02026ac:	00c70023          	sb	a2,0(a4) # 4000 <BASE_ADDRESS-0xffffffffc01fc000>
ffffffffc02026b0:	4398                	lw	a4,0(a5)
ffffffffc02026b2:	2701                	sext.w	a4,a4
ffffffffc02026b4:	1cd71f63          	bne	a4,a3,ffffffffc0202892 <_clock_check_swap+0x218>
ffffffffc02026b8:	6689                	lui	a3,0x2
ffffffffc02026ba:	462d                	li	a2,11
ffffffffc02026bc:	00c68023          	sb	a2,0(a3) # 2000 <BASE_ADDRESS-0xffffffffc01fe000>
ffffffffc02026c0:	4394                	lw	a3,0(a5)
ffffffffc02026c2:	2681                	sext.w	a3,a3
ffffffffc02026c4:	1ae69763          	bne	a3,a4,ffffffffc0202872 <_clock_check_swap+0x1f8>
ffffffffc02026c8:	6715                	lui	a4,0x5
ffffffffc02026ca:	46b9                	li	a3,14
ffffffffc02026cc:	00d70023          	sb	a3,0(a4) # 5000 <BASE_ADDRESS-0xffffffffc01fb000>
ffffffffc02026d0:	4398                	lw	a4,0(a5)
ffffffffc02026d2:	4695                	li	a3,5
ffffffffc02026d4:	2701                	sext.w	a4,a4
ffffffffc02026d6:	16d71e63          	bne	a4,a3,ffffffffc0202852 <_clock_check_swap+0x1d8>
ffffffffc02026da:	4394                	lw	a3,0(a5)
ffffffffc02026dc:	2681                	sext.w	a3,a3
ffffffffc02026de:	14e69a63          	bne	a3,a4,ffffffffc0202832 <_clock_check_swap+0x1b8>
ffffffffc02026e2:	4398                	lw	a4,0(a5)
ffffffffc02026e4:	2701                	sext.w	a4,a4
ffffffffc02026e6:	12d71663          	bne	a4,a3,ffffffffc0202812 <_clock_check_swap+0x198>
ffffffffc02026ea:	4394                	lw	a3,0(a5)
ffffffffc02026ec:	2681                	sext.w	a3,a3
ffffffffc02026ee:	10e69263          	bne	a3,a4,ffffffffc02027f2 <_clock_check_swap+0x178>
ffffffffc02026f2:	4398                	lw	a4,0(a5)
ffffffffc02026f4:	2701                	sext.w	a4,a4
ffffffffc02026f6:	0cd71e63          	bne	a4,a3,ffffffffc02027d2 <_clock_check_swap+0x158>
ffffffffc02026fa:	4394                	lw	a3,0(a5)
ffffffffc02026fc:	2681                	sext.w	a3,a3
ffffffffc02026fe:	0ae69a63          	bne	a3,a4,ffffffffc02027b2 <_clock_check_swap+0x138>
ffffffffc0202702:	6715                	lui	a4,0x5
ffffffffc0202704:	46b9                	li	a3,14
ffffffffc0202706:	00d70023          	sb	a3,0(a4) # 5000 <BASE_ADDRESS-0xffffffffc01fb000>
ffffffffc020270a:	4398                	lw	a4,0(a5)
ffffffffc020270c:	4695                	li	a3,5
ffffffffc020270e:	2701                	sext.w	a4,a4
ffffffffc0202710:	08d71163          	bne	a4,a3,ffffffffc0202792 <_clock_check_swap+0x118>
ffffffffc0202714:	6705                	lui	a4,0x1
ffffffffc0202716:	00074683          	lbu	a3,0(a4) # 1000 <BASE_ADDRESS-0xffffffffc01ff000>
ffffffffc020271a:	4729                	li	a4,10
ffffffffc020271c:	04e69b63          	bne	a3,a4,ffffffffc0202772 <_clock_check_swap+0xf8>
ffffffffc0202720:	439c                	lw	a5,0(a5)
ffffffffc0202722:	4719                	li	a4,6
ffffffffc0202724:	2781                	sext.w	a5,a5
ffffffffc0202726:	02e79663          	bne	a5,a4,ffffffffc0202752 <_clock_check_swap+0xd8>
ffffffffc020272a:	60a2                	ld	ra,8(sp)
ffffffffc020272c:	4501                	li	a0,0
ffffffffc020272e:	0141                	addi	sp,sp,16
ffffffffc0202730:	8082                	ret
ffffffffc0202732:	00003697          	auipc	a3,0x3
ffffffffc0202736:	86e68693          	addi	a3,a3,-1938 # ffffffffc0204fa0 <commands+0xe00>
ffffffffc020273a:	00002617          	auipc	a2,0x2
ffffffffc020273e:	2be60613          	addi	a2,a2,702 # ffffffffc02049f8 <commands+0x858>
ffffffffc0202742:	06800593          	li	a1,104
ffffffffc0202746:	00003517          	auipc	a0,0x3
ffffffffc020274a:	d9a50513          	addi	a0,a0,-614 # ffffffffc02054e0 <default_pmm_manager+0x50>
ffffffffc020274e:	9b7fd0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0202752:	00003697          	auipc	a3,0x3
ffffffffc0202756:	dde68693          	addi	a3,a3,-546 # ffffffffc0205530 <default_pmm_manager+0xa0>
ffffffffc020275a:	00002617          	auipc	a2,0x2
ffffffffc020275e:	29e60613          	addi	a2,a2,670 # ffffffffc02049f8 <commands+0x858>
ffffffffc0202762:	07f00593          	li	a1,127
ffffffffc0202766:	00003517          	auipc	a0,0x3
ffffffffc020276a:	d7a50513          	addi	a0,a0,-646 # ffffffffc02054e0 <default_pmm_manager+0x50>
ffffffffc020276e:	997fd0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0202772:	00003697          	auipc	a3,0x3
ffffffffc0202776:	d9668693          	addi	a3,a3,-618 # ffffffffc0205508 <default_pmm_manager+0x78>
ffffffffc020277a:	00002617          	auipc	a2,0x2
ffffffffc020277e:	27e60613          	addi	a2,a2,638 # ffffffffc02049f8 <commands+0x858>
ffffffffc0202782:	07d00593          	li	a1,125
ffffffffc0202786:	00003517          	auipc	a0,0x3
ffffffffc020278a:	d5a50513          	addi	a0,a0,-678 # ffffffffc02054e0 <default_pmm_manager+0x50>
ffffffffc020278e:	977fd0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0202792:	00003697          	auipc	a3,0x3
ffffffffc0202796:	d6668693          	addi	a3,a3,-666 # ffffffffc02054f8 <default_pmm_manager+0x68>
ffffffffc020279a:	00002617          	auipc	a2,0x2
ffffffffc020279e:	25e60613          	addi	a2,a2,606 # ffffffffc02049f8 <commands+0x858>
ffffffffc02027a2:	07c00593          	li	a1,124
ffffffffc02027a6:	00003517          	auipc	a0,0x3
ffffffffc02027aa:	d3a50513          	addi	a0,a0,-710 # ffffffffc02054e0 <default_pmm_manager+0x50>
ffffffffc02027ae:	957fd0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc02027b2:	00003697          	auipc	a3,0x3
ffffffffc02027b6:	d4668693          	addi	a3,a3,-698 # ffffffffc02054f8 <default_pmm_manager+0x68>
ffffffffc02027ba:	00002617          	auipc	a2,0x2
ffffffffc02027be:	23e60613          	addi	a2,a2,574 # ffffffffc02049f8 <commands+0x858>
ffffffffc02027c2:	07a00593          	li	a1,122
ffffffffc02027c6:	00003517          	auipc	a0,0x3
ffffffffc02027ca:	d1a50513          	addi	a0,a0,-742 # ffffffffc02054e0 <default_pmm_manager+0x50>
ffffffffc02027ce:	937fd0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc02027d2:	00003697          	auipc	a3,0x3
ffffffffc02027d6:	d2668693          	addi	a3,a3,-730 # ffffffffc02054f8 <default_pmm_manager+0x68>
ffffffffc02027da:	00002617          	auipc	a2,0x2
ffffffffc02027de:	21e60613          	addi	a2,a2,542 # ffffffffc02049f8 <commands+0x858>
ffffffffc02027e2:	07800593          	li	a1,120
ffffffffc02027e6:	00003517          	auipc	a0,0x3
ffffffffc02027ea:	cfa50513          	addi	a0,a0,-774 # ffffffffc02054e0 <default_pmm_manager+0x50>
ffffffffc02027ee:	917fd0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc02027f2:	00003697          	auipc	a3,0x3
ffffffffc02027f6:	d0668693          	addi	a3,a3,-762 # ffffffffc02054f8 <default_pmm_manager+0x68>
ffffffffc02027fa:	00002617          	auipc	a2,0x2
ffffffffc02027fe:	1fe60613          	addi	a2,a2,510 # ffffffffc02049f8 <commands+0x858>
ffffffffc0202802:	07600593          	li	a1,118
ffffffffc0202806:	00003517          	auipc	a0,0x3
ffffffffc020280a:	cda50513          	addi	a0,a0,-806 # ffffffffc02054e0 <default_pmm_manager+0x50>
ffffffffc020280e:	8f7fd0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0202812:	00003697          	auipc	a3,0x3
ffffffffc0202816:	ce668693          	addi	a3,a3,-794 # ffffffffc02054f8 <default_pmm_manager+0x68>
ffffffffc020281a:	00002617          	auipc	a2,0x2
ffffffffc020281e:	1de60613          	addi	a2,a2,478 # ffffffffc02049f8 <commands+0x858>
ffffffffc0202822:	07400593          	li	a1,116
ffffffffc0202826:	00003517          	auipc	a0,0x3
ffffffffc020282a:	cba50513          	addi	a0,a0,-838 # ffffffffc02054e0 <default_pmm_manager+0x50>
ffffffffc020282e:	8d7fd0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0202832:	00003697          	auipc	a3,0x3
ffffffffc0202836:	cc668693          	addi	a3,a3,-826 # ffffffffc02054f8 <default_pmm_manager+0x68>
ffffffffc020283a:	00002617          	auipc	a2,0x2
ffffffffc020283e:	1be60613          	addi	a2,a2,446 # ffffffffc02049f8 <commands+0x858>
ffffffffc0202842:	07200593          	li	a1,114
ffffffffc0202846:	00003517          	auipc	a0,0x3
ffffffffc020284a:	c9a50513          	addi	a0,a0,-870 # ffffffffc02054e0 <default_pmm_manager+0x50>
ffffffffc020284e:	8b7fd0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0202852:	00003697          	auipc	a3,0x3
ffffffffc0202856:	ca668693          	addi	a3,a3,-858 # ffffffffc02054f8 <default_pmm_manager+0x68>
ffffffffc020285a:	00002617          	auipc	a2,0x2
ffffffffc020285e:	19e60613          	addi	a2,a2,414 # ffffffffc02049f8 <commands+0x858>
ffffffffc0202862:	07000593          	li	a1,112
ffffffffc0202866:	00003517          	auipc	a0,0x3
ffffffffc020286a:	c7a50513          	addi	a0,a0,-902 # ffffffffc02054e0 <default_pmm_manager+0x50>
ffffffffc020286e:	897fd0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0202872:	00002697          	auipc	a3,0x2
ffffffffc0202876:	72e68693          	addi	a3,a3,1838 # ffffffffc0204fa0 <commands+0xe00>
ffffffffc020287a:	00002617          	auipc	a2,0x2
ffffffffc020287e:	17e60613          	addi	a2,a2,382 # ffffffffc02049f8 <commands+0x858>
ffffffffc0202882:	06e00593          	li	a1,110
ffffffffc0202886:	00003517          	auipc	a0,0x3
ffffffffc020288a:	c5a50513          	addi	a0,a0,-934 # ffffffffc02054e0 <default_pmm_manager+0x50>
ffffffffc020288e:	877fd0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0202892:	00002697          	auipc	a3,0x2
ffffffffc0202896:	70e68693          	addi	a3,a3,1806 # ffffffffc0204fa0 <commands+0xe00>
ffffffffc020289a:	00002617          	auipc	a2,0x2
ffffffffc020289e:	15e60613          	addi	a2,a2,350 # ffffffffc02049f8 <commands+0x858>
ffffffffc02028a2:	06c00593          	li	a1,108
ffffffffc02028a6:	00003517          	auipc	a0,0x3
ffffffffc02028aa:	c3a50513          	addi	a0,a0,-966 # ffffffffc02054e0 <default_pmm_manager+0x50>
ffffffffc02028ae:	857fd0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc02028b2:	00002697          	auipc	a3,0x2
ffffffffc02028b6:	6ee68693          	addi	a3,a3,1774 # ffffffffc0204fa0 <commands+0xe00>
ffffffffc02028ba:	00002617          	auipc	a2,0x2
ffffffffc02028be:	13e60613          	addi	a2,a2,318 # ffffffffc02049f8 <commands+0x858>
ffffffffc02028c2:	06a00593          	li	a1,106
ffffffffc02028c6:	00003517          	auipc	a0,0x3
ffffffffc02028ca:	c1a50513          	addi	a0,a0,-998 # ffffffffc02054e0 <default_pmm_manager+0x50>
ffffffffc02028ce:	837fd0ef          	jal	ra,ffffffffc0200104 <__panic>

ffffffffc02028d2 <_clock_tick_event>:
ffffffffc02028d2:	4501                	li	a0,0
ffffffffc02028d4:	8082                	ret

ffffffffc02028d6 <pa2page.part.4>:
ffffffffc02028d6:	1141                	addi	sp,sp,-16
ffffffffc02028d8:	00002617          	auipc	a2,0x2
ffffffffc02028dc:	41860613          	addi	a2,a2,1048 # ffffffffc0204cf0 <commands+0xb50>
ffffffffc02028e0:	06500593          	li	a1,101
ffffffffc02028e4:	00002517          	auipc	a0,0x2
ffffffffc02028e8:	42c50513          	addi	a0,a0,1068 # ffffffffc0204d10 <commands+0xb70>
ffffffffc02028ec:	e406                	sd	ra,8(sp)
ffffffffc02028ee:	817fd0ef          	jal	ra,ffffffffc0200104 <__panic>

ffffffffc02028f2 <alloc_pages>:
ffffffffc02028f2:	715d                	addi	sp,sp,-80
ffffffffc02028f4:	e0a2                	sd	s0,64(sp)
ffffffffc02028f6:	fc26                	sd	s1,56(sp)
ffffffffc02028f8:	f84a                	sd	s2,48(sp)
ffffffffc02028fa:	f44e                	sd	s3,40(sp)
ffffffffc02028fc:	f052                	sd	s4,32(sp)
ffffffffc02028fe:	ec56                	sd	s5,24(sp)
ffffffffc0202900:	e486                	sd	ra,72(sp)
ffffffffc0202902:	842a                	mv	s0,a0
ffffffffc0202904:	0000e497          	auipc	s1,0xe
ffffffffc0202908:	c6448493          	addi	s1,s1,-924 # ffffffffc0210568 <pmm_manager>
ffffffffc020290c:	4985                	li	s3,1
ffffffffc020290e:	0000ea17          	auipc	s4,0xe
ffffffffc0202912:	b52a0a13          	addi	s4,s4,-1198 # ffffffffc0210460 <swap_init_ok>
ffffffffc0202916:	0005091b          	sext.w	s2,a0
ffffffffc020291a:	0000ea97          	auipc	s5,0xe
ffffffffc020291e:	b66a8a93          	addi	s5,s5,-1178 # ffffffffc0210480 <check_mm_struct>
ffffffffc0202922:	a00d                	j	ffffffffc0202944 <alloc_pages+0x52>
ffffffffc0202924:	609c                	ld	a5,0(s1)
ffffffffc0202926:	6f9c                	ld	a5,24(a5)
ffffffffc0202928:	9782                	jalr	a5
ffffffffc020292a:	4601                	li	a2,0
ffffffffc020292c:	85ca                	mv	a1,s2
ffffffffc020292e:	ed0d                	bnez	a0,ffffffffc0202968 <alloc_pages+0x76>
ffffffffc0202930:	0289ec63          	bltu	s3,s0,ffffffffc0202968 <alloc_pages+0x76>
ffffffffc0202934:	000a2783          	lw	a5,0(s4)
ffffffffc0202938:	2781                	sext.w	a5,a5
ffffffffc020293a:	c79d                	beqz	a5,ffffffffc0202968 <alloc_pages+0x76>
ffffffffc020293c:	000ab503          	ld	a0,0(s5)
ffffffffc0202940:	822ff0ef          	jal	ra,ffffffffc0201962 <swap_out>
ffffffffc0202944:	100027f3          	csrr	a5,sstatus
ffffffffc0202948:	8b89                	andi	a5,a5,2
ffffffffc020294a:	8522                	mv	a0,s0
ffffffffc020294c:	dfe1                	beqz	a5,ffffffffc0202924 <alloc_pages+0x32>
ffffffffc020294e:	ba5fd0ef          	jal	ra,ffffffffc02004f2 <intr_disable>
ffffffffc0202952:	609c                	ld	a5,0(s1)
ffffffffc0202954:	8522                	mv	a0,s0
ffffffffc0202956:	6f9c                	ld	a5,24(a5)
ffffffffc0202958:	9782                	jalr	a5
ffffffffc020295a:	e42a                	sd	a0,8(sp)
ffffffffc020295c:	b91fd0ef          	jal	ra,ffffffffc02004ec <intr_enable>
ffffffffc0202960:	6522                	ld	a0,8(sp)
ffffffffc0202962:	4601                	li	a2,0
ffffffffc0202964:	85ca                	mv	a1,s2
ffffffffc0202966:	d569                	beqz	a0,ffffffffc0202930 <alloc_pages+0x3e>
ffffffffc0202968:	60a6                	ld	ra,72(sp)
ffffffffc020296a:	6406                	ld	s0,64(sp)
ffffffffc020296c:	74e2                	ld	s1,56(sp)
ffffffffc020296e:	7942                	ld	s2,48(sp)
ffffffffc0202970:	79a2                	ld	s3,40(sp)
ffffffffc0202972:	7a02                	ld	s4,32(sp)
ffffffffc0202974:	6ae2                	ld	s5,24(sp)
ffffffffc0202976:	6161                	addi	sp,sp,80
ffffffffc0202978:	8082                	ret

ffffffffc020297a <free_pages>:
ffffffffc020297a:	100027f3          	csrr	a5,sstatus
ffffffffc020297e:	8b89                	andi	a5,a5,2
ffffffffc0202980:	eb89                	bnez	a5,ffffffffc0202992 <free_pages+0x18>
ffffffffc0202982:	0000e797          	auipc	a5,0xe
ffffffffc0202986:	be678793          	addi	a5,a5,-1050 # ffffffffc0210568 <pmm_manager>
ffffffffc020298a:	639c                	ld	a5,0(a5)
ffffffffc020298c:	0207b303          	ld	t1,32(a5)
ffffffffc0202990:	8302                	jr	t1
ffffffffc0202992:	1101                	addi	sp,sp,-32
ffffffffc0202994:	ec06                	sd	ra,24(sp)
ffffffffc0202996:	e822                	sd	s0,16(sp)
ffffffffc0202998:	e426                	sd	s1,8(sp)
ffffffffc020299a:	842a                	mv	s0,a0
ffffffffc020299c:	84ae                	mv	s1,a1
ffffffffc020299e:	b55fd0ef          	jal	ra,ffffffffc02004f2 <intr_disable>
ffffffffc02029a2:	0000e797          	auipc	a5,0xe
ffffffffc02029a6:	bc678793          	addi	a5,a5,-1082 # ffffffffc0210568 <pmm_manager>
ffffffffc02029aa:	639c                	ld	a5,0(a5)
ffffffffc02029ac:	85a6                	mv	a1,s1
ffffffffc02029ae:	8522                	mv	a0,s0
ffffffffc02029b0:	739c                	ld	a5,32(a5)
ffffffffc02029b2:	9782                	jalr	a5
ffffffffc02029b4:	6442                	ld	s0,16(sp)
ffffffffc02029b6:	60e2                	ld	ra,24(sp)
ffffffffc02029b8:	64a2                	ld	s1,8(sp)
ffffffffc02029ba:	6105                	addi	sp,sp,32
ffffffffc02029bc:	b31fd06f          	j	ffffffffc02004ec <intr_enable>

ffffffffc02029c0 <nr_free_pages>:
ffffffffc02029c0:	100027f3          	csrr	a5,sstatus
ffffffffc02029c4:	8b89                	andi	a5,a5,2
ffffffffc02029c6:	eb89                	bnez	a5,ffffffffc02029d8 <nr_free_pages+0x18>
ffffffffc02029c8:	0000e797          	auipc	a5,0xe
ffffffffc02029cc:	ba078793          	addi	a5,a5,-1120 # ffffffffc0210568 <pmm_manager>
ffffffffc02029d0:	639c                	ld	a5,0(a5)
ffffffffc02029d2:	0287b303          	ld	t1,40(a5)
ffffffffc02029d6:	8302                	jr	t1
ffffffffc02029d8:	1141                	addi	sp,sp,-16
ffffffffc02029da:	e406                	sd	ra,8(sp)
ffffffffc02029dc:	e022                	sd	s0,0(sp)
ffffffffc02029de:	b15fd0ef          	jal	ra,ffffffffc02004f2 <intr_disable>
ffffffffc02029e2:	0000e797          	auipc	a5,0xe
ffffffffc02029e6:	b8678793          	addi	a5,a5,-1146 # ffffffffc0210568 <pmm_manager>
ffffffffc02029ea:	639c                	ld	a5,0(a5)
ffffffffc02029ec:	779c                	ld	a5,40(a5)
ffffffffc02029ee:	9782                	jalr	a5
ffffffffc02029f0:	842a                	mv	s0,a0
ffffffffc02029f2:	afbfd0ef          	jal	ra,ffffffffc02004ec <intr_enable>
ffffffffc02029f6:	8522                	mv	a0,s0
ffffffffc02029f8:	60a2                	ld	ra,8(sp)
ffffffffc02029fa:	6402                	ld	s0,0(sp)
ffffffffc02029fc:	0141                	addi	sp,sp,16
ffffffffc02029fe:	8082                	ret

ffffffffc0202a00 <get_pte>:
ffffffffc0202a00:	715d                	addi	sp,sp,-80
ffffffffc0202a02:	fc26                	sd	s1,56(sp)
ffffffffc0202a04:	01e5d493          	srli	s1,a1,0x1e
ffffffffc0202a08:	1ff4f493          	andi	s1,s1,511
ffffffffc0202a0c:	048e                	slli	s1,s1,0x3
ffffffffc0202a0e:	94aa                	add	s1,s1,a0
ffffffffc0202a10:	6094                	ld	a3,0(s1)
ffffffffc0202a12:	f84a                	sd	s2,48(sp)
ffffffffc0202a14:	f44e                	sd	s3,40(sp)
ffffffffc0202a16:	f052                	sd	s4,32(sp)
ffffffffc0202a18:	e486                	sd	ra,72(sp)
ffffffffc0202a1a:	e0a2                	sd	s0,64(sp)
ffffffffc0202a1c:	ec56                	sd	s5,24(sp)
ffffffffc0202a1e:	e85a                	sd	s6,16(sp)
ffffffffc0202a20:	e45e                	sd	s7,8(sp)
ffffffffc0202a22:	0016f793          	andi	a5,a3,1
ffffffffc0202a26:	892e                	mv	s2,a1
ffffffffc0202a28:	8a32                	mv	s4,a2
ffffffffc0202a2a:	0000e997          	auipc	s3,0xe
ffffffffc0202a2e:	a4698993          	addi	s3,s3,-1466 # ffffffffc0210470 <npage>
ffffffffc0202a32:	e3c9                	bnez	a5,ffffffffc0202ab4 <get_pte+0xb4>
ffffffffc0202a34:	16060163          	beqz	a2,ffffffffc0202b96 <get_pte+0x196>
ffffffffc0202a38:	4505                	li	a0,1
ffffffffc0202a3a:	eb9ff0ef          	jal	ra,ffffffffc02028f2 <alloc_pages>
ffffffffc0202a3e:	842a                	mv	s0,a0
ffffffffc0202a40:	14050b63          	beqz	a0,ffffffffc0202b96 <get_pte+0x196>
ffffffffc0202a44:	0000eb97          	auipc	s7,0xe
ffffffffc0202a48:	b3cb8b93          	addi	s7,s7,-1220 # ffffffffc0210580 <pages>
ffffffffc0202a4c:	000bb503          	ld	a0,0(s7)
ffffffffc0202a50:	00002797          	auipc	a5,0x2
ffffffffc0202a54:	6e878793          	addi	a5,a5,1768 # ffffffffc0205138 <commands+0xf98>
ffffffffc0202a58:	0007bb03          	ld	s6,0(a5)
ffffffffc0202a5c:	40a40533          	sub	a0,s0,a0
ffffffffc0202a60:	850d                	srai	a0,a0,0x3
ffffffffc0202a62:	03650533          	mul	a0,a0,s6
ffffffffc0202a66:	00080ab7          	lui	s5,0x80
ffffffffc0202a6a:	0000e997          	auipc	s3,0xe
ffffffffc0202a6e:	a0698993          	addi	s3,s3,-1530 # ffffffffc0210470 <npage>
ffffffffc0202a72:	4785                	li	a5,1
ffffffffc0202a74:	0009b703          	ld	a4,0(s3)
ffffffffc0202a78:	c01c                	sw	a5,0(s0)
ffffffffc0202a7a:	9556                	add	a0,a0,s5
ffffffffc0202a7c:	00c51793          	slli	a5,a0,0xc
ffffffffc0202a80:	83b1                	srli	a5,a5,0xc
ffffffffc0202a82:	0532                	slli	a0,a0,0xc
ffffffffc0202a84:	16e7f063          	bgeu	a5,a4,ffffffffc0202be4 <get_pte+0x1e4>
ffffffffc0202a88:	0000e797          	auipc	a5,0xe
ffffffffc0202a8c:	ae878793          	addi	a5,a5,-1304 # ffffffffc0210570 <va_pa_offset>
ffffffffc0202a90:	639c                	ld	a5,0(a5)
ffffffffc0202a92:	6605                	lui	a2,0x1
ffffffffc0202a94:	4581                	li	a1,0
ffffffffc0202a96:	953e                	add	a0,a0,a5
ffffffffc0202a98:	0e8010ef          	jal	ra,ffffffffc0203b80 <memset>
ffffffffc0202a9c:	000bb683          	ld	a3,0(s7)
ffffffffc0202aa0:	40d406b3          	sub	a3,s0,a3
ffffffffc0202aa4:	868d                	srai	a3,a3,0x3
ffffffffc0202aa6:	036686b3          	mul	a3,a3,s6
ffffffffc0202aaa:	96d6                	add	a3,a3,s5
ffffffffc0202aac:	06aa                	slli	a3,a3,0xa
ffffffffc0202aae:	0116e693          	ori	a3,a3,17
ffffffffc0202ab2:	e094                	sd	a3,0(s1)
ffffffffc0202ab4:	77fd                	lui	a5,0xfffff
ffffffffc0202ab6:	068a                	slli	a3,a3,0x2
ffffffffc0202ab8:	0009b703          	ld	a4,0(s3)
ffffffffc0202abc:	8efd                	and	a3,a3,a5
ffffffffc0202abe:	00c6d793          	srli	a5,a3,0xc
ffffffffc0202ac2:	0ce7fc63          	bgeu	a5,a4,ffffffffc0202b9a <get_pte+0x19a>
ffffffffc0202ac6:	0000ea97          	auipc	s5,0xe
ffffffffc0202aca:	aaaa8a93          	addi	s5,s5,-1366 # ffffffffc0210570 <va_pa_offset>
ffffffffc0202ace:	000ab403          	ld	s0,0(s5)
ffffffffc0202ad2:	01595793          	srli	a5,s2,0x15
ffffffffc0202ad6:	1ff7f793          	andi	a5,a5,511
ffffffffc0202ada:	96a2                	add	a3,a3,s0
ffffffffc0202adc:	00379413          	slli	s0,a5,0x3
ffffffffc0202ae0:	9436                	add	s0,s0,a3
ffffffffc0202ae2:	6014                	ld	a3,0(s0)
ffffffffc0202ae4:	0016f793          	andi	a5,a3,1
ffffffffc0202ae8:	ebbd                	bnez	a5,ffffffffc0202b5e <get_pte+0x15e>
ffffffffc0202aea:	0a0a0663          	beqz	s4,ffffffffc0202b96 <get_pte+0x196>
ffffffffc0202aee:	4505                	li	a0,1
ffffffffc0202af0:	e03ff0ef          	jal	ra,ffffffffc02028f2 <alloc_pages>
ffffffffc0202af4:	84aa                	mv	s1,a0
ffffffffc0202af6:	c145                	beqz	a0,ffffffffc0202b96 <get_pte+0x196>
ffffffffc0202af8:	0000eb97          	auipc	s7,0xe
ffffffffc0202afc:	a88b8b93          	addi	s7,s7,-1400 # ffffffffc0210580 <pages>
ffffffffc0202b00:	000bb503          	ld	a0,0(s7)
ffffffffc0202b04:	00002797          	auipc	a5,0x2
ffffffffc0202b08:	63478793          	addi	a5,a5,1588 # ffffffffc0205138 <commands+0xf98>
ffffffffc0202b0c:	0007bb03          	ld	s6,0(a5)
ffffffffc0202b10:	40a48533          	sub	a0,s1,a0
ffffffffc0202b14:	850d                	srai	a0,a0,0x3
ffffffffc0202b16:	03650533          	mul	a0,a0,s6
ffffffffc0202b1a:	00080a37          	lui	s4,0x80
ffffffffc0202b1e:	4785                	li	a5,1
ffffffffc0202b20:	0009b703          	ld	a4,0(s3)
ffffffffc0202b24:	c09c                	sw	a5,0(s1)
ffffffffc0202b26:	9552                	add	a0,a0,s4
ffffffffc0202b28:	00c51793          	slli	a5,a0,0xc
ffffffffc0202b2c:	83b1                	srli	a5,a5,0xc
ffffffffc0202b2e:	0532                	slli	a0,a0,0xc
ffffffffc0202b30:	08e7fd63          	bgeu	a5,a4,ffffffffc0202bca <get_pte+0x1ca>
ffffffffc0202b34:	000ab783          	ld	a5,0(s5)
ffffffffc0202b38:	6605                	lui	a2,0x1
ffffffffc0202b3a:	4581                	li	a1,0
ffffffffc0202b3c:	953e                	add	a0,a0,a5
ffffffffc0202b3e:	042010ef          	jal	ra,ffffffffc0203b80 <memset>
ffffffffc0202b42:	000bb683          	ld	a3,0(s7)
ffffffffc0202b46:	40d486b3          	sub	a3,s1,a3
ffffffffc0202b4a:	868d                	srai	a3,a3,0x3
ffffffffc0202b4c:	036686b3          	mul	a3,a3,s6
ffffffffc0202b50:	96d2                	add	a3,a3,s4
ffffffffc0202b52:	06aa                	slli	a3,a3,0xa
ffffffffc0202b54:	0116e693          	ori	a3,a3,17
ffffffffc0202b58:	e014                	sd	a3,0(s0)
ffffffffc0202b5a:	0009b703          	ld	a4,0(s3)
ffffffffc0202b5e:	068a                	slli	a3,a3,0x2
ffffffffc0202b60:	757d                	lui	a0,0xfffff
ffffffffc0202b62:	8ee9                	and	a3,a3,a0
ffffffffc0202b64:	00c6d793          	srli	a5,a3,0xc
ffffffffc0202b68:	04e7f563          	bgeu	a5,a4,ffffffffc0202bb2 <get_pte+0x1b2>
ffffffffc0202b6c:	000ab503          	ld	a0,0(s5)
ffffffffc0202b70:	00c95793          	srli	a5,s2,0xc
ffffffffc0202b74:	1ff7f793          	andi	a5,a5,511
ffffffffc0202b78:	96aa                	add	a3,a3,a0
ffffffffc0202b7a:	00379513          	slli	a0,a5,0x3
ffffffffc0202b7e:	9536                	add	a0,a0,a3
ffffffffc0202b80:	60a6                	ld	ra,72(sp)
ffffffffc0202b82:	6406                	ld	s0,64(sp)
ffffffffc0202b84:	74e2                	ld	s1,56(sp)
ffffffffc0202b86:	7942                	ld	s2,48(sp)
ffffffffc0202b88:	79a2                	ld	s3,40(sp)
ffffffffc0202b8a:	7a02                	ld	s4,32(sp)
ffffffffc0202b8c:	6ae2                	ld	s5,24(sp)
ffffffffc0202b8e:	6b42                	ld	s6,16(sp)
ffffffffc0202b90:	6ba2                	ld	s7,8(sp)
ffffffffc0202b92:	6161                	addi	sp,sp,80
ffffffffc0202b94:	8082                	ret
ffffffffc0202b96:	4501                	li	a0,0
ffffffffc0202b98:	b7e5                	j	ffffffffc0202b80 <get_pte+0x180>
ffffffffc0202b9a:	00003617          	auipc	a2,0x3
ffffffffc0202b9e:	9be60613          	addi	a2,a2,-1602 # ffffffffc0205558 <default_pmm_manager+0xc8>
ffffffffc0202ba2:	10200593          	li	a1,258
ffffffffc0202ba6:	00003517          	auipc	a0,0x3
ffffffffc0202baa:	9da50513          	addi	a0,a0,-1574 # ffffffffc0205580 <default_pmm_manager+0xf0>
ffffffffc0202bae:	d56fd0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0202bb2:	00003617          	auipc	a2,0x3
ffffffffc0202bb6:	9a660613          	addi	a2,a2,-1626 # ffffffffc0205558 <default_pmm_manager+0xc8>
ffffffffc0202bba:	10f00593          	li	a1,271
ffffffffc0202bbe:	00003517          	auipc	a0,0x3
ffffffffc0202bc2:	9c250513          	addi	a0,a0,-1598 # ffffffffc0205580 <default_pmm_manager+0xf0>
ffffffffc0202bc6:	d3efd0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0202bca:	86aa                	mv	a3,a0
ffffffffc0202bcc:	00003617          	auipc	a2,0x3
ffffffffc0202bd0:	98c60613          	addi	a2,a2,-1652 # ffffffffc0205558 <default_pmm_manager+0xc8>
ffffffffc0202bd4:	10b00593          	li	a1,267
ffffffffc0202bd8:	00003517          	auipc	a0,0x3
ffffffffc0202bdc:	9a850513          	addi	a0,a0,-1624 # ffffffffc0205580 <default_pmm_manager+0xf0>
ffffffffc0202be0:	d24fd0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0202be4:	86aa                	mv	a3,a0
ffffffffc0202be6:	00003617          	auipc	a2,0x3
ffffffffc0202bea:	97260613          	addi	a2,a2,-1678 # ffffffffc0205558 <default_pmm_manager+0xc8>
ffffffffc0202bee:	0ff00593          	li	a1,255
ffffffffc0202bf2:	00003517          	auipc	a0,0x3
ffffffffc0202bf6:	98e50513          	addi	a0,a0,-1650 # ffffffffc0205580 <default_pmm_manager+0xf0>
ffffffffc0202bfa:	d0afd0ef          	jal	ra,ffffffffc0200104 <__panic>

ffffffffc0202bfe <get_page>:
ffffffffc0202bfe:	1141                	addi	sp,sp,-16
ffffffffc0202c00:	e022                	sd	s0,0(sp)
ffffffffc0202c02:	8432                	mv	s0,a2
ffffffffc0202c04:	4601                	li	a2,0
ffffffffc0202c06:	e406                	sd	ra,8(sp)
ffffffffc0202c08:	df9ff0ef          	jal	ra,ffffffffc0202a00 <get_pte>
ffffffffc0202c0c:	c011                	beqz	s0,ffffffffc0202c10 <get_page+0x12>
ffffffffc0202c0e:	e008                	sd	a0,0(s0)
ffffffffc0202c10:	c511                	beqz	a0,ffffffffc0202c1c <get_page+0x1e>
ffffffffc0202c12:	611c                	ld	a5,0(a0)
ffffffffc0202c14:	4501                	li	a0,0
ffffffffc0202c16:	0017f713          	andi	a4,a5,1
ffffffffc0202c1a:	e709                	bnez	a4,ffffffffc0202c24 <get_page+0x26>
ffffffffc0202c1c:	60a2                	ld	ra,8(sp)
ffffffffc0202c1e:	6402                	ld	s0,0(sp)
ffffffffc0202c20:	0141                	addi	sp,sp,16
ffffffffc0202c22:	8082                	ret
ffffffffc0202c24:	0000e717          	auipc	a4,0xe
ffffffffc0202c28:	84c70713          	addi	a4,a4,-1972 # ffffffffc0210470 <npage>
ffffffffc0202c2c:	6318                	ld	a4,0(a4)
ffffffffc0202c2e:	078a                	slli	a5,a5,0x2
ffffffffc0202c30:	83b1                	srli	a5,a5,0xc
ffffffffc0202c32:	02e7f363          	bgeu	a5,a4,ffffffffc0202c58 <get_page+0x5a>
ffffffffc0202c36:	fff80537          	lui	a0,0xfff80
ffffffffc0202c3a:	97aa                	add	a5,a5,a0
ffffffffc0202c3c:	0000e697          	auipc	a3,0xe
ffffffffc0202c40:	94468693          	addi	a3,a3,-1724 # ffffffffc0210580 <pages>
ffffffffc0202c44:	6288                	ld	a0,0(a3)
ffffffffc0202c46:	60a2                	ld	ra,8(sp)
ffffffffc0202c48:	6402                	ld	s0,0(sp)
ffffffffc0202c4a:	00379713          	slli	a4,a5,0x3
ffffffffc0202c4e:	97ba                	add	a5,a5,a4
ffffffffc0202c50:	078e                	slli	a5,a5,0x3
ffffffffc0202c52:	953e                	add	a0,a0,a5
ffffffffc0202c54:	0141                	addi	sp,sp,16
ffffffffc0202c56:	8082                	ret
ffffffffc0202c58:	c7fff0ef          	jal	ra,ffffffffc02028d6 <pa2page.part.4>

ffffffffc0202c5c <page_remove>:
ffffffffc0202c5c:	1141                	addi	sp,sp,-16
ffffffffc0202c5e:	4601                	li	a2,0
ffffffffc0202c60:	e406                	sd	ra,8(sp)
ffffffffc0202c62:	e022                	sd	s0,0(sp)
ffffffffc0202c64:	d9dff0ef          	jal	ra,ffffffffc0202a00 <get_pte>
ffffffffc0202c68:	c511                	beqz	a0,ffffffffc0202c74 <page_remove+0x18>
ffffffffc0202c6a:	611c                	ld	a5,0(a0)
ffffffffc0202c6c:	842a                	mv	s0,a0
ffffffffc0202c6e:	0017f713          	andi	a4,a5,1
ffffffffc0202c72:	e709                	bnez	a4,ffffffffc0202c7c <page_remove+0x20>
ffffffffc0202c74:	60a2                	ld	ra,8(sp)
ffffffffc0202c76:	6402                	ld	s0,0(sp)
ffffffffc0202c78:	0141                	addi	sp,sp,16
ffffffffc0202c7a:	8082                	ret
ffffffffc0202c7c:	0000d717          	auipc	a4,0xd
ffffffffc0202c80:	7f470713          	addi	a4,a4,2036 # ffffffffc0210470 <npage>
ffffffffc0202c84:	6318                	ld	a4,0(a4)
ffffffffc0202c86:	078a                	slli	a5,a5,0x2
ffffffffc0202c88:	83b1                	srli	a5,a5,0xc
ffffffffc0202c8a:	04e7f063          	bgeu	a5,a4,ffffffffc0202cca <page_remove+0x6e>
ffffffffc0202c8e:	fff80737          	lui	a4,0xfff80
ffffffffc0202c92:	97ba                	add	a5,a5,a4
ffffffffc0202c94:	0000e717          	auipc	a4,0xe
ffffffffc0202c98:	8ec70713          	addi	a4,a4,-1812 # ffffffffc0210580 <pages>
ffffffffc0202c9c:	6308                	ld	a0,0(a4)
ffffffffc0202c9e:	00379713          	slli	a4,a5,0x3
ffffffffc0202ca2:	97ba                	add	a5,a5,a4
ffffffffc0202ca4:	078e                	slli	a5,a5,0x3
ffffffffc0202ca6:	953e                	add	a0,a0,a5
ffffffffc0202ca8:	411c                	lw	a5,0(a0)
ffffffffc0202caa:	fff7871b          	addiw	a4,a5,-1
ffffffffc0202cae:	c118                	sw	a4,0(a0)
ffffffffc0202cb0:	cb09                	beqz	a4,ffffffffc0202cc2 <page_remove+0x66>
ffffffffc0202cb2:	00043023          	sd	zero,0(s0)
ffffffffc0202cb6:	12000073          	sfence.vma
ffffffffc0202cba:	60a2                	ld	ra,8(sp)
ffffffffc0202cbc:	6402                	ld	s0,0(sp)
ffffffffc0202cbe:	0141                	addi	sp,sp,16
ffffffffc0202cc0:	8082                	ret
ffffffffc0202cc2:	4585                	li	a1,1
ffffffffc0202cc4:	cb7ff0ef          	jal	ra,ffffffffc020297a <free_pages>
ffffffffc0202cc8:	b7ed                	j	ffffffffc0202cb2 <page_remove+0x56>
ffffffffc0202cca:	c0dff0ef          	jal	ra,ffffffffc02028d6 <pa2page.part.4>

ffffffffc0202cce <page_insert>:
ffffffffc0202cce:	7179                	addi	sp,sp,-48
ffffffffc0202cd0:	87b2                	mv	a5,a2
ffffffffc0202cd2:	f022                	sd	s0,32(sp)
ffffffffc0202cd4:	4605                	li	a2,1
ffffffffc0202cd6:	842e                	mv	s0,a1
ffffffffc0202cd8:	85be                	mv	a1,a5
ffffffffc0202cda:	ec26                	sd	s1,24(sp)
ffffffffc0202cdc:	f406                	sd	ra,40(sp)
ffffffffc0202cde:	e84a                	sd	s2,16(sp)
ffffffffc0202ce0:	e44e                	sd	s3,8(sp)
ffffffffc0202ce2:	84b6                	mv	s1,a3
ffffffffc0202ce4:	d1dff0ef          	jal	ra,ffffffffc0202a00 <get_pte>
ffffffffc0202ce8:	c945                	beqz	a0,ffffffffc0202d98 <page_insert+0xca>
ffffffffc0202cea:	4014                	lw	a3,0(s0)
ffffffffc0202cec:	611c                	ld	a5,0(a0)
ffffffffc0202cee:	892a                	mv	s2,a0
ffffffffc0202cf0:	0016871b          	addiw	a4,a3,1
ffffffffc0202cf4:	c018                	sw	a4,0(s0)
ffffffffc0202cf6:	0017f713          	andi	a4,a5,1
ffffffffc0202cfa:	e339                	bnez	a4,ffffffffc0202d40 <page_insert+0x72>
ffffffffc0202cfc:	0000e797          	auipc	a5,0xe
ffffffffc0202d00:	88478793          	addi	a5,a5,-1916 # ffffffffc0210580 <pages>
ffffffffc0202d04:	639c                	ld	a5,0(a5)
ffffffffc0202d06:	00002717          	auipc	a4,0x2
ffffffffc0202d0a:	43270713          	addi	a4,a4,1074 # ffffffffc0205138 <commands+0xf98>
ffffffffc0202d0e:	40f407b3          	sub	a5,s0,a5
ffffffffc0202d12:	6300                	ld	s0,0(a4)
ffffffffc0202d14:	878d                	srai	a5,a5,0x3
ffffffffc0202d16:	000806b7          	lui	a3,0x80
ffffffffc0202d1a:	028787b3          	mul	a5,a5,s0
ffffffffc0202d1e:	97b6                	add	a5,a5,a3
ffffffffc0202d20:	07aa                	slli	a5,a5,0xa
ffffffffc0202d22:	8fc5                	or	a5,a5,s1
ffffffffc0202d24:	0017e793          	ori	a5,a5,1
ffffffffc0202d28:	00f93023          	sd	a5,0(s2)
ffffffffc0202d2c:	12000073          	sfence.vma
ffffffffc0202d30:	4501                	li	a0,0
ffffffffc0202d32:	70a2                	ld	ra,40(sp)
ffffffffc0202d34:	7402                	ld	s0,32(sp)
ffffffffc0202d36:	64e2                	ld	s1,24(sp)
ffffffffc0202d38:	6942                	ld	s2,16(sp)
ffffffffc0202d3a:	69a2                	ld	s3,8(sp)
ffffffffc0202d3c:	6145                	addi	sp,sp,48
ffffffffc0202d3e:	8082                	ret
ffffffffc0202d40:	0000d717          	auipc	a4,0xd
ffffffffc0202d44:	73070713          	addi	a4,a4,1840 # ffffffffc0210470 <npage>
ffffffffc0202d48:	6318                	ld	a4,0(a4)
ffffffffc0202d4a:	00279513          	slli	a0,a5,0x2
ffffffffc0202d4e:	8131                	srli	a0,a0,0xc
ffffffffc0202d50:	04e57663          	bgeu	a0,a4,ffffffffc0202d9c <page_insert+0xce>
ffffffffc0202d54:	fff807b7          	lui	a5,0xfff80
ffffffffc0202d58:	953e                	add	a0,a0,a5
ffffffffc0202d5a:	0000e997          	auipc	s3,0xe
ffffffffc0202d5e:	82698993          	addi	s3,s3,-2010 # ffffffffc0210580 <pages>
ffffffffc0202d62:	0009b783          	ld	a5,0(s3)
ffffffffc0202d66:	00351713          	slli	a4,a0,0x3
ffffffffc0202d6a:	953a                	add	a0,a0,a4
ffffffffc0202d6c:	050e                	slli	a0,a0,0x3
ffffffffc0202d6e:	953e                	add	a0,a0,a5
ffffffffc0202d70:	00a40e63          	beq	s0,a0,ffffffffc0202d8c <page_insert+0xbe>
ffffffffc0202d74:	411c                	lw	a5,0(a0)
ffffffffc0202d76:	fff7871b          	addiw	a4,a5,-1
ffffffffc0202d7a:	c118                	sw	a4,0(a0)
ffffffffc0202d7c:	cb11                	beqz	a4,ffffffffc0202d90 <page_insert+0xc2>
ffffffffc0202d7e:	00093023          	sd	zero,0(s2)
ffffffffc0202d82:	12000073          	sfence.vma
ffffffffc0202d86:	0009b783          	ld	a5,0(s3)
ffffffffc0202d8a:	bfb5                	j	ffffffffc0202d06 <page_insert+0x38>
ffffffffc0202d8c:	c014                	sw	a3,0(s0)
ffffffffc0202d8e:	bfa5                	j	ffffffffc0202d06 <page_insert+0x38>
ffffffffc0202d90:	4585                	li	a1,1
ffffffffc0202d92:	be9ff0ef          	jal	ra,ffffffffc020297a <free_pages>
ffffffffc0202d96:	b7e5                	j	ffffffffc0202d7e <page_insert+0xb0>
ffffffffc0202d98:	5571                	li	a0,-4
ffffffffc0202d9a:	bf61                	j	ffffffffc0202d32 <page_insert+0x64>
ffffffffc0202d9c:	b3bff0ef          	jal	ra,ffffffffc02028d6 <pa2page.part.4>

ffffffffc0202da0 <pmm_init>:
ffffffffc0202da0:	00002797          	auipc	a5,0x2
ffffffffc0202da4:	6f078793          	addi	a5,a5,1776 # ffffffffc0205490 <default_pmm_manager>
ffffffffc0202da8:	638c                	ld	a1,0(a5)
ffffffffc0202daa:	7139                	addi	sp,sp,-64
ffffffffc0202dac:	00003517          	auipc	a0,0x3
ffffffffc0202db0:	83c50513          	addi	a0,a0,-1988 # ffffffffc02055e8 <default_pmm_manager+0x158>
ffffffffc0202db4:	fc06                	sd	ra,56(sp)
ffffffffc0202db6:	0000d717          	auipc	a4,0xd
ffffffffc0202dba:	7af73923          	sd	a5,1970(a4) # ffffffffc0210568 <pmm_manager>
ffffffffc0202dbe:	f822                	sd	s0,48(sp)
ffffffffc0202dc0:	f426                	sd	s1,40(sp)
ffffffffc0202dc2:	f04a                	sd	s2,32(sp)
ffffffffc0202dc4:	ec4e                	sd	s3,24(sp)
ffffffffc0202dc6:	e852                	sd	s4,16(sp)
ffffffffc0202dc8:	e456                	sd	s5,8(sp)
ffffffffc0202dca:	e05a                	sd	s6,0(sp)
ffffffffc0202dcc:	0000d417          	auipc	s0,0xd
ffffffffc0202dd0:	79c40413          	addi	s0,s0,1948 # ffffffffc0210568 <pmm_manager>
ffffffffc0202dd4:	aeafd0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc0202dd8:	601c                	ld	a5,0(s0)
ffffffffc0202dda:	49c5                	li	s3,17
ffffffffc0202ddc:	40100a13          	li	s4,1025
ffffffffc0202de0:	679c                	ld	a5,8(a5)
ffffffffc0202de2:	0000d497          	auipc	s1,0xd
ffffffffc0202de6:	68e48493          	addi	s1,s1,1678 # ffffffffc0210470 <npage>
ffffffffc0202dea:	0000d917          	auipc	s2,0xd
ffffffffc0202dee:	79690913          	addi	s2,s2,1942 # ffffffffc0210580 <pages>
ffffffffc0202df2:	9782                	jalr	a5
ffffffffc0202df4:	57f5                	li	a5,-3
ffffffffc0202df6:	07fa                	slli	a5,a5,0x1e
ffffffffc0202df8:	07e006b7          	lui	a3,0x7e00
ffffffffc0202dfc:	01b99613          	slli	a2,s3,0x1b
ffffffffc0202e00:	015a1593          	slli	a1,s4,0x15
ffffffffc0202e04:	00002517          	auipc	a0,0x2
ffffffffc0202e08:	7fc50513          	addi	a0,a0,2044 # ffffffffc0205600 <default_pmm_manager+0x170>
ffffffffc0202e0c:	0000d717          	auipc	a4,0xd
ffffffffc0202e10:	76f73223          	sd	a5,1892(a4) # ffffffffc0210570 <va_pa_offset>
ffffffffc0202e14:	aaafd0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc0202e18:	00003517          	auipc	a0,0x3
ffffffffc0202e1c:	81850513          	addi	a0,a0,-2024 # ffffffffc0205630 <default_pmm_manager+0x1a0>
ffffffffc0202e20:	a9efd0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc0202e24:	01b99693          	slli	a3,s3,0x1b
ffffffffc0202e28:	16fd                	addi	a3,a3,-1
ffffffffc0202e2a:	015a1613          	slli	a2,s4,0x15
ffffffffc0202e2e:	07e005b7          	lui	a1,0x7e00
ffffffffc0202e32:	00003517          	auipc	a0,0x3
ffffffffc0202e36:	81650513          	addi	a0,a0,-2026 # ffffffffc0205648 <default_pmm_manager+0x1b8>
ffffffffc0202e3a:	a84fd0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc0202e3e:	777d                	lui	a4,0xfffff
ffffffffc0202e40:	0000e797          	auipc	a5,0xe
ffffffffc0202e44:	74778793          	addi	a5,a5,1863 # ffffffffc0211587 <end+0xfff>
ffffffffc0202e48:	8ff9                	and	a5,a5,a4
ffffffffc0202e4a:	00088737          	lui	a4,0x88
ffffffffc0202e4e:	0000d697          	auipc	a3,0xd
ffffffffc0202e52:	62e6b123          	sd	a4,1570(a3) # ffffffffc0210470 <npage>
ffffffffc0202e56:	0000d717          	auipc	a4,0xd
ffffffffc0202e5a:	72f73523          	sd	a5,1834(a4) # ffffffffc0210580 <pages>
ffffffffc0202e5e:	4681                	li	a3,0
ffffffffc0202e60:	4701                	li	a4,0
ffffffffc0202e62:	4585                	li	a1,1
ffffffffc0202e64:	fff80637          	lui	a2,0xfff80
ffffffffc0202e68:	a019                	j	ffffffffc0202e6e <pmm_init+0xce>
ffffffffc0202e6a:	00093783          	ld	a5,0(s2)
ffffffffc0202e6e:	97b6                	add	a5,a5,a3
ffffffffc0202e70:	07a1                	addi	a5,a5,8
ffffffffc0202e72:	40b7b02f          	amoor.d	zero,a1,(a5)
ffffffffc0202e76:	609c                	ld	a5,0(s1)
ffffffffc0202e78:	0705                	addi	a4,a4,1
ffffffffc0202e7a:	04868693          	addi	a3,a3,72
ffffffffc0202e7e:	00c78533          	add	a0,a5,a2
ffffffffc0202e82:	fea764e3          	bltu	a4,a0,ffffffffc0202e6a <pmm_init+0xca>
ffffffffc0202e86:	00093503          	ld	a0,0(s2)
ffffffffc0202e8a:	00379693          	slli	a3,a5,0x3
ffffffffc0202e8e:	96be                	add	a3,a3,a5
ffffffffc0202e90:	fdc00737          	lui	a4,0xfdc00
ffffffffc0202e94:	972a                	add	a4,a4,a0
ffffffffc0202e96:	068e                	slli	a3,a3,0x3
ffffffffc0202e98:	96ba                	add	a3,a3,a4
ffffffffc0202e9a:	c0200737          	lui	a4,0xc0200
ffffffffc0202e9e:	7ae6ea63          	bltu	a3,a4,ffffffffc0203652 <pmm_init+0x8b2>
ffffffffc0202ea2:	0000d997          	auipc	s3,0xd
ffffffffc0202ea6:	6ce98993          	addi	s3,s3,1742 # ffffffffc0210570 <va_pa_offset>
ffffffffc0202eaa:	0009b703          	ld	a4,0(s3)
ffffffffc0202eae:	45c5                	li	a1,17
ffffffffc0202eb0:	05ee                	slli	a1,a1,0x1b
ffffffffc0202eb2:	8e99                	sub	a3,a3,a4
ffffffffc0202eb4:	36b6e563          	bltu	a3,a1,ffffffffc020321e <pmm_init+0x47e>
ffffffffc0202eb8:	601c                	ld	a5,0(s0)
ffffffffc0202eba:	0000d417          	auipc	s0,0xd
ffffffffc0202ebe:	5ae40413          	addi	s0,s0,1454 # ffffffffc0210468 <boot_pgdir>
ffffffffc0202ec2:	7b9c                	ld	a5,48(a5)
ffffffffc0202ec4:	9782                	jalr	a5
ffffffffc0202ec6:	00002517          	auipc	a0,0x2
ffffffffc0202eca:	7d250513          	addi	a0,a0,2002 # ffffffffc0205698 <default_pmm_manager+0x208>
ffffffffc0202ece:	9f0fd0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc0202ed2:	00005517          	auipc	a0,0x5
ffffffffc0202ed6:	12e50513          	addi	a0,a0,302 # ffffffffc0208000 <boot_page_table_sv39>
ffffffffc0202eda:	0000d797          	auipc	a5,0xd
ffffffffc0202ede:	58a7b723          	sd	a0,1422(a5) # ffffffffc0210468 <boot_pgdir>
ffffffffc0202ee2:	c02007b7          	lui	a5,0xc0200
ffffffffc0202ee6:	7cf56263          	bltu	a0,a5,ffffffffc02036aa <pmm_init+0x90a>
ffffffffc0202eea:	0009b783          	ld	a5,0(s3)
ffffffffc0202eee:	6098                	ld	a4,0(s1)
ffffffffc0202ef0:	40f507b3          	sub	a5,a0,a5
ffffffffc0202ef4:	0000d697          	auipc	a3,0xd
ffffffffc0202ef8:	68f6b223          	sd	a5,1668(a3) # ffffffffc0210578 <boot_cr3>
ffffffffc0202efc:	c80007b7          	lui	a5,0xc8000
ffffffffc0202f00:	83b1                	srli	a5,a5,0xc
ffffffffc0202f02:	78e7e463          	bltu	a5,a4,ffffffffc020368a <pmm_init+0x8ea>
ffffffffc0202f06:	03451793          	slli	a5,a0,0x34
ffffffffc0202f0a:	3a079e63          	bnez	a5,ffffffffc02032c6 <pmm_init+0x526>
ffffffffc0202f0e:	4601                	li	a2,0
ffffffffc0202f10:	4581                	li	a1,0
ffffffffc0202f12:	cedff0ef          	jal	ra,ffffffffc0202bfe <get_page>
ffffffffc0202f16:	74051a63          	bnez	a0,ffffffffc020366a <pmm_init+0x8ca>
ffffffffc0202f1a:	4505                	li	a0,1
ffffffffc0202f1c:	9d7ff0ef          	jal	ra,ffffffffc02028f2 <alloc_pages>
ffffffffc0202f20:	8a2a                	mv	s4,a0
ffffffffc0202f22:	6008                	ld	a0,0(s0)
ffffffffc0202f24:	4681                	li	a3,0
ffffffffc0202f26:	4601                	li	a2,0
ffffffffc0202f28:	85d2                	mv	a1,s4
ffffffffc0202f2a:	da5ff0ef          	jal	ra,ffffffffc0202cce <page_insert>
ffffffffc0202f2e:	3c051c63          	bnez	a0,ffffffffc0203306 <pmm_init+0x566>
ffffffffc0202f32:	6008                	ld	a0,0(s0)
ffffffffc0202f34:	4601                	li	a2,0
ffffffffc0202f36:	4581                	li	a1,0
ffffffffc0202f38:	ac9ff0ef          	jal	ra,ffffffffc0202a00 <get_pte>
ffffffffc0202f3c:	3a050563          	beqz	a0,ffffffffc02032e6 <pmm_init+0x546>
ffffffffc0202f40:	611c                	ld	a5,0(a0)
ffffffffc0202f42:	0017f713          	andi	a4,a5,1
ffffffffc0202f46:	36070463          	beqz	a4,ffffffffc02032ae <pmm_init+0x50e>
ffffffffc0202f4a:	6090                	ld	a2,0(s1)
ffffffffc0202f4c:	078a                	slli	a5,a5,0x2
ffffffffc0202f4e:	83b1                	srli	a5,a5,0xc
ffffffffc0202f50:	34c7fd63          	bgeu	a5,a2,ffffffffc02032aa <pmm_init+0x50a>
ffffffffc0202f54:	fff80737          	lui	a4,0xfff80
ffffffffc0202f58:	97ba                	add	a5,a5,a4
ffffffffc0202f5a:	00379713          	slli	a4,a5,0x3
ffffffffc0202f5e:	00093683          	ld	a3,0(s2)
ffffffffc0202f62:	97ba                	add	a5,a5,a4
ffffffffc0202f64:	078e                	slli	a5,a5,0x3
ffffffffc0202f66:	97b6                	add	a5,a5,a3
ffffffffc0202f68:	4cfa1963          	bne	s4,a5,ffffffffc020343a <pmm_init+0x69a>
ffffffffc0202f6c:	000a2703          	lw	a4,0(s4) # 80000 <BASE_ADDRESS-0xffffffffc0180000>
ffffffffc0202f70:	4785                	li	a5,1
ffffffffc0202f72:	4af71463          	bne	a4,a5,ffffffffc020341a <pmm_init+0x67a>
ffffffffc0202f76:	6008                	ld	a0,0(s0)
ffffffffc0202f78:	76fd                	lui	a3,0xfffff
ffffffffc0202f7a:	611c                	ld	a5,0(a0)
ffffffffc0202f7c:	078a                	slli	a5,a5,0x2
ffffffffc0202f7e:	8ff5                	and	a5,a5,a3
ffffffffc0202f80:	00c7d713          	srli	a4,a5,0xc
ffffffffc0202f84:	46c77e63          	bgeu	a4,a2,ffffffffc0203400 <pmm_init+0x660>
ffffffffc0202f88:	0009bb03          	ld	s6,0(s3)
ffffffffc0202f8c:	97da                	add	a5,a5,s6
ffffffffc0202f8e:	0007ba83          	ld	s5,0(a5) # ffffffffc8000000 <end+0x7defa78>
ffffffffc0202f92:	0a8a                	slli	s5,s5,0x2
ffffffffc0202f94:	00dafab3          	and	s5,s5,a3
ffffffffc0202f98:	00cad793          	srli	a5,s5,0xc
ffffffffc0202f9c:	44c7f563          	bgeu	a5,a2,ffffffffc02033e6 <pmm_init+0x646>
ffffffffc0202fa0:	4601                	li	a2,0
ffffffffc0202fa2:	6585                	lui	a1,0x1
ffffffffc0202fa4:	9ada                	add	s5,s5,s6
ffffffffc0202fa6:	a5bff0ef          	jal	ra,ffffffffc0202a00 <get_pte>
ffffffffc0202faa:	0aa1                	addi	s5,s5,8
ffffffffc0202fac:	41551d63          	bne	a0,s5,ffffffffc02033c6 <pmm_init+0x626>
ffffffffc0202fb0:	4505                	li	a0,1
ffffffffc0202fb2:	941ff0ef          	jal	ra,ffffffffc02028f2 <alloc_pages>
ffffffffc0202fb6:	8aaa                	mv	s5,a0
ffffffffc0202fb8:	6008                	ld	a0,0(s0)
ffffffffc0202fba:	46d1                	li	a3,20
ffffffffc0202fbc:	6605                	lui	a2,0x1
ffffffffc0202fbe:	85d6                	mv	a1,s5
ffffffffc0202fc0:	d0fff0ef          	jal	ra,ffffffffc0202cce <page_insert>
ffffffffc0202fc4:	3e051163          	bnez	a0,ffffffffc02033a6 <pmm_init+0x606>
ffffffffc0202fc8:	6008                	ld	a0,0(s0)
ffffffffc0202fca:	4601                	li	a2,0
ffffffffc0202fcc:	6585                	lui	a1,0x1
ffffffffc0202fce:	a33ff0ef          	jal	ra,ffffffffc0202a00 <get_pte>
ffffffffc0202fd2:	3a050a63          	beqz	a0,ffffffffc0203386 <pmm_init+0x5e6>
ffffffffc0202fd6:	611c                	ld	a5,0(a0)
ffffffffc0202fd8:	0107f713          	andi	a4,a5,16
ffffffffc0202fdc:	38070563          	beqz	a4,ffffffffc0203366 <pmm_init+0x5c6>
ffffffffc0202fe0:	8b91                	andi	a5,a5,4
ffffffffc0202fe2:	36078263          	beqz	a5,ffffffffc0203346 <pmm_init+0x5a6>
ffffffffc0202fe6:	6008                	ld	a0,0(s0)
ffffffffc0202fe8:	611c                	ld	a5,0(a0)
ffffffffc0202fea:	8bc1                	andi	a5,a5,16
ffffffffc0202fec:	32078d63          	beqz	a5,ffffffffc0203326 <pmm_init+0x586>
ffffffffc0202ff0:	000aa703          	lw	a4,0(s5)
ffffffffc0202ff4:	4785                	li	a5,1
ffffffffc0202ff6:	50f71263          	bne	a4,a5,ffffffffc02034fa <pmm_init+0x75a>
ffffffffc0202ffa:	4681                	li	a3,0
ffffffffc0202ffc:	6605                	lui	a2,0x1
ffffffffc0202ffe:	85d2                	mv	a1,s4
ffffffffc0203000:	ccfff0ef          	jal	ra,ffffffffc0202cce <page_insert>
ffffffffc0203004:	4c051b63          	bnez	a0,ffffffffc02034da <pmm_init+0x73a>
ffffffffc0203008:	000a2703          	lw	a4,0(s4)
ffffffffc020300c:	4789                	li	a5,2
ffffffffc020300e:	4af71663          	bne	a4,a5,ffffffffc02034ba <pmm_init+0x71a>
ffffffffc0203012:	000aa783          	lw	a5,0(s5)
ffffffffc0203016:	48079263          	bnez	a5,ffffffffc020349a <pmm_init+0x6fa>
ffffffffc020301a:	6008                	ld	a0,0(s0)
ffffffffc020301c:	4601                	li	a2,0
ffffffffc020301e:	6585                	lui	a1,0x1
ffffffffc0203020:	9e1ff0ef          	jal	ra,ffffffffc0202a00 <get_pte>
ffffffffc0203024:	44050b63          	beqz	a0,ffffffffc020347a <pmm_init+0x6da>
ffffffffc0203028:	6114                	ld	a3,0(a0)
ffffffffc020302a:	0016f793          	andi	a5,a3,1
ffffffffc020302e:	28078063          	beqz	a5,ffffffffc02032ae <pmm_init+0x50e>
ffffffffc0203032:	6098                	ld	a4,0(s1)
ffffffffc0203034:	00269793          	slli	a5,a3,0x2
ffffffffc0203038:	83b1                	srli	a5,a5,0xc
ffffffffc020303a:	26e7f863          	bgeu	a5,a4,ffffffffc02032aa <pmm_init+0x50a>
ffffffffc020303e:	fff80737          	lui	a4,0xfff80
ffffffffc0203042:	97ba                	add	a5,a5,a4
ffffffffc0203044:	00379713          	slli	a4,a5,0x3
ffffffffc0203048:	00093603          	ld	a2,0(s2)
ffffffffc020304c:	97ba                	add	a5,a5,a4
ffffffffc020304e:	078e                	slli	a5,a5,0x3
ffffffffc0203050:	97b2                	add	a5,a5,a2
ffffffffc0203052:	40fa1463          	bne	s4,a5,ffffffffc020345a <pmm_init+0x6ba>
ffffffffc0203056:	8ac1                	andi	a3,a3,16
ffffffffc0203058:	5c069d63          	bnez	a3,ffffffffc0203632 <pmm_init+0x892>
ffffffffc020305c:	6008                	ld	a0,0(s0)
ffffffffc020305e:	4581                	li	a1,0
ffffffffc0203060:	bfdff0ef          	jal	ra,ffffffffc0202c5c <page_remove>
ffffffffc0203064:	000a2703          	lw	a4,0(s4)
ffffffffc0203068:	4785                	li	a5,1
ffffffffc020306a:	5af71463          	bne	a4,a5,ffffffffc0203612 <pmm_init+0x872>
ffffffffc020306e:	000aa783          	lw	a5,0(s5)
ffffffffc0203072:	4c079463          	bnez	a5,ffffffffc020353a <pmm_init+0x79a>
ffffffffc0203076:	6008                	ld	a0,0(s0)
ffffffffc0203078:	6585                	lui	a1,0x1
ffffffffc020307a:	be3ff0ef          	jal	ra,ffffffffc0202c5c <page_remove>
ffffffffc020307e:	000a2783          	lw	a5,0(s4)
ffffffffc0203082:	48079c63          	bnez	a5,ffffffffc020351a <pmm_init+0x77a>
ffffffffc0203086:	000aa783          	lw	a5,0(s5)
ffffffffc020308a:	64079d63          	bnez	a5,ffffffffc02036e4 <pmm_init+0x944>
ffffffffc020308e:	601c                	ld	a5,0(s0)
ffffffffc0203090:	6098                	ld	a4,0(s1)
ffffffffc0203092:	639c                	ld	a5,0(a5)
ffffffffc0203094:	078a                	slli	a5,a5,0x2
ffffffffc0203096:	83b1                	srli	a5,a5,0xc
ffffffffc0203098:	20e7f963          	bgeu	a5,a4,ffffffffc02032aa <pmm_init+0x50a>
ffffffffc020309c:	fff80537          	lui	a0,0xfff80
ffffffffc02030a0:	97aa                	add	a5,a5,a0
ffffffffc02030a2:	00379713          	slli	a4,a5,0x3
ffffffffc02030a6:	00093503          	ld	a0,0(s2)
ffffffffc02030aa:	97ba                	add	a5,a5,a4
ffffffffc02030ac:	078e                	slli	a5,a5,0x3
ffffffffc02030ae:	953e                	add	a0,a0,a5
ffffffffc02030b0:	4118                	lw	a4,0(a0)
ffffffffc02030b2:	4785                	li	a5,1
ffffffffc02030b4:	60f71863          	bne	a4,a5,ffffffffc02036c4 <pmm_init+0x924>
ffffffffc02030b8:	4585                	li	a1,1
ffffffffc02030ba:	8c1ff0ef          	jal	ra,ffffffffc020297a <free_pages>
ffffffffc02030be:	601c                	ld	a5,0(s0)
ffffffffc02030c0:	00003517          	auipc	a0,0x3
ffffffffc02030c4:	8a050513          	addi	a0,a0,-1888 # ffffffffc0205960 <default_pmm_manager+0x4d0>
ffffffffc02030c8:	0007b023          	sd	zero,0(a5)
ffffffffc02030cc:	ff3fc0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc02030d0:	6098                	ld	a4,0(s1)
ffffffffc02030d2:	c02007b7          	lui	a5,0xc0200
ffffffffc02030d6:	00c71693          	slli	a3,a4,0xc
ffffffffc02030da:	16d7f963          	bgeu	a5,a3,ffffffffc020324c <pmm_init+0x4ac>
ffffffffc02030de:	83b1                	srli	a5,a5,0xc
ffffffffc02030e0:	6008                	ld	a0,0(s0)
ffffffffc02030e2:	c0200a37          	lui	s4,0xc0200
ffffffffc02030e6:	1ae7f563          	bgeu	a5,a4,ffffffffc0203290 <pmm_init+0x4f0>
ffffffffc02030ea:	7b7d                	lui	s6,0xfffff
ffffffffc02030ec:	6a85                	lui	s5,0x1
ffffffffc02030ee:	a029                	j	ffffffffc02030f8 <pmm_init+0x358>
ffffffffc02030f0:	00ca5713          	srli	a4,s4,0xc
ffffffffc02030f4:	18f77e63          	bgeu	a4,a5,ffffffffc0203290 <pmm_init+0x4f0>
ffffffffc02030f8:	0009b583          	ld	a1,0(s3)
ffffffffc02030fc:	4601                	li	a2,0
ffffffffc02030fe:	95d2                	add	a1,a1,s4
ffffffffc0203100:	901ff0ef          	jal	ra,ffffffffc0202a00 <get_pte>
ffffffffc0203104:	16050663          	beqz	a0,ffffffffc0203270 <pmm_init+0x4d0>
ffffffffc0203108:	611c                	ld	a5,0(a0)
ffffffffc020310a:	078a                	slli	a5,a5,0x2
ffffffffc020310c:	0167f7b3          	and	a5,a5,s6
ffffffffc0203110:	15479063          	bne	a5,s4,ffffffffc0203250 <pmm_init+0x4b0>
ffffffffc0203114:	609c                	ld	a5,0(s1)
ffffffffc0203116:	9a56                	add	s4,s4,s5
ffffffffc0203118:	6008                	ld	a0,0(s0)
ffffffffc020311a:	00c79713          	slli	a4,a5,0xc
ffffffffc020311e:	fcea69e3          	bltu	s4,a4,ffffffffc02030f0 <pmm_init+0x350>
ffffffffc0203122:	611c                	ld	a5,0(a0)
ffffffffc0203124:	48079763          	bnez	a5,ffffffffc02035b2 <pmm_init+0x812>
ffffffffc0203128:	4505                	li	a0,1
ffffffffc020312a:	fc8ff0ef          	jal	ra,ffffffffc02028f2 <alloc_pages>
ffffffffc020312e:	8a2a                	mv	s4,a0
ffffffffc0203130:	6008                	ld	a0,0(s0)
ffffffffc0203132:	4699                	li	a3,6
ffffffffc0203134:	10000613          	li	a2,256
ffffffffc0203138:	85d2                	mv	a1,s4
ffffffffc020313a:	b95ff0ef          	jal	ra,ffffffffc0202cce <page_insert>
ffffffffc020313e:	44051a63          	bnez	a0,ffffffffc0203592 <pmm_init+0x7f2>
ffffffffc0203142:	000a2703          	lw	a4,0(s4) # ffffffffc0200000 <kern_entry>
ffffffffc0203146:	4785                	li	a5,1
ffffffffc0203148:	5cf71e63          	bne	a4,a5,ffffffffc0203724 <pmm_init+0x984>
ffffffffc020314c:	6008                	ld	a0,0(s0)
ffffffffc020314e:	6a85                	lui	s5,0x1
ffffffffc0203150:	4699                	li	a3,6
ffffffffc0203152:	100a8613          	addi	a2,s5,256 # 1100 <BASE_ADDRESS-0xffffffffc01fef00>
ffffffffc0203156:	85d2                	mv	a1,s4
ffffffffc0203158:	b77ff0ef          	jal	ra,ffffffffc0202cce <page_insert>
ffffffffc020315c:	5a051463          	bnez	a0,ffffffffc0203704 <pmm_init+0x964>
ffffffffc0203160:	000a2703          	lw	a4,0(s4)
ffffffffc0203164:	4789                	li	a5,2
ffffffffc0203166:	48f71663          	bne	a4,a5,ffffffffc02035f2 <pmm_init+0x852>
ffffffffc020316a:	00003597          	auipc	a1,0x3
ffffffffc020316e:	92e58593          	addi	a1,a1,-1746 # ffffffffc0205a98 <default_pmm_manager+0x608>
ffffffffc0203172:	10000513          	li	a0,256
ffffffffc0203176:	1b1000ef          	jal	ra,ffffffffc0203b26 <strcpy>
ffffffffc020317a:	100a8593          	addi	a1,s5,256
ffffffffc020317e:	10000513          	li	a0,256
ffffffffc0203182:	1b7000ef          	jal	ra,ffffffffc0203b38 <strcmp>
ffffffffc0203186:	44051663          	bnez	a0,ffffffffc02035d2 <pmm_init+0x832>
ffffffffc020318a:	00093683          	ld	a3,0(s2)
ffffffffc020318e:	00002797          	auipc	a5,0x2
ffffffffc0203192:	faa78793          	addi	a5,a5,-86 # ffffffffc0205138 <commands+0xf98>
ffffffffc0203196:	639c                	ld	a5,0(a5)
ffffffffc0203198:	40da06b3          	sub	a3,s4,a3
ffffffffc020319c:	868d                	srai	a3,a3,0x3
ffffffffc020319e:	02f686b3          	mul	a3,a3,a5
ffffffffc02031a2:	00080ab7          	lui	s5,0x80
ffffffffc02031a6:	6098                	ld	a4,0(s1)
ffffffffc02031a8:	96d6                	add	a3,a3,s5
ffffffffc02031aa:	00c69793          	slli	a5,a3,0xc
ffffffffc02031ae:	83b1                	srli	a5,a5,0xc
ffffffffc02031b0:	06b2                	slli	a3,a3,0xc
ffffffffc02031b2:	3ce7f463          	bgeu	a5,a4,ffffffffc020357a <pmm_init+0x7da>
ffffffffc02031b6:	0009b783          	ld	a5,0(s3)
ffffffffc02031ba:	10000513          	li	a0,256
ffffffffc02031be:	96be                	add	a3,a3,a5
ffffffffc02031c0:	10068023          	sb	zero,256(a3) # fffffffffffff100 <end+0x3fdeeb78>
ffffffffc02031c4:	11f000ef          	jal	ra,ffffffffc0203ae2 <strlen>
ffffffffc02031c8:	38051963          	bnez	a0,ffffffffc020355a <pmm_init+0x7ba>
ffffffffc02031cc:	4585                	li	a1,1
ffffffffc02031ce:	8552                	mv	a0,s4
ffffffffc02031d0:	faaff0ef          	jal	ra,ffffffffc020297a <free_pages>
ffffffffc02031d4:	601c                	ld	a5,0(s0)
ffffffffc02031d6:	6098                	ld	a4,0(s1)
ffffffffc02031d8:	639c                	ld	a5,0(a5)
ffffffffc02031da:	078a                	slli	a5,a5,0x2
ffffffffc02031dc:	83b1                	srli	a5,a5,0xc
ffffffffc02031de:	0ce7f663          	bgeu	a5,a4,ffffffffc02032aa <pmm_init+0x50a>
ffffffffc02031e2:	415787b3          	sub	a5,a5,s5
ffffffffc02031e6:	00093503          	ld	a0,0(s2)
ffffffffc02031ea:	00379713          	slli	a4,a5,0x3
ffffffffc02031ee:	97ba                	add	a5,a5,a4
ffffffffc02031f0:	078e                	slli	a5,a5,0x3
ffffffffc02031f2:	953e                	add	a0,a0,a5
ffffffffc02031f4:	4585                	li	a1,1
ffffffffc02031f6:	f84ff0ef          	jal	ra,ffffffffc020297a <free_pages>
ffffffffc02031fa:	601c                	ld	a5,0(s0)
ffffffffc02031fc:	7442                	ld	s0,48(sp)
ffffffffc02031fe:	70e2                	ld	ra,56(sp)
ffffffffc0203200:	74a2                	ld	s1,40(sp)
ffffffffc0203202:	7902                	ld	s2,32(sp)
ffffffffc0203204:	69e2                	ld	s3,24(sp)
ffffffffc0203206:	6a42                	ld	s4,16(sp)
ffffffffc0203208:	6aa2                	ld	s5,8(sp)
ffffffffc020320a:	6b02                	ld	s6,0(sp)
ffffffffc020320c:	0007b023          	sd	zero,0(a5)
ffffffffc0203210:	00003517          	auipc	a0,0x3
ffffffffc0203214:	90050513          	addi	a0,a0,-1792 # ffffffffc0205b10 <default_pmm_manager+0x680>
ffffffffc0203218:	6121                	addi	sp,sp,64
ffffffffc020321a:	ea5fc06f          	j	ffffffffc02000be <cprintf>
ffffffffc020321e:	6705                	lui	a4,0x1
ffffffffc0203220:	177d                	addi	a4,a4,-1
ffffffffc0203222:	96ba                	add	a3,a3,a4
ffffffffc0203224:	00c6d713          	srli	a4,a3,0xc
ffffffffc0203228:	08f77163          	bgeu	a4,a5,ffffffffc02032aa <pmm_init+0x50a>
ffffffffc020322c:	00043803          	ld	a6,0(s0)
ffffffffc0203230:	9732                	add	a4,a4,a2
ffffffffc0203232:	00371793          	slli	a5,a4,0x3
ffffffffc0203236:	767d                	lui	a2,0xfffff
ffffffffc0203238:	8ef1                	and	a3,a3,a2
ffffffffc020323a:	97ba                	add	a5,a5,a4
ffffffffc020323c:	01083703          	ld	a4,16(a6)
ffffffffc0203240:	8d95                	sub	a1,a1,a3
ffffffffc0203242:	078e                	slli	a5,a5,0x3
ffffffffc0203244:	81b1                	srli	a1,a1,0xc
ffffffffc0203246:	953e                	add	a0,a0,a5
ffffffffc0203248:	9702                	jalr	a4
ffffffffc020324a:	b1bd                	j	ffffffffc0202eb8 <pmm_init+0x118>
ffffffffc020324c:	6008                	ld	a0,0(s0)
ffffffffc020324e:	bdd1                	j	ffffffffc0203122 <pmm_init+0x382>
ffffffffc0203250:	00002697          	auipc	a3,0x2
ffffffffc0203254:	77068693          	addi	a3,a3,1904 # ffffffffc02059c0 <default_pmm_manager+0x530>
ffffffffc0203258:	00001617          	auipc	a2,0x1
ffffffffc020325c:	7a060613          	addi	a2,a2,1952 # ffffffffc02049f8 <commands+0x858>
ffffffffc0203260:	1c100593          	li	a1,449
ffffffffc0203264:	00002517          	auipc	a0,0x2
ffffffffc0203268:	31c50513          	addi	a0,a0,796 # ffffffffc0205580 <default_pmm_manager+0xf0>
ffffffffc020326c:	e99fc0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0203270:	00002697          	auipc	a3,0x2
ffffffffc0203274:	71068693          	addi	a3,a3,1808 # ffffffffc0205980 <default_pmm_manager+0x4f0>
ffffffffc0203278:	00001617          	auipc	a2,0x1
ffffffffc020327c:	78060613          	addi	a2,a2,1920 # ffffffffc02049f8 <commands+0x858>
ffffffffc0203280:	1c000593          	li	a1,448
ffffffffc0203284:	00002517          	auipc	a0,0x2
ffffffffc0203288:	2fc50513          	addi	a0,a0,764 # ffffffffc0205580 <default_pmm_manager+0xf0>
ffffffffc020328c:	e79fc0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0203290:	86d2                	mv	a3,s4
ffffffffc0203292:	00002617          	auipc	a2,0x2
ffffffffc0203296:	2c660613          	addi	a2,a2,710 # ffffffffc0205558 <default_pmm_manager+0xc8>
ffffffffc020329a:	1c000593          	li	a1,448
ffffffffc020329e:	00002517          	auipc	a0,0x2
ffffffffc02032a2:	2e250513          	addi	a0,a0,738 # ffffffffc0205580 <default_pmm_manager+0xf0>
ffffffffc02032a6:	e5ffc0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc02032aa:	e2cff0ef          	jal	ra,ffffffffc02028d6 <pa2page.part.4>
ffffffffc02032ae:	00002617          	auipc	a2,0x2
ffffffffc02032b2:	d2a60613          	addi	a2,a2,-726 # ffffffffc0204fd8 <commands+0xe38>
ffffffffc02032b6:	07000593          	li	a1,112
ffffffffc02032ba:	00002517          	auipc	a0,0x2
ffffffffc02032be:	a5650513          	addi	a0,a0,-1450 # ffffffffc0204d10 <commands+0xb70>
ffffffffc02032c2:	e43fc0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc02032c6:	00002697          	auipc	a3,0x2
ffffffffc02032ca:	41268693          	addi	a3,a3,1042 # ffffffffc02056d8 <default_pmm_manager+0x248>
ffffffffc02032ce:	00001617          	auipc	a2,0x1
ffffffffc02032d2:	72a60613          	addi	a2,a2,1834 # ffffffffc02049f8 <commands+0x858>
ffffffffc02032d6:	18f00593          	li	a1,399
ffffffffc02032da:	00002517          	auipc	a0,0x2
ffffffffc02032de:	2a650513          	addi	a0,a0,678 # ffffffffc0205580 <default_pmm_manager+0xf0>
ffffffffc02032e2:	e23fc0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc02032e6:	00002697          	auipc	a3,0x2
ffffffffc02032ea:	48268693          	addi	a3,a3,1154 # ffffffffc0205768 <default_pmm_manager+0x2d8>
ffffffffc02032ee:	00001617          	auipc	a2,0x1
ffffffffc02032f2:	70a60613          	addi	a2,a2,1802 # ffffffffc02049f8 <commands+0x858>
ffffffffc02032f6:	19600593          	li	a1,406
ffffffffc02032fa:	00002517          	auipc	a0,0x2
ffffffffc02032fe:	28650513          	addi	a0,a0,646 # ffffffffc0205580 <default_pmm_manager+0xf0>
ffffffffc0203302:	e03fc0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0203306:	00002697          	auipc	a3,0x2
ffffffffc020330a:	43268693          	addi	a3,a3,1074 # ffffffffc0205738 <default_pmm_manager+0x2a8>
ffffffffc020330e:	00001617          	auipc	a2,0x1
ffffffffc0203312:	6ea60613          	addi	a2,a2,1770 # ffffffffc02049f8 <commands+0x858>
ffffffffc0203316:	19400593          	li	a1,404
ffffffffc020331a:	00002517          	auipc	a0,0x2
ffffffffc020331e:	26650513          	addi	a0,a0,614 # ffffffffc0205580 <default_pmm_manager+0xf0>
ffffffffc0203322:	de3fc0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0203326:	00002697          	auipc	a3,0x2
ffffffffc020332a:	55268693          	addi	a3,a3,1362 # ffffffffc0205878 <default_pmm_manager+0x3e8>
ffffffffc020332e:	00001617          	auipc	a2,0x1
ffffffffc0203332:	6ca60613          	addi	a2,a2,1738 # ffffffffc02049f8 <commands+0x858>
ffffffffc0203336:	1a300593          	li	a1,419
ffffffffc020333a:	00002517          	auipc	a0,0x2
ffffffffc020333e:	24650513          	addi	a0,a0,582 # ffffffffc0205580 <default_pmm_manager+0xf0>
ffffffffc0203342:	dc3fc0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0203346:	00002697          	auipc	a3,0x2
ffffffffc020334a:	52268693          	addi	a3,a3,1314 # ffffffffc0205868 <default_pmm_manager+0x3d8>
ffffffffc020334e:	00001617          	auipc	a2,0x1
ffffffffc0203352:	6aa60613          	addi	a2,a2,1706 # ffffffffc02049f8 <commands+0x858>
ffffffffc0203356:	1a200593          	li	a1,418
ffffffffc020335a:	00002517          	auipc	a0,0x2
ffffffffc020335e:	22650513          	addi	a0,a0,550 # ffffffffc0205580 <default_pmm_manager+0xf0>
ffffffffc0203362:	da3fc0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0203366:	00002697          	auipc	a3,0x2
ffffffffc020336a:	4f268693          	addi	a3,a3,1266 # ffffffffc0205858 <default_pmm_manager+0x3c8>
ffffffffc020336e:	00001617          	auipc	a2,0x1
ffffffffc0203372:	68a60613          	addi	a2,a2,1674 # ffffffffc02049f8 <commands+0x858>
ffffffffc0203376:	1a100593          	li	a1,417
ffffffffc020337a:	00002517          	auipc	a0,0x2
ffffffffc020337e:	20650513          	addi	a0,a0,518 # ffffffffc0205580 <default_pmm_manager+0xf0>
ffffffffc0203382:	d83fc0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0203386:	00002697          	auipc	a3,0x2
ffffffffc020338a:	4a268693          	addi	a3,a3,1186 # ffffffffc0205828 <default_pmm_manager+0x398>
ffffffffc020338e:	00001617          	auipc	a2,0x1
ffffffffc0203392:	66a60613          	addi	a2,a2,1642 # ffffffffc02049f8 <commands+0x858>
ffffffffc0203396:	1a000593          	li	a1,416
ffffffffc020339a:	00002517          	auipc	a0,0x2
ffffffffc020339e:	1e650513          	addi	a0,a0,486 # ffffffffc0205580 <default_pmm_manager+0xf0>
ffffffffc02033a2:	d63fc0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc02033a6:	00002697          	auipc	a3,0x2
ffffffffc02033aa:	44a68693          	addi	a3,a3,1098 # ffffffffc02057f0 <default_pmm_manager+0x360>
ffffffffc02033ae:	00001617          	auipc	a2,0x1
ffffffffc02033b2:	64a60613          	addi	a2,a2,1610 # ffffffffc02049f8 <commands+0x858>
ffffffffc02033b6:	19f00593          	li	a1,415
ffffffffc02033ba:	00002517          	auipc	a0,0x2
ffffffffc02033be:	1c650513          	addi	a0,a0,454 # ffffffffc0205580 <default_pmm_manager+0xf0>
ffffffffc02033c2:	d43fc0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc02033c6:	00002697          	auipc	a3,0x2
ffffffffc02033ca:	40268693          	addi	a3,a3,1026 # ffffffffc02057c8 <default_pmm_manager+0x338>
ffffffffc02033ce:	00001617          	auipc	a2,0x1
ffffffffc02033d2:	62a60613          	addi	a2,a2,1578 # ffffffffc02049f8 <commands+0x858>
ffffffffc02033d6:	19c00593          	li	a1,412
ffffffffc02033da:	00002517          	auipc	a0,0x2
ffffffffc02033de:	1a650513          	addi	a0,a0,422 # ffffffffc0205580 <default_pmm_manager+0xf0>
ffffffffc02033e2:	d23fc0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc02033e6:	86d6                	mv	a3,s5
ffffffffc02033e8:	00002617          	auipc	a2,0x2
ffffffffc02033ec:	17060613          	addi	a2,a2,368 # ffffffffc0205558 <default_pmm_manager+0xc8>
ffffffffc02033f0:	19b00593          	li	a1,411
ffffffffc02033f4:	00002517          	auipc	a0,0x2
ffffffffc02033f8:	18c50513          	addi	a0,a0,396 # ffffffffc0205580 <default_pmm_manager+0xf0>
ffffffffc02033fc:	d09fc0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0203400:	86be                	mv	a3,a5
ffffffffc0203402:	00002617          	auipc	a2,0x2
ffffffffc0203406:	15660613          	addi	a2,a2,342 # ffffffffc0205558 <default_pmm_manager+0xc8>
ffffffffc020340a:	19a00593          	li	a1,410
ffffffffc020340e:	00002517          	auipc	a0,0x2
ffffffffc0203412:	17250513          	addi	a0,a0,370 # ffffffffc0205580 <default_pmm_manager+0xf0>
ffffffffc0203416:	ceffc0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc020341a:	00002697          	auipc	a3,0x2
ffffffffc020341e:	39668693          	addi	a3,a3,918 # ffffffffc02057b0 <default_pmm_manager+0x320>
ffffffffc0203422:	00001617          	auipc	a2,0x1
ffffffffc0203426:	5d660613          	addi	a2,a2,1494 # ffffffffc02049f8 <commands+0x858>
ffffffffc020342a:	19800593          	li	a1,408
ffffffffc020342e:	00002517          	auipc	a0,0x2
ffffffffc0203432:	15250513          	addi	a0,a0,338 # ffffffffc0205580 <default_pmm_manager+0xf0>
ffffffffc0203436:	ccffc0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc020343a:	00002697          	auipc	a3,0x2
ffffffffc020343e:	35e68693          	addi	a3,a3,862 # ffffffffc0205798 <default_pmm_manager+0x308>
ffffffffc0203442:	00001617          	auipc	a2,0x1
ffffffffc0203446:	5b660613          	addi	a2,a2,1462 # ffffffffc02049f8 <commands+0x858>
ffffffffc020344a:	19700593          	li	a1,407
ffffffffc020344e:	00002517          	auipc	a0,0x2
ffffffffc0203452:	13250513          	addi	a0,a0,306 # ffffffffc0205580 <default_pmm_manager+0xf0>
ffffffffc0203456:	caffc0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc020345a:	00002697          	auipc	a3,0x2
ffffffffc020345e:	33e68693          	addi	a3,a3,830 # ffffffffc0205798 <default_pmm_manager+0x308>
ffffffffc0203462:	00001617          	auipc	a2,0x1
ffffffffc0203466:	59660613          	addi	a2,a2,1430 # ffffffffc02049f8 <commands+0x858>
ffffffffc020346a:	1aa00593          	li	a1,426
ffffffffc020346e:	00002517          	auipc	a0,0x2
ffffffffc0203472:	11250513          	addi	a0,a0,274 # ffffffffc0205580 <default_pmm_manager+0xf0>
ffffffffc0203476:	c8ffc0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc020347a:	00002697          	auipc	a3,0x2
ffffffffc020347e:	3ae68693          	addi	a3,a3,942 # ffffffffc0205828 <default_pmm_manager+0x398>
ffffffffc0203482:	00001617          	auipc	a2,0x1
ffffffffc0203486:	57660613          	addi	a2,a2,1398 # ffffffffc02049f8 <commands+0x858>
ffffffffc020348a:	1a900593          	li	a1,425
ffffffffc020348e:	00002517          	auipc	a0,0x2
ffffffffc0203492:	0f250513          	addi	a0,a0,242 # ffffffffc0205580 <default_pmm_manager+0xf0>
ffffffffc0203496:	c6ffc0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc020349a:	00002697          	auipc	a3,0x2
ffffffffc020349e:	45668693          	addi	a3,a3,1110 # ffffffffc02058f0 <default_pmm_manager+0x460>
ffffffffc02034a2:	00001617          	auipc	a2,0x1
ffffffffc02034a6:	55660613          	addi	a2,a2,1366 # ffffffffc02049f8 <commands+0x858>
ffffffffc02034aa:	1a800593          	li	a1,424
ffffffffc02034ae:	00002517          	auipc	a0,0x2
ffffffffc02034b2:	0d250513          	addi	a0,a0,210 # ffffffffc0205580 <default_pmm_manager+0xf0>
ffffffffc02034b6:	c4ffc0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc02034ba:	00002697          	auipc	a3,0x2
ffffffffc02034be:	41e68693          	addi	a3,a3,1054 # ffffffffc02058d8 <default_pmm_manager+0x448>
ffffffffc02034c2:	00001617          	auipc	a2,0x1
ffffffffc02034c6:	53660613          	addi	a2,a2,1334 # ffffffffc02049f8 <commands+0x858>
ffffffffc02034ca:	1a700593          	li	a1,423
ffffffffc02034ce:	00002517          	auipc	a0,0x2
ffffffffc02034d2:	0b250513          	addi	a0,a0,178 # ffffffffc0205580 <default_pmm_manager+0xf0>
ffffffffc02034d6:	c2ffc0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc02034da:	00002697          	auipc	a3,0x2
ffffffffc02034de:	3ce68693          	addi	a3,a3,974 # ffffffffc02058a8 <default_pmm_manager+0x418>
ffffffffc02034e2:	00001617          	auipc	a2,0x1
ffffffffc02034e6:	51660613          	addi	a2,a2,1302 # ffffffffc02049f8 <commands+0x858>
ffffffffc02034ea:	1a600593          	li	a1,422
ffffffffc02034ee:	00002517          	auipc	a0,0x2
ffffffffc02034f2:	09250513          	addi	a0,a0,146 # ffffffffc0205580 <default_pmm_manager+0xf0>
ffffffffc02034f6:	c0ffc0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc02034fa:	00002697          	auipc	a3,0x2
ffffffffc02034fe:	39668693          	addi	a3,a3,918 # ffffffffc0205890 <default_pmm_manager+0x400>
ffffffffc0203502:	00001617          	auipc	a2,0x1
ffffffffc0203506:	4f660613          	addi	a2,a2,1270 # ffffffffc02049f8 <commands+0x858>
ffffffffc020350a:	1a400593          	li	a1,420
ffffffffc020350e:	00002517          	auipc	a0,0x2
ffffffffc0203512:	07250513          	addi	a0,a0,114 # ffffffffc0205580 <default_pmm_manager+0xf0>
ffffffffc0203516:	beffc0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc020351a:	00002697          	auipc	a3,0x2
ffffffffc020351e:	40668693          	addi	a3,a3,1030 # ffffffffc0205920 <default_pmm_manager+0x490>
ffffffffc0203522:	00001617          	auipc	a2,0x1
ffffffffc0203526:	4d660613          	addi	a2,a2,1238 # ffffffffc02049f8 <commands+0x858>
ffffffffc020352a:	1b200593          	li	a1,434
ffffffffc020352e:	00002517          	auipc	a0,0x2
ffffffffc0203532:	05250513          	addi	a0,a0,82 # ffffffffc0205580 <default_pmm_manager+0xf0>
ffffffffc0203536:	bcffc0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc020353a:	00002697          	auipc	a3,0x2
ffffffffc020353e:	3b668693          	addi	a3,a3,950 # ffffffffc02058f0 <default_pmm_manager+0x460>
ffffffffc0203542:	00001617          	auipc	a2,0x1
ffffffffc0203546:	4b660613          	addi	a2,a2,1206 # ffffffffc02049f8 <commands+0x858>
ffffffffc020354a:	1af00593          	li	a1,431
ffffffffc020354e:	00002517          	auipc	a0,0x2
ffffffffc0203552:	03250513          	addi	a0,a0,50 # ffffffffc0205580 <default_pmm_manager+0xf0>
ffffffffc0203556:	baffc0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc020355a:	00002697          	auipc	a3,0x2
ffffffffc020355e:	58e68693          	addi	a3,a3,1422 # ffffffffc0205ae8 <default_pmm_manager+0x658>
ffffffffc0203562:	00001617          	auipc	a2,0x1
ffffffffc0203566:	49660613          	addi	a2,a2,1174 # ffffffffc02049f8 <commands+0x858>
ffffffffc020356a:	1d300593          	li	a1,467
ffffffffc020356e:	00002517          	auipc	a0,0x2
ffffffffc0203572:	01250513          	addi	a0,a0,18 # ffffffffc0205580 <default_pmm_manager+0xf0>
ffffffffc0203576:	b8ffc0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc020357a:	00002617          	auipc	a2,0x2
ffffffffc020357e:	fde60613          	addi	a2,a2,-34 # ffffffffc0205558 <default_pmm_manager+0xc8>
ffffffffc0203582:	06a00593          	li	a1,106
ffffffffc0203586:	00001517          	auipc	a0,0x1
ffffffffc020358a:	78a50513          	addi	a0,a0,1930 # ffffffffc0204d10 <commands+0xb70>
ffffffffc020358e:	b77fc0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0203592:	00002697          	auipc	a3,0x2
ffffffffc0203596:	45e68693          	addi	a3,a3,1118 # ffffffffc02059f0 <default_pmm_manager+0x560>
ffffffffc020359a:	00001617          	auipc	a2,0x1
ffffffffc020359e:	45e60613          	addi	a2,a2,1118 # ffffffffc02049f8 <commands+0x858>
ffffffffc02035a2:	1c900593          	li	a1,457
ffffffffc02035a6:	00002517          	auipc	a0,0x2
ffffffffc02035aa:	fda50513          	addi	a0,a0,-38 # ffffffffc0205580 <default_pmm_manager+0xf0>
ffffffffc02035ae:	b57fc0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc02035b2:	00002697          	auipc	a3,0x2
ffffffffc02035b6:	42668693          	addi	a3,a3,1062 # ffffffffc02059d8 <default_pmm_manager+0x548>
ffffffffc02035ba:	00001617          	auipc	a2,0x1
ffffffffc02035be:	43e60613          	addi	a2,a2,1086 # ffffffffc02049f8 <commands+0x858>
ffffffffc02035c2:	1c500593          	li	a1,453
ffffffffc02035c6:	00002517          	auipc	a0,0x2
ffffffffc02035ca:	fba50513          	addi	a0,a0,-70 # ffffffffc0205580 <default_pmm_manager+0xf0>
ffffffffc02035ce:	b37fc0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc02035d2:	00002697          	auipc	a3,0x2
ffffffffc02035d6:	4de68693          	addi	a3,a3,1246 # ffffffffc0205ab0 <default_pmm_manager+0x620>
ffffffffc02035da:	00001617          	auipc	a2,0x1
ffffffffc02035de:	41e60613          	addi	a2,a2,1054 # ffffffffc02049f8 <commands+0x858>
ffffffffc02035e2:	1d000593          	li	a1,464
ffffffffc02035e6:	00002517          	auipc	a0,0x2
ffffffffc02035ea:	f9a50513          	addi	a0,a0,-102 # ffffffffc0205580 <default_pmm_manager+0xf0>
ffffffffc02035ee:	b17fc0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc02035f2:	00002697          	auipc	a3,0x2
ffffffffc02035f6:	48e68693          	addi	a3,a3,1166 # ffffffffc0205a80 <default_pmm_manager+0x5f0>
ffffffffc02035fa:	00001617          	auipc	a2,0x1
ffffffffc02035fe:	3fe60613          	addi	a2,a2,1022 # ffffffffc02049f8 <commands+0x858>
ffffffffc0203602:	1cc00593          	li	a1,460
ffffffffc0203606:	00002517          	auipc	a0,0x2
ffffffffc020360a:	f7a50513          	addi	a0,a0,-134 # ffffffffc0205580 <default_pmm_manager+0xf0>
ffffffffc020360e:	af7fc0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0203612:	00002697          	auipc	a3,0x2
ffffffffc0203616:	19e68693          	addi	a3,a3,414 # ffffffffc02057b0 <default_pmm_manager+0x320>
ffffffffc020361a:	00001617          	auipc	a2,0x1
ffffffffc020361e:	3de60613          	addi	a2,a2,990 # ffffffffc02049f8 <commands+0x858>
ffffffffc0203622:	1ae00593          	li	a1,430
ffffffffc0203626:	00002517          	auipc	a0,0x2
ffffffffc020362a:	f5a50513          	addi	a0,a0,-166 # ffffffffc0205580 <default_pmm_manager+0xf0>
ffffffffc020362e:	ad7fc0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0203632:	00002697          	auipc	a3,0x2
ffffffffc0203636:	2d668693          	addi	a3,a3,726 # ffffffffc0205908 <default_pmm_manager+0x478>
ffffffffc020363a:	00001617          	auipc	a2,0x1
ffffffffc020363e:	3be60613          	addi	a2,a2,958 # ffffffffc02049f8 <commands+0x858>
ffffffffc0203642:	1ab00593          	li	a1,427
ffffffffc0203646:	00002517          	auipc	a0,0x2
ffffffffc020364a:	f3a50513          	addi	a0,a0,-198 # ffffffffc0205580 <default_pmm_manager+0xf0>
ffffffffc020364e:	ab7fc0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0203652:	00002617          	auipc	a2,0x2
ffffffffc0203656:	01e60613          	addi	a2,a2,30 # ffffffffc0205670 <default_pmm_manager+0x1e0>
ffffffffc020365a:	07700593          	li	a1,119
ffffffffc020365e:	00002517          	auipc	a0,0x2
ffffffffc0203662:	f2250513          	addi	a0,a0,-222 # ffffffffc0205580 <default_pmm_manager+0xf0>
ffffffffc0203666:	a9ffc0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc020366a:	00002697          	auipc	a3,0x2
ffffffffc020366e:	0a668693          	addi	a3,a3,166 # ffffffffc0205710 <default_pmm_manager+0x280>
ffffffffc0203672:	00001617          	auipc	a2,0x1
ffffffffc0203676:	38660613          	addi	a2,a2,902 # ffffffffc02049f8 <commands+0x858>
ffffffffc020367a:	19000593          	li	a1,400
ffffffffc020367e:	00002517          	auipc	a0,0x2
ffffffffc0203682:	f0250513          	addi	a0,a0,-254 # ffffffffc0205580 <default_pmm_manager+0xf0>
ffffffffc0203686:	a7ffc0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc020368a:	00002697          	auipc	a3,0x2
ffffffffc020368e:	02e68693          	addi	a3,a3,46 # ffffffffc02056b8 <default_pmm_manager+0x228>
ffffffffc0203692:	00001617          	auipc	a2,0x1
ffffffffc0203696:	36660613          	addi	a2,a2,870 # ffffffffc02049f8 <commands+0x858>
ffffffffc020369a:	18e00593          	li	a1,398
ffffffffc020369e:	00002517          	auipc	a0,0x2
ffffffffc02036a2:	ee250513          	addi	a0,a0,-286 # ffffffffc0205580 <default_pmm_manager+0xf0>
ffffffffc02036a6:	a5ffc0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc02036aa:	86aa                	mv	a3,a0
ffffffffc02036ac:	00002617          	auipc	a2,0x2
ffffffffc02036b0:	fc460613          	addi	a2,a2,-60 # ffffffffc0205670 <default_pmm_manager+0x1e0>
ffffffffc02036b4:	0bd00593          	li	a1,189
ffffffffc02036b8:	00002517          	auipc	a0,0x2
ffffffffc02036bc:	ec850513          	addi	a0,a0,-312 # ffffffffc0205580 <default_pmm_manager+0xf0>
ffffffffc02036c0:	a45fc0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc02036c4:	00002697          	auipc	a3,0x2
ffffffffc02036c8:	27468693          	addi	a3,a3,628 # ffffffffc0205938 <default_pmm_manager+0x4a8>
ffffffffc02036cc:	00001617          	auipc	a2,0x1
ffffffffc02036d0:	32c60613          	addi	a2,a2,812 # ffffffffc02049f8 <commands+0x858>
ffffffffc02036d4:	1b500593          	li	a1,437
ffffffffc02036d8:	00002517          	auipc	a0,0x2
ffffffffc02036dc:	ea850513          	addi	a0,a0,-344 # ffffffffc0205580 <default_pmm_manager+0xf0>
ffffffffc02036e0:	a25fc0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc02036e4:	00002697          	auipc	a3,0x2
ffffffffc02036e8:	20c68693          	addi	a3,a3,524 # ffffffffc02058f0 <default_pmm_manager+0x460>
ffffffffc02036ec:	00001617          	auipc	a2,0x1
ffffffffc02036f0:	30c60613          	addi	a2,a2,780 # ffffffffc02049f8 <commands+0x858>
ffffffffc02036f4:	1b300593          	li	a1,435
ffffffffc02036f8:	00002517          	auipc	a0,0x2
ffffffffc02036fc:	e8850513          	addi	a0,a0,-376 # ffffffffc0205580 <default_pmm_manager+0xf0>
ffffffffc0203700:	a05fc0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0203704:	00002697          	auipc	a3,0x2
ffffffffc0203708:	33c68693          	addi	a3,a3,828 # ffffffffc0205a40 <default_pmm_manager+0x5b0>
ffffffffc020370c:	00001617          	auipc	a2,0x1
ffffffffc0203710:	2ec60613          	addi	a2,a2,748 # ffffffffc02049f8 <commands+0x858>
ffffffffc0203714:	1cb00593          	li	a1,459
ffffffffc0203718:	00002517          	auipc	a0,0x2
ffffffffc020371c:	e6850513          	addi	a0,a0,-408 # ffffffffc0205580 <default_pmm_manager+0xf0>
ffffffffc0203720:	9e5fc0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0203724:	00002697          	auipc	a3,0x2
ffffffffc0203728:	30468693          	addi	a3,a3,772 # ffffffffc0205a28 <default_pmm_manager+0x598>
ffffffffc020372c:	00001617          	auipc	a2,0x1
ffffffffc0203730:	2cc60613          	addi	a2,a2,716 # ffffffffc02049f8 <commands+0x858>
ffffffffc0203734:	1ca00593          	li	a1,458
ffffffffc0203738:	00002517          	auipc	a0,0x2
ffffffffc020373c:	e4850513          	addi	a0,a0,-440 # ffffffffc0205580 <default_pmm_manager+0xf0>
ffffffffc0203740:	9c5fc0ef          	jal	ra,ffffffffc0200104 <__panic>

ffffffffc0203744 <tlb_invalidate>:
ffffffffc0203744:	12000073          	sfence.vma
ffffffffc0203748:	8082                	ret

ffffffffc020374a <pgdir_alloc_page>:
ffffffffc020374a:	7179                	addi	sp,sp,-48
ffffffffc020374c:	e84a                	sd	s2,16(sp)
ffffffffc020374e:	892a                	mv	s2,a0
ffffffffc0203750:	4505                	li	a0,1
ffffffffc0203752:	f022                	sd	s0,32(sp)
ffffffffc0203754:	ec26                	sd	s1,24(sp)
ffffffffc0203756:	e44e                	sd	s3,8(sp)
ffffffffc0203758:	f406                	sd	ra,40(sp)
ffffffffc020375a:	84ae                	mv	s1,a1
ffffffffc020375c:	89b2                	mv	s3,a2
ffffffffc020375e:	994ff0ef          	jal	ra,ffffffffc02028f2 <alloc_pages>
ffffffffc0203762:	842a                	mv	s0,a0
ffffffffc0203764:	cd19                	beqz	a0,ffffffffc0203782 <pgdir_alloc_page+0x38>
ffffffffc0203766:	85aa                	mv	a1,a0
ffffffffc0203768:	86ce                	mv	a3,s3
ffffffffc020376a:	8626                	mv	a2,s1
ffffffffc020376c:	854a                	mv	a0,s2
ffffffffc020376e:	d60ff0ef          	jal	ra,ffffffffc0202cce <page_insert>
ffffffffc0203772:	ed39                	bnez	a0,ffffffffc02037d0 <pgdir_alloc_page+0x86>
ffffffffc0203774:	0000d797          	auipc	a5,0xd
ffffffffc0203778:	cec78793          	addi	a5,a5,-788 # ffffffffc0210460 <swap_init_ok>
ffffffffc020377c:	439c                	lw	a5,0(a5)
ffffffffc020377e:	2781                	sext.w	a5,a5
ffffffffc0203780:	eb89                	bnez	a5,ffffffffc0203792 <pgdir_alloc_page+0x48>
ffffffffc0203782:	8522                	mv	a0,s0
ffffffffc0203784:	70a2                	ld	ra,40(sp)
ffffffffc0203786:	7402                	ld	s0,32(sp)
ffffffffc0203788:	64e2                	ld	s1,24(sp)
ffffffffc020378a:	6942                	ld	s2,16(sp)
ffffffffc020378c:	69a2                	ld	s3,8(sp)
ffffffffc020378e:	6145                	addi	sp,sp,48
ffffffffc0203790:	8082                	ret
ffffffffc0203792:	0000d797          	auipc	a5,0xd
ffffffffc0203796:	cee78793          	addi	a5,a5,-786 # ffffffffc0210480 <check_mm_struct>
ffffffffc020379a:	6388                	ld	a0,0(a5)
ffffffffc020379c:	4681                	li	a3,0
ffffffffc020379e:	8622                	mv	a2,s0
ffffffffc02037a0:	85a6                	mv	a1,s1
ffffffffc02037a2:	9b0fe0ef          	jal	ra,ffffffffc0201952 <swap_map_swappable>
ffffffffc02037a6:	4018                	lw	a4,0(s0)
ffffffffc02037a8:	e024                	sd	s1,64(s0)
ffffffffc02037aa:	4785                	li	a5,1
ffffffffc02037ac:	fcf70be3          	beq	a4,a5,ffffffffc0203782 <pgdir_alloc_page+0x38>
ffffffffc02037b0:	00002697          	auipc	a3,0x2
ffffffffc02037b4:	e2068693          	addi	a3,a3,-480 # ffffffffc02055d0 <default_pmm_manager+0x140>
ffffffffc02037b8:	00001617          	auipc	a2,0x1
ffffffffc02037bc:	24060613          	addi	a2,a2,576 # ffffffffc02049f8 <commands+0x858>
ffffffffc02037c0:	17a00593          	li	a1,378
ffffffffc02037c4:	00002517          	auipc	a0,0x2
ffffffffc02037c8:	dbc50513          	addi	a0,a0,-580 # ffffffffc0205580 <default_pmm_manager+0xf0>
ffffffffc02037cc:	939fc0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc02037d0:	8522                	mv	a0,s0
ffffffffc02037d2:	4585                	li	a1,1
ffffffffc02037d4:	9a6ff0ef          	jal	ra,ffffffffc020297a <free_pages>
ffffffffc02037d8:	4401                	li	s0,0
ffffffffc02037da:	b765                	j	ffffffffc0203782 <pgdir_alloc_page+0x38>

ffffffffc02037dc <kmalloc>:
ffffffffc02037dc:	1141                	addi	sp,sp,-16
ffffffffc02037de:	67d5                	lui	a5,0x15
ffffffffc02037e0:	e406                	sd	ra,8(sp)
ffffffffc02037e2:	fff50713          	addi	a4,a0,-1
ffffffffc02037e6:	17f9                	addi	a5,a5,-2
ffffffffc02037e8:	04e7ee63          	bltu	a5,a4,ffffffffc0203844 <kmalloc+0x68>
ffffffffc02037ec:	6785                	lui	a5,0x1
ffffffffc02037ee:	17fd                	addi	a5,a5,-1
ffffffffc02037f0:	953e                	add	a0,a0,a5
ffffffffc02037f2:	8131                	srli	a0,a0,0xc
ffffffffc02037f4:	8feff0ef          	jal	ra,ffffffffc02028f2 <alloc_pages>
ffffffffc02037f8:	c159                	beqz	a0,ffffffffc020387e <kmalloc+0xa2>
ffffffffc02037fa:	0000d797          	auipc	a5,0xd
ffffffffc02037fe:	d8678793          	addi	a5,a5,-634 # ffffffffc0210580 <pages>
ffffffffc0203802:	639c                	ld	a5,0(a5)
ffffffffc0203804:	8d1d                	sub	a0,a0,a5
ffffffffc0203806:	00002797          	auipc	a5,0x2
ffffffffc020380a:	93278793          	addi	a5,a5,-1742 # ffffffffc0205138 <commands+0xf98>
ffffffffc020380e:	6394                	ld	a3,0(a5)
ffffffffc0203810:	850d                	srai	a0,a0,0x3
ffffffffc0203812:	0000d797          	auipc	a5,0xd
ffffffffc0203816:	c5e78793          	addi	a5,a5,-930 # ffffffffc0210470 <npage>
ffffffffc020381a:	02d50533          	mul	a0,a0,a3
ffffffffc020381e:	000806b7          	lui	a3,0x80
ffffffffc0203822:	6398                	ld	a4,0(a5)
ffffffffc0203824:	9536                	add	a0,a0,a3
ffffffffc0203826:	00c51793          	slli	a5,a0,0xc
ffffffffc020382a:	83b1                	srli	a5,a5,0xc
ffffffffc020382c:	0532                	slli	a0,a0,0xc
ffffffffc020382e:	02e7fb63          	bgeu	a5,a4,ffffffffc0203864 <kmalloc+0x88>
ffffffffc0203832:	0000d797          	auipc	a5,0xd
ffffffffc0203836:	d3e78793          	addi	a5,a5,-706 # ffffffffc0210570 <va_pa_offset>
ffffffffc020383a:	639c                	ld	a5,0(a5)
ffffffffc020383c:	60a2                	ld	ra,8(sp)
ffffffffc020383e:	953e                	add	a0,a0,a5
ffffffffc0203840:	0141                	addi	sp,sp,16
ffffffffc0203842:	8082                	ret
ffffffffc0203844:	00002697          	auipc	a3,0x2
ffffffffc0203848:	d5c68693          	addi	a3,a3,-676 # ffffffffc02055a0 <default_pmm_manager+0x110>
ffffffffc020384c:	00001617          	auipc	a2,0x1
ffffffffc0203850:	1ac60613          	addi	a2,a2,428 # ffffffffc02049f8 <commands+0x858>
ffffffffc0203854:	1df00593          	li	a1,479
ffffffffc0203858:	00002517          	auipc	a0,0x2
ffffffffc020385c:	d2850513          	addi	a0,a0,-728 # ffffffffc0205580 <default_pmm_manager+0xf0>
ffffffffc0203860:	8a5fc0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0203864:	86aa                	mv	a3,a0
ffffffffc0203866:	00002617          	auipc	a2,0x2
ffffffffc020386a:	cf260613          	addi	a2,a2,-782 # ffffffffc0205558 <default_pmm_manager+0xc8>
ffffffffc020386e:	06a00593          	li	a1,106
ffffffffc0203872:	00001517          	auipc	a0,0x1
ffffffffc0203876:	49e50513          	addi	a0,a0,1182 # ffffffffc0204d10 <commands+0xb70>
ffffffffc020387a:	88bfc0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc020387e:	00002697          	auipc	a3,0x2
ffffffffc0203882:	d4268693          	addi	a3,a3,-702 # ffffffffc02055c0 <default_pmm_manager+0x130>
ffffffffc0203886:	00001617          	auipc	a2,0x1
ffffffffc020388a:	17260613          	addi	a2,a2,370 # ffffffffc02049f8 <commands+0x858>
ffffffffc020388e:	1e200593          	li	a1,482
ffffffffc0203892:	00002517          	auipc	a0,0x2
ffffffffc0203896:	cee50513          	addi	a0,a0,-786 # ffffffffc0205580 <default_pmm_manager+0xf0>
ffffffffc020389a:	86bfc0ef          	jal	ra,ffffffffc0200104 <__panic>

ffffffffc020389e <kfree>:
ffffffffc020389e:	1141                	addi	sp,sp,-16
ffffffffc02038a0:	67d5                	lui	a5,0x15
ffffffffc02038a2:	e406                	sd	ra,8(sp)
ffffffffc02038a4:	fff58713          	addi	a4,a1,-1
ffffffffc02038a8:	17f9                	addi	a5,a5,-2
ffffffffc02038aa:	04e7eb63          	bltu	a5,a4,ffffffffc0203900 <kfree+0x62>
ffffffffc02038ae:	c941                	beqz	a0,ffffffffc020393e <kfree+0xa0>
ffffffffc02038b0:	6785                	lui	a5,0x1
ffffffffc02038b2:	17fd                	addi	a5,a5,-1
ffffffffc02038b4:	95be                	add	a1,a1,a5
ffffffffc02038b6:	c02007b7          	lui	a5,0xc0200
ffffffffc02038ba:	81b1                	srli	a1,a1,0xc
ffffffffc02038bc:	06f56463          	bltu	a0,a5,ffffffffc0203924 <kfree+0x86>
ffffffffc02038c0:	0000d797          	auipc	a5,0xd
ffffffffc02038c4:	cb078793          	addi	a5,a5,-848 # ffffffffc0210570 <va_pa_offset>
ffffffffc02038c8:	639c                	ld	a5,0(a5)
ffffffffc02038ca:	0000d717          	auipc	a4,0xd
ffffffffc02038ce:	ba670713          	addi	a4,a4,-1114 # ffffffffc0210470 <npage>
ffffffffc02038d2:	6318                	ld	a4,0(a4)
ffffffffc02038d4:	40f507b3          	sub	a5,a0,a5
ffffffffc02038d8:	83b1                	srli	a5,a5,0xc
ffffffffc02038da:	04e7f363          	bgeu	a5,a4,ffffffffc0203920 <kfree+0x82>
ffffffffc02038de:	fff80537          	lui	a0,0xfff80
ffffffffc02038e2:	97aa                	add	a5,a5,a0
ffffffffc02038e4:	0000d697          	auipc	a3,0xd
ffffffffc02038e8:	c9c68693          	addi	a3,a3,-868 # ffffffffc0210580 <pages>
ffffffffc02038ec:	6288                	ld	a0,0(a3)
ffffffffc02038ee:	00379713          	slli	a4,a5,0x3
ffffffffc02038f2:	60a2                	ld	ra,8(sp)
ffffffffc02038f4:	97ba                	add	a5,a5,a4
ffffffffc02038f6:	078e                	slli	a5,a5,0x3
ffffffffc02038f8:	953e                	add	a0,a0,a5
ffffffffc02038fa:	0141                	addi	sp,sp,16
ffffffffc02038fc:	87eff06f          	j	ffffffffc020297a <free_pages>
ffffffffc0203900:	00002697          	auipc	a3,0x2
ffffffffc0203904:	ca068693          	addi	a3,a3,-864 # ffffffffc02055a0 <default_pmm_manager+0x110>
ffffffffc0203908:	00001617          	auipc	a2,0x1
ffffffffc020390c:	0f060613          	addi	a2,a2,240 # ffffffffc02049f8 <commands+0x858>
ffffffffc0203910:	1e800593          	li	a1,488
ffffffffc0203914:	00002517          	auipc	a0,0x2
ffffffffc0203918:	c6c50513          	addi	a0,a0,-916 # ffffffffc0205580 <default_pmm_manager+0xf0>
ffffffffc020391c:	fe8fc0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0203920:	fb7fe0ef          	jal	ra,ffffffffc02028d6 <pa2page.part.4>
ffffffffc0203924:	86aa                	mv	a3,a0
ffffffffc0203926:	00002617          	auipc	a2,0x2
ffffffffc020392a:	d4a60613          	addi	a2,a2,-694 # ffffffffc0205670 <default_pmm_manager+0x1e0>
ffffffffc020392e:	06c00593          	li	a1,108
ffffffffc0203932:	00001517          	auipc	a0,0x1
ffffffffc0203936:	3de50513          	addi	a0,a0,990 # ffffffffc0204d10 <commands+0xb70>
ffffffffc020393a:	fcafc0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc020393e:	00002697          	auipc	a3,0x2
ffffffffc0203942:	c5268693          	addi	a3,a3,-942 # ffffffffc0205590 <default_pmm_manager+0x100>
ffffffffc0203946:	00001617          	auipc	a2,0x1
ffffffffc020394a:	0b260613          	addi	a2,a2,178 # ffffffffc02049f8 <commands+0x858>
ffffffffc020394e:	1e900593          	li	a1,489
ffffffffc0203952:	00002517          	auipc	a0,0x2
ffffffffc0203956:	c2e50513          	addi	a0,a0,-978 # ffffffffc0205580 <default_pmm_manager+0xf0>
ffffffffc020395a:	faafc0ef          	jal	ra,ffffffffc0200104 <__panic>

ffffffffc020395e <swapfs_init>:
ffffffffc020395e:	1141                	addi	sp,sp,-16
ffffffffc0203960:	4505                	li	a0,1
ffffffffc0203962:	e406                	sd	ra,8(sp)
ffffffffc0203964:	a6ffc0ef          	jal	ra,ffffffffc02003d2 <ide_device_valid>
ffffffffc0203968:	cd01                	beqz	a0,ffffffffc0203980 <swapfs_init+0x22>
ffffffffc020396a:	4505                	li	a0,1
ffffffffc020396c:	a6dfc0ef          	jal	ra,ffffffffc02003d8 <ide_device_size>
ffffffffc0203970:	60a2                	ld	ra,8(sp)
ffffffffc0203972:	810d                	srli	a0,a0,0x3
ffffffffc0203974:	0000d797          	auipc	a5,0xd
ffffffffc0203978:	b8a7be23          	sd	a0,-1124(a5) # ffffffffc0210510 <max_swap_offset>
ffffffffc020397c:	0141                	addi	sp,sp,16
ffffffffc020397e:	8082                	ret
ffffffffc0203980:	00002617          	auipc	a2,0x2
ffffffffc0203984:	1b060613          	addi	a2,a2,432 # ffffffffc0205b30 <default_pmm_manager+0x6a0>
ffffffffc0203988:	45b5                	li	a1,13
ffffffffc020398a:	00002517          	auipc	a0,0x2
ffffffffc020398e:	1c650513          	addi	a0,a0,454 # ffffffffc0205b50 <default_pmm_manager+0x6c0>
ffffffffc0203992:	f72fc0ef          	jal	ra,ffffffffc0200104 <__panic>

ffffffffc0203996 <swapfs_read>:
ffffffffc0203996:	1141                	addi	sp,sp,-16
ffffffffc0203998:	e406                	sd	ra,8(sp)
ffffffffc020399a:	00855793          	srli	a5,a0,0x8
ffffffffc020399e:	c7b5                	beqz	a5,ffffffffc0203a0a <swapfs_read+0x74>
ffffffffc02039a0:	0000d717          	auipc	a4,0xd
ffffffffc02039a4:	b7070713          	addi	a4,a4,-1168 # ffffffffc0210510 <max_swap_offset>
ffffffffc02039a8:	6318                	ld	a4,0(a4)
ffffffffc02039aa:	06e7f063          	bgeu	a5,a4,ffffffffc0203a0a <swapfs_read+0x74>
ffffffffc02039ae:	0000d717          	auipc	a4,0xd
ffffffffc02039b2:	bd270713          	addi	a4,a4,-1070 # ffffffffc0210580 <pages>
ffffffffc02039b6:	6310                	ld	a2,0(a4)
ffffffffc02039b8:	00001717          	auipc	a4,0x1
ffffffffc02039bc:	78070713          	addi	a4,a4,1920 # ffffffffc0205138 <commands+0xf98>
ffffffffc02039c0:	00002697          	auipc	a3,0x2
ffffffffc02039c4:	41068693          	addi	a3,a3,1040 # ffffffffc0205dd0 <nbase>
ffffffffc02039c8:	40c58633          	sub	a2,a1,a2
ffffffffc02039cc:	630c                	ld	a1,0(a4)
ffffffffc02039ce:	860d                	srai	a2,a2,0x3
ffffffffc02039d0:	0000d717          	auipc	a4,0xd
ffffffffc02039d4:	aa070713          	addi	a4,a4,-1376 # ffffffffc0210470 <npage>
ffffffffc02039d8:	02b60633          	mul	a2,a2,a1
ffffffffc02039dc:	0037959b          	slliw	a1,a5,0x3
ffffffffc02039e0:	629c                	ld	a5,0(a3)
ffffffffc02039e2:	6318                	ld	a4,0(a4)
ffffffffc02039e4:	963e                	add	a2,a2,a5
ffffffffc02039e6:	00c61793          	slli	a5,a2,0xc
ffffffffc02039ea:	83b1                	srli	a5,a5,0xc
ffffffffc02039ec:	0632                	slli	a2,a2,0xc
ffffffffc02039ee:	02e7fa63          	bgeu	a5,a4,ffffffffc0203a22 <swapfs_read+0x8c>
ffffffffc02039f2:	0000d797          	auipc	a5,0xd
ffffffffc02039f6:	b7e78793          	addi	a5,a5,-1154 # ffffffffc0210570 <va_pa_offset>
ffffffffc02039fa:	639c                	ld	a5,0(a5)
ffffffffc02039fc:	60a2                	ld	ra,8(sp)
ffffffffc02039fe:	46a1                	li	a3,8
ffffffffc0203a00:	963e                	add	a2,a2,a5
ffffffffc0203a02:	4505                	li	a0,1
ffffffffc0203a04:	0141                	addi	sp,sp,16
ffffffffc0203a06:	9d9fc06f          	j	ffffffffc02003de <ide_read_secs>
ffffffffc0203a0a:	86aa                	mv	a3,a0
ffffffffc0203a0c:	00002617          	auipc	a2,0x2
ffffffffc0203a10:	15c60613          	addi	a2,a2,348 # ffffffffc0205b68 <default_pmm_manager+0x6d8>
ffffffffc0203a14:	45d1                	li	a1,20
ffffffffc0203a16:	00002517          	auipc	a0,0x2
ffffffffc0203a1a:	13a50513          	addi	a0,a0,314 # ffffffffc0205b50 <default_pmm_manager+0x6c0>
ffffffffc0203a1e:	ee6fc0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0203a22:	86b2                	mv	a3,a2
ffffffffc0203a24:	06a00593          	li	a1,106
ffffffffc0203a28:	00002617          	auipc	a2,0x2
ffffffffc0203a2c:	b3060613          	addi	a2,a2,-1232 # ffffffffc0205558 <default_pmm_manager+0xc8>
ffffffffc0203a30:	00001517          	auipc	a0,0x1
ffffffffc0203a34:	2e050513          	addi	a0,a0,736 # ffffffffc0204d10 <commands+0xb70>
ffffffffc0203a38:	eccfc0ef          	jal	ra,ffffffffc0200104 <__panic>

ffffffffc0203a3c <swapfs_write>:
ffffffffc0203a3c:	1141                	addi	sp,sp,-16
ffffffffc0203a3e:	e406                	sd	ra,8(sp)
ffffffffc0203a40:	00855793          	srli	a5,a0,0x8
ffffffffc0203a44:	c7b5                	beqz	a5,ffffffffc0203ab0 <swapfs_write+0x74>
ffffffffc0203a46:	0000d717          	auipc	a4,0xd
ffffffffc0203a4a:	aca70713          	addi	a4,a4,-1334 # ffffffffc0210510 <max_swap_offset>
ffffffffc0203a4e:	6318                	ld	a4,0(a4)
ffffffffc0203a50:	06e7f063          	bgeu	a5,a4,ffffffffc0203ab0 <swapfs_write+0x74>
ffffffffc0203a54:	0000d717          	auipc	a4,0xd
ffffffffc0203a58:	b2c70713          	addi	a4,a4,-1236 # ffffffffc0210580 <pages>
ffffffffc0203a5c:	6310                	ld	a2,0(a4)
ffffffffc0203a5e:	00001717          	auipc	a4,0x1
ffffffffc0203a62:	6da70713          	addi	a4,a4,1754 # ffffffffc0205138 <commands+0xf98>
ffffffffc0203a66:	00002697          	auipc	a3,0x2
ffffffffc0203a6a:	36a68693          	addi	a3,a3,874 # ffffffffc0205dd0 <nbase>
ffffffffc0203a6e:	40c58633          	sub	a2,a1,a2
ffffffffc0203a72:	630c                	ld	a1,0(a4)
ffffffffc0203a74:	860d                	srai	a2,a2,0x3
ffffffffc0203a76:	0000d717          	auipc	a4,0xd
ffffffffc0203a7a:	9fa70713          	addi	a4,a4,-1542 # ffffffffc0210470 <npage>
ffffffffc0203a7e:	02b60633          	mul	a2,a2,a1
ffffffffc0203a82:	0037959b          	slliw	a1,a5,0x3
ffffffffc0203a86:	629c                	ld	a5,0(a3)
ffffffffc0203a88:	6318                	ld	a4,0(a4)
ffffffffc0203a8a:	963e                	add	a2,a2,a5
ffffffffc0203a8c:	00c61793          	slli	a5,a2,0xc
ffffffffc0203a90:	83b1                	srli	a5,a5,0xc
ffffffffc0203a92:	0632                	slli	a2,a2,0xc
ffffffffc0203a94:	02e7fa63          	bgeu	a5,a4,ffffffffc0203ac8 <swapfs_write+0x8c>
ffffffffc0203a98:	0000d797          	auipc	a5,0xd
ffffffffc0203a9c:	ad878793          	addi	a5,a5,-1320 # ffffffffc0210570 <va_pa_offset>
ffffffffc0203aa0:	639c                	ld	a5,0(a5)
ffffffffc0203aa2:	60a2                	ld	ra,8(sp)
ffffffffc0203aa4:	46a1                	li	a3,8
ffffffffc0203aa6:	963e                	add	a2,a2,a5
ffffffffc0203aa8:	4505                	li	a0,1
ffffffffc0203aaa:	0141                	addi	sp,sp,16
ffffffffc0203aac:	957fc06f          	j	ffffffffc0200402 <ide_write_secs>
ffffffffc0203ab0:	86aa                	mv	a3,a0
ffffffffc0203ab2:	00002617          	auipc	a2,0x2
ffffffffc0203ab6:	0b660613          	addi	a2,a2,182 # ffffffffc0205b68 <default_pmm_manager+0x6d8>
ffffffffc0203aba:	45e5                	li	a1,25
ffffffffc0203abc:	00002517          	auipc	a0,0x2
ffffffffc0203ac0:	09450513          	addi	a0,a0,148 # ffffffffc0205b50 <default_pmm_manager+0x6c0>
ffffffffc0203ac4:	e40fc0ef          	jal	ra,ffffffffc0200104 <__panic>
ffffffffc0203ac8:	86b2                	mv	a3,a2
ffffffffc0203aca:	06a00593          	li	a1,106
ffffffffc0203ace:	00002617          	auipc	a2,0x2
ffffffffc0203ad2:	a8a60613          	addi	a2,a2,-1398 # ffffffffc0205558 <default_pmm_manager+0xc8>
ffffffffc0203ad6:	00001517          	auipc	a0,0x1
ffffffffc0203ada:	23a50513          	addi	a0,a0,570 # ffffffffc0204d10 <commands+0xb70>
ffffffffc0203ade:	e26fc0ef          	jal	ra,ffffffffc0200104 <__panic>

ffffffffc0203ae2 <strlen>:
ffffffffc0203ae2:	00054783          	lbu	a5,0(a0)
ffffffffc0203ae6:	cb91                	beqz	a5,ffffffffc0203afa <strlen+0x18>
ffffffffc0203ae8:	4781                	li	a5,0
ffffffffc0203aea:	0785                	addi	a5,a5,1
ffffffffc0203aec:	00f50733          	add	a4,a0,a5
ffffffffc0203af0:	00074703          	lbu	a4,0(a4)
ffffffffc0203af4:	fb7d                	bnez	a4,ffffffffc0203aea <strlen+0x8>
ffffffffc0203af6:	853e                	mv	a0,a5
ffffffffc0203af8:	8082                	ret
ffffffffc0203afa:	4781                	li	a5,0
ffffffffc0203afc:	853e                	mv	a0,a5
ffffffffc0203afe:	8082                	ret

ffffffffc0203b00 <strnlen>:
ffffffffc0203b00:	c185                	beqz	a1,ffffffffc0203b20 <strnlen+0x20>
ffffffffc0203b02:	00054783          	lbu	a5,0(a0)
ffffffffc0203b06:	cf89                	beqz	a5,ffffffffc0203b20 <strnlen+0x20>
ffffffffc0203b08:	4781                	li	a5,0
ffffffffc0203b0a:	a021                	j	ffffffffc0203b12 <strnlen+0x12>
ffffffffc0203b0c:	00074703          	lbu	a4,0(a4)
ffffffffc0203b10:	c711                	beqz	a4,ffffffffc0203b1c <strnlen+0x1c>
ffffffffc0203b12:	0785                	addi	a5,a5,1
ffffffffc0203b14:	00f50733          	add	a4,a0,a5
ffffffffc0203b18:	fef59ae3          	bne	a1,a5,ffffffffc0203b0c <strnlen+0xc>
ffffffffc0203b1c:	853e                	mv	a0,a5
ffffffffc0203b1e:	8082                	ret
ffffffffc0203b20:	4781                	li	a5,0
ffffffffc0203b22:	853e                	mv	a0,a5
ffffffffc0203b24:	8082                	ret

ffffffffc0203b26 <strcpy>:
ffffffffc0203b26:	87aa                	mv	a5,a0
ffffffffc0203b28:	0585                	addi	a1,a1,1
ffffffffc0203b2a:	fff5c703          	lbu	a4,-1(a1)
ffffffffc0203b2e:	0785                	addi	a5,a5,1
ffffffffc0203b30:	fee78fa3          	sb	a4,-1(a5)
ffffffffc0203b34:	fb75                	bnez	a4,ffffffffc0203b28 <strcpy+0x2>
ffffffffc0203b36:	8082                	ret

ffffffffc0203b38 <strcmp>:
ffffffffc0203b38:	00054783          	lbu	a5,0(a0)
ffffffffc0203b3c:	0005c703          	lbu	a4,0(a1)
ffffffffc0203b40:	cb91                	beqz	a5,ffffffffc0203b54 <strcmp+0x1c>
ffffffffc0203b42:	00e79c63          	bne	a5,a4,ffffffffc0203b5a <strcmp+0x22>
ffffffffc0203b46:	0505                	addi	a0,a0,1
ffffffffc0203b48:	00054783          	lbu	a5,0(a0)
ffffffffc0203b4c:	0585                	addi	a1,a1,1
ffffffffc0203b4e:	0005c703          	lbu	a4,0(a1)
ffffffffc0203b52:	fbe5                	bnez	a5,ffffffffc0203b42 <strcmp+0xa>
ffffffffc0203b54:	4501                	li	a0,0
ffffffffc0203b56:	9d19                	subw	a0,a0,a4
ffffffffc0203b58:	8082                	ret
ffffffffc0203b5a:	0007851b          	sext.w	a0,a5
ffffffffc0203b5e:	9d19                	subw	a0,a0,a4
ffffffffc0203b60:	8082                	ret

ffffffffc0203b62 <strchr>:
ffffffffc0203b62:	00054783          	lbu	a5,0(a0)
ffffffffc0203b66:	cb91                	beqz	a5,ffffffffc0203b7a <strchr+0x18>
ffffffffc0203b68:	00b79563          	bne	a5,a1,ffffffffc0203b72 <strchr+0x10>
ffffffffc0203b6c:	a809                	j	ffffffffc0203b7e <strchr+0x1c>
ffffffffc0203b6e:	00b78763          	beq	a5,a1,ffffffffc0203b7c <strchr+0x1a>
ffffffffc0203b72:	0505                	addi	a0,a0,1
ffffffffc0203b74:	00054783          	lbu	a5,0(a0)
ffffffffc0203b78:	fbfd                	bnez	a5,ffffffffc0203b6e <strchr+0xc>
ffffffffc0203b7a:	4501                	li	a0,0
ffffffffc0203b7c:	8082                	ret
ffffffffc0203b7e:	8082                	ret

ffffffffc0203b80 <memset>:
ffffffffc0203b80:	ca01                	beqz	a2,ffffffffc0203b90 <memset+0x10>
ffffffffc0203b82:	962a                	add	a2,a2,a0
ffffffffc0203b84:	87aa                	mv	a5,a0
ffffffffc0203b86:	0785                	addi	a5,a5,1
ffffffffc0203b88:	feb78fa3          	sb	a1,-1(a5)
ffffffffc0203b8c:	fec79de3          	bne	a5,a2,ffffffffc0203b86 <memset+0x6>
ffffffffc0203b90:	8082                	ret

ffffffffc0203b92 <memcpy>:
ffffffffc0203b92:	ca19                	beqz	a2,ffffffffc0203ba8 <memcpy+0x16>
ffffffffc0203b94:	962e                	add	a2,a2,a1
ffffffffc0203b96:	87aa                	mv	a5,a0
ffffffffc0203b98:	0585                	addi	a1,a1,1
ffffffffc0203b9a:	fff5c703          	lbu	a4,-1(a1)
ffffffffc0203b9e:	0785                	addi	a5,a5,1
ffffffffc0203ba0:	fee78fa3          	sb	a4,-1(a5)
ffffffffc0203ba4:	fec59ae3          	bne	a1,a2,ffffffffc0203b98 <memcpy+0x6>
ffffffffc0203ba8:	8082                	ret

ffffffffc0203baa <printnum>:
ffffffffc0203baa:	02069813          	slli	a6,a3,0x20
ffffffffc0203bae:	7179                	addi	sp,sp,-48
ffffffffc0203bb0:	02085813          	srli	a6,a6,0x20
ffffffffc0203bb4:	e052                	sd	s4,0(sp)
ffffffffc0203bb6:	03067a33          	remu	s4,a2,a6
ffffffffc0203bba:	f022                	sd	s0,32(sp)
ffffffffc0203bbc:	ec26                	sd	s1,24(sp)
ffffffffc0203bbe:	e84a                	sd	s2,16(sp)
ffffffffc0203bc0:	f406                	sd	ra,40(sp)
ffffffffc0203bc2:	e44e                	sd	s3,8(sp)
ffffffffc0203bc4:	84aa                	mv	s1,a0
ffffffffc0203bc6:	892e                	mv	s2,a1
ffffffffc0203bc8:	fff7041b          	addiw	s0,a4,-1
ffffffffc0203bcc:	2a01                	sext.w	s4,s4
ffffffffc0203bce:	03067e63          	bgeu	a2,a6,ffffffffc0203c0a <printnum+0x60>
ffffffffc0203bd2:	89be                	mv	s3,a5
ffffffffc0203bd4:	00805763          	blez	s0,ffffffffc0203be2 <printnum+0x38>
ffffffffc0203bd8:	347d                	addiw	s0,s0,-1
ffffffffc0203bda:	85ca                	mv	a1,s2
ffffffffc0203bdc:	854e                	mv	a0,s3
ffffffffc0203bde:	9482                	jalr	s1
ffffffffc0203be0:	fc65                	bnez	s0,ffffffffc0203bd8 <printnum+0x2e>
ffffffffc0203be2:	1a02                	slli	s4,s4,0x20
ffffffffc0203be4:	020a5a13          	srli	s4,s4,0x20
ffffffffc0203be8:	00002797          	auipc	a5,0x2
ffffffffc0203bec:	13078793          	addi	a5,a5,304 # ffffffffc0205d18 <error_string+0x38>
ffffffffc0203bf0:	9a3e                	add	s4,s4,a5
ffffffffc0203bf2:	7402                	ld	s0,32(sp)
ffffffffc0203bf4:	000a4503          	lbu	a0,0(s4)
ffffffffc0203bf8:	70a2                	ld	ra,40(sp)
ffffffffc0203bfa:	69a2                	ld	s3,8(sp)
ffffffffc0203bfc:	6a02                	ld	s4,0(sp)
ffffffffc0203bfe:	85ca                	mv	a1,s2
ffffffffc0203c00:	8326                	mv	t1,s1
ffffffffc0203c02:	6942                	ld	s2,16(sp)
ffffffffc0203c04:	64e2                	ld	s1,24(sp)
ffffffffc0203c06:	6145                	addi	sp,sp,48
ffffffffc0203c08:	8302                	jr	t1
ffffffffc0203c0a:	03065633          	divu	a2,a2,a6
ffffffffc0203c0e:	8722                	mv	a4,s0
ffffffffc0203c10:	f9bff0ef          	jal	ra,ffffffffc0203baa <printnum>
ffffffffc0203c14:	b7f9                	j	ffffffffc0203be2 <printnum+0x38>

ffffffffc0203c16 <vprintfmt>:
ffffffffc0203c16:	7119                	addi	sp,sp,-128
ffffffffc0203c18:	f4a6                	sd	s1,104(sp)
ffffffffc0203c1a:	f0ca                	sd	s2,96(sp)
ffffffffc0203c1c:	e8d2                	sd	s4,80(sp)
ffffffffc0203c1e:	e4d6                	sd	s5,72(sp)
ffffffffc0203c20:	e0da                	sd	s6,64(sp)
ffffffffc0203c22:	fc5e                	sd	s7,56(sp)
ffffffffc0203c24:	f862                	sd	s8,48(sp)
ffffffffc0203c26:	f06a                	sd	s10,32(sp)
ffffffffc0203c28:	fc86                	sd	ra,120(sp)
ffffffffc0203c2a:	f8a2                	sd	s0,112(sp)
ffffffffc0203c2c:	ecce                	sd	s3,88(sp)
ffffffffc0203c2e:	f466                	sd	s9,40(sp)
ffffffffc0203c30:	ec6e                	sd	s11,24(sp)
ffffffffc0203c32:	892a                	mv	s2,a0
ffffffffc0203c34:	84ae                	mv	s1,a1
ffffffffc0203c36:	8d32                	mv	s10,a2
ffffffffc0203c38:	8ab6                	mv	s5,a3
ffffffffc0203c3a:	5b7d                	li	s6,-1
ffffffffc0203c3c:	00002a17          	auipc	s4,0x2
ffffffffc0203c40:	f4ca0a13          	addi	s4,s4,-180 # ffffffffc0205b88 <default_pmm_manager+0x6f8>
ffffffffc0203c44:	05e00b93          	li	s7,94
ffffffffc0203c48:	00002c17          	auipc	s8,0x2
ffffffffc0203c4c:	098c0c13          	addi	s8,s8,152 # ffffffffc0205ce0 <error_string>
ffffffffc0203c50:	000d4503          	lbu	a0,0(s10)
ffffffffc0203c54:	02500793          	li	a5,37
ffffffffc0203c58:	001d0413          	addi	s0,s10,1
ffffffffc0203c5c:	00f50e63          	beq	a0,a5,ffffffffc0203c78 <vprintfmt+0x62>
ffffffffc0203c60:	c521                	beqz	a0,ffffffffc0203ca8 <vprintfmt+0x92>
ffffffffc0203c62:	02500993          	li	s3,37
ffffffffc0203c66:	a011                	j	ffffffffc0203c6a <vprintfmt+0x54>
ffffffffc0203c68:	c121                	beqz	a0,ffffffffc0203ca8 <vprintfmt+0x92>
ffffffffc0203c6a:	85a6                	mv	a1,s1
ffffffffc0203c6c:	0405                	addi	s0,s0,1
ffffffffc0203c6e:	9902                	jalr	s2
ffffffffc0203c70:	fff44503          	lbu	a0,-1(s0)
ffffffffc0203c74:	ff351ae3          	bne	a0,s3,ffffffffc0203c68 <vprintfmt+0x52>
ffffffffc0203c78:	00044603          	lbu	a2,0(s0)
ffffffffc0203c7c:	02000793          	li	a5,32
ffffffffc0203c80:	4981                	li	s3,0
ffffffffc0203c82:	4801                	li	a6,0
ffffffffc0203c84:	5cfd                	li	s9,-1
ffffffffc0203c86:	5dfd                	li	s11,-1
ffffffffc0203c88:	05500593          	li	a1,85
ffffffffc0203c8c:	4525                	li	a0,9
ffffffffc0203c8e:	fdd6069b          	addiw	a3,a2,-35
ffffffffc0203c92:	0ff6f693          	andi	a3,a3,255
ffffffffc0203c96:	00140d13          	addi	s10,s0,1
ffffffffc0203c9a:	1ed5ef63          	bltu	a1,a3,ffffffffc0203e98 <vprintfmt+0x282>
ffffffffc0203c9e:	068a                	slli	a3,a3,0x2
ffffffffc0203ca0:	96d2                	add	a3,a3,s4
ffffffffc0203ca2:	4294                	lw	a3,0(a3)
ffffffffc0203ca4:	96d2                	add	a3,a3,s4
ffffffffc0203ca6:	8682                	jr	a3
ffffffffc0203ca8:	70e6                	ld	ra,120(sp)
ffffffffc0203caa:	7446                	ld	s0,112(sp)
ffffffffc0203cac:	74a6                	ld	s1,104(sp)
ffffffffc0203cae:	7906                	ld	s2,96(sp)
ffffffffc0203cb0:	69e6                	ld	s3,88(sp)
ffffffffc0203cb2:	6a46                	ld	s4,80(sp)
ffffffffc0203cb4:	6aa6                	ld	s5,72(sp)
ffffffffc0203cb6:	6b06                	ld	s6,64(sp)
ffffffffc0203cb8:	7be2                	ld	s7,56(sp)
ffffffffc0203cba:	7c42                	ld	s8,48(sp)
ffffffffc0203cbc:	7ca2                	ld	s9,40(sp)
ffffffffc0203cbe:	7d02                	ld	s10,32(sp)
ffffffffc0203cc0:	6de2                	ld	s11,24(sp)
ffffffffc0203cc2:	6109                	addi	sp,sp,128
ffffffffc0203cc4:	8082                	ret
ffffffffc0203cc6:	87b2                	mv	a5,a2
ffffffffc0203cc8:	00144603          	lbu	a2,1(s0)
ffffffffc0203ccc:	846a                	mv	s0,s10
ffffffffc0203cce:	b7c1                	j	ffffffffc0203c8e <vprintfmt+0x78>
ffffffffc0203cd0:	000aac83          	lw	s9,0(s5) # 80000 <BASE_ADDRESS-0xffffffffc0180000>
ffffffffc0203cd4:	00144603          	lbu	a2,1(s0)
ffffffffc0203cd8:	0aa1                	addi	s5,s5,8
ffffffffc0203cda:	846a                	mv	s0,s10
ffffffffc0203cdc:	fa0dd9e3          	bgez	s11,ffffffffc0203c8e <vprintfmt+0x78>
ffffffffc0203ce0:	8de6                	mv	s11,s9
ffffffffc0203ce2:	5cfd                	li	s9,-1
ffffffffc0203ce4:	b76d                	j	ffffffffc0203c8e <vprintfmt+0x78>
ffffffffc0203ce6:	fffdc693          	not	a3,s11
ffffffffc0203cea:	96fd                	srai	a3,a3,0x3f
ffffffffc0203cec:	00ddfdb3          	and	s11,s11,a3
ffffffffc0203cf0:	00144603          	lbu	a2,1(s0)
ffffffffc0203cf4:	2d81                	sext.w	s11,s11
ffffffffc0203cf6:	846a                	mv	s0,s10
ffffffffc0203cf8:	bf59                	j	ffffffffc0203c8e <vprintfmt+0x78>
ffffffffc0203cfa:	4705                	li	a4,1
ffffffffc0203cfc:	008a8593          	addi	a1,s5,8
ffffffffc0203d00:	01074463          	blt	a4,a6,ffffffffc0203d08 <vprintfmt+0xf2>
ffffffffc0203d04:	22080863          	beqz	a6,ffffffffc0203f34 <vprintfmt+0x31e>
ffffffffc0203d08:	000ab603          	ld	a2,0(s5)
ffffffffc0203d0c:	46c1                	li	a3,16
ffffffffc0203d0e:	8aae                	mv	s5,a1
ffffffffc0203d10:	a291                	j	ffffffffc0203e54 <vprintfmt+0x23e>
ffffffffc0203d12:	fd060c9b          	addiw	s9,a2,-48
ffffffffc0203d16:	00144603          	lbu	a2,1(s0)
ffffffffc0203d1a:	846a                	mv	s0,s10
ffffffffc0203d1c:	fd06069b          	addiw	a3,a2,-48
ffffffffc0203d20:	0006089b          	sext.w	a7,a2
ffffffffc0203d24:	fad56ce3          	bltu	a0,a3,ffffffffc0203cdc <vprintfmt+0xc6>
ffffffffc0203d28:	0405                	addi	s0,s0,1
ffffffffc0203d2a:	002c969b          	slliw	a3,s9,0x2
ffffffffc0203d2e:	00044603          	lbu	a2,0(s0)
ffffffffc0203d32:	0196873b          	addw	a4,a3,s9
ffffffffc0203d36:	0017171b          	slliw	a4,a4,0x1
ffffffffc0203d3a:	0117073b          	addw	a4,a4,a7
ffffffffc0203d3e:	fd06069b          	addiw	a3,a2,-48
ffffffffc0203d42:	fd070c9b          	addiw	s9,a4,-48
ffffffffc0203d46:	0006089b          	sext.w	a7,a2
ffffffffc0203d4a:	fcd57fe3          	bgeu	a0,a3,ffffffffc0203d28 <vprintfmt+0x112>
ffffffffc0203d4e:	b779                	j	ffffffffc0203cdc <vprintfmt+0xc6>
ffffffffc0203d50:	000aa503          	lw	a0,0(s5)
ffffffffc0203d54:	85a6                	mv	a1,s1
ffffffffc0203d56:	0aa1                	addi	s5,s5,8
ffffffffc0203d58:	9902                	jalr	s2
ffffffffc0203d5a:	bddd                	j	ffffffffc0203c50 <vprintfmt+0x3a>
ffffffffc0203d5c:	4705                	li	a4,1
ffffffffc0203d5e:	008a8993          	addi	s3,s5,8
ffffffffc0203d62:	01074463          	blt	a4,a6,ffffffffc0203d6a <vprintfmt+0x154>
ffffffffc0203d66:	1c080463          	beqz	a6,ffffffffc0203f2e <vprintfmt+0x318>
ffffffffc0203d6a:	000ab403          	ld	s0,0(s5)
ffffffffc0203d6e:	1c044a63          	bltz	s0,ffffffffc0203f42 <vprintfmt+0x32c>
ffffffffc0203d72:	8622                	mv	a2,s0
ffffffffc0203d74:	8ace                	mv	s5,s3
ffffffffc0203d76:	46a9                	li	a3,10
ffffffffc0203d78:	a8f1                	j	ffffffffc0203e54 <vprintfmt+0x23e>
ffffffffc0203d7a:	000aa783          	lw	a5,0(s5)
ffffffffc0203d7e:	4719                	li	a4,6
ffffffffc0203d80:	0aa1                	addi	s5,s5,8
ffffffffc0203d82:	41f7d69b          	sraiw	a3,a5,0x1f
ffffffffc0203d86:	8fb5                	xor	a5,a5,a3
ffffffffc0203d88:	40d786bb          	subw	a3,a5,a3
ffffffffc0203d8c:	12d74963          	blt	a4,a3,ffffffffc0203ebe <vprintfmt+0x2a8>
ffffffffc0203d90:	00369793          	slli	a5,a3,0x3
ffffffffc0203d94:	97e2                	add	a5,a5,s8
ffffffffc0203d96:	639c                	ld	a5,0(a5)
ffffffffc0203d98:	12078363          	beqz	a5,ffffffffc0203ebe <vprintfmt+0x2a8>
ffffffffc0203d9c:	86be                	mv	a3,a5
ffffffffc0203d9e:	00002617          	auipc	a2,0x2
ffffffffc0203da2:	02a60613          	addi	a2,a2,42 # ffffffffc0205dc8 <error_string+0xe8>
ffffffffc0203da6:	85a6                	mv	a1,s1
ffffffffc0203da8:	854a                	mv	a0,s2
ffffffffc0203daa:	1cc000ef          	jal	ra,ffffffffc0203f76 <printfmt>
ffffffffc0203dae:	b54d                	j	ffffffffc0203c50 <vprintfmt+0x3a>
ffffffffc0203db0:	000ab603          	ld	a2,0(s5)
ffffffffc0203db4:	0aa1                	addi	s5,s5,8
ffffffffc0203db6:	1a060163          	beqz	a2,ffffffffc0203f58 <vprintfmt+0x342>
ffffffffc0203dba:	00160413          	addi	s0,a2,1
ffffffffc0203dbe:	15b05763          	blez	s11,ffffffffc0203f0c <vprintfmt+0x2f6>
ffffffffc0203dc2:	02d00593          	li	a1,45
ffffffffc0203dc6:	10b79d63          	bne	a5,a1,ffffffffc0203ee0 <vprintfmt+0x2ca>
ffffffffc0203dca:	00064783          	lbu	a5,0(a2)
ffffffffc0203dce:	0007851b          	sext.w	a0,a5
ffffffffc0203dd2:	c905                	beqz	a0,ffffffffc0203e02 <vprintfmt+0x1ec>
ffffffffc0203dd4:	000cc563          	bltz	s9,ffffffffc0203dde <vprintfmt+0x1c8>
ffffffffc0203dd8:	3cfd                	addiw	s9,s9,-1
ffffffffc0203dda:	036c8263          	beq	s9,s6,ffffffffc0203dfe <vprintfmt+0x1e8>
ffffffffc0203dde:	85a6                	mv	a1,s1
ffffffffc0203de0:	14098f63          	beqz	s3,ffffffffc0203f3e <vprintfmt+0x328>
ffffffffc0203de4:	3781                	addiw	a5,a5,-32
ffffffffc0203de6:	14fbfc63          	bgeu	s7,a5,ffffffffc0203f3e <vprintfmt+0x328>
ffffffffc0203dea:	03f00513          	li	a0,63
ffffffffc0203dee:	9902                	jalr	s2
ffffffffc0203df0:	0405                	addi	s0,s0,1
ffffffffc0203df2:	fff44783          	lbu	a5,-1(s0)
ffffffffc0203df6:	3dfd                	addiw	s11,s11,-1
ffffffffc0203df8:	0007851b          	sext.w	a0,a5
ffffffffc0203dfc:	fd61                	bnez	a0,ffffffffc0203dd4 <vprintfmt+0x1be>
ffffffffc0203dfe:	e5b059e3          	blez	s11,ffffffffc0203c50 <vprintfmt+0x3a>
ffffffffc0203e02:	3dfd                	addiw	s11,s11,-1
ffffffffc0203e04:	85a6                	mv	a1,s1
ffffffffc0203e06:	02000513          	li	a0,32
ffffffffc0203e0a:	9902                	jalr	s2
ffffffffc0203e0c:	e40d82e3          	beqz	s11,ffffffffc0203c50 <vprintfmt+0x3a>
ffffffffc0203e10:	3dfd                	addiw	s11,s11,-1
ffffffffc0203e12:	85a6                	mv	a1,s1
ffffffffc0203e14:	02000513          	li	a0,32
ffffffffc0203e18:	9902                	jalr	s2
ffffffffc0203e1a:	fe0d94e3          	bnez	s11,ffffffffc0203e02 <vprintfmt+0x1ec>
ffffffffc0203e1e:	bd0d                	j	ffffffffc0203c50 <vprintfmt+0x3a>
ffffffffc0203e20:	4705                	li	a4,1
ffffffffc0203e22:	008a8593          	addi	a1,s5,8
ffffffffc0203e26:	01074463          	blt	a4,a6,ffffffffc0203e2e <vprintfmt+0x218>
ffffffffc0203e2a:	0e080863          	beqz	a6,ffffffffc0203f1a <vprintfmt+0x304>
ffffffffc0203e2e:	000ab603          	ld	a2,0(s5)
ffffffffc0203e32:	46a1                	li	a3,8
ffffffffc0203e34:	8aae                	mv	s5,a1
ffffffffc0203e36:	a839                	j	ffffffffc0203e54 <vprintfmt+0x23e>
ffffffffc0203e38:	03000513          	li	a0,48
ffffffffc0203e3c:	85a6                	mv	a1,s1
ffffffffc0203e3e:	e03e                	sd	a5,0(sp)
ffffffffc0203e40:	9902                	jalr	s2
ffffffffc0203e42:	85a6                	mv	a1,s1
ffffffffc0203e44:	07800513          	li	a0,120
ffffffffc0203e48:	9902                	jalr	s2
ffffffffc0203e4a:	0aa1                	addi	s5,s5,8
ffffffffc0203e4c:	ff8ab603          	ld	a2,-8(s5)
ffffffffc0203e50:	6782                	ld	a5,0(sp)
ffffffffc0203e52:	46c1                	li	a3,16
ffffffffc0203e54:	2781                	sext.w	a5,a5
ffffffffc0203e56:	876e                	mv	a4,s11
ffffffffc0203e58:	85a6                	mv	a1,s1
ffffffffc0203e5a:	854a                	mv	a0,s2
ffffffffc0203e5c:	d4fff0ef          	jal	ra,ffffffffc0203baa <printnum>
ffffffffc0203e60:	bbc5                	j	ffffffffc0203c50 <vprintfmt+0x3a>
ffffffffc0203e62:	00144603          	lbu	a2,1(s0)
ffffffffc0203e66:	2805                	addiw	a6,a6,1
ffffffffc0203e68:	846a                	mv	s0,s10
ffffffffc0203e6a:	b515                	j	ffffffffc0203c8e <vprintfmt+0x78>
ffffffffc0203e6c:	00144603          	lbu	a2,1(s0)
ffffffffc0203e70:	4985                	li	s3,1
ffffffffc0203e72:	846a                	mv	s0,s10
ffffffffc0203e74:	bd29                	j	ffffffffc0203c8e <vprintfmt+0x78>
ffffffffc0203e76:	85a6                	mv	a1,s1
ffffffffc0203e78:	02500513          	li	a0,37
ffffffffc0203e7c:	9902                	jalr	s2
ffffffffc0203e7e:	bbc9                	j	ffffffffc0203c50 <vprintfmt+0x3a>
ffffffffc0203e80:	4705                	li	a4,1
ffffffffc0203e82:	008a8593          	addi	a1,s5,8
ffffffffc0203e86:	01074463          	blt	a4,a6,ffffffffc0203e8e <vprintfmt+0x278>
ffffffffc0203e8a:	08080d63          	beqz	a6,ffffffffc0203f24 <vprintfmt+0x30e>
ffffffffc0203e8e:	000ab603          	ld	a2,0(s5)
ffffffffc0203e92:	46a9                	li	a3,10
ffffffffc0203e94:	8aae                	mv	s5,a1
ffffffffc0203e96:	bf7d                	j	ffffffffc0203e54 <vprintfmt+0x23e>
ffffffffc0203e98:	85a6                	mv	a1,s1
ffffffffc0203e9a:	02500513          	li	a0,37
ffffffffc0203e9e:	9902                	jalr	s2
ffffffffc0203ea0:	fff44703          	lbu	a4,-1(s0)
ffffffffc0203ea4:	02500793          	li	a5,37
ffffffffc0203ea8:	8d22                	mv	s10,s0
ffffffffc0203eaa:	daf703e3          	beq	a4,a5,ffffffffc0203c50 <vprintfmt+0x3a>
ffffffffc0203eae:	02500713          	li	a4,37
ffffffffc0203eb2:	1d7d                	addi	s10,s10,-1
ffffffffc0203eb4:	fffd4783          	lbu	a5,-1(s10)
ffffffffc0203eb8:	fee79de3          	bne	a5,a4,ffffffffc0203eb2 <vprintfmt+0x29c>
ffffffffc0203ebc:	bb51                	j	ffffffffc0203c50 <vprintfmt+0x3a>
ffffffffc0203ebe:	00002617          	auipc	a2,0x2
ffffffffc0203ec2:	efa60613          	addi	a2,a2,-262 # ffffffffc0205db8 <error_string+0xd8>
ffffffffc0203ec6:	85a6                	mv	a1,s1
ffffffffc0203ec8:	854a                	mv	a0,s2
ffffffffc0203eca:	0ac000ef          	jal	ra,ffffffffc0203f76 <printfmt>
ffffffffc0203ece:	b349                	j	ffffffffc0203c50 <vprintfmt+0x3a>
ffffffffc0203ed0:	00002617          	auipc	a2,0x2
ffffffffc0203ed4:	ee060613          	addi	a2,a2,-288 # ffffffffc0205db0 <error_string+0xd0>
ffffffffc0203ed8:	00002417          	auipc	s0,0x2
ffffffffc0203edc:	ed940413          	addi	s0,s0,-295 # ffffffffc0205db1 <error_string+0xd1>
ffffffffc0203ee0:	8532                	mv	a0,a2
ffffffffc0203ee2:	85e6                	mv	a1,s9
ffffffffc0203ee4:	e032                	sd	a2,0(sp)
ffffffffc0203ee6:	e43e                	sd	a5,8(sp)
ffffffffc0203ee8:	c19ff0ef          	jal	ra,ffffffffc0203b00 <strnlen>
ffffffffc0203eec:	40ad8dbb          	subw	s11,s11,a0
ffffffffc0203ef0:	6602                	ld	a2,0(sp)
ffffffffc0203ef2:	01b05d63          	blez	s11,ffffffffc0203f0c <vprintfmt+0x2f6>
ffffffffc0203ef6:	67a2                	ld	a5,8(sp)
ffffffffc0203ef8:	2781                	sext.w	a5,a5
ffffffffc0203efa:	e43e                	sd	a5,8(sp)
ffffffffc0203efc:	6522                	ld	a0,8(sp)
ffffffffc0203efe:	85a6                	mv	a1,s1
ffffffffc0203f00:	e032                	sd	a2,0(sp)
ffffffffc0203f02:	3dfd                	addiw	s11,s11,-1
ffffffffc0203f04:	9902                	jalr	s2
ffffffffc0203f06:	6602                	ld	a2,0(sp)
ffffffffc0203f08:	fe0d9ae3          	bnez	s11,ffffffffc0203efc <vprintfmt+0x2e6>
ffffffffc0203f0c:	00064783          	lbu	a5,0(a2)
ffffffffc0203f10:	0007851b          	sext.w	a0,a5
ffffffffc0203f14:	ec0510e3          	bnez	a0,ffffffffc0203dd4 <vprintfmt+0x1be>
ffffffffc0203f18:	bb25                	j	ffffffffc0203c50 <vprintfmt+0x3a>
ffffffffc0203f1a:	000ae603          	lwu	a2,0(s5)
ffffffffc0203f1e:	46a1                	li	a3,8
ffffffffc0203f20:	8aae                	mv	s5,a1
ffffffffc0203f22:	bf0d                	j	ffffffffc0203e54 <vprintfmt+0x23e>
ffffffffc0203f24:	000ae603          	lwu	a2,0(s5)
ffffffffc0203f28:	46a9                	li	a3,10
ffffffffc0203f2a:	8aae                	mv	s5,a1
ffffffffc0203f2c:	b725                	j	ffffffffc0203e54 <vprintfmt+0x23e>
ffffffffc0203f2e:	000aa403          	lw	s0,0(s5)
ffffffffc0203f32:	bd35                	j	ffffffffc0203d6e <vprintfmt+0x158>
ffffffffc0203f34:	000ae603          	lwu	a2,0(s5)
ffffffffc0203f38:	46c1                	li	a3,16
ffffffffc0203f3a:	8aae                	mv	s5,a1
ffffffffc0203f3c:	bf21                	j	ffffffffc0203e54 <vprintfmt+0x23e>
ffffffffc0203f3e:	9902                	jalr	s2
ffffffffc0203f40:	bd45                	j	ffffffffc0203df0 <vprintfmt+0x1da>
ffffffffc0203f42:	85a6                	mv	a1,s1
ffffffffc0203f44:	02d00513          	li	a0,45
ffffffffc0203f48:	e03e                	sd	a5,0(sp)
ffffffffc0203f4a:	9902                	jalr	s2
ffffffffc0203f4c:	8ace                	mv	s5,s3
ffffffffc0203f4e:	40800633          	neg	a2,s0
ffffffffc0203f52:	46a9                	li	a3,10
ffffffffc0203f54:	6782                	ld	a5,0(sp)
ffffffffc0203f56:	bdfd                	j	ffffffffc0203e54 <vprintfmt+0x23e>
ffffffffc0203f58:	01b05663          	blez	s11,ffffffffc0203f64 <vprintfmt+0x34e>
ffffffffc0203f5c:	02d00693          	li	a3,45
ffffffffc0203f60:	f6d798e3          	bne	a5,a3,ffffffffc0203ed0 <vprintfmt+0x2ba>
ffffffffc0203f64:	00002417          	auipc	s0,0x2
ffffffffc0203f68:	e4d40413          	addi	s0,s0,-435 # ffffffffc0205db1 <error_string+0xd1>
ffffffffc0203f6c:	02800513          	li	a0,40
ffffffffc0203f70:	02800793          	li	a5,40
ffffffffc0203f74:	b585                	j	ffffffffc0203dd4 <vprintfmt+0x1be>

ffffffffc0203f76 <printfmt>:
ffffffffc0203f76:	715d                	addi	sp,sp,-80
ffffffffc0203f78:	02810313          	addi	t1,sp,40
ffffffffc0203f7c:	f436                	sd	a3,40(sp)
ffffffffc0203f7e:	869a                	mv	a3,t1
ffffffffc0203f80:	ec06                	sd	ra,24(sp)
ffffffffc0203f82:	f83a                	sd	a4,48(sp)
ffffffffc0203f84:	fc3e                	sd	a5,56(sp)
ffffffffc0203f86:	e0c2                	sd	a6,64(sp)
ffffffffc0203f88:	e4c6                	sd	a7,72(sp)
ffffffffc0203f8a:	e41a                	sd	t1,8(sp)
ffffffffc0203f8c:	c8bff0ef          	jal	ra,ffffffffc0203c16 <vprintfmt>
ffffffffc0203f90:	60e2                	ld	ra,24(sp)
ffffffffc0203f92:	6161                	addi	sp,sp,80
ffffffffc0203f94:	8082                	ret

ffffffffc0203f96 <readline>:
ffffffffc0203f96:	715d                	addi	sp,sp,-80
ffffffffc0203f98:	e486                	sd	ra,72(sp)
ffffffffc0203f9a:	e0a2                	sd	s0,64(sp)
ffffffffc0203f9c:	fc26                	sd	s1,56(sp)
ffffffffc0203f9e:	f84a                	sd	s2,48(sp)
ffffffffc0203fa0:	f44e                	sd	s3,40(sp)
ffffffffc0203fa2:	f052                	sd	s4,32(sp)
ffffffffc0203fa4:	ec56                	sd	s5,24(sp)
ffffffffc0203fa6:	e85a                	sd	s6,16(sp)
ffffffffc0203fa8:	e45e                	sd	s7,8(sp)
ffffffffc0203faa:	c901                	beqz	a0,ffffffffc0203fba <readline+0x24>
ffffffffc0203fac:	85aa                	mv	a1,a0
ffffffffc0203fae:	00002517          	auipc	a0,0x2
ffffffffc0203fb2:	e1a50513          	addi	a0,a0,-486 # ffffffffc0205dc8 <error_string+0xe8>
ffffffffc0203fb6:	908fc0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc0203fba:	4481                	li	s1,0
ffffffffc0203fbc:	497d                	li	s2,31
ffffffffc0203fbe:	49a1                	li	s3,8
ffffffffc0203fc0:	4aa9                	li	s5,10
ffffffffc0203fc2:	4b35                	li	s6,13
ffffffffc0203fc4:	0000cb97          	auipc	s7,0xc
ffffffffc0203fc8:	07cb8b93          	addi	s7,s7,124 # ffffffffc0210040 <buf>
ffffffffc0203fcc:	3fe00a13          	li	s4,1022
ffffffffc0203fd0:	924fc0ef          	jal	ra,ffffffffc02000f4 <getchar>
ffffffffc0203fd4:	842a                	mv	s0,a0
ffffffffc0203fd6:	00054b63          	bltz	a0,ffffffffc0203fec <readline+0x56>
ffffffffc0203fda:	00a95b63          	bge	s2,a0,ffffffffc0203ff0 <readline+0x5a>
ffffffffc0203fde:	029a5463          	bge	s4,s1,ffffffffc0204006 <readline+0x70>
ffffffffc0203fe2:	912fc0ef          	jal	ra,ffffffffc02000f4 <getchar>
ffffffffc0203fe6:	842a                	mv	s0,a0
ffffffffc0203fe8:	fe0559e3          	bgez	a0,ffffffffc0203fda <readline+0x44>
ffffffffc0203fec:	4501                	li	a0,0
ffffffffc0203fee:	a099                	j	ffffffffc0204034 <readline+0x9e>
ffffffffc0203ff0:	03341463          	bne	s0,s3,ffffffffc0204018 <readline+0x82>
ffffffffc0203ff4:	e8b9                	bnez	s1,ffffffffc020404a <readline+0xb4>
ffffffffc0203ff6:	8fefc0ef          	jal	ra,ffffffffc02000f4 <getchar>
ffffffffc0203ffa:	842a                	mv	s0,a0
ffffffffc0203ffc:	fe0548e3          	bltz	a0,ffffffffc0203fec <readline+0x56>
ffffffffc0204000:	fea958e3          	bge	s2,a0,ffffffffc0203ff0 <readline+0x5a>
ffffffffc0204004:	4481                	li	s1,0
ffffffffc0204006:	8522                	mv	a0,s0
ffffffffc0204008:	8eafc0ef          	jal	ra,ffffffffc02000f2 <cputchar>
ffffffffc020400c:	009b87b3          	add	a5,s7,s1
ffffffffc0204010:	00878023          	sb	s0,0(a5)
ffffffffc0204014:	2485                	addiw	s1,s1,1
ffffffffc0204016:	bf6d                	j	ffffffffc0203fd0 <readline+0x3a>
ffffffffc0204018:	01540463          	beq	s0,s5,ffffffffc0204020 <readline+0x8a>
ffffffffc020401c:	fb641ae3          	bne	s0,s6,ffffffffc0203fd0 <readline+0x3a>
ffffffffc0204020:	8522                	mv	a0,s0
ffffffffc0204022:	8d0fc0ef          	jal	ra,ffffffffc02000f2 <cputchar>
ffffffffc0204026:	0000c517          	auipc	a0,0xc
ffffffffc020402a:	01a50513          	addi	a0,a0,26 # ffffffffc0210040 <buf>
ffffffffc020402e:	94aa                	add	s1,s1,a0
ffffffffc0204030:	00048023          	sb	zero,0(s1)
ffffffffc0204034:	60a6                	ld	ra,72(sp)
ffffffffc0204036:	6406                	ld	s0,64(sp)
ffffffffc0204038:	74e2                	ld	s1,56(sp)
ffffffffc020403a:	7942                	ld	s2,48(sp)
ffffffffc020403c:	79a2                	ld	s3,40(sp)
ffffffffc020403e:	7a02                	ld	s4,32(sp)
ffffffffc0204040:	6ae2                	ld	s5,24(sp)
ffffffffc0204042:	6b42                	ld	s6,16(sp)
ffffffffc0204044:	6ba2                	ld	s7,8(sp)
ffffffffc0204046:	6161                	addi	sp,sp,80
ffffffffc0204048:	8082                	ret
ffffffffc020404a:	4521                	li	a0,8
ffffffffc020404c:	8a6fc0ef          	jal	ra,ffffffffc02000f2 <cputchar>
ffffffffc0204050:	34fd                	addiw	s1,s1,-1
ffffffffc0204052:	bfbd                	j	ffffffffc0203fd0 <readline+0x3a>
