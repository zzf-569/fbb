//
//  FirstLoginViewController.swift
//  pink
//
//  Created by xfffff on 2026/7/10.
//  Copyright © 2026 pink. All rights reserved.
//

import UIKit

class FirstLoginViewController: LMBaseVC {

    private let accentColor = UIColor(red: 139 / 255, green: 1, blue: 0, alpha: 1)
    private let buttonColor = UIColor(red: 19 / 255, green: 31 / 255, blue: 22 / 255, alpha: 1)

   

    /// 顶部主插画资源位（当前留空）。
    private let heroImageView: UIImageView = {
        let imageView = UIImageView().image(UIImage(named: "login_icon"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let sloganLabel: UILabel = {
        let label = UILabel()
        label.text = "Kindred spirits always find\neach other"
        label.textColor = UIColor(red: 27 / 255, green: 34 / 255, blue: 29 / 255, alpha: 1)
        label.font = lmFontM(20)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()

    private lazy var appleButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = buttonColor
        button.layer.cornerRadius = 9
        button.setTitle("Sign in with Apple", for: .normal)
        button.setTitleColor(accentColor, for: .normal)
        button.titleLabel?.font = lmFontR(20)
        button.addTarget(self, action: #selector(appleSignIn), for: .touchUpInside)
        return button
    }()

    /// Apple 图标资源位（当前留空）。
    private let appleIconView: UIImageView = {
        let imageView = UIImageView().image((UIImage(named: "login_apple")))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let alternativeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Other"
        label.textColor = UIColor(white: 0.67, alpha: 1)
        label.font = lmFontR(12)
        label.textAlignment = .center
        return label
    }()

    private let leftLine = FirstLoginViewController.makeSeparatorLine()
    private let rightLine = FirstLoginViewController.makeSeparatorLine()

    /// 底部其他登录方式图标资源位（当前均留空）。
    private let alternativeIconViews: [UIButton] = ["login_mail", "login_phone", "login_peo", "login_lock"].map { imageStr in
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: imageStr), for: .normal)
        return button
    }

    private let agreementLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        configureView()
        configureAgreement()
        IMService.shared.initSDK()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    private func configureView() {
        view.backgroundColor = .white
        backgroundImage = nil
        [heroImageView, sloganLabel, appleButton, alternativeTitleLabel,
         leftLine, rightLine, agreementLabel].forEach(view.addSubview)
        appleButton.addSubview(appleIconView)

        let iconStack = UIStackView(arrangedSubviews: alternativeIconViews)
        iconStack.axis = .horizontal
        iconStack.alignment = .center
        iconStack.distribution = .equalSpacing
        view.addSubview(iconStack)

        heroImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(kScaleWidth(76))
            make.centerX.equalToSuperview()
            make.width.equalTo(kScaleWidth(228))
            make.height.equalTo(kScaleWidth(260))
        }

        sloganLabel.snp.makeConstraints { make in
            make.top.equalTo(heroImageView.snp.bottom).offset(kScaleWidth(16))
            make.left.right.equalToSuperview().inset(kScaleWidth(30))
        }

        appleButton.snp.makeConstraints { make in
            make.top.equalTo(sloganLabel.snp.bottom).offset(kScaleWidth(28))
            make.left.right.equalToSuperview().inset(kScaleWidth(42))
            make.height.equalTo(kScaleWidth(56))
        }

        appleIconView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(appleButton.titleLabel!.snp.left).offset(-8)
            make.width.height.equalTo(22)
        }

        alternativeTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(appleButton.snp.bottom).offset(kScaleWidth(18))
            make.centerX.equalToSuperview()
        }

        leftLine.snp.makeConstraints { make in
            make.centerY.equalTo(alternativeTitleLabel)
            make.left.equalToSuperview().offset(kScaleWidth(122))
            make.right.equalTo(alternativeTitleLabel.snp.left).offset(-8)
            make.height.equalTo(1)
        }

        rightLine.snp.makeConstraints { make in
            make.centerY.equalTo(alternativeTitleLabel)
            make.left.equalTo(alternativeTitleLabel.snp.right).offset(8)
            make.right.equalToSuperview().offset(-kScaleWidth(122))
            make.height.equalTo(1)
        }

        iconStack.snp.makeConstraints { make in
            make.top.equalTo(alternativeTitleLabel.snp.bottom).offset(kScaleWidth(24))
            make.left.right.equalToSuperview().inset(kScaleWidth(72))
            make.height.equalTo(46)
        }

        alternativeIconViews.forEach { iconView in
            iconView.snp.makeConstraints { make in
                make.width.height.equalTo(46)
            }
        }

        agreementLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-12)
        }
        
        for (index, button) in alternativeIconViews.enumerated() {
            button.tag = index + 1
            button.addTarget(self, action: #selector(loginClick), for: .touchUpInside)
        }
        
    }

    private func configureAgreement() {
        let prefix = "By logging in or registering, you agree to the "
        let service = "User\nService Terms"
        let text = prefix + service
        let attributed = NSMutableAttributedString(
            string: text,
            attributes: [
                .font: lmFontR(11),
                .foregroundColor: UIColor(white: 0.67, alpha: 1)
            ]
        )
        attributed.addAttributes([
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .foregroundColor: UIColor(white: 0.48, alpha: 1)
        ], range: (text as NSString).range(of: service))
        agreementLabel.attributedText = attributed

        agreementLabel.addGestureTap { [weak self] _ in
            guard let self else { return }
            self.navigationController?.pushViewController(
                BaseWebViewController(loadUrl: AppConfig.URL.service),
                animated: true
            )
        }
    }

    @objc private func appleSignIn() {
        // UI 已预留 Apple 登录入口；接入授权 SDK 后在此发起登录。
    }
    
    @objc func loginClick(sender:UIButton) {
        self.navigationController?.pushViewController(LoginViewController(type: loginType(rawValue: sender.tag) ?? .emaile), animated: true)

    }

    private static func makeSeparatorLine() -> UIView {
        let line = UIView()
        line.backgroundColor = UIColor(white: 0.72, alpha: 1)
        return line
    }
}
