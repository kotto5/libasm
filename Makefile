TARGET = libasm.a
EXECUTABLE = main
ASM_EXT = s

C_SRCS := main.c
ASM_SRCS := $(wildcard *.$(ASM_EXT))
SRCS = $(C_SRCS) $(ASM_SRCS)

C_OBJS := $(patsubst %.c, %.o, $(C_SRCS))
ASM_OBJS := $(patsubst %.$(ASM_EXT), %.o, $(ASM_SRCS))

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
	$(CC) $(CFLAGS) -o $(C_SRCS) -L. -l$(TARGET)

# $(EXECUTABLE): $(TARGET) $(C_OBJS)
# 	$(LD) -o $@ $(STARTUP) $(C_OBJS) $(LDFLAGS) -L. -l:$(TARGET)

%.o: %.$(ASM_EXT)
	$(NASM) $(NASMFLAGS) $<

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
