gas:
	gcc -nostdlib hello.s -o hello_gas

nasm:
	nasm -f elf64 hello.asm && ld hello.o -o hello_nasm

