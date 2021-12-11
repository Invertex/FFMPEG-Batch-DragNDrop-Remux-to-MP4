@echo OFF
setlocal enabledelayedexpansion

ECHO. BATCH script for remuxing downloaded videos to MP4 without affecting their quality.
ECHO. Simply drag and drop the files onto this batch script.
ECHO. Make sure FFMPEG.EXE is in the same folder as this BATCH file
ECHO. When folder dragged, converted files will be placed in a mirrored directory to avoid polluting subdirectories.

IF (%1) == () GOTO NOFILES

SET BPATH=%~dp0
SET /a processed=0

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
setlocal enabledelayedexpansion
set convPath=%~1_Converted
set origPath=%~1

if not exist "%convPath%" MD "%convPath%"
ECHO %convPath%
for /f "delims=" %%a in ('dir "%~1" /b /s /A:-D') do (
	set fpath=%%a
	call set fpath=%%fpath:!origPath!=!convPath!%%
	call :PROCESSFILE "%%a" "!fpath!"
)
exit /b 0

:PROCESSFILE <filePath> <newPath>
SET /a processed+=1
if not exist "%~dp2" MD "%~dp2"
"%BPATH%ffmpeg.exe" -err_detect ignore_err -i "%~1" -c copy "%~2"
exit /b 0

:NOFILES
ECHO No files dragged onto this script to convert...
pause
exit

:END
ECHO.
ECHO.
ECHO !processed! Files converted!
ECHO.
pause
exit

:GET_PATH <dirVar> <fileNameVar> <pathVar>
(
    set "%~1=%~dp3"
	set "%~2=%~fn3"
    exit /b 0
)

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
