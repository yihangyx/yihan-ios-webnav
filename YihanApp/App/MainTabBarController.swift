import UIKit

/// 底部三个 Tab：主页 / 邮箱 / 我的
final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let homeNav = UINavigationController(rootViewController: HomeViewController())
        homeNav.tabBarItem = UITabBarItem(title: "主页", image: nil, tag: 0)

        let mailNav = UINavigationController(rootViewController: MailViewController())
        mailNav.tabBarItem = UITabBarItem(title: "邮箱", image: nil, tag: 1)

        let profileNav = UINavigationController(rootViewController: ProfileViewController())
        profileNav.tabBarItem = UITabBarItem(title: "我的", image: nil, tag: 2)

        viewControllers = [homeNav, mailNav, profileNav]
    }
}
