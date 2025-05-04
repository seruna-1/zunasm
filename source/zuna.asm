format ELF64

public zunasm_start

public zunasm_test

public zunasm_object_get_type

syscall_mmap = 9
memory_page_size = 4096
PROT_READ = 0x1
PROT_WRITE = 0x2
MAP_PRIVATE = 0x02
MAP_ANONYMOUS = 0x20
object_type_referencer = 1
object_type_bytes = 2
object_type_names = 3

section '.bss'
	primordial_page dq 0 ; Adress of the first byte of the metadata of the last block
	primordial_object dq 0 ; Adress of the second byte of the first block of the first object

section '.text' executable

zunasm_start:
	; Allocate primordial_page
	mov rax, syscall_mmap
	xor rdi, rdi ; Let kernel choose location of mapping
	mov rsi, memory_page_size
	mov rdx, 0x3 ; PROT_READ and PROT_WRITE
	mov r10, 0x22 ; MAP_PRIVATE and MAP_ANONYMOUS
	mov r8, -1 ; No fd
	xor r9, r9 ; No offset
	syscall
	mov [primordial_page], rax

	mov rbx, rax ; Use rbx to set page metadata
	add rax, 16 ; After the metadata, adress of first block

	mov qword [rbx], rax ; 8 bytes for adress of the last block in the page. In this case, is also the primordial block
	add rbx, 8
	mov qword [rbx], 0 ; 8 bytes for adress of next page, currently 0

	; Metadata of primordial block
	mov qword [rax], 0 ; 8 bytes for adress first block. 0 because this is the first block

	add rax, 8; Metadata of primordial object : 64 bytes from here
	mov [primordial_object], rax
	mov rbx, rax
	add rax, 56
	mov [rax],
	add

	mov qword [rax], object_type_referencer ; Type of primordial object
	add rax, 8 ; Metadata of block
	mov qword [rax], 0 ; Adress of next metadata block. 0 because there is none

	ret

zunasm_object_travel:
; Gets the adress of the first block of an object based on its name path
; rdi = name path
; rsi = length of path
	mov rax, [primordial_object]
	jmp .consume_name



	.consume_name:
	; Consumes a name in current object


	.consume_name_character:
	; Consumes characters of name path


		; Check if all were consumed
		sub rsi, 1
		cmp rsi, 0
		je .exit
		jmp .consume

	.exit:
		ret

zunasm_find_metadata_sequence:
; Returns the adress of the first metadata block referent to a data sequence
; rdi : object adress
; rsi : number of the data sequence

	mov rbx, 1 ; Number of the current sequence

	; Check if is of type names. If so, skip the first byte
	sub rdi, 8 ; Block metadata
	cmp [rdi], object_type_names
	je .names
	mov rax, 40 ; Number of usable bytes to reference data blocks
	add rdi, 16

	.names:
		mov rax, 48 ; Number of usable bytes to reference data blocks
		add rdi, 8

	add rdi, 8 ; skip number of free slots in block

	.forward:
		add rdi, 16 ; Go to next adress (skip number of free slots in block)
		sub rax, 16 ; Consumed
		cmp rax, 0 ; All bytes checked in this metadata block, go to next
		je .go_to_next_metadata_block
		jmp .forward

	.go_to_next_metadata_block:
		mov rcx, rdi
		mov rdi, [rcx]
		mov rax, 48
		jmp .forward

	ret

zunasm_check_reference_by_adress:
; Check if an object contain a reference to a specific adress
; rdi : referencer
; rsi : adress to check



	ret

zunasm_object_reference_by_adress:
; Create a reference from one object to another
; rdi : adress of referencer
; rsi : adress of referenced



	ret

zunasm_object_create:
; Create an empty object. For internal usage only
; rdi : adress of parent
; rsi : type of new object

	; Go past the last block
	mov rbx, [primordial_page]
	mov rax, [rbx] ; Adress of the last block
	add rax, 64 ; Overcome the last block; adress of new block

	cmp rsi, object_type_names
	je .name

	; Not name :
	mov [rax], 0
	add rax, 8 ; Overcome block metadata
	mov [rax], rsi ; Type

	.name:
		mov [rax], rdi ; Adress of parent
		add rax, 8 ; Overcome block metadata

	; Next metadata block adress = 0
	mov rbx, rax
	add rbx, 56
	mov [rbx], 0

	; Create reference to the new object in parent
	mov rsi, rax ; rsi : adress of referenced
	push rax ; keep adress of new object to be returned later
	call zunasm_object_reference_by_adress

	pop rax ; Adress of new object
	ret

zunasm_object_bytes_create:
; Create an object of type bytes
; rdi : adress of parent
; rsi : inital value
	push rsi
	mov rsi, object_type_names
	call zunasm_object_create

	mov rdi, rax ; Adress of created object
	pop rsi ; inital value
	call zunasm_object_bytes_insert
	ret

zunasm_test:
	mov rbx, [primordial_page]
	add rbx, 8
	mov rax, rbx
	ret
