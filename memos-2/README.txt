MEMOS-2	

Description:
The folder contains 6 files:

1) memos2.s —> contains the ASSEMBLY CODE for memos1. 

2) memos2.c —> the c code from which the ASSEMBLY code was generated

3) link.ld —> contains the linker file for memos2. This aligns all the data to 0x1000000 (1MB)

4) Makefile —> running the make file will run the kernel image on qemu

5) multiboot.h —>This file contains the header required for a system call in protected mode

6) c.img —> the virtual disk image on which the qemu runs and executed the binary file generated from MEMOS2.s. 

Note: I have written the code in C language for memory probing and displaying the text on screen. I then used the gcc -s command to compile and generate an equivalent Assembly code called memos2.s. On this file I added the GRUB headers (by manually copy pasting) and then directly make a binary file out of it. 
I have not linked the C code and the assembly code. They are two different files. 
The conversion can be performed using:
gcc -S -c memos2.c

Then run the make file to run the code. Command: make

Please Note: The Makefile has the address of the c.img in my directory. To run on any other image please change the location and the image name accordingly. 

If the disk hasn’t been mounted then call the 
make mount command from the terminal. Command: make mount
This will umount the disk first and then mount the c.img to loop1 looping device.


To see the output go to the following destination after typing the make command:

/root/vnc/opt/TigerVnc/bin
and type the following command:
./vncviewer <address generated by qemu after make>

The kernel image is stored in the partition called KTBFFH.

The logic and the program flow is clearly mentioned in the comments of the code —> memos2.c 
