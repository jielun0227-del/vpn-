$target = "$([char]0x6280)$([char]0x672f)$([char]0x8bc4)$([char]0x6d4b)" # 技术评测
$replace = "$([char]0x79d1)$([char]0x5b66)$([char]0x4e0a)$([char]0x7f51)" # 科学上网

$root = (Get-Item -LiteralPath $PSScriptRoot).Parent.FullName
$files = Get-ChildItem -LiteralPath $root -Recurse | Where-Object { $_.Extension -eq ".html" }

$changedCount = 0
foreach ($file in $files) {
    if ($file.FullName -like "*\scratch\*") { continue }
    $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    $pattern = ">" + $target + "<"
    $replacement = ">" + $replace + "<"
    if ($content.Contains($pattern)) {
        $content = $content.Replace($pattern, $replacement)
        [System.IO.File]::WriteAllText($file.FullName, $content, [System.Text.Encoding]::UTF8)
        Write-Host "Updated: $($file.Name)"
        $changedCount++
    }
}

Write-Host "Total files updated: $changedCount"
