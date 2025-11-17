F=ramtest

all: $F.com

clean:
	rm $F.com $F.lst TASM85.TAB

$F.com: $F.asm Makefile
	cp ~/bin/TASM80.TAB .
	wine ~/bin/TASM.EXE -80 -b $< $@
	rm TASM80.TAB
