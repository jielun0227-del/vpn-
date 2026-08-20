$file = "scratch/fix_ranking_js.ps1"
$text = [System.IO.File]::ReadAllText($file, [System.Text.Encoding]::UTF8)
$utf8Bom = New-Object System.Text.UTF8Encoding $true
[System.IO.File]::WriteAllText($file, $text, $utf8Bom)
Write-Host "Converted fix_ranking_js.ps1 to UTF-8 BOM successfully."
