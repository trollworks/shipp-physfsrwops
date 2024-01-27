BUILDDIR = $(PWD)/__build__
PREFIX := /usr/local
DESTDIR := $(PREFIX)

CC := gcc
CFLAGS := -O2 -g -I$(PWD)/include -I$(PREFIX)/include -I$(PREFIX)/include/SDL2

AR := ar
ARFLAGS := rcs

SOURCES = $(shell find src -name "*.c")
OBJECTS = $(patsubst src/%.c, $(BUILDDIR)/%.o, $(SOURCES))
DEPS    = $(patsubst %.o, %.d, $(OBJECTS))
TARGET  = $(BUILDDIR)/libtrollworks-sdk-backend-sdl.a

.PHONY: all
all: $(TARGET)

.PHONY: install
install:
	@mkdir -p $(DESTDIR)/include
	@cp -R $(PWD)/include $(DESTDIR)
	@cp $(TARGET) $(DESTDIR)/lib

.PHONY: clean
clean:
	@rm -vrf $(BUILDDIR)

$(TARGET): $(OBJECTS)
	@mkdir -p $(@D)
	@echo "  AR      $(patsubst $(BUILDDIR)/%, %, $@)"
	@$(AR) $(ARFLAGS) $@ $^

$(BUILDDIR)/%.o: src/%.c
	@mkdir -p $(@D)
	@echo "  CC      $(patsubst $(BUILDDIR)/%, %, $@)"
	@$(CC) $(CFLAGS) -MMD -c -o $@ $<

-include $(DEPS)
