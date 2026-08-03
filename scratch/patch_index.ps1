$utf8 = New-Object System.Text.UTF8Encoding $false
$currentDir = (Get-Location).Path
$file = Join-Path $currentDir "index.html"
$content = [System.IO.File]::ReadAllText($file, $utf8)

$strNewTitle = "Shadowrocket $([char]0x8282)$([char]0x70b9)$([char]0x5168)$([char]0x90e8)$([char]0x8d5f)$([char]0x65f6)$([char]0x3001)$([char]0x914d)$([char]0x7f6e)$([char]0x6587)$([char]0x4ef6)$([char]0x5931)$([char]0x6548)$([char]0x3001)$([char]0x4e3a)$([char]0x4ec0)$([char]0x4e48)$([char]0x8d8a)$([char]0x6765)$([char]0x8d8a)$([char]0x6162)$([char]0xff1f)2026$([char]0x5168)$([char]0x9762)$([char]0x89e3)$([char]0x6790)"

# 1. Update Clash Verge guide from 10 to 11
$content = [regex]::Replace($content, '(?s)(<li class="hot-article-item">\s*<span class="hot-number">)10(</span>\s*<a href="\./articles/clash-verge-guide\.html")', '${1}11${2}')

# 2. Update edgenova review from 9 to 10
$content = [regex]::Replace($content, '(?s)(<li class="hot-article-item">\s*<span class="hot-number">)9(</span>\s*<a href="\./articles/edgenova-review\.html")', '${1}10${2}')

# 3. Update prevent-running from 8 to 9
$content = [regex]::Replace($content, '(?s)(<li class="hot-article-item">\s*<span class="hot-number">)8(</span>\s*<a href="\./articles/prevent-running\.html")', '${1}9${2}')

# 4. Insert the new Rank 7 item and update router-vpn-guide from 7 to 8
$targetPattern = '(?s)<li class="hot-article-item">\s*<span class="hot-number">7</span>\s*<a href="\./articles/router-vpn-guide\.html"'
$replacement = @"
                    <li class="hot-article-item">
                        <span class="hot-number">7</span>
                        <a href="./articles/shadowrocket-node-timeout-config-invalid-slow-2026.html" class="hot-article-link" title="$strNewTitle">$strNewTitle</a>
                        <span class="hot-views">215</span>
                    </li>
                    <li class="hot-article-item">
                        <span class="hot-number">8</span>
                        <a href="./articles/router-vpn-guide.html"
"@

if ($content -match $targetPattern) {
    $content = [regex]::Replace($content, $targetPattern, $replacement)
    Write-Output "Successfully matched and replaced Rank 7 and shifted list."
} else {
    Write-Output "Target pattern not found!"
}

[System.IO.File]::WriteAllText($file, $content, $utf8)
Write-Output "Successfully finished patching index.html"
