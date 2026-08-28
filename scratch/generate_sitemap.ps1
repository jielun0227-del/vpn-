$domain = "https://yzrztop.com"
$sitemapPath = "sitemap.xml"
$utf8 = New-Object System.Text.UTF8Encoding($false)
$today = (Get-Date).ToString("yyyy-MM-dd")

$xml = '<?xml version="1.0" encoding="UTF-8"?>' + [Environment]::NewLine
$xml += '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">' + [Environment]::NewLine

# Add root files (both .html and clean URLs)
$rootFiles = @("index.html", "ranking.html", "tutorial.html", "articles.html", "contact.html", "share-guide.html")
foreach ($file in $rootFiles) {
    if (Test-Path $file) {
        $lastmod = $today
        if ($file -eq "index.html") {
            $xml += "  <url>`n    <loc>$domain/</loc>`n    <lastmod>$lastmod</lastmod>`n    <changefreq>daily</changefreq>`n    <priority>1.0</priority>`n  </url>`n"
        } else {
            $cleanName = $file.Replace(".html", "")
            $xml += "  <url>`n    <loc>$domain/$file</loc>`n    <lastmod>$lastmod</lastmod>`n    <changefreq>daily</changefreq>`n    <priority>0.8</priority>`n  </url>`n"
            $xml += "  <url>`n    <loc>$domain/$cleanName</loc>`n    <lastmod>$lastmod</lastmod>`n    <changefreq>daily</changefreq>`n    <priority>0.8</priority>`n  </url>`n"
        }
    }
}

# Add all article files (both .html and clean URLs)
$articleFiles = Get-ChildItem -Path "articles" -Filter "*.html" | Sort-Object Name
foreach ($fileObj in $articleFiles) {
    $lastmod = $today
    $nameHtml = $fileObj.Name
    $nameClean = $fileObj.Name.Replace(".html", "")
    
    $xml += "  <url>`n    <loc>$domain/articles/$nameHtml</loc>`n    <lastmod>$lastmod</lastmod>`n    <changefreq>weekly</changefreq>`n    <priority>0.7</priority>`n  </url>`n"
    $xml += "  <url>`n    <loc>$domain/articles/$nameClean</loc>`n    <lastmod>$lastmod</lastmod>`n    <changefreq>weekly</changefreq>`n    <priority>0.7</priority>`n  </url>`n"
}

$xml += '</urlset>'

[System.IO.File]::WriteAllText($sitemapPath, $xml, $utf8)
Write-Output "Sitemap generated successfully with full clean URL coverage and updated lastmod date ($today)."

