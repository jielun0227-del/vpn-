// 动态星环背景动画 (Star Ring Orbit Background)
document.addEventListener('DOMContentLoaded', () => {
    const canvas = document.createElement('canvas');
    canvas.id = 'particles-canvas';
    document.body.prepend(canvas);

    const ctx = canvas.getContext('2d');
    let animationFrameId;

    let width = canvas.width = window.innerWidth;
    let height = canvas.height = window.innerHeight;

    // 静态背景闪烁小星星
    const stars = [];
    const maxStars = 60;

    // 星环轨道配置
    const orbits = [];
    const numOrbits = 5;
    const orbitTilt = -0.22; // 轨道倾斜弧度 (约 -12.5度)
    const bRatio = 0.35;      // 椭圆短半轴与长半轴比例 (Y/X)

    // 轨道上的运行粒子
    const orbitParticles = [];

    // 初始化星空与星环
    function init() {
        width = canvas.width = window.innerWidth;
        height = canvas.height = window.innerHeight;

        // 1. 初始化背景星 field (微弱闪烁)
        stars.length = 0;
        for (let i = 0; i < maxStars; i++) {
            stars.push({
                x: Math.random() * width,
                y: Math.random() * height,
                radius: Math.random() * 1.0 + 0.2,
                opacity: Math.random(),
                speed: Math.random() * 0.015 + 0.005
            });
        }

        // 2. 初始化轨道半径
        orbits.length = 0;
        const baseRadius = Math.min(width, height) * 0.16;
        const spacing = Math.min(width, height) * 0.13;

        for (let i = 0; i < numOrbits; i++) {
            orbits.push({
                radiusX: baseRadius + (i * spacing),
                radiusY: (baseRadius + (i * spacing)) * bRatio,
                color: i % 2 === 0 ? 'rgba(0, 150, 199, 0.06)' : 'rgba(114, 9, 183, 0.04)'
            });
        }

        // 3. 初始化轨道运行粒子
        orbitParticles.length = 0;
        orbits.forEach((orbit, index) => {
            // 每条轨道放置 3 - 6 个运行的粒子星体
            const particleCount = 3 + index;
            for (let i = 0; i < particleCount; i++) {
                orbitParticles.push({
                    orbitIndex: index,
                    // 均匀分布初始角度
                    theta: (Math.PI * 2 / particleCount) * i + Math.random() * 0.4,
                    // 离心轨道速度：越内圈运行越快
                    speed: (0.0035 / (index * 0.5 + 1)) * (Math.random() * 0.3 + 0.85),
                    radius: Math.random() * 1.5 + 1.2,
                    color: Math.random() > 0.5 ? 'rgba(0, 150, 199, 0.65)' : 'rgba(114, 9, 183, 0.6)'
                });
            }
        });
    }

    // 计算椭圆倾斜轨道在 Canvas 上的绝对 X, Y 坐标
    function getOrbitCoords(centerX, centerY, radiusX, radiusY, theta, tiltAngle) {
        // 未倾斜时的局部坐标
        const xLocal = radiusX * Math.cos(theta);
        const yLocal = radiusY * Math.sin(theta);

        // 应用旋转矩阵旋转 tiltAngle 弧度
        const xRotated = xLocal * Math.cos(tiltAngle) - yLocal * Math.sin(tiltAngle);
        const yRotated = xLocal * Math.sin(tiltAngle) + yLocal * Math.cos(tiltAngle);

        return {
            x: centerX + xRotated,
            y: centerY + yRotated
        };
    }

    // 绘制与更新主循环
    function animate() {
        ctx.clearRect(0, 0, width, height);

        // 轨道中心点 (放置在中心位置)
        const centerX = width * 0.5;
        const centerY = height * 0.48;

        // 1. 绘制背景散落小星星 (融于白底，所以使用深灰字体的超高透明度)
        stars.forEach(star => {
            star.opacity += star.speed;
            if (star.opacity > 1 || star.opacity < 0) {
                star.speed = -star.speed;
            }
            ctx.beginPath();
            ctx.arc(star.x, star.y, star.radius, 0, Math.PI * 2);
            ctx.fillStyle = `rgba(15, 23, 42, ${Math.max(0.04, star.opacity * 0.08)})`; 
            ctx.fill();
        });

        // 2. 绘制倾斜椭圆星轨
        orbits.forEach(orbit => {
            ctx.beginPath();
            for (let theta = 0; theta < Math.PI * 2; theta += 0.04) {
                const coords = getOrbitCoords(centerX, centerY, orbit.radiusX, orbit.radiusY, theta, orbitTilt);
                if (theta === 0) {
                    ctx.moveTo(coords.x, coords.y);
                } else {
                    ctx.lineTo(coords.x, coords.y);
                }
            }
            ctx.closePath();
            ctx.strokeStyle = orbit.color;
            ctx.lineWidth = 1;
            ctx.stroke();
        });

        // 3. 绘制并更新运行星体粒子
        orbitParticles.forEach(p => {
            p.theta += p.speed;
            if (p.theta > Math.PI * 2) {
                p.theta -= Math.PI * 2;
            }

            const orbit = orbits[p.orbitIndex];
            const coords = getOrbitCoords(centerX, centerY, orbit.radiusX, orbit.radiusY, p.theta, orbitTilt);

            ctx.beginPath();
            ctx.arc(coords.x, coords.y, p.radius, 0, Math.PI * 2);
            ctx.fillStyle = p.color;
            
            // 亮色主题下添加微发光
            ctx.shadowBlur = 5;
            ctx.shadowColor = p.color;
            ctx.fill();
            ctx.shadowBlur = 0; // 重置
        });

        animationFrameId = requestAnimationFrame(animate);
    }

    // 窗口尺寸缩放监听
    window.addEventListener('resize', () => {
        init();
    });

    init();
    animate();
});
