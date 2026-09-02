# -*- coding: utf-8 -*-
import os
import glob
import re

root_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
print(f"Workspace root: {root_dir}")

# 1. Update index.html
index_path = os.path.join(root_dir, "index.html")
if os.path.exists(index_path):
    with open(index_path, "r", encoding="utf-8") as f:
        content = f.read()

    # Remove friendly-links-section
    content = re.sub(r'(?s)<!-- 友情链接专属板块 -->\s*<section class="friendly-links-section" id="friendly-links">.*?</section>', '', content)

    # Update nav
    content = content.replace(
        '<a href="share-guide.html">账号合租指南</a>\n            </div>',
        '<a href="share-guide.html">账号合租指南</a>\n                <a href="links.html">友情链接</a>\n            </div>'
    )

    # Update footer
    old_footer = '''<div class="footer-nav-col">
                    <h4>友情链接</h4>
                    <a href="contact.html#link-exchange">申请友链 / 提交反向链接</a>
                </div>'''
    new_footer = '''<div class="footer-nav-col">
                    <h4>友情链接</h4>
                    <a href="links.html">友情链接大全</a>
                    <a href="links.html#link-exchange">申请友链 / 提交反向链接</a>
                </div>'''
    content = content.replace(old_footer, new_footer)

    with open(index_path, "w", encoding="utf-8") as f:
        f.write(content)
    print("Updated index.html cleanly")

# 2. Update other root HTML files
root_pages = ["ranking.html", "tutorial.html", "articles.html", "contact.html", "share-guide.html"]

old_footer = '''<div class="footer-nav-col">
                    <h4>友情链接</h4>
                    <a href="contact.html#link-exchange">申请友链 / 提交反向链接</a>
                </div>'''
new_footer = '''<div class="footer-nav-col">
                    <h4>友情链接</h4>
                    <a href="links.html">友情链接大全</a>
                    <a href="links.html#link-exchange">申请友链 / 提交反向链接</a>
                </div>'''

for page in root_pages:
    fpath = os.path.join(root_dir, page)
    if os.path.exists(fpath):
        with open(fpath, "r", encoding="utf-8") as f:
            content = f.read()

        # Update nav menu
        content = content.replace(
            '<a href="share-guide.html">账号合租指南</a>\n            </div>',
            '<a href="share-guide.html">账号合租指南</a>\n                <a href="links.html">友情链接</a>\n            </div>'
        )
        content = content.replace(
            '<a href="share-guide.html" class="active">账号合租指南</a>\n            </div>',
            '<a href="share-guide.html" class="active">账号合租指南</a>\n                <a href="links.html">友情链接</a>\n            </div>'
        )

        # Update footer
        content = content.replace(old_footer, new_footer)

        with open(fpath, "w", encoding="utf-8") as f:
            f.write(content)
        print(f"Updated {page} cleanly")

# 3. Update articles/*.html
articles_dir = os.path.join(root_dir, "articles")

old_art_footer1 = '''<div class="footer-nav-col">
                    <h4>友情链接</h4>
                    <a href="contact.html#link-exchange">申请友链 / 提交反向链接</a>
                </div>'''
old_art_footer2 = '''<div class="footer-nav-col">
                    <h4>友情链接</h4>
                    <a href="../contact.html#link-exchange">申请友链 / 提交反向链接</a>
                </div>'''
new_art_footer = '''<div class="footer-nav-col">
                    <h4>友情链接</h4>
                    <a href="../links.html">友情链接大全</a>
                    <a href="../links.html#link-exchange">申请友链 / 提交反向链接</a>
                </div>'''

for fpath in glob.glob(os.path.join(articles_dir, "*.html")):
    with open(fpath, "r", encoding="utf-8") as f:
        content = f.read()

    # Update nav
    content = content.replace(
        '<a href="../share-guide.html">账号合租指南</a>\n            </div>',
        '<a href="../share-guide.html">账号合租指南</a>\n                <a href="../links.html">友情链接</a>\n            </div>'
    )

    # Update footer
    content = content.replace(old_art_footer1, new_art_footer)
    content = content.replace(old_art_footer2, new_art_footer)

    with open(fpath, "w", encoding="utf-8") as f:
        f.write(content)
    print(f"Updated article {os.path.basename(fpath)} cleanly")

print("\n✅ All HTML files updated cleanly with Python UTF-8!")
