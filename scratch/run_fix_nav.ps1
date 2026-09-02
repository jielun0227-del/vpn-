# UTF-8 BOM Script
$rootDir = Split-Path -Parent $PSScriptRoot

$t_home     = "网站首页"
$t_ranking  = "机场排行"
$t_tutorial = "小白教程"
$t_articles = "技术评测"
$t_contact  = "商务合作"
$t_share    = "账号合租指南"
$t_links    = "友情链接"

function Set-NavMenu([string]$filePath, [string]$navHtml) {
    if (Test-Path $filePath) {
        $content = [System.IO.File]::ReadAllText($filePath, [System.Text.Encoding]::UTF8)
        $regex = '(?s)<div class="nav-menu" id="nav-menu">.*?(?=</nav>)'
        if ($content -match $regex) {
            $content = $content -replace $regex, $navHtml
            # Use UTF8 with BOM so PowerShell/Browsers read it cleanly
            $utf8Bom = New-Object System.Text.UTF8Encoding($false)
            [System.IO.File]::WriteAllText($filePath, $content, $utf8Bom)
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

Write-Host "`n✅ All navbars updated cleanly!"
