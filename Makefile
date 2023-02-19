ASM = $(wildcard lib/*.s)
OBJ = $(patsubst %.s, %.o, $(ASM))

%.o: %.s
	as $< -o $@

all: $(OBJ)

clean:
	rm -f *.o
	rm -f $(PRG)
