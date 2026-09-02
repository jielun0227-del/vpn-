# fix_comments.ps1
$rootDir = "c:\Users\Lenovo\Desktop\椰汁博客"
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

$badComment = "<!-- 蹇嫺鏈哄満鎺ㄨ崘鏉垮潡 -->"
$goodComment = [System.Text.Encoding]::UTF8.GetString([byte[]](0x3c,0x21,0x2d,0x2d,0x20,0xe5,0xbf,0xab,0xe8,0xbf,0x9e,0xe6,0x9c,0xba,0xe5,0x9c,0xba,0xe6,0x8e,0xa5,0xe8,0x8d,0x90,0xe6,0x9d,0xbf,0xe5,0x9d,0x97,0x20,0x2d,0x2d,0x3e)) # <!-- 快连机场推荐板块 -->

$articleFiles = Get-ChildItem -Path (Join-Path $rootDir "articles") -Filter "*.html"

foreach ($file in $articleFiles) {
    $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    if ($content.Contains($badComment)) {
        $content = $content.Replace($badComment, $goodComment)
        [System.IO.File]::WriteAllText($file.FullName, $content, $utf8NoBom)
        Write-Host "Fixed comment in: $($file.Name)"
    }
}

Write-Host "Done fixing garbled HTML comments!"
