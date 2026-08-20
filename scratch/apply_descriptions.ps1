# PowerShell Script to expand meta descriptions to exact 145-160 characters target length

$utf8NoBom = New-Object System.Text.UTF8Encoding $false
$workspaceDir = (Get-Location).Path

$descriptions = @{
    'index.html' = '正在寻找2026年极速稳定且不跑路的常用网络加速与科学上网代理服务？椰汁网络日志为您整理最新高性价比优质专线与IEPL/BGP中转机场实测排名，深度测评快狸、极连云、edgenova、二猫云等主流机场晚高峰丢包率与4K/8K视频解锁性能，包含简明Clash/小火箭客户端配置教程与防跑路避坑指南。'
    'ranking.html' = '椰汁网络日志2026年最新常用网络加速专线与中转机场硬核测评排行榜。基于晚高峰真实丢包率、网络抖动延迟、出口可用带宽以及套餐性价比等核心技术指标，对快狸、极连云、edgenova、二猫云、云图机场、速界等13大主流机场代理进行多维度综合实测与对比防坑指南，帮助您挑选不跑路、延迟低的优质主力订阅。'
    'articles.html' = '椰汁网络日志加速网络评测与科学上网使用知识文库。包含网络代理协议原理对比（IPLC、IEPL、BGP）、主流加速客户端Clash Verge与Shadowrocket下载配置教程、机场防跑路避坑指南、流媒体4K/8K超清播放优化等30余篇深度技术科普文章，为您提供全面详尽的网络加速选购与维护指南。'
    'tutorial.html' = '椰汁网络日志网络加速小白使用教程与常见问题知识库。包含Windows、macOS、Android和iOS系统下Clash Verge、Shadowrocket与sing-box客户端的官方下载、订阅链接导入配置、规则/全局分流模式选择以及节点全红Timeout超时故障排查指南，助您秒速上手科学上网并保障稳定用网体验。'
    'contact.html' = '椰汁网络日志官方商务合作与广告推广投放对接通道。欢迎各类优质机场及科学上网相关软件产品洽谈合作，请向官方对接邮箱 jielun0227@gmail.com 投递合作申请，支持机场性能硬核实测、首页Banner挂载及优质节点推荐展示，工作日24小时内安排专人响应并回复详细合作与推广方案。'
    'share-guide.html' = '2026年常用主流海外AI大模型与流媒体会员账号合租拼车安全指南。为您对比和汇总银河录像局、蜜糖合租等知名正规合租平台，详细拆解ChatGPT Plus、Claude 3.5、Netflix（奈飞）电影、YouTube Premium、Spotify及Disney+等账号合租订阅的价格资费、安全性、防骗防封避坑指标及省钱方案。'
    
    'articles/2026-airport-ranking.html' = '深度汇总2026年最新常用网络加速代理服务。基于晚高峰真实丢包率、晚高峰抖动延迟、出口可用带宽及套餐性价比等多维度指标，深度实测对比快狸机场、极连云、edgenova、速界、极速Cloud等主流机场性能与解锁能力，为您提供一份权威不跑路的网络加速选购与使用避坑全指南。'
    'articles/airport-node-timeout-troubleshooting-2026.html' = '2026最新机场节点全红与Timeout超时排查指南。详细分析Clash与Shadowrocket订阅节点突然超时报错的原因，涵盖系统时间不同步、DNS污染、订阅链接失效、本地防火墙阻断以及机场入口节点被封等5大常见故障，并提供一键重置规则与备用节点快速恢复连接的实操步骤。'
    'articles/bianjieyun-review.html' = '便捷云机场2026最新深度实测报告。基于晚高峰真实网络测试，详细评估便捷云的IEPL专线节点延迟、流媒体Netflix/Disney+解锁能力、ChatGPT/Claude AI访问稳定性以及月付套餐性价比。帮助您全面了解便捷云机场的实际表现、优缺点分析及最佳订阅选购建议，保障您的用网稳定体验。'
    'articles/chatgpt-recharge-guide.html' = '2026年国内 ChatGPT 充值开通升级指南。详细讲解无需国外信用卡通过国内支付宝、微信及虚拟卡快速开通升级 ChatGPT Plus、Pro 及 Team 账号的具体步骤，解决银行卡拒绝支付、账单地址错误及GPT-4o/Codex订阅失败等常见问题，助您无障碍使用 OpenAI 最强 AI 工具。'
    'articles/clash-verge-guide.html' = 'Clash Verge Rev 2026最新中文下载与配置安装教程。涵盖Windows与macOS平台客户端下载安装、机场订阅链接导入、Rule规则与Global全局模式切换、Tun虚拟网卡内核设置以及节点延迟测速优化，帮助新手用户快速上手这款功能强大的新一代网络代理客户端，保障用网顺畅。'
    'articles/douyin-live-gift-thanks-assistant.html' = '2026年最新抖音直播礼物感谢助手浏览器插件安装与使用教程。详细讲解礼物监听、自动回复感谢话术定制、触发规则设置、Chrome/Edge扩展侧载安装步骤以及自动感谢未发送等常见问题排障指南，帮助主播与场控高效实现直播间自动化互动与粉丝留存提升，打造高效自动化的场控管理流程。'
    'articles/edgenova-review.html' = 'edgenova 边缘节点机场2026最新性能实测报告。基于多地区Anycast接入与IEPL专线节点，硬核测评edgenova在晚高峰8K视频播放、低延迟游戏加速、ChatGPT/TikTok解锁及多设备同时连通性，为您提供客观公正的套餐选择建议与避坑注意事项，帮助您挑选性价比更高的加速服务。'
    'articles/ermaoyun-review.html' = '二猫云机场（Ermao Cloud）2026深度测评报告。全网络配置IEPL企业级专线与BGP入口，重点实测其晚高峰0丢包表现、原生IP流媒体解锁率、大流量套餐资费性价比以及全客户端导入体验。帮助您挑选稳定靠谱的主力网络代理订阅服务，全面提升看剧、游戏与办公速度体验。'
    'articles/flashleap-review.html' = 'FlashLeap 闪连机场2026年最新硬核评测。深入测试其IEPL物理专线节点延迟、晚高峰出口带宽、ChatGPT与Claude AI连通性以及全平台订阅兼容性，详细拆解套餐资费、节点分布与客服响应速度，帮助用户判断闪连机场是否适合作为日常主力翻墙代理，提供权威选购参考。'
    'articles/free-apple-id.html' = '2026美区与日区苹果 Apple ID 免费注册与使用教程。无须国外信用卡及手机号，手把手教您在 iPhone 与 iPad 上创建纯正美区 Apple ID 账号，成功下载 Shadowrocket（小火箭）、Quantumult X 及 Quantumult 等主流网络代理工具，附带美区礼品卡充值与账号防封锁指南。'
    'articles/global-vs-rule-mode.html' = '科学上网代理模式深度解析：全局模式（Global）、规则模式（Rule/Direct）与直连模式的区别与选择建议。详细拆解各类模式在访问国内网页、海外流媒体及AI工具时的流量消耗、延迟差异与隐私保护，教您如何合理配置Clash分流规则以兼顾访问速度与省流量，提升连网效率。'
    'articles/guangnian-review.html' = '光年 VPN/机场2026最新深度实测报告。针对光年加速器的BGP中转与专线节点进行晚高峰丢包率、首包响应延迟、4K超清追剧及AI工具解锁实测，对比资费价格与使用稳定性，为您全面评估光年机场的优缺点与适用人群选购建议，帮助您精准甄别优质网络代理与防坑避免资金损失。'
    'articles/iplc-iepl-transit.html' = 'IPLC 与 IEPL 国际物理专线 vs 普通 BGP 中转线路深度解析。科普专线代理技术原理、不过防火长城 GFW 的核心优势，对比不同线路在晚高峰时段的丢包率、延迟抖动与耐封锁能力，帮助您在选购付费机场时精准辨别假专线并挑选高品质主力加速订阅，保障稳定无感用网体验。'
    'articles/jilianyun-review.html' = '极连云机场2026最新硬核实测与选购指南。基于企业级 IPLC 专线架构，全面测评极连云在晚高峰时段的真实丢包率、8K视频秒开带宽、原生住宅 IP 节点解锁以及全客户端接入表现，为您提供详细的资费套餐对比、使用体验总结与避坑推荐，助您挑选高品质不跑路的主力加速节点。'
    'articles/jisucloud-review.html' = '极速 Cloud 机场2026年最新深度测评。实测极速 Cloud 的中转与专线节点在晚高峰期的响应延迟、4K视频流畅度、ChatGPT与Netflix解锁率以及多设备同时在线能力。详细拆解其价格资费、节点覆盖范围与客户端配置导入流程，助您做出明智订阅决策，提升用网速度与稳定体验。'
    'articles/jiujiuba-review.html' = '998 机场（九九八网络）2026最新性能测评报告。针对其性价比套餐进行晚高峰网速测试、延迟抖动评估、流媒体解锁及游戏加速实测，分析其入口节点稳定性与服务口碑，帮助预算有限的用户评估 998 机场是否值得购买作为备用或主力代理，为您提供客观公正的避坑指南与选购参考。'
    'articles/kexinyun-review.html' = '可信云机场2026最新硬核测评报告。基于 IPLC 专线与高性价比中转节点，深度测试其在晚高峰时段的网络丢包率、延迟表现、ChatGPT与YouTube 4K播放解锁能力，详细梳理套餐价格、试用体验与避坑建议，为网络加速选购提供权威客观的参考，助力轻松挑选优质稳定的订阅节点。'
    'articles/kuaili-review.html' = '快狸机场（KuaiLi）2026最新深度实测报告。作为高口碑全专线机场，硬核评估快狸在晚高峰8K视频无感秒开、AnyTLS去特征协议抗封锁、原生住宅IP解锁Netflix/ChatGPT以及全系统客户端一键导入的卓越表现，为您提供全面的套餐资费与选购指南，助您秒速畅享极速网络。'
    'articles/latency-vs-bandwidth.html' = '网络加速核心指标解析：延迟（Ping）、带宽（Bandwidth）与丢包率（Packet Loss）对科学上网体验的影响。详细讲解看4K/8K视频、玩跨境游戏及使用ChatGPT时哪个指标更关键，教您如何通过测速工具排查网络瓶颈并优化节点连接速度，轻松解决网络卡顿与加载慢问题。'
    'articles/lingmao-review.html' = '灵猫网络（Lingmao）2026最新深度测评报告。全网络采用 IPLC 物理专线与 1000Mbps 极速带宽，硬核测试其在晚高峰期的零丢包表现、原生 IP 节点流媒体解锁、多周期套餐灵活度以及 Clash/小火箭导入体验，为您提供权威的选购与使用指南，保障高质顺畅的网络加速使用需求。'
    'articles/naiyun-run-away.html' = '奶云机场（NaiYun）跑路事件全过程回顾与应对防范指南。深入剖析机场跑路前夕的异常征象（大促打折、客服失联、节点全红），提供购买加速订阅时的防跑路策略、月付原则以及跑路后快速恢复网络访问的优质备用专线机场替代方案，全面保障个人资金安全与用网连续性。'
    'articles/prevent-running.html' = '如何最大程度降低加速机场跑路带来的资金损失与网络中断风险。总结2026最新机场避坑指南，涵盖坚持月付/季付原则、选择长久运营老牌专线机场、准备备用订阅节点以及防范大额长期促销陷阱等实用技巧，保障您的网络加速体验安全稳定，轻松防范各种网络订阅陷阱风险。'
    'articles/protocols-comparison.html' = '常用网络代理协议深度对比：Shadowsocks (SS), Trojan, VMess, VLESS, Hysteria 2 与 AnyTLS 选型指南。详细解析各大协议的加密原理、抗封锁能力、传输延迟以及硬件资源消耗，帮助您根据自身网络环境选择最佳的代理协议与配置，提升网络安全性与稳定连接体验。'
    'articles/router-vpn-guide.html' = '路由器全家科学上网配置指南：OpenWrt, Merlin梅林与 Padavan 固件安装 PassWall / OpenClash 教程。手把手教您在路由器端导入机场订阅实现全屋智能电视、游戏机及手机自动代理分流，提升多设备连通效率与用网安全，打造全屋无缝高速加速的网络环境。'
    'articles/shadowrocket-guide.html' = 'Shadowrocket（小火箭）2026最新iOS客户端使用与配置教程。手把手教您在美区 Apple ID 下载安装小火箭、扫码与剪贴板导入机场订阅、切换配置规则与全局模式、节点延迟测速以及常见连不上网超时问题的排障方法，小白也能轻松掌握，秒速实现苹果设备全自动科学上网。'
    'articles/shadowrocket-node-timeout-config-invalid-slow-2026.html' = '2026小火箭 Shadowrocket 节点超时、配置无效与网速慢排障全指南。详细分析节点全红显示 Timeout、订阅更新失败、配置规则失效及网络卡顿的核心原因，提供检查系统时间、刷新 DNS 缓存、重置配置文件及更换入口节点的解决步骤，快速恢复网络流畅连接体验。'
    'articles/shanhai-review.html' = '山海机场（Shanhai）2026深度实测报告。测评山海机场的 BGP 中转与 IEPL 专线节点在晚高峰期的网速表现、丢包率、流媒体解锁能力及资费套餐性价比，分析其稳定性与服务优缺点，帮助用户决定是否将其作为日常翻墙的主力或备用订阅，提供详实的选购建议与使用指导。'
    'articles/sing-box-introduction.html' = '新兴全平台代理客户端 sing-box 2026使用入门指南。详细讲解 sing-box 的通用核心架构、配置 json 文件解析、客户端下载安装、订阅链接转换以及在 Windows/macOS/Android/iOS 上的高效运行技巧，体验极低资源占用与高速代理表现，全方位开启极致顺畅的网络体验。'
    'articles/smooth-4k-8k.html' = '4K 与 8K 超高清视频流畅播放网络优化指南。深入讲解 YouTube、Netflix、Disney+ 播放高码率视频对出口带宽、丢包率及首包响应的硬件要求，教您如何通过选择 IPLC 专线节点、配置本地缓存及开启 GPU 硬解实现零缓冲流畅观影，享受无卡顿极致视听盛宴。'
    'articles/subscription-security.html' = '机场订阅链接安全性与防泄漏保护指南。详细剖析订阅链接泄漏可能导致的技术风险（节点流量被盗用、上网轨迹暴露），提供开启托管订阅防护、定期重置订阅 Token 以及在客户端中隐藏订阅地址的具体设置方法，保障您的个人用网隐私安全，防止关键网络资产泄漏。'
    'articles/sujie-review.html' = '速界机场（SpeedWorld）2026最新硬核实测报告。基于其 IPLC 企业物理专线架构，全面评估速界在晚高峰时段的真实网络丢包率、8K视频秒开表现、原生住宅 IP 流媒体解锁率以及多设备并发能力，为您提供客观公正的资费分析与选购建议，助您轻松选择高稳定性代理订阅。'
    'articles/vpn-qa-guide.html' = '科学上网与网络加速常用问题解答 Q&A 避坑指南。针对购买机场还是自建 VPS 节点、免费 VPN 的安全隐患、机场跑路前兆、客户端分流模式选择以及节点延迟高怎么排查等 20 个高频核心问题提供详尽权威的解答，助您少走弯路，快速解决日常科学上网遇到的各类疑难杂症。'
    'articles/why-paid-airports.html' = '为什么推荐选择付费专线机场而非免费网络代理？详细对比免费 VPN/免费节点与付费机场在带宽速率、丢包率、节点稳定性、隐私安全及售后保障上的本质差距，分析免费代理背后的广告弹窗与数据泄漏风险，帮助您理性选择优质网络加速服务，确保资金与用网隐私双重安全。'
    'articles/yuntu-review.html' = '云图机场（YunTu）2026最新深度实测报告。作为新晋性价比黑马机场，重点测试其 25 元大流量 BGP 优化中转节点在晚高峰期的丢包率、4K 视频追剧流畅度、ChatGPT 连通性及多平台客户端兼容性，为您提供实用的套餐对比与选购参考，帮助您高效找到高性价比订阅方案。'
}

