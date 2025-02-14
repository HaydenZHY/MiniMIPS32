include mips_sc/src/Makefile.testcase

.PHONY: run clean

ifndef INCLUDE_DIR
INCLUDE_DIR := ./temu/include
endif
ifndef SRC_DIR
SRC_DIR := ./temu/src
endif
ifndef BUILD_DIR
BUILD_DIR := build/
endif
DEBUG := false

# Compilation flags
CC := gcc
CFLAGS := -I$(INCLUDE_DIR) -I$(INCLUDE_DIR)/cpu -I$(INCLUDE_DIR)/memory -I$(INCLUDE_DIR)/monitor -Wall -Werror -fcommon
LDFLAGS := -lreadline

# Files to be compiled
SRCS := $(wildcard $(SRC_DIR)/*.c) $(wildcard $(SRC_DIR)/memory/*.c) $(wildcard $(SRC_DIR)/cpu/*.c) $(wildcard $(SRC_DIR)/monitor/*.c)

TEMU_TARGET := temu

ifeq ($(DEBUG), true)
CFLAGS += -g
endif

export	INCLUDE_DIR
export	SRC_DIR
export	BUILD_DIR

# ********************
# Rules of Compilation
# ********************

$(BUILD_DIR)$(TEMU_TARGET): 
	$(MAKE) -C mips_sc
	@mkdir -p $(BUILD_DIR)
	$(CC) $(CFLAGS) -o $@ $(SRCS) $(LDFLAGS)

run: $(BUILD_DIR)$(TEMU_TARGET)
	@./$(BUILD_DIR)$(TEMU_TARGET) $(USER_PROGRAM)

clean-temu:
	rm -f -r $(BUILD_DIR)

clean:
	rm -f -r $(BUILD_DIR)
	rm -f -r ./mips_sc/build
	rm -f log.txt
	rm -f *.bin
	rm -f ./golden_trace.txt
