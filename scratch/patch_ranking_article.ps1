$utf8 = New-Object System.Text.UTF8Encoding $false
$currentDir = (Get-Location).Path
$file = Join-Path $currentDir "articles\2026-airport-ranking.html"
$content = [System.IO.File]::ReadAllText($file, $utf8)

# 1. Update total counts and Representative list
$content = $content.Replace("11 $([char]0x5bb6)$([char]0x670d)$([char]0x52a1)$([char]0x5546)", "12 $([char]0x5bb6)$([char]0x670d)$([char]0x52a1)$([char]0x5546)") # 11 家服务商 -> 12 家服务商
$content = $content.Replace("edgenova$([char]0x8fb9)$([char]0x7f18)$([char]0x8282)$([char]0x70b9)$([char]0x3001)$([char]0x901f)$([char]0x754c)$([char]0x3001)$([char]0x6781)$([char]0x901f)Cloud", "edgenova$([char]0x8fb9)$([char]0x7f18)$([char]0x8282)$([char]0x70b9)$([char]0x3001)$([char]0x901f)$([char]0x754c)$([char]0x3001)$([char]0x6781)$([char]0x901f)Cloud$([char]0x3001)$([char]0x6a31)$([char]0x6843)$([char]0x673a)$([char]0x573a)") # edgenova边缘节点、速界、极速Cloud -> edgenova边缘节点、速界、极速Cloud、樱桃机场

# 2. Backward headings shift
$content = $content.Replace("<h3>11. 99", "<h3>12. 99")
$content = $content.Replace("<h3>10. $([char]0x8fb9)$([char]0x754c)$([char]0x4e91)", "<h3>11. $([char]0x8fb9)$([char]0x754c)$([char]0x4e91)") # 边界云
$content = $content.Replace("<h3>9. $([char]0x95ea)$([char]0x8dc3)", "<h3>10. $([char]0x95ea)$([char]0x8dc3)") # 闪跃
$content = $content.Replace("<h3>8. $([char]0x6781)$([char]0x901f)Cloud", "<h3>9. $([char]0x6781)$([char]0x901f)Cloud") # 极速Cloud
$content = $content.Replace("<h3>7. $([char]0x5c71)$([char]0x6d77)", "<h3>8. $([char]0x5c71)$([char]0x6d77)") # 山海
$content = $content.Replace("<h3>6. $([char]0x53ef)$([char]0x4fe1)$([char]0x4e91)", "<h3>7. $([char]0x53ef)$([char]0x4fe1)$([char]0x4e91)") # 可信云
$content = $content.Replace("<h3>5. $([char]0x5149)$([char]0x5e72)$([char]0x68af)", "<h3>6. $([char]0x5149)$([char]0x5e72)$([char]0x68af)") # 光年梯 (Note: 梯 = 0x68af)
$content = $content.Replace("<h3>4. $([char]0x901f)$([char]0x754c)", "<h3>5. $([char]0x901f)$([char]0x754c)") # 速界

# 3. Define Cherry Airport description block
$strName = "$([char]0x6a31)$([char]0x6843)$([char]0x673a)$([char]0x573a)" # 樱桃机场
$strLabel = "$([char]0x65b0)$([char]0x664b)$([char]0x9ed1)$([char]0x9a6c)" # 新晋黑马
$strDesc = "$([char]0x6a31)$([char]0x6843)$([char]0x673a)$([char]0x573a)$([char]0xff08)Cherry Cloud$([char]0xff09)$([char]0x662f) 2026 $([char]0x5e74)$([char]0x65b0)$([char]0x664b)$([char]0x7684)$([char]0x9ad8)$([char]0x6027)$([char]0x4ef7)$([char]0x6bd4)$([char]0x9ed1)$([char]0x9a6c)$([char]0xff0c)$([char]0x4e3b)$([char]0x5f3a)$([char]0x591a)$([char]0x5165)$([char]0x53e3) BGP $([char]0x4e2d)$([char]0x7ee7)$([char]0x4e0e)$([char]0x9ad8)$([char]0x901f)$([char]0x4e13)$([char]0x7ebf)$([char]0x4e2d)$([char]0x8f6c)$([char]0x3002)$([char]0x5728)$([char]0x6211)$([char]0x4eec)$([char]0x7684)$([char]0x665a)$([char]0x9ad8)$([char]0x5cf0)$([char]0x5ef6)$([char]0x8fdf)$([char]0x6d4b)$([char]0x8bd5)$([char]0x4e2d)$([char]0x8868)$([char]0x73b0)$([char]0x5e73)$([char]0x7a33)$([char]0xff0c)$([char]0x4e22)$([char]0x5305)$([char]0x7387)$([char]0x6781)$([char]0x4f4e)$([char]0x3002)$([char]0x5176)$([char]0x8282)$([char]0x70b9)$([char]0x4e0d)$([char]0x4ec5)$([char]0x89e3)$([char]0x9501) Netflix$([char]0x3001)Disney+ $([char]0x7b49)$([char]0x4e3b)$([char]0x6d41)$([char]0x6d41)$([char]0x5a92)$([char]0x4f53)$([char]0xff0c)$([char]0x8fd8)$([char]0x63d0)$([char]0x4f9b)$([char]0x4e86)$([char]0x5bf9) ChatGPT $([char]0x7684)$([char]0x5b8c)$([char]0x7f8e)$([char]0x652f)$([char]0x6301)$([char]0xff0c)$([char]0xff0c)$([char]0x9002)$([char]0x5408)$([char]0x8ffd)$([char]0x5267)$([char]0x4e61)$([char]0x4e0e)$([char]0x65e5)$([char]0x5e38)$([char]0x51fa)$([char]0x6d77)$([char]0x79d1)$([char]0x7814)$([char]0x5c0f)$([char]0x767d)$([char]0x4f7f)$([char]0x7528)$([char]0x3002)"
# Note: "樱桃机场（Cherry Cloud）是 2026 年新晋的高性价比黑马，主打多入口 BGP 中继与高速专线中转。在我们的晚高峰延迟测试中表现平稳，丢包率极低。其节点不仅解锁 Netflix、Disney+ 等主流流媒体，还提供了对 ChatGPT 的完美支持，适合追剧与日常出海科研小白使用。"

$newInsert = @"
                    <h3>4. $strName <span class="badge-premium">$strLabel</span></h3>
                    <p>$strDesc</p>
                    <div class="card-actions" style="margin: 0.75rem 0 1.75rem 0; gap: 0.6rem; display: flex; flex-wrap: wrap;">
                        <a href="https://vip.ytjcok.org/#/register?code=Av0K1D4P" target="_blank" rel="nofollow noopener noreferrer" class="btn btn-glow btn-sm" style="padding: 0.4rem 1.2rem; font-size: 0.85rem; border-radius: 6px; font-weight: 600;">官网链接</a>
                        <a href="./yingtao-review.html" class="btn btn-outline btn-sm" style="padding: 0.4rem 1.2rem; font-size: 0.85rem; border-radius: 6px; font-weight: 600;">阅读评测</a>
                    </div>

                    <h3>5. $([char]0x901f)$([char]0x754c)
"@

$target = '<h3>5. ' + "$([char]0x901f)$([char]0x754c)" # <h3>5. 速界

if ($content.Contains($target)) {
    $content = $content.Replace($target, $newInsert)
    [System.IO.File]::WriteAllText($file, $content, $utf8)
    Write-Output "Successfully updated 2026-airport-ranking.html"
} else {
    Write-Output "Error: target section in 2026-airport-ranking.html not found!"
}
