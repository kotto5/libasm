TARGET_NAME = asm
TARGET = lib$(TARGET_NAME).a
EXECUTABLE = a.out
ASM_EXT = s

C_SRCS := main.c
ASM_SRCS := $(wildcard *.$(ASM_EXT))

C_OBJS := $(patsubst %.c, %.o, $(C_SRCS))
ASM_OBJS := $(patsubst %.$(ASM_EXT), objs/%.o, $(ASM_SRCS))

CC = gcc
CFLAGS = -Wall -g

NASM = nasm
NASMFLAGS = -f elf64

LD = ld
LDFLAGS = -L/usr/lib/x86_64-linux-gnu -lc -dynamic-linker /lib64/ld-linux-x86-64.so.2
STARTUP = /usr/lib/x86_64-linux-gnu/crt1.o /usr/lib/x86_64-linux-gnu/crti.o /usr/lib/x86_64-linux-gnu/crtn.o

ARC = ar
ARCFLAGS = rcs

.PHONY: all clean

all: $(TARGET)

$(TARGET): $(ASM_OBJS)
	$(ARC) $(ARCFLAGS) $@ $^

test: $(EXECUTABLE)

$(EXECUTABLE): $(C_SRCS) $(TARGET)
	$(CC) $(C_SRCS) -L. -l$(TARGET_NAME)

# $(EXECUTABLE): $(TARGET) $(C_OBJS)
# 	$(LD) -o $@ $(STARTUP) $(C_OBJS) $(LDFLAGS) -L. -l:$(TARGET)

objs/%.o: %.$(ASM_EXT)
	mkdir -p $(dir $@)
	$(NASM) $(NASMFLAGS) $< -o $@

%.o: %.c
	$(CC) $(CFLAGS) -c $<

clean:
	rm -f $(C_OBJS) $(ASM_OBJS)

fclean: clean
	rm -f $(TARGET) $(EXECUTABLE)

re: fclean all

asm:
	objdump -d $(TARGET)

elf:
	readelf -a $(TARGET)
