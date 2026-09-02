# fix_nav_bytes.ps1
$rootDir = Split-Path -Parent $PSScriptRoot
$utf8 = [System.Text.Encoding]::UTF8

# Raw UTF-8 bytes for Chinese navigation labels
$t_home     = $utf8.GetString([byte[]](0xe7, 0xbd, 0x91, 0xe7, 0xab, 0x99, 0xe9, 0xa6, 0x96, 0xe9, 0xa1, 0xb5)) # 网站首页
$t_ranking  = $utf8.GetString([byte[]](0xe6, 0x9c, 0xba, 0xe5, 0x9c, 0xba, 0xe6, 0x8e, 0x92, 0xe8, 0xa1, 0x8c)) # 机场排行
$t_tutorial = $utf8.GetString([byte[]](0xe5, 0xb0, 0x8f, 0xe7, 0x99, 0xbd, 0xe6, 0x95, 0x99, 0xe7, 0xa8, 0x8b)) # 小白教程
$t_articles = $utf8.GetString([byte[]](0xe6, 0x8a, 0x80, 0xe6, 0x9c, 0xaf, 0xe8, 0xaf, 0x84, 0xe6, 0xb5, 0x8b)) # 技术评测
$t_contact  = $utf8.GetString([byte[]](0xe5, 0x95, 0x86, 0xe5, 0x8a, 0xa1, 0xe5, 0x90, 0x88, 0xe4, 0xbd, 0x9c)) # 商务合作
$t_share    = $utf8.GetString([byte[]](0xe8, 0xb4, 0xa4, 0xe5, 0x8f, 0xb3, 0xe5, 0x90, 0x88, 0xe7, 0xa7, 0x9f, 0xe6, 0x8c, 0x87, 0xe5, 0x8d, 0x97)) # 账号合租指南
$t_links    = $utf8.GetString([byte[]](0xe5, 0x8f, 0x8b, 0xe6, 0x83, 0x85, 0xe8, 0xbf, 0x9e, 0xe6, 0x8e, 0xa5)) # 友情链接

function Set-NavMenu([string]$filePath, [string]$navHtml) {
    if (Test-Path $filePath) {
        $content = [System.IO.File]::ReadAllText($filePath, [System.Text.Encoding]::UTF8)
        $regex = '(?s)<div class="nav-menu" id="nav-menu">.*?(?=</nav>)'
        if ($content -match $regex) {
            $content = $content -replace $regex, $navHtml
            [System.IO.File]::WriteAllText($filePath, $content, [System.Text.Encoding]::UTF8)
            Write-Host "Updated navbar in: $([System.IO.Path]::GetFileName($filePath))"
        }
    }
}

function Build-Nav([string]$activeKey, [bool]$isSubdir) {
    $prefix = if ($isSubdir) { "../" } else { "" }
    
    $items = @(
        @{ href = "${prefix}index.html"; key = "index"; text = $t_home },
        @{ href = "${prefix}ranking.html"; key = "ranking"; text = $t_ranking },
        @{ href = "${prefix}tutorial.html"; key = "tutorial"; text = $t_tutorial },
        @{ href = "${prefix}articles.html"; key = "articles"; text = $t_articles },
        @{ href = "${prefix}contact.html"; key = "contact"; text = $t_contact },
        @{ href = "${prefix}share-guide.html"; key = "share-guide"; text = $t_share },
        @{ href = "${prefix}links.html"; key = "links"; text = $t_links }
    )
    
    $sb = New-Object System.Text.StringBuilder
    [void]$sb.AppendLine('<div class="nav-menu" id="nav-menu">')
    foreach ($item in $items) {
        $cls = if ($item.key -eq $activeKey) { ' class="active"' } else { '' }
        $line = "                <a href=`"$($item.href)`"$cls>$($item.text)</a>"
        [void]$sb.AppendLine($line)
    }
    [void]$sb.Append('            </div>' + "`n        ")
    return $sb.ToString()
}

$rootPages = @{
    "index.html" = "index"
    "ranking.html" = "ranking"
    "tutorial.html" = "tutorial"
    "articles.html" = "articles"
    "contact.html" = "contact"
    "share-guide.html" = "share-guide"
    "links.html" = "links"
}

foreach ($p in $rootPages.Keys) {
    $nav = Build-Nav -activeKey $rootPages[$p] -isSubdir $false
    Set-NavMenu -filePath (Join-Path $rootDir $p) -navHtml $nav
}

$articleFiles = Get-ChildItem -Path (Join-Path $rootDir "articles") -Filter "*.html"
$articleNav = Build-Nav -activeKey "articles" -isSubdir $true
foreach ($af in $articleFiles) {
    Set-NavMenu -filePath $af.FullName -navHtml $articleNav
}

Write-Host "`n✅ All navbars updated with exact UTF-8 byte sequences!"
