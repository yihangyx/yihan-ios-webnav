#!/usr/bin/env bash
# 在 GitHub Actions (macOS runner) 上生成结构合规的未签名 IPA
# 无苹果开发者证书，产物为未签名 .ipa，需用 Sideloadly / AltStore 等工具自签后安装到真机
set -euo pipefail

APP_NAME="YihanApp"
SCHEME="YihanApp"
CONFIG="Release"
DD="build/DerivedData"

echo "== 1/5 安装 XcodeGen =="
brew install xcodegen
xcodegen --version

echo "== 2/5 生成 Xcode 工程 =="
xcodegen generate

echo "== 3/5 编译真机版本（不签名，arm64 / iOS 12.0） =="
xcodebuild build \
  -scheme "$SCHEME" \
  -configuration "$CONFIG" \
  -sdk iphoneos \
  -derivedDataPath "$DD" \
  CODE_SIGNING_ALLOWED=NO \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGN_IDENTITY="" \
  PROVISIONING_PROFILE_SPECIFIER=""

APP_PATH="$(find "$DD/Build/Products/Release-iphoneos" -maxdepth 1 -name "*.app" | head -n 1)"
if [ -z "${APP_PATH:-}" ]; then
  echo "ERROR: 未找到编译产物 .app"
  exit 1
fi
echo "产物目录: $APP_PATH"

echo "== 4/5 打包前结构自检（缺项直接报错，杜绝残缺安装包） =="
require_item() {
  if [ ! -e "$APP_PATH/$1" ]; then
    echo "ERROR: 缺少必备项 $1"
    exit 1
  fi
}
require_item "Info.plist"
require_item "$APP_NAME"
require_item "Frameworks"

# 标准 8 字节 PkgInfo
printf 'APPL????' > "$APP_PATH/PkgInfo"

# 清理 macOS 元数据
find "$APP_PATH" -name ".DS_Store" -delete 2>/dev/null || true

# 校验最低系统版本
echo "-- MinimumOSVersion:"
/usr/libexec/PlistBuddy -c "Print :MinimumOSVersion" "$APP_PATH/Info.plist"
echo "-- 主二进制架构:"
file "$APP_PATH/$APP_NAME" || true

echo "== 5/5 打包 IPA（标准 Payload 结构） =="
rm -rf build/ipa Payload
mkdir -p build/ipa/Payload
cp -R "$APP_PATH" "build/ipa/Payload/$APP_NAME.app"
find build/ipa/Payload -name ".DS_Store" -delete 2>/dev/null || true

(cd build/ipa && zip -r -X -q "../../$APP_NAME.ipa" Payload -x "*.DS_Store")

echo "---- IPA 内容清单 ----"
unzip -l "$APP_NAME.ipa"
ls -lh "$APP_NAME.ipa"
echo "== 完成: $APP_NAME.ipa =="
