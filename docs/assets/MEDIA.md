# README 素材索引

五张图片与两段现场视频由项目方提供；功能MP4来自项目实机演示。原始文件保持在本机 `examples/video/` 及项目方视频目录，本目录只收录README使用的发布副本。

| 引用 | 发布文件 | 提供的原始名称 |
|---|---|---|
| 图1 | scenes/conveyor-risk.png | 人攀爬上传送带.png |
| 图2 | scenes/irregular-parcel.png | 传送带异形件扫描上报.png |
| 图3 | scenes/parcel-unpacking.png | 无着件上报 1.png |
| 图4 | scenes/parcel-waybill.png | 无着件上报 2.png |
| 图5 | scenes/vision-pro-gesture.png | appleVisionPro 手势操作.png |
| 现场视频1 | videos/conveyor-risk.mp4 | 传送带站人等危险情况.MP4 |
| 现场视频2 | videos/manual-feeding.mp4 | 手动供件台.MP4 |
| 功能演示 | videos/gesture-control.mp4 | 手势控制启停.mp4 |
| 功能演示 | videos/photo-evidence.mp4 | 快件拍照取证.mp4 |
| 功能演示 | videos/damage-report.mp4 | 破损识别上报.mp4 |
| 功能演示 | videos/gate-binding.mp4 | 格口绑定.mp4 |
| 功能演示 | videos/barcode-scan.mp4 | 单号独立识别.mp4 |

场景PNG保持原图；五段功能MP4从原HEVC/H.265转为H.264视频（已移除音轨）、30fps、原始分辨率的兼容副本，原始素材保留在本机。两段现场MP4转为1280像素宽、H.264视频（已移除音轨）、网页渐进加载副本，完整保留时序；视频同名JPG为对应视频中间位置的真实预览帧。所有MP4均为无音轨H.264视频并将moov索引前置（faststart）。README内嵌同源WebP动图自动循环播放，每段下方保留指向GitHub Pages实际视频资源的高清MP4入口，由浏览器原生播放器打开；不指向GitHub blob文件浏览页。

图3、图4呈现异常件处理动作，不代表图片中的物品已被判定破损。图5用于说明手势交互灵感，不表示本项目使用Apple头显或其技术实现。


## README 自动播放版本

README直接内嵌 `animations/*.webp`，加载后无声自动循环，无需点击；MP4保留为高清补充入口并移除音轨。播放页的video同时设置autoplay、muted、loop和playsinline。

动画从项目方原始视频重新生成，不加速、不慢放：五段功能动图为1280像素宽、30fps时间轴、质量80的动画WebP，单段1.3–3.2MB；两段现场动图为960像素宽、约10–12fps时间轴、质量55–60的动画WebP，单段控制在5MB以内，以便GitHub页面内直接加载播放。全部使用无限循环和逐帧毫秒时间戳，避免传统GIF的色彩和时间精度限制；编码器可合并连续相同画面并累加对应停留时间，不改变动作节奏和片段总时长。逐项时间校验记录在本机outputs/animation-validation.json，未上传运行输出。
