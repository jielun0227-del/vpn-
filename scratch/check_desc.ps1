$utf8 = [System.Text.Encoding]::UTF8
$files = Get-ChildItem -Recurse -Filter *.html | Where-Object { $_.FullName -notlike '*\.git\*' -and $_.FullName -notlike '*\scratch\*' }

foreach ($file in $files) {
    $content = [System.IO.File]::ReadAllText($file.FullName, $utf8)
    $m = [regex]::Match($content, '(?s)<meta\s+name="description"\s+content="(.*?)"')
    $desc = if ($m.Success) { $m.Groups[1].Value.Trim() } else { "MISSING" }
    $rel = $file.FullName.Substring((Get-Location).Path.Length + 1).Replace('\', '/')
    Write-Host "[Length: $($desc.Length)] $rel"
}
