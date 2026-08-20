# PowerShell script to add 无忧链接 (Wuyou Link) as #10 in ranking.html, 2026-airport-ranking.html, and articles.html

$utf8NoBom = New-Object System.Text.UTF8Encoding $false
$workspaceDir = (Get-Location).Path

# 1. Update ranking.html
$rankingPath = Join-Path $workspaceDir "ranking.html"
$rankingContent = [System.IO.File]::ReadAllText($rankingPath, [System.Text.Encoding]::UTF8)

$wuyouItem = @"
            {
                rank: 10,
                id: "wuyoulianjie",
                name: "无忧链接",
                price: 6,
                type: "dedicated",
                protocolLabel: "新 Vless 协议 / Sing-box / Clash",
                lineType: "IPLC 物理专线",
                unlocks: "ChatGPT / Gemini / TikTok / Netflix 全解",
                regions: "港台新日美、东南亚小众及欧美国家",
                slogan: "🚀 IPLC 专线 + 新 Vless 协议，海外团队全天在线客服",
                editorNote: "配置 IPLC 物理专线与新 Vless 协议，海外团队运营支持全天客服。完美解锁 ChatGPT、Gemini 等 AI 平台及 TikTok、Netflix 等海外流媒体。无倍率不限速不限设备，提供低至 6 元/月轻量套餐，专线稳定高效。特惠码 wuyou666 享 6.8 折。",
                affLink: "https://wep01.worryfreeaff.com/#/?code=30yg9KJh",
                reviewLink: "./articles/wuyoulianjie-review.html"
            },
"@

