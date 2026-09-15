import os

root_dir = r'c:\Users\Lenovo\Desktop\椰汁博客'
html_files = []
for r, d, f in os.walk(root_dir):
    if 'scratch' in r or '.git' in r:
        continue
    for file in f:
        if file.endswith('.html'):
            html_files.append(os.path.join(r, file))

count = 0
file_count = 0

for file_path in html_files:
    with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
        content = f.read()
    
    new_content = content.replace('>技术评测<', '>科学上网<')
    
    if new_content != content:
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(new_content)
        file_count += 1
        count += content.count('>技术评测<')

print(f'Updated {file_count} files, replaced {count} occurrences of >技术评测< with >科学上网<')
