@ECHO OFF & setlocal enableextensions enabledelayedexpansion
:: CONV_CBx-TO-PDF.BAT: Make a PDF file from Comic Book file
:: Image processing for create PDF file from Comic Book (.CBR & .CBZ) with 7zip/ImageMagik/NConvert tools on Windows x64
:: Tools used :
:: - 7zip v22.01 // https://sevenzip.osdn.jp/chm/cmdline/commands/
:: - ImageMagick v7.1.0 // http://www.gogolplex.org/?imagemagick
:: - NConvert v7.121 // https://www.xnview.com/wiki/index.php/NConvert_User_Guide
:: Author: Frédéric Sagez
:: License: free for all forever
:: Source, docs and manual: https://www.dropbox.com/home/github.com/DOS_Scripts/ComicBook-batch-converter
@CLS

:Config_label
set FOLDER-CBx=.\files\.CBx\
set FOLDER-LOG=.\files\.LOG\
set FOLDER-PDF=.\files\.PDF\
set FOLDER-TMP=.\files\.TMP\
set LISTING-FILE=listeCB.txt

set SEVENZIP=.\tools\7z.exe
set OPTIONS-SEVENZIP=-r -y
set IMAGEDISK=.\tools\convert.exe
set OPTIONS-IMAGEDISK=-auto-orient
set CONVERTIMG=.\tools\nconvert.exe
set OPTIONS-CONVERTIMG=-out jpeg -overwrite -ignore_errors

:Start_label
CHCP 1252 > NUL

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
	echo [ERROR] No file to convert in the folder %FOLDER-CBx% > CON
	goto :Error_label
)
echo checked/
ECHO ------------------------- GENERATE BACKLOG FILE -----------------------
set mydatestamp=%DATE:~0,2%%DATE:~3,2%%DATE:~6,4%-%TIME:~0,2%h%TIME:~3,2%
set BAKCLOG_FILE=%FOLDER-LOG%rapport_%mydatestamp: =%.txt
del %BAKCLOG_FILE% 2>NUL
echo checked/
ECHO --------------------------- GENERATE LIST FILE ------------------------
del %FOLDER-TMP%%LISTING-FILE% 2>NUL
echo Liste des fichiers a traiter : >> %BAKCLOG_FILE%
for %%a in (%FOLDER-CBx%*.CB*) do (echo "%%a" >> %BAKCLOG_FILE%)
for %%b in (%FOLDER-CBx%*.CB*) do (echo %%b >> %FOLDER-TMP%%LISTING-FILE%)
set /a cpt_nb_total_file=0
for /f "delims=" %%i in ('type %FOLDER-TMP%%LISTING-FILE%') do (set /a cpt_nb_total_file+=1)
set TOTAL-FILE=!cpt_nb_total_file!
echo [INFO] %TOTAL-FILE% fichier(s) a traiter dans le listing %FOLDER-TMP%%LISTING-FILE% > CON
ECHO ------------------------------ WORKING ON IT --------------------------
set /a cpt_total_file=0
for /f "tokens=* usebackq" %%a in (%FOLDER-TMP%%LISTING-FILE%) do (
:Next_Label
	set /a cpt_total_file=cpt_total_file+1
	echo [INFO] Traitement du fichier "%%~a" - !cpt_total_file! / %TOTAL-FILE% > CON
	echo [INFO] Traitement du fichier "%%~a"
	if exist "%%~a" (
		ECHO ------------------------------ CREATE FOLDER --------------------------
		echo [INFO] Suppression du repertoire %FOLDER-TMP%%%~na
		rmdir /S /Q "%FOLDER-TMP%%%~na" 2>NUL
		echo [INFO] Creation du repertoire %FOLDER-TMP%%%~na
		mkdir "%FOLDER-TMP%%%~na"
		ECHO ---------------------------- DECOMPRESS FILE --------------------------
		echo [INFO] Decompression du fichier "%%~a"
		set FILENAME=%%a
		%SEVENZIP% e "!FILENAME:~0,-1!" -o"%FOLDER-TMP%%%~na" *.* %OPTIONS-SEVENZIP%
		IF ERRORLEVEL 1 GOTO :Error_label
		ECHO --------------------------- CONVERT IMAGE FILES -----------------------
		if not exist "%FOLDER-TMP%%%~na\*.*" (
			echo [WARNING] Aucun fichier decompresse dans le repertoire "%FOLDER-TMP%%%~na" > CON
			echo [WARNING] Aucun fichier decompresse dans le repertoire "%FOLDER-TMP%%%~na"
			rmdir /S /Q "%FOLDER-TMP%%%~na" 2>NUL
			if %TOTAL-FILE% == 1 (goto :Error_label)
		)
		echo [INFO] Suppression des fichiers .txt .xml .nfo dans le repertoire %FOLDER-TMP%%%~na
		del "%FOLDER-TMP%%%~na\*.txt" 2>NUL
		del "%FOLDER-TMP%%%~na\*.xml" 2>NUL
		del "%FOLDER-TMP%%%~na\*.sfv" 2>NUL
		del "%FOLDER-TMP%%%~na\*.nfo" 2>NUL
		del "%FOLDER-TMP%%%~na\*.afi" 2>NUL
		del "%FOLDER-TMP%%%~na\*.old" 2>NUL
		del "%FOLDER-TMP%%%~na\*.csv" 2>NUL
		del /S /A:H "%FOLDER-TMP%%%~na\Thumbs.db" 2>NUL
		if exist "%FOLDER-TMP%%%~na\*.jpg" (
		echo [INFO] Convertion uniquement des images au format JPEG dans le repertoire %FOLDER-TMP%%%~na
		%CONVERTIMG% %OPTIONS-CONVERTIMG% "%FOLDER-TMP%%%~na\*.jpg"
		IF ERRORLEVEL 1 GOTO :Error_label
		)
		if not exist "%FOLDER-TMP%%%~na" (
			echo [WARNING] Fichier %%~a non decompresse > CON
			echo [WARNING] Fichier %%~a non decompresse
			rmdir /S /Q "%FOLDER-TMP%%%~na" 2>NUL
		) else (
			ECHO ----------------------------- CREATE PDF FILE -------------------------
			echo [INFO] Suppression du fichier "%FOLDER-PDF%%%~na.PDF"
			del "%FOLDER-PDF%%%~na.PDF" 2>NUL
			echo [INFO] Conversion du fichier "%FOLDER-PDF%%%~na.PDF"
			%IMAGEDISK% %OPTIONS% "%FOLDER-TMP%%%~na\*.*" "%FOLDER-PDF%%%~na.PDF"
			IF ERRORLEVEL 1 GOTO :Error_label
			echo [INFO] Supression du repertoire de travail %FOLDER-TMP%%%~na
			rmdir /S /Q "%FOLDER-TMP%%%~na" 2>NUL
		)
	)
)>>%BAKCLOG_FILE%
echo [INFO] Nettoyage des fichiers temporaires
del "%FOLDER-TMP%%LISTING-FILE%" 2>NUL
ECHO ----------------------------------- DONE! -----------------------------
goto :End_label
:Error_label
ECHO ------------------------- ERRORS ! see rapport file -------------------
goto :End_label
:Error_tools
ECHO ----------------------------- NO TOOLS FIND ! -------------------------
:End_label
PAUSE

:End_label
@CLS
@ECHO ON
EXIT