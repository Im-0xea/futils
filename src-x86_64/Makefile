AS := as
LD := ld

ASFLAGS := -O0 -g
LDFLAGS := -static

.SUFFIXES: .s .o

OBJS = cat.o rm.o rmdir.o mkdir.o
PRGS = cat rm rmdir mkdir

.s.o:
	$(AS) $(ASFLAGS) -o $@ $<
.o:
	$(LD) $(LDFLAGS) -o $@ $<

all: $(OBJS) $(PRGS)

clean:
	rm -f *.o $(PRGS) $(OBJS)
