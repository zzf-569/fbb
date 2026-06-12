import UIKit
class LMHearPageCell: UICollectionViewCell {
    func set_(model: RoomItem, index: Int) {
        cover.set_Image(url: model.cover, placeholder: UIImage(named: "ICON"))
        name.text = model.roomName
        hotbtn.setTitle(model.hotValue.toString().StringToHotVaule(), for: .normal)
        typelb.text = model.typeValue
        if index%4 == 0 {
            bgView.backgroundColor = lmColorHex("#328BF914")
        } else if index%4 == 1 {
            bgView.backgroundColor = lmColorHex("#FF9F4014")
        } else if index%4 == 2 {
            bgView.backgroundColor = lmColorHex("#F5455C14")
        } else if index%4 == 3 {
            bgView.backgroundColor = lmColorHex("#26D47714")
        }
        layoutIfNeeded()
        if self.bgView.height > self.height {
            bgView.snp.remakeConstraints { make in
                make.top.left.right.equalToSuperview()
                make.bottom.equalToSuperview()
            }
            self.name.snp.remakeConstraints { make in
                make.left.equalToSuperview().inset(kScaleWidth(16))
                make.top.equalTo(cover.snp.bottom).offset(kScaleWidth(12))
                make.width.equalTo(kScaleWidth(28))
                make.bottom.equalToSuperview().offset(-72)
            }
        }
    }
    lazy var bgView: UIView = {
        let view = UIView()
        view.cornerRadius(12)
        return view
    }()
    lazy var cover: UIImageView = {
        let imageV = UIImageView()
        imageV.cornerRadius(8)
        return imageV
    }()
    lazy var name: UILabel = {
        let lb = UILabel()
        lb.numberOfLines = 0
        lb.textAlignment = .center
        lb.font = lmFontM(16)
        lb.textColor = lmColorHex("#2B313D")
        return lb
    }()
    lazy var hotbtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "hot"), for: .normal)
        btn.set_ImageTitleLayout(.imgLeft, spacing: 2)
        btn.setTitleColor(lmColorHex("#2B313DAD"), for: .normal)
        btn.titleLabel?.font = lmFontR(10)
        return btn
    }()
    lazy var typelb: UILabel = {
        let lb = UILabel()
        lb.font = lmFontR(10)
        lb.textColor = lmColorHex("#FF4F7DFF")
        lb.backgroundColor = lmColorHex("#328BF914")
        lb.cornerRadius(12)
        lb.textAlignment = .center
        return lb
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setViewSnp() {
        contentView.addSubview(bgView)
        bgView.addSubview(cover)
        bgView.addSubview(name)
        bgView.addSubview(hotbtn)
        bgView.addSubview(typelb)
        bgView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        cover.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(kScaleWidth(12))
            make.size.equalTo(CGSize(width: kScaleWidth(36), height: kScaleWidth(36)))
        }
        name.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(kScaleWidth(16))
            make.top.equalTo(cover.snp.bottom).offset(kScaleWidth(12))
            make.width.equalTo(kScaleWidth(28))
        }
        hotbtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(name.snp.bottom).offset(kScaleWidth(12))
            make.height.equalTo(kScaleWidth(12))
        }
        typelb.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(hotbtn.snp.bottom).offset(kScaleWidth(12))
            make.size.equalTo(CGSize(width: kScaleWidth(36), height: kScaleWidth(20)))
            make.bottom.lessThanOrEqualToSuperview().offset(-kScaleWidth(12))
        }
    }
}
