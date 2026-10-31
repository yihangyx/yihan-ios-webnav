import UIKit

/// 个人信息页
final class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private let tableView = UITableView(frame: .zero, style: .plain)

    private let rows: [(title: String, value: String)] = [
        ("昵称", "奕涵"),
        ("账号", "yihan"),
        ("联系邮箱", "yihan@example.com"),
        ("简介", "自用导航工具箱")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "我的"
        view.backgroundColor = UIColor(red: 0.96, green: 0.97, blue: 0.99, alpha: 1.0)
        setupTable()
    }

    private func setupTable() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .clear
        view.addSubview(tableView)

        let header = ProfileHeader()
        header.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 150)
        tableView.tableHeaderView = header

        if #available(iOS 11.0, *) {
            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        } else {
            tableView.frame = view.bounds
            tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
            ?? UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        let row = rows[indexPath.row]
        cell.textLabel?.text = row.title
        cell.detailTextLabel?.text = row.value
        cell.accessoryType = .none
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
        return "版本 \(version) · 兼容 iOS 12.0+"
    }
}

private final class ProfileHeader: UIView {

    private let avatar = UILabel()
    private let nameLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        avatar.text = "奕"
        avatar.textColor = .white
        avatar.textAlignment = .center
        avatar.font = UIFont.systemFont(ofSize: 26, weight: .semibold)
        avatar.backgroundColor = UIColor(red: 0.16, green: 0.42, blue: 0.90, alpha: 1.0)
        avatar.layer.cornerRadius = 38
        avatar.clipsToBounds = true
        avatar.translatesAutoresizingMaskIntoConstraints = false

        nameLabel.text = "奕涵"
        nameLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        addSubview(avatar)
        addSubview(nameLabel)

        NSLayoutConstraint.activate([
            avatar.centerXAnchor.constraint(equalTo: centerXAnchor),
            avatar.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            avatar.widthAnchor.constraint(equalToConstant: 76),
            avatar.heightAnchor.constraint(equalToConstant: 76),
            nameLabel.topAnchor.constraint(equalTo: avatar.bottomAnchor, constant: 12),
            nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
