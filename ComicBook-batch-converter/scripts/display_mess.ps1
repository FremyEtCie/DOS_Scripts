<#
.SYNOPSIS
	Batch: CONV_CBx-TO-PDF.BAT - Script: display_mess.ps1

.DESCRIPTION
	Display an alert message with colors

.PARAMETER
	1/ A message

.EXAMPLE
	PATH/SCRIPT <MESSAGE>

.NOTES
	***********************************************
	***     Author: Frédéric Sagez              ***
	***     Copyright (c) 2022-2026 Frémy&Cie   ***
	***     https://github.com/FremyEtCie       ***
	***********************************************
#>
$message = $args[0]
Write-Host $message -ForegroundColor Yellow -BackgroundColor DarkRed