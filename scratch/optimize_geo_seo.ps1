# PowerShell Script to automate SEO/GEO structured data insertion for Yeju Blog
# Fully ASCII-safe to prevent encoding corruption in Windows PowerShell

$utf8 = New-Object System.Text.UTF8Encoding $false # UTF-8 without BOM
$workspaceDir = (Get-Location).Path

# Define Chinese strings using character codes to prevent ANSI/UTF8 conversion errors
$strXiangGuanTuiJian = "$([char]0x76f8)$([char]0x5173)$([char]0x63a8)$([char]0x8350)"
$strChangJianWenTi = "$([char]0x5e38)$([char]0x89c1)$([char]0x95ee)$([char]0x9898)"
$strXiangGuanYueDu = "$([char]0x76f8)$([char]0x5173)$([char]0x9605)$([char]0x8bfb)"
$strDaoHang = "$([char]0x5bfc)$([char]0x822a)"
$strReMenWenZhang = "$([char]0x70ed)$([char]0x95e8)$([char]0x6587)$([char]0x7ae0)"
$strJiShuZhiChi = "$([char]0x6280)$([char]0x672f)$([char]0x652f)$([char]0x6301)"

$strYeJuPingCeZu = "$([char]0x6930)$([char]0x6c41)$([char]0x8bc4)$([char]0x6d4b)$([char]0x7ec4)"
$strYeJuWangLuoRiZhi = "$([char]0x6930)$([char]0x6c41)$([char]0x7f51)$([char]0x7edc)$([char]0x65e5)$([char]0x5fd7)"

$strFaBuRiQi = "$([char]0x53d1)$([char]0x5e03)$([char]0x65e5)$([char]0x671f)$([char]0xff1a)"
$strZuoZhe = "$([char]0x4f5c)$([char]0x8005)$([char]0xff1a)"
$strQuestionMark = "$([char]0xff1f)"
$strChinesePeriod = "$([char]0x3002)"

# Patterns for dynamic question formation
$patternWeiShenMe = "$([char]0x4e3a)$([char]0x4ec0)$([char]0x4e48)"
$patternRuHe = "$([char]0x5982)$([char]0x4f55)"
$patternShenMe = "$([char]0x4ec0)$([char]0x4e48)"
$patternNaLi = "$([char]0x54ea)$([char]0x91cc)"
$patternZenMeYang = "$([char]0x600e)$([char]0x4e48)$([char]0x6837)"
$patternYouNaXie = "$([char]0x6709)$([char]0x54ea)$([char]0x4e9b)"
$patternBiKeng = "$([char]0x907f)$([char]0x5751)"
$patternFangFan = "$([char]0x9632)$([char]0x8303)"
$patternXieLou = "$([char]0x6cc4)$([char]0x9732)"
$geoMatchPattern = "($patternWeiShenMe|$patternRuHe|$patternShenMe|$patternNaLi|$patternZenMeYang|$patternYouNaXie|$patternBiKeng|$patternFangFan|$patternXieLou)"

function Clean-Html ($html) {
    if ($html -eq $null) { return "" }
    $cleaned = [regex]::Replace($html, '<[^>]+>', '')
    $cleaned = $cleaned.Replace("&nbsp;", " ").Replace("&amp;", "&").Replace("&quot;", '"').Replace("&lt;", "<").Replace("&gt;", ">")
    return $cleaned.Trim()
}

function Clean-Question ($qText) {
    $qText = Clean-Html $qText
    $qText = [regex]::Replace($qText, '^[^\w\u4e00-\u9fa5]+', '')
    $qText = [regex]::Replace($qText, '^[er\s]', '') # clean up any stray characters
    $qText = [regex]::Replace($qText, '^[一二三四五六七八九十百]+[、\s\.]\s*', '')
    $qText = [regex]::Replace($qText, '^\d+[、\.\s]\s*', '')
    return $qText.Trim()
}

function Get-Content-Between ($content, $start, $end) {
    if ($end -gt $content.Length) { $end = $content.Length }
    $len = $end - $start
    if ($len -le 0) { return "" }
    $segment = $content.Substring($start, $len)
    
    $pattern = '(?s)<p>(.*?)</p>|<blockquote[^>]*>(.*?)</blockquote[^>]*>|<li>(.*?)</li>'
    $matches = [regex]::Matches($segment, $pattern)
    $texts = @()
    foreach ($m in $matches) {
        $val = ""
        if ($m.Groups[1].Success) { $val = $m.Groups[1].Value }
        elseif ($m.Groups[2].Success) { $val = $m.Groups[2].Value }
        elseif ($m.Groups[3].Success) { $val = $m.Groups[3].Value }
        
        $cleanedVal = Clean-Html $val
        if ($cleanedVal.Length -gt 15) {
            $texts += $cleanedVal
        }
    }
    
    $fullText = $texts -join " "
    $fullText = [regex]::Replace($fullText, '\s+', ' ')
    
    if ($fullText.Length -gt 350) {
        $fullText = $fullText.Substring(0, 350) + "..."
    }
    return $fullText.Trim()
}

