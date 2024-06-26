
qemu: rtos.elf
	qemu-system-riscv64 -bios none -smp 1 -nographic -M virt -m 64M -kernel rtos.elf

rtos.elf: boot.o
	riscv64-unknown-elf-ld boot.o --entry=_start -Ttext=0x80000000 -o rtos.elf

boot.o: boot.s
	riscv64-unknown-elf-gcc -c boot.s -o boot.o

clean:
	rm -rf *.o *.elf
