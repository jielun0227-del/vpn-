$root = (Get-Item -LiteralPath $PSScriptRoot).Parent.FullName
$targetFile = Join-Path $root "articles\clash-linux-guide-2026.html"
$content = [System.IO.File]::ReadAllText($targetFile, [System.Text.Encoding]::UTF8)

$start = $content.IndexOf('<section class="article-body">')
$end = $content.IndexOf('</section>', $start)
$bodyHtml = $content.Substring($start, $end - $start)

$text = [System.Text.RegularExpressions.Regex]::Replace($bodyHtml, '<[^>]+>', '')
$textClean = [System.Text.RegularExpressions.Regex]::Replace($text, '\s+', '')

Write-Host "Total Chinese character count (excluding HTML tags & spaces): $($textClean.Length)"
