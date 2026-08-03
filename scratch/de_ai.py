import os
import re

workspace_dir = r"c:\Users\Lenovo\Desktop\椰汁博客"

def process_html_file(file_path):
    print(f"Processing: {file_path}")
    with open(file_path, "r", encoding="utf-8") as f:
        content = f.read()

    # 1. Remove navigation link in header, footer or sidebar
    # Handle both absolute/relative links like "ai-guide.html" and "../ai-guide.html"
    content = re.sub(
        r'\s*<a href="(?:\.\./)?ai-guide\.html"[^>]*>AI指南</a>\s*\n?',
        '\n',
        content
    )

    # 2. Specifically for articles.html: Remove the entire AI指南 card block
    if "articles.html" in file_path:
        # Find the card container for AI指南
        # We look for the comment <!-- AI指南文章 --> followed by the article block and remove it
        pattern = r'\s*<!-- AI指南文章 -->\s*<article class="article-card">.*?</article>\s*\n?'
        content, count = re.subn(pattern, '\n', content, flags=re.DOTALL)
        if count > 0:
            print(f"  Removed AI指南 card block from articles.html")

    # 3. Clean up double/multiple empty lines that might have been introduced
    content = re.sub(r'\n\s*\n\s*\n', '\n\n', content)

    with open(file_path, "w", encoding="utf-8") as f:
        f.write(content)

def main():
    # Delete the ai-guide.html file if it exists
    ai_guide_path = os.path.join(workspace_dir, "ai-guide.html")
    if os.path.exists(ai_guide_path):
        os.remove(ai_guide_path)
        print("Deleted ai-guide.html")
    else:
        print("ai-guide.html not found (already deleted?)")

    # Update sitemap.xml
    sitemap_path = os.path.join(workspace_dir, "sitemap.xml")
    if os.path.exists(sitemap_path):
        print("Processing sitemap.xml")
        with open(sitemap_path, "r", encoding="utf-8") as f:
            sitemap_content = f.read()
        
        # Remove the <url> block containing ai-guide.html
        sitemap_pattern = r'\s*<url>\s*<loc>https://yzrztop\.com/ai-guide\.html</loc>.*?</url>\s*\n?'
        sitemap_content, count = re.subn(sitemap_pattern, '\n', sitemap_content, flags=re.DOTALL)
        if count > 0:
            print("  Removed ai-guide.html entry from sitemap.xml")
            
        with open(sitemap_path, "w", encoding="utf-8") as f:
            f.write(sitemap_content)

    # Process all root HTML files
    for root, dirs, files in os.walk(workspace_dir):
        # Skip git folders or scratch
        if ".git" in root or "scratch" in root:
            continue
        for file in files:
            if file.endswith(".html"):
                file_path = os.path.join(root, file)
                process_html_file(file_path)

    # Update verify_menus.ps1 script
    verify_script_path = os.path.join(workspace_dir, "scratch", "verify_menus.ps1")
    if os.path.exists(verify_script_path):
        print("Processing verify_menus.ps1")
        with open(verify_script_path, "r", encoding="utf-8") as f:
            script_content = f.read()

        # Update rootFiles array to exclude "ai-guide.html"
        script_content = script_content.replace('"ai-guide.html", ', '')
        
        # Update linkCount checks from 7 to 6
        script_content = script_content.replace('$linkCount -ne 7', '$linkCount -ne 6')

        with open(verify_script_path, "w", encoding="utf-8") as f:
            f.write(script_content)
        print("  Updated verify_menus.ps1 script to expect 6 nav links and skip ai-guide.html")

if __name__ == "__main__":
    main()
