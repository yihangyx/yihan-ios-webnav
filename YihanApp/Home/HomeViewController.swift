import UIKit

/// 主页：站点按钮列表，数据来自 SiteConfig.sites，新增站点只改配置数组
final class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private let tableView = UITableView(frame: .zero, style: .plain)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "主页"
        view.backgroundColor = UIColor(red: 0.96, green: 0.97, blue: 0.99, alpha: 1.0)
        setupTable()
    }

    private func setupTable() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SiteCell.self, forCellReuseIdentifier: SiteCell.reuseId)
        tableView.rowHeight = 66
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .clear
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 70, bottom: 0, right: 16)
        view.addSubview(tableView)

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

    // MARK: - UITableView

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SiteConfig.sites.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SiteCell.reuseId, for: indexPath) as! SiteCell
        cell.configure(SiteConfig.sites[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = SiteConfig.sites[indexPath.row]

        guard item.enabled, let urlString = item.url, let url = URL(string: urlString) else {
            let alert = UIAlertController(title: "提示",
                                          message: "该站点尚未配置，请先在 SiteConfig.swift 中填写网址并开启。",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "知道了", style: .default))
            present(alert, animated: true)
            return
        }

        let webVC = WebViewController(url: url, title: item.title)
        navigationController?.pushViewController(webVC, animated: true)
    }
}

// MARK: - 列表 Cell
final class SiteCell: UITableViewCell {

    static let reuseId = "SiteCell"

    private let iconBlock = UIView()
    private let titleLabel = UILabel()
    private let subLabel = UILabel()
    private let arrowLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setup() {
        selectionStyle = .default

        iconBlock.translatesAutoresizingMaskIntoConstraints = false
        iconBlock.layer.cornerRadius = 10

        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        subLabel.font = UIFont.systemFont(ofSize: 12)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subLabel.translatesAutoresizingMaskIntoConstraints = false

        arrowLabel.text = "›"
        arrowLabel.font = UIFont.systemFont(ofSize: 24)
        arrowLabel.textColor = UIColor(white: 0.74, alpha: 1.0)
        arrowLabel.translatesAutoresizingMaskIntoConstraints = false

        let stack = UIStackView(arrangedSubviews: [titleLabel, subLabel])
        stack.axis = .vertical
        stack.spacing = 3
        stack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(iconBlock)
        contentView.addSubview(stack)
        contentView.addSubview(arrowLabel)

        NSLayoutConstraint.activate([
            iconBlock.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconBlock.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconBlock.widthAnchor.constraint(equalToConstant: 38),
            iconBlock.heightAnchor.constraint(equalToConstant: 38),

            stack.leadingAnchor.constraint(equalTo: iconBlock.trailingAnchor, constant: 12),
            stack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stack.trailingAnchor.constraint(lessThanOrEqualTo: arrowLabel.leadingAnchor, constant: -8),

            arrowLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            arrowLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    func configure(_ item: SiteItem) {
        iconBlock.backgroundColor = item.color
        titleLabel.text = item.title
        subLabel.text = item.subtitle
        titleLabel.textColor = item.enabled ? UIColor.darkText : UIColor.lightGray
        subLabel.textColor = item.enabled ? UIColor(white: 0.45, alpha: 1.0) : UIColor.lightGray
        arrowLabel.isHidden = !item.enabled
    }
}
