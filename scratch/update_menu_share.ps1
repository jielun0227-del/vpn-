$jsonPath = "C:\Users\Lenovo\.gemini\antigravity-ide\brain\4a183e3b-c462-4b97-a5f0-dd3d0883fb6a\scratch\chinese_strings.json"
$utf8 = [System.Text.Encoding]::UTF8
$jsonContent = [System.IO.File]::ReadAllText($jsonPath, $utf8)
$strings = ConvertFrom-Json $jsonContent

$menuNames = $strings.menu_names

function Get-Root-Nav($activePage, $names) {
    $menu = '            <div class="nav-menu" id="nav-menu">' + "`r`n"
    
    $pages = @(
        @("index.html", $names[0]),
        @("ranking.html", $names[1]),
        @("tutorial.html", $names[2]),
        @("articles.html", $names[3]),
        @("ai-guide.html", $names[4]),
        @("contact.html", $names[5]),
        @("share-guide.html", $names[6])
    )
    
    foreach ($p in $pages) {
        $href = $p[0]
        $name = $p[1]
        if ($href -eq $activePage) {
            $menu += "                <a href=`"$href`" class=`"active`">$name</a>`r`n"
        } else {
            $menu += "                <a href=`"$href`">$name</a>`r`n"
        }
    }
    
    $menu += '            </div>'
    return $menu
}

function Get-Sub-Nav($names) {
    $menu = '            <div class="nav-menu" id="nav-menu">' + "`r`n"
    $menu += '                <a href="../index.html">' + $names[0] + '</a>' + "`r`n"
    $menu += '                <a href="../ranking.html">' + $names[1] + '</a>' + "`r`n"
    $menu += '                <a href="../tutorial.html">' + $names[2] + '</a>' + "`r`n"
    $menu += '                <a href="../articles.html" class="active">' + $names[3] + '</a>' + "`r`n"
    $menu += '                <a href="../ai-guide.html">' + $names[4] + '</a>' + "`r`n"
    $menu += '                <a href="../contact.html">' + $names[5] + '</a>' + "`r`n"
    $menu += '                <a href="../share-guide.html">' + $names[6] + '</a>' + "`r`n"
    $menu += '            </div>'
    return $menu
}

# Update root files
$rootPages = @(
    @("index.html", "index.html"),
    @("ranking.html", "ranking.html"),
    @("tutorial.html", "tutorial.html"),
    @("articles.html", "articles.html"),
    @("ai-guide.html", "ai-guide.html"),
    @("contact.html", "contact.html"),
    @("share-guide.html", "share-guide.html")
)

foreach ($rp in $rootPages) {
    $file = $rp[0]
    $active = $rp[1]
    if (Test-Path $file) {
        $text = [System.IO.File]::ReadAllText($file, $utf8)
        
        # 1. Update Header Nav Menu
        $pattern = '(?s)<div class="nav-menu" id="nav-menu">.*?</div>'
        $newNav = Get-Root-Nav $active $menuNames
        $text = [System.Text.RegularExpressions.Regex]::Replace($text, $pattern, $newNav)
        
        # 2. Update Footer Col 1 (if share-guide.html not already in footer)
        if (-not $text.Contains('share-guide.html"')) {
            $footerPattern1 = '(?s)(\s+)(<a href="ai-guide\.html">AI指南</a>)(\s+)(</div>)'
            $footerReplacement1 = '$1$2$1<a href="share-guide.html">账号合租指南</a>$3$4'
            $text = [System.Text.RegularExpressions.Regex]::Replace($text, $footerPattern1, $footerReplacement1)
            
            # 3. Update Footer Col 3
            $footerPattern3 = '(?s)(\s+)(<a href="ai-guide\.html">AI指南</a>)(\s+)(<a href="contact\.html">商务对接</a>)'
            $footerReplacement3 = '$1$2$1<a href="share-guide.html">账号合租指南</a>$3$4'
            $text = [System.Text.RegularExpressions.Regex]::Replace($text, $footerPattern3, $footerReplacement3)
        }
        
        [System.IO.File]::WriteAllText($file, $text, $utf8)
        Write-Output "Updated root file: $file"
    }
}

# Update sub-articles
$articleFiles = Get-ChildItem -Path "articles" -Filter "*.html"
foreach ($fileObj in $articleFiles) {
    $file = $fileObj.FullName
    $text = [System.IO.File]::ReadAllText($file, $utf8)
    
    # 1. Update Header Nav Menu
    $pattern = '(?s)<div class="nav-menu" id="nav-menu">.*?</div>'
    $newNav = Get-Sub-Nav $menuNames
    $text = [System.Text.RegularExpressions.Regex]::Replace($text, $pattern, $newNav)
    
    # 2. Update Footer Col 1
    if (-not $text.Contains('share-guide.html"')) {
        $footerPattern1 = '(?s)(\s+)(<a href="\.\./ai-guide\.html">AI指南</a>)(\s+)(</div>)'
        $footerReplacement1 = '$1$2$1<a href="../share-guide.html">账号合租指南</a>$3$4'
        $text = [System.Text.RegularExpressions.Regex]::Replace($text, $footerPattern1, $footerReplacement1)
        
        # 3. Update Footer Col 3
        $footerPattern3 = '(?s)(\s+)(<a href="\.\./ai-guide\.html">AI指南</a>)(\s+)(<a href="\.\./contact\.html">商务对接</a>)'
        $footerReplacement3 = '$1$2$1<a href="../share-guide.html">账号合租指南</a>$3$4'
        $text = [System.Text.RegularExpressions.Regex]::Replace($text, $footerPattern3, $footerReplacement3)
    }
    
    [System.IO.File]::WriteAllText($file, $text, $utf8)
    Write-Output "Updated sub-article: $($fileObj.Name)"
}
