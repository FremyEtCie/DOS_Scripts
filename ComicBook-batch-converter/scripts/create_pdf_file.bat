@REM ****************************************************
@REM ***    CONV_CBx-TO-PDF2.BAT (Script Three)       ***
@REM ***       Script : create_pdf_file.bat           ***
@REM ***    Make PDF file from temporary folder       ***
@REM ****************************************************
@REM ***      Author: Frédéric Sagez                  ***
@REM ***      Copyright (c) 2022-2025 Frémy&Cie       ***
@REM ***      https://github.com/FremyEtCie           ***
@REM ****************************************************

set /a cpt_total_file=0

for /f "tokens=* usebackq" %%A in (%FOLDER-TMP%%LISTING-FILE%) do (
	set /a cpt_total_file+=1
	echo [INFO] Creation du fichier !cpt_total_file!/%TOTAL-FILE% : %%~nA.pdf > CON
	echo [INFO] Traitement du fichier !cpt_total_file!/%TOTAL-FILE% : "%%~A" >> %BAKCLOG_FILE%
	if exist "%FOLDER-CBx%%%A" (
		REM --- Concersion des fichiers graphiques ---
		set FOLDER-ARCHIVE-NAME="%FOLDER-TMP%%%~nA"
		set FOLDER-ARCHIVE-NAME-FOLDER=%FOLDER-TMP%%%~nA
		ECHO --------------------------- CONVERT IMAGE FILES ----------------------- >> %BAKCLOG_FILE%
		if exist "!FOLDER-ARCHIVE-NAME-FOLDER!\*.jpg" (
			echo [INFO] Convertion uniquement des images au format JPEG dans le repertoire !FOLDER-ARCHIVE-NAME! >> %BAKCLOG_FILE%
			%CONVERTIMG% %OPTIONS-CONVERTIMG-JPEG% "!FOLDER-ARCHIVE-NAME-FOLDER!\*.jpg" >> %BAKCLOG_FILE%
		)
		if exist "!FOLDER-ARCHIVE-NAME-FOLDER!\*.png" (
			echo [INFO] Convertion uniquement des images au format PONG dans le repertoire !FOLDER-ARCHIVE-NAME! >> %BAKCLOG_FILE%
			%CONVERTIMG% %OPTIONS-CONVERTIMG-PNG% "!FOLDER-ARCHIVE-NAME-FOLDER!\*.png" >> %BAKCLOG_FILE%
		)
		REM --- Test si le fichier existe déjà, si oui on le supprime ---
		if exist "%FOLDER-PDF%%%~nA.PDF" (
			echo [INFO] Suppression du fichier "%FOLDER-PDF%%%~nA.PDF"
			del /q /f /s "%FOLDER-PDF%%%~nA.PDF" 2>NUL 1>NUL
		) >> %BAKCLOG_FILE%
		REM --- Creation du fichier PDF ---
		ECHO ----------------------------- CREATE PDF FILE ------------------------- >> %BAKCLOG_FILE%
		echo [INFO] Creation du fichier "%FOLDER-PDF%%%~nA.PDF" >> %BAKCLOG_FILE%
		%IMAGEDISK% %OPTIONS-IMAGEDISK% "!FOLDER-ARCHIVE-NAME-FOLDER!\*.*" "%FOLDER-PDF%%%~nA.PDF" >> %BAKCLOG_FILE%
		IF ERRORLEVEL 1 ( echo [ERROR] Impossible de creer le fichier PDF intitule "%%~A")
		echo [INFO] Supression du repertoire de travail !FOLDER-ARCHIVE-NAME! >> %BAKCLOG_FILE%
		rmdir /s /q !FOLDER-ARCHIVE-NAME! 2>NUL 1>NUL
	)
)

