# Load_zip_into_memory

A recent issue requires check files in a zip file, instead of extract it and clean up after, I prefer to load the zip file's files into memory as binary.

```powershell
> # load the class
> . ".\LoadZipContentInToMemory.ps1"
> 
> [LoadZipContentInToMemory]::new

OverloadDefinitions
-------------------
LoadZipContentInToMemory new(string ZipPath, string FullNameRegexFilter)

> # load a zip file, with a regex filter "txt$" on the fullname
> $zip = [LoadZipContentInToMemory]::new(".\testzip.zip", "txt$")
> $zip

ZipFile                                                        FullNameRegexFilter Entries
-------                                                        ------------------- -------
C:\Users\xxxxxxxxxx\Downloads\Load_zip_into_memory\testzip.zip txt$                {testzip/testfile1.txt, testzip/t...

> $zip.Entries

Name                           Value
----                           -----
testzip/testfile1.txt          {116, 101, 115, 116...}
testzip/testsubfolder1/test... {116, 101, 115, 116...}

> # the "Entries" is a ordered dictionary
> $zip.Entries.Keys.Count
2
> $zip.Entries.Keys.Name
testfile1.txt
testfile2.txt

> $zip.Entries.Keys.FullName
testzip/testfile1.txt
testzip/testsubfolder1/testfile2.txt
```
