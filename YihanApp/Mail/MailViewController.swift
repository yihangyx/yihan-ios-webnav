import UIKit
import MessageUI

/// 邮箱接口页：填写昵称 / 邮箱 / 留言，优先调起系统邮件发送；
/// 设备未登录邮箱账户时自动把内容复制到剪贴板，保证不丢内容。
final class MailViewController: UIViewController, MFMailComposeViewControllerDelegate {

    // TODO: 改成你自己的收件邮箱
    private let supportEmail = "yihan@example.com"

    private let nameField = UITextField()
    private let emailField = UITextField()
    private let messageView = UITextView()
    private let submitButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "邮箱联系"
        view.backgroundColor = UIColor(red: 0.96, green: 0.97, blue: 0.99, alpha: 1.0)
        setupUI()
    }

    private func setupUI() {
        let card = UIView()
        card.backgroundColor = .white
        card.layer.cornerRadius = 12
        card.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(card)

        let nameLabel = UILabel()
        nameLabel.text = "昵称"
        nameLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        let emailLabel = UILabel()
        emailLabel.text = "邮箱"
        emailLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        let msgLabel = UILabel()
        msgLabel.text = "留言"
        msgLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)

        [nameLabel, emailLabel, msgLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            card.addSubview($0)
        }

        nameField.placeholder = "请输入昵称"
        nameField.borderStyle = .roundedRect
        emailField.placeholder = "请输入你的邮箱"
        emailField.keyboardType = .emailAddress
        emailField.borderStyle = .roundedRect

        messageView.layer.borderWidth = 1
        messageView.layer.borderColor = UIColor(white: 0.88, alpha: 1.0).cgColor
        messageView.layer.cornerRadius = 8
        messageView.font = UIFont.systemFont(ofSize: 15)

        [nameField, emailField, messageView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            card.addSubview($0)
        }

        submitButton.setTitle("发送邮件", for: .normal)
        submitButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.backgroundColor = UIColor(red: 0.16, green: 0.42, blue: 0.90, alpha: 1.0)
        submitButton.layer.cornerRadius = 10
        submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(submitButton)

        if #available(iOS 11.0, *) {
            NSLayoutConstraint.activate([
                card.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
                card.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                card.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

                nameLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 16),
                nameLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
                nameField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
                nameField.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
                nameField.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
                nameField.heightAnchor.constraint(equalToConstant: 44),

                emailLabel.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 16),
                emailLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
                emailField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 8),
                emailField.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
                emailField.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
                emailField.heightAnchor.constraint(equalToConstant: 44),

                msgLabel.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 16),
                msgLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
                messageView.topAnchor.constraint(equalTo: msgLabel.bottomAnchor, constant: 8),
                messageView.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
                messageView.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
                messageView.heightAnchor.constraint(equalToConstant: 120),
                messageView.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -16),

                submitButton.topAnchor.constraint(equalTo: card.bottomAnchor, constant: 20),
                submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                submitButton.heightAnchor.constraint(equalToConstant: 48)
            ])
        }
    }

    @objc private func submitTapped() {
        guard let name = nameField.text,
              !name.trimmingCharacters(in: .whitespaces).isEmpty else {
            showTip("请先输入昵称")
            return
        }
        guard let email = emailField.text, isValidEmail(email) else {
            showTip("请输入正确的邮箱地址")
            return
        }
        let body = "昵称：\(name)\n联系邮箱：\(email)\n留言：\(messageView.text ?? "")"

        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([supportEmail])
            mail.setSubject("App 来信：\(name)")
            mail.setMessageBody(body, isHTML: false)
            present(mail, animated: true)
        } else {
            // 设备未配置系统邮箱账户：复制到剪贴板兜底
            UIPasteboard.general.string = "收件人：\(supportEmail)\n\(body)"
            showTip("设备未登录邮箱账户，内容已复制到剪贴板，可手动粘贴发送")
        }
    }

    private func isValidEmail(_ text: String) -> Bool {
        let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: text)
    }

    private func showTip(_ message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "知道了", style: .default))
        present(alert, animated: true)
    }

    // MARK: - MFMailComposeViewControllerDelegate
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult,
                               error: Error?) {
        controller.dismiss(animated: true)
        if result == .sent {
            messageView.text = ""
            showTip("发送成功")
        }
    }
}
