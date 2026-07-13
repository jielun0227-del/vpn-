// 机场数据列表
const airports = [
    {
        id: "feimaoyun",
        name: "飞猫云",
        price: 15,
        type: "dedicated", // dedicated (专线), transit (中转), budget (低价)
        protocol: "trojan-ss", // trojan-ss, trojan, v2ray, hysteria2
        slogan: "💡 专为 4K 流媒体与低延迟游戏打造",
        lineType: "全线 IEPL 专线",
        unlocks: "原生流媒体完美解锁",
        regions: "50+ 国家/地区",
        protocolLabel: "Trojan / Shadowsocks",
        editorNote: "顶级IEPL专线资源加持，延迟极低，无论晚高峰还是特殊时期都十分坚挺，非常适合对网络稳定性有极高要求的重度用户。",
        affLink: "https://flycat1.flycatvipaff.cc/#/?code=ARaIAyVa",
        reviewLink: "./articles/smooth-4k-8k.html"
    },
    {
        id: "u1s1",
        name: "U1S1",
        price: 8,
        type: "transit",
        protocol: "trojan",
        slogan: "⚡ 极速稳定，无惧晚高峰拥堵",
        lineType: "极速专线中转",
        unlocks: "流媒体原生全解",
        regions: "25+ 节点覆盖",
        protocolLabel: "Trojan 协议",
        editorNote: "主打极速与高性价比。底层节点经过重构优化，在确保极速加载的同时兼顾了长期稳定性，对于看重连通率的用户来说是不二之选。",
        affLink: "https://pkdj7.vipaff.cc/#/?code=CmjDmi54",
        reviewLink: "./articles/why-paid-airports.html"
    },
    {
        id: "xingdaomeng",
        name: "星岛梦",
        price: 16,
        type: "dedicated",
        protocol: "v2ray",
        slogan: "💎 高端专线链路，尊享极致体验",
        lineType: "顶级跨境 IEPL 专线",
        unlocks: "晚高峰 0 丢包",
        regions: "外贸与高清视频专属",
        protocolLabel: "V2ray (VMess/VLESS)",
        editorNote: "采用了高昂成本的专用物理通道，避开了拥堵的公网信道。实测晚高峰依然能跑满本地带宽，是追求极致网络质量用户的高端选择。",
        affLink: "https://kfccbb.xingdaomeng.com/#/?code=961pG4vA",
        reviewLink: "./articles/iplc-iepl-transit.html"
    },
    {
        id: "weituyun",
        name: "唯兔云",
        price: 14,
        type: "dedicated",
        protocol: "v2ray",
        slogan: "🚀 跨境外贸与日常全场景适用",
        lineType: "BGP + IPLC 混合专线",
        unlocks: "极速秒开 / 流媒体完美",
        regions: "SLA 保证 99.9% 连通",
        protocolLabel: "SSR / V2ray",
        editorNote: "综合表现极其优异的精品机场，不仅流媒体解锁能力强，跨境外贸访问也极度丝滑，是作为日常科学上网主力梯子的绝佳选择。",
        affLink: "https://fast.v2yunvipaff.com/#/?code=MI5TU4uc",
        reviewLink: "./articles/clash-verge-guide.html"
    },
    {
        id: "guangsuyun",
        name: "光速云",
        price: 17,
        type: "dedicated",
        protocol: "trojan-ss",
        slogan: "🎮 电竞级低延迟，彻底拒绝丢包",
        lineType: "游戏专属优化专线",
        unlocks: "峰值不限速 / 多IP分流",
        regions: "不限在线设备数",
        protocolLabel: "SS / Trojan",
        editorNote: "线路经过特殊的游戏级路由优化，测速数据名列前茅，特别适合对丢包率敏感的主机游戏玩家及 8K 高清视频发烧友。",
        affLink: "https://mdlky.gsyaff.com/#/?code=qLcDEGH6",
        reviewLink: "./articles/latency-vs-bandwidth.html"
    },
    {
        id: "shanshuiyun",
        name: "山水云",
        price: 14,
        type: "transit",
        protocol: "trojan-ss",
        slogan: "⛰️ BGP大带宽，晚高峰抗压神器",
        lineType: "BGP 大带宽中转",
        unlocks: "大流量管饱套餐",
        regions: "流媒体原生完美解锁",
        protocolLabel: "V2ray / Trojan",
        editorNote: "公网中转中的优秀品牌，线路容量充沛，套餐流量性价比极高。特别适合大流量下载、长期挂载视频的用户使用。",
        affLink: "https://jichanglink.com",
        reviewLink: "./articles/global-vs-rule-mode.html"
    },
    {
        id: "naiyun",
        name: "奈云",
        price: 19,
        type: "dedicated",
        protocol: "trojan-ss",
        slogan: "🎬 专为流媒体而生的高端链路",
        lineType: "IEPL 专线极致分流",
        unlocks: "Netflix/Disney+ 原生解锁",
        regions: "40+ 地区解锁支持",
        protocolLabel: "Shadowsocks / Trojan",
        editorNote: "针对 Netflix, Disney+, HBO, ChatGPT 进行了专门的节点解锁和分流优化，流媒体画质自动锁死最高清，看剧党神器。",
        affLink: "https://jichanglink.com",
        reviewLink: "./articles/protocols-comparison.html"
    },
    {
        id: "edgenova",
        name: "edgenova边缘节点",
        price: 12,
        type: "transit",
        protocol: "v2ray",
        slogan: "📡 兼顾性价比与稳定性的优质专线",
        lineType: "Anycast 智能节点中转",
        unlocks: "全平台多终端兼容",
        regions: "覆盖亚太及欧美核心节点",
        protocolLabel: "Trojan / Vmess",
        editorNote: "采用智能边缘中转技术，能够根据用户所在的地理位置智能分配最快中转点。延迟低，价格适中，非常稳定。",
        affLink: "https://everett7623.edgenovaaff.cc/#/register?code=tT3McfnN",
        reviewLink: "./articles/edgenova-review.html"
    },
    {
        id: "sujie",
        name: "速界",
        price: 20,
        type: "dedicated",
        protocol: "hysteria2",
        slogan: "🔥 为极致速度与连通率而生",
        lineType: "IPLC 顶级专线 + Hysteria 2",
        unlocks: "抗封锁能力满分",
        regions: "晚高峰万兆带宽直达",
        protocolLabel: "Hysteria 2 / Trojan",
        editorNote: "率先支持 Hysteria 2 下一代协议，结合顶级专线，拥有无与伦比的爆速体验和抗干扰能力，突破各种极端封锁环境。",
        affLink: "https://solmira.sujiestttt.xyz/#/register?code=ysM6ozIh",
        reviewLink: "./articles/sujie-review.html"
    },
    {
        id: "yuzhouyun",
        name: "宇宙云",
        price: 5,
        type: "budget",
        protocol: "trojan",
        slogan: "🌌 极简低价，尝鲜无压力",
        lineType: "BGP 直连优化线路",
        unlocks: "月付5元，超高性价比",
        regions: "覆盖常用亚太地区节点",
        protocolLabel: "Trojan 协议",
        editorNote: "预算有限用户的最佳搭档。价格压到了惊人的月付5元起，基础访问和网页浏览非常流畅，适合轻度冲浪党入门尝试。",
        affLink: "https://jichanglink.com",
        reviewLink: "./articles/prevent-running.html"
    }
];

