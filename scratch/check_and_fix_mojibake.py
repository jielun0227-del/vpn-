# -*- coding: utf-8 -*-
import os
import glob
import re

root_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
print(f"Workspace root: {root_dir}")

root_navs = {
    "index.html": '''<div class="nav-menu" id="nav-menu">
                <a href="index.html" class="active">网站首页</a>
                <a href="ranking.html">机场排行</a>
                <a href="tutorial.html">小白教程</a>
                <a href="articles.html">技术评测</a>
                <a href="contact.html">商务合作</a>
                <a href="share-guide.html">账号合租指南</a>
                <a href="links.html">友情链接</a>
            </div>''',
    "ranking.html": '''<div class="nav-menu" id="nav-menu">
                <a href="index.html">网站首页</a>
                <a href="ranking.html" class="active">机场排行</a>
                <a href="tutorial.html">小白教程</a>
                <a href="articles.html">技术评测</a>
                <a href="contact.html">商务合作</a>
                <a href="share-guide.html">账号合租指南</a>
                <a href="links.html">友情链接</a>
            </div>''',
    "tutorial.html": '''<div class="nav-menu" id="nav-menu">
                <a href="index.html">网站首页</a>
                <a href="ranking.html">机场排行</a>
                <a href="tutorial.html" class="active">小白教程</a>
                <a href="articles.html">技术评测</a>
                <a href="contact.html">商务合作</a>
                <a href="share-guide.html">账号合租指南</a>
                <a href="links.html">友情链接</a>
            </div>''',
    "articles.html": '''<div class="nav-menu" id="nav-menu">
                <a href="index.html">网站首页</a>
                <a href="ranking.html">机场排行</a>
                <a href="tutorial.html">小白教程</a>
                <a href="articles.html" class="active">技术评测</a>
                <a href="contact.html">商务合作</a>
                <a href="share-guide.html">账号合租指南</a>
                <a href="links.html">友情链接</a>
            </div>''',
    "contact.html": '''<div class="nav-menu" id="nav-menu">
                <a href="index.html">网站首页</a>
                <a href="ranking.html">机场排行</a>
                <a href="tutorial.html">小白教程</a>
                <a href="articles.html">技术评测</a>
                <a href="contact.html" class="active">商务合作</a>
                <a href="share-guide.html">账号合租指南</a>
                <a href="links.html">友情链接</a>
            </div>''',
    "share-guide.html": '''<div class="nav-menu" id="nav-menu">
                <a href="index.html">网站首页</a>
                <a href="ranking.html">机场排行</a>
                <a href="tutorial.html">小白教程</a>
                <a href="articles.html">技术评测</a>
                <a href="contact.html">商务合作</a>
                <a href="share-guide.html" class="active">账号合租指南</a>
                <a href="links.html">友情链接</a>
            </div>''',
    "links.html": '''<div class="nav-menu" id="nav-menu">
                <a href="index.html">网站首页</a>
                <a href="ranking.html">机场排行</a>
                <a href="tutorial.html">小白教程</a>
                <a href="articles.html">技术评测</a>
                <a href="contact.html">商务合作</a>
                <a href="share-guide.html">账号合租指南</a>
                <a href="links.html" class="active">友情链接</a>
            </div>'''
}

article_nav = '''<div class="nav-menu" id="nav-menu">
                <a href="../index.html">网站首页</a>
                <a href="../ranking.html">机场排行</a>
                <a href="../tutorial.html">小白教程</a>
                <a href="../articles.html" class="active">技术评测</a>
                <a href="../contact.html">商务合作</a>
                <a href="../share-guide.html">账号合租指南</a>
                <a href="../links.html">友情链接</a>
            </div>'''

# Replace nav-menu in all HTML files with clean UTF-8 text
for fname, nav_code in root_navs.items():
    fpath = os.path.join(root_dir, fname)
    if os.path.exists(fpath):
        with open(fpath, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read()
        
        content = re.sub(r'(?s)<div class="nav-menu" id="nav-menu">.*?(?=</nav>)', nav_code + '\n        ', content)
        with open(fpath, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"Replaced nav-menu cleanly in {fname}")

articles_dir = os.path.join(root_dir, 'articles')
for fpath in glob.glob(os.path.join(articles_dir, '*.html')):
    with open(fpath, 'r', encoding='utf-8', errors='ignore') as f:
        content = f.read()
    content = re.sub(r'(?s)<div class="nav-menu" id="nav-menu">.*?(?=</nav>)', article_nav + '\n        ', content)
    with open(fpath, 'w', encoding='utf-8') as f:
        f.write(content)
    print(f"Replaced nav-menu cleanly in {os.path.basename(fpath)}")

print("\n--- CHECKING FOR ANY MOJIBAKE / GARBLED TEXT ---")
html_files = glob.glob(os.path.join(root_dir, '*.html')) + glob.glob(os.path.join(articles_dir, '*.html'))
mojibake_chars = ['缃', '鏈哄満', '鎶€鏈', '灏┲', '鍟嗗姟', '璐﹀彿', '鍙嬫儏', '棣栭〉', '鏁欑▼', '鎸囧崡']

found_mojibake = []
for fpath in html_files:
    with open(fpath, 'r', encoding='utf-8', errors='ignore') as f:
        text = f.read()
    for mb in mojibake_chars:
        if mb in text:
            found_mojibake.append((os.path.relpath(fpath, root_dir), mb))
            break

if not found_mojibake:
    print("✅ PERFECT: All HTML files checked and 0 mojibake/garbled text found!")
else:
    print(f"❌ FOUND MOJIBAKE IN {len(found_mojibake)} FILES:")
    for fn, mb in found_mojibake:
        print(f"  - {fn} (contains '{mb}')")
