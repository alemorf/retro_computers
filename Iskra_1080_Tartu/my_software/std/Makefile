all: std.com
	cp std.com ../../my_extensions/extram_extrom/i1080_sources/files
	make -C ../../my_extensions/extram_extrom/i1080_sources

.PHONY: std.com
std.com: *.c *.h Makefile
	~/bin/c8080 -OCPM -DARCH_CPM -D__C8080_NO_HEAP -DARCH_CPM_BDOS -ostd.com *.c

.PHONY: clean
clean:
	rm -f std.lst std.com

