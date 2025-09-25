all: micro80bios.js micro80font.js micro80cpm.js

micro80bios.js: micro80.bin Makefile
	echo "const bios = [" >micro80bios.js
	xxd -i micro80.bin | grep , >>micro80bios.js
	echo "];" >>micro80bios.js

micro80cpm.js: micro80cpm.bin Makefile
	echo "const cpmBios = [" >micro80cpm.js
	xxd -i micro80cpm.bin | grep , >>micro80cpm.js
	echo "];" >>micro80cpm.js

test.js: test.rk Makefile
	echo "const testApp = [" >test.js
	xxd -i test.rk | grep , >>test.js
	echo "];" >>test.js

micro80font.js: font.bin Makefile
	echo "const font = [" >micro80font.js
	xxd -i font.bin | grep , >>micro80font.js
	echo "];" >>micro80font.js
