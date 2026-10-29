#!/bin/zsh
set -euo pipefail
cd -- "${0:A:h}"
if [[ "$(uname -s)" != Darwin || "$(uname -m)" != arm64 ]]; then
  echo "此安装脚本面向 Apple Silicon Mac，请使用原部署指南安装其他平台。"
  exit 1
fi
if ! xcode-select -p >/dev/null 2>&1; then
  echo "请先运行 xcode-select --install，完成 Apple Command Line Tools 安装后重试。"
  exit 1
fi
if [[ ! -x .tools/bin/uv ]]; then
  /usr/bin/python3 -m pip install --target "$PWD/.tools" uv==0.13.6
fi
./.tools/bin/uv python install 3.11 --install-dir "$PWD/.python"
if [[ ! -x .venv/bin/python ]]; then
  ./.tools/bin/uv venv --python "$PWD/.python/cpython-3.11-macos-aarch64-none/bin/python3" .venv
fi
./.tools/bin/uv pip install --python .venv/bin/python -r requirements-macos.lock.txt --override overrides-macos.txt
./macos/build_app.command
./.venv/bin/python check_environment.py
echo "安装完成。双击 YTO手势控制.app 或运行 ./start.command。"
