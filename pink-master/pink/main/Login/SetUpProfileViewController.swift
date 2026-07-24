import UIKit
import ZLPhotoBrowser
import Qiniu

final class SetUpProfileViewController: LMBaseVC {
    private var avatarURL = ""
    private var selectedCountry = CountrySelectItem(name: "英国", dialCode: "+44", flag: "🇬🇧")

    private lazy var titleLabel: UILabel = {
        let label = UILabel(lmfont: lmFontM(24), textColor: lmColorHex("#192218"))
            .lmtext("Set Up Your Profile")
            .textAlignment(.center)
        return label
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel(lmfont: lmFontR(14), textColor: lmColorHex("#192218", alpha: 0.58))
            .lmtext("Complete profile to see full details~")
            .textAlignment(.center)
        return label
    }()

    private lazy var avatarView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = lmColorHex("#192218", alpha: 0.03)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectAvatar)))
        return imageView
    }()

    private let addLabel: UILabel = {
        let label = UILabel()
        label.text = "+"
        label.font = lmFontR(44)
        label.textColor = lmColorHex("#192218", alpha: 0.4)
        label.textAlignment = .center
        return label
    }()

    private lazy var nicknameField: LMTextFiledView = makeTextField(placeholder: "Enter your nickname")

    private lazy var countryField: LMTextFiledView = {
        let field = makeTextField(placeholder: "")
        field.textField.text = "\(selectedCountry.flag)  \(selectedCountry.name)"
        field.textField.isUserInteractionEnabled = false
        field.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectCountry)))
        return field
    }()

    private lazy var invitationField: LMTextFiledView = makeTextField(placeholder: "Enter invitation code")

    private lazy var invitationTipLabel: UILabel = {
        let label = UILabel(lmfont: lmFontR(12), textColor: lmColorHex("#192218", alpha: 0.35))
        let text = NSMutableAttributedString(string: "输入邀请码获得  ")
        text.append(NSAttributedString(string: "🎟 10000", attributes: [
            .foregroundColor: lmColorHex("#7DCE02"),
            .font: lmFontR(12)
        ]))
        label.attributedText = text
        label.textAlignment = .center
        return label
    }()

    private lazy var nextButton: UIButton = {
        let button = UIButton(lmfont: lmFontR(20), titleColor: lmColorHex("#A0FA19"), target: self, action: #selector(nextAction))
            .lmtitle("Next")
            .cornerRadius(9)
        button.backgroundColor = lmColorHex("#192218")
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        avatarView.layer.cornerRadius = 18
        addAvatarDashedBorder()
    }
}

