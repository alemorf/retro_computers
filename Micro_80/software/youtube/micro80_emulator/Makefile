all: micro80bios.js micro80font.js

micro80bios.js: micro80.bin Makefile
	echo "const bios = [" >micro80bios.js
	xxd -i micro80.bin | grep , >>micro80bios.js
	echo "];" >>micro80bios.js

micro80font.js: font.bin Makefile
	echo "const font = [" >micro80font.js
	xxd -i font.bin | grep , >>micro80font.js
	echo "];" >>micro80font.js
