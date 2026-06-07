all: std.com

std.com: *.c *.h Makefile
	~/bin/c8080 -OCPM -DARCH_CPM -ostd.com *.c

.PHONY: clean
clean:
	rm -f std.lst std.com

