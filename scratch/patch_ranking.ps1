$utf8 = New-Object System.Text.UTF8Encoding $false
$currentDir = (Get-Location).Path
$file = Join-Path $currentDir "ranking.html"
$content = [System.IO.File]::ReadAllText($file, $utf8)

# 1. Backward shift of rank numbers to avoid double-incrementing
$content = $content.Replace("rank: 11,", "rank: 12,")
$content = $content.Replace("rank: 10,", "rank: 11,")
$content = $content.Replace("rank: 9,", "rank: 10,")
$content = $content.Replace("rank: 8,", "rank: 9,")
$content = $content.Replace("rank: 7,", "rank: 8,")
$content = $content.Replace("rank: 6,", "rank: 7,")
$content = $content.Replace("rank: 5,", "rank: 6,")
$content = $content.Replace("rank: 4,", "rank: 5,")

# 2. Reconstruct Chinese strings using Unicode escape characters
$strName = "$([char]0x6a31)$([char]0x6843)$([char]0x673a)$([char]0x573a)" # 樱桃机场
$strProtocol = "Trojan / Shadowsocks"
$strLineType = "BGP $([char]0x591a)$([char]0x7ebf)$([char]0x4e2d)$([char]0x7ee7) + $([char]0x4e13)$([char]0x7ebf)$([char]0x4e2d)$([char]0x8f6c)" # BGP 多线中继 + 专线中转
$strUnlocks = "$([char]0x5e38)$([char]0x89c4)$([char]0x6d41)$([char]0x5a92)$([char]0x4f53)$([char]0x4e0e)AI$([char]0x5e73)$([char]0x53f0)$([char]0x5168)$([char]0x89e3)" # 常规流媒体与AI平台全解
$strRegions = "$([char]0x9999)$([char]0x6e2f)$([char]0x3001)$([char]0x65e5)$([char]0x672c)$([char]0x3001)$([char]0x65b0)$([char]0x52a0)$([char]0x5761)$([char]0x3001)$([char]0x7f8e)$([char]0x56fd)$([char]0x7b49)" # 香港、日本、新加坡、美国等
$strSlogan = "$([char]0xd83c)$([char]0xdf52) $([char]0x65b0)$([char]0x664b)$([char]0x9ed1)$([char]0x9a6c)$([char]0xff0c)$([char]0x9ad8)$([char]0x6027)$([char]0x4ef7)$([char]0x6bd4)$([char]0x591a)$([char]0x5165)$([char]0x53e3) BGP $([char]0x96a7)$([char]0x9053)$([char]0x4e2d)$([char]0x8f6c)" # 🍒 新晋黑马，高性价比多入口 BGP 隧道中转
$strEditorNote = "$([char]0x65b0)$([char]0x664b)$([char]0x9ed1)$([char]0x9a6c)$([char]0xff0c)$([char]0x63d0)$([char]0x4e9b)$([char]0x9ad8)$([char]0x6027)$([char]0x4ef7)$([char]0x6bd4)$([char]0x7684)$([char]0x96a7)$([char]0x9053)$([char]0x4e2d)$([char]0x8f6c)$([char]0x670d)$([char]0x52a1)$([char]0xff0c)$([char]0x8282)$([char]0x70b9)$([char]0x89e3)$([char]0x9501)$([char]0x8868)$([char]0x73b0)$([char]0x826f)$([char]0x597d)$([char]0xff0c)$([char]0x652f)$([char]0x6301) Netflix$([char]0x3001)Disney+$([char]0x53ca) ChatGPT$([char]0x3002)$([char]0x9002)$([char]0x5408)$([char]0x65e5)$([char]0x5e38)$([char]0x5a31)$([char]0x4e50)$([char]0x3001)$([char]0x8ffd)$([char]0x5267)$([char]0x4e0e)$([char]0x529e)$([char]0x516c)$([char]0x5c0f)$([char]0x767d)$([char]0x4f7f)$([char]0x7528)$([char]0x3002)"

$newEntry = @"
            {
                rank: 4,
                id: "yingtao",
                name: "$strName",
                price: 15,
                type: "transit",
                protocolLabel: "$strProtocol",
                lineType: "$strLineType",
                unlocks: "$strUnlocks",
                regions: "$strRegions",
                slogan: "$strSlogan",
                editorNote: "$strEditorNote",
                affLink: "https://vip.ytjcok.org/#/register?code=Av0K1D4P",
                reviewLink: "./articles/yingtao-review.html"
            },
            {
                rank: 5,
                id: "sujie",
"@

$pattern = '(?s)\{\s*rank: 5,\s*id: "sujie",'

if ($content -match $pattern) {
    $content = [regex]::Replace($content, $pattern, $newEntry)
    [System.IO.File]::WriteAllText($file, $content, $utf8)
    Write-Output "Successfully updated ranking.html"
} else {
    Write-Output "Error: target section in ranking.html not found!"
}
