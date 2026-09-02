# apply_clean_ps.ps1
$rootDir = Split-Path -Parent $PSScriptRoot

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

function Update-PageNavAndFooter([string]$filePath, [bool]$isSubdir) {
    if (-not (Test-Path $filePath)) { return }
    
    $content = [System.IO.File]::ReadAllText($filePath, [System.Text.Encoding]::UTF8)
    
    $prefix = if ($isSubdir) { "../" } else { "" }
    
    # 1. Add links.html to nav-menu if not present
    if ($content -notmatch "href=`"$prefix`links\.html`"") {
        # Match share-guide.html line inside nav-menu and append links.html
        $patternNav = '(?s)(<a href="' + [regex]::Escape($prefix) + 'share-guide\.html"[^>]*>.*?</a>)\s*</div>'
        $replacementNav = '$1' + "`n                <a href=`"${prefix}links.html`">" + '$[LINK_TEXT]</a>' + "`n            </div>"
        
        # We need the link text "友情链接"
        # Let's construct "友情链接" via UTF-8 byte conversion
        $linkText = [System.Text.Encoding]::UTF8.GetString([byte[]](0xe5, 0x8f, 0x8b, 0xe6, 0x83, 0x85, 0xe9, 0x93, 0xbe, 0xe6, 0x8e, 0xa5))
        
        $replacementNav = "$1`n                <a href=`"${prefix}links.html`">${linkText}</a>`n            </div>"
        $content = [regex]::Replace($content, $patternNav, $replacementNav)
    }

    # 2. Update Footer friendly links column
    $footerTitle = [System.Text.Encoding]::UTF8.GetString([byte[]](0xe5, 0x8f, 0x8b, 0xe6, 0x83, 0x85, 0xe9, 0x93, 0xbe, 0xe6, 0x8e, 0xa5, 0xe5, 0xa4, 0xa7, 0xe5, 0x85, 0xa8)) # 友情链接大全
    
    $patternFooter = '(?s)<div class="footer-nav-col">\s*<h4>.*?友情链接.*?</h4>\s*<a href="[^"]*contact\.html#link-exchange">.*?</a>\s*</div>'
    $replacementFooter = @"
<div class="footer-nav-col">
                    <h4>友情链接</h4>
                    <a href="${prefix}links.html">${footerTitle}</a>
                    <a href="${prefix}links.html#link-exchange">申请友链 / 提交反向链接</a>
                </div>
"@
    
    # Remove friendly-links-section if index.html
    if ($filePath -match "index\.html$") {
        $content = [regex]::Replace($content, '(?s)<!-- 友情链接专属板块 -->\s*<section class="friendly-links-section" id="friendly-links">.*?</section>', '')
    }

    [System.IO.File]::WriteAllText($filePath, $content, $utf8NoBom)
    Write-Host "Updated: $([System.IO.Path]::GetFileName($filePath))"
}

# Process Root Pages
$rootPages = @("index.html", "ranking.html", "tutorial.html", "articles.html", "contact.html", "share-guide.html", "links.html")
foreach ($p in $rootPages) {
    Update-PageNavAndFooter -filePath (Join-Path $rootDir $p) -isSubdir $false
}

# Process Articles
$articleFiles = Get-ChildItem -Path (Join-Path $rootDir "articles") -Filter "*.html"
foreach ($af in $articleFiles) {
    Update-PageNavAndFooter -filePath $af.FullName -isSubdir $true
}

Write-Host "`n✅ SUCCESS: All HTML files updated cleanly!" -ForegroundColor Green
