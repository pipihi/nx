	.section	__TEXT,__text,regular,pure_instructions
	.build_version ios, 12, 0
	.globl	_add                    ; -- Begin function add
	.p2align	2
_add:                                   ; @add
	.cfi_startproc
; %bb.0:
	// 申请内存
	sub	sp, sp, #64             ; =64
	// 入栈
	stp	x29, x30, [sp, #48]     ; 8-byte Folded Spill
	add	x29, sp, #48            ; =48
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16

	// 初始化a和b
	orr	w8, wzr, #0x3
	orr	w9, wzr, #0x7

	stur	w0, [x29, #-4]
	stur	x1, [x29, #-16]
	stur	w9, [x29, #-20]
	str	w8, [sp, #24]
	ldur	w8, [x29, #-20]
	ldr	w9, [sp, #24]

	// 执行相加
	add	w8, w8, w9

	str	w8, [sp, #20]
	ldr	w8, [sp, #20]

	// 传递可变参数                                    
	; implicit-def: %x1
	mov	x1, x8
	mov	x10, sp
	str	x1, [x10]

	// 传递字符串地址
	adrp	x0, l_.str@PAGE
	add	x0, x0, l_.str@PAGEOFF

	// 调用printf
	bl	_printf

	ldr	w8, [sp, #20]
	str	w0, [sp, #16]           ; 4-byte Folded Spill
	mov	x0, x8
	// 出栈 X30/LR保存返回值信息，X29/FP保存栈帧地址(栈底指针)
	ldp	x29, x30, [sp, #48]     ; 8-byte Folded Reload
	// 释放内存
	add	sp, sp, #64             ; =64
	// 默认返回 返回值保存到LR/x3
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
