TARGET_NAME = asm
TARGET = lib$(TARGET_NAME).a
EXECUTABLE = a.out
ASM_EXT = s

SRC_DIR = src
OBJ_DIR = obj
SRC_BONUS_DIR = src_bonus

SRCS = $(wildcard $(SRC_DIR)/*.s)
BONUS_SRCS = $(wildcard $(SRC_BONUS_DIR)/*.s)

C_SRCS := main.c
C_OBJS := $(patsubst %.c, %.o, $(C_SRCS))

vpath %.s $(SRC_DIR) $(SRC_BONUS_DIR)

OBJS = $(addprefix $(OBJ_DIR)/, $(notdir $(SRCS:.s=.o)))
OBJS_BONUS = $(addprefix $(OBJ_DIR)/, $(notdir $(BONUS_SRCS:.s=.o)))

CC = gcc
CFLAGS = -Wall -Wextra -Werror -g

NASM = nasm
NASMFLAGS = -f elf64

LD = ld
LDFLAGS = -L/usr/lib/x86_64-linux-gnu -lc -dynamic-linker /lib64/ld-linux-x86-64.so.2
STARTUP = /usr/lib/x86_64-linux-gnu/crt1.o /usr/lib/x86_64-linux-gnu/crti.o /usr/lib/x86_64-linux-gnu/crtn.o

ARC = ar
ARCFLAGS = rcs

.PHONY: all clean

all: $(TARGET)

$(TARGET): $(OBJS)
	$(ARC) $(ARCFLAGS) $@ $^

bonus: $(OBJS) $(OBJS_BONUS)
	$(ARC) $(ARCFLAGS) $(TARGET) $^

test: $(EXECUTABLE)

$(EXECUTABLE): $(C_SRCS) $(TARGET)
	$(CC) $(CFLAGS) $(C_SRCS) -L. -l$(TARGET_NAME)

# $(EXECUTABLE): $(TARGET) $(C_OBJS)
# 	$(LD) -o $@ $(STARTUP) $(C_OBJS) $(LDFLAGS) -L. -l:$(TARGET)

$(OBJ_DIR)/%.o: %.s
	@mkdir -p $(dir $@)
	$(NASM) $(NASMFLAGS) $< -o $@

%.o: %.c
	$(CC) $(CFLAGS) -c $<

clean:
	rm -f $(OBJS) $(OBJS_BONUS) $(C_OBJS)

fclean: clean
	rm -f $(TARGET) $(EXECUTABLE)

re: fclean all

asm:
	objdump -d $(TARGET)

elf:
	readelf -a $(TARGET)
