all:
	as --32 memos2.s -o memos2.o
	ld -T  link.ld memos2.o -o memos2
	losetup -o 32256 /dev/loop1 /root/memos-2/c.img	
	cp memos2 /mnt/C/boot/
	losetup -d /dev/loop1
	qemu-system-i386 /root/memos-2/c.img
	
mount:
	umount /dev/loop0
	mount /root/memos-2/c.img /mnt/C -text2 -o loop,offset=32256
	
clean:
	rm memos2.o memos2
	rm /mnt/C/boot/memos2