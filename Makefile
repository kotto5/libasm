TARGET = main

C_SRCS := $(wildcard *.c)
ASM_SRCS := $(wildcard *.asm)
SRCS = $(C_SRCS) $(ASM_SRCS)

C_OBJS := $(patsubst %.c, %.o, $(C_SRCS))
ASM_OBJS := $(patsubst %.asm, %.o, $(ASM_SRCS))
OBJS = $(C_OBJS) $(ASM_OBJS)

CC = gcc
CFLAGS = -Wall -Wextra -Werror -g

NASM = nasm
NASMFLAGS = -f elf64

LD = ld
LDFLAGS = -L/usr/lib/x86_64-linux-gnu -lc -dynamic-linker /lib64/ld-linux-x86-64.so.2
STARTUP = /usr/lib/x86_64-linux-gnu/crt1.o /usr/lib/x86_64-linux-gnu/crti.o /usr/lib/x86_64-linux-gnu/crtn.o


.PHONY: all clean

all: $(TARGET)

$(TARGET): $(OBJS)
	$(LD) -o $@ $^ $(STARTUP) $(LDFLAGS)

%.o: %.c
	$(CC) $(CFLAGS) -c $<

%.o: %.asm
	$(NASM) $(NASMFLAGS) $<

clean:
	rm -f $(TARGET) $(OBJS)
