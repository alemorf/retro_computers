b = build/

all: $(b)maketrd

$(b)maketrd: maketrd.cpp trdfile.h trdfile.cpp sclfile.h sclfile.cpp fstools.cpp fstools.h
	@mkdir -p $(b)
	g++ --std=gnu++17 -g trdfile.cpp maketrd.cpp sclfile.cpp fstools.cpp -o$@

clean:
	rm $(b)*
