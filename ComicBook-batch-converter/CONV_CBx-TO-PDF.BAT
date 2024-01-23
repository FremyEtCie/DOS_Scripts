@ECHO OFF & SETLOCAL enableextensions enabledelayedexpansion
:: CONV_CBx-TO-PDF.BAT: Make a PDF file from Comic Book file
:: Image processing for create PDF file from Comic Book (.CBR & .CBZ) with 7zip/ImageMagik/NConvert tools on Windows x64
:: Tools used :
:: - 7zip v22.01 (64-bit Windows x64) - https://sevenzip.osdn.jp/chm/cmdline/commands/
:: - ImageMagick v7.1.1-24 (Portable-Q16-x64) - http://www.gogolplex.org/?imagemagick - https://imagemagick.org/script/magick-script.php
:: - NConvert v7.121 - https://www.xnview.com/wiki/index.php/NConvert_User_Guide
:: Author: Frédéric Sagez
:: License: free for all forever
:: Source, docs and manual: https://github.com/FremyEtCie/DOS_Scripts/tree/main/ComicBook-batch-converter
@CLS

:Terminal_Colors_and_Size()
COLOR 0C & MODE CON LINES=45 COLS=180

:Config_label()
set FOLDER-CBx=.\files\.CBx\
set FOLDER-LOG=.\files\.LOG\
set FOLDER-PDF=.\files\.PDF\
set FOLDER-TMP=.\files\.TMP\
set LISTING-FILE=listeCB.txt
set LISTING-FILE-ERR=%FOLDER-LOG%%listeCBErr.txt

set SEVENZIP=.\tools\7z.exe
set OPTIONS-SEVENZIP=-r -y
<<<<<<< HEAD
=======
set IMAGEDISK=.\tools\convert.exe
set OPTIONS-IMAGEDISK=-auto-orient
>>>>>>> c55f00acea786b318fc0df862565aa9765725bfb
set CONVERTIMG=.\tools\nconvert.exe
set OPTIONS-CONVERTIMG-JPEG=-overwrite -out jpeg -ignore_errors -dpi 72 -quiet
set OPTIONS-CONVERTIMG-JPEG-DEBUG=-overwrite -out jpeg -dpi 72
set OPTIONS-CONVERTIMG-PNG=-32bits -D -out jpeg -ignore_errors -dpi 72 -quiet
set OPTIONS-CONVERTIMG-PNG-DEBUG=-32bits -D -out jpeg -dpi 72
set IMAGEDISK=.\tools\convert.exe
set OPTIONS-IMAGEDISK=-auto-orient -normalize -quiet
set OPTIONS-IMAGEDISK-DEBUG=-auto-orient -normalize -monitor

:Start_label()
CHCP 1252 > NUL

