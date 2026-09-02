# fix_nav_base64.ps1
$rootDir = Split-Path -Parent $PSScriptRoot

function B64ToUtf8([string]$b64) {
    $bytes = [System.Convert]::FromBase64String($b64)
    return [System.Text.Encoding]::UTF8.GetString($bytes)
}

# Base64 strings for Chinese titles
$t_home = B64ToUtf8 "572R57uZ6aaW6aG1"
$t_ranking = B64ToUtf8 "5py65Zy65o6S6KGM"
$t_tutorial = B64ToUtf8 "5bCP55m95pWZ56iL"
$t_articles = B64ToUtf8 "5oqA5pyv6K-E5rWL"
$t_contact = B64ToUtf8 "5ZWG5Yqh5ZCI5L2c"
$t_share = B64ToUtf8 "6LSm5Y+35ZCI56ef5oyH5Y2X"
$t_links = B64ToUtf8 "5Y+L5oOF6L+e5o6l"

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

Write-Host "`n✅ All navbars updated cleanly with guaranteed UTF-8 Base64 strings!"
