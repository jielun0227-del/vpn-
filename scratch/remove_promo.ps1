$utf8 = New-Object System.Text.UTF8Encoding $false
$currentDir = (Get-Location).Path

function Clean-HtmlFile($filePath) {
    $content = [System.IO.File]::ReadAllText($filePath, $utf8)
    
    # 1. 移除 nav-dropdown
    $patternDropdown = '(?s)<div class="nav-dropdown">.*?</div>\s*</div>'
    if ($content -match $patternDropdown) {
        # 只替换 nav-dropdown 部分
        $startIdx = $content.IndexOf('<div class="nav-dropdown">')
        $endIdx = $content.IndexOf('</div>', $startIdx)
        # 我们找 nav-dropdown 结束标签
        # 简单正则替换 nav-dropdown 块
        $regex = New-Object System.Text.RegularExpressions.Regex '(?s)\s*<div class="nav-dropdown">.*?</div>\s*</div>'
        # 更精确地，将 nav-dropdown 到 nav-menu 的结尾 </div> 之间的 dropdown 删掉，保留 nav-menu 结尾 </div>
    }
}
