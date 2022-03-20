b = build/

all: files $(b)cmm

files:
	@mkdir -p $(b)
	find . -type f -not -path "./$(b)*" >cmm.files

$(b)cmm: parse.cc main.cpp Parser.h Parser.ih ParserPreinclude.h Scannerbase.h Scanner.h Scanner.ih utf8tocp1251.cpp utf8tocp1251.h
	g++ -fconcepts -std=c++14 -g -o$(b)cmm main.cpp parse.cc lex.cc utf8tocp1251.cpp

parse.cc: cmm.l cmm.y
	flexc++ cmm.l
	bisonc++ cmm.y

clean:
	rm $(b)*
