@CLS
:: Image processing for create PDF file from Comic Book (.CBR & .CBZ) with 7zip/ImageMagik/NConvert/Ghostscript tools on Windows x64
:: Tools used :
:: - 7zip v24.08 (64-bit Windows x64) - https://sevenzip.osdn.jp/chm/cmdline/commands/
:: - ImageMagick v7.1.1-24 (Portable-Q16-x64) - http://www.gogolplex.org/?imagemagick - https://imagemagick.org/script/magick-script.php
:: - NConvert v7.110 x86 - https://www.xnview.com/wiki/index.php/NConvert_User_Guide
:: - GPL Ghostscript v10.3.1.0 x64 - https://www.ghostscript.com/
:: Author: Frédéric Sagez
:: Copyright (c) 2022-2025 Frémy&Cie
:: Source, docs, manual and licence: https://github.com/FremyEtCie/DOS_Scripts/tree/main/ComicBook-batch-converter

@ECHO OFF & SETLOCAL enableextensions enabledelayedexpansion
TITLE CONV_CBx-TO-PDF.BAT: Batch to make PDF file from a Comic Book file (Version 2.0)

:Terminal_Colors_and_Size()
COLOR 06 & MODE CON

:Config_label()
:: WORK FOLDERS
set FOLDER-CBx=.\files\.CBx\
set FOLDER-LOG=.\files\.LOG\
set FOLDER-PDF=.\files\.PDF\
set FOLDER-CMP=.\files\.CMP\
set FOLDER-TMP=.\files\.TMP\
set FOLDER-ERR=.\files\.ERR\
:: LISTING FILES
set LISTING-FILE=listeCB.txt
set LISTING-FILE-ERR=%FOLDER-LOG%%listeCBErr.txt
set LISTTODO=%FOLDER-TMP%PictureListToDo.txt
set /a TOTAL-FILE=0
:: RENAME FILES STATE
set RENAME_FILE_POURCENTAGE=nul
set RENAME_FILE_EXCLAMATION=nul
:: EXTENSION FILE ERASED FROM FILE DECOMPRESSED WHICH NOT USE TO MAKE A PDF FILE
set LIST-FILE-EXTENSION=.\scripts\extensions.dat
:: PROGRAM TOOLS USED TO DECOMPRESS AND CONVERT
set SEVENZIP=.\tools\01.decompress_cbx\7z.exe
set CONVERTIMG=.\tools\02.convert_cbx\nconvert.exe
set IMAGEDISK=.\tools\03.create_pdf\convert.exe
set GHOSTSCRIPT=.\tools\04.compress_pdf\gswin64c.exe
set TESTCONVERT=.\tools\03.create_pdf\magick.exe
:: PARAMETERS OF TOOLS USED WITH THE SCRIPT
call scripts/_parameters.bat

:Using_UTF-8_Encoding()
CHCP 65001 > NUL

set start_batch_time=%time%

ECHO [INFO] CONTROLS AND CHECKING ==========================================

ECHO -------------------------- NO FOLDER TO WORK ? ------------------------
if not exist %FOLDER-CBx% MKDIR %FOLDER-CBx%
if not exist %FOLDER-LOG% MKDIR %FOLDER-LOG%
if not exist %FOLDER-PDF% MKDIR %FOLDER-PDF%
if not exist %FOLDER-CMP% MKDIR %FOLDER-CMP%
if not exist %FOLDER-TMP% MKDIR %FOLDER-TMP%
if not exist %FOLDER-ERR% MKDIR %FOLDER-ERR%
echo checked/
ECHO ----------------------------- FIRST ACCESS ? --------------------------
if exist "%FOLDER-CBx%todelete.txt" (
	del %FOLDER-CBx%todelete.txt 2>NUL
	del %FOLDER-LOG%todelete.txt 2>NUL
	del %FOLDER-PDF%todelete.txt 2>NUL
	del %FOLDER-CMP%todelete.txt 2>NUL
	del %FOLDER-TMP%todelete.txt 2>NUL
	del %FOLDER-ERR%todelete.txt 2>NUL
)
echo checked/
ECHO --------------------------- TOOLS AVALAIBLE ? -------------------------
if not exist %SEVENZIP% ( goto :Error_tools_s )
if not exist %CONVERTIMG% ( goto :Error_tools_c )
if not exist %IMAGEDISK% ( goto :Error_tools_i )
if not exist %GHOSTSCRIPT% ( goto :Error_tools_g )
if not exist %TESTCONVERT% ( goto :Error_tools_t )
if not exist %LIST-FILE-EXTENSION% ( goto :Error_tools_e )
echo checked/

ECHO ------------------------- GENERATE BACKLOG FILE -----------------------
set mydatestamp=%DATE:~0,2%%DATE:~3,2%%DATE:~6,4%-%TIME:~0,2%h%TIME:~3,2%
set BAKCLOG_FILE=%FOLDER-LOG%rapport_%mydatestamp: =%.txt
del %BAKCLOG_FILE% 2>NUL
echo checked/

ECHO ------------------------ PURGE TEMPORARY FILES ? ----------------------
call scripts/_functions.bat "ProcedureDelTemporaryFiles"
echo checked/

:Clear_all_checked_initialisations()
@CLS

ECHO ---------------------- IF FILE EXISTS TO CONVERT ? --------------------
call scripts/_functions.bat "ProcedureTestFilesInsideFolder"
echo checked/

ECHO [INFO] PREPARATION ====================================================

