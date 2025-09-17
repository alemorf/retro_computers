all: micro80.bin micro80a.bin micro80b.bin
	cp micro80.bin ~/a/work/micro80_emulator/
	cd ~/a/work/micro80_emulator && make

.PHONY: clean
clean:
	rm micro80.bin micro80.lst micro80.asm micro80.bin micro80a.bin 

micro80.bin: micro80.c Makefile
	./bin/c8080 -m micro80.c

micro80a.bin: micro80.bin Makefile
	dd if=micro80.bin of=tmp1.bin bs=1 count=1024 skip=0
	cat tmp1.bin tmp1.bin tmp1.bin tmp1.bin >micro80a.bin
	rm tmp1.bin

micro80b.bin: micro80.bin Makefile
	dd if=micro80.bin of=tmp2.bin bs=1 count=1024 skip=1024
	cat tmp2.bin tmp2.bin tmp2.bin tmp2.bin >micro80b.bin
	rm tmp2.bin

