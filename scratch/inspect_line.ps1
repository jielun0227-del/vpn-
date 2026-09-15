$files = Get-ChildItem -Path "c:\Users\Lenovo\Desktop\椰汁博客" -Recurse | Where-Object { $_.Extension -eq ".html" }
Write-Host "Found $($files.Count) html files"

$f = $files | Where-Object { $_.Name -eq "index.html" } | Select-Object -First 1
$content = [System.IO.File]::ReadAllText($f.FullName, [System.Text.Encoding]::UTF8)

$lines = $content -split "`r`n"
foreach ($line in $lines) {
    if ($line -like "*articles.html*") {
        Write-Host "Line: '$line'"
        for ($i=0; $i -lt $line.Length; $i++) {
            $c = $line[$i]
            Write-Host ("Char {0}: '{1}' U+{2:X4}" -f $i, $c, [int][char]$c)
        }
    }
}
