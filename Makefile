ARCH := $(shell uname -m)

all:
	make -C src-$(ARCH)
