# amd64 build

caos_amd64_asm_src := $(shell find src/caos/arch/amd64 -name *.asm)
caos_amd64_asm_obj := $(patsubst src/caos/arch/amd64/%.asm, build/amd64/%.o, $(caos_amd64_asm_src))

$(caos_amd64_asm_obj): build/amd64/%.o : src/caos/arch/amd64/%.asm
	mkdir -p $(dir $@) && \
	nasm -f elf64 $(patsubst build/amd64/%.o, src/caos/arch/amd64/%.asm, $@) -o $@

.PHONY: build-amd64
build-amd64: $(caos_amd64_asm_obj)
	mkdir -p publish/amd64 && \
	ld.lld -m elf_x86_64 -n -o publish/amd64/sandwich.krnl64 -T config/amd64/linker.ld $(caos_amd64_asm_obj) && \
	cp publish/amd64/sandwich.krnl64 config/amd64/boot/sandwich.krnl64 && \
	grub-mkrescue /usr/lib/grub/i386-pc -o publish/amd64/iso/cannibal-amd64.iso config/amd64


# ia32 build

caos_ia32_asm_src := $(shell find src/caos/arch/ia32 -name *.asm)
caos_ia32_asm_obj := $(patsubst src/caos/arch/ia32/%.asm, build/ia32/%.o, $(caos_ia32_asm_src))

$(caos_ia32_asm_obj): build/ia32/%.o : src/caos/arch/ia32/%.asm
	mkdir -p $(dir $@) && \
	nasm -f elf32 $(patsubst build/ia32/%.o, src/caos/arch/ia32/%.asm, $@) -o $@

.PHONY: build-ia32
build-ia32: $(caos_ia32_asm_obj)
	mkdir -p publish/ia32 && \
	ld.lld -m elf_i386 -n -o publish/ia32/sandwich.krnl32 -T config/ia32/linker.ld $(caos_ia32_asm_obj) && \
	cp publish/ia32/sandwich.krnl32 config/ia32/boot/sandwich.krnl32 && \
	grub-mkrescue /usr/lib/grub/i386-pc -o publish/ia32/iso/cannibal-ia32.iso config/ia32