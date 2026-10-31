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

1. 推送代码到 `main` / `master` 分支，或在仓库页面 **Actions → build-ios-ipa → Run workflow** 手动触发。
2. 任务完成后，在对应运行记录底部 **Artifacts** 下载 `YihanApp-iOS12-unsigned-ipa`，解压得到 `YihanApp.ipa`。
3. 打 tag（如 `git tag v1.0.0 && git push origin v1.0.0`）会自动创建 Release 并附上 IPA。

### 安装到 iPhone 5s

云端 runner 没有苹果开发者证书，产出的是**未签名 IPA**，不能直接安装，需用自签工具签名：

- **Sideloadly**（Windows / macOS）：用免费 Apple ID 签名，7 天有效，到期重签。
- **AltStore**：类似原理，后台刷新保活。
- 若有付费开发者账号（$99/年），在 Actions Secrets 中放证书和描述文件即可签名出正式 IPA。

## iOS 12 兼容性说明

- 未使用 SwiftUI（iOS 13+）、未使用 SF Symbols（iOS 13+）、未使用 SceneDelegate（iOS 13+）。
- 全部使用传统 UIKit 组件与老版本 API，最低支持 iOS 12.0，适配 iPhone 5s。
- `Info.plist` 已开启 WebView 任意加载（NSAllowsArbitraryLoadsInWebContent），避免 http 站点打不开。
