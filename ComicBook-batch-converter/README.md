## About

Script CONV_CBx-TO-PDF.BAT: make a PDF file from Comic Book file

## Processing

Image processing for create PDF file from Comic Book (.CBR & .CBZ) with 7zip / ImageMagik / NConvert tools in Windows x64 platform

## Building with

* VSC :: v1.67.0 64bits
* OS :: Windows_NT x64 10.0.19044
* 7zip v22.01 (https://sevenzip.osdn.jp/chm/cmdline/commands/)
* ImageMagick v7.1.0 (http://www.gogolplex.org/?imagemagick)
* NConvert v7.121 (https://www.xnview.com/wiki/index.php/NConvert_User_Guide)

## Requirements

 - Microsoft Windows in a x64 bits plateform
 - CPU 4 Cores
 - Memory: minimum 8 to 16 Go needed

## Folder structure

```
 ComicBook-batch-converter/
 CONV_CBx-TO-PDF.BAT
  +-- tools/
 |   +-- 7z.dll
 |   +-- 7z.exe
 |   +-- convert.exe
 |   +-- nconvert.exe
 |   +-- vcomp120.dll
 +-- files/
 |   +-- .CBX/ - file to convert folder
 |   |   +-- fichier1_example.CBX
 |   |   +-- fichier2_example.CBZ
 |   +-- .LOG/ - generate rapport from the batch script
 |   |   +-- rapport_13102022-14h24.txt
 |   +-- .PDF/ - Generate PDF file folder
 |   |   +-- fichier1_example.PDF
 |   |   +-- fichier2_example.PDF
 |   +-- .TMP/ - Temporary folder
 |   |   +-- listeCB.txt
```

## How to use it

Put all the Comic Book files to convert into the folder ~/ComicBook-batch-converter/files/.CBx/ and launch the dos script "CONV_CBx-TO-PDF.BAT"

## Screenshot

![img|50%](https://github.com/FremyEtCie/DOS_Scripts/blob/main/ComicBook-batch-converter/Capture-DOS.png)
![img|50%](https://github.com/FremyEtCie/DOS_Scripts/blob/main/ComicBook-batch-converter/Capture-rapport.png)

## TODO
- 7zip
  - [x] decompress zip and rar format file (CBR = Rar! / CBZ = PK)
  - [x] decompress all file in an only one folder
  - [x] long file name accepted
  - [ ] check viability of the file to decompress
- ImageDisk
  - [x] Convert all image file to PDF
  - [ ] use multi threading job
- NConvert
  - [x] convert JPEG file not recongnized by ImageDisk
- CONV_CBx-TO-PDF.BAT
  - [x] check first using (delete todelete.txt file)
  - [x] check tools available before
  - [x] check file(s) to convert available before
  - [x] generate report file of treatment
  - [x] generate list of file for treatment
  - [x] treatment of n file with loop indicated
  - [x] indicate which file in treatment
  - [x] check if no file decompress
  - [x] delete file which should not included inside the PDF file
    - [x] *.txt
    - [x] *.xml
    - [x] *.sfv
    - [x] *.nfo
    - [x] Thumbs.db
    - [ ] detect a non image file with a proper list designed
  - [x] detect if no file decompressed
  - [x] remove / delete old folder unused after
- Create tests with bad files
  - [ ] make non regression tests

### License

see LICENSE file.