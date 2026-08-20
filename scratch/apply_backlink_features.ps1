# PowerShell script to inject Friendly Links in Footer and Citation Backlink Card into all HTML files

$utf8NoBom = New-Object System.Text.UTF8Encoding $false
$workspaceDir = (Get-Location).Path

# 1. Update contact.html to include Backlink Exchange Section
$contactPath = Join-Path $workspaceDir "contact.html"
if (Test-Path $contactPath) {
    $contactHtml = [System.IO.File]::ReadAllText($contactPath, [System.Text.Encoding]::UTF8)
    
    $linkExchangeBlock = @"
        <!-- 友情链接与反向链接互换 -->
        <section class="card link-exchange-card" style="margin-top: 2rem; padding: 2rem; background: rgba(255, 255, 255, 0.03); border: 1px solid var(--border-color); border-radius: 12px;" id="link-exchange">
            <h3 style="font-size: 1.25rem; margin-bottom: 1rem; color: var(--primary); display: flex; align-items: center; gap: 0.5rem;">
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M10 13a5 5 0 0 0 7.54.54l3-3a5 5 0 0 0-7.07-7.07l-1.72 1.71"></path><path d="M14 11a5 5 0 0 0-7.54-.54l-3 3a5 5 0 0 0 7.07 7.07l1.71-1.71"></path></svg>
                🔗 友情链接互换与入站反向链接建设 (Link Exchange)
            </h3>
            <p style="font-size: 0.95rem; color: var(--text-secondary); line-height: 1.6; margin-bottom: 1.2rem;">
                为了共同提升网站域名权重与搜索引擎收录权威度，椰汁网络日志长期欢迎正规科技博客、网络技术文库、VPN评测及代理工具类网站交换首页/内页友情链接。
            </p>
            <div style="background: rgba(0, 0, 0, 0.2); padding: 1.2rem; border-radius: 8px; border: 1px solid rgba(255, 255, 255, 0.08); margin-bottom: 1.2rem;">
                <h4 style="font-size: 0.95rem; color: var(--primary); margin-bottom: 0.6rem;">本站友链信息：</h4>
                <ul style="font-size: 0.9rem; color: var(--text-secondary); line-height: 1.8; list-style: none; padding-left: 0;">
                    <li><strong>网站名称：</strong> 椰汁网络日志</li>
                    <li><strong>网站网址：</strong> https://yzrztop.com/</li>
                    <li><strong>网站描述：</strong> 2026年稳定网络加速服务与优质专线机场推荐评测指南</li>
                    <li><strong>Icon / Icon 地址：</strong> https://yzrztop.com/favicon.ico</li>
                </ul>
            </div>
            <div style="display: flex; flex-direction: column; gap: 0.8rem;">
                <label style="font-size: 0.88rem; color: var(--text-secondary);">HTML 格式友情链接代码 (点击全选复制)：</label>
                <input type="text" readonly value='<a href="https://yzrztop.com/" target="_blank" title="椰汁网络日志 - 2026年稳定网络加速服务与优质专线机场推荐">椰汁网络日志</a>' onclick="this.select()" style="width: 100%; padding: 0.6rem; font-size: 0.85rem; background: rgba(0,0,0,0.3); border: 1px solid var(--border-color); border-radius: 6px; color: var(--primary); font-family: monospace;">
                <label style="font-size: 0.88rem; color: var(--text-secondary);">Markdown 格式链接代码：</label>
                <input type="text" readonly value="[椰汁网络日志](https://yzrztop.com/)" onclick="this.select()" style="width: 100%; padding: 0.6rem; font-size: 0.85rem; background: rgba(0,0,0,0.3); border: 1px solid var(--border-color); border-radius: 6px; color: var(--primary); font-family: monospace;">
            </div>
            <p style="font-size: 0.88rem; color: var(--text-muted); margin-top: 1rem;">
                添加本站链接后，请将您的网站名称、网址及描述发送至邮箱 <a href="mailto:jielun0227@gmail.com" style="color: var(--primary);">jielun0227@gmail.com</a>，我们将在 24 小时内完成审核并回链！
            </p>
        </section>
"@
    
    if ($contactHtml -notlike '*link-exchange*') {
        $contactHtml = $contactHtml.Replace("</main>", "$linkExchangeBlock`n</main>")
        [System.IO.File]::WriteAllText($contactPath, $contactHtml, $utf8NoBom)
        Write-Host "Added Backlink Exchange section to contact.html" -ForegroundColor Green
    }
}

