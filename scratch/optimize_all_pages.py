import os
import re
import json

workspace = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))

def get_html_files():
    html_files = []
    for root, dirs, files in os.walk(workspace):
        if ".git" in root or "scratch" in root:
            continue
        for f in files:
            if f.endswith(".html"):
                html_files.append(os.path.join(root, f))
    return html_files

aff_domains = [
    "kuailiaff", "edgenovaaff", "speedworldaff", "ytjcok", "shanhai.sbs", 
    "jsjc456789", "99vpn.bar", "kosingaff", "civetaff", "acceboy", "code="
]

faq_schema_data = {
    "@context": "https://schema.org",
    "@type": "FAQPage",
    "mainEntity": [
        {
            "@type": "Question",
            "name": "2026年选择加速机场核心看哪些指标？",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "选择机场时应优先关注晚高峰丢包率与网络抖动（小于2%为佳）、节点出口真实带宽（支持4K/8K无卡顿）、连接协议稳定性（如Shadowsocks, AnyTLS, Trojan, Hysteria2）以及服务商的注册运营年限与客服响应度。"
            }
        },
        {
            "@type": "Question",
            "name": "IPLC/IEPL专线与普通BGP中转机场有什么区别？",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "IPLC/IEPL是国际物理专线，数据不经过防火长城审查与过境公网，因此具有超低延迟、零丢包和高度耐封锁特点；而BGP中转成本较低，但在特殊时期可能受到国际出口波动影响。"
            }
        },
        {
            "@type": "Question",
            "name": "机场节点连接延迟多少毫秒算合格？",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "通常香港/台湾/日本中转节点延迟在 30ms - 80ms 之间体验极佳；新加坡/韩国节点 60ms - 110ms 表现良好；美西/欧洲专线节点 120ms - 180ms 属于正常范畴。网页打开速度主要取决于丢包率与首包响应（TTFB）。"
            }
        },
        {
            "@type": "Question",
            "name": "如何有效降低机场付费订阅“跑路”带来的损失？",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "建议新手或防范风险用户优先选择“月付”或“季付”套餐，尽量避免一次性购买多年长周期大额套餐；同时保留 1-2 个不同机场备用节点，确保关键时刻网络不中断。"
            }
        }
    ]
}

