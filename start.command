#!/bin/zsh
cd -- "${0:A:h}" || exit 1
if [[ ! -x "$PWD/.venv/bin/python" || ! -d "$PWD/YTO手势控制.app" ]]; then
  echo "请先运行 ./setup_macos.command 安装环境并构建 Mac 启动器。"
  exit 1
fi
# Launch through the app bundle so macOS can persist camera permission.
exec /usr/bin/open -n -W --env "YTO_DEVICE=${YTO_DEVICE:-auto}" "$PWD/YTO手势控制.app" --args "$@"
