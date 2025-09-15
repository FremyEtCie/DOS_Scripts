@REM ****************************************************
@REM ***      CONV_CBx-TO-PDF2.BAT (Part One)         ***
@REM ***         Script : _parameters.bat             ***
@REM ***     All parameters needed to use tools       ***
@REM ****************************************************
@REM ***      Author: Frédéric Sagez                  ***
@REM ***      Copyright (c) 2022-2025 Frémy&Cie       ***
@REM ***      https://github.com/FremyEtCie           ***
@REM ****************************************************

:: command : t	    Test
:: switch  : bs{o|e|p}{0|1|2}	Set output stream for output/error/progress
:: bso - standard output messages / bse - error messages / bsp - progress information
:: command : ssc    case-insensitive (The default is "-ssc-" on Windows (insensitive) and "-scc" on Linux (sensitive))
:: command : r      Recurse subdirectories
:: command : bd     Disable the progress indicator
set OPTION-TEST-SEVENZIP=t -bse1 -r -ssc -bd

:: command : r     Recurse subdirectories
:: command : y     Assume Yes on all queries
:: switch  : bs{o|e|p}{0|1|2}	Set output stream for output/error/progress
:: bso - standard output messages / bse - error messages / bsp - progress information
:: command : mmt   multithread the operation (faster)
:: command : ssc   case-insensitive (The default is "-ssc-" on Windows (insensitive) and "-scc" on Linux (sensitive))
:: command : bd     Disable the progress indicator
set OPTIONS-SEVENZIP=-r -y -bso0 -mmt -ssc -bd

:: command : quiet Quiet mode
set OPTIONS-NCONVERT=-quiet

:: command : identify           Describes the format and characteristics of one or more image file
:: command : regard-warnings 	pay attention to warning messages
set OPTIONS-TESTCONVERT=identify -regard-warnings

:: Full 72 dpi conversion
set OPTIONS-CONVERTIMG-JPEG=-overwrite -out jpeg -ignore_errors -dpi 72 -quiet
set OPTIONS-CONVERTIMG-PNG=-32bits -D -out jpeg -ignore_errors -dpi 72 -quiet
set OPTIONS-IMAGEDISK=-auto-orient -normalize -quiet

:: Debug mode for expert
set OPTIONS-CONVERTIMG-JPEG-DEBUG=-overwrite -out jpeg -dpi 72
set OPTIONS-CONVERTIMG-PNG-DEBUG=-32bits -D -out jpeg -dpi 72
set OPTIONS-IMAGEDISK-DEBUG=-auto-orient -normalize -monitor

:: See all informartion https://web.mit.edu/ghostscript/www/Use.htm
set OPTIONS-GHOSTSCRIPT=-dBATCH -dSAFER -dNOPAUSE -sDEVICE=pdfwrite -dCompatibilityLevel=1.5 -dPDFSETTINGS=/screen ^
-dColorImageDownsampleType=/Bicubic -dColorImageResolution=72 -dGrayImageDownsampleType=/Bicubic ^
-dGrayImageResolution=72 -dMonoImageDownsampleType=/Bicubic -dMonoImageResolution=72 -sPAPERSIZE=a4 ^
-sOutputFile=
