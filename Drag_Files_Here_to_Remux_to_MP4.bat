@echo OFF
ECHO. BATCH script for remuxing downloaded videos to MP4 without affecting their quality.
ECHO. Simply drag and drop the files onto this batch script, and make sure FFMPEG.EXE is in the same folder as this BATCH file
ECHO. 
IF (%1) == () GOTO NOFILES
SET BPATH=%~dp0

:LOOPNEXTFILE
ECHO %~1
if not exist "%~dp1Converted" MD "%~dp1Converted"
"%BPATH%ffmpeg.exe" -err_detect ignore_err -i %1 -c copy "%~dp1Converted\%~n1.mp4"
ECHO. 
SHIFT
IF (%1) == () GOTO END
GOTO LOOPNEXTFILE

:NOFILES
ECHO No files dragged onto this script to convert...
pause
exit

:END
ECHO Files converted!
ECHO.
pause
