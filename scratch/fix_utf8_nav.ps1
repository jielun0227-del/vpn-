$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

$bytesKexue = [byte[]](0xe7, 0xa7, 0x91, 0xe5, 0xad, 0xa6, 0xe4, 0xb8, 0x8a, 0xe7, 0xbd, 0x91)
$kexueStr = [System.Text.Encoding]::UTF8.GetString($bytesKexue)

$root = (Get-Item -LiteralPath $PSScriptRoot).Parent.FullName
$files = Get-ChildItem -LiteralPath $root -Recurse | Where-Object { $_.Extension -eq ".html" }

$changedCount = 0
foreach ($file in $files) {
    if ($file.FullName -like "*\scratch\*") { continue }
    $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    
    # Replace empty href="articles.html"></a> or href="../articles.html"></a>
    $newContent = $content.Replace('href="articles.html"></a>', 'href="articles.html">' + $kexueStr + '</a>')
    $newContent = $newContent.Replace('href="../articles.html"></a>', 'href="../articles.html">' + $kexueStr + '</a>')
    $newContent = $newContent.Replace('href="articles.html" class="active"></a>', 'href="articles.html" class="active">' + $kexueStr + '</a>')
    $newContent = $newContent.Replace('href="../articles.html" class="active"></a>', 'href="../articles.html" class="active">' + $kexueStr + '</a>')
    
    if ($newContent -ne $content) {
        [System.IO.File]::WriteAllText($file.FullName, $newContent, $utf8NoBom)
        Write-Host "Updated: $($file.Name)"
        $changedCount++
    }
}

Write-Host "Total files fixed: $changedCount"
