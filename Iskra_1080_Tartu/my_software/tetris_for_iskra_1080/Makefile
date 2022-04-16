all: tetris.lvt

tetris.lvt: tetris.asm bios.inc text.inc fn.inc graph.inc intro.inc playfieldgraph.inc rand.inc tetris.inc unmlz.inc graph/font.inc graph/igrab.inc graph/level1.inc graph/level2.inc graph/level3.inc graph/level4.inc graph/level5.inc graph/level6.inc graph/logo.inc graph/plane.inc
	wine bin/pdp11asm tetris.asm

clean:
	rm -f tetris.lvt tetris.lst
