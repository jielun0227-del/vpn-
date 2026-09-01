$files = Get-ChildItem -Recurse -Filter *.html | Where-Object { $_.FullName -notmatch '\\.git\\' }
$results = @()
foreach ($file in $files) {
    $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    if ($content -match '<meta\s+name=["'']description["'']\s+content=["'']([^"'']*)["'']') {
        $d = $matches[1]
        $obj = [PSCustomObject]@{
            Length = $d.Length
            Path = $file.FullName.Replace("c:\Users\Lenovo\Desktop\椰汁博客\", "")
            Desc = $d
        }
        $results += $obj
    }
}
$results | Sort-Object Length | Format-Table -AutoSize
