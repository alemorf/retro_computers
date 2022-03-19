set pf=C:\Program Files

set include=%pf%\Microsoft Visual Studio 9.0\VC\include;%pf%\Microsoft SDKs\Windows\v5.0\Include;%pf%\Microsoft SDKs\Windows\v6.0A\Include
set lib=%pf%\Microsoft Visual Studio 9.0\VC\lib;%pf%\Microsoft SDKs\Windows\v5.0\Lib;%pf%\Microsoft SDKs\Windows\v6.0A\Lib
set path=%pf%\Microsoft Visual Studio 9.0\VC\bin;%pf%\Microsoft Visual Studio 9.0\Common7\IDE;%path%

cl /Gr /Ox LV_OUTF.C /link /SUBSYSTEM:CONSOLE /VERSION:4.0 WINMM.lib
