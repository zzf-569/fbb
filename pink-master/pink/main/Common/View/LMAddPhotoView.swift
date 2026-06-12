import UIKit
class LMAddPhotoView: UIView {
    lazy var imv: UIImageView = {
        let iamgeV = UIImageView()
        iamgeV.image(UIImage(named: image))
        iamgeV.contentMode = .scaleAspectFill
        iamgeV.cornerRadius(12)
        return iamgeV
    }()
    lazy var close: UIButton = {
        let buttton = UIButton(image: UIImage(named: "cm_textfild_close"), target: self, action: #selector(closeAction))
        buttton.isHidden = true
        return buttton
    }()
    private var image: String
    private let callbackblock: () -> Void
    init(image: String = "photo_choose", complete block: @escaping () -> Void) {
        self.image = image
        self.callbackblock = block
        super.init(frame: .zero)
        setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setViewSnp() {
        addSubview(imv)
        addSubview(close)
        imv.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        close.snp.makeConstraints { make in
            make.top.right.equalToSuperview()
            make.size.equalTo(CGSize(width: kScaleWidth(16), height: kScaleWidth(16)))
        }
    }
    func setDataSoure(imageUrl: String) {
        imv.set_Image(url: imageUrl)
        close.isHidden = false
    }
    func set_ImageData(image: UIImage) {
        imv.image = image
        close.isHidden = false
    }
    @objc func closeAction() {
        imv.image(UIImage(named: image))
        close.isHidden = true
        callbackblock()
    }
}
