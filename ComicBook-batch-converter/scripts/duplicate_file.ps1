<#
.SYNOPSIS
	Batch: CONV_CBx-TO-PDF.BAT - Script: duplicate_file.ps1

.DESCRIPTION
	Detect duplicate file with extension .CBx (SHA compare method) in a one folder

.PARAMETER
	1/ Path of the file = $pathSrc
	2/ Path of the destination file = $pathDest

.EXAMPLE
	PATH/SCRIPT <SOURCE FOLDER> <DESTINATION FOLDER>

.NOTES
	***********************************************
	***     Author: Frédéric Sagez              ***
	***     Copyright (c) 2022-2026 Frémy&Cie   ***
	***     https://github.com/FremyEtCie       ***
	***********************************************
#>
$pathSrc = $args[0]
$pathDest = $args[1]
$files = Get-ChildItem -Path $pathSrc -Include *.CB* -ErrorAction SilentlyContinue
$hashTable = @{}

foreach ($file in $files) {
    $hash = Get-FileHash -Path $file.FullName -Algorithm MD5
    if ($hashTable.ContainsKey($hash.Hash)) {
        $hashTable[$hash.Hash] += $file
    } else {
        $hashTable[$hash.Hash] = @($file)
    }
}
$duplicates = $hashTable.Values | Where-Object { $_.Count -gt 1 }
foreach ($dupGroup in $duplicates) {
    $dupGroup | ForEach-Object {
        $fname = $_.FullName
        $pos_last_anti_slash = $fname.LastIndexOf("\")
        $filename = $fname.Substring($pos_last_anti_slash+1)
    	try
	    {
	    	Move-Item -Path $pathSrc$filename -Destination $pathDest$filename
	    }
	    catch
	    {
		    Write-Host "[WARN][PS] Attention, the duplicate file '$pathSrc$filename' is not found! [$_.Exception.Message]" -ForegroundColor Red
	    }
	    finally
	    {
		    Write-Host "[INFO][PS] Move the file '$pathSrc$filename' in the folder '$pathDest'" -ForegroundColor Cyan
	    }
    }
}