ECHO ----------------------- RENAME FILES IF NEEDED ------------------------
call scripts/_functions.bat "ProcedureRenameFile" %FOLDER-CBX%
echo checked/
ECHO ---------------- TESTING FILES IN FOLDER (SCRIPT ONE) -----------------
call scripts/test_archive.bat
echo checked/                                                                               - > CON
echo ---------------------------------------------------------------------------------------- > CON
ECHO ------------------------- GENERATE LIST FILE TO DO -------------------- >> %BAKCLOG_FILE%
call scripts/_functions.bat "ProcedureGenerateFileListingAndInformationsIntoLog" %FOLDER-CBX%*.CB*
if %ERROR_FILE% EQU -1 ( goto :NoFile_label )
ECHO -------------------------- GENERATE LISTING FILE ---------------------- >> %BAKCLOG_FILE%
call scripts/_functions.bat "ProcedureGenerateFileListing" %FOLDER-CBX%*.CB* %FOLDER-TMP%%LISTING-FILE%
if %ERROR_FILE% EQU -1 ( goto :NoFile_label )

ECHO [INFO] WORKING HARD ==================================================^>

ECHO ------------------ DECOMPRESS ARCHIVE FILE (SCRIPT TWO) ---------------
call scripts/decomp_archive.bat %LISTTODO%
echo checked/                                                                               - > CON
echo ---------------------------------------------------------------------------------------- > CON
ECHO ------------------------ ANY FILE TO PROCEED ? ------------------------ >> %BAKCLOG_FILE%
del %FOLDER-TMP%%LISTING-FILE% 2>NUL
call scripts/_functions.bat "FonctionTestIfFileExistIn" %FOLDER-CBX%*.CB*
if %ERROR_FILE% EQU -1 ( goto :NoFile_label )
ECHO -------------------- GENERATE FOLDER WITH IMAGE FILES ----------------- >> %BAKCLOG_FILE%
call scripts/_functions.bat "ProcedureGenerateFileListing" %FOLDER-CBX%*.CB* %FOLDER-TMP%%LISTING-FILE%
if %ERROR_FILE% EQU -1 ( goto :NoFile_label )
ECHO ------------------- GENERATE PDF FILES (SCRIPT THREE) -----------------
call scripts/create_pdf_file.bat
echo checked/

:Compress_label
ECHO ------------------------ ANY FILE TO PROCEED ? ------------------------ >> %BAKCLOG_FILE%
call scripts/_functions.bat "ProcedureGenerateFileListing" %FOLDER-PDF%*.PDF %FOLDER-TMP%%LISTING-FILE%
if %ERROR_FILE% EQU -1 ( goto :NoFile_label )
ECHO ------------------- COMPRESS PDF FILES (SCRIPT FOUR) ------------------
call scripts/compress_pdf_file.bat
echo checked/
ECHO ----------------- RENAME COMPRESS PDF FILES IF NEEDED ----------------- >> %BAKCLOG_FILE%
call scripts/_functions.bat "ProcedureReplaceFile"
ECHO ---------------------- DELETE ALL TEMPORARY FILES ---------------------
call scripts/_functions.bat "ProcedureDelTemporaryFiles"
ECHO ------------------ DISPLAY ELAPSED TIME OF TREATMENT ------------------ >> %BAKCLOG_FILE%
call scripts/_functions.bat "ProcedureDisplayElapsedTime" "%start_batch_time%"
ECHO [INFO] ^<============================================ TREATMENT IS OVER

goto :End_label

:NoFile_label
ECHO ------------------------- NO FILE TO CONVERT ! ------------------------
if %NO_PDF_FILE% NEQ -1 ( goto :Compress_label )
echo [ERROR] No file to convert in the folder %FOLDER-CBx%
call scripts/_functions.bat "ProcedureDelTemporaryFiles"
goto :End_label
:Error_label
ECHO -------------------- ERRORS (see: %LISTING-FILE-ERR%) -----------------
echo [ERROR] See the log file %BAKCLOG_FILE%s
goto :End_label
:Error_tools_s
ECHO ----------------------------- NO TOOLS FIND ^^! -------------------------
echo [ERROR] Il manque le programme "%SEVENZIP%" pour decompresser les fichiers ^^!
goto :End_label
:Error_tools_i
ECHO ----------------------------- NO TOOLS FIND ^^! -------------------------
echo [ERROR] Il manque le programme "%IMAGEDISK%" pour generer les fichiers pdf ^^!
goto :End_label
:Error_tools_c
ECHO ----------------------------- NO TOOLS FIND ^^! -------------------------
echo [ERROR] Il manque le programme "%CONVERTIMG%" pour convertir les fichiers images ^^!
:Error_tools_g
ECHO ----------------------------- NO TOOLS FIND ^^! -------------------------
echo [ERROR] Il manque le programme "%GHOSTSCRIPT%" pour compresser les fichiers pdf ^^!
goto :End_label
:Error_tools_t
ECHO ----------------------------- NO TOOLS FIND ^^! -------------------------
echo [ERROR] Il manque le programme "%TESTCONVERT%" pour valider les fichiers images ^^!
goto :End_label
:Error_tools_e
ECHO ----------------------------- NO TOOLS FIND ^^! -------------------------
echo [ERROR] Il manque le detail des extensions "%LIST-FILE-EXTENSION%" pour cleaner les fichiers a traiter ^^!
goto :End_label

:End_label
PAUSE
ENDLOCAL
@ECHO ON
EXIT