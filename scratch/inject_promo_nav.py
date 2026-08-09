import os

modal_html = """
    <!-- 专属优惠码 Modal 弹窗 -->
    <div class="promo-modal-overlay" id="promo-modal-overlay" onclick="if(event.target===this)closePromoModal();">
        <div class="promo-modal-box">
            <button class="promo-modal-close" onclick="closePromoModal();" aria-label="关闭">&times;</button>
            <div class="promo-modal-title">
                <span>🎁</span> 站长独家专属优惠码
            </div>
            <div class="promo-modal-desc">已为您整理主流优质机场最新折扣码，点击右侧即可一键复制！</div>
            <div class="promo-modal-list">
                <div class="promo-modal-item">
                    <div class="promo-item-info">
                        <span class="promo-item-name">⚡ edgenova 边缘节点</span>
                        <span class="promo-item-sub">全场 8 折限时折扣优惠码</span>
                    </div>
                    <button class="promo-item-btn" onclick="copyPromoCode('xk808', 'edgenova')">
                        <span>xk808</span>
                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="9" y="9" width="13" height="13" rx="2" ry="2"/><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"/></svg>
                    </button>
                </div>
                <div class="promo-modal-item">
                    <div class="promo-item-info">
                        <span class="promo-item-name">🐱 快狸机场</span>
                        <span class="promo-item-sub">IEPL 专线特惠套餐折扣码</span>
                    </div>
                    <button class="promo-item-btn" onclick="copyPromoCode('kl888', '快狸机场')">
                        <span>kl888</span>
                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="9" y="9" width="13" height="13" rx="2" ry="2"/><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"/></svg>
                    </button>
                </div>
                <div class="promo-modal-item">
                    <div class="promo-item-info">
                        <span class="promo-item-name">🚀 速界机场</span>
                        <span class="promo-item-sub">Hysteria 2 万兆爆速专线折扣码</span>
                    </div>
                    <button class="promo-item-btn" onclick="copyPromoCode('sujie888', '速界机场')">
                        <span>sujie888</span>
                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="9" y="9" width="13" height="13" rx="2" ry="2"/><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"/></svg>
                    </button>
                </div>
                <div class="promo-modal-item">
                    <div class="promo-item-info">
                        <span class="promo-item-name">🔗 极连云</span>
                        <span class="promo-item-sub">BGP 多线中继高性价比优惠码</span>
                    </div>
                    <button class="promo-item-btn" onclick="copyPromoCode('jly888', '极连云')">
                        <span>jly888</span>
                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="9" y="9" width="13" height="13" rx="2" ry="2"/><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"/></svg>
                    </button>
                </div>
                <div class="promo-modal-item">
                    <div class="promo-item-info">
                        <span class="promo-item-name">☁️ 云图机场</span>
                        <span class="promo-item-sub">新用户首购特惠折扣码</span>
                    </div>
                    <button class="promo-item-btn" onclick="copyPromoCode('yt88', '云图机场')">
                        <span>yt88</span>
                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="9" y="9" width="13" height="13" rx="2" ry="2"/><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"/></svg>
                    </button>
                </div>
                <div class="promo-modal-item">
                    <div class="promo-item-info">
                        <span class="promo-item-name">⚡ 闪跃机场</span>
                        <span class="promo-item-sub">极速专线月付体验折扣码</span>
                    </div>
                    <button class="promo-item-btn" onclick="copyPromoCode('shanyue', '闪跃机场')">
                        <span>shanyue</span>
                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="9" y="9" width="13" height="13" rx="2" ry="2"/><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"/></svg>
                    </button>
                </div>
            </div>
        </div>
    </div>
"""

nav_dropdown_item = """
                <div class="nav-dropdown">
                    <a href="javascript:void(0);" onclick="openPromoModal();" class="nav-dropdown-toggle">
                        <span>🎁 专属优惠码</span>
                        <span class="arrow-icon">▼</span>
                    </a>
                    <div class="nav-dropdown-menu">
                        <div class="nav-dropdown-header">
                            <span>热门机场折扣码</span>
                            <span>点击复制</span>
                        </div>
                        <div class="dropdown-item">
                            <span class="dropdown-item-name">edgenova</span>
                            <span class="dropdown-item-code" onclick="copyPromoCode('xk808', 'edgenova');event.stopPropagation();">xk808</span>
                        </div>
                        <div class="dropdown-item">
                            <span class="dropdown-item-name">快狸机场</span>
                            <span class="dropdown-item-code" onclick="copyPromoCode('kl888', '快狸机场');event.stopPropagation();">kl888</span>
                        </div>
                        <div class="dropdown-item">
                            <span class="dropdown-item-name">速界机场</span>
                            <span class="dropdown-item-code" onclick="copyPromoCode('sujie888', '速界机场');event.stopPropagation();">sujie888</span>
                        </div>
                        <div class="dropdown-item">
                            <span class="dropdown-item-name">极连云</span>
                            <span class="dropdown-item-code" onclick="copyPromoCode('jly888', '极连云');event.stopPropagation();">jly888</span>
                        </div>
                        <div class="dropdown-item">
                            <span class="dropdown-item-name">云图机场</span>
                            <span class="dropdown-item-code" onclick="copyPromoCode('yt88', '云图机场');event.stopPropagation();">yt88</span>
                        </div>
                        <div class="dropdown-item">
                            <span class="dropdown-item-name">闪跃机场</span>
                            <span class="dropdown-item-code" onclick="copyPromoCode('shanyue', '闪跃机场');event.stopPropagation();">shanyue</span>
                        </div>
                    </div>
                </div>
"""

def process_file(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    if 'openPromoModal' in content and 'promo-modal-overlay' in content:
        return

    # Target the closing </div> of nav-menu
    target_str = '账号合租指南</a>'
    if target_str in content:
        content = content.replace(target_str, target_str + '\n' + nav_dropdown_item.strip())

    if '</body>' in content and 'promo-modal-overlay' not in content:
        content = content.replace('</body>', modal_html.strip() + '\n</body>')

    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(content)
    print(f"Successfully updated {os.path.basename(filepath)}")

base_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

for file in os.listdir(base_dir):
    if file.endswith('.html'):
        process_file(os.path.join(base_dir, file))

articles_dir = os.path.join(base_dir, 'articles')
if os.path.exists(articles_dir):
    for file in os.listdir(articles_dir):
        if file.endswith('.html'):
            process_file(os.path.join(articles_dir, file))
