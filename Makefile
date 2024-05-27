TARGET = main
OBJS = $(C_OBJS) $(ASM_OBJS)
SRCS = $(C_SRCS) $(ASM_SRCS)

C_SRCS := $(wildcard *.c)
ASM_SRCS := $(wildcard *.asm)

C_OBJS := $(patsubst %.c, %.o, $(C_SRCS))
ASM_OBJS := $(patsubst %.asm, %.o, $(ASM_SRCS))

CC = gcc
CFLAGS = -Wall -Wextra -Werror -g

.PHONY: all clean

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $@ $^

%.o: %.c
	$(CC) $(CFLAGS) -c $<

%.o: %.asm
	nasm -f elf64 $<

clean:
	rm -f $(TARGET) $(OBJS)
