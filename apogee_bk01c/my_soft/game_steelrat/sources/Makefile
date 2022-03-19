all: prepare build/steelrat.rka files

.PHONY: all prepare files clean realclean

prepare:
	mkdir -p build

build/steelrat.rka: build/steelrat.bin build/makerka
	./build/makerka 0 $@ $<

build/makerka: makerka.cpp fstools.cpp fstools.h
#	cppcheck -q --addon=misra --enable=all $^
	g++ -pedantic --std=c++17 $^ -o $@

build/steelrat.bin: steelrat.asm build/00.bin build/01.bin build/02.bin build/03.bin build/04.bin build/05.bin build/06.bin build/07.bin \
          build/08.bin build/09.bin build/10.bin build/11.bin build/12.bin build/13.bin build/14.bin
	@echo "    savebin \"../$@\", begin, $$ - begin" > $@.save.inc
	./bin/sjasmplus --lst=$@.lst $< $@.save.inc 1>&2

files:
	find . -type f >steelrat.files

clean: realclean files

realclean:
	rm -f build/*

build/makescenario: makescenario.cpp fstools.cpp fstools.h
#	cppcheck -q --addon=misra --enable=all $^
	g++ -pedantic --std=c++17 $^ -o $@

build/00.bin: scenario/00.txt build/makescenario

build/01.bin: scenario/01.txt build/makescenario

build/02.bin: scenario/02.txt build/makescenario

build/03.bin: scenario/03.txt build/makescenario

build/04.bin: scenario/04.txt build/makescenario

build/05.bin: scenario/05.txt build/makescenario

build/06.bin: scenario/06.txt build/makescenario

build/07.bin: scenario/07.txt build/makescenario

build/08.bin: scenario/08.txt build/makescenario

build/09.bin: scenario/09.txt build/makescenario

build/10.bin: scenario/10.txt build/makescenario

build/11.bin: scenario/11.txt build/makescenario

build/12.bin: scenario/12.txt build/makescenario

build/13.bin: scenario/13.txt build/makescenario

build/14.bin: scenario/14.txt build/makescenario

build/%.bin: scenario/%.txt
	./build/makescenario $@.tmp $<
	wine bin/megalz.exe $@.tmp $@
