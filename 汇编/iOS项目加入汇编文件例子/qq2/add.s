.text
.align 4

.globl _add

_add:
    sub    sp, sp, #0x10             ; =0x10
// 存储传入的参数到栈(冗余)
    str    w0, [sp, #0xc]
    str    w1, [sp, #0x8]
// 加载传入的参数
    ldr    w0, [sp, #0xc]
    ldr    w1, [sp, #0x8]
// 执行加法操作    
    add    w0, w0, w1
// 释放栈内存
    add    sp, sp, #0x10             ; =0x10
// return w0
    ret