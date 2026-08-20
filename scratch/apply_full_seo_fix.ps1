# PowerShell Script: Full SEO & Traffic Recovery Optimization for Yeju Blog
# UTF-8 Encoding without BOM

$utf8 = New-Object System.Text.UTF8Encoding $false
$workspaceDir = (Get-Location).Path

Write-Host "Starting Full SEO & Technical Optimization..." -ForegroundColor Cyan

$htmlFiles = Get-ChildItem -Path $workspaceDir -Filter "*.html" -Recurse | Where-Object {
    $_.FullName -notlike "*\.git\*" -and $_.FullName -notlike "*\scratch\*"
}

foreach ($file in $htmlFiles) {
    $filePath = $file.FullName
    $relPath = $filePath.Substring($workspaceDir.Length + 1).Replace('\', '/')
    
    $content = [System.IO.File]::ReadAllText($filePath, $utf8)
    $modified = $false
    
    # 1. Fix noindex tag on douyin article
    if ($content -match '<meta name="robots" content="noindex, nofollow">') {
        $content = $content.Replace('<meta name="robots" content="noindex, nofollow">', '<meta name="robots" content="index, follow, max-image-preview:large, max-snippet:-1, max-video-preview:-1">')
        $modified = $true
        Write-Host "Fixed noindex tag in $relPath" -ForegroundColor Green
    }
    
    # Ensure default robots tag if missing
    if ($content -notmatch '<meta name="robots"') {
        $robotsTag = '    <meta name="robots" content="index, follow, max-image-preview:large, max-snippet:-1, max-video-preview:-1">'
        $content = $content -replace '(<head>[\r\n]+)', "$1$robotsTag`n"
        $modified = $true
    }
    
    # 2. Preconnect fonts tag
    if ($content -notmatch 'fonts.gstatic.com') {
        $preconnectTags = @"
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
"@
        $content = $content -replace '(</title>)', "$1`n$preconnectTags"
        $modified = $true
    }
    
    # 3. Canonical Tag Verification & Insertion
    $canonicalUrl = "https://yzrztop.com/$relPath"
    if ($relPath -eq "index.html") { $canonicalUrl = "https://yzrztop.com/" }
    
    if ($content -notmatch '<link rel="canonical"') {
        $canonicalTag = "    <link rel=`"canonical`" href=`"$canonicalUrl`">"
        $content = $content -replace '(</title>)', "$1`n$canonicalTag"
        $modified = $true
        Write-Host "Added canonical tag to $relPath ($canonicalUrl)" -ForegroundColor Yellow
    }
    
    # 4. OpenGraph & Twitter Meta Tags
    if ($content -notmatch 'property="og:site_name"') {
        $titleMatch = [regex]::Match($content, '(?s)<title>(.*?)</title>')
        $title = if ($titleMatch.Success) { $titleMatch.Groups[1].Value } else { "椰汁网络日志" }
        
        $descMatch = [regex]::Match($content, '(?s)<meta name="description" content="(.*?)"')
        $desc = if ($descMatch.Success) { $descMatch.Groups[1].Value } else { "" }
        
        $ogBlock = @"
    <meta property="og:site_name" content="椰汁网络日志">
    <meta property="og:locale" content="zh_CN">
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:title" content="$title">
    <meta name="twitter:description" content="$desc">
"@
        if ($content -match 'property="og:title"') {
            $content = $content -replace '(meta property="og:type"[^>]*>)', "$1`n$ogBlock"
        } else {
            $content = $content -replace '(</title>)', "$1`n    <meta property=`"og:title`" content=`"$title`">`n    <meta property=`"og:description`" content=`"$desc`">`n    <meta property=`"og:type`" content=`"website`">`n    <meta property=`"og:url`" content=`"$canonicalUrl`">`n$ogBlock"
        }
        $modified = $true
    }
    
    # 5. Affiliate Link Rel Attribute Compliance
    # Match external links to commercial domain registers/affiliates and make sure rel contains "nofollow sponsored noopener"
    $affDomains = @("kuailiaff", "edgenovaaff", "speedworldaff", "ytjcok", "shanhai.sbs", "jsjc456789", "99vpn.bar", "kosingaff", "civetaff", "acceboy", "register", "code=")
    foreach ($domain in $affDomains) {
        $pattern = "(<a\s+[^>]*href=`"[^`"]*$domain[^`"]*`"[^>]*)"
        $matches = [regex]::Matches($content, $pattern)
        foreach ($m in $matches) {
            $fullTag = $m.Groups[1].Value
            if ($fullTag -notmatch 'rel=') {
                $newTag = $fullTag + ' rel="nofollow sponsored noopener" target="_blank"'
                $content = $content.Replace($fullTag, $newTag)
                $modified = $true
            } elseif ($fullTag -notmatch 'sponsored') {
                $newTag = [regex]::Replace($fullTag, 'rel="([^"]*)"', 'rel="$1 sponsored"')
                if ($newTag -notmatch 'target="_blank"') {
                    $newTag += ' target="_blank"'
                }
                $content = $content.Replace($fullTag, $newTag)
                $modified = $true
            }
        }
    }
    
    if ($modified) {
        [System.IO.File]::WriteAllText($filePath, $content, $utf8)
        Write-Host "Updated: $relPath" -ForegroundColor Green
    }
}

Write-Host "Completed global head & link optimizations!" -ForegroundColor Cyan
