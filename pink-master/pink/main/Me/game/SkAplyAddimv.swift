import UIKit
class SkAplyAddimv: UIView {
    lazy var imv: UIImageView = {
        let iamgeV = UIImageView()
        iamgeV.image(UIImage(named: image))
        iamgeV.contentMode = .scaleAspectFill
        iamgeV.cornerRadius(12)
        return iamgeV
    }()
    lazy var close: UIButton = {
        let buttton = UIButton(image: UIImage(named: "apply_close"), target: self, action: #selector(a_close))
        buttton.isHidden = true
        return buttton
    }()
    private var image: String
    private let callbackblock: () -> Void
    init(image: String = "skill_imageadd", complete block: @escaping () -> Void) {
        self.image = image
        self.callbackblock = block
        super.init(frame: .zero)
        set_Subviews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func set_Subviews() {
        addSubview(imv)
        addSubview(close)
        imv.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        close.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(-kScaleWidth(6))
            make.size.equalTo(CGSize(width: kScaleWidth(16), height: kScaleWidth(16)))
        }
    }
    func setDataSoure(imageUrl: String) {
        imv.set_Image(url: imageUrl)
        close.isHidden = false
    }
    @objc func a_close() {
        imv.image(UIImage(named: image))
        close.isHidden = true
        callbackblock()
    }
}
