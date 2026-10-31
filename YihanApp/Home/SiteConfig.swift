import UIKit

/// 主页站点条目。以后要加新站点，直接在 sites 数组里追加一行即可。
struct SiteItem {
    let title: String
    let subtitle: String
    /// nil 表示占位预留位（按钮显示为待添加，点击提示）；填网址后自动可用
    let url: String?
    let enabled: Bool
    let color: UIColor
}

enum SiteConfig {

    /// 新增站点示例（复制一行改标题和网址即可）：
    /// SiteItem(title: "新站点", subtitle: "xxx.com",
    ///          url: "https://xxx.com/", enabled: true,
    ///          color: UIColor(red: 0.20, green: 0.68, blue: 0.45, alpha: 1.0)),
    static let sites: [SiteItem] = [
        SiteItem(title: "抖音",
                 subtitle: "https://www.douyin.com/",
                 url: "https://www.douyin.com/",
                 enabled: true,
                 color: UIColor(red: 0.90, green: 0.20, blue: 0.32, alpha: 1.0)),
        SiteItem(title: "ysgcgk",
                 subtitle: "https://ysgcgk.com/",
                 url: "https://ysgcgk.com/",
                 enabled: true,
                 color: UIColor(red: 0.16, green: 0.42, blue: 0.90, alpha: 1.0)),
        // 以下为预留位，下次直接把 url 填上、enabled 改为 true 即可启用
        SiteItem(title: "站点三（待添加）", subtitle: "预留位 3", url: nil, enabled: false,
                 color: UIColor(red: 0.66, green: 0.69, blue: 0.74, alpha: 1.0)),
        SiteItem(title: "站点四（待添加）", subtitle: "预留位 4", url: nil, enabled: false,
                 color: UIColor(red: 0.66, green: 0.69, blue: 0.74, alpha: 1.0)),
        SiteItem(title: "站点五（待添加）", subtitle: "预留位 5", url: nil, enabled: false,
                 color: UIColor(red: 0.66, green: 0.69, blue: 0.74, alpha: 1.0)),
        SiteItem(title: "站点六（待添加）", subtitle: "预留位 6", url: nil, enabled: false,
                 color: UIColor(red: 0.66, green: 0.69, blue: 0.74, alpha: 1.0)),
    ]
}
