# fix_all_navbars.ps1
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

$rootDir = Split-Path -Parent $PSScriptRoot
Write-Host "Workspace Root Directory: $rootDir"

# Function to replace nav-menu block
function Update-NavMenu {
    param (
        [string]$filePath,
        [string]$newNavHtml
    )
    if (Test-Path $filePath) {
        $content = [System.IO.File]::ReadAllText($filePath, [System.Text.Encoding]::UTF8)
        # Regex to match from <div class="nav-menu" id="nav-menu"> to before </nav>
        $regex = '(?s)<div class="nav-menu" id="nav-menu">.*?(?=</nav>)'
        if ($content -match $regex) {
            $content = $content -replace $regex, $newNavHtml
            [System.IO.File]::WriteAllText($filePath, $content, [System.Text.Encoding]::UTF8)
            Write-Host "Cleaned navbar in: $([System.IO.Path]::GetFileName($filePath))"
        } else {
            Write-Host "Warning: nav-menu pattern not matched in $filePath" -ForegroundColor Yellow
        }
    }
}

# 1. Root Pages
$rootNavs = @{
    "index.html" = '<div class="nav-menu" id="nav-menu">
                <a href="index.html" class="active">网站首页</a>
                <a href="ranking.html">机场排行</a>
                <a href="tutorial.html">小白教程</a>
                <a href="articles.html">技术评测</a>
                <a href="contact.html">商务合作</a>
                <a href="share-guide.html">账号合租指南</a>
                <a href="links.html">友情链接</a>
            </div>
        '
    "ranking.html" = '<div class="nav-menu" id="nav-menu">
                <a href="index.html">网站首页</a>
                <a href="ranking.html" class="active">机场排行</a>
                <a href="tutorial.html">小白教程</a>
                <a href="articles.html">技术评测</a>
                <a href="contact.html">商务合作</a>
                <a href="share-guide.html">账号合租指南</a>
                <a href="links.html">友情链接</a>
            </div>
        '
    "tutorial.html" = '<div class="nav-menu" id="nav-menu">
                <a href="index.html">网站首页</a>
                <a href="ranking.html">机场排行</a>
                <a href="tutorial.html" class="active">小白教程</a>
                <a href="articles.html">技术评测</a>
                <a href="contact.html">商务合作</a>
                <a href="share-guide.html">账号合租指南</a>
                <a href="links.html">友情链接</a>
            </div>
        '
    "articles.html" = '<div class="nav-menu" id="nav-menu">
                <a href="index.html">网站首页</a>
                <a href="ranking.html">机场排行</a>
                <a href="tutorial.html">小白教程</a>
                <a href="articles.html" class="active">技术评测</a>
                <a href="contact.html">商务合作</a>
                <a href="share-guide.html">账号合租指南</a>
                <a href="links.html">友情链接</a>
            </div>
        '
    "contact.html" = '<div class="nav-menu" id="nav-menu">
                <a href="index.html">网站首页</a>
                <a href="ranking.html">机场排行</a>
                <a href="tutorial.html">小白教程</a>
                <a href="articles.html">技术评测</a>
                <a href="contact.html" class="active">商务合作</a>
                <a href="share-guide.html">账号合租指南</a>
                <a href="links.html">友情链接</a>
            </div>
        '
    "share-guide.html" = '<div class="nav-menu" id="nav-menu">
                <a href="index.html">网站首页</a>
                <a href="ranking.html">机场排行</a>
                <a href="tutorial.html">小白教程</a>
                <a href="articles.html">技术评测</a>
                <a href="contact.html">商务合作</a>
                <a href="share-guide.html" class="active">账号合租指南</a>
                <a href="links.html">友情链接</a>
            </div>
        '
    "links.html" = '<div class="nav-menu" id="nav-menu">
                <a href="index.html">网站首页</a>
                <a href="ranking.html">机场排行</a>
                <a href="tutorial.html">小白教程</a>
                <a href="articles.html">技术评测</a>
                <a href="contact.html">商务合作</a>
                <a href="share-guide.html">账号合租指南</a>
                <a href="links.html" class="active">友情链接</a>
            </div>
        '
}

foreach ($key in $rootNavs.Keys) {
    Update-NavMenu -filePath (Join-Path $rootDir $key) -newNavHtml $rootNavs[$key]
}

# 2. Articles Directory
$articlesDir = Join-Path $rootDir "articles"
$articleFiles = Get-ChildItem -Path $articlesDir -Filter "*.html"

$articleNavHtml = '<div class="nav-menu" id="nav-menu">
                <a href="../index.html">网站首页</a>
                <a href="../ranking.html">机场排行</a>
                <a href="../tutorial.html">小白教程</a>
                <a href="../articles.html" class="active">技术评测</a>
                <a href="../contact.html">商务合作</a>
                <a href="../share-guide.html">账号合租指南</a>
                <a href="../links.html">友情链接</a>
            </div>
        '

foreach ($file in $articleFiles) {
    Update-NavMenu -filePath $file.FullName -newNavHtml $articleNavHtml
}

Write-Host "`nAll navbars cleaned and updated successfully!" -ForegroundColor Green
