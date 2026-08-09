import os

base_dir = r"c:\Users\Lenovo\Desktop\椰汁博客"

def clean_file(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    changed = False

    # 1. 移除 <div class="nav-dropdown"> ... </div>
    target_nav_dropdown = '<div class="nav-dropdown">'
    if target_nav_dropdown in content:
        start = content.find(target_nav_dropdown)
        # nav-dropdown is right before </div>\n        </nav>
        end = content.find('</div>\n            </div>\n        </nav>', start)
        if end != -1:
            end_cut = end + 7 # include first </div>
            content = content[:start] + content[end_cut:]
            changed = True
        else:
            # 尝试通过 </nav> 定位
            nav_end = content.find('</nav>', start)
            if nav_end != -1:
                # nav-menu closing div is just before </nav>
                last_div_before_nav = content.rfind('</div>', start, nav_end)
                second_last_div = content.rfind('</div>', start, last_div_before_nav)
                if second_last_div != -1:
                    content = content[:start] + content[second_last_div + 6:]
                    changed = True

    # 2. 移除 Modal
    modal_tag = '<!-- 专属优惠码 Modal 弹窗 -->'
    if modal_tag in content:
        m_start = content.find(modal_tag)
        m_end = content.find('</body>', m_start)
        if m_end != -1:
            content = content[:m_start] + content[m_end:]
            changed = True

    if changed:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"Cleaned {os.path.basename(filepath)}")

for file in os.listdir(base_dir):
    if file.endswith('.html'):
        clean_file(os.path.join(base_dir, file))

articles_dir = os.path.join(base_dir, 'articles')
if os.path.exists(articles_dir):
    for file in os.listdir(articles_dir):
        if file.endswith('.html'):
            clean_file(os.path.join(articles_dir, file))
