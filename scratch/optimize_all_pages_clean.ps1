# ASCII-safe PowerShell Script for Full SEO & Schema Optimization
# Uses [char] unicode escapes for Chinese strings to ensure 100% encoding safety in Windows PowerShell

$utf8NoBom = New-Object System.Text.UTF8Encoding $false
$workspaceDir = (Get-Location).Path

# Define Chinese strings via unicode escapes
$strSiteName = "$([char]0x6930)$([char]0x6c41)$([char]0x7f51)$([char]0x7edc)$([char]0x65e5)$([char]0x5fd7)" # 椰汁网络日志
$strShouYe = "$([char]0x9996)$([char]0x9875)" # 首页
$strJiShuPingCe = "$([char]0x6280)$([char]0x672f)$([char]0x8bc4)$([char]0x6d4b)" # 技术评测
$strCePingZu = "$([char]0x6930)$([char]0x6c41)$([char]0x7f51)$([char]0x7edc)$([char]0x65e5)$([char]0x5fd7)$([char]0x8bc4)$([char]0x6d4b)$([char]0x7ec4)" # 椰汁网络日志评测组

$affDomains = @("kuailiaff", "edgenovaaff", "speedworldaff", "ytjcok", "shanhai.sbs", "jsjc456789", "99vpn.bar", "kosingaff", "civetaff", "acceboy", "code=")

$htmlFiles = Get-ChildItem -Path $workspaceDir -Filter "*.html" -Recurse | Where-Object {
    $_.FullName -notlike "*\.git\*" -and $_.FullName -notlike "*\scratch\*"
}

Write-Host "Processing $($htmlFiles.Count) HTML files..." -ForegroundColor Cyan

