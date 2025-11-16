F=pcput

all: $F.com

clean:
	rm $F.com $F.lst TASM85.TAB

$F.com: $F.asm Makefile
	cp ~/bin/TASM85.TAB .
	wine ~/bin/TASM.EXE -85 -b $< $@
	rm TASM85.TAB