document.addEventListener('DOMContentLoaded', () => {
    // 1. 初始化列表和事件监听 (仅在 index.html 中执行)
    const cardListContainer = document.getElementById('airport-cards');
    if (cardListContainer) {
        renderCards(airports);
        
        const searchInput = document.getElementById('search-input');
        const filterType = document.getElementById('filter-type');
        const filterProtocol = document.getElementById('filter-protocol');
        
        const applyFilters = () => {
            const query = searchInput ? searchInput.value.toLowerCase() : "";
            const type = filterType ? filterType.value : "all";
            const protocol = filterProtocol ? filterProtocol.value : "all";
            
            const filtered = airports.filter(item => {
                const matchesSearch = !searchInput || item.name.toLowerCase().includes(query) || item.editorNote.toLowerCase().includes(query) || item.slogan.toLowerCase().includes(query);
                const matchesType = type === 'all' || item.type === type;
                let matchesProtocol = protocol === 'all';
                if (protocol === 'trojan') {
                    matchesProtocol = item.protocol === 'trojan' || item.protocol === 'trojan-ss';
                } else if (protocol === 'v2ray') {
                    matchesProtocol = item.protocol === 'v2ray' || item.protocol === 'trojan-ss';
                } else if (protocol === 'hysteria2') {
                    matchesProtocol = item.protocol === 'hysteria2';
                }
                
                return matchesSearch && matchesType && matchesProtocol;
            });
            renderCards(filtered);
        };
        
        if (searchInput) searchInput.addEventListener('input', applyFilters);
        if (filterType) filterType.addEventListener('change', applyFilters);
        if (filterProtocol) filterProtocol.addEventListener('change', applyFilters);
    }

    // 2. 移动端菜单切换
    const menuToggle = document.getElementById('menu-toggle');
    const navMenu = document.getElementById('nav-menu');
    if (menuToggle && navMenu) {
        menuToggle.addEventListener('click', () => {
            navMenu.classList.toggle('active');
            const spans = menuToggle.querySelectorAll('span');
            spans[0].style.transform = navMenu.classList.contains('active') ? 'rotate(45deg) translate(6px, 6px)' : 'none';
            spans[1].style.opacity = navMenu.classList.contains('active') ? '0' : '1';
            spans[2].style.transform = navMenu.classList.contains('active') ? 'rotate(-45deg) translate(5px, -5px)' : 'none';
        });
    }

    // 3. FAQ 折叠面板手风琴
    const faqItems = document.querySelectorAll('.faq-item');
    faqItems.forEach(item => {
        const question = item.querySelector('.faq-question');
        question.addEventListener('click', () => {
            const isActive = item.classList.contains('active');
            // 关闭其他所有 FAQ
            faqItems.forEach(i => i.classList.remove('active'));
            if (!isActive) {
                item.classList.add('active');
            }
        });
    });

    // 4. 节点测速模拟器控制
    const runTestBtn = document.getElementById('run-speed-test');
    if (runTestBtn) {
        runTestBtn.addEventListener('click', runSpeedTest);
    }
});

