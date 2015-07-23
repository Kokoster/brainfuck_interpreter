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
brackets_array: .space 131072, 0
error_message: .asciz "error: exceeded array bounds"

.text

_eval:
    push rbp

    mov rbp, rsp

    push rbx
    push rcx
    push rdx

    sub rsp, 64 + 131072

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
    je end_cleaning

    lea rcx, [rip + brackets_array]
    mov rdx, rbx
    imul rdx, rdx, 2
    add rcx, rdx

    mov [rcx], 0

    inc rbx

    jmp clean_brackets_array

end_cleaning:

    xor rbx, rbx

    mov [rbp - 40], rdi // [rbp - 40] eval string

    push rdi
    call _strlen
    add rsp, 8

    mov [rbp - 32], rax // [rpb - 32] – eval string length
    xor rbx, rbx // rbx - current eval string index, bx?

    lea rdx, [rip + memory_array]
    mov [rbp - 80], rdx
    xor rdx, rdx

    mov dword ptr [rbp - 88], 0 // brackets array index
    mov dword ptr [rbp - 84], 0

begin:
//  while not eof
    cmp rbx, [rbp - 32] // eval string length
    je end

    mov rcx, [rbp - 40] // eval string
    add rcx, rbx // rcx - current eval index (IP)

//  code[i] == '>'
    cmp byte ptr [rcx], 62 // '>'
    je data_pointer_inc

//  code[i] == '<'
    cmp byte ptr [rcx], 60
    je data_pointer_dec

//  code[i] == '+'
    cmp byte ptr [rcx], 43
    je data_inc

//  code[i] == '-'
    cmp byte ptr [rcx], 45
    je data_dec

//  code[i] == '.'
    cmp byte ptr[rcx], 46
    je data_output

//  code[i] == ','
    cmp byte ptr [rcx], 44
    je data_input

//  code[i] == '['
    cmp byte ptr [rcx], 91
    je begin_loop

//  code[i] == ']'
    cmp byte ptr  [rcx], 93
    je end_loop

data_pointer_inc:
//    inc rdx
    inc rdx// rdx - current memory index

    cmp rdx, 30000
    jge print_error_message

    jmp end_section

data_pointer_dec:
//    dec rdx
    dec rdx

    cmp rdx, 0
    jl print_error_message

    jmp end_section

print_error_message:
    lea rdi, [rip + error_message]

    mov [rbp - 48], rcx
    mov [rbp - 56], rdx
    sub rsp, 8

    call _printf

    add rsp, 8
    mov rcx, [rbp - 48]
    mov rdx, [rbp - 56]

    jmp exit

data_inc:
    mov [rbp - 72], rcx
    xor rcx, rcx
    mov rcx, [rbp - 80]
    add rcx, rdx
    inc [rcx]

    mov rcx, [rbp - 72]

    jmp end_section

data_dec:
    mov [rbp - 72], rcx
    xor rcx, rcx
    mov rcx, [rbp - 80]
    add rcx, rdx
    dec [rcx]

    mov rcx, [rbp - 72]

    jmp end_section

data_output:
    mov [rbp - 48], rcx
    mov [rbp - 56], rdx

    xor rcx, rcx
    mov rcx, [rbp - 80]
    add rcx, rdx

    mov rdi, [rcx]
    sub rsp, 8
//    push rdi // push [rdx] ?
//    sub rsp, 4
//    push qword ptr [rdx] // так падает
    call _putchar
    add rsp, 8

    mov rcx, [rbp - 48]
    mov rdx, [rbp - 56]

    jmp end_section

data_input:
    mov [rbp - 48], rcx
    mov [rbp - 56], rdx

    call _getchar

    xor rcx, rcx
    mov rcx, [rbp - 80]
    add rcx, rdx

    mov [rcx], rax

    mov rcx, [rbp - 48]
    mov rdx, [rbp - 56]

    jmp end_section

begin_loop:
    mov [rbp - 72], rcx
    mov [rbp - 64], rdx

    lea rax, [rip + brackets_array]
    xor rcx, rcx
    mov rcx, [rbp - 88]
    imul rcx, rcx, 2
    add rax, rcx
    mov [rax], word ptr rbx
    inc [rbp - 88]

    mov rcx, [rbp - 72]
    mov rdx, [rbp - 64]

    jmp end_section

end_loop:
    cmp [rbp - 88], 0 // check excess closing brackets
    jle end_section

    mov [rbp - 64], rcx
    xor rcx, rcx
    mov rcx, qword ptr [rbp - 80]
    add rcx, rdx
    xor rax, rax
    mov al, [cl]

    cmp al, 0
    jne return_to_begin

    mov rcx, [rbp - 64]

    dec [rbp - 88]

    jmp end_section

return_to_begin:
//    mov [rbp - 64], rcx
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

exit:
    add rsp, 131072 +  64
    pop rdx
    pop rcx
    pop rbx

    pop rbp

    ret
