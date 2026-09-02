# gen_nav.ps1
$rootDir = Split-Path -Parent $PSScriptRoot
$utf8 = [System.Text.Encoding]::UTF8

$h_home     = [byte[]](231, 189, 145, 231, 171, 153, 233, 166, 150, 233, 161, 181)
$h_ranking  = [byte[]](236, 156, 186, 229, 156, 186, 230, 142, 146, 232, 161, 140)
$h_tutorial = [byte[]](229, 176, 143, 231, 153, 189, 230, 149, 153, 231, 168, 139)
$h_articles = [byte[]](230, 138, 128, 230, 156, 175, 232, 175, 132, 236, 181, 140)
$h_contact  = [byte[]](229, 149, 134, 229, 138, 161, 229, 144, 136, 228, 189, 156)
$h_share    = [byte[]](238, 184, 164, 229, 143, 183, 229, 144, 136, 231, 167, 159, 230, 140, 135, 229, 141, 157)
$h_links    = [byte[]](229, 143, 139, 230, 131, 133, 233, 147, 190, 236, 142, 165)

# Wait! Let's get the exact bytes directly from .NET System.Text.Encoding UTF-8!
$t_home     = $utf8.GetString([System.Text.Encoding]::UTF8.GetBytes("网站首页"))
$t_ranking  = $utf8.GetString([System.Text.Encoding]::UTF8.GetBytes("机场排行"))
$t_tutorial = $utf8.GetString([System.Text.Encoding]::UTF8.GetBytes("小白教程"))
$t_articles = $utf8.GetString([System.Text.Encoding]::UTF8.GetBytes("技术评测"))
$t_contact  = $utf8.GetString([System.Text.Encoding]::UTF8.GetBytes("商务合作"))
$t_share    = $utf8.GetString([System.Text.Encoding]::UTF8.GetBytes("账号合租指南"))
$t_links    = $utf8.GetString([System.Text.Encoding]::UTF8.GetBytes("友情链接"))

function Set-NavMenu([string]$filePath, [string]$navHtml) {
    if (Test-Path $filePath) {
        $content = [System.IO.File]::ReadAllText($filePath, [System.Text.Encoding]::UTF8)
        $regex = '(?s)<div class="nav-menu" id="nav-menu">.*?(?=</nav>)'
        if ($content -match $regex) {
            $content = $content -replace $regex, $navHtml
            [System.IO.File]::WriteAllText($filePath, $content, [System.Text.Encoding]::UTF8)
            Write-Host "Cleaned navbar in: $([System.IO.Path]::GetFileName($filePath))"
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

Write-Host "navbars generated!"