private extension SetUpProfileViewController {
    func makeTextField(placeholder: String) -> LMTextFiledView {
        let field = LMTextFiledView()
        field.textField.placeholder = placeholder
        field.textField.font = lmFontR(16)
        field.textField.textColor = lmColorHex("#192218")
        field.textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [
            .foregroundColor: lmColorHex("#192218", alpha: 0.35),
            .font: lmFontR(16)
        ])
        return field
    }

    func setUpView() {
        backgroundImage = UIImage(named: "login_bg")
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "login_back"),
            style: .plain,
            target: self,
            action: #selector(backAction)
        )

        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(avatarView)
        avatarView.addSubview(addLabel)
        view.addSubview(nicknameField)
        view.addSubview(countryField)
        view.addSubview(invitationField)
        view.addSubview(invitationTipLabel)
        view.addSubview(nextButton)

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(kNavigationHeight + 22)
            make.centerX.equalToSuperview()
        }
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        avatarView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(42)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 106, height: 106))
        }
        addLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        nicknameField.snp.makeConstraints { make in
            make.top.equalTo(avatarView.snp.bottom).offset(32)
            make.left.right.equalToSuperview().inset(51)
            make.height.equalTo(42)
        }
        countryField.snp.makeConstraints { make in
            make.top.equalTo(nicknameField.snp.bottom).offset(30)
            make.left.right.height.equalTo(nicknameField)
        }
        invitationField.snp.makeConstraints { make in
            make.top.equalTo(countryField.snp.bottom).offset(30)
            make.left.right.height.equalTo(nicknameField)
        }
        invitationTipLabel.snp.makeConstraints { make in
            make.top.equalTo(invitationField.snp.bottom).offset(66)
            make.centerX.equalToSuperview()
        }
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(invitationTipLabel.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(46)
            make.height.equalTo(56)
        }

        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing)))
    }

    func addAvatarDashedBorder() {
        avatarView.layer.sublayers?.removeAll(where: { $0.name == "AvatarDashedBorderLayer" })
        let border = CAShapeLayer()
        border.name = "AvatarDashedBorderLayer"
        border.fillColor = UIColor.clear.cgColor
        border.strokeColor = lmColorHex("#192218", alpha: 0.28).cgColor
        border.lineWidth = 1
        border.lineDashPattern = [6, 4]
        border.path = UIBezierPath(roundedRect: avatarView.bounds, cornerRadius: 18).cgPath
        avatarView.layer.addSublayer(border)
    }

    @objc func selectCountry() {
        endEditing()
        let countryView = CountrySelectView()
        countryView.didSelectCountry = { [weak self] country in
            self?.selectedCountry = country
            self?.countryField.textField.text = "\(country.flag)  \(country.name)"
        }
        countryView.show()
    }

    @objc func selectAvatar() {
        endEditing()
        let items = [
            LMSheetTabModel(title: "摄像头", titleColor: "#2B313D"),
            LMSheetTabModel(title: "相册", titleColor: "#2B313D")
        ]
        LMSheetTableVC(title: nil, dataSource: items, cancel: "取消") { [weak self] item in
            guard let self, let item else { return }
            item.title == "摄像头" ? self.openCamera() : self.openPhotoLibrary()
        }.show()
    }

    func openCamera() {
        let camera = ZLCustomCamera()
        camera.takeDoneBlock = { [weak self] image, _ in
            guard let image else { return }
            self?.uploadAvatar(image)
        }
        showDetailViewController(camera, sender: nil)
    }

    func openPhotoLibrary() {
        let configuration = ZLPhotoConfiguration.default()
        configuration.maxSelectCount = 1
        configuration.allowSelectVideo = false
        let sheet = ZLPhotoPreviewSheet()
        sheet.selectImageBlock = { [weak self] results, _ in
            guard let image = results.first?.image else { return }
            self?.uploadAvatar(image)
        }
        sheet.showPhotoLibrary(sender: self)
    }

    func uploadAvatar(_ image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        HUD.showLoading("上传中...")
        UpLoadNetWork.UpToken(uploadSource: 0).lmrequest { [weak self] response in
            guard let self,
                  let data = response.data as? [String: Any],
                  let token = data["token"] as? String,
                  let prefix = data["prefix"] as? String,
                  let manager = QNUploadManager() else {
                HUD.hide()
                return
            }
            let key = prefix + "\(Date().timeIntervalSince1970 * 1_000_000).jpeg"
            manager.put(imageData, key: key, token: token, complete: { [weak self] _, key, _ in
                guard let self, let key else {
                    HUD.showFailure("上传失败")
                    return
                }
                DispatchQueue.main.async {
                    self.avatarURL = AppConfig.URL.resource + key
                    self.avatarView.image = image
                    self.addLabel.isHidden = true
                    HUD.hide()
                }
            }, option: nil)
        } failureBlock: { error in
            HUD.showFailure(error.message)
        }
    }

    @objc func nextAction() {
        guard let nickname = nicknameField.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !nickname.isEmpty else {
            HUD.showFailure("请输入昵称")
            return
        }
        guard !avatarURL.isEmpty else {
            HUD.showFailure("请上传头像")
            return
        }
        HUD.showLoading()
        UserNetWork.updateUserInfo(avatar: avatarURL, nickname: nickname).lmrequest { _ in
            HUD.hide()
            let controller = BaseNavigationController(rootViewController: MainTabBarViewController())
            RootRouter().setRootViewController(controller: controller, animatedWithOptions: nil)
        } failureBlock: { error in
            HUD.showFailure(error.message)
        }
    }

    @objc func backAction() {
        navigationController?.popViewController(animated: true)
    }

    @objc func endEditing() {
        view.endEditing(true)
    }
}
