//
//  asm.s
//  BFinterpreter
//
//  Created by Ольга Диденко on 05.07.15.
//
//

.globl _eval

.data
memory_array  : .space 30000, 0 // ??
//brackets_array: .space 65513107236, 0
brackets_array: .space 131072, 0

.text

_eval:
    push rbp

    mov rbp, rsp

    push rbx
    push rcx
    push rdx

    sub rsp, 64 + 131072
//    sub rsp, 131072 // ??

    xor rbx, rbx
    xor rcx, rcx

clean_memory_array:
    cmp rbx, 30000
    je clear

    lea rcx, [rip + memory_array]
    add rcx, rbx
    mov [rcx], 0

    inc rbx

    jmp clean_memory_array

clear:
    xor rbx, rbx
    xor rdx, rdx
    xor rcx, rcx

clean_brackets_array:
    cmp rbx, 32768
    je everything_is_clear

    lea rcx, [rip + brackets_array]
    mov rdx, rbx
    imul rdx, rdx, 2
    add rcx, rdx

    mov [rcx], 0

    inc rbx

    jmp clean_brackets_array

everything_is_clear:

    xor rbx, rbx

    lea rdx, [rip + memory_array]

//    mov [rbp - 48], rcx // ??
    mov [rbp - 56], rdx // [rbp - 56] memory array

    mov [rbp - 40], rdi // [rbp - 40] eval string

    push rdi
    call _strlen
    add rsp, 8

    mov [rbp - 32], rax // [rpb - 32] – eval string length
    xor rbx, rbx // rbx - current eval string index, bx?

//    mov rcx, [rbp - 48] // ??
    mov rdx, [rbp - 56]

//    mov [rbp - 88], rbp // [rbp - 88] current bracket ptr
//    sub [rbp - 88], 88
//    sub dword ptr [rbp - 88], 131072 // 3 op -> 1, index?

    mov dword ptr [rbp - 88], 0 // brackets array index
    mov dword ptr [rbp - 84], 0

begin:
//  while not eof
    cmp rbx, [rbp - 32] // eval string length
    je end

    mov rcx, [rbp - 40] // eval string
    add rcx, rbx // rcx - current eval index (IP)

data_pointer_inc:
//  code[i] == '>'
    cmp byte ptr [rcx], 62 // '>'
    jne data_pointer_dec

//    inc rdx
    add rdx, 8 // rdx - current memory index

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
    push rdi // push [rdx] ?
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

    push rdi // ??
    call _getchar
    add rsp, 8 // ??
    mov [rdx], rax

    mov rcx, [rbp - 48]
    mov rdx, [rbp - 56]

    jmp end_section

begin_loop:
//  code[i] == '['
    cmp byte ptr [rcx], 91
    jne end_loop

//    sub [rbp - 88], 8
//    mov [rbp - 72], rax
//    mov rax, [rbp - 88]
//    mov [rax], rbx

// ?? simplify
//    add [rbp - 88], 2 // inc brackets stack ptr
//    mov [rbp - 72], rax // rax - ??
//    mov rax, [rbp - 88]
//    mov [rax], rbx

    mov [rbp - 72], rcx
    mov [rbp - 64], rdx

    lea rax, [rip + brackets_array]
    xor rcx, rcx
    mov rcx, [rbp - 88]
    imul rcx, rcx, 2
    add rax, rcx
//    mov [rax], rbx
    mov [rax], word ptr rbx
    inc [rbp - 88]

    mov rcx, [rbp - 72]
    mov rdx, [rbp - 64]

//    mov rax, [rbp - 72] // ??

    jmp end_section

end_loop:
//  code[i] == ']'
    cmp byte ptr  [rcx], 93
    jne end_section

//    mov [rbp - 72], rax // ?
//
//    mov rax, rbp
////    sub rax, 88
////    sub rax, 131072
//    sub rax, 88 + 131072 // ?
//
//    cmp [rbp - 88], rax // check excess closing bracket
//    je end_section
//
//    mov rax, [rbp - 88]
//
//    cmp [rdx], 0
//
//    jne return_to_begin
//
//    sub [rbp - 88], 2
//    mov rax, [rbp - 72] // ?

    cmp [rbp - 88], 0 // check excess closing brackets
    jle end_section

    cmp [rdx], 0
    jne return_to_begin

    dec [rbp - 88]

    jmp end_section

return_to_begin:
//    mov [rbp - 64], rcx
//    mov rcx, [rax] // rax - current bracket ptr
//    xor rax, rax
//    mov al, cl //  ?? 1) two bytes! test first
//    mov rbx, rax // ? 2) mov bx, cx ?
//    mov rax, [rbp - 72] // ?
//    mov rcx, [rbp - 64]

    mov [rbp - 64], rcx
    mov [rbp - 72], rdx

    lea rax, [rip + brackets_array]
    xor rdx, rdx
    mov rdx, [rbp - 88]
    imul rdx, rdx, 2
    add rax, rdx
    sub rax, 2
    xor rcx, rcx
    mov rdx, [rax]
    mov cx, dx
    mov bx, cx

    mov rcx, [rbp - 64]
    mov rdx, [rbp - 72]

    jmp end_section

end_section:

    inc rbx

    jmp begin

end:

    add rsp, 131072 // ? 131072 + 64
    add rsp, 64
    pop rdx
    pop rcx
    pop rbx

    pop rbp

    ret
