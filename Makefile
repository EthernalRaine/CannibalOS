caos_amd64_asm_src := $(shell find src/caos/arch/amd64 -name *.asm)
caos_amd64_asm_obj := $(patsubst src/caos/arch/amd64/%.asm, build/amd64/%.o, $(caos_amd64_asm_src))

$(caos_amd64_asm_obj): build/amd64/%.o : src/caos/arch/amd64/%.asm
	mkdir -p $(dir $@) && \
	nasm -f elf64 $(patsubst build/amd64/%.o, src/caos/arch/amd64/%.asm, $@) -o $@

.PHONY: build-amd64
build-amd64: $(caos_amd64_asm_obj)
	mkdir -p publish/amd64 && \
	x86_64-elf-ld -n -o publish/amd64/sandwich.krnl -T config/amd64/linker.ld $(caos_amd64_asm_obj) && \
	cp publish/amd64/sandwich.krnl config/amd64/boot/sandwich.krnl && \
	grub-mkrescue /usr/lib/grub/i386-pc -o publish/amd64/iso/cannibal.iso config/amd64