@REM ****************************************************
@REM ***     CONV_CBx-TO-PDF2.BAT (Script Four)       ***
@REM ***       Script : compress_pdf_file.bat         ***
@REM ***       Adjust compression of PDF file         ***
@REM ****************************************************
@REM ***      Author: Frédéric Sagez                  ***
@REM ***      Copyright (c) 2022-2025 Frémy&Cie       ***
@REM ***      https://github.com/FremyEtCie           ***
@REM ****************************************************

set /a cpt_total_file=0

ECHO ------------------------ PREPARE FILES TO COMPRESS -------------------- >> %BAKCLOG_FILE%
for /f "tokens=* usebackq" %%C in (%FOLDER-TMP%%LISTING-FILE%) do (
	set /a cpt_total_file+=1
	echo [INFO] Compression du fichier !cpt_total_file!/%TOTAL-FILE% : "%%~C"
	REM --- Test si le fichier existe déjà, si oui on le supprime ---
	if exist "%FOLDER-PDF%comp_%%~nxC" (
		echo [INFO] Suppression du fichier "%FOLDER-PDF%comp_%%~nxC" >> %BAKCLOG_FILE%
		del /q /f /s "%FOLDER-PDF%comp_%%~nxC" 2>NUL 1>NUL
	)
	REM --- Compression du fichier PDF ---
	echo [INFO] Compression du fichier pdf "%FOLDER-PDF%%%~nxC" >> %BAKCLOG_FILE%
	%GHOSTSCRIPT% %OPTIONS-GHOSTSCRIPT%"%FOLDER-CMP%%%~nxC" "%FOLDER-PDF%%%~nxC" >> %BAKCLOG_FILE%
	IF ERRORLEVEL 1 ( echo [ERROR] Impossible de compresser le fichier "%%~C" ^^! )
)