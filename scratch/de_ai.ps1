$utf8 = [System.Text.Encoding]::UTF8
$workspace = "."

Write-Output "--- Starting de-AI Cleanup Process ---"

# 1. Delete ai-guide.html
$aiGuidePath = Join-Path $workspace "ai-guide.html"
if (Test-Path $aiGuidePath) {
    Remove-Item $aiGuidePath -Force
    Write-Output "SUCCESS: Deleted ai-guide.html"
} else {
    Write-Output "INFO: ai-guide.html not found or already deleted."
}

# 2. Process sitemap.xml
$sitemapPath = Join-Path $workspace "sitemap.xml"
if (Test-Path $sitemapPath) {
    $sitemap = [System.IO.File]::ReadAllText($sitemapPath, $utf8)
    $pattern = '(?s)\s*<url>\s*<loc>https://yzrztop\.com/ai-guide\.html</loc>.*?</url>\s*\r?\n?'
    $sitemap = [System.Text.RegularExpressions.Regex]::Replace($sitemap, $pattern, "`r`n")
    [System.IO.File]::WriteAllText($sitemapPath, $sitemap, $utf8)
    Write-Output "SUCCESS: Updated sitemap.xml"
}

# 3. Process verify_menus.ps1
$verifyPath = Join-Path $workspace "scratch/verify_menus.ps1"
if (Test-Path $verifyPath) {
    $verify = [System.IO.File]::ReadAllText($verifyPath, $utf8)
    $verify = $verify.Replace('"ai-guide.html", ', '')
    $verify = $verify.Replace('$linkCount -ne 7', '$linkCount -ne 6')
    [System.IO.File]::WriteAllText($verifyPath, $verify, $utf8)
    Write-Output "SUCCESS: Updated verify_menus.ps1"
}

# 4. Process HTML files in workspace
$htmlFiles = Get-ChildItem -Path $workspace -Filter "*.html" -Recurse
foreach ($fileObj in $htmlFiles) {
    if ($fileObj.FullName.Contains("\.git\") -or $fileObj.FullName.Contains("\scratch\")) {
        continue
    }
    
    $file = $fileObj.FullName
    $text = [System.IO.File]::ReadAllText($file, $utf8)
    
    # Remove nav links, footer links, and sidebar links referencing ai-guide.html (encoding-independent)
    $linkPattern = '(?s)\s*<a href="(?:\.\./)?ai-guide\.html"[^>]*>.*?</a>\s*\r?\n?'
    $text = [System.Text.RegularExpressions.Regex]::Replace($text, $linkPattern, "`r`n")
    
    # Specific cleanup for articles.html card grid (encoding-independent)
    if ($fileObj.Name -eq "articles.html") {
        $cardPattern = '(?s)\s*<!-- .*? -->\s*<article class="article-card">\s*<div class="article-card-body">.*?ai-guide\.html.*?</article>\s*\r?\n?'
        $text = [System.Text.RegularExpressions.Regex]::Replace($text, $cardPattern, "`r`n")
        Write-Output "  -> Removed AI Guide card block from articles.html"
    }
    
    # Clean up excess empty lines (three or more newlines replaced by two)
    $text = [System.Text.RegularExpressions.Regex]::Replace($text, '(\r?\n\s*){3,}', "`r`n`r`n")
    
    [System.IO.File]::WriteAllText($file, $text, $utf8)
    Write-Output "SUCCESS: Processed menu and footer links in $($fileObj.Name)"
}

Write-Output "--- de-AI Cleanup Completed ---"
