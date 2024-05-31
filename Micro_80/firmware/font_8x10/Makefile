all: font_8x10_k573rf4.bin Makefile

clean:
	rm -f font_8x10_k573rf4.bin convert

font_8x10_k573rf4.bin: convert font_8x10.bin Makefile
	./convert font_8x10_k573rf4.bin font_8x10.bin

convert: convert.c Makefile
	gcc -s -oconvert convert.c

format:
	clang-format -i convert.c