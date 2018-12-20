参考https://www.cnblogs.com/ylhwx/p/7834969.html
参考https://www.cnblogs.com/huhu0013/p/4103024.html
参考https://www.cnblogs.com/linganxiong/p/9119686.html
Xcode项目添加汇编参考https://blog.csdn.net/sysprogram/article/details/71687333

### wzr零寄存器
零寄存器:XZR/WZR，写该寄存器会被忽略，读该寄存器会得到全0值。

### mov给寄存器赋值

mov	w8, #0 ; w8 = 0
mov	x0, x8 ; x0 = x8

### orr位或

orr R0,R1,R2; R0=R1 | R2
orr R0,R1,#0xFF ;R0=R1 | 0xFF

### add

ADD R0,R1,R2 ; R0=R1+R2
ADD R0,R1,#3 ; R0=R1+3

### str,store

STR(Store) 用于把一个寄存器的值存入外部存储空间,是LDR的逆操作.
STR R0,[R1] ; 把R0的值,存入到R1对应地址空间上(*R1 = R0)
STR R0,=0x30008000 ;把R0中值存入到地址0x30008000 *(0x30008000) = r0
STR X0, [SP, #0x8] ;X0寄存器的数据传送到SP+0x8地址值指向的存储空间, *(sp+0x08) = x0

### ldr,load double world to register

LDR R0,[R1]; R1的值当成地址,再从这个地址装入数据到R0 (R0=*R1)
LDR R1,=0x30008000 ; 把地址0x30008000的值装入到R1中

###


```
	.section	__TEXT,__text,regular,pure_instructions
	.build_version ios, 12, 0
	.globl	_main		; -- Begin function main .globl标识，可被外部当函数调用
	.p2align	2
_main:					; @main 
	.cfi_startproc ; 运行时函数，进程结束时调用
; %bb.0:

	sub	sp, sp, #32		; =32 内存是从高地址分配的开始开始分配 sp = sp - 32

	.cfi_def_cfa_offset 32
	
    mov	w8, #0 ; w8 = 0  mov赋值 #0为立即数,不能超过512 w8位32位寄存器
	
    orr	w9, wzr, #0x2 ; w9 = wzr | 0x0002;orr为逻辑或  ORR{条件}{S} 目的寄存器，操作数 1，操作数 2
    orr	w10, wzr, #0x1 ; w10 = wzr | 0x0001; wzr始终为0
	
    str	wzr, [sp, #28] ; *(sp+0x28) = wzr;STR{条件}  源寄存器，<存储器地址>
	str	w0, [sp, #24] ; *(sp+0x24) = w0
	str	x1, [sp, #16] ; *(sp + 16) = x1
	str	w10, [sp, #12] ; *(sp + 12) = x1
	str	w9, [sp, #8] ; *(sp + 8) = x1
	ldr	w9, [sp, #12] ; w9 = *(sp + 12)
	ldr	w10, [sp, #8] ; w10 = *(sp + 8)
	add	w9, w9, w10 ; w9 = w9 + w10

	str	w9, [sp, #4] ; *(sp + 4) = x1
	mov	x0, x8 ; x0 = x8
	add	sp, sp, #32    ; sp = sp + 0x32         ; =32
	ret
	.cfi_endproc // 运行时函数 进程结束调用
                                        ; -- End function
	.section	__DATA,__objc_imageinfo,regular,no_dead_strip
L_OBJC_IMAGE_INFO:
	.long	0
	.long	64


.subsections_via_symbols
```

Objective-C
```
#include <stdio.h>
int main(int argc, char *argv[]) {
	int a = 7;
	int b = 3;
	int c = a + b;
	printf("c=%d", c);
	return 0;
}

```

ASM
```
	.section	__TEXT,__text,regular,pure_instructions
	.build_version ios, 12, 0
	.globl	_main                   ; -- Begin function main
	.p2align	2
_main:                                  ; @main
	.cfi_startproc
; %bb.0:
    // 分配栈内存
	sub	sp, sp, #64             ; =64
    // 入栈，占用16字节，剩48字节 
	stp	x29, x30, [sp, #48]     ; 8-byte Folded Spill
	
    add	x29, sp, #48            ; =48
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16

	orr	w8, wzr, #0x3 // b
	orr	w9, wzr, #0x7 // a

	stur	wzr, [x29, #-4]
	stur	w0, [x29, #-8]
	stur	x1, [x29, #-16]
	
    stur	w9, [x29, #-20]
	// *（sp + 0x24） = w8
    str	w8, [sp, #24]
	
    ldur	w8, [x29, #-20]

    //  w
	ldr	w9, [sp, #24]
	
    add	w8, w8, w9

	str	w8, [sp, #20]
	ldr	w8, [sp, #20]

    // 将c放入内存中,可变参数都是通过栈传递
    ; implicit-def: %x1
	mov	x1, x8
	mov	x10, sp
	str	x1, [x10]

    ; x0 = &l_.str.PAGE + l_.str@PAGEOFF
	adrp	x0, l_.str@PAGE
	add	x0, x0, l_.str@PAGEOFF

	bl	_printf

	mov	w8, #0
	str	w0, [sp, #16]           ; 4-byte Folded Spill
	mov	x0, x8
    // stack pop
	ldp	x29, x30, [sp, #48]     ; 8-byte Folded Reload
	add	sp, sp, #64             ; =64
	ret
	.cfi_endproc
                                        ; -- End function
	.section	__TEXT,__cstring,cstring_literals
l_.str:                                 ; @.str
	.asciz	"c=%d"

	.section	__DATA,__objc_imageinfo,regular,no_dead_strip
L_OBJC_IMAGE_INFO:
	.long	0
	.long	64


.subsections_via_symbols

```



//
//  main.m
//  qq
//
//  Created by Beauty-jishu on 2018/11/23.
//  Copyright © 2018年 Beauty-jishu. All rights reserved.
//

//#import <Foundation/Foundation.h>

#import <stdio.h>

int add(int a, int b) {
    int c = a + b;
    return a;
}

qq2`add:
    // 获取栈内存
    0x102756804 <+0>:  sub    sp, sp, #0x10             ; =0x10 
    // 存储传入的参数到栈
    0x102756808 <+4>:  str    w0, [sp, #0xc]
    0x10275680c <+8>:  str    w1, [sp, #0x8]
    // 加载传入的参数
->  0x102756810 <+12>: ldr    w0, [sp, #0xc]
    0x102756814 <+16>: ldr    w1, [sp, #0x8]
    0x102756818 <+20>: add    w0, w0, w1
    // 释放栈内存
    0x10275681c <+24>: add    sp, sp, #0x10             ; =0x10 
    // return w0
    0x102756820 <+28>: ret    


qq2`add:
 分配16字节内存
0x1024c6838 <+0>:  sub    sp, sp, #0x10             ; =0x10
 12存储参数w0 8存参数w1
0x1024c683c <+4>:  str    w0, [sp, #0xc]
0x1024c6840 <+8>:  str    w1, [sp, #0x8]

 又从栈里面把参数加载参数处理（这不是冗余吗？）
->  0x1024c6844 <+12>: ldr    w0, [sp, #0xc]
0x1024c6848 <+16>: ldr    w1, [sp, #0x8]

 执行相加计算
0x1024c684c <+20>: add    w0, w0, w1


0x1024c6850 <+24>: str    w0, [sp, #0x4]

0x1024c6854 <+28>: ldr    w0, [sp, #0xc]

 释放栈内存
0x1024c6858 <+32>: add    sp, sp, #0x10             ; =0x10

 返回，返回值存到了那里？
0x1024c685c <+36>: ret


int main(int argc, const char * argv[]) {
    int c = add(1, 2);
    printf("c=%d", c);
    //    @autoreleasepool {
    // insert code here...
    //        NSString * a = @"Hello, World!";
    //        NSString * b = @"Hello, World!";
    //        NSString * c = a;
    //        NSLog(@"%d", [c isEqualToString:b]);
    //    }
    return 0;
}

qq2`main:
0x104e6a824 <+0>:  sub    sp, sp, #0x30             ; =0x30

0x104e6a828 <+4>:  stp    x29, x30, [sp, #0x20]

0x104e6a82c <+8>:  add    x29, sp, #0x20            ; =0x20

// 局部变量初始化
0x104e6a830 <+12>: orr    w8, wzr, #0x1
0x104e6a834 <+16>: orr    w9, wzr, #0x2

0x104e6a838 <+20>: stur   wzr, [x29, #-0x4]
0x104e6a83c <+24>: stur   w0, [x29, #-0x8]
0x104e6a840 <+28>: str    x1, [sp, #0x10]

// 给add函数传参
0x104e6a844 <+32>: mov    x0, x8
0x104e6a848 <+36>: mov    x1, x9
// 执行add函数
0x104e6a84c <+40>: bl     0x104e6a7fc               ; add at main.m:13

// 存储返回值到栈中
0x104e6a850 <+44>: str    w0, [sp, #0xc]
// 加载返回值到w8/x8
0x104e6a854 <+48>: ldr    w8, [sp, #0xc]

// 通过栈传递c到printf
0x104e6a858 <+52>: mov    x30, x8
0x104e6a85c <+56>: mov    x10, sp
0x104e6a860 <+60>: str    x30, [x10]

// 传递第一个参数
0x104e6a864 <+64>: adrp   x0, 1
0x104e6a868 <+68>: add    x0, x0, #0x67c            ; =0x67c
0x104e6a86c <+72>: bl     0x104e6ab9c               ; symbol stub for: printf

0x104e6a870 <+76>: mov    w8, #0x0
0x104e6a874 <+80>: str    w0, [sp, #0x8]
0x104e6a878 <+84>: mov    x0, x8

0x104e6a87c <+88>: ldp    x29, x30, [sp, #0x20]

0x104e6a880 <+92>: add    sp, sp, #0x30             ; =0x30
0x104e6a884 <+96>: ret
