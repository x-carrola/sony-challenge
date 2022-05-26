CC ?= gcc
CFLAGS := ${CFLAGS}
CFLAGS += -ansi -std=gnu99
MKDIR ?= mkdir -p

# DIRECTORIES
OUT_DIR := out
BUILD_DIR := build
INC_DIR := include
SRC_DIR := src

# FILES
EXEC := $(OUT_DIR)/output
SRCS := $(wildcard $(SRC_DIR)/*.c)
OBJS := $(patsubst $(SRC_DIR)/%.c,$(BUILD_DIR)/%.o,$(SRCS))

# TARGET RULES

all : $(EXEC)

# Linker rule
# gcc $(CFLAGS) -I$(INC_DIR) -o output main.o ...
$(EXEC) : $(OBJS)
	rm -f $@
	$(MKDIR) $(@D)
	$(CC) $(CFLAGS) $^ -o $@

# Objects rule
# gcc $(CFLAGS) -c main.c -o main.o
$(BUILD_DIR)/%.o : $(SRC_DIR)/%.c
	rm -f $@
	$(MKDIR) $(@D)
	$(CC) $(CFLAGS) -I$(INC_DIR) -o $@ -c $<

# Cleaning rule
clean:
	rm -rf $(BUILD_DIR) $(OUT_DIR)
