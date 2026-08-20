# PowerShell Script for Full SEO & Schema Optimization across all HTML files
$utf8 = New-Object System.Text.UTF8Encoding $false
$workspaceDir = (Get-Location).Path

$affDomains = @("kuailiaff", "edgenovaaff", "speedworldaff", "ytjcok", "shanhai.sbs", "jsjc456789", "99vpn.bar", "kosingaff", "civetaff", "acceboy", "code=")

$htmlFiles = Get-ChildItem -Path $workspaceDir -Filter "*.html" -Recurse | Where-Object {
    $_.FullName -notlike "*\.git\*" -and $_.FullName -notlike "*\scratch\*"
}

Write-Host "Found $($htmlFiles.Count) HTML files to optimize." -ForegroundColor Cyan

foreach ($file in $htmlFiles) {
    $filePath = $file.FullName
    $relPath = $filePath.Substring($workspaceDir.Length + 1).Replace('\', '/')
    
    $content = [System.IO.File]::ReadAllText($filePath, $utf8)
    $origContent = $content
    
    # 1. Fix robots meta tag (especially douyin page)
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
        $titleText = "椰汁网络日志"
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
    <meta property="og:site_name" content="椰汁网络日志">
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
            $cleanTitle = $titleText.Split('-')[0].Trim()
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
                "name": "首页",
                "item": "https://yzrztop.com/"
            },
            {
                "@type": "ListItem",
                "position": 2,
                "name": "技术评测",
                "item": "https://yzrztop.com/articles.html"
            },
            {
                "@type": "ListItem",
                "position": 3,
                "name": "$cleanTitle",
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
            $authorJson = '"@type": "BlogPosting",' + "`n" + '                       "author": { "@type": "Organization", "name": "椰汁网络日志评测组", "url": "https://yzrztop.com/contact.html" },' + "`n" + '                       "publisher": { "@type": "Organization", "name": "椰汁网络日志", "logo": { "@type": "ImageObject", "url": "https://yzrztop.com/favicon.ico" } },'
            $content = $content.Replace('"@type":  "BlogPosting",', $authorJson).Replace('"@type": "BlogPosting",', $authorJson)
        }
    }
    
    # 6. FAQ Page Schema for ranking pages
    if ($relPath -eq "ranking.html" -or $relPath -eq "articles/2026-airport-ranking.html") {
        if ($content -notlike '*"@type": "FAQPage"*') {
            $faqJson = @"
    <!-- FAQ Schema for SERP Rich Snippets -->
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "FAQPage",
        "mainEntity": [
            {
                "@type": "Question",
                "name": "2026年选择常用网络加速机场核心看哪些指标？",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "选择机场时应优先关注晚高峰丢包率与网络抖动（小于2%为佳）、节点出口真实带宽（支持4K/8K无卡顿）、连接协议稳定性（如Shadowsocks, AnyTLS, Trojan, Hysteria2）以及服务商的注册运营年限与客服响应度。"
                }
            },
            {
                "@type": "Question",
                "name": "IPLC/IEPL专线与普通BGP中转机场有什么区别？",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "IPLC/IEPL是国际物理专线，数据不经过防火长城审查与过境公网，因此具有超低延迟、零丢包和高度耐封锁特点；而BGP中转成本较低，但在特殊时期可能受到国际出口波动影响。"
                }
            },
            {
                "@type": "Question",
                "name": "机场节点连接延迟多少毫秒算合格？",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "通常香港/台湾/日本中转节点延迟在 30ms - 80ms 之间体验极佳；新加坡/韩国节点 60ms - 110ms 表现良好；美西/欧洲专线节点 120ms - 180ms 属于正常范畴。网页打开速度主要取决于丢包率与首包响应（TTFB）。"
                }
            },
            {
                "@type": "Question",
                "name": "如何有效降低机场付费订阅“跑路”带来的损失？",
                "acceptedAnswer": {
                    "@type": "Answer",
                    "text": "建议新手或防范风险用户优先选择“月付”或“季付”套餐，尽量避免一次性购买多年长周期大额套餐；同时保留 1-2 个不同机场备用节点，确保关键时刻网络不中断。"
                }
            }
        ]
    }
    </script>
"@
            $content = $content.Replace("</head>", "$faqJson`n</head>")
        }
    }
    
    # 7. Affiliate Link Rel Compliance (nofollow sponsored noopener target=_blank)
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
        [System.IO.File]::WriteAllText($filePath, $content, $utf8)
        Write-Host "Successfully Optimized: $relPath" -ForegroundColor Green
    }
}

Write-Host "All HTML optimization complete!" -ForegroundColor Cyan
