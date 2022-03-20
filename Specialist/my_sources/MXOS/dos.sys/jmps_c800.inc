j_reboot3:	jmp	reboot3		; Запустить NC.COM
j_getch:	jmp	getch		; Ожидание ввода с клавиатуры
j_tapeRead:	jmp	tapeRead	; Чтение байта с магнитофона
j_printChar:	jmp	printChar	; Вывод символы на экран
j_tapeWrite:	jmp	tapeWrite	; Запись байта на магнитофон
		jmp	input		; Ввод строки с клавиатуры
		jmp	j_keyScan	; Получить код нажатой клавиши
		jmp	printHexByte	; Вывести 16-ричное число (байт)
j_printString:	jmp	printString1	; Вывести строку на экран
		jmp	j_keyScan	; Получить код нажатой клавиши
		jmp	getCursorPos	; Получить координаты курсора в HL (координаты в пикселях)
		jmp	setCursorPos	; Установить координаты курсора из HL (координаты в пикселях)
		jmp	tapeLoad	; Загрузить программу с магнитофона
		jmp	tapeSave	; Сохранить программу на магнитофон
		jmp	calcCS		; Расчет контрольной суммы
		jmp	printHexWord	; Вывести 16-ричное число (слово)
		jmp	getMemTop	; Получить объем доступной памяти
		jmp	setMemTop	; Установить объем доступной памяти
		jmp	printer		; Напечатать байт на принтере
		jmp	j_reboot3	; Запустить NC.COM
		jmp	reboot3		; Запустить NC.COM
		jmp	fileList	; Получить список файлов
		jmp	fileGetSetDrive	; Получить/установить активное устройство
		jmp	fileCreate	; Создать файл
		jmp	fileLoad	; Загрузить файл по адресу из заголовка этого файла
		jmp	fileDelete	; Удалить файл
		jmp	fileRename	; Переименовать файл
		jmp	fileLoadInfo	; Загрузить информацию о файле
		jmp	fileGetSetAddr	; Получить/установить адрес загрузки файла
		jmp	fileGetSetAttr	; Получить/установить атрибуты файла
		jmp	fileNamePrepare	; Преобразовать имя файла во внутренний формат
		jmp	fileExec	; Запустить файл
		jmp	installDriver	; Установить драйвер накопителя
j_diskDriver:	jmp	diskDriver	; Драйвер выбранного диска
		jmp	fileLoad2	; Загрузить файл по адресу DE