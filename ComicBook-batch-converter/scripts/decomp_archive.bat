@REM ****************************************************
@REM ***     CONV_CBx-TO-PDF2.BAT (Script Two)        ***
@REM ***       Script : decomp_archive.bat            ***
@REM *** Deccompress the archive file and delete stuf ***
@REM ****************************************************
@REM ***      Author: Frédéric Sagez                  ***
@REM ***      Copyright (c) 2022-2025 Frémy&Cie       ***
@REM ***      https://github.com/FremyEtCie           ***
@REM ****************************************************

set FOLDER-ARCHIVE-NAME=nul
set FOLDER-ARCHIVE-NAME-FOLDER=nul
set FILENAME=nul
set /a CPT_NBFILE_KO=0

ECHO --------------------------- DECOMPRESS FILES ------------------------- >> %BAKCLOG_FILE%
set /a cpt_total_file=0
for /f "tokens=* usebackq" %%A in (%FOLDER-TMP%%LISTING-FILE%) do (
	set /a cpt_total_file+=1
	echo [INFO] Analyse du fichier !cpt_total_file!/%TOTAL-FILE% : %%~A > CON
	echo [INFO] Traitement du fichier !cpt_total_file!/%TOTAL-FILE% : "%%~A" >> %BAKCLOG_FILE%
	if exist "%FOLDER-CBx%%%A" (
		set FOLDER-ARCHIVE-NAME="%FOLDER-TMP%%%~nA"
		set FOLDER-ARCHIVE-NAME-FOLDER=%FOLDER-TMP%%%~nA
		ECHO ----------------------- CREATE TEMPORARY FOLDER ----------------------- >> %BAKCLOG_FILE%
		echo [INFO] Creation du repertoire de travail !FOLDER-ARCHIVE-NAME! >> %BAKCLOG_FILE%
		mkdir !FOLDER-ARCHIVE-NAME! 2>NUL
		ECHO ---------------------------- DECOMPRESS FILES ------------------------- >> %BAKCLOG_FILE%
		echo [INFO] Decompression du fichier "%%~A" >> %BAKCLOG_FILE%
		set FILENAME=%FOLDER-CBx%%%A
		echo [BATCH] %SEVENZIP% e "!FILENAME:~0,-1!" -o!FOLDER-ARCHIVE-NAME! *.* %OPTIONS-SEVENZIP% >> %BAKCLOG_FILE%
		%SEVENZIP% e "!FILENAME:~0,-1!" -o!FOLDER-ARCHIVE-NAME! *.* %OPTIONS-SEVENZIP% >> %BAKCLOG_FILE%
		REM --- Enleve les points d'exclamations sur tous les fichiers dans le repertoire ---
		if exist "!FOLDER-ARCHIVE-NAME-FOLDER!\*^!*.*" (
			echo [INFO] Renommage des fichiers images avec un point exclamation
			call powershell.exe -executionpolicy Unrestricted -File "%cd%\scripts\rename_char.ps1" "!FOLDER-ARCHIVE-NAME-FOLDER!" "Z2"
		) >> %BAKCLOG_FILE%
		REM --- Test if file exist inside a folder
		set TestIfFileInsideFolder="TRUE"
		for /f "usebackq" %%i in (`dir "!FOLDER-ARCHIVE-NAME-FOLDER!\" /b`) do set TestIfFileInsideFolder="FALSE"
		REM --- Clean files inside a folder
		if !TestIfFileInsideFolder!=="FALSE" (
			ECHO ----------------------------- PURGE WASP FILES ------------------------ >> %BAKCLOG_FILE%
			echo [INFO] Suppression des fichiers autres que des images dans le repertoire !FOLDER-ARCHIVE-NAME! >> %BAKCLOG_FILE%
			attrib -r -h -s -a "!FOLDER-ARCHIVE-NAME-FOLDER!\*.*" 2>NUL
			REM --- Delete all files inside the folder
			for /f "delims=" %%e in ( 'type %LIST-FILE-EXTENSION%' ) do (
				del /q /f /s "!FOLDER-ARCHIVE-NAME-FOLDER!\%%e" 2>NUL 1>NUL
			)
			REM --- Delete Windows's files
			del /q /f /s "!FOLDER-ARCHIVE-NAME-FOLDER!\Thumbs.db" 2>NUL 1>NUL
			REM --- Delete Mac's files
			del /q /f /s "!FOLDER-ARCHIVE-NAME-FOLDER!\._*" 2>NUL 1>NUL
			del /q /f /s "!FOLDER-ARCHIVE-NAME-FOLDER!\.DS_Store" 2>NUL 1>NUL
			rmdir /s /q "!FOLDER-ARCHIVE-NAME-FOLDER!\__MACOSX" 2>NUL 1>NUL
		)
		REM --- Test if file exist inside a folder
		set /a cpt_nb_7zfile_ko=0
		set TestIfFileInsideFolder="TRUE"
		for /f "usebackq" %%i in (`dir "!FOLDER-ARCHIVE-NAME-FOLDER!\" /b`) do set TestIfFileInsideFolder="FALSE"
		REM --- Test les fichiers restants ---
		if !TestIfFileInsideFolder!=="FALSE" (
			ECHO ---------------------- GENERATE IMAGE FILES LISTING ------------------- >> %BAKCLOG_FILE%
			del /q /f /s %~1 2>NUL 1>NUL
			for /f "tokens=*" %%Z in ('dir /b /a-d /n "!FOLDER-ARCHIVE-NAME-FOLDER!"') do (echo %%~nxZ >> %~1)
			ECHO ------------------------- TEST FOLDER WITH FILES ---------------------- >> %BAKCLOG_FILE%
			echo [INFO] Test si on peut convertir les images dans le repertoire !FOLDER-ARCHIVE-NAME! >> %BAKCLOG_FILE%
			call scripts/_functions.bat "ProcedureTestPictureFileInsideFolder" %~1 "!FOLDER-ARCHIVE-NAME-FOLDER!" "!FILENAME!"
		) else (
			ECHO -------------------------- DELETE EMPTY FOLDER ------------------------ >> %BAKCLOG_FILE%		
			rd /s /q "!FOLDER-ARCHIVE-NAME-FOLDER!" 2>NUL
			echo [ERROR] Aucun fichier image a traiter dans le fichier "%%~A" > CON
			echo [ERROR] Aucun fichier image a traiter dans le fichier "%%~A" >> %BAKCLOG_FILE%	
			move /Y "%FOLDER-CBx%%%~nxA" "%FOLDER-ERR%%%~nxA" >> %BAKCLOG_FILE%
			set /a cpt_nb_7zfile_ko+=1
		)
		set /a CPT_NBFILE_KO=!CPT_NBFILE_KO!+!cpt_nb_7zfile_ko!
	)
)
REM --- Descriptif des traitements suivants a effectuer ---
echo ---------------------------------------------------------------------------------------- > CON
if [%CPT_NBFILE_KO%] NEQ [0] (
	echo [ERROR] "!CPT_NBFILE_KO! fichier(s) erreur(s) deplace(s) dans le repertoire %FOLDER-ERR%" > CON
	echo [ERROR] "!CPT_NBFILE_KO! fichier(s) erreur(s) deplace(s) dans le repertoire %FOLDER-ERR%" >> %BAKCLOG_FILE%
)
set /a A_TRAITER_AU_FINAL=%TOTAL-FILE%-%CPT_NBFILE_KO%
if [%A_TRAITER_AU_FINAL%] NEQ [0] (
	echo [INFO] "!A_TRAITER_AU_FINAL! fichier(s) CBx a traiter dans le repertoire %FOLDER-CBx%" > CON
	echo [INFO] "!A_TRAITER_AU_FINAL! fichier(s) CBx a traiter dans le repertoire %FOLDER-CBx%" >> %BAKCLOG_FILE%
)
