# PowerShell script to place 2026 Shadowrocket guide as TOP 1 in index.html and articles.html

$utf8NoBom = New-Object System.Text.UTF8Encoding $false
$workspaceDir = (Get-Location).Path

$top1CardArticles = @"
                <!-- 文章1: 2026 苹果必装神器 小火箭指南 (TOP #1) -->
                <article class="article-card" style="border: 1px solid var(--primary);">
                    <div class="article-card-body">
                        <div class="article-meta">
                            <span style="background: linear-gradient(135deg, #ff416c, #ff4b2b); color: #fff; padding: 0.15rem 0.5rem; border-radius: 4px; font-weight: 800; font-size: 0.75rem;">TOP 1</span>
                            <span>📅 2026-08-20</span>
                            <span>🏷️ iOS 必装神器</span>
                        </div>
                        <h3>2026 苹果必装神器！Shadowrocket（小火箭）极速配置与高速节点深度指南</h3>
                        <p>在 iOS 生态中，Shadowrocket（小火箭）公认为代理神器。手把手教你 3 分钟一键导入订阅、配置 Config 智能分流与排障自查，剖析专线机场与免费节点体验差距，附带快狸 8 折专属优惠码 kl888...</p>
                        <a href="articles/shadowrocket-guide.html" class="article-more">
                            阅读全文 (4500字干货)
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M5 12h14M12 5l7 7-7 7"/></svg>
                        </a>
                    </div>
                </article>
"@

# Update articles.html
$articlesPath = Join-Path $workspaceDir "articles.html"
$articlesContent = [System.IO.File]::ReadAllText($articlesPath, [System.Text.Encoding]::UTF8)

$articlesContent = [regex]::Replace($articlesContent, '(?s)<!--.*?小火箭.*?-->\s*<article class="article-card"[\s\S]*?</article>', '')
$articlesContent = $articlesContent.Replace('<div class="article-grid">', "<div class=`"article-grid`">`n$top1CardArticles")
[System.IO.File]::WriteAllText($articlesPath, $articlesContent, $utf8NoBom)
Write-Host "Updated articles.html: Shadowrocket guide placed as TOP 1" -ForegroundColor Green
