// .macro fnStart
//     push rbp
//     mov rbp, rsp
// .endm
/*
    func(rdi,rsi,rdx,rcx,r8,r9)
    push rest onto stack in reverse order (push last param first)

    callee-saved:
    rbx,rbp,r12-r15

    caller-saved:
    r10,r11,any used in params
*/

.section .data
msg:
    .asciz "Hello World\n"
title:
    .asciz "Hello World from asm"
fmt:
    .asciz "%zu\n"
y:
    .zero 4

.section .text
    .globl main
    .extern printf
    // .extern InitWindow,CloseWIndow,WindowShouldClose,BeginDrawing,EndDrawing,ClearBackground

main:
    // save stack
    push %rbp
    mov %rsp, %rbp
    // inner code

    mov $msg, %rdi
    call printf

    //void InitWindow(int width, int height, const char *title)
    mov $400, %edi
    mov %edi, %esi
    mov $title, %rdx
    call InitWindow

    //void SetTargetFPS(int fps)
    mov $60, %edi
    call SetTargetFPS

    jmp .loop_check
.loop:
    // main loop
    // update
    .set KEY_S, 83
    .set KEY_W, 87
    mov $KEY_S, %edi
    call IsKeyDown
    test %al,%al
    jz .w_not_down
    //is down
    mov (y), %esi
    inc %esi
    mov %esi, (y)
.w_not_down:

    mov $KEY_W, %edi
    call IsKeyDown
    test %al,%al
    jz .s_not_down
    //is down
    mov (y), %esi
    dec %esi
    mov %esi, (y)
.s_not_down:

    //clamp
    //if y<0 then y=0
    //loading y -> esi
    mov (y), %esi
    // 0>esi
    cmp $0, %esi
    jg .y_not_zero
    //then y=0
    xor %esi,%esi
    mov %esi, (y)
.y_not_zero:
    //if 350>y then y=350
    mov (y), %esi
    cmp $350, %esi
    jl .y_l_350
    mov $350, %esi
    mov %esi, (y)
.y_l_350:

    //draw
    call BeginDrawing

    mov $0xff562700,%edi
    call ClearBackground

    // draw paddle
    mov $0, %edi
    mov (y), %esi
    mov $10, %edx
    mov $50, %ecx
    mov $0xffffffff,%r8
    call DrawRectangle




    call EndDrawing

.loop_check:
    // end main loop
    call WindowShouldClose
    test %al, %al
    //if 0, shouldn't close, then loop
    jz .loop
.done:
    // mov %rsp, %rbp

    // exit
    mov $0, %rax
    // mov %rbp, %rsp
    pop %rbp
    ret