$htmlFiles = Get-ChildItem -Path $workspaceDir -Filter "*.html" -Recurse | Where-Object {
    $_.FullName -notlike "*\.git\*" -and $_.FullName -notlike "*\scratch\*"
}

Write-Output "Found $($htmlFiles.Count) HTML files to process."

foreach ($fileObj in $htmlFiles) {
    $filePath = $fileObj.FullName
    $relPath = $filePath.Substring($workspaceDir.Length + 1).Replace('\', '/')
    $url = "https://yzrztop.com/$relPath"
    if ($relPath -eq "index.html") { $url = "https://yzrztop.com/" }
    
    Write-Output "Processing: $relPath"
    
    $content = [System.IO.File]::ReadAllText($filePath, $utf8)
    
    # Extract title
    $titleMatch = [regex]::Match($content, '(?s)<title>(.*?)</title>')
    $title = $strYeJuWangLuoRiZhi
    if ($titleMatch.Success) {
        $title = Clean-Html $titleMatch.Groups[1].Value
    }
    $headline = $title.Replace(" - $strYeJuWangLuoRiZhi", "")
    
    # Extract description
    $descMatch = [regex]::Match($content, '(?i)<meta\s+name="description"\s+content="([^"]+)"')
    $description = ""
    if ($descMatch.Success) {
        $description = Clean-Html $descMatch.Groups[1].Value
    }
    
    $schemas = @()
    $isArticle = $relPath.StartsWith("articles/")
    
    # 1. Base website or article schema
    if ($isArticle) {
        $dateMatch = [regex]::Match($content, ($strFaBuRiQi + '\s*(\d{4}-\d{2}-\d{2})'))
        $datePublished = "2026-07-15"
        if ($dateMatch.Success) { $datePublished = $dateMatch.Groups[1].Value }
        
        $authorMatch = [regex]::Match($content, ($strZuoZhe + '\s*([^\s<]+)'))
        $authorName = $strYeJuPingCeZu
        if ($authorMatch.Success) { $authorName = Clean-Html $authorMatch.Groups[1].Value }
        
        $articleSchema = @{}
        $articleSchema["@type"] = "BlogPosting"
        $articleSchema["@id"] = "$url#article"
        $articleSchema["headline"] = $headline
        $articleSchema["description"] = $description
        $articleSchema["datePublished"] = $datePublished
        $articleSchema["inLanguage"] = "zh-CN"
        $articleSchema["mainEntityOfPage"] = $url
        
        $authorObj = @{}
        $authorObj["@type"] = "Person"
        $authorObj["name"] = $authorName
        $articleSchema["author"] = $authorObj
        
        $publisherObj = @{}
        $publisherObj["@type"] = "Organization"
        $publisherObj["name"] = $strYeJuWangLuoRiZhi
        
        $logoObj = @{}
        $logoObj["@type"] = "ImageObject"
        $logoObj["url"] = "https://yzrztop.com/favicon.ico"
        $publisherObj["logo"] = $logoObj
        $articleSchema["publisher"] = $publisherObj
        
        $schemas += $articleSchema
    } else {
        $websiteSchema = @{}
        $websiteSchema["@type"] = "WebSite"
        $websiteSchema["@id"] = "$url#website"
        $websiteSchema["url"] = $url
        $websiteSchema["name"] = $strYeJuWangLuoRiZhi
        $websiteSchema["description"] = $description
        $websiteSchema["inLanguage"] = "zh-CN"
        
        $schemas += $websiteSchema
    }
    
    # 2. Extract FAQ Page Schema
    $faqItems = @()
    
    if ($relPath -eq "tutorial.html") {
        # Parse tutorial.html
        $faqPattern = '(?s)<div class="faq-item">\s*<div class="faq-question">\s*<span>(.*?)</span>.*?<div class="faq-answer-inner">(.*?)</div>'
        $faqMatches = [regex]::Matches($content, $faqPattern)
        foreach ($m in $faqMatches) {
            $question = Clean-Question $m.Groups[1].Value
            $answer = Clean-Html $m.Groups[2].Value
            $answer = [regex]::Replace($answer, '\s+', ' ')
            if ($question -ne "" -and $answer -ne "") {
                $qItem = @{}
                $qItem["@type"] = "Question"
                $qItem["name"] = $question
                
                $aItem = @{}
                $aItem["@type"] = "Answer"
                $aItem["text"] = $answer
                $qItem["acceptedAnswer"] = $aItem
                
                $faqItems += $qItem
            }
        }
    } elseif ($isArticle) {
        # Process article headings
        $headings = @()
        $headingMatches = [regex]::Matches($content, '(?s)<h[23][^>]*>(.*?)</h[23]>')
        foreach ($m in $headingMatches) {
            $hText = Clean-Html $m.Groups[1].Value
            if ($hText -in @($strXiangGuanTuiJian, $strChangJianWenTi, $strXiangGuanYueDu, $strDaoHang, $strReMenWenZhang, $strJiShuZhiChi)) {
                continue
            }
            $headings += New-Object PSObject -Property @{
                Start = $m.Index
                End = $m.Index + $m.Length
                Text = $hText
            }
        }
        
        for ($i = 0; $i -lt $headings.Count; $i++) {
            $h = $headings[$i]
            $nextStart = 0
            if ($i + 1 -lt $headings.Count) {
                $nextStart = $headings[$i+1].Start
            } else {
                $nextStart = $content.IndexOf("</section>", $h.End)
                if ($nextStart -eq -1) { $nextStart = $content.IndexOf("</article>", $h.End) }
                if ($nextStart -eq -1) { 
                    $nextStart = $h.End + 3000 
                    if ($nextStart -gt $content.Length) { $nextStart = $content.Length }
                }
            }
            
            $qName = Clean-Question $h.Text
            if ($qName.Length -lt 4) { continue }
            
            # Format question for GEO
            if (-not ($qName.EndsWith($strQuestionMark) -or $qName.EndsWith("?") -or $qName.EndsWith($strChinesePeriod))) {
                if ($qName -match $geoMatchPattern) {
                    $qName = $qName + $strQuestionMark
                }
            }
            
            $aText = Get-Content-Between $content $h.End $nextStart
            if ($qName -ne "" -and $aText.Length -gt 30) {
                $qItem = @{}
                $qItem["@type"] = "Question"
                $qItem["name"] = $qName
                
                $aItem = @{}
                $aItem["@type"] = "Answer"
                $aItem["text"] = $aText
                $qItem["acceptedAnswer"] = $aItem
                
                $faqItems += $qItem
            }
        }
    }
    
    if ($faqItems.Count -ge 2) {
        $faqSchema = @{}
        $faqSchema["@type"] = "FAQPage"
        $faqSchema["mainEntity"] = $faqItems
        $schemas += $faqSchema
        Write-Output "  Extracted $($faqItems.Count) Q&A pairs for FAQPage Schema."
    }
    
    # Combine schemas
    $jsonLdData = @{}
    $jsonLdData["@context"] = "https://schema.org"
    $jsonLdData["@graph"] = $schemas
    
    # Convert to JSON
    $jsonStr = ConvertTo-Json -InputObject $jsonLdData -Depth 10
    
    $scriptBlock = @"
    <!-- JSON-LD Structured Data for SEO & GEO -->
    <script type="application/ld+json">
$jsonStr
    </script>
"@

    # Replace or insert
    $existingPattern = '(?s)\s*<!-- JSON-LD Structured Data for SEO & GEO -->.*?<\/script>\s*\n?'
    $hasExisting = $content -match $existingPattern
    
    $newContent = ""
    if ($hasExisting) {
        $newContent = [regex]::Replace($content, $existingPattern, "`r`n" + $scriptBlock + "`r`n")
        Write-Output "  Replaced existing JSON-LD script block."
    } else {
        $plainPattern = '(?s)\s*<script type="application/ld\+json">.*?<\/script>\s*\n?'
        if ($content -match $plainPattern) {
            $newContent = [regex]::Replace($content, $plainPattern, "`r`n" + $scriptBlock + "`r`n")
            Write-Output "  Replaced plain JSON-LD block."
        } else {
            $newContent = $content.Replace("</head>", $scriptBlock + "`r`n</head>")
            Write-Output "  Inserted new JSON-LD script block before </head>."
        }
    }
    
    [System.IO.File]::WriteAllText($filePath, $newContent, $utf8)
}

Write-Output "`nOptimization successfully completed!"