foreach ($file in $htmlFiles) {
    $filePath = $file.FullName
    $relPath = $filePath.Substring($workspaceDir.Length + 1).Replace('\', '/')
    
    $content = [System.IO.File]::ReadAllText($filePath, [System.Text.Encoding]::UTF8)
    $origContent = $content
    
    # 1. Fix robots meta tag
    if ($content -like '*name="robots"*') {
        $content = [regex]::Replace($content, '<meta\s+name="robots"\s+content="[^"]*"[^>]*>', '<meta name="robots" content="index, follow, max-image-preview:large, max-snippet:-1, max-video-preview:-1">')
    } else {
        $robotsTag = '    <meta name="robots" content="index, follow, max-image-preview:large, max-snippet:-1, max-video-preview:-1">' + "`n"
        $content = $content.Replace("<head>", "<head>`n" + $robotsTag)
    }
    
    # 2. Fix fonts preconnect
    if ($content -notlike '*fonts.gstatic.com*') {
        $preconnectStr = "    <link rel=`"preconnect`" href=`"https://fonts.googleapis.com`">`n    <link rel=`"preconnect`" href=`"https://fonts.gstatic.com`" crossorigin>`n"
        $content = [regex]::Replace($content, '</title>', "</title>`n$preconnectStr", [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    }
    
    # 3. Canonical Tag
    $canonicalUrl = "https://yzrztop.com/$relPath"
    if ($relPath -eq "index.html") { $canonicalUrl = "https://yzrztop.com/" }
    
    if ($content -like '*<link rel="canonical"*') {
        $content = [regex]::Replace($content, '<link\s+rel="canonical"\s+href="[^"]*"[^>]*>', "<link rel=`"canonical`" href=`"$canonicalUrl`">")
    } else {
        $canonicalTag = "    <link rel=`"canonical`" href=`"$canonicalUrl`">`n"
        $content = [regex]::Replace($content, '</title>', "</title>`n$canonicalTag")
    }
    
    # 4. OpenGraph & Twitter tags
    if ($content -notlike '*property="og:site_name"*') {
        $titleMatch = [regex]::Match($content, '(?s)<title>(.*?)</title>')
        $titleText = $strSiteName
        if ($titleMatch.Success) {
            $titleText = $titleMatch.Groups[1].Value.Trim()
        }
        
        $descMatch = [regex]::Match($content, '(?s)<meta\s+name="description"\s+content="(.*?)"')
        $descText = ""
        if ($descMatch.Success) {
            $descText = $descMatch.Groups[1].Value.Trim()
        }
        
        $ogBlock = @"
    <!-- Open Graph & Twitter Cards -->
    <meta property="og:site_name" content="$strSiteName">
    <meta property="og:locale" content="zh_CN">
    <meta property="og:title" content="$titleText">
    <meta property="og:description" content="$descText">
    <meta property="og:type" content="website">
    <meta property="og:url" content="$canonicalUrl">
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:title" content="$titleText">
    <meta name="twitter:description" content="$descText">
"@
        $content = [regex]::Replace($content, '</title>', "</title>`n$ogBlock")
    }
    
    # 5. BreadcrumbList Schema for Articles
    if ($relPath.StartsWith("articles/")) {
        if ($content -notlike '*"@type": "BreadcrumbList"*') {
            $titleMatch = [regex]::Match($content, '(?s)<title>(.*?)</title>')
            $articleTitle = if ($titleMatch.Success) { $titleMatch.Groups[1].Value.Split('-')[0].Trim() } else { "" }
            
            $breadcrumbJson = @"
    <!-- Breadcrumb Schema -->
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "BreadcrumbList",
        "itemListElement": [
            {
                "@type": "ListItem",
                "position": 1,
                "name": "$strShouYe",
                "item": "https://yzrztop.com/"
            },
            {
                "@type": "ListItem",
                "position": 2,
                "name": "$strJiShuPingCe",
                "item": "https://yzrztop.com/articles.html"
            },
            {
                "@type": "ListItem",
                "position": 3,
                "name": "$articleTitle",
                "item": "$canonicalUrl"
            }
        ]
    }
    </script>
"@
            $content = $content.Replace("</head>", "$breadcrumbJson`n</head>")
        }
        
        # Author & Publisher
        if ($content -like '*"@type": "BlogPosting"*' -and $content -notlike '*"author":*') {
            $authorJson = '"@type": "BlogPosting",' + "`n" + '                       "author": { "@type": "Organization", "name": "' + $strCePingZu + '", "url": "https://yzrztop.com/contact.html" },' + "`n" + '                       "publisher": { "@type": "Organization", "name": "' + $strSiteName + '", "logo": { "@type": "ImageObject", "url": "https://yzrztop.com/favicon.ico" } },'
            $content = $content.Replace('"@type":  "BlogPosting",', $authorJson).Replace('"@type": "BlogPosting",', $authorJson)
        }
    }
    
    # 6. Affiliate Link Rel Compliance (nofollow sponsored noopener target=_blank)
    foreach ($domain in $affDomains) {
        $pattern = '(<a\s+[^>]*href="[^"]*' + $domain + '[^"]*"[^>]*)'
        $matches = [regex]::Matches($content, $pattern)
        foreach ($m in $matches) {
            $fullTag = $m.Groups[1].Value
            $newTag = $fullTag
            if ($newTag -notlike '*target=*') {
                $newTag += ' target="_blank"'
            }
            if ($newTag -notlike '*rel=*') {
                $newTag += ' rel="nofollow sponsored noopener"'
            } else {
                $newTag = [regex]::Replace($newTag, 'rel="([^"]*)"', 'rel="nofollow sponsored noopener"')
            }
            if ($newTag -ne $fullTag) {
                $content = $content.Replace($fullTag, $newTag)
            }
        }
    }
    
    if ($content -ne $origContent) {
        [System.IO.File]::WriteAllText($filePath, $content, $utf8NoBom)
        Write-Host "Optimized: $relPath" -ForegroundColor Green
    }
}

Write-Host "Completed clean optimization!" -ForegroundColor Cyan
