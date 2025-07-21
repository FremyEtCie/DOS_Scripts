<#
.SYNOPSIS
	Batch: CONV_CBx-TO-PDF2.BAT - Script: replace_char.ps1

.DESCRIPTION
	Replace character '!' ou '%' in filename

.PARAMETER
	1/ Path of the file = $path
	2/ Character to modify = $args[1]

.EXAMPLE
	PATH/SCRIPT <DESTINATION FOLDER> <CHARAACTER TO CHANGE>

.NOTES
	***********************************************
	***     Author: Frédéric Sagez              ***
	***     Copyright (c) 2022-2025 Frémy&Cie   ***
	***     https://github.com/FremyEtCie       ***
	***********************************************
#>
$path=$args[0]
$caractochange=$args[1]
if ($caractochange -eq "Z1")
{
	try
	{
		Get-ChildItem $path -Recurse | Where-Object { $_.Extension -in '.pdf','.cbr','.cbz'} | Rename-Item -NewName {$_.name -replace $caractochange,"%"} -ErrorAction SilentlyContinue
	}
	catch
	{
		Write-Host "[WARN][PS] Attention, the file already exists! [$_.Exception.Message]" -ForegroundColor Red
	}
	finally
	{
		Write-Host "[INFO][PS] Replace character '$caractochange' to '%' in folder $path" -ForegroundColor Green
	}
}
if ($caractochange -eq "Z2")
{
	try
	{
		Get-ChildItem $path -Recurse | Where-Object { $_.Extension -in '.pdf','.cbr','.cbz'} | Rename-Item -NewName {$_.name -replace $caractochange,"!"}	-ErrorAction SilentlyContinue
	}
	catch
	{
		Write-Host "[WARN][PS] Attention, the file already exists! [$_.Exception.Message]" -ForegroundColor Red
	}
	finally
	{
		Write-Host "[INFO][PS] Replace character '$caractochange' to '!' in folder $path" -ForegroundColor Green
	}
}
if ( ($caractochange -ne "Z1") -and ($caractochange -ne "Z2") )
{
	Write-Host "[ERROR][PS] Caractochange parameter is not found ! (value=$caractochange)" -ForegroundColor Yellow
}