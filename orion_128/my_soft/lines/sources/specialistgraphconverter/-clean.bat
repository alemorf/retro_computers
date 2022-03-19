del /q debug\*.*
del /q release\*.*
del /q /s ipch\*.*

attrib -h -r -s *.suo

del *.tmp
del *.ncb
del *.suo
del *.sdf
del *.xml
del *.opt
del *.plg
del *.vcproj.*.user