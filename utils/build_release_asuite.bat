call ..\clean.bat
call .\Run-Dependend-rsvars-From-Path.bat L rsvars
msbuild /nologo /t:rebuild /verbosity:quiet /p:Platform=Win32 /p:config=Release ASuite.dproj