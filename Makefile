AS := as
LD := ld
ARCH := $(shell uname -m)

all:
	make -C src-$(ARCH) LD="$(LD)" AS="$(AS)"