def process_file(filepath):
    rel_path = os.path.relpath(filepath, workspace).replace("\\", "/")
    is_root = ("/" not in rel_path)
    
    with open(filepath, "r", encoding="utf-8") as f:
        content = f.read()

    orig_content = content

    # 1. Fix robots meta tag (especially douyin page)
    if 'name="robots"' in content:
        content = re.sub(
            r'<meta\s+name="robots"\s+content="[^"]*"[^>]*>',
            '<meta name="robots" content="index, follow, max-image-preview:large, max-snippet:-1, max-video-preview:-1">',
            content
        )
    else:
        robots_tag = '    <meta name="robots" content="index, follow, max-image-preview:large, max-snippet:-1, max-video-preview:-1">\n'
        content = content.replace("<head>", "<head>\n" + robots_tag, 1)

    # 2. Fix fonts preconnect
    if "fonts.gstatic.com" not in content:
        preconnect_str = '    <link rel="preconnect" href="https://fonts.googleapis.com">\n    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>\n'
        content = content.replace("</title>", "</title>\n" + preconnect_str, 1)

    # 3. Canonical tag
    canonical_url = f"https://yzrztop.com/{rel_path}"
    if rel_path == "index.html":
        canonical_url = "https://yzrztop.com/"

    if '<link rel="canonical"' in content:
        content = re.sub(
            r'<link\s+rel="canonical"\s+href="[^"]*"[^>]*>',
            f'<link rel="canonical" href="{canonical_url}">',
            content
        )
    else:
        canonical_tag = f'    <link rel="canonical" href="{canonical_url}">\n'
        content = content.replace("</title>", "</title>\n" + canonical_tag, 1)

    # 4. OpenGraph & Twitter tags
    title_m = re.search(r'<title>(.*?)</title>', content, re.DOTALL)
    title_text = title_m.group(1).strip() if title_m else "椰汁网络日志"
    
    desc_m = re.search(r'<meta\s+name="description"\s+content="(.*?)"', content, re.DOTALL)
    desc_text = desc_m.group(1).strip() if desc_m else ""

    og_tags = f'''    <!-- Open Graph & Twitter Cards -->
    <meta property="og:site_name" content="椰汁网络日志">
    <meta property="og:locale" content="zh_CN">
    <meta property="og:title" content="{title_text}">
    <meta property="og:description" content="{desc_text}">
    <meta property="og:type" content="website">
    <meta property="og:url" content="{canonical_url}">
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:title" content="{title_text}">
    <meta name="twitter:description" content="{desc_text}">'''

    if 'property="og:site_name"' not in content:
        if 'property="og:title"' in content:
            # Replace existing basic OG block
            content = re.sub(
                r'<!-- Open Graph / Meta Cards -->.*?<meta property="og:url"[^>]*>',
                og_tags,
                content,
                flags=re.DOTALL
            )
        else:
            content = content.replace("</title>", "</title>\n" + og_tags + "\n", 1)

    # 5. BreadcrumbList for Articles
    if rel_path.startswith("articles/"):
        breadcrumb_schema = {
            "@context": "https://schema.org",
            "@type": "BreadcrumbList",
            "itemListElement": [
                {
                    "@type": "ListItem",
                    "position": 1,
                    "name": "首页",
                    "item": "https://yzrztop.com/"
                },
                {
                    "@type": "ListItem",
                    "position": 2,
                    "name": "技术评测文库",
                    "item": "https://yzrztop.com/articles.html"
                },
                {
                    "@type": "ListItem",
                    "position": 3,
                    "name": title_text.split(" - ")[0],
                    "item": canonical_url
                }
            ]
        }
        
        breadcrumb_script = f'\n    <!-- Breadcrumb Schema -->\n    <script type="application/ld+json">\n{json.dumps(breadcrumb_schema, ensure_ascii=False, indent=4)}\n    </script>\n'
        if '"@type": "BreadcrumbList"' not in content:
            content = content.replace("</head>", breadcrumb_script + "</head>", 1)

        # Enhance Author & Publisher in BlogPosting schema if present
        if '"@type": "BlogPosting"' in content or '"@type": "Article"' in content:
            if '"author"' not in content:
                content = content.replace(
                    '"@type": "BlogPosting",',
                    '"@type": "BlogPosting",\n                       "author": { "@type": "Organization", "name": "椰汁网络日志评测组", "url": "https://yzrztop.com/contact.html" },\n                       "publisher": { "@type": "Organization", "name": "椰汁网络日志", "logo": { "@type": "ImageObject", "url": "https://yzrztop.com/favicon.ico" } },'
                )

    # 6. FAQ Page Schema for ranking.html and 2026-airport-ranking.html
    if rel_path in ["ranking.html", "articles/2026-airport-ranking.html"]:
        if '"@type": "FAQPage"' not in content:
            faq_script = f'\n    <!-- FAQ Schema -->\n    <script type="application/ld+json">\n{json.dumps(faq_schema_data, ensure_ascii=False, indent=4)}\n    </script>\n'
            content = content.replace("</head>", faq_script + "</head>", 1)

    # 7. Affiliate Link Rel Compliance (nofollow sponsored noopener target=_blank)
    def update_a_tag(match):
        tag_str = match.group(0)
        is_aff = any(domain in tag_str for domain in aff_domains)
        if is_aff:
            if 'target=' not in tag_str:
                tag_str = tag_str.rstrip('>') + ' target="_blank">'
            if 'rel=' not in tag_str:
                tag_str = tag_str.rstrip('>') + ' rel="nofollow sponsored noopener">'
            else:
                tag_str = re.sub(r'rel="([^"]*)"', r'rel="nofollow sponsored noopener"', tag_str)
        return tag_str

    content = re.sub(r'<a\s+[^>]*href="http[^"]*"[^>]*>', update_a_tag, content)

    if content != orig_content:
        with open(filepath, "w", encoding="utf-8") as f:
            f.write(content)
        print(f"Updated: {rel_path}")

def main():
    files = get_html_files()
    print(f"Processing {len(files)} HTML files...")
    for f in files:
        process_file(f)
    print("All HTML optimization complete!")

if __name__ == "__main__":
    main()
