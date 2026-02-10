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
    mov $10, %edi
    call SetTargetFPS

    jmp .loop_check
.loop:
    // main loop
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

    .set KEY_S $83
    .set KEY_W $87
    mov $KEY_S, rdi
    call IsKeyDown
    test al,al
    jz .not_down
    //is down
    
.not_down:

    mov (y), %esi
    inc %esi
    mov %esi, (y)

    call EndDrawing

.loop_check:
    // end main loop
    call WindowShouldClose
    cmp $0, %al
    je .loop
.done:

    // exit
    mov $0, %rax
    leave
