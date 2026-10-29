#!/bin/zsh
set -euo pipefail
cd -- "${0:A:h:h}"
APP="YTO手势控制.app"
mkdir -p "$APP/Contents/MacOS"
cp macos/Info.plist "$APP/Contents/Info.plist"
swiftc macos/Launcher.swift -o "$APP/Contents/MacOS/yto-launcher" -framework AppKit -framework AVFoundation
codesign --force --sign - "$APP"
echo "已构建：$PWD/$APP"
