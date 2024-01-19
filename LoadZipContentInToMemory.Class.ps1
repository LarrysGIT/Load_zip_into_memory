
class LoadZipContentInToMemory {
    $ZipFile
    $FullNameRegexFilter
    $Entries = [ordered]@{}

    LoadZipContentInToMemory ([string]$ZipPath, [string]$FullNameRegexFilter) {
        $this.ZipFile = Get-Item -Path $ZipPath
        $this.FullNameRegexFilter = $FullNameRegexFilter
        $h_ZipFile = [System.IO.Compression.ZipFile]::OpenRead($this.ZipFile.FullName)
        foreach($Entry in $h_ZipFile.Entries) {
            if($Entry.FullName -imatch $this.FullNameRegexFilter)
            {
                $this.Entries.Add($Entry, [byte[]]::new($Entry.Length))
                $h_Entry = $Entry.Open()
                $h_Entry.Read($this.Entries[$Entry], 0, $Entry.Length)
                $h_Entry.Close()
            }
        }
        $h_ZipFile.Dispose()
    }
}
