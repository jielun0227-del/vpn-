# PowerShell script to fix ranking.html JavaScript array syntax

$utf8NoBom = New-Object System.Text.UTF8Encoding $false
$workspaceDir = (Get-Location).Path
$rankingPath = Join-Path $workspaceDir "ranking.html"

$cleanRankData = @"
        const rankData = [
            {
                rank: 1,
                id: "kuaili",
                name: "快狸",
                price: 15,
                type: "dedicated",
                protocolLabel: "IEPL 专线 / VLESS 协议",
                lineType: "企业级 IEPL 物理专线",
                unlocks: "静态住宅 IP / 0 丢包 / 完美风控",
                regions: "香港、台湾、日本、新加坡、美国、英国等",
                slogan: "👑 2026 强力推荐，全专线极致稳定性保障",
                editorNote: "主打企业级专线与新一代VLESS协议，防封锁与连通率表现极其出色。对于流媒体解锁及海外办公有高要求的用户首选。",
                affLink: "https://yyo649929.kuailiaff.com/#/register?code=EjqxPHQZ",
                reviewLink: "./articles/kuaili-review.html"
            },
            {
                rank: 2,
                id: "jilianyun",
                name: "极连云",
                price: 18,
                type: "dedicated",
                protocolLabel: "Trojan / V2ray",
                lineType: "IPLC 专线",
                unlocks: "晚高峰 0 丢包 / 4K秒开",
                regions: "全球 30+ 节点覆盖",
                slogan: "⚡ 定位中高端，极致稳定与极速响应",
                editorNote: "专线直达，抗封锁和晚高峰抗压性能极强，几乎无延迟抖动。适合对稳定性和游戏延迟有苛刻要求的高端用户。",
                affLink: "https://157935.jlyvipaff.com/#/register?code=Sm7oT61X",
                reviewLink: "./articles/jilianyun-review.html"
            },
            {
                rank: 3,
                id: "edgenova",
                name: "edgenova边缘节点",
                price: 12,
                type: "transit",
                protocolLabel: "Trojan / Vmess",
                lineType: "Anycast 智能节点中转",
                unlocks: "全平台多终端兼容",
                regions: "覆盖亚太及欧美核心节点",
                slogan: "📡 兼顾性价比与稳定性的优质专线",
                editorNote: "采用智能边缘中转技术，能够根据用户所在的地理位置智能分配最快中转点。延迟低，价格适中，非常稳定。",
                affLink: "https://everett7623.edgenovaaff.cc/#/register?code=tT3McfnN",
                reviewLink: "./articles/edgenova-review.html"
            },
            {
                rank: 4,
                id: "yuntu",
                name: "云图机场",
                price: 25,
                type: "transit",
                protocolLabel: "Trojan / Shadowsocks",
                lineType: "BGP 多线中继 + 专线中转",
                unlocks: "常规流媒体与AI平台全解",
                regions: "香港、日本、新加坡、美国等",
                slogan: "☁️ 新晋黑马，高性价比多入口 BGP 隧道中转",
                editorNote: "新晋黑马，提供高性价比的隧道中转服务，节点解锁表现良好，支持 Netflix、Disney+及 ChatGPT。适合日常娱乐、追剧与办公小白使用。",
                affLink: "https://vip.ytjcok.org/#/register?code=Av0K1D4P",
                reviewLink: "./articles/yuntu-review.html"
            },
            {
                rank: 5,
                id: "sujie",
                name: "速界",
                price: 20,
                type: "dedicated",
                protocolLabel: "Hysteria 2 / Trojan",
                lineType: "IPLC 顶级专线 + Hysteria 2",
                unlocks: "抗封锁能力满分",
                regions: "晚高峰万兆带宽直达",
                slogan: "🔥 为极致速度与连通率而生",
                editorNote: "率先支持 Hysteria 2 下一代协议，结合顶级专线，拥有无与伦比的爆速体验和抗干扰能力，突破各种极端封锁环境。",
                affLink: "https://lqy001.speedworldaff.com/#/?code=ysM6ozIh",
                reviewLink: "./articles/sujie-review.html"
            },
            {
                rank: 6,
                id: "guangnian",
                name: "光年梯",
                price: 10,
                type: "transit",
                protocolLabel: "Shadowsocks / Trojan",
                lineType: "BGP 多线中转优化",
                unlocks: "流媒体完美解锁 / 大流量",
                regions: "全场景 40+ 地区支持",
                slogan: "🚀 资深老牌服务，超高性价比大流量",
                editorNote: "老牌加速服务，以稳定运营与极佳的性价比著称。中转线路在晚高峰表现依然稳健，是日常追剧与轻度办公的性价比之选。",
                affLink: "https://1579.gntaff.com/#/?code=PzvG9uPl",
                reviewLink: "./articles/guangnian-review.html"
            },
            {
                rank: 7,
                id: "kexinyun",
                name: "可信云",
                price: 14,
                type: "transit",
                protocolLabel: "Vmess / Trojan",
                lineType: "纯中转优化线路",
                unlocks: "主流平台及网页极速加载",
                regions: "多端并发不限速",
                slogan: "🛡️ 主打安全可信赖，多端流畅并发",
                editorNote: "线路稳定且数据传输安全程度高。支持多设备同时在线，不限速度上限。适合多设备家庭以及看重稳定性的用户使用。",
                affLink: "https://yp76688.kosingaff.com/#/register?code=KJxZyDig",
                reviewLink: "./articles/kexinyun-review.html"
            },
            {
                rank: 8,
                id: "ermaoyun",
                name: "二猫云",
                price: 20,
                type: "dedicated",
                protocolLabel: "Shadowsocks / Trojan",
                lineType: "全 IEPL 专线 (2.5Gbps)",
                unlocks: "流媒体 / AI 全面解锁",
                regions: "香港×20、台湾×5、日本×10、新加坡×10、美国×10",
                slogan: "🐱 全专线高速稳定性保障，100G不限时/年付超省",
                editorNote: "二猫云全线采用全 IEPL 专线，单节点最高峰值达 2.5Gbps。具备极致低延迟与无感解锁能力，支持多设备无限制并发。提供月付、大流量年付及 99 元 100G 永久不限时套餐，极为适合作为主力加速与长期备用。",
                affLink: "https://vip.ermaoaff.com/#/?code=Yq2zJR8A",
                reviewLink: "./articles/ermaoyun-review.html"
            },
            {
                rank: 9,
                id: "lingmao",
                name: "灵猫网络",
                price: 25,
                type: "dedicated",
                protocolLabel: "Clash / Shadowrocket / Stash / v2ray",
                lineType: "全 IPLC 专线 (1000Mbps)",
                unlocks: "原生 IP / 流媒体 & AI 平台全解锁",
                regions: "常用地区 1 倍率节点覆盖",
                slogan: "🐱 全 IPLC 专线 + 原生 IP，多周期灵活套餐",
                editorNote: "主打全 IPLC 专线与原生 IP，最高可用带宽 1000Mbps，节点默认 1 倍率计算。完美解锁 Netflix、Hulu、HBO、Disney+ 及 ChatGPT、Gemini、TikTok，不限客户端数量，支持月付/季付/年付灵活订阅。",
                affLink: "https://kuaili080.civetaff.com/#/?code=54RWQult",
                reviewLink: "./articles/lingmao-review.html"
            },
            {
                rank: 10,
                id: "wuyoulianjie",
                name: "无忧链接",
                price: 6,
                type: "dedicated",
                protocolLabel: "新 Vless 协议 / Sing-box / Clash",
                lineType: "IPLC 物理专线",
                unlocks: "ChatGPT / Gemini / TikTok / Netflix 全解",
                regions: "港台新日美、东南亚小众及欧美国家",
                slogan: "🚀 IPLC 专线 + 新 Vless 协议，海外团队全天在线客服",
                editorNote: "配置 IPLC 物理专线与新 Vless 协议，海外团队运营支持全天客服。完美解锁 ChatGPT、Gemini 等 AI 平台及 TikTok、Netflix 等海外流媒体。无倍率不限速不限设备，提供低至 6 元/月轻量套餐，专线稳定高效。特惠码 wuyou666 享 6.8 折。",
                affLink: "https://wep01.worryfreeaff.com/#/?code=30yg9KJh",
                reviewLink: "./articles/wuyoulianjie-review.html"
            },
            {
                rank: 11,
                id: "shanhai",
                name: "山海机场",
                price: 15,
                type: "transit",
                protocolLabel: "Trojan / Vmess",
                lineType: "隧道公网中转",
                unlocks: "高性价比，多线路冗余",
                regions: "支持港澳台及东南亚热门地区",
                slogan: "🏔️ 海纳百川，性价比突出的主流中转",
                editorNote: "性价比较高的中转机场，节点分布广泛。虽然在极高峰期可能有轻微波动，但日常追剧以及日常跨境科研绝对能够轻松胜任。",
                affLink: "https://shanhai.sbs/#/register?code=qVTbPfWP",
                reviewLink: "./articles/shanhai-review.html"
            },
            {
                rank: 12,
                id: "jisucloud",
                name: "极速Cloud",
                price: 15,
                type: "dedicated",
                protocolLabel: "VLESS 协议",
                lineType: "三网精品优化专线",
                unlocks: "常规流媒体与AI平台全解",
                regions: "香港、日本、新加坡、美国、台湾等27+国家/地区",
                slogan: "⚡ 顶级优化专线，原生IP助力TikTok与AI运营",
                editorNote: "采用DMIT、Gomami、NEBURST等顶级服务商的高质量三网优化专线（CN2GIA/AS9929/CMIN2），晚高峰体验丝滑。上线了专门的原生节点，对跨境电商、TikTok运营及高强度AI解锁极其友好。",
                affLink: "https://august.jsjc456789.com",
                reviewLink: "./articles/jisucloud-review.html"
            },
            {
                rank: 13,
                id: "flashleap",
                name: "闪跃机场",
                price: 15,
                type: "transit",
                protocolLabel: "Trojan / Vmess / Shadowsocks",
                lineType: "高速公网隧道中转",
                unlocks: "常用流媒体与ChatGPT解锁",
                regions: "亚太与欧美核心地区",
                slogan: "⚡ 闪亮出海，极速跃迁的稳定新秀",
                editorNote: "闪跃机场（Flashleap）主打高速稳定的公网中转线路，针对晚高峰大流量网络进行了深度分流设计。节点解锁表现良好，性价比突出，适合预算有限但追求高带宽与低延迟的用户。",
                affLink: "https://jielun0227.flashleapaff.com/#/?code=uyTPETiU",
                reviewLink: "./articles/flashleap-review.html"
            },
            {
                rank: 14,
                id: "bianjieyun",
                name: "边界云加速器",
                price: 18,
                type: "transit",
                protocolLabel: "Vmess / Shadowsocks",
                lineType: "智能接入BGP中转",
                unlocks: "多端兼容，稳定负载均衡",
                regions: "亚洲核心及欧美主力节点",
                slogan: "🌌 无界出海，主打稳定连通的高性价比",
                editorNote: "提供多条智能接入中转线路，抗封锁性能优异。客户端全适配，节点支持负载均衡，能够自动切换可用节点以保障网络的连通率。",
                affLink: "https://www.lvpn.cc/r/6UQDZT",
                reviewLink: "./articles/bianjieyun-review.html"
            },
            {
                rank: 15,
                id: "jiujiuba",
                name: "99吧",
                price: 9.9,
                type: "transit",
                protocolLabel: "Shadowsocks / Trojan",
                lineType: "直连+公网隧道双层优化",
                unlocks: "极致超低门槛，入门级大流量",
                regions: "常用主流亚太地区覆盖",
                slogan: "🎈 极致门槛，超划算入门尝鲜之选",
                editorNote: "起步价极其低廉的入门机场，仅需几元即可上手体验。适合流量消耗极大、预算较紧的尝鲜小白，基础出海浏览的首选。",
                affLink: "https://99vpn.bar/#/register?code=Uni7IOJh",
                reviewLink: "./articles/jiujiuba-review.html"
            }
        ];
"@

$content = [System.IO.File]::ReadAllText($rankingPath, [System.Text.Encoding]::UTF8)

# Replace broken rankData block
$m = [regex]::Match($content, '(?s)const rankData = \[.*?\];')
if ($m.Success) {
    $content = $content.Replace($m.Value, $cleanRankData)
    [System.IO.File]::WriteAllText($rankingPath, $content, $utf8NoBom)
    Write-Host "Replaced rankData with clean JS array in ranking.html" -ForegroundColor Green
} else {
    Write-Host "Could not find rankData match" -ForegroundColor Red
}
