all: micro80.bin

micro80.bin: Makefile micro80.c micro80.h save.c Makefile
	./asm80 --cmm --lst=micro80.lst micro80.c save.c

format:
	clang-format -i micro80.c micro80.h

clean:
	rm micro80.bin
