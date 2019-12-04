global    _start

section .data
	text2:  db        "Doug is a cock"      ; note the newline at the end
	msglen2 equ $ - text2
	text1:  db        "How many times is Doug a cock? "
	msglen1 equ $ - text1
	inputBuff equ 100
	newline: db 10

section .bss
	count resb 8
	digitSpace resb 100
	digitSpacePos resb 8
	
	totalNums resb 1

section .text
_start:
	call _printText1
	call _getNumber
	call _fixBytes
	call _printText2
	

end:      mov       rax, 60                 ; system call for exit
          xor       rdi, rdi                ; exit code 0
          syscall                           ; invoke operating system to exit

_printText1:
	
	mov rax, 1
	mov rdi, 1
	mov rsi, text1
	mov rdx, msglen1
	syscall
	ret

_getNumber:
	mov rax, 0
	mov rdi, 0
	mov rsi, count
	mov rdx, inputBuff
	syscall
	ret




_printText2:
	xor r10, r10
	mov r10, 1
Loop1:
	cmp r10, [count]
		jg end
	
	mov rax, 1
	mov rdi, 1
	mov rsi, text2
	mov rdx, msglen2
	syscall

	mov rax, r10
	call _printRAX

	inc r10
	jmp Loop1

	ret


_fixBytes:
	mov rbx, 10
	mov rax, 0
	mov rcx, 0
	xor rsi, rsi
	mov rsi, count
	mov r10, 0
	mov r9, 0


.1:
	mov al, [rsi]
	cmp rax, 10
		je .2
	sub al, 48
	push rax
	inc rsi
	inc byte[totalNums]
	jmp .1

	

.2:							
	mov r10b, byte [totalNums]
	mov r8, 0
	pop rax
.3:	cmp r8, r9
		jl .4

	add rcx, rax
	dec byte [totalNums]
	mov r10b, byte [totalNums]
	inc r9
	cmp r10, 0
		je .5
	jmp .2
	

.4:
	mul rbx
	inc r8
	jmp .3

.5:	
	mov [count], rcx
	mov rax, [count]
	call _printRAX
	ret
	
_printRAX:
    mov rcx, digitSpace
    mov rbx, 10
    mov [rcx], rbx
    inc rcx
    mov [digitSpacePos], rcx
 
_printRAXLoop:
    mov rdx, 0
    mov rbx, 10
    div rbx
    push rax
    add rdx, 48
 
    mov rcx, [digitSpacePos]
    mov [rcx], dl
    inc rcx
    mov [digitSpacePos], rcx
   
    pop rax
    cmp rax, 0
    jne _printRAXLoop
 
_printRAXLoop2:
    mov rcx, [digitSpacePos]
 
    mov rax, 1
    mov rdi, 1
    mov rsi, rcx
    mov rdx, 1
    syscall
 
    mov rcx, [digitSpacePos]
    dec rcx
    mov [digitSpacePos], rcx
 
    cmp rcx, digitSpace
    jge _printRAXLoop2
 
    ret
