# fix_nav_bom.ps1
$rootDir = "c:\Users\Lenovo\Desktop\椰汁博客"
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

function Fix-NavMenu([string]$filePath, [string]$activeKey, [bool]$isSubdir) {
    if (-not (Test-Path $filePath)) { return }
    $content = [System.IO.File]::ReadAllText($filePath, [System.Text.Encoding]::UTF8)
    
    $prefix = if ($isSubdir) { "../" } else { "" }
    
    $a_home    = if ($activeKey -eq 'index')       { ' class="active"' } else { '' }
    $a_rank    = if ($activeKey -eq 'ranking')     { ' class="active"' } else { '' }
    $a_tuto    = if ($activeKey -eq 'tutorial')    { ' class="active"' } else { '' }
    $a_arti    = if ($activeKey -eq 'articles')    { ' class="active"' } else { '' }
    $a_cont    = if ($activeKey -eq 'contact')     { ' class="active"' } else { '' }
    $a_shar    = if ($activeKey -eq 'share-guide') { ' class="active"' } else { '' }
    $a_link    = if ($activeKey -eq 'links')       { ' class="active"' } else { '' }

    $newNav = @"
<div class="nav-menu" id="nav-menu">
                <a href="${prefix}index.html"${a_home}>网站首页</a>
                <a href="${prefix}ranking.html"${a_rank}>机场排行</a>
                <a href="${prefix}tutorial.html"${a_tuto}>小白教程</a>
                <a href="${prefix}articles.html"${a_arti}>技术评测</a>
                <a href="${prefix}contact.html"${a_cont}>商务合作</a>
                <a href="${prefix}share-guide.html"${a_shar}>账号合租指南</a>
                <a href="${prefix}links.html"${a_link}>友情链接</a>
            </div>
"@

    $regex = '(?s)<div class="nav-menu" id="nav-menu">.*?(?=</nav>)'
    if ($content -match $regex) {
        $content = $content -replace $regex, $newNav
        [System.IO.File]::WriteAllText($filePath, $content, $utf8NoBom)
        Write-Host "Replaced navbar in: $([System.IO.Path]::GetFileName($filePath))"
    }
}

$rootMap = @{
    "index.html" = "index"
    "ranking.html" = "ranking"
    "tutorial.html" = "tutorial"
    "articles.html" = "articles"
    "contact.html" = "contact"
    "share-guide.html" = "share-guide"
    "links.html" = "links"
}

foreach ($p in $rootMap.Keys) {
    Fix-NavMenu -filePath (Join-Path $rootDir $p) -activeKey $rootMap[$p] -isSubdir $false
}

$articleFiles = Get-ChildItem -Path (Join-Path $rootDir "articles") -Filter "*.html"
foreach ($af in $articleFiles) {
    Fix-NavMenu -filePath $af.FullName -activeKey "articles" -isSubdir $true
}

Write-Host "✅ All navbars updated cleanly!"