# Update ranks 10 to 14 in ranking.html
if ($rankingContent -notlike '*id: "wuyoulianjie"*') {
    # Insert wuyou before rank 10 (shanhai) and increment shanhai, jisucloud, flashleap, bianjieyun, jiujiuba ranks
    $rankingContent = $rankingContent.Replace('rank: 10,', 'rank: 11,')
    $rankingContent = $rankingContent.Replace('rank: 11,', 'rank: 12,')
    $rankingContent = $rankingContent.Replace('rank: 12,', 'rank: 13,')
    $rankingContent = $rankingContent.Replace('rank: 13,', 'rank: 14,')
    $rankingContent = $rankingContent.Replace('rank: 14,', 'rank: 15,')
    
    $rankingContent = $rankingContent.Replace('id: "shanhai",', "$wuyouItem`n            id: `"shanhai`",")
    
    [System.IO.File]::WriteAllText($rankingPath, $rankingContent, $utf8NoBom)
    Write-Host "Updated ranking.html with 无忧链接 as #10" -ForegroundColor Green
}

# 2. Update articles/2026-airport-ranking.html
$rankArticlePath = Join-Path $workspaceDir "articles/2026-airport-ranking.html"
$rankArtContent = [System.IO.File]::ReadAllText($rankArticlePath, [System.Text.Encoding]::UTF8)

$wuyouSection = @"
                    <h3>10. 无忧链接 <span class="badge-premium">IPLC 专线 / Vless</span></h3>
                    <p>无忧链接（Wuyou Link）是由海外专业团队运营的优质 IPLC 专线机场，部署了新一代 <strong>Vless 协议</strong>。支持全平台一键导入，完美解锁 ChatGPT、Gemini 等 AI 工具以及 TikTok、Netflix、Disney+ 流媒体。包含低至 6 元/月的轻量套餐，无倍率不限速不限设备。输入特惠码 <strong>wuyou666</strong> 可享 6.8 折优惠。</p>
                    <div class="card-actions" style="margin: 0.75rem 0 1.75rem 0; gap: 0.6rem; display: flex; flex-wrap: wrap;">
                        <a href="https://wep01.worryfreeaff.com/#/?code=30yg9KJh" target="_blank" rel="nofollow sponsored noopener" class="btn btn-glow btn-sm" style="padding: 0.4rem 1.2rem; font-size: 0.85rem; border-radius: 6px; font-weight: 600;">官网链接</a>
                        <a href="./wuyoulianjie-review.html" class="btn btn-outline btn-sm" style="padding: 0.4rem 1.2rem; font-size: 0.85rem; border-radius: 6px; font-weight: 600;">阅读评测</a>
                    </div>

"@

if ($rankArtContent -notlike '*wuyoulianjie-review.html*') {
    # Increment numbers 10 -> 11, 11 -> 12, etc.
    $rankArtContent = $rankArtContent.Replace('<h3>10. 山海机场', '<h3>11. 山海机场')
    $rankArtContent = $rankArtContent.Replace('<h3>11. 极速Cloud', '<h3>12. 极速Cloud')
    $rankArtContent = $rankArtContent.Replace('<h3>12. 闪跃机场', '<h3>13. 闪跃机场')
    $rankArtContent = $rankArtContent.Replace('<h3>13. 边界云加速器', '<h3>14. 边界云加速器')
    $rankArtContent = $rankArtContent.Replace('<h3>14. 99吧', '<h3>15. 99吧')
    
    # Update tier 2 list in table
    $rankArtContent = $rankArtContent.Replace('edgenova边缘节点、速界、二猫云、灵猫网络、极速Cloud、云图机场', 'edgenova边缘节点、速界、无忧链接、二猫云、灵猫网络、极速Cloud、云图机场')
    
    $rankArtContent = $rankArtContent.Replace('<h3>11. 山海机场', "$wuyouSection`n                    <h3>11. 山海机场")
    
    [System.IO.File]::WriteAllText($rankArticlePath, $rankArtContent, $utf8NoBom)
    Write-Host "Updated 2026-airport-ranking.html with 无忧链接 as #10" -ForegroundColor Green
}

# 3. Update articles.html grid
$articlesPath = Join-Path $workspaceDir "articles.html"
$articlesContent = [System.IO.File]::ReadAllText($articlesPath, [System.Text.Encoding]::UTF8)

$wuyouCard = @"
                <!-- 无忧链接机场评测 -->
                <article class="blog-post-card">
                    <div class="post-card-content">
                        <h3 class="post-title">
                            <span class="post-badge">NEW</span>
                            <a href="articles/wuyoulianjie-review.html">【IPLC专线】无忧链接深度测评：新Vless协议与低至6元/月超值套餐实测！</a>
                        </h3>
                        <div class="post-meta">
                            <span class="meta-item"><span class="meta-icon">📁</span>机场评测</span>
                            <span class="meta-item"><span class="meta-icon">⏱️</span>约 1500 字</span>
                            <span class="meta-item"><span class="meta-icon">📅</span>2026-08-20</span>
                            <span class="meta-item"><span class="meta-icon">🏷️</span>无忧链接, IPLC专线, Vless协议, TikTok解锁</span>
                        </div>
                        <div class="post-excerpt">
                            <p>寻找一款“低至6元/月起步、IPLC专线传输、新Vless协议且全天客服在线”的优质代理？无忧链接（Wuyou Link）基于全物理专线打造，完美解锁 ChatGPT、Gemini 与 TikTok/Netflix。输入独家优惠码 wuyou666 即可享受全线 6.8 折特惠...</p>
                        </div>
                        <div class="post-footer">
                            <a href="articles/wuyoulianjie-review.html" class="btn btn-outline">阅读全文 &rarr;</a>
                        </div>
                    </div>
                </article>

"@

if ($articlesContent -notlike '*wuyoulianjie-review.html*') {
    $articlesContent = $articlesContent.Replace('<div class="articles-grid">', "<div class=`"articles-grid`">`n$wuyouCard")
    [System.IO.File]::WriteAllText($articlesPath, $articlesContent, $utf8NoBom)
    Write-Host "Updated articles.html with 无忧链接 review card" -ForegroundColor Green
}

# 4. Update index.html post list
$indexPath = Join-Path $workspaceDir "index.html"
$indexContent = [System.IO.File]::ReadAllText($indexPath, [System.Text.Encoding]::UTF8)

if ($indexContent -notlike '*wuyoulianjie-review.html*') {
    $indexContent = $indexContent.Replace('<div class="articles-grid">', "<div class=`"articles-grid`">`n$wuyouCard")
    [System.IO.File]::WriteAllText($indexPath, $indexContent, $utf8NoBom)
    Write-Host "Updated index.html with 无忧链接 card" -ForegroundColor Green
}

Write-Host "All airport ranking files updated successfully!" -ForegroundColor Cyan