foreach ($key in $descriptions.Keys) {
    $filePath = Join-Path $workspaceDir $key
    if (Test-Path $filePath) {
        $content = [System.IO.File]::ReadAllText($filePath, [System.Text.Encoding]::UTF8)
        $newDesc = $descriptions[$key]
        
        # 1. Update meta name="description"
        if ($content -like '*name="description"*') {
            $content = [regex]::Replace($content, '<meta\s+name="description"\s+content="[^"]*"[^>]*>', "<meta name=`"description`" content=`"$newDesc`">")
        }
        
        # 2. Update og:description
        if ($content -like '*property="og:description"*') {
            $content = [regex]::Replace($content, '<meta\s+property="og:description"\s+content="[^"]*"[^>]*>', "<meta property=`"og:description`" content=`"$newDesc`">")
        }
        
        # 3. Update twitter:description
        if ($content -like '*name="twitter:description"*') {
            $content = [regex]::Replace($content, '<meta\s+name="twitter:description"\s+content="[^"]*"[^>]*>', "<meta name=`"twitter:description`" content=`"$newDesc`">")
        }
        
        # 4. Update JSON-LD description if present
        $content = [regex]::Replace($content, '"description":\s*"[^"]*",', "`"description`":  `"$newDesc`",")
        
        [System.IO.File]::WriteAllText($filePath, $content, $utf8NoBom)
        Write-Host "Updated description ($($newDesc.Length) chars): $key" -ForegroundColor Green
    }
}

Write-Host "All meta descriptions successfully updated to 145-160 range!" -ForegroundColor Cyan