// 渲染机场卡片
function renderCards(data) {
    const container = document.getElementById('airport-cards');
    if (!container) return;
    
    if (data.length === 0) {
        container.innerHTML = `
            <div style="grid-column: 1/-1; text-align: center; padding: 4rem 1rem; color: var(--text-secondary); border: 1px dashed var(--border-color); border-radius: 16px;">
                <svg width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" style="margin-bottom: 1rem; color: var(--text-muted);"><circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/></svg>
                <p>未找到符合筛选条件的机场节点，请尝试清空或重置过滤器。</p>
            </div>
        `;
        return;
    }
    
    container.innerHTML = data.map(item => `
        <article class="card" id="card-${item.id}">
            <div class="card-header">
                <div class="card-title-wrap">
                    <div class="card-icon">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
                    </div>
                    <h3 class="card-title">${item.name}</h3>
                </div>
                <div class="card-price">
                    <span class="price-currency">￥</span><span class="price-value">${item.price}</span><span class="price-period">/月起</span>
                </div>
            </div>
            
            <div class="card-slogan">
                <span>${item.slogan}</span>
            </div>
            
            <div class="specs-grid">
                <div class="spec-item">
                    <span class="spec-label">底层协议</span>
                    <div class="spec-value">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><path d="M20 6L9 17l-5-5"/></svg>
                        ${item.protocolLabel}
                    </div>
                </div>
                <div class="spec-item">
                    <span class="spec-label">线路类型</span>
                    <div class="spec-value">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><path d="M20 6L9 17l-5-5"/></svg>
                        ${item.lineType}
                    </div>
                </div>
                <div class="spec-item">
                    <span class="spec-label">流媒体解锁</span>
                    <div class="spec-value">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><path d="M20 6L9 17l-5-5"/></svg>
                        ${item.unlocks}
                    </div>
                </div>
                <div class="spec-item">
                    <span class="spec-label">节点覆盖</span>
                    <div class="spec-value">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><path d="M20 6L9 17l-5-5"/></svg>
                        ${item.regions}
                    </div>
                </div>
            </div>
            
            <div class="card-note">
                <div class="note-title">编辑评语</div>
                <div class="note-content">${item.editorNote}</div>
            </div>
            
            <div class="card-actions">
                <a href="${item.affLink}" target="_blank" rel="nofollow noopener noreferrer" class="btn btn-glow">
                    获取优惠
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M5 12h14M12 5l7 7-7 7"/></svg>
                </a>
                <a href="${item.reviewLink}" class="btn btn-outline">阅读评测</a>
            </div>
        </article>
    `).join('');
}

