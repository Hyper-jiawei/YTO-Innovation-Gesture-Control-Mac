# Apple Silicon Mac 部署

本仓库基于 [Windows 原项目](https://github.com/Hyper-jiawei/YTO-Innovation-Gesture-Control) 适配 Mac M1。功能、演示素材、业务规则和模型沿用原项目。

## 安装与启动

测试设备：MacBook Air M1 2020，7 核 GPU，8 GB 内存，macOS 15.7.9，FaceTime 高清相机。
目标环境：Apple Silicon、macOS 14 及以上、原生 ARM64 Python 3.11；其他型号和系统版本未逐一验证。

首次安装需要联网、Git 和 Apple Command Line Tools。未安装工具时先运行 `xcode-select --install` 并完成系统安装，再执行：

```zsh
git clone https://github.com/Hyper-jiawei/YTO-Innovation-Gesture-Control-Mac.git
cd YTO-Innovation-Gesture-Control-Mac
./setup_macos.command
./start.command
```

安装脚本只在工程目录创建 `.tools/`、`.python/` 和 `.venv/`，不向系统Python安装项目依赖；下载并使用固定版本uv，安装原生Python 3.11及锁定依赖，然后编译、临时签名本地应用。依赖和运行时约1.4 GB，建议至少预留2 GB空间。构建产生的 `.app` 不提交Git，源码与Info.plist在 `macos/`。重建启动器可执行 `./macos/build_app.command`。

日常可双击 `YTO手势控制.app` 或 `start.command`；无相机演示双击 `demo.command`。
首次相机提示请选择允许；权限位于“系统设置 → 隐私与安全性 → 摄像头 → YTO手势控制”。直接运行Python时，系统也可能要求启动它的终端或Python的相机权限。

```zsh
./start.command --camera 0
./start.command --camera 1           # 外接相机
./start.command --camera auto
./start.command --no-yolo
YTO_DEVICE=cpu ./start.command       # 强制CPU
./demo.command
```

默认相机0、请求分辨率1280×720；相机实际输出受硬件能力影响。请只开一个实时实例，首次模型预热可能需要十余秒。关闭窗口即可退出。应用启动日志 `outputs/app-launch.log` 每次启动覆盖，照片、报告和事件记录位于 `outputs/`，采集数据位于 `data/`。

## 开发与采集

```zsh
source .venv/bin/activate
python main.py --camera 0
python collect_digits.py --camera 0
python check_environment.py
deactivate
```

项目默认加载仓库自带的三个模型，无需重新训练。推理设备自动尝试CUDA、Metal/MPS、CPU；本机使用Metal。`YTO_DEVICE=cpu`、`mps`、`cuda:0` 可强制选择，显式选择不可用设备时会报错。MediaPipe关键点使用CPU。启动器设置 `PYTORCH_ENABLE_MPS_FALLBACK=1` 和4线程上限；直接运行Python时如需要可自行设置此环境变量。YOLO训练入口支持选择的Metal设备，但本次未进行模型训练验证。

## 依赖与恢复

`requirements-macos.txt` 定义主要依赖；`requirements-macos.lock.txt` 记录本次完整实装版本。

```zsh
./.tools/bin/uv pip install --python .venv/bin/python -r requirements-macos.lock.txt --override overrides-macos.txt
```

MediaPipe要求的 `opencv-contrib-python` 已提供本项目需要的cv2接口；`overrides-macos.txt` 排除Ultralytics重复要求的 `opencv-python`，避免两套包覆盖同一个cv2模块。因此普通依赖检查器会提示缺少 `opencv-python`，这是显式的同模块依赖替代。

MediaPipe 0.10.21安装包内部WHEEL标签标为x86_64，依赖检查器也会提示平台不符；实查 `_framework_bindings` 包含arm64和x86_64，已通过ARM64 Python加载和推理验证。保持已验证的锁定组合，不要直接套用Windows/CUDA安装命令。

虚拟环境包含绝对路径，移动或重命名目录后应重新创建 `.venv`。本地解释器、环境、日志、照片、采集数据、构建应用和机器专用说明均不上传仓库。

## 本次验证

2026-10-29在上述M1设备完成：

- 79项自动化测试全部通过，包含macOS/Windows/Linux相机后端、权限预检及设备覆盖配置回归测试。
- Metal前向及反向计算、手势模型加载、MediaPipe空白帧处理、YOLO12n实际推理通过。
- YOLO合成图测试首次约12.4秒，后续三次约59、32、35毫秒，不代表端到端帧率。
- 离线界面4秒显示75帧，内置相机实时界面12秒显示89帧；原生启动脚本链路另行验证通过。

```zsh
./.venv/bin/python -B -s -m unittest discover -s tests -v
./demo.command --smoke 4
./start.command --camera 0 --smoke 12
```

以上为运行验证，不是跨人员手势准确率结论。原README中的RTX5060性能及分类准确率属于原Windows开发环境。当前传送带与格口为本地模拟，未接入PLC与企业上报接口；“破损件上报”仍为操作员发起取证和物品类别检测。
