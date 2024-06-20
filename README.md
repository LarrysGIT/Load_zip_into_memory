# Load_zip_into_memory

A recent issue requires check files in a zip file, instead of extract it and clean up after, I prefer to load the zip file's files into memory as binary.

```powershell
> # load the class
> . ".\LoadZipContentInToMemory.ps1"
> 
> [LoadZipContentInToMemory]::new

OverloadDefinitions
-------------------
LoadZipContentInToMemory new(string ZipPath, string FullNameRegexFilter, switch Recurse)                                                                      
LoadZipContentInToMemory new(byte[] ZipBytes, string FullNameRegexFilter, switch Recurse) 

> # load a zip file, with a regex filter "txt$" on the fullname
> $zip = [LoadZipContentInToMemory]::new(".\testzip.zip", "txt$", $false)
> $zip

ZipFile                                                        FullNameRegexFilter Entries
-------                                                        ------------------- -------
C:\Users\xxxxxxxxxx\Downloads\Load_zip_into_memory\testzip.zip txt$                {testzip/testfile1.txt, testzip/t...

> $zip.Entries

Name                           Value
----                           -----
testzip/testfile1.txt          {116, 101, 115, 116...}
testzip/testsubfolder1/test... {116, 101, 115, 116...}

> # load a zip bytes, with a regex filter "txt$" on the fullname
> $bytes = [io.file]::ReadAllBytes("C:\Users\xxxxxxxxxx\Downloads\Load_zip_into_memory\testzip.zip")
> $zip = [LoadZipContentInToMemory]::new($bytes, "txt$", $false)

> # if there is zip files in a zip file, use the recurse switch to load all
> $bytes = [io.file]::ReadAllBytes("C:\Users\xxxxxxxxxx\Downloads\Load_zip_into_memory\testzip.zip")
> $zip = [LoadZipContentInToMemory]::new($bytes, ".", $true)
> $zip.Entries["subzip1.zip"].Content
> 
```
