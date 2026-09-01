import os
import re

updates = {
    # 9 Bing Webmaster reported files:
    "articles/jilianyun-review.html": (
        "极连云机场2026年最新硬核实测与选购防坑指南。基于全企业级 IPLC 国际专线传输架构，全面实测极连云在晚高峰繁忙时段的真实丢包率、8K超高清视频秒开带宽、原生住宅 IP 节点解锁以及全客户端兼容表现，为您提供详尽的资费套餐对比、使用体验总结与优惠折扣，助您挑选极致稳定不跑路的高品质主力网络加速节点。"
    ),
    "articles/shanhai-review.html": (
        "山海机场（Shanhai）2026年最新深度硬核测评报告。多维度实测山海机场在 BGP 智能中转与 IEPL 国际专线下的晚高峰网速表现、真实丢包率、流媒体全解锁能力及资费套餐性价比，全面分析其连通稳定性与服务优缺点，帮助您精准评估是否将其作为日常科学上网与学术查资料的主力或备用加速订阅节点。"
    ),
    "articles/subscription-security.html": (
        "机场订阅链接安全性与全方位防泄漏保护操作指南。详细剖析订阅链接不慎泄漏可能引发的技术安全风险（如套餐流量被他人偷刷盗用、个人上网历史轨迹暴露），并提供开启订阅托管保护、定期重置密钥 Token 以及在 Clash/Sing-box 客户端中隐藏订阅地址的具体配置步骤，全方位保障您的个人网络隐私与关键资产安全。"
    ),
    "articles/vpn-qa-guide.html": (
        "科学上网与网络代理加速高频常见问题解答 Q&A 实用避坑指南。针对购买中转机场还是自建 VPS 节点、免费 VPN 隐藏的严重安全风险、机场跑路前的前兆特征、客户端规则分流模式选择以及节点延迟高丢包率高怎么排查解决等 20 个核心疑难问题提供权威专业解答，助您少走弯路，高效解决日常使用各类网络障碍。"
    ),
    "articles/edgenova-review.html": (
        "edgenova 边缘节点机场2026年最新网络性能硬核实测报告。基于全网 Anycast 智能边缘中转与 IEPL 国际专线技术，全面测评 edgenova 在晚高峰 8K 视频播放、低延迟游戏响应、ChatGPT/TikTok 原生 IP 解锁及多设备并发稳定性，为您提供真实客观的套餐资费对比、专属优惠码与避坑买建议，助您挑选高性价比科学上网主力节点。"
    ),
    "articles/router-vpn-guide.html": (
        "路由器全家无感科学上网配置实操指南：涵盖 OpenWrt, Merlin 梅林与 Padavan 固件安装 PassWall 与 OpenClash 插件教程。手把手教您在软路由端导入机场订阅节点，实现全屋 Apple TV、智能电视、PS5/Xbox 游戏机及手机自动智能分流，大幅提升多设备并发连通效率，打造全屋无缝高速翻墙的网络环境。"
    ),
    "articles/sujie-review.html": (
        "速界机场（SpeedWorld）2026年最新硬核网络实测报告。基于其企业级 IPLC 物理专线架构与 Hysteria 2 下一代协议，全面评估速界在晚高峰繁忙时段的真实丢包率、8K 视频秒开能力、原生住宅 IP 流媒体解锁率及多设备并发稳定性，为您提供客观公正的套餐资费分析与优惠码买建议，助您轻松选购高稳定性订阅。"
    ),
    "articles/global-vs-rule-mode.html": (
        "科学上网代理分流模式深度解析：全局模式（Global）、规则模式（Rule/PAC）与直连模式（Direct）的核心区别与使用建议。详细拆解各类模式在访问国内网站、海外流媒体及 ChatGPT 等 AI 工具时的流量消耗、延迟差异与隐私防护，教您如何合理配置 Clash 与 Sing-box 规则，兼顾极速访问与节省流量。"
    ),
    "articles/kexinyun-review.html": (
        "可信云机场2026年最新硬核性能测评报告。基于 IPLC 国际专线与高性价比 BGP 中转节点，深度实测其在晚高峰繁忙时段的网络丢包率、延迟抖动、ChatGPT 与 YouTube 4K/8K 超高清视频解锁能力，详细梳理资费套餐对比、多设备并发试用体验与选购避坑建议，为网络加速挑选提供权威参考，轻松选到稳定满意的主力订阅。"
    ),

    # Other files under 150 chars:
    "articles/android-kuaili-guide-2026.html": (
        "2026最新安卓手机配置快狸机场科学上网手把手详细教程。针对 Android 平台用户，深度解析 v2rayNG 与 Surfboard 客户端安装设置步骤、订阅链接一键导入方法、暗黑模式开启与节点延时测速技巧，帮助科学上网小白快速解决安卓客户端无法连接、配置错误等疑难问题，享受高速流畅的海外网络访问体验。"
    ),
    "articles/naiyun-run-away.html": (
        "奶云（NaiYun）跑路事件全过程深度复盘与防坑应对指南。详细记录奶云突然断连失联的技术前兆、用户维权窘境与经验教训，总结机场行业常见的跑路预警信号（如频繁大促放折、官网域名异常变化、客服工单无响应），并提供挑选高连通率不跑路主力加速节点的实用技巧，帮助广大大网民有效防范网络订阅被坑损失。"
    ),
    "articles/prevent-running.html": (
        "如何识别避开跑路机场与挑选稳定主力加速节点避坑全指南。深入揭秘低价垃圾机场跑路四大典型征兆（如远低于成本的永久买断包、客服长期缺失、频繁更换连接域名），并手把手教您如何挑选具备企业级 IPLC/IEPL 专线保障的高质量服务商，掌握月付订阅原则，彻底告别商家跑路失联带来的经济财产损失。"
    ),
    "articles/why-paid-airports.html": (
        "为什么强烈不建议使用免费翻墙 VPN？免费 VPN 隐藏的技术与隐私风险深度剖析。详细拆解免费机场/免费 VPN 服务商如何通过贩卖用户浏览数据、嵌入恶意广告拦截脚本甚至注入后台代码获取非法收益，对比付费中转专线机场在稳定性、丢包率、解锁流媒体及网络隐私保护上的巨大优势，帮您理智选择安全可靠的主力加速方案。"
    ),
    "articles/guangnian-review.html": (
        "光年梯机场（LightYear）2026年最新性能实测与优惠指南。作为运营多年的资深老牌加速服务，基于 BGP 多线智能中转架构，硬核测试其在晚高峰8K视频播放、低延迟游戏响应、ChatGPT/Netflix 全协议解锁及大流量套餐性价比表现，为您提供详细的资费选购建议与防坑指南，助您挑选高品质稳定出海的主力订阅。"
    ),
    "articles/jiujiuba-review.html": (
        "99吧（99Bar）机场2026年最新硬核测评与使用建议。主打极致低门槛与高性价比，详细测评其在公网隧道中转下的晚高峰网速连通率、真实丢包率、节点解锁表现及超划算低价大流量套餐，全面分析其适合学生党与临时备用出海体验的优点与短板，为您提供客观翔实的购买决策参考，轻松避开低价机场陷阱。"
    ),
    "articles/ermaoyun-review.html": (
        "二猫云机场（ErMaoYun）2026年最新深度硬核测评报告。基于企业级 IPLC 国际物理专线与优化中转架构，全面实测二猫云在晚高峰时段的真实丢包率、8K超高清视频秒开速度、原生住宅 IP 流媒体解锁以及多设备同时在线连通表现，为您提供详细的资费对比、优惠码买建议与服务体验总结，助您挑选稳定不跑路的主力节点。"
    ),
    "articles/shadowrocket-node-timeout-config-invalid-slow-2026.html": (
        "2026版 iOS 小火箭 Shadowrocket 节点超时、配置无效与网速慢排查解决全指南。针对 iPhone 用户使用小火箭时频繁遇到的节点真连接延迟超时、UDP 连通失败、订阅更新报错及晚高峰网页加载极慢等高频疑难故障，提供 6 种一步到位的排查修复方法与核心节点配置技巧，帮助您快速恢复高速流畅的移动出海体验。"
    ),
    "articles/2026-airport-ranking.html": (
        "2026年常用科学上网机场稳定推荐与选购避坑指南。基于晚高峰真实丢包率、网络抖动延迟、出口可用带宽以及套餐性价比等核心技术指标，硬核测评各大主流机场代理，为您提供客观公正的资费套餐对比、线路类型解析与防跑路挑选建议，帮助不同预算的用户快速选出适合自己的高质量主力加速节点。"
    ),
    "articles/yuntu-review.html": (
        "云图机场（YunTu）2026年最新网络性能硬核实测与优惠选购指南。基于 IPLC 国际专线与智能 BGP 中转架构，全面测评云图机场在晚高峰 8K 视频秒开速度、低延迟游戏响应、ChatGPT/TikTok 原生 IP 解锁及全客户端连接表现，为您提供翔实的套餐价格对比、试用体验总结与避坑建议，轻松挑出高稳定主力节点。"
    ),
    "articles/iplc-iepl-transit.html": (
        "IPLC 专线、IEPL 专线与 BGP 中转有什么区别？科学上网线路类型全深度解析。详细拆解 IPLC 物理专线（内网直连不经过防火墙）、IEPL 以太网专线与 BGP 智能中转的传输原理、延迟稳定性差异、抗封锁能力及成本价格，帮助用户根据个人需求（如打游戏、看4K/8K视频或AI创作）选择最适合的翻墙线路方案。"
    ),
    "articles/airport-node-timeout-troubleshooting-2026.html": (
        "2026机场节点超时、批量节点不可用与连通失败排查解决全指南。针对 Clash, Sing-box, Shadowrocket 等客户端出现的节点超时提示、DNS 污染解析失败及订阅无法更新问题，总结 7 大导致连通中断的常见根源，并提供清空 DNS 缓存、切换备用协议、修复系统代理等简单高效的解决方法，助您快速恢复顺畅上网。"
    ),
    "articles/douyin-live-gift-thanks-assistant.html": (
        "2026抖音直播间自动感谢礼物助手软件：全自动实时语音弹幕互动挂机神器。针对抖音主播与带货团队，详细讲解支持自动感谢送礼粉丝、实时语音播报答谢、自动回应进房欢迎与智能回答常见问题的挂机软件功能特色，大幅提升直播间互动留存率与热闹氛围，释放主播双手，打造高效智能化直播运营流程。"
    ),
    "articles/smooth-4k-8k.html": (
        "如何顺畅无卡顿观看 YouTube 4K 与 8K 超高清视频？节点配置与加速优化全指南。深入分析限制超高清视频流畅播放的技术瓶颈（如出口可用带宽上限、晚高峰丢包抖动及客户端缓冲设置），提供从挑选企业级 IEPL 专线机场、配置 Clash/v2rayNG 线程缓冲区到开启浏览器硬件加速的完整优化方案，体验极速秒开。"
    ),
    "articles/flashleap-review.html": (
        "闪跃机场（FlashLeap）2026年最新性能实测报告。基于 BGP 智能多线中转与公网隧道优化架构，多维度评估闪跃机场在晚高峰繁忙时段的网速连通率、8K视频秒开表现、主流流媒体全解锁率以及大流量套餐性价比，为您提供真实客观的资费选购建议与优惠码使用指南，帮助您评估挑选适合自己的稳定备用加速节点。"
    ),
    "articles/latency-vs-bandwidth.html": (
        "网络延迟（Ping）与带宽（Mbps）有什么区别？哪个对科学上网体验更重要？详细拆解延迟与带宽的物理定义、相互作用关系及其对看4K视频、玩联机游戏、网页浏览与AI对话的具体影响，教您在挑选中转机场时如何兼顾低延迟与高带宽，根据个人实际用网场景挑选出性价比最高、使用体验最舒适的网络节点。"
    ),
    "articles/kuaili-review.html": (
        "快狸机场（KuaiLi）2026年最新深度硬核测评报告。基于全企业级 IEPL 物理专线架构，硬核测试快狸在晚高峰 8K 视频秒开、原生住宅 IP 完美解锁 ChatGPT/TikTok 及全客户端兼容性，为您提供详细的套餐资费对比、专属 8 折优惠码与避坑买建议，帮助您挑选极致稳定不跑路的高品质主力加速节点。"
    ),
    "articles/jisucloud-review.html": (
        "极速云机场（JiSu Cloud）2026年最新性能实测报告。基于三网优化专线与高质量 BGP 中转架构，全面测评极速云在晚高峰 8K 视频流畅播放、原生产业 IP 节点解锁、TikTok 运营及多设备连通稳定性，为您提供详细的套餐资费对比、使用体验总结与防坑建议，助您轻松选出适合科学上网与海外办公的主力节点。"
    ),
    "contact.html": (
        "椰汁网络日志商务合作与测评申请通道。如果您是网络加速服务商、机场运营方或出海软件开发者，欢迎联系我们进行节点测速评估与硬核测评合作。我们提供主观真实的网络性能评测、品牌展示与推广对接服务，帮助优质出海加速产品获得更多曝光，共同打造健康透明的高质量网络体验环境。"
    ),
    "articles/lingmao-review.html": (
        "灵猫云机场（LingMao）2026年最新深度硬核测评报告。基于企业级 IPLC 国际专线与优化中转架构，全面实测灵猫云在晚高峰繁忙时段的真实丢包率、8K超高清视频秒开速度、原生 IP 流媒体全解锁以及多终端同时连通表现，为您提供详细的资费对比、专属优惠码与选购避坑建议，助您挑选高品质稳定出海的主力节点。"
    ),
    "articles/clash-verge-guide.html": (
        "2026最新 Clash Verge Rev Windows/Mac 电脑客户端下载安装与配置详细教程。详细讲解 Clash Verge 软件界面中文设置、订阅链接导入、Tun 虚拟网卡模式开启以及系统代理路由规则切换操作步骤，帮助科学上网小白快速解决连不上网、节点超时及 DNS 污染等故障，轻松体验极速稳定的出海加速。"
    ),
    "articles/shadowrocket-guide.html": (
        "2026最新 iOS 苹果手机小火箭 Shadowrocket 下载安装与配置手把手教程。详细讲解苹果手机安装小火箭的 App Store 账号准备、订阅链接导入、节点延迟测试、智能路由分流规则配置以及场景自动化切换技巧，帮助用户轻松解决 iPhone 连接超时、网速慢等故障，享受极速顺畅的移动端海外上网体验。"
    ),
    "ranking.html": (
        "椰汁网络日志2026年最新常用网络加速专线与中转机场硬核测评排行榜。基于晚高峰真实丢包率、网络抖动延迟、出口可用带宽以及套餐性价比等核心技术指标，对快狸、极连云、edgenova、二猫云、云图机场、速界等13大主流机场代理进行多维度综合实测与对比防坑指南，帮助您挑选不跑路、延迟低的优质主力订阅。"
    ),
    "articles/bianjieyun-review.html": (
        "边界云机场（BianJieYun）2026年最新性能硬核实测与优惠指南。基于智能接入 BGP 中转线路与负载均衡架构，硬核测试边界云在晚高峰 8K 视频秒开速度、抗封锁连通性、流媒体全解锁及多设备并发稳定性，为您提供客观公正的套餐资费分析与选购避坑建议，助您轻松挑选高性价比科学上网主力加速节点。"
    ),
    "index.html": (
        "椰汁网络日志 - 2026年稳定好用的机场推荐与科学上网教程博客。专注提供常用代理机场硬核测评、低延迟专线节点排行榜、Clash/Sing-box/Shadowrocket 客户端配置教程及苹果账号免费共享。基于晚高峰真实连通率与丢包率测试，为您推荐不跑路、速度快、性价比高的主力加速订阅服务。"
    ),
    "articles.html": (
        "椰汁网络日志技术评测与科学上网文章目录。汇集 2026 年最新机场代理硬核测评、IPLC/IEPL 专线对比、Clash/Sing-box/小火箭客户端配置教程、跑路避坑指南及网络加速疑难解答，为您提供丰富详实的科学上网技术干货与选购参考，帮助您快速解决出海连网障碍，体验高速稳定的网络。"
    ),
}

