
class LoadZipContentInToMemory {
    $ZipFile
    $ZipBytes
    $FullNameRegexFilter
    $Recurse
    $Entries = [ordered]@{}
    LoadZipContentInToMemory ([string]$ZipPath, [string]$FullNameRegexFilter, [switch]$Recurse) {
        $this.ZipFile = Get-Item -Path $ZipPath
        $this.FullNameRegexFilter = $FullNameRegexFilter
        $this.Recurse = $Recurse
        $h_ZipFile = [System.IO.Compression.ZipFile]::OpenRead($this.ZipFile.FullName)
        $this.ReadEntries($h_ZipFile)
        $h_ZipFile.Dispose()
    }
    LoadZipContentInToMemory ([byte[]]$ZipBytes, [string]$FullNameRegexFilter, [switch]$Recurse){
        $this.ZipBytes = $ZipBytes
        $MemoryStream = [System.IO.MemoryStream]$this.ZipBytes
        $this.Recurse = $Recurse
        $this.FullNameRegexFilter = $FullNameRegexFilter
        $h_Zip = [System.IO.Compression.ZipArchive]::new($MemoryStream, [System.IO.Compression.ZipArchiveMode]::Read)
        $this.ReadEntries($h_Zip)
        $h_Zip.Dispose()
    }
    hidden ReadEntries($h_zip){
        foreach($Entry in $h_Zip.Entries) {
            if($Entry.FullName -imatch $this.FullNameRegexFilter)
            {
                $this.Entries.Add($Entry.FullName, @{})
                $this.Entries[$Entry.FullName].ZipEntry = $Entry
                $this.Entries[$Entry.FullName].Bytes = [byte[]]::new($Entry.Length)
                $h_Entry = $Entry.Open()
                $h_Entry.Read($this.Entries[$Entry.FullName].Bytes, 0, $Entry.Length)
                $h_Entry.Close()
                if($this.Recurse -and $Entry.FullName -imatch ".zip$"){
                    $this.Entries[$Entry.FullName].Content = [LoadZipContentInToMemory]::new($this.Entries[$Entry.FullName].Bytes, $this.FullNameRegexFilter, $this.Recurse)
                }
            }
        }
    }
}
