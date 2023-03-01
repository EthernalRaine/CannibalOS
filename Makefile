# build ldr

.PHONY: ldr
ldr:
	nasm src/ldr/bootloader.asm -o publish/ldr/caosldr