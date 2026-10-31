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

### 安装到 iPhone 5s（iOS 12.5.7，仅 Windows 电脑，设备不越狱）

**先理解前提**：云端 runner 没有苹果开发者证书，产出的是**未签名 IPA**；iOS 不允许未签名程序直接安装。用爱思/PP/海马等国内助手**直接点"安装"**推这个未签名包，就会报 **"错误码 25 / 安装失败 / 无法验证 App"**——这不是安装包损坏，而是缺签名。**必须先用签名工具签一遍，再安装**，手机全程不需要越狱。

#### 方法一：爱思助手免费自签（Windows 推荐）

1. 电脑安装爱思助手，并安装 iTunes（或爱思里点"修复驱动"），数据线连 iPhone，手机弹窗点"信任此电脑"；
2. 进入 **工具箱 → IPA 签名**（旧版在"应用游戏/我的游戏"页面的签名入口）；
3. 点"添加文件"，选择 Releases 里下载的 `YihanApp.ipa`（**不要**选 Actions 外层 zip）；
4. 签名方式**必须选"使用 Apple ID 签名"**，登录你自己的 Apple ID（免费账号即可，按提示收 2FA 验证码）；**不要选"企业证书签名 / 共享证书 / 免越狱一键签名"等第三方通道**——那种共享描述文件绑定的是别人的 BundleID，与本 App 不匹配，签完安装仍会报"安装包不完整"；
5. 点"开始签名"，等待"签名成功"，得到一个**已签名的 ipa**（注意保存目录，文件名通常带签名标识）；
6. 回到爱思"应用游戏"界面，把**已签名的 ipa** 安装到手机；
7. 手机进入 **设置 → 通用 → VPN与设备管理**，点开刚生成的开发者证书，点"信任"；
8. 桌面出现"奕涵导航"图标即可打开。免费账号签名 **7 天有效**，过期删除 App 后重复第 2–7 步重签。

#### 方法二：Sideloadly（备选）

1. 官网下载 Windows 版安装，手机连电脑并点"信任"；
2. 拖入 `YihanApp.ipa`，填入 Apple ID 与密码，点 Start，完成后自动装到手机；
3. 手机 **设置 → 通用 → VPN与设备管理** 信任证书；免费签名同样 7 天有效。

#### 报错对照表

| 现象 | 原因 | 处理 |
| --- | --- | --- |
| 错误码 25 / 安装失败 / 无法验证 App | 未签名直接安装（最常见） | 先用方法一第 2–5 步签名，再装已签名包 |
| 安装包格式错误/不完整 | 把 Actions 外层 zip 当成了 ipa | 从 Releases 直链下载 `YihanApp.ipa`，约 15 MB |
| 已签名但安装仍报"安装包不完整" | 误用共享企业证书：描述文件 BundleID（如某企业 `hk.com.hsbc…`）与本 App `com.yihan.webnav` 不一致，签名链校验被拒 | 丢弃该签名包，IPA 签名界面改选"使用 Apple ID 签名"；正常产物描述文件 TeamName 应为本人账号，而非某企业名称 |
| 助手连不上设备 | 缺驱动/数据线问题 | 换原装数据线、爱思修复驱动、重启手机 |
| 安装提示空间不足 | 存储不够 | 清理手机存储后重试 |
| 签名时提示额度已满 | 免费 ID 同时最多 3 个侧载 App | 先删除旧的自签 App 再签 |
| 想 7 天不重签、点图标即用 | 需要正式签名 | 提供付费开发者证书（.p12 + 描述文件），可把 Actions 改成自动签名出正式 IPA |

## iOS 12 兼容性说明

- 未使用 SwiftUI（iOS 13+）、未使用 SF Symbols（iOS 13+）、未使用 SceneDelegate（iOS 13+）。
- 全部使用传统 UIKit 组件与老版本 API，`MinimumOSVersion = 12.0`、架构 arm64，适配 iPhone 5s。
- `UIRequiresFullScreen = true`，无需 LaunchStoryboard 也能通过启动配置校验。
- Swift 运行时 dylib（libswiftCore 等 13 个）已内嵌进 `Frameworks/`，iOS 12 系统无内置 Swift 库也能运行。
- `Info.plist` 已开启 WebView 任意加载（NSAllowsArbitraryLoadsInWebContent），避免 http 站点打不开。
