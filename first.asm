section .bss
buffer  resb 256

	;        10 == \n, 0 == null terminator
	section  .data
	msg      db "Hello, from DeezNuts", 10, 0
	error_no_args db "No args provided. Need atleast 1 arg to function.", 10, 0
	len_err_msg equ $ - error_no_args
	deezNuts db "Hello, from DeezNuts", 10, 0
	msg_no_deez_nuts db "No deez nuts here. Go away.", 10
	len_no_deez_nuts equ $ - msg_no_deez_nuts
	msg_if_deez_nuts db "DEEZ NUTS", 10
	len_if_deez_nuts equ $ - msg_if_deez_nuts
	len      equ $ - msg

	section .text
	global  _start

_start:
	mov rax, [rsp]
	cmp rax, 2
	jb  no_args
	mov rsi, [rsp + 16]
	mov rdi, buffer
	xor rcx, rcx

.copy_loop:
	mov  al, [rsi + rcx]
	test al, al
	je   .append_newline_and_print
	mov  [rdi + rcx], al
	inc  rcx
	jmp  .copy_loop

.append_newline_and_print:
	mov byte [rdi + rcx], 10; append 10th ascii code to end of string
	inc rcx; now count that newline which was just appended

	mov rax, 1
	mov rdi, 1
	mov rsi, buffer
	mov rdx, rcx
	syscall

	mov  rdi, buffer; now comparing rdi with rsi (deezNuts)
	mov  rsi, deezNuts
	call compare_strings

	test rax, rax
	jz   if_deez_nuts
	jmp  not_deez_nuts

if_deez_nuts:
	mov rax, 1
	mov rdi, 1
	mov rsi, msg_if_deez_nuts
	mov rdx, len_if_deez_nuts
	syscall

	mov rax, 60
	mov rdi, 0
	syscall

not_deez_nuts:
	mov rax, 1
	mov rdi, 1
	mov rsi, msg_no_deez_nuts
	mov rdx, len_no_deez_nuts
	syscall

	mov rax, 60
	mov rdi, 127; non-zero exit code
	syscall

compare_strings:
.compare_loop:
	mov  al, [rdi]
	mov  bl, [rsi]
	cmp  al, bl
	jne  .diff_found
	test al, al
	je   .equal
	inc  rdi
	inc  rsi
	jmp  .compare_loop

.diff_found:
	movzx eax, al
	movzx ebx, bl
	sub   eax, ebx
	ret

.equal:
	xor eax, ebx
	ret

no_args:
	mov rax, 1
	mov rdi, 1
	mov rsi, error_no_args
	mov rdx, len_err_msg
	syscall

	mov rax, 60; exit syscall
	mov rdi, 69; non zero exit
	syscall
