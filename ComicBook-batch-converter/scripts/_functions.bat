@REM ****************************************************
@REM ***           CONV_CBx-TO-PDF2.BAT               ***
@REM ***          Script : _functions.bat             ***
@REM ***            Tools and libraries               ***
@REM ****************************************************
@REM ***      Author: Frédéric Sagez                  ***
@REM ***      Copyright (c) 2022-2025 Frémy&Cie       ***
@REM ***      https://github.com/FremyEtCie           ***
@REM ****************************************************

set ERROR_FILE=0

if "%1" == "" (echo The file was either run regardless or from command without arguments. & exit /b 1)
goto :%~1

REM -------------------------------------------------------------------
REM --- Test tous les fichiers/répertoires du repertoire de travail ---
REM -------------------------------------------------------------------
:ProcedureTestFilesInsideFolder
set /a cpt_nb_pdffile_to_move=0
set NO_CBx_FILE=-1
set NO_PDF_FILE=-1
if exist "%FOLDER-CBx%*.cb*" ( set NO_CBx_FILE=0 )
if exist "%FOLDER-CBx%*.pdf" (
	for /f "tokens=*" %%P in ('dir /b /a-d /n %FOLDER-CBx%*.pdf') do (
		set /a cpt_nb_pdffile_to_move+=1
		copy /Y /B /V "%FOLDER-CBx%%%~nxP" "%FOLDER-PDF%%%~nxP" 2>NUL 1>NUL
		set NO_PDF_FILE=0
	)
) >> %BAKCLOG_FILE%
if %NO_CBx_FILE% NEQ 0 (
	ECHO ------------------- NO .CBR OR .CBZ FILE TO CONVERT ^^! -----------------
	if %NO_PDF_FILE% NEQ 0 (
		ECHO ----------------------- NO .PDF FILE TO CONVERT ^^! ---------------------
	)
) > CON
goto :EndFunctions

REM ------------------------------------------------------------------------------------
REM --- Renomme tous les fichiers avec un caractere special du repertoire de travail ---
REM ------------------------------------------------------------------------------------
:ProcedureRenameFile
::echo #ProcedureRenameFile# The value of parameter 2 is %2
REM - Caractere Espace
if exist "%~2* .*" (
	for /f "tokens=*" %%F in ('dir "%~2* .*" /a:-d /b') do (
		echo [INFO] Renommage de fichiers "%%~F" avec un espace a la fin > CON
		set $Filename=%%~nF
		set $Filename=!$Filename:~0,-1!%%~xF
		move /y "%~2%%F" "%~2!$Filename!" 2>NUL 1>NUL
	)
) >> %BAKCLOG_FILE%
REM - Caractere Point
if exist "%~2*..*" (
	for /f "tokens=*" %%F in ('dir "%~2*..*" /a:-d /b') do (
		echo [INFO] Renommage de fichiers "%%~F" avec un point a la fin en trop > CON
		set $Filename=%%~nF
		set $Filename=!$Filename:~0,-1!%%~xF
		move /y "%~2%%F" "%~2!$Filename!" 2>NUL 1>NUL
	)
) >> %BAKCLOG_FILE%
if exist "%~2*...*" (
	for /f "tokens=*" %%F in ('dir "%~2*...*" /a:-d /b') do (
		echo [INFO] Renommage de fichiers "%%~F" avec un point a la fin en trop > CON
		set $Filename=%%~nF
		set $Filename=!$Filename:~0,-2!%%~xF
		move /y "%~2%%F" "%~2!$Filename!" 2>NUL 1>NUL
	)
) >> %BAKCLOG_FILE%
REM - Caractere Pourcentage remplace par Z1
if exist "%~2*%%*.*" (
	echo [INFO] Renommage de fichiers avec un caractere pourcentage par le caractere "Z1" > CON
	call powershell.exe -executionpolicy Unrestricted -File "%cd%\scripts\rename_char.ps1" %FOLDER-CBx% "Z1"
	set RENAME_FILE_POURCENTAGE="TRUE"
)
REM - Caractere Point d'exclamation remplace par Z2
if exist "%~2*^!*.*" (
	echo [INFO] Renommage de fichiers avec un point exclamation par le caractere "Z2" > CON
	call powershell.exe -executionpolicy Unrestricted -File "%cd%\scripts\rename_char.ps1" %FOLDER-CBx% "Z2"
	set RENAME_FILE_EXCLAMATION="TRUE"
)
goto :EndFunctions

REM --------------------------------------------------------
REM --- Appel des scripts PS1 pour renommer des fichiers ---
REM --------------------------------------------------------
:ProcedureReplaceFile
if %RENAME_FILE_POURCENTAGE%=="TRUE" (
	ECHO --------------- RENAME FILES WITH POURCENTAGE CHARACTER---------------
	call powershell.exe -executionpolicy Unrestricted -File "%cd%\scripts\replace_char.ps1" %FOLDER-CMP% "Z1"
	call powershell.exe -executionpolicy Unrestricted -File "%cd%\scripts\replace_char.ps1" %FOLDER-CBx% "Z1"
)
if %RENAME_FILE_EXCLAMATION%=="TRUE" (
	ECHO --------------- RENAME FILES WITH EXCLAMATION CHARACTER---------------
	call powershell.exe -executionpolicy Unrestricted -File "%cd%\scripts\replace_char.ps1" %FOLDER-CMP% "Z2"
	call powershell.exe -executionpolicy Unrestricted -File "%cd%\scripts\replace_char.ps1" %FOLDER-CBx% "Z2"
)
goto :EndFunctions

