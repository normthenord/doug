sudo apt install nasm
nasm -felf64 beep.asm && ld beep.o && ./a.out
