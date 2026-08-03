import glob
import os

promo_html = """                    <!-- 快狸机场推荐板块 -->
                    <div class="promo-box" style="margin-top: 2rem; padding: 1.5rem; background: rgba(0, 150, 199, 0.04); border: 1px dashed var(--primary); border-radius: 12px; text-align: center; box-shadow: 0 4px 20px rgba(0, 150, 199, 0.08);">
                        <h4 style="margin: 0 0 0.8rem 0; color: var(--primary); font-size: 1.2rem; display: flex; align-items: center; justify-content: center; gap: 0.5rem;">
                            🚀 椰汁评测组强力推荐：备用与主力首选方案
                        </h4>
                        <p style="font-size: 0.95rem; color: var(--text-secondary); line-height: 1.6; margin: 0 0 1.2rem 0; text-align: left;">
                            如果您目前使用的节点频繁超时、变慢或 IP 被风控（无法正常访问 ChatGPT / TikTok 等），推荐使用 <strong>快狸机场 (Quick Li)</strong>。其核心搭载企业级 IEPL 专线与 AnyTLS 去特征协议，晚高峰 0 丢包，支持原生住宅 IP，<strong>15 元起月付</strong>。
                        </p>
                        <div style="display: flex; flex-wrap: wrap; justify-content: center; gap: 1rem; align-items: center;">
                            <a href="https://yyo649929.kuailiaff.com/#/register?code=EjqxPHQZ" target="_blank" rel="nofollow noopener noreferrer" class="btn btn-glow" style="display: inline-flex; align-items: center; gap: 0.5rem; padding: 0.7rem 1.8rem; font-size: 1rem; border-radius: 50px; text-decoration: none;">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" style="vertical-align: middle;"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9M13.73 21a2 2 0 0 1-3.46 0"/></svg>
                                注册免费试用 (享限时优惠)
                            </a>
                            <a href="kuaili-review.html" class="btn" style="display: inline-flex; align-items: center; gap: 0.5rem; padding: 0.7rem 1.8rem; font-size: 1rem; border-radius: 50px; text-decoration: none; border: 1px solid var(--primary); background: transparent; color: var(--primary);">
                                阅读深度评测
                            </a>
                        </div>
                    </div>
"""

html_files = glob.glob("articles/*.html")
for file_path in html_files:
    if "kuaili-review.html" in file_path:
        print(f"Skipping self review: {file_path}")
        continue
    
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
        
    if "promo-box" in content or "<!-- 快狸机场推荐板块 -->" in content:
        print(f"Already contains promo box: {file_path}")
        continue
        
    if "</section>" in content:
        new_content = content.replace("</section>", promo_html + "                </section>")
        with open(file_path, 'w', encoding='utf-8', newline='') as f:
            f.write(new_content)
        print(f"Successfully injected: {file_path}")
    else:
        print(f"Warning: No </section> tag found in {file_path}")
