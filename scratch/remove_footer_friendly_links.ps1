# remove_footer_friendly_links.ps1
$rootDir = "c:\Users\Lenovo\Desktop\椰汁博客"
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

function Remove-FooterFriendlyLinks([string]$filePath) {
    if (-not (Test-Path $filePath)) { return }
    $content = [System.IO.File]::ReadAllText($filePath, [System.Text.Encoding]::UTF8)
    
    # Regex to match footer-nav-col with 友情链接
    $regex = '(?s)\s*<div class="footer-nav-col">\s*<h4>.*?友情链接.*?</h4>.*?</div>'
    
    if ($content -match $regex) {
        $content = $content -replace $regex, ''
        [System.IO.File]::WriteAllText($filePath, $content, $utf8NoBom)
        Write-Host "Removed footer friendly links col from: $([System.IO.Path]::GetFileName($filePath))"
    }
}

# 1. Root Pages
$rootPages = @("index.html", "ranking.html", "tutorial.html", "articles.html", "contact.html", "share-guide.html", "links.html")
foreach ($p in $rootPages) {
    Remove-FooterFriendlyLinks -filePath (Join-Path $rootDir $p)
}

# 2. Articles Directory
$articleFiles = Get-ChildItem -Path (Join-Path $rootDir "articles") -Filter "*.html"
foreach ($af in $articleFiles) {
    Remove-FooterFriendlyLinks -filePath $af.FullName
}

Write-Host "`n✅ Successfully removed 友情链接 column from all footers!" -ForegroundColor Green
