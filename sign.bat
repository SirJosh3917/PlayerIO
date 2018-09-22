:: TODO: don't hardcode all this stuff
::@echo off

echo. Preparing
setlocal enabledelayedexpansion

del /f /q PlayerIO*.nupkg
mkdir DotNetCore_Signed DotNet_Signed

set "snk=playerioclient-signed"
set "DLL=PlayerIOClient"
set "DLLTypes=1"
set "DLLTypes[0]=DotNetCore"
set "DLLTypes[1]=DotNet"

for /L %%I in (0, 1, %DLLTypes%) DO (
	echo. Disassembling !DLLTypes[%%I]!
	call :ildasm !DLLTypes[%%I]! %DLL%
)

for /L %%I in (0, 1, %DLLTypes%) DO (
	echo. Assembling !DLLTypes[%%I]!
	call :ilasm %snk% "!DLLTypes[%%I]!_Signed" %DLL%
)

echo. Getting assembly version

type DotNetCore_Signed\PlayerIOClient.il | find "  .ver 3:" > ver.txt
set /p version=<ver.txt
set version=!version:~7!
set version=!version::=.!

echo. Packing %version%

nuget pack -Version %version%

echo. Cleanup

for /L %%I in (0, 1, %DLLTypes%) DO (
	echo. Cleaning leftovers in !DLLTypes[%%I]!
	del /f /s /q "!DLLTypes[%%I]!_Signed\*.*"
	rmdir !DLLTypes[%%I]!_Signed
)

del /f /q ver.txt

exit /b 0

:ildasm <netver> <dllname>
call ildasm /out=%~1_Signed\%~2.il %~1\%~2.dll
echo.ildasm /out=%~1_Signed\%~2.il %~1\%~2.dll
exit /b %ERRORLEVEL%

:ilasm <key> <netver> <dllname>
call ilasm /dll /key=%~1.snk %~2\%~3.il /resource=%~2\%~3.res /out=%~2\%~3.dll
exit /b %ERRORLEVEL%