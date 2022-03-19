del /q debug\*.*
del /q release\*.*

attrib -h -r -s *.suo

del *.tmp
del *.ncb
del *.suo
del *.sdf
del *.xml
del *.opt
del *.plg
del *.vcproj.*.user