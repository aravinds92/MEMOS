	.file	"memos2.c"
	.comm	pos_x,4,4
	.comm	pos_y,4,4
	.section	.rodata
	.align 4
	.globl _start
	.type	main, @function
.LC0:
	.string	"Welcome to MEMOS-2: The System memory is: "
.LC1:
	.string	"MB"
	
.text	
_start:
        jmp main

        /* Multiboot header -- Safe to place this header in 1st page of memory for GRUB */
        .align 4
        .long 0x1BADB002 /* Multiboot magic number */
        .long 0x00000003 /* Align modules to 4KB, req. mem size */
                         /* See 'info multiboot' for further info */
        .long 0xE4524FFB /* Checksum */
           
first:
	pushl %ebx
	call main
	popl %ebx
	hlt
main:
	pushl	%ebp
	movl	%esp, %ebp
	andl	$-16, %esp
	pushl	%ebx
	subl	$348, %esp
	movl	$0, 324(%esp)
	movl	$0, 320(%esp)
	movl	8(%ebp), %eax
	movl	44(%eax), %eax
	movl	%eax, 312(%esp)
	movl	$0, 308(%esp)
	movl	$0, 304(%esp)
	movl	$.LC0, 300(%esp)
	movl	$.LC1, 296(%esp)
	movb	$15, 334(%esp)
	movb	$0, 333(%esp)
	movl	8(%ebp), %eax
	movl	48(%eax), %eax
	movl	%eax, 292(%esp)
	jmp	.L2
.L4:
	movl	292(%esp), %eax
	movl	20(%eax), %eax
	cmpl	$1, %eax
	jne	.L3
	movl	292(%esp), %eax
	movl	12(%eax), %eax
	movl	%eax, 308(%esp)
	movl	308(%esp), %eax
	addl	%eax, 304(%esp)
.L3:
	movl	292(%esp), %eax
	movl	(%eax), %edx
	movl	292(%esp), %eax
	leal	(%edx,%eax), %eax
	addl	$4, %eax
	movl	%eax, 292(%esp)
.L2:
	movl	8(%ebp), %eax
	movl	48(%eax), %edx
	movl	312(%esp), %eax
	leal	(%edx,%eax), %eax
	cmpl	292(%esp), %eax
	ja	.L4
	shrl	$20, 304(%esp)
	jmp	.L5
.L6:
	movl	324(%esp), %ebx
	movl	304(%esp), %ecx
	movl	$-858993459, %edx
	movl	%ecx, %eax
	mull	%edx
	shrl	$3, %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	addl	%eax, %eax
	movl	%ecx, %edx
	subl	%eax, %edx
	movl	%edx, %eax
	movl	%eax, 36(%esp,%ebx,4)
	movl	304(%esp), %eax
	movl	%eax, 28(%esp)
	movl	$-858993459, %edx
	movl	28(%esp), %eax
	mull	%edx
	movl	%edx, %eax
	shrl	$3, %eax
	movl	%eax, 304(%esp)
	addl	$1, 324(%esp)
.L5:
	cmpl	$0, 304(%esp)
	jne	.L6
	movl	$0, pos_y
	jmp	.L7
.L10:
	movl	$0, pos_x
	jmp	.L8
.L9:
	movzbl	333(%esp), %edx
	movzbl	334(%esp), %eax
	movl	%edx, 8(%esp)
	movl	%eax, 4(%esp)
	movl	$0, (%esp)
	call	WriteCharacter
	movl	pos_x, %eax
	addl	$2, %eax
	movl	%eax, pos_x
.L8:
	movl	pos_x, %eax
	cmpl	$79, %eax
	jle	.L9
	movl	pos_y, %eax
	addl	$1, %eax
	movl	%eax, pos_y
.L7:
	movl	pos_y, %eax
	cmpl	$25, %eax
	jle	.L10
	movl	$0, pos_x
	movl	$0, pos_y
	movl	$0, 316(%esp)
	jmp	.L11
.L12:
	movzbl	333(%esp), %ecx
	movzbl	334(%esp), %edx
	movl	316(%esp), %eax
	addl	300(%esp), %eax
	movzbl	(%eax), %eax
	movzbl	%al, %eax
	movl	%ecx, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	WriteCharacter
	addl	$1, 316(%esp)
	movl	pos_x, %eax
	addl	$2, %eax
	movl	%eax, pos_x
.L11:
	movl	316(%esp), %eax
	addl	300(%esp), %eax
	movzbl	(%eax), %eax
	testb	%al, %al
	jne	.L12
	movl	324(%esp), %eax
	subl	$1, %eax
	movl	%eax, 328(%esp)
	jmp	.L13
.L14:
	movl	328(%esp), %eax
	movl	36(%esp,%eax,4), %eax
	addl	$48, %eax
	movb	%al, 335(%esp)
	movzbl	333(%esp), %ecx
	movzbl	334(%esp), %edx
	movzbl	335(%esp), %eax
	movzbl	%al, %eax
	movl	%ecx, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	WriteCharacter
	movl	pos_x, %eax
	addl	$2, %eax
	movl	%eax, pos_x
	subl	$1, 328(%esp)
.L13:
	cmpl	$0, 328(%esp)
	jns	.L14
	movl	$0, 316(%esp)
	jmp	.L15
.L16:
	movzbl	333(%esp), %ecx
	movzbl	334(%esp), %edx
	movl	316(%esp), %eax
	addl	296(%esp), %eax
	movzbl	(%eax), %eax
	movzbl	%al, %eax
	movl	%ecx, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	WriteCharacter
	addl	$1, 316(%esp)
	movl	pos_x, %eax
	addl	$2, %eax
	movl	%eax, pos_x
.L15:
	movl	316(%esp), %eax
	addl	296(%esp), %eax
	movzbl	(%eax), %eax
	testb	%al, %al
	jne	.L16
	addl	$348, %esp
	popl	%ebx
	movl	%ebp, %esp
	popl	%ebp
	ret
	.size	main, .-main
.globl WriteCharacter
	.type	WriteCharacter, @function
WriteCharacter:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$28, %esp
	movl	8(%ebp), %ecx
	movl	12(%ebp), %edx
	movl	16(%ebp), %eax
	movb	%cl, -20(%ebp)
	movb	%dl, -24(%ebp)
	movb	%al, -28(%ebp)
	movl	pos_x, %eax
	cmpl	$79, %eax
	jle	.L19
	movl	$0, pos_x
	movl	pos_y, %eax
	addl	$1, %eax
	movl	%eax, pos_y
.L19:
	movzbl	-28(%ebp), %eax
	sall	$4, %eax
	movzbl	-24(%ebp), %edx
	andl	$15, %edx
	orl	%edx, %eax
	movb	%al, -1(%ebp)
	movl	pos_y, %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	sall	$4, %eax
	movl	%eax, %edx
	movl	pos_x, %eax
	leal	(%edx,%eax), %eax
	addl	$753664, %eax
	movl	%eax, -8(%ebp)
	movl	-8(%ebp), %eax
	movzbl	-1(%ebp), %edx
	movb	%dl, (%eax)
	movl	-8(%ebp), %eax
	movzbl	-20(%ebp), %edx
	movb	%dl, (%eax)
	addl	$1, -8(%ebp)
	leave
	ret
	.size	WriteCharacter, .-WriteCharacter
	.ident	"GCC: (Ubuntu 4.4.3-4ubuntu5) 4.4.3"
	.section	.note.GNU-stack,"",@progbits
