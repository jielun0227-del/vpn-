# PowerShell script to place 2026 Shadowrocket guide as TOP 1 in index.html and articles.html

$utf8NoBom = New-Object System.Text.UTF8Encoding $false
$workspaceDir = (Get-Location).Path

$top1CardIndex = @"
                <!-- 文章1: 2026 苹果必装神器 小火箭指南 (TOP #1) -->
                <article class="blog-post-card">
                    <div class="post-card-content">
                        <h3 class="post-title">
                            <span class="post-badge" style="background: linear-gradient(135deg, #ff416c, #ff4b2b); color: #fff; font-weight: 800;">TOP 1</span>
                            <a href="articles/shadowrocket-guide.html">2026 苹果必装神器！Shadowrocket（小火箭）极速配置与高速节点深度指南</a>
                        </h3>
                        <div class="post-meta">
                            <span class="meta-item"><span class="meta-icon">📁</span>客户端教程</span>
                            <span class="meta-item"><span class="meta-icon">⏱️</span>约 2500 字</span>
                            <span class="meta-item"><span class="meta-icon">📅</span>2026-08-20</span>
                            <span class="meta-item"><span class="meta-icon">🏷️</span>Shadowrocket, 小火箭配置, iOS科学上网, 专线节点, 快狸8折</span>
                        </div>
                        <div class="post-excerpt">
                            <p>在 iOS 生态中，Shadowrocket（小火箭）一直被公认为网络代理工具里的“性价比天花板”。小火箭只是一辆顶级超跑，而“节点（机场）”才是注入的燃油！本文手把手教你 3 分钟一键导入订阅、智能分流路由配置与排障指南，附带快狸专线专属 8 折优惠码 kl888...</p>
                        </div>
                        <div class="post-footer">
                            <a href="articles/shadowrocket-guide.html" class="btn btn-glow">阅读全文 &rarr;</a>
                        </div>
                    </div>
                </article>
"@

$top1CardArticles = @"
                <!-- 文章1: 2026 苹果必装神器 小火箭指南 (TOP #1) -->
                <article class="blog-post-card">
                    <div class="post-card-content">
                        <h3 class="post-title">
                            <span class="post-badge" style="background: linear-gradient(135deg, #ff416c, #ff4b2b); color: #fff; font-weight: 800;">TOP 1</span>
                            <a href="articles/shadowrocket-guide.html">2026 苹果必装神器！Shadowrocket（小火箭）极速配置与高速节点深度指南</a>
                        </h3>
                        <div class="post-meta">
                            <span class="meta-item"><span class="meta-icon">📁</span>客户端教程</span>
                            <span class="meta-item"><span class="meta-icon">⏱️</span>约 2500 字</span>
                            <span class="meta-item"><span class="meta-icon">📅</span>2026-08-20</span>
                            <span class="meta-item"><span class="meta-icon">🏷️</span>Shadowrocket, 小火箭配置, iOS科学上网, 专线节点, 快狸8折</span>
                        </div>
                        <div class="post-excerpt">
                            <p>在 iOS 生态中，Shadowrocket（小火箭）一直被公认为网络代理工具里的“性价比天花板”。小火箭只是一辆顶级超跑，而“节点（机场）”才是注入的燃油！本文手把手教你 3 分钟一键导入订阅、智能分流路由配置与排障指南，附带快狸专线专属 8 折优惠码 kl888...</p>
                        </div>
                        <div class="post-footer">
                            <a href="articles/shadowrocket-guide.html" class="btn btn-glow">阅读全文 &rarr;</a>
                        </div>
                    </div>
                </article>
"@

# 1. Update index.html
$indexPath = Join-Path $workspaceDir "index.html"
$indexContent = [System.IO.File]::ReadAllText($indexPath, [System.Text.Encoding]::UTF8)

# Remove any existing shadowrocket-guide card if present
$indexContent = [regex]::Replace($indexContent, '(?s)<!--.*?小火箭.*?-->\s*<article class="blog-post-card">[\s\S]*?<a href="articles/shadowrocket-guide\.html"[\s\S]*?</article>', '')
$indexContent = [regex]::Replace($indexContent, '(?s)<article class="blog-post-card">[\s\S]*?<a href="articles/shadowrocket-guide\.html"[\s\S]*?</article>', '')

$indexContent = $indexContent.Replace('<div class="blog-feed-container">', "<div class=`"blog-feed-container`">`n$top1CardIndex")
[System.IO.File]::WriteAllText($indexPath, $indexContent, $utf8NoBom)
Write-Host "Updated index.html: Shadowrocket guide placed as TOP 1 in blog-feed-container" -ForegroundColor Green

# 2. Update articles.html
$articlesPath = Join-Path $workspaceDir "articles.html"
$articlesContent = [System.IO.File]::ReadAllText($articlesPath, [System.Text.Encoding]::UTF8)

$articlesContent = [regex]::Replace($articlesContent, '(?s)<!--.*?小火箭.*?-->\s*<article class="blog-post-card">[\s\S]*?<a href="articles/shadowrocket-guide\.html"[\s\S]*?</article>', '')
$articlesContent = [regex]::Replace($articlesContent, '(?s)<article class="blog-post-card">[\s\S]*?<a href="articles/shadowrocket-guide\.html"[\s\S]*?</article>', '')

$articlesContent = $articlesContent.Replace('<div class="articles-grid">', "<div class=`"articles-grid`">`n$top1CardArticles")
[System.IO.File]::WriteAllText($articlesPath, $articlesContent, $utf8NoBom)
Write-Host "Updated articles.html: Shadowrocket guide placed as TOP 1 in articles-grid" -ForegroundColor Green

Write-Host "Top article placement finished!" -ForegroundColor Cyan
