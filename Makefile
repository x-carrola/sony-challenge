CC ?= gcc
CFLAGS := ${CFLAGS}
CFLAGS += -ansi -std=c99
MKDIR ?= mkdir -p

# DIRECTORIES
OUT_DIR := build
INC_DIR := include
SRC_DIR := src

# FILES
EXEC := $(OUT_DIR)/output
SRCS := $(wildcard $(SRC_DIR)/*.c)
OBJS := $(patsubst $(SRC_DIR)/%.c,$(OUT_DIR)/%.o,$(SRCS))

# TARGET RULES

all : $(EXEC)

# Linker rule
# gcc $(CFLAGS) -I$(INC_DIR) -o output main.o ...
$(EXEC) : $(OBJS)
	$(CC) $(CFLAGS) $^ -o $@

# Objects rule
# gcc $(CFLAGS) -c main.c -o main.o
$(OUT_DIR)/%.o : $(SRC_DIR)/%.c
	$(MKDIR) $(@D)
	$(CC) $(CFLAGS) -I$(INC_DIR) -o $@ -c $<

# Cleaning rule
clean:
	rm -rf $(OUT_DIR)
