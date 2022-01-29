@echo OFF
setlocal enabledelayedexpansion

ECHO. BATCH script for remuxing downloaded videos to MP4 without affecting their quality.
ECHO. Simply drag and drop the files onto this batch script.
ECHO. Make sure FFMPEG.EXE is in the same folder as this BATCH file
ECHO. When folder dragged, converted files will be placed in a mirrored directory to avoid polluting subdirectories.

IF (%1) == () GOTO NOFILES

SET BPATH=%~dp0
SET /a processed=0
SET /a copied=0
:PROCESSINPUT
IF (%1) == () GOTO END

set CURPATH=%1
call :ISFOLDER !CURPATH!

if ERRORLEVEL 1 (
	call :PROCESSFOLDER !CURPATH!
) else (
	if not exist "%~dp1Converted" MD "%~dp1Converted"
	call :PROCESSFILE !CURPATH! "%~dp1Converted\%~n1.mp4"
)

SHIFT
goto PROCESSINPUT

:PROCESSFOLDER <folderPath>
ECHO PROC FOLDER
set convPath=%~1_Converted
set origPath=%~1

if not exist "%convPath%" MD "%convPath%"
ECHO %convPath%
for /f "delims=" %%a in ('dir "%~1" /b /s /A:-D') do (
	set fpath=%%~dpna
	call set fpath=%%fpath:!origPath!=!convPath!%%
	call :PROCESSFILE "%%a" "!fpath!.mp4"
)
exit /b 0

:PROCESSFILE <filePath> <newPath> 
if not exist "%~dp2" MD "%~dp2"
"%BPATH%ffmpeg.exe" -err_detect ignore_err -i "%~1" -c copy "%~2"

if "%~z2"=="0" (
    del /f "%~2"
    set word=NonRemuxable\
    set str=%~dp2
    call set str=%%str:Converted\=!word!%%
    if not exist "!str!" MD "!str!"
    xcopy "%~1" "!str!"
    SET /a copied+=1
    call :IsFolderEmpty "%~dp2"
    if ERRORLEVEL 1 ( rmdir "%~dp2" )
) else ( SET /a processed+=1 )
exit /b 0

:NOFILES
ECHO No files dragged onto this script to convert...
pause
exit

:END
ECHO.
ECHO.
ECHO !processed! Files converted!
if !copied! NEQ 0 ( ECHO !copied! Files that can't be remuxed were copied to "NonRemuxable" folder. You'll want to actually re-encode these video files.)
ECHO.
pause
exit

:ISFOLDER <pathVar>
(
	setlocal enabledelayedexpansion
	SETLOCAL EnableExtensions

	set isFolder=0

	ECHO.%~a1 | find "d" >NUL 2>NUL && (
		set isFolder=1
	)
	exit /b !isFolder!
)

:IsFolderEmpty <pathVar>
(	
	for %%I in ("%~f1\*.*") do exit /b 0 
	exit /b 1
)
