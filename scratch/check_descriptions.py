import os
import re

html_files = []
for root, dirs, files in os.walk('.'):
    if '.git' in root:
        continue
    for f in files:
        if f.endswith('.html'):
            html_files.append(os.path.join(root, f))

results = []
for path in html_files:
    with open(path, 'r', encoding='utf-8', errors='ignore') as fp:
        content = fp.read()
    match = re.search(r'<meta\s+name=["\']description["\']\s+content=["\']([^"\']*)["\']', content, re.IGNORECASE)
    if not match:
        match = re.search(r'<meta\s+property=["\']og:description["\']\s+content=["\']([^"\']*)["\']', content, re.IGNORECASE)
    if match:
        desc = match.group(1)
        results.append((len(desc), path, desc))

results.sort(key=lambda x: x[0])
print(f"Total HTML files analyzed: {len(results)}\n")
for length, path, desc in results:
    print(f"[{length:3d} chars] {path}\n  -> {desc}\n")
