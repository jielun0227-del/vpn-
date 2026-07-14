$domain = "https://yzrztop.com"
$sitemapPath = "sitemap.xml"
$utf8 = New-Object System.Text.UTF8Encoding($false)

$xml = '<?xml version="1.0" encoding="UTF-8"?>' + [Environment]::NewLine
$xml += '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">' + [Environment]::NewLine

# Add root files (added share-guide.html)
$rootFiles = @("index.html", "ranking.html", "tutorial.html", "articles.html", "ai-guide.html", "contact.html", "share-guide.html")
foreach ($file in $rootFiles) {
    if (Test-Path $file) {
        $lastmod = (Get-Item $file).LastWriteTime.ToString("yyyy-MM-dd")
        if ($file -eq "index.html") {
            $xml += "  <url>`n    <loc>$domain/</loc>`n    <lastmod>$lastmod</lastmod>`n    <changefreq>daily</changefreq>`n    <priority>1.0</priority>`n  </url>`n"
        } else {
            $xml += "  <url>`n    <loc>$domain/$file</loc>`n    <lastmod>$lastmod</lastmod>`n    <changefreq>daily</changefreq>`n    <priority>0.8</priority>`n  </url>`n"
        }
    }
}

# Add sub-articles
$articleFiles = Get-ChildItem -Path "articles" -Filter "*.html"
foreach ($fileObj in $articleFiles) {
    $lastmod = $fileObj.LastWriteTime.ToString("yyyy-MM-dd")
    $xml += "  <url>`n    <loc>$domain/articles/$($fileObj.Name)</loc>`n    <lastmod>$lastmod</lastmod>`n    <changefreq>weekly</changefreq>`n    <priority>0.6</priority>`n  </url>`n"
}

$xml += '</urlset>'

[System.IO.File]::WriteAllText($sitemapPath, $xml, $utf8)
Write-Output "Sitemap generated successfully."
