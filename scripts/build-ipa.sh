#!/usr/bin/env bash
# 在 GitHub Actions (macOS runner) 上生成未签名 IPA
# 无苹果开发者证书，产物为未签名 .ipa，需用 Sideloadly / AltStore 等工具自签后安装到真机
set -euo pipefail

APP_NAME="YihanApp"
SCHEME="YihanApp"
CONFIG="Release"
DD="build/DerivedData"

echo "== 1/4 安装 XcodeGen =="
brew install xcodegen
xcodegen --version

echo "== 2/4 生成 Xcode 工程 =="
xcodegen generate

echo "== 3/4 编译真机版本（不签名） =="
xcodebuild build \
  -scheme "$SCHEME" \
  -configuration "$CONFIG" \
  -sdk iphoneos \
  -derivedDataPath "$DD" \
  CODE_SIGNING_ALLOWED=NO \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGN_IDENTITY="" \
  PROVISIONING_PROFILE_SPECIFIER=""

APP_PATH=$(find "$DD/Build/Products/Release-iphoneos" -maxdepth 1 -name "*.app" | head -n 1)
if [ -z "${APP_PATH:-}" ]; then
  echo "ERROR: 未找到编译产物 .app"
  exit 1
fi
echo "产物: $APP_PATH"

echo "== 4/4 打包 IPA =="
rm -rf build/ipa Payload
mkdir -p build/ipa/Payload
cp -R "$APP_PATH" "build/ipa/Payload/$APP_NAME.app"

(cd build/ipa && zip -r -q "../../$APP_NAME.ipa" Payload)

ls -lh "$APP_NAME.ipa"
echo "== 完成: $APP_NAME.ipa =="
