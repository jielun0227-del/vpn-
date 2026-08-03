import os
import re
import json
import html

workspace_dir = r"c:\Users\Lenovo\Desktop\椰汁博客"

def clean_html(text):
    """Remove HTML tags and decode HTML entities."""
    text = re.sub(r'<[^>]+>', '', text)
    text = html.unescape(text)
    return text.strip()

def clean_question(text):
    """Clean numbering, icons, and emojis from heading text to make a natural question."""
    text = clean_html(text)
    # Remove emojis and symbols
    text = re.sub(r'^[^\w\u4e00-\u9fa5]+', '', text)
    # Remove Chinese numbering prefixes like "一、", "二、", "三、", "四、"
    text = re.sub(r'^[一二三四五六七八九十百]+[、\s\.]\s*', '', text)
    # Remove digit numbering prefixes like "1. ", "2. ", "1、"
    text = re.sub(r'^\d+[、\.\s]\s*', '', text)
    # Remove leading and trailing punctuation and spaces
    text = text.strip()
    return text

def extract_content_between(content, start_pos, end_pos):
    """Extract and clean text from p, li, blockquote tags within a text range."""
    segment = content[start_pos:end_pos]
    
    # Extract contents of p, li, and blockquotes
    matches = re.findall(r'<p>(.*?)</p>|<blockquote[^>]*>(.*?)</blockquote>|<li>(.*?)</li>', segment, re.DOTALL)
    texts = []
    for m in matches:
        # Take the matched group content (non-empty)
        val = next((item for item in m if item), "")
        val = clean_html(val)
        if len(val) > 15: # Skip too short text snippets
            texts.append(val)
            
    full_text = " ".join(texts)
    # Normalize whitespaces
    full_text = re.sub(r'\s+', ' ', full_text)
    
    # Truncate to maximum 350 characters for clean summaries
    if len(full_text) > 350:
        full_text = full_text[:350] + "..."
    return full_text.strip()

