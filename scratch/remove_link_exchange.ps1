# remove_link_exchange.ps1
$rootDir = "c:\Users\Lenovo\Desktop\椰汁博客"
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

# 1. Remove link-exchange section from contact.html and links.html
$filesWithSection = @("contact.html", "links.html")
foreach ($f in $filesWithSection) {
    $fpath = Join-Path $rootDir $f
    if (Test-Path $fpath) {
        $content = [System.IO.File]::ReadAllText($fpath, [System.Text.Encoding]::UTF8)
        # Regex to remove section id="link-exchange"
        $regexSection = '(?s)\s*<!-- 友情链接与反向链接互换 -->\s*<section class="card link-exchange-card".*?</section>'
        if ($content -match $regexSection) {
            $content = $content -replace $regexSection, ''
            [System.IO.File]::WriteAllText($fpath, $content, $utf8NoBom)
            Write-Host "Removed link-exchange section from: $f"
        }
    }
}

# 2. Update Footer in all HTML files
function Update-Footer([string]$filePath, [bool]$isSubdir) {
    if (-not (Test-Path $filePath)) { return }
    $content = [System.IO.File]::ReadAllText($filePath, [System.Text.Encoding]::UTF8)
    
    $prefix = if ($isSubdir) { "../" } else { "" }
    
    $footerTitle = [System.Text.Encoding]::UTF8.GetString([byte[]](0xe5, 0x8f, 0x8b, 0xe6, 0x83, 0x85, 0xe9, 0x93, 0xbe, 0xe6, 0x8e, 0xa5, 0xe5, 0xa4, 0xa7, 0xe5, 0x85, 0xa8)) # 友情链接大全
    
    # Match any footer-nav-col containing 友情链接 and link-exchange link, or old link-exchange link alone
    $regexFooter = '(?s)<div class="footer-nav-col">\s*<h4>.*?友情链接.*?</h4>\s*(<a href="[^"]*links\.html">.*?</a>\s*)?<a href="[^"]*#link-exchange">.*?</a>\s*</div>'
    
    $newFooterCol = @"
<div class="footer-nav-col">
                    <h4>友情链接</h4>
                    <a href="${prefix}links.html">${footerTitle}</a>
                </div>
"@

    if ($content -match $regexFooter) {
        $content = $content -replace $regexFooter, $newFooterCol
        [System.IO.File]::WriteAllText($filePath, $content, $utf8NoBom)
        Write-Host "Updated footer in: $([System.IO.Path]::GetFileName($filePath))"
    }
}

$rootPages = @("index.html", "ranking.html", "tutorial.html", "articles.html", "contact.html", "share-guide.html", "links.html")
foreach ($p in $rootPages) {
    Update-Footer -filePath (Join-Path $rootDir $p) -isSubdir $false
}

$articleFiles = Get-ChildItem -Path (Join-Path $rootDir "articles") -Filter "*.html"
foreach ($af in $articleFiles) {
    Update-Footer -filePath $af.FullName -isSubdir $true
}

Write-Host "`n✅ Deletions complete!" -ForegroundColor Green
