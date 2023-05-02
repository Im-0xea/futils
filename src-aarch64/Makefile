AS := as
LD := ld

ASFLAGS := -g
LDFLAGS := -static

.SUFFIXES: .s .o

OBJS = cat.o
PRGS = cat

.s.o:
	$(AS) $(ASFLAGS) -o $@ $<
.o:
	$(LD) $(LDFLAGS) -o $@ $<

all: $(OBJS) $(PRGS)

clean:
	rm -f *.o $(PRGS) $(OBJS)