modified_count = 0
for rel_path, new_desc in updates.items():
    full_path = os.path.abspath(rel_path)
    if not os.path.exists(full_path):
        print(f"[MISSING] {full_path}")
        continue
    
    with open(full_path, 'r', encoding='utf-8') as f:
        content = f.read()

    length = len(new_desc)
    print(f"File: {rel_path:<50} | Length: {length:3d} chars")

    # Replace meta description
    content = re.sub(
        r'<meta\s+name=["\']description["\']\s+content=["\']([^"\']*)["\']',
        f'<meta name="description" content="{new_desc}">',
        content,
        flags=re.IGNORECASE
    )
    # Replace og:description
    content = re.sub(
        r'<meta\s+property=["\']og:description["\']\s+content=["\']([^"\']*)["\']',
        f'<meta property="og:description" content="{new_desc}">',
        content,
        flags=re.IGNORECASE
    )
    # Replace twitter:description
    content = re.sub(
        r'<meta\s+name=["\']twitter:description["\']\s+content=["\']([^"\']*)["\']',
        f'<meta name="twitter:description" content="{new_desc}">',
        content,
        flags=re.IGNORECASE
    )

    with open(full_path, 'w', encoding='utf-8') as f:
        f.write(content)
    modified_count += 1

print(f"\nDone! Modified {modified_count} HTML files.")
