# 奕涵导航（YihanApp）

纯 UIKit 编写的 iOS 导航工具，**Deployment Target = iOS 12.0**，可在 iPhone 5s（最高 iOS 12.5.7）上运行。

## 功能

- **主页**：站点按钮列表，点击进入内嵌 WebView 网页
  - 抖音：https://www.douyin.com/
  - ysgcgk：https://ysgcgk.com/
  - 另有 4 个预留位，配置后直接启用
- **邮箱**：昵称 / 邮箱 / 留言表单，调起系统邮件发送；设备未登录邮箱时自动复制内容到剪贴板
- **我的**：个人信息展示页（昵称、账号、邮箱、简介、版本号）
- **底部 Tab**：主页 / 邮箱 / 我的

## 目录结构

```
├── project.yml                     # XcodeGen 工程配置（Actions 自动生成 .xcodeproj）
├── scripts/build-ipa.sh            # 云端编译并打包未签名 IPA
├── .github/workflows/build-ipa.yml # GitHub Actions 自动编译
└── YihanApp/
    ├── App/                        # AppDelegate + TabBar 框架
    ├── Home/SiteConfig.swift       # ★ 站点配置数组，新增站点只改这里
    ├── Home/HomeViewController.swift
    ├── Web/WebViewController.swift
    ├── Mail/MailViewController.swift   # ★ supportEmail 改成你的收件邮箱
    └── Profile/ProfileViewController.swift
```

## 如何新增站点

打开 `YihanApp/Home/SiteConfig.swift`，在 `sites` 数组中复制一行并修改：

```swift
SiteItem(title: "新站点",
         subtitle: "xxx.com",
         url: "https://xxx.com/",
         enabled: true,
         color: UIColor(red: 0.20, green: 0.68, blue: 0.45, alpha: 1.0)),
```

占位位启用：把对应条目的 `url` 填上真实网址、`enabled` 改为 `true` 即可。

## 修改收件邮箱

`YihanApp/Mail/MailViewController.swift` 顶部：

```swift
private let supportEmail = "yihan@example.com" // 改成你的邮箱
```

## 云端编译 IPA（GitHub Actions）

推送代码到 `main`，或在 **Actions → build-ios-ipa → Run workflow** 手动触发，约 1 分钟出包。

### 下载 IPA（两个渠道，注意区别）

1. **Releases（推荐，拿到的就是 `.ipa` 本体）**：仓库首页右侧 **Releases → latest-build → 下载 `YihanApp.ipa`**，无需二次解压。
2. **Actions Artifacts（外层套了 zip，必须先解压）**：某次运行记录底部 **Artifacts** 下载的 `YihanApp-iOS12-unsigned-ipa.zip` 是压缩包，**先解压，里面的 `YihanApp.ipa` 才是安装包**；直接把这个外层 zip 拖进安装工具会报"安装包不完整/格式错误"。

打包脚本内置结构自检：Info.plist、主二进制、Frameworks、PkgInfo 缺一即编译失败退出，不会产出残缺包。

### 安装到 iPhone 5s（iOS 12.5.7）

云端 runner 没有苹果开发者证书，产出的是**未签名 IPA**，iOS 不允许未签名程序直接安装，必须先用自签工具签名：

- **Sideloadly（Windows 首选）**
  1. iPhone 用数据线连电脑，手机上点"信任此电脑"；
  2. 打开 Sideloadly，拖入 `YihanApp.ipa`（不是外层 zip）；
  3. 填 Apple ID（免费账号即可，需要开 App 专用密码/直接在工具内登录），点 Start；
  4. 安装后到 **设置 → 通用 → VPN与设备管理** 信任该开发者证书；
  5. 免费账号签名 7 天有效，到期重新用 Sideloadly 刷一次。
- **AltStore**：类似原理，可后台保活续期，适合长期用。
- **付费开发者账号（$99/年）**：把证书 .p12 和描述文件放进仓库 Secrets，脚本加 `codesign` 步骤即可出可直接安装的正式 IPA。

> 若安装工具提示"安装包不完整/已损坏/无法安装"，按顺序排查：①是否误把 Actions 外层 zip 当 IPA；②IPA 是否完整下载（Releases 直链文件应约 15 MB）；③是否经过 Sideloadly 等工具签名（未签名无法直装）。

## iOS 12 兼容性说明

- 未使用 SwiftUI（iOS 13+）、未使用 SF Symbols（iOS 13+）、未使用 SceneDelegate（iOS 13+）。
- 全部使用传统 UIKit 组件与老版本 API，`MinimumOSVersion = 12.0`、架构 arm64，适配 iPhone 5s。
- `UIRequiresFullScreen = true`，无需 LaunchStoryboard 也能通过启动配置校验。
- Swift 运行时 dylib（libswiftCore 等 13 个）已内嵌进 `Frameworks/`，iOS 12 系统无内置 Swift 库也能运行。
- `Info.plist` 已开启 WebView 任意加载（NSAllowsArbitraryLoadsInWebContent），避免 http 站点打不开。
