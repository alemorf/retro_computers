Программа для работы с образами флоппи и жестких дисков.

Список файлов                  : img L my.img
Извлечь файл                   : img X my.img file.ext
Добавить файл                  : img A my.img file.ext
Добавить с удалением исходного : img M my.img file.ext
Удалить файл из образа         : img D my.img file.ext

Программа не умеет работать с каталогами, за исключением извлечения файлов из
образа. Т.е. нельзя добавить каталог, нельзя добавить файл в каталог, однако
можно извлечь файл из каталога.

Чтобы использовать программу совместно с Far, нужно скопировать её в каталог
Far-а и добавить в файл ...Far\Plugins\MultiArc\Formats\custom.ini следующий
текст:

[IMG]
Extension=img
List="img l"
Format0="nnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn"
Format1="aaaa zzzzzzzzzz yyyy-tt-dd hh-mm-ss"
Extract=img x %%A %%f
ExtractWithoutPath=img x %%A %%f
Delete=img d %%A %%f
Add=img a %%A %%f
Move=img m %%A %%f
