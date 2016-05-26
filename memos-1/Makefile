all:
	as --32 memos1.s -o memos1.o
	ld -T  link.ld memos1.o -o memos1
	qemu-system-i386 memos1
	
clean:
	rm -f memos1 memos1.o boot
