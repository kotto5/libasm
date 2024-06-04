TARGET = libasm.a
EXECUTABLE = main
ASM_EXT = s

C_SRCS := $(wildcard *.c)
ASM_SRCS := $(wildcard *.$(ASM_EXT))
SRCS = $(C_SRCS) $(ASM_SRCS)

C_OBJS := $(patsubst %.c, %.o, $(C_SRCS))
ASM_OBJS := $(patsubst %.$(ASM_EXT), %.o, $(ASM_SRCS))
OBJS = $(C_OBJS) $(ASM_OBJS)

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

$(TARGET): $(ASM_OBJS)
	$(ARC) $(ARCFLAGS) $@ $^

test: $(EXECUTABLE)

$(EXECUTABLE): $(TARGET) $(C_OBJS)
	$(LD) -o $@ $(STARTUP) $(C_OBJS) $(LDFLAGS) -L. -l:$(TARGET)

%.o: %.c
	$(CC) $(CFLAGS) -c $<

%.o: %.$(ASM_EXT)
	$(NASM) $(NASMFLAGS) $<

debug: $(OBJS)
	$(CC) $(CFLAGS) -o $(TARGET) -fsanitize=address $^
	

clean:
	rm -f $(TARGET) $(OBJS)

asm:
	objdump -d $(TARGET)

elf:
	readelf -a $(TARGET)

re: 
	make clean debug