# 2. Add Citation Backlink Card to all articles
$htmlFiles = Get-ChildItem -Path $workspaceDir -Filter "*.html" -Recurse | Where-Object {
    $_.FullName -notlike "*\.git\*" -and $_.FullName -notlike "*\scratch\*"
}

foreach ($file in $htmlFiles) {
    $filePath = $file.FullName
    $relPath = $filePath.Substring($workspaceDir.Length + 1).Replace('\', '/')
    
    $content = [System.IO.File]::ReadAllText($filePath, [System.Text.Encoding]::UTF8)
    $origContent = $content
    
    if ($relPath.StartsWith("articles/")) {
        if ($content -notlike '*article-share-box*') {
            $titleMatch = [regex]::Match($content, '(?s)<title>(.*?)</title>')
            $articleTitle = if ($titleMatch.Success) { $titleMatch.Groups[1].Value.Split('-')[0].Trim() } else { "网络代理评测" }
            $canonicalUrl = "https://yzrztop.com/$relPath"
            
            $citationCard = @"
                    <!-- 引用本文与反向链接生成器 -->
                    <div class="article-share-box" style="margin: 2.5rem 0; padding: 1.5rem; background: rgba(0, 150, 199, 0.04); border: 1px solid var(--border-color); border-radius: 10px;">
                        <h4 style="margin-bottom: 0.8rem; font-size: 1rem; color: var(--primary); display: flex; align-items: center; gap: 0.5rem;">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M10 13a5 5 0 0 0 7.54.54l3-3a5 5 0 0 0-7.07-7.07l-1.72 1.71"></path><path d="M14 11a5 5 0 0 0-7.54-.54l-3 3a5 5 0 0 0 7.07 7.07l1.71-1.71"></path></svg>
                            引用本文与反向链接 (Cite & Backlink)
                        </h4>
                        <p style="font-size: 0.88rem; color: var(--text-secondary); margin-bottom: 1rem; line-height: 1.6;">
                            欢迎各大技术博客、论坛与开发者社区引用本文内容！复制下方 HTML 或 Markdown 代码可在您的站点上直接建立回链：
                        </p>
                        <div style="display: flex; flex-direction: column; gap: 0.6rem;">
                            <label style="font-size: 0.8rem; color: var(--text-muted);">Markdown 格式引用代码：</label>
                            <input type="text" readonly value="[$articleTitle]($canonicalUrl)" onclick="this.select()" style="width: 100%; padding: 0.5rem 0.8rem; font-size: 0.82rem; background: rgba(0,0,0,0.25); border: 1px solid rgba(255,255,255,0.1); border-radius: 4px; color: var(--primary); font-family: monospace;">
                            <label style="font-size: 0.8rem; color: var(--text-muted);">HTML 格式引用代码：</label>
                            <input type="text" readonly value='<a href="$canonicalUrl" target="_blank" title="$articleTitle - 椰汁网络日志">$articleTitle</a>' onclick="this.select()" style="width: 100%; padding: 0.5rem 0.8rem; font-size: 0.82rem; background: rgba(0,0,0,0.25); border: 1px solid rgba(255,255,255,0.1); border-radius: 4px; color: var(--primary); font-family: monospace;">
                        </div>
                    </div>
"@
            if ($content -like '*</article>*') {
                $content = $content.Replace("</article>", "$citationCard`n</article>")
            }
        }
    }
    
    # 3. Add Friendly Links entry in footer nav
    if ($content -notlike '*<a href="https://yzrztop.com/contact.html#link-exchange"*' -and $content -notlike '*<a href="../contact.html#link-exchange"*') {
        $contactHref = if ($relPath.StartsWith("articles/")) { "../contact.html#link-exchange" } else { "contact.html#link-exchange" }
        $friendCol = @"
                <div class="footer-nav-col">
                    <h4>友情链接</h4>
                    <a href="$contactHref">申请友链 / 提交反向链接</a>
                </div>
"@
        if ($content -like '*<div class="footer-nav-col">*') {
            $content = [regex]::Replace($content, '(<div class="footer-links">[\s\S]*?<div class="footer-nav-col">[\s\S]*?</div>)', "$1`n$friendCol", [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
        }
    }
    
    if ($content -ne $origContent) {
        [System.IO.File]::WriteAllText($filePath, $content, $utf8NoBom)
        Write-Host "Updated backlink engine: $relPath" -ForegroundColor Green
    }
}

Write-Host "Backlink engine & citation cards applied successfully!" -ForegroundColor Cyan