ECHO -------------------------- NO FOLDER TO WORK ? ------------------- -----
if not exist %FOLDER-CBx% MKDIR %FOLDER-CBx%
if not exist %FOLDER-LOG% MKDIR %FOLDER-LOG%
if not exist %FOLDER-PDF% MKDIR %FOLDER-PDF%
if not exist %FOLDER-TMP% MKDIR %FOLDER-TMP%
echo checked/
if exist "%FOLDER-CBx%todelete.txt" (
ECHO ----------------------------- FIRST ACCESS ? --------------------------
del %FOLDER-CBx%todelete.txt 2>NUL
del %FOLDER-LOG%todelete.txt 2>NUL
del %FOLDER-PDF%todelete.txt 2>NUL
del %FOLDER-TMP%todelete.txt 2>NUL
echo checked/
)
ECHO --------------------------- TOOLS AVALAIBLE ? -------------------------
if not exist %SEVENZIP% (goto :Error_tools)
if not exist %IMAGEDISK% (goto :Error_tools)
if not exist %CONVERTIMG% (goto :Error_tools)
echo checked/
ECHO --------------------------- IF FILE EXISTS ? --------------------------
if not exist %FOLDER-CBX%\*.CB* (
	echo [ERROR] No file to convert in the folder %FOLDER-CBx% > %LISTING-FILE-ERR%
	goto :Error_label
)
echo checked/
ECHO ------------------------ PURGE TEMPORARY FILES ? ----------------------
del %FOLDER-TMP%%LISTING-FILE% 2>NUL
del %LISTING-FILE-ERR% 2>NUL
del /q /f /s "%FOLDER-TMP%\*.*" 2>NUL
echo checked/
ECHO ------------------------- GENERATE BACKLOG FILE -----------------------
set mydatestamp=%DATE:~0,2%%DATE:~3,2%%DATE:~6,4%-%TIME:~0,2%h%TIME:~3,2%
set BAKCLOG_FILE=%FOLDER-LOG%rapport_%mydatestamp: =%.txt
del %BAKCLOG_FILE% 2>NUL
echo checked/
ECHO --------------------------- GENERATE LIST FILE ------------------------
echo Liste des fichiers a traiter : >> %BAKCLOG_FILE%
set /a num=0
for /f "tokens=*" %%A in ('dir /b /a-d /n %FOLDER-CBx%*.CB*') do (
set /a num+=1
echo !num!-%%~nxA >> %BAKCLOG_FILE%
)
for /f "tokens=*" %%B in ('dir /b /a-d /n %FOLDER-CBx%*.CB*') do (echo %%~nxB >> %FOLDER-TMP%%LISTING-FILE%)
echo checked/
set /a cpt_nb_total_file=0
for /f "delims=" %%i in ('type %FOLDER-TMP%%LISTING-FILE%') do (set /a cpt_nb_total_file+=1)
set TOTAL-FILE=!cpt_nb_total_file!
echo [INFO] %TOTAL-FILE% fichier(s) a traiter dans le listing %FOLDER-TMP%%LISTING-FILE% > CON
ECHO ------------------------------ WORKING ON IT --------------------------
set MaxSizeOfFile=1000
set /a cpt_total_file=0
for /f "tokens=* usebackq" %%a in (%FOLDER-TMP%%LISTING-FILE%) do (
	set /a cpt_total_file=cpt_total_file+1
	echo [INFO] Traitement du fichier !cpt_total_file!/%TOTAL-FILE% : "%%~a" > CON
	ECHO =======================================================================
	echo [INFO] Traitement du fichier !cpt_total_file!/%TOTAL-FILE% : "%%~a"
	if exist "%FOLDER-CBx%%%a" (
		ECHO ---------------------------- CREATE TMP FOLDER ------------------------
		echo [INFO] Suppression du repertoire %FOLDER-TMP%%%~na
		rmdir /S /Q "%FOLDER-TMP%%%~na" 2>NUL
		echo [INFO] Creation du repertoire %FOLDER-TMP%%%~na
		mkdir "%FOLDER-TMP%%%~na"
		ECHO ---------------------------- DECOMPRESS FILE --------------------------
		echo [INFO] Decompression du fichier "%%~a"
<<<<<<< HEAD
		set FILENAME=%FOLDER-CBx%%%a
		echo %SEVENZIP% e "!FILENAME:~0,-1!" -o"%FOLDER-TMP%%%~na" *.* %OPTIONS-SEVENZIP%
=======
		set FILENAME=%%a
>>>>>>> c55f00acea786b318fc0df862565aa9765725bfb
		%SEVENZIP% e "!FILENAME:~0,-1!" -o"%FOLDER-TMP%%%~na" *.* %OPTIONS-SEVENZIP%
		IF ERRORLEVEL 1 GOTO :Error_label
		ECHO --------------------------- CONVERT IMAGE FILES -----------------------
		if not exist "%FOLDER-TMP%%%~na\*.*" (
<<<<<<< HEAD
			echo [WARNING] Aucun fichier decompresse dans le repertoire "%FOLDER-TMP%%%~na" > %LISTING-FILE-ERR%
=======
			echo [WARNING] Aucun fichier decompresse dans le repertoire "%FOLDER-TMP%%%~na" > CON
>>>>>>> c55f00acea786b318fc0df862565aa9765725bfb
			echo [WARNING] Aucun fichier decompresse dans le repertoire "%FOLDER-TMP%%%~na"
			rmdir /S /Q "%FOLDER-TMP%%%~na" 2>NUL
			if %TOTAL-FILE% == 1 (goto :Error_label)
		)
<<<<<<< HEAD
		echo [INFO] Suppression des fichiers temporaires dans le repertoire %FOLDER-TMP%%%~na
		attrib -r -h -s -a "%FOLDER-TMP%%%~na\*.*" 2>NUL
		del "%FOLDER-TMP%%%~na\*.rtf" 2>NUL
		del "%FOLDER-TMP%%%~na\*.htm*" 2>NUL
=======
		echo [INFO] Suppression des fichiers .txt .xml .nfo dans le repertoire %FOLDER-TMP%%%~na
>>>>>>> c55f00acea786b318fc0df862565aa9765725bfb
		del "%FOLDER-TMP%%%~na\*.txt" 2>NUL
		del "%FOLDER-TMP%%%~na\*.xml" 2>NUL
		del "%FOLDER-TMP%%%~na\*.sfv" 2>NUL
		del "%FOLDER-TMP%%%~na\*.nfo" 2>NUL
		del "%FOLDER-TMP%%%~na\*.afi" 2>NUL
		del "%FOLDER-TMP%%%~na\*.old" 2>NUL
		del "%FOLDER-TMP%%%~na\*.csv" 2>NUL
<<<<<<< HEAD
		del "%FOLDER-TMP%%%~na\*.db" 2>NUL
		del "%FOLDER-TMP%%%~na\*.url" 2>NUL
		del "%FOLDER-TMP%%%~na\.directory" 2>NUL
   	rem --- Windows
		del "%FOLDER-TMP%%%~na\Thumbs.db" 2>NUL
		rem --- Mac
		del "%FOLDER-TMP%%%~na\._*" 2>NUL
		del "%FOLDER-TMP%%%~na\.DS_Store" 2>NUL
		rmdir /S /Q "%FOLDER-TMP%%%~na\__MACOSX" 2>NUL
		if exist "%FOLDER-TMP%%%~na\*.jpg" (
			echo [INFO] Convertion uniquement des images au format JPEG dans le repertoire %FOLDER-TMP%%%~na
			echo %CONVERTIMG% %OPTIONS-CONVERTIMG-JPEG% "%FOLDER-TMP%%%~na\*.jpg"
			%CONVERTIMG% %OPTIONS-CONVERTIMG-JPEG% "%FOLDER-TMP%%%~na\*.jpg"
			IF ERRORLEVEL 1 GOTO :Error_label
		)
		if exist "%FOLDER-TMP%%%~na\*.png" (
			echo [INFO] Convertion uniquement des images au format PNG dans le repertoire %FOLDER-TMP%%%~na
			echo %CONVERTIMG% %OPTIONS-CONVERTIMG-PNG% "%FOLDER-TMP%%%~na\*.png"
			%CONVERTIMG% %OPTIONS-CONVERTIMG-PNG% "%FOLDER-TMP%%%~na\*.png"
			IF ERRORLEVEL 1 GOTO :Error_label
=======
		del /S /A:H "%FOLDER-TMP%%%~na\Thumbs.db" 2>NUL
		if exist "%FOLDER-TMP%%%~na\*.jpg" (
		echo [INFO] Convertion uniquement des images au format JPEG dans le repertoire %FOLDER-TMP%%%~na
		%CONVERTIMG% %OPTIONS-CONVERTIMG% "%FOLDER-TMP%%%~na\*.jpg"
		IF ERRORLEVEL 1 GOTO :Error_label
>>>>>>> c55f00acea786b318fc0df862565aa9765725bfb
		)
		if not exist "%FOLDER-TMP%%%~na" (
			echo [WARNING] Fichier %%~a non decompresse > %LISTING-FILE-ERR%
			echo [WARNING] Fichier %%~a non decompresse
			goto :Error_label
		) else (
			ECHO ----------------------------- CREATE PDF FILE -------------------------
			echo [INFO] Suppression du fichier "%FOLDER-PDF%%%~na.PDF"
			del "%FOLDER-PDF%%%~na.PDF" 2>NUL
			echo [INFO] Conversion du fichier "%FOLDER-PDF%%%~na.PDF"
<<<<<<< HEAD
			echo %IMAGEDISK% %OPTIONS-IMAGEDISK% "%FOLDER-TMP%%%~na\*.*" "%FOLDER-PDF%%%~na.PDF"
			%IMAGEDISK% %OPTIONS-IMAGEDISK% "%FOLDER-TMP%%%~na\*.*" "%FOLDER-PDF%%%~na.PDF"
=======
			%IMAGEDISK% %OPTIONS% "%FOLDER-TMP%%%~na\*.*" "%FOLDER-PDF%%%~na.PDF"
>>>>>>> c55f00acea786b318fc0df862565aa9765725bfb
			IF ERRORLEVEL 1 GOTO :Error_label
			echo [INFO] Supression du repertoire de travail %FOLDER-TMP%%%~na
			rmdir /S /Q "%FOLDER-TMP%%%~na" 2>NUL
		)
	) else (
	echo [ERROR] Fichier a traiter "%FOLDER-CBx%%%a" non trouve > %LISTING-FILE-ERR%
	goto :Error_label
	)

)>>%BAKCLOG_FILE%
echo [INFO] Nettoyage des fichiers temporaires
<<<<<<< HEAD
del /q /f /s "%FOLDER-TMP%\*.*" 2>NUL
=======
del "%FOLDER-TMP%%LISTING-FILE%" 2>NUL
>>>>>>> c55f00acea786b318fc0df862565aa9765725bfb
ECHO ----------------------------------- DONE! -----------------------------
goto :End_label
:Error_label
ECHO ---------------- ERRORS (see: %LISTING-FILE-ERR%) ------------
goto :End_label
:Error_tools
ECHO ----------------------------- NO TOOLS FIND ! -------------------------
echo [ERROR] Il manque les programmes pour convertir les fichiers ! > %LISTING-FILE-ERR%
:End_label
PAUSE
ENDLOCAL
@ECHO ON
EXIT