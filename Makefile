AS=aarch64-linux-gnu-as
LD=aarch64-linux-gnu-ld
CC=aarch64-linux-gnu-gcc
OBJCOPY=aarch64-linux-gnu-objcopy
DD=dd


AS_SOURCES=reset.S monitor.S nsecure.S secure.S context_mgmt.S
AS_OBJS=$(subst .S,.o,$(AS_SOURCES))
LD_SCRIPT=main.ld.S

C_SOURCES=$(wildcard *.c)
C_OBJS=$(subst .c,.o,$(C_SOURCES))


ELF=test.elf
BIN=test.bin
FLASH=flash.bin

$(BIN): $(ELF)
	$(OBJCOPY) -O binary $< $@

$(ELF): $(AS_OBJS) $(C_OBJS)
	$(LD) -T $(LD_SCRIPT) $^ -o $@ -N

$(AS_OBJS):%.o:%.S
	$(CC) -o $@ -c $< -DDEBUG

$(C_OBJS):%.o:%.c
	$(CC) -o $@ -c $<


flash: $(BIN)
	rm -rf $(FLASH)
	dd if=/dev/zero of=$(FLASH) bs=16M count=1
	dd if=$< of=$(FLASH) conv=notrunc

run: flash
	qemu-system-aarch64 -machine virt,secure=on -cpu cortex-a53 -monitor stdio -bios flash.bin -m 1024

clean:
	rm -rf $(AS_OBJS) $(ELF) $(BIN) $(C_OBJS)

.PHONY: flash run clean
