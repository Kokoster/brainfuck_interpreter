//
//  asm.s
//  BFinterpreter
//
//  Created by Ольга Диденко on 05.07.15.
//
//

.globl _eval

.data
arr: .space 30000, 0

.text

_eval:
    push rbp

    mov rbp, rsp

    push rbx
    push rcx
    push rdx

    sub rsp, 64
    sub rsp, 1600

    xor rbx, rbx

clean_array:
    cmp rbx, 30000
    je clear

    lea rcx, [rip + arr]
    add rcx, rbx
    mov [rcx], 0

    inc rbx

    jmp clean_array

clear:
    xor rbx, rbx

    lea rdx, [rip + arr]
//    mov rdx, qword ptr [arr]
//    inc [rdx]

    mov [rbp - 48], rcx
    mov [rbp - 56], rdx

    mov [rbp - 40], rdi

    push rdi
    call _strlen
    add rsp, 8

    mov [rbp - 32], rax
    xor rbx, rbx

    mov rcx, [rbp - 48]
    mov rdx, [rbp - 56]

    mov [rbp - 88], rbp
    sub [rbp - 88], 88

begin:
//  while not eof
    cmp rbx, [rbp - 32]
    je end

    mov rcx, [rbp - 40]
    add rcx, rbx

data_pointer_inc:
//  code[i] == '>'
    cmp byte ptr [rcx], 62
    jne data_pointer_dec

//    inc rdx
    add rdx, 8

    jmp end_section

data_pointer_dec:
//  code[i] == '<'
    cmp byte ptr [rcx], 60
    jne data_inc

//    dec rdx
    sub rdx, 8

    jmp end_section

data_inc:
//  code[i] == '+'
    cmp byte ptr [rcx], 43
    jne data_dec

    inc [rdx]

    jmp end_section

data_dec:
//  code[i] == '-'
    cmp byte ptr [rcx], 45
    jne data_output

    dec [rdx]

    jmp end_section

data_output:
//  code[i] == '.'
    cmp byte ptr[rcx], 46
    jne input_data

    mov [rbp - 48], rcx
    mov [rbp - 56], rdx

    mov rdi, [rdx]
    push rdi
    call _putchar
    add rsp, 8

    mov rcx, [rbp - 48]
    mov rdx, [rbp - 56]

    jmp end_section

input_data:
//  code[i] == ','
    cmp byte ptr [rcx], 44
    jne begin_loop

    mov [rbp - 48], rcx
    mov [rbp - 56], rdx

    push rdi
    call _getchar
    add rsp, 8
    mov [rdx], rax

    mov rcx, [rbp - 48]
    mov rdx, [rbp - 56]

    jmp end_section

begin_loop:
//  code[i] == '['
    cmp byte ptr [rcx], 91
    jne end_loop

    sub [rbp - 88], 8
    mov [rbp - 72], rax
    mov rax, [rbp - 88]
    mov [rax], rbx

    mov rax, [rbp - 72]

    jmp end_section

end_loop:
//  code[i] == ']'
    cmp byte ptr  [rcx], 93
    jne end_section

    mov [rbp - 72], rax

    mov rax, rbp
    sub rax, 88

    cmp [rbp - 88], rax
    je end_section

    cmp [rdx], 0

    jne return_to_begin

    add [rbp - 88], 8
    mov rax, [rbp - 72]
    jmp end_section

return_to_begin:
    mov rax, [rax]
    mov rbx, [rax]
    mov rax, [rbp - 72]

    jmp end_section

end_section:

    inc rbx

    jmp begin

end:

    add rsp, 1600
    add rsp, 64
    pop rdx
    pop rcx
    pop rbx

    pop rbp

    ret
