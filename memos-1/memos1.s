.globl _start
.code16

.text

_start:
		movw $0x09000, %ax				#ss=0x9000
		movw %ax, %ss
		xorw %sp, %sp				
		movw $0x0, %ax					#ds=0x0000	
		movw %ax, %ds
		movw %ax, %es					#es=0x0000
		mov $len, %dh					#storing length of msg
		leaw (msg), %si	
		call print						#printing the msg

memory_probe:	
		leaw (memory), %di				#pointer to store the fetched data from BIOS call
		xorl %ebx, %ebx					#clearing ebx
		movl $0x534D4150, %edx			#storing the magic number to %edx
		movl $0xE820, %eax				#BIOS call parameter
		movl $0x14, %ecx				#number of bytes to fetch on BIOS call
		int  $0x15
		call check_func					#call check_function to check if call successful
loop:
		leaw (count),%si				#fetch the address of counter
		movw (%si), %ax
		add  $0x01, %al					#count the number of calls made to INT0x15
		mov  %al, (%si)					
		addw $0x14,%di					#increment the pointer for the next 20bytes of data
		movl $0xE820, %eax				#call the BIOS call again with parameters
		movl $0x14, %ecx
		int  $0x15
		call check_func					#check if call successful
		andl %ebx, %ebx   				#Checking for final function call to int 0x15
		jz calc_mem						#if last call successful then calculate memory
		jmp loop						#or call again

calc_mem:
		leaw (count),%si				#fetchign the address of count
		movb (%si), %ch					#ch will store the number of int15 was called
		xorl %edx,%edx					#clearing edx reg
		xorl %ebx,%ebx					#clearing edx reg
		leaw (memory),%si				#getting the address where memory is stored from int0x15
		addw $16, %si
next_call:
		movb $0x04, %cl					#4 bytes of data to be fteched from mem
		mov (%si), %al 					#al will hold the "Region Type"
		cmp $0x01, %al					#comparing to see if mem is type 1
		jnz skip_add					#of not type1 do not fetch data
		subw $0x5, %si					#fetching the first byte of the free mem
	
next_digit:
		mov (%si), %ah					#mov the value at si to ah
		shll $8, %edx					#shift left the current %edx
		add %ah, %dl					#add the newly fetched byte to edx
		subw $0x01, %si					#sub pointer to next byte
		sub $0x01,%cl		
		jnz next_digit		
		addl %edx,%ebx					#add the newly ftched number to the sum in %ebx
		add $0x1D, %si					#add 29D to fetch the mem type of the next call
		jmp skip_add2
skip_add:
		addw $0x14, %si					#if not type 1 fetch the next type 
skip_add2:
		subb $0x01, %ch					#decrement counter
		jnz next_call					#fetch and get the next counter
		shrl $0x14, %ebx				#Divide the sum by (1024*1024) to convert to MB
		mov %bl,%al						#mov the total mem to al for printing
		mov $0x02, %cl
		call hextoascii
		mov $len1, %dh					#to print the 'MB' string
		leaw (mb), %si					#fetch the address of the 'MB' string 
		call print						#print it
		call reset_cursor
		jmp stop
		
hextoascii:
		push %ax				 		#save the current value
		shr $4, %al				 		#rotate to get the higher byte
		and  %al,0x0f			
		cmp $0x0A,%al					
		jge less		
		addb $48,%al			 		#convert to ascii equivalent	
back:	mov $0x01, %dh			 		#counter for print function
		call print1
		pop %ax					 		#retrieve the number back
		shl $4, %al				 		#get the next 4 bytes
		sub $0x01,%cl
		jnz hextoascii					#to print all the bytes jump back
		ret
		
less:
		add $55, %al
		jmp back
		

check_func:						  		#checks whether the call to INT15 has been successful
		jc fail 				  		#if carry is set OS call fails		
		movl $0x534D4150, %edx	  		#put the magic number back in %edx
		cmp %eax,%edx			  		#check if %eax has the magic number
		jne fail
		ret						
		
print:	
		lodsb					  		#fetch the string to print
print1:	
		mov $0x00, %bh            		#page number
		mov $0x0F, %bl            		#Colour Code
		mov $0x0E, %ah            		#interrupt type
		INT $0x10
		sub $0x01, %dh			  		#counter the next half byte
		jnz print
		ret

reset_cursor:
		mov $0x03,%ah
		xor %bh,%bh						#get the cursor value in dx
		int $0x10
		add $0x01, %dh					#update the cursor value to the next row
		xor %dl,%dl						#update the column to row
		xor %bh,%bh						#page number
		mov $0x02,%ah			
		int $0x10						#updating the cursor value
		ret
		
stop:
fail:	hlt
		
msg: .ascii "Welcome to MEMOS-1. System Memory is: 0x"
len = .-msg
mb: .ascii "MB"
len1 = .-mb
count: .byte 0x00						#stores the number of calls to int15
memory: .byte 0x00						#stores the fetched data on int15

	# This is going to be in our MBR for Bochs, so we need a valid signature
		.org 0x1FE

		.byte 0x55
		.byte 0xAA
		
