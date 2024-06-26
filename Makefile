# 目录变量
TOP_DIR:= $(patsubst %/,%,$(dir $(abspath $(firstword $(MAKEFILE_LIST)))))
CUR_DIR:= $(CURDIR)

# 交叉编译工具链
CROSS_COMPILE:= riscv64-linux-gnu-
CC:= $(CROSS_COMPILE)gcc
CFLAGS:= 

# QEMU 选项
QEMU:= qemu-system-riscv64
CPUS:= 1
MEM:= 64M
QEMU_FLAGS:= -bios none -smp $(CPUS) -nographic -M virt -m $(MEM)

# 源文件和目标文件
SRC_DIR:= $(TOP_DIR)/src
BUILD_DIR:= $(TOP_DIR)/build

SRC:= $(shell find $(SRC_DIR) -name "*.c")
SRC+= $(shell find $(SRC_DIR) -name "*.s")

OBJS:= $(patsubst $(SRC_DIR)/%.c, $(BUILD_DIR)/%.o, $(SRC))
OBJS:= $(patsubst $(SRC_DIR)/%.s, $(BUILD_DIR)/%.o, $(OBJS))

# 项目名
NAME:= uniproton.elf

################################################################

$(NAME): $(OBJS)
	@mkdir -p $(dir $@)
	$(CC) --freestanding --entry=_start -Ttext=0x80000000 $^ -o $@

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.s
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

qemu: $(NAME)
	$(QEMU) $(QEMU_FLAGS) -kernel $(NAME)

debug:
	@echo $(OBJS)

clean:
	rm -rf $(BUILD_DIR)	$(NAME)

.PHONY: qemu clean debug