def process_file(file_path):
    rel_path = os.path.relpath(file_path, workspace_dir).replace('\\', '/')
    url = f"https://yzrztop.com/{rel_path}"
    if rel_path == "index.html":
        url = "https://yzrztop.com/"
        
    print(f"Optimizing SEO/GEO for: {rel_path}")
    
    with open(file_path, "r", encoding="utf-8") as f:
        content = f.read()
        
    # Extract metadata
    title_match = re.search(r'<title>(.*?)</title>', content)
    title = clean_html(title_match.group(1)) if title_match else "椰汁网络日志"
    # Remove site brand suffix for cleaner headline
    headline = title.replace(" - 椰汁网络日志", "")
    
    desc_match = re.search(r'<meta\s+name="description"\s+content="([^"]+)"', content, re.IGNORECASE)
    description = clean_html(desc_match.group(1)) if desc_match else ""
    
    # Determine the type of page and schemas to build
    schemas = []
    
    # 1. Base WebSite Schema for root pages, or Article Schema for article pages
    is_article = rel_path.startswith("articles/")
    
    if is_article:
        # Try to find date and author
        date_match = re.search(r'📅\s*发布日期：\s*(\d{4}-\d{2}-\d{2})', content)
        date_published = date_match.group(1) if date_match else "2026-07-15"
        
        author_match = re.search(r'👤\s*作者：\s*([^\s<]+)', content)
        author_name = clean_html(author_match.group(1)) if author_match else "椰汁评测组"
        
        article_schema = {
            "@type": "BlogPosting",
            "@id": f"{url}#article",
            "headline": headline,
            "description": description,
            "datePublished": date_published,
            "inLanguage": "zh-CN",
            "mainEntityOfPage": url,
            "author": {
                "@type": "Person",
                "name": author_name
            },
            "publisher": {
                "@type": "Organization",
                "name": "椰汁网络日志",
                "logo": {
                    "@type": "ImageObject",
                    "url": "https://yzrztop.com/favicon.ico"
                }
            }
        }
        schemas.append(article_schema)
    else:
        website_schema = {
            "@type": "WebSite",
            "@id": f"{url}#website",
            "url": url,
            "name": "椰汁网络日志",
            "description": description,
            "inLanguage": "zh-CN"
        }
        schemas.append(website_schema)
        
    # 2. Extract FAQ Schema
    faq_items = []
    
    if rel_path == "tutorial.html":
        # Parse tutorial.html specific .faq-item blocks
        faq_blocks = re.findall(r'<div class="faq-item">(.*?)</div>\s*</div>', content, re.DOTALL)
        # Fallback if the regex is too strict
        if not faq_blocks:
            faq_blocks = re.findall(r'<div class="faq-item">(.*?)</div>\s*</div>\s*</div>', content, re.DOTALL)
            
        # Let's find using start and end markers
        faq_starts = [m.start() for m in re.finditer(r'<div class="faq-item">', content)]
        for i, start in enumerate(faq_starts):
            # The block ends at the next start or at the end of the faq container
            end = faq_starts[i+1] if i+1 < len(faq_starts) else content.find('</div>\n        </div>\n    </div>', start)
            if end == -1 or end < start:
                end = start + 2000 # safeguard
            block = content[start:end]
            
            q_match = re.search(r'<div class="faq-question">\s*<span>(.*?)</span>', block, re.DOTALL)
            a_match = re.search(r'<div class="faq-answer-inner">(.*?)</div>', block, re.DOTALL)
            if q_match and a_match:
                question = clean_question(q_match.group(1))
                answer = clean_html(a_match.group(1))
                answer = re.sub(r'\s+', ' ', answer).strip()
                if question and answer:
                    faq_items.append({
                        "@type": "Question",
                        "name": question,
                        "acceptedAnswer": {
                            "@type": "Answer",
                            "text": answer
                        }
                    })
    elif is_article:
        # Parse headings (h2 and h3) and extract corresponding paragraphs as answers
        headings = []
        for m in re.finditer(r'<h[23][^>]*>(.*?)</h[23]>', content, re.DOTALL):
            h_text = clean_html(m.group(1))
            # Skip metadata summaries or generic endings like "相关推荐", "查看 2026 最新常用机场详细测速排行榜"
            if h_text in ["相关推荐", "常见问题", "相关阅读", "相关推荐", "导航"]:
                continue
            headings.append((m.start(), m.end(), h_text))
            
        # Accumulate QA pairs
        for idx, (h_start, h_end, h_text) in enumerate(headings):
            # Find boundary of this section (until the next heading or end of section)
            next_heading_start = headings[idx+1][0] if idx+1 < len(headings) else content.find('</section>', h_end)
            if next_heading_start == -1 or next_heading_start < h_end:
                next_heading_start = content.find('</article>', h_end)
            if next_heading_start == -1:
                next_heading_start = h_end + 3000 # safeguard
                
            q_name = clean_question(h_text)
            # Ensure it is a meaningful question-like heading or has content
            if not q_name or len(q_name) < 4:
                continue
                
            # If the heading doesn't end with a question mark, make it a natural question for GEO
            if not any(q_name.endswith(char) for char in ['？', '?', '。', '!']):
                # If it's a summary or buying guide, rephrase slightly in our schema or keep as is.
                # Keep as-is but add question mark if it fits
                if "为什么" in q_name or "如何" in q_name or "什么" in q_name or "哪里" in q_name or "怎么样" in q_name:
                    if not q_name.endswith('？'):
                        q_name += '？'
            
            a_text = extract_content_between(content, h_end, next_heading_start)
            if q_name and a_text and len(a_text) > 30:
                faq_items.append({
                    "@type": "Question",
                    "name": q_name,
                    "acceptedAnswer": {
                        "@type": "Answer",
                        "text": a_text
                    }
                })
                
    # If we extracted questions, add FAQPage schema
    if len(faq_items) >= 2:
        faq_schema = {
            "@type": "FAQPage",
            "mainEntity": faq_items
        }
        schemas.append(faq_schema)
        print(f"  Generated {len(faq_items)} FAQ items for FAQPage schema.")
        
    # Build complete JSON-LD script block
    json_ld_data = {
        "@context": "https://schema.org",
        "@graph": schemas
    }
    
    json_ld_str = json.dumps(json_ld_data, ensure_ascii=False, indent=2)
    
    script_block = f"""    <!-- JSON-LD Structured Data for SEO & GEO -->
    <script type="application/ld+json">
{json_ld_str}
    </script>
"""
    
    # Insert or replace script block in file
    # Check if there is already our comments or script block
    existing_pattern = r'\s*<!-- JSON-LD Structured Data for SEO & GEO -->.*?<\/script>\s*\n?'
    if re.search(existing_pattern, content, re.DOTALL):
        new_content = re.sub(existing_pattern, f"\n{script_block}", content, flags=re.DOTALL)
        print("  Replaced existing JSON-LD block.")
    else:
        # Look for standard script blocks if our comments weren't there
        existing_script_pattern = r'\s*<script type="application/ld\+json">.*?<\/script>\s*\n?'
        if re.search(existing_script_pattern, content, re.DOTALL):
            new_content = re.sub(existing_script_pattern, f"\n{script_block}", content, flags=re.DOTALL)
            print("  Replaced plain JSON-LD block.")
        else:
            # Insert before </head>
            new_content = content.replace("</head>", f"{script_block}</head>")
            print("  Inserted new JSON-LD block before </head>.")
            
    with open(file_path, "w", encoding="utf-8") as f:
        f.write(new_content)

def main():
    html_files = []
    for root, dirs, files in os.walk(workspace_dir):
        if ".git" in root or "scratch" in root:
            continue
        for file in files:
            if file.endswith(".html"):
                html_files.append(os.path.join(root, file))
                
    print(f"Found {len(html_files)} HTML files to process.")
    for file_path in html_files:
        try:
            process_file(file_path)
        except Exception as e:
            print(f"Error processing {file_path}: {e}")
            
    print("\nAll files successfully processed for SEO and GEO schema integration!")

if __name__ == "__main__":
    main()