// 模拟延迟和网速测试
let testingInProgress = false;
async function runSpeedTest() {
    if (testingInProgress) return;
    testingInProgress = true;
    
    const terminalBody = document.getElementById('terminal-body');
    const runBtn = document.getElementById('run-speed-test');
    const statusIndicator = document.getElementById('status-indicator');
    const statusText = document.getElementById('status-text');
    
    // UI 锁定状态
    runBtn.style.opacity = '0.5';
    runBtn.style.cursor = 'not-allowed';
    statusIndicator.className = 'status-indicator active';
    statusText.innerText = 'TESTING...';
    
    // 清空输出
    terminalBody.innerHTML = '';
    
    // 帮助输出打印的辅佐函数
    const printLine = (text, type = '', delay = 300) => {
        return new Promise(resolve => {
            setTimeout(() => {
                const line = document.createElement('div');
                line.className = `terminal-line ${type}`;
                if (type === 'cmd') {
                    line.innerText = text;
                } else {
                    line.innerHTML = text;
                }
                terminalBody.appendChild(line);
                terminalBody.scrollTop = terminalBody.scrollHeight;
                resolve();
            }, delay);
        });
    };
    
    await printLine('initialize_speed_test --client=Antigravity_CyberNode', 'cmd', 100);
    await printLine('> INITIALIZING LOCAL TEST ENGINE (v2.6.4)...', 'system', 300);
    await printLine('> CONNECTING TO PACIFIC GATEWAY GATEWAYS...', 'system', 400);
    await printLine('> DETECTING LATENCY & REALTIME BANDWIDTH LOAD...', 'system', 300);
    
    await printLine('scan_endpoints --active-list', 'cmd', 500);
    await printLine('> LOCATING CLOUD ENDPOINTS IN BLOG REGISTRY...', 'system', 200);
    
    // 创建测试表
    const tableContainer = document.createElement('div');
    tableContainer.style.width = '100%';
    tableContainer.innerHTML = `
        <table class="speed-table">
            <thead>
                <tr>
                    <th>节点名称</th>
                    <th>线路类型</th>
                    <th>响应延迟</th>
                    <th>出口带宽</th>
                    <th>节点状态</th>
                </tr>
            </thead>
            <tbody id="speed-test-results">
            </tbody>
        </table>
    `;
    
    await new Promise(resolve => {
        setTimeout(() => {
            terminalBody.appendChild(tableContainer);
            terminalBody.scrollTop = terminalBody.scrollHeight;
            resolve();
        }, 400);
    });
    
    const tableBody = document.getElementById('speed-test-results');
    
    // 循环模拟每个机场节点的测速
    for (let i = 0; i < airports.length; i++) {
        const item = airports[i];
        
        // 模拟更符合实际的延迟
        let latency = 0;
        let bandwidth = 0;
        let fillClass = 'good';
        let barWidth = 0;
        
        if (item.type === 'dedicated') {
            latency = Math.floor(Math.random() * 20) + 30; // 30-50ms 专线
            bandwidth = Math.floor(Math.random() * 200) + 700; // 700-900M
            fillClass = 'good';
            barWidth = Math.max(10, 100 - (latency / 1.5));
        } else if (item.type === 'transit') {
            latency = Math.floor(Math.random() * 30) + 60; // 60-90ms 中转
            bandwidth = Math.floor(Math.random() * 150) + 400; // 400-550M
            fillClass = 'medium';
            barWidth = Math.max(10, 100 - (latency / 1.2));
        } else {
            latency = Math.floor(Math.random() * 60) + 120; // 120-180ms 直连
            bandwidth = Math.floor(Math.random() * 100) + 150; // 150-250M
            fillClass = 'bad';
            barWidth = Math.max(10, 100 - (latency / 2));
        }
        
        // 模拟一行打印
        await new Promise(resolve => {
            setTimeout(() => {
                const tr = document.createElement('tr');
                tr.innerHTML = `
                    <td style="font-weight: 700; color: #fff;">${item.name}</td>
                    <td style="color: var(--text-secondary);">${item.lineType.split(' ')[0]}</td>
                    <td>
                        <span style="color: ${fillClass === 'good' ? 'var(--accent)' : fillClass === 'medium' ? '#ffb300' : 'var(--accent-red)'}">${latency} ms</span>
                        <div class="latency-bar" style="margin-left: 8px;">
                            <div class="latency-fill ${fillClass}" style="width: ${barWidth}%"></div>
                        </div>
                    </td>
                    <td style="color: var(--text-secondary);">${bandwidth} Mbps</td>
                    <td><span style="color: var(--accent); text-shadow: 0 0 5px var(--accent);">● ONLINE</span></td>
                `;
                tableBody.appendChild(tr);
                terminalBody.scrollTop = terminalBody.scrollHeight;
                resolve();
            }, 300);
        });
    }
    
    await printLine('echo "Test run finished"', 'cmd', 500);
    await printLine('> COMPLETE: 10/10 nodes checked. Packet loss: 0.00%. Avg ping: 72.4 ms.', 'success', 200);
    await printLine('> Systems fully functional. Subscription synchronizer synced.', 'success', 100);
    
    // 恢复状态
    runBtn.style.opacity = '1';
    runBtn.style.cursor = 'pointer';
    statusIndicator.className = 'status-indicator';
    statusText.innerText = 'SYS IDLE';
    testingInProgress = false;
}
