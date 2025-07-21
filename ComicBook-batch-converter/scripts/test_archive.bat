@REM ****************************************************
@REM ***       CONV_CBx-TO-PDF2.BAT (Script One)      ***
@REM ***         Script : test_archive.bat            ***
@REM ***   Test archive file and all files inside it  ***
@REM ****************************************************
@REM ***      Author: Frédéric Sagez                  ***
@REM ***      Copyright (c) 2022-2025 Frémy&Cie       ***
@REM ***      https://github.com/FremyEtCie           ***
@REM ****************************************************

set /a cpt_nb_7zfile_ok=0
set /a cpt_nb_7zfile_ko=0
set /a cpt_nb_file=0

REM --- Compte le nombre de fichier a convertir dans le repertoire ---
for /f %%c in ('dir "%FOLDER-CBx%" /A-D /B') do set /a cpt_nb_file+=1
ECHO [INFO] Tests sur %cpt_nb_file% fichier(s) COMIC BOOK a convertir ... un peu de patience s.v.p. ^^! > CON

REM --- Tests si les fichiers compresses ont des erreurs ---
ECHO [INFO] Tests sur le(s) %cpt_nb_file% fichier(s) COMIC BOOK a convertir  >> %BAKCLOG_FILE%
for /f "tokens=*" %%B in ('dir /b /a-d /n "%FOLDER-CBx%*.CB*"') do (
	echo [INFO] Test sur le fichier %FOLDER-CBx%%%~nxB
	%SEVENZIP% %OPTION-TEST-SEVENZIP% "%FOLDER-CBx%%%~nxB"
	if ERRORLEVEL 1 (
		set /a cpt_nb_7zfile_ko+=1
		echo [ERROR] Erreur de compression dans le fichier %%~B > CON
		echo [ERROR] Erreur de compression dans le fichier %%~B
		move /Y "%FOLDER-CBx%%%~nxB" "%FOLDER-ERR%%%~nxB" 2>NUL
	) else (
		set /a cpt_nb_7zfile_ok+=1
	)
) >> %BAKCLOG_FILE%

REM --- Descriptif des traitements suivants a effectuer ---
echo ---------------------------------------------------------------------------------------- > CON
if [!cpt_nb_pdffile_to_move!] NEQ [0] (
	echo [WARN] "!cpt_nb_pdffile_to_move! fichier(s) PDF copie(s) dans le repertoire %FOLDER-PDF% a compresser." > CON
	echo [WARN] "!cpt_nb_pdffile_to_move! fichier(s) PDF copie(s) dans le repertoire %FOLDER-PDF% a compresser." >> %BAKCLOG_FILE%
)
if [!cpt_nb_7zfile_ko!] NEQ [0] (
	echo [ERROR] "!cpt_nb_7zfile_ko! fichier(s) erreur(s) deplace(s) dans le repertoire %FOLDER-ERR%" > CON
	echo [ERROR] "!cpt_nb_7zfile_ko! fichier(s) erreur(s) deplace(s) dans le repertoire %FOLDER-ERR%" >> %BAKCLOG_FILE%
)
if [!cpt_nb_7zfile_ok!] NEQ [0] (
	echo [INFO] "!cpt_nb_7zfile_ok! fichier(s) CBx a traiter dans le repertoire %FOLDER-CBx%" > CON
	echo [INFO] "!cpt_nb_7zfile_ok! fichier(s) CBx a traiter dans le repertoire %FOLDER-CBx%" >> %BAKCLOG_FILE%
)
set TOTAL-FILE=!cpt_nb_7zfile_ok!
