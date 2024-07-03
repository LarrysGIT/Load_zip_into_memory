
Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem

function Global:Load-ZipContentInToMemory{
    PARAM(
        [string]$ZipFile,
        [byte[]]$ZipBytes,
        [string]$ZipFullNameRegexFilter,
        [switch]$Recurse = $false
    )

    $ZipContentInToMemoryObject = [PSObject]@{
        ZipFile = $ZipFile
        ZipBytes = $ZipBytes
        FullNameRegexFilter = $ZipFullNameRegexFilter
        Recurse = $Recurse
        Entries = [ordered]@{}
    }

    if($ZipFile -and !$ZipBytes){
        $ZipContentInToMemoryObject.ZipFile = Get-Item -Path $ZipFile
        $ZipContentInToMemoryObject.ZipBytes = [io.file]::ReadAllBytes($ZipContentInToMemoryObject.ZipFile.FullName)
    }

    $MemoryStream = [System.IO.MemoryStream]$ZipContentInToMemoryObject.ZipBytes
    $h_Zip = [System.IO.Compression.ZipArchive]::new($MemoryStream, [System.IO.Compression.ZipArchiveMode]::Read)
    
    foreach($Entry in $h_Zip.Entries) {
        if($Entry.FullName -imatch $ZipContentInToMemoryObject.FullNameRegexFilter)
        {
            $ZipContentInToMemoryObject.Entries.Add($Entry.FullName, @{})
            $ZipContentInToMemoryObject.Entries[$Entry.FullName].ZipEntry = $Entry
            $ZipContentInToMemoryObject.Entries[$Entry.FullName].Bytes = [byte[]]::new($Entry.Length)
            $h_Entry = $Entry.Open()
            $h_Entry.Read($ZipContentInToMemoryObject.Entries[$Entry.FullName].Bytes, 0, $Entry.Length) | Out-Null
            $h_Entry.Close()
            if($ZipContentInToMemoryObject.Recurse -and $Entry.FullName -imatch ".zip$"){
                $ZipContentInToMemoryObject.Entries[$Entry.FullName].Content = Load-ZipContentInToMemory -ZipBytes $ZipContentInToMemoryObject.Entries[$Entry.FullName].Bytes -ZipFullNameRegexFilter $ZipContentInToMemoryObject.FullNameRegexFilter -Recurse:$ZipContentInToMemoryObject.Recurse
            }
        }
    }

    $MemoryStream.Close()
    $h_Zip.Dispose()
    return $ZipContentInToMemoryObject
}
