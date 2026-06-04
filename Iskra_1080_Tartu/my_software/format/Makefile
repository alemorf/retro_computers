all: format.com

format.com:
	cp ~/bin/TASM85.TAB TASM85.TAB
	wine ~/bin/TASM.EXE -t85 -b format.asm format.com
	rm TASM85.TAB

.PHONY: clean
clean:
	rm -f format.lst format.com TASM85.TAB