REM -----------------------------------------------------------------------
REM --- Supprime tous les fichiers/répertoires du repertoire temporaire ---
REM -----------------------------------------------------------------------
:ProcedureDelTemporaryFiles
del /q /f /s %LISTTODO% 2>NUL 1>NUL
del /q /f /s %FOLDER-TMP%%LISTING-FILE% 2>NUL 1>NUL
del /q /f /s %LISTING-FILE-ERR% 2>NUL 1>NUL
del /q /f /s "%FOLDER-PDF%*.*" 2>NUL 1>NUL
del /q /f /s "%FOLDER-TMP%*.*" 2>NUL 1>NUL
for /f "delims=" %%P in ('dir "%FOLDER-TMP%" /b /a-a') do (
	echo Répertoire supprimé - %%~dpP%%~nP
	rmdir /s /q "%FOLDER-TMP%%%P" 2>NUL 1>NUL
) >> %BAKCLOG_FILE%
goto :EndFunctions

REM -----------------------------------------------
REM --- Test si il y a des fichiers a convertir ---
REM -----------------------------------------------
:FonctionTestIfFileExistIn
::echo #FonctionTestIfFileExistIn# The value of parameter 2 is %~2
if not exist %~2 (
	echo [ERROR] No file to convert in the folder %~2 >> %BAKCLOG_FILE%
	set ERROR_FILE=-1
)
goto :EndFunctions

REM -------------------------------------------------------------
REM --- Genere la liste des fichiers du repertoire de travail ---
REM -------------------------------------------------------------
:ProcedureGenerateFileListing
::echo #ProcedureGenerateFileListing# The value of parameter 2 is %~2
::echo #ProcedureGenerateFileListing# The value of parameter 3 is %~3
del /q /f /s %~3 2>NUL 1>NUL
set /a compteurFile=0
if exist %~2 (
	for /f "tokens=*" %%B in ('dir /b /a-d /n %~2') do (
		set /a compteurFile+=1
		echo %%~nxB >> %~3
	)
	set TOTAL-FILE=!compteurFile!
) else (
	set ERROR_FILE=-1
)
goto :EndFunctions

REM ---------------------------------------------------------------------------------
REM --- Genere la liste des fichiers du repertoire de travail dans le fichier LOG ---
REM ---------------------------------------------------------------------------------
:ProcedureGenerateFileListingAndInformationsIntoLog
::echo #ProcedureGenerateFileListingAndInformationsIntoLog# The value of parameter 2 is %~2
echo [INFO] Liste des fichiers a traiter : >> %BAKCLOG_FILE%
set /a num=0
for /f "tokens=*" %%A in ('dir /b /a-d /n %~2') do (
	set /a num+=1
	echo !num!-%%~nxA >> %BAKCLOG_FILE%
)
echo [INFO] !num! fichier(s) a traiter dans le fichier listing .\files\.TMP\listeCB.txt >> %BAKCLOG_FILE%
goto :EndFunctions

REM --------------------------------------------------------------------------------------
REM --- Test tous les fichiers a l'interieur d'un fichier CBR du repertoire de travail ---
REM --------------------------------------------------------------------------------------
:ProcedureTestPictureFileInsideFolder
::echo #ProcedureTestPictureFileInsideFolder# The value of parameter 2 is %2.
::echo #ProcedureTestPictureFileInsideFolder# The value of parameter 3 is %3.
::echo #ProcedureTestPictureFileInsideFolder# The value of parameter 4 is %4.
for /f "tokens=* usebackq" %%C in (%2) do (
	%TESTCONVERT% %OPTIONS-TESTCONVERT% "%~3\%%~nxC"
	if !errorlevel! == 1 (
		echo [BATCH ERROR] %TESTCONVERT% %OPTIONS-TESTCONVERT% "%~3\%%~nxC"
		echo [ERROR] Ne peut convertir les fichiers images dans le fichier %4
		echo [ERROR] Deplacement du fichier %4
		move /Y "%~4" %FOLDER-ERR% 2>NUL 1>NUL
		echo [ERROR] Suppression du repertoire de travail %3
		rmdir /s /q "%~3" 2>NUL 1>NUL
		set /a cpt_nb_7zfile_ko+=1
		goto :EndFunctions
	)
) >> %BAKCLOG_FILE%
goto :EndFunctions

REM ---------------------------------------------------------------------------------
REM --- Genere la liste des fichiers du repertoire de travail dans le fichier LOG ---
REM ---------------------------------------------------------------------------------
:ProcedureDisplayElapsedTime
::echo #ProcedureDisplayElapsedTime# The value of parameter 2 is %2.
set strt=%~2
set endt=%time%
::Calculating elapsed time
set /A elpsd=(%endt:~0,2%-%strt:~0,2%)*360000 + (%endt:~3,2%-%strt:~3,2%)*6000 + (%endt:~6,2%-%strt:~6,2%)*100 + (%endt:~9,2%-%strt:~9,2%) 
if %elpsd% LSS 0 set /A elpsd=%elpsd% + 24*360000
::Display final countdown
set /A "cc=elpsd%%100+100,elpsd/=100,ss=elpsd%%60+100,elpsd/=60,mm=elpsd%%60+100,hh=elpsd/60+100"
echo [INFO] Temps final d'execution du batch : %hh:~1%h:%mm:~1%m:%ss:~1%.%cc:~1%s
echo [INFO] Temps final d'execution du batch : %hh:~1%h:%mm:~1%m:%ss:~1%.%cc:~1%s >> %BAKCLOG_FILE%
goto :EndFunctions

:EndFunctions
exit /b %ERROR_FILE%