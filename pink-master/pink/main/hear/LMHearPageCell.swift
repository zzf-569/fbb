import UIKit

class LMHearPageCell: UICollectionViewCell {
    func set_(model: RoomItem, index: Int) {
        coverImage.set_Image(url: model.cover, placeholder: UIImage(named: "ICON"))
        nameLabel.text = model.roomName
        tagImage.set_Image(url: model.tagUrl)
        tagImage.isHidden = model.tagUrl.isEmpty
        hotButton.setTitle(model.hotValue.toString().StringToHotVaule(), for: .normal)
        seatView.model = model.onlineAvatarList

        countryImage.isHidden = model.cornerMark.isEmpty
        if model.cornerMark.isEmpty == false {
            countryImage.set_Image(url: model.cornerMark)
        }
    }

    private lazy var coverImage: UIImageView = {
        let imageView = UIImageView(image: kPlaceholder_image)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.cornerRadius(kScaleWidth(12))
        return imageView
    }()

    private lazy var countryImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel(lmfont: lmFontM(16), textColor: .textDefaulColor)
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    private lazy var tagImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var seatView: LMHomeSeatView = {
        LMHomeSeatView()
    }()

    private lazy var hotButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "hot")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = lmColorHex("#2B313D66")
        button.setTitleColor(lmColorHex("#2B313D66"), for: .normal)
        button.titleLabel?.font = lmFontR(12)
        button.set_ImageTitleLayout(.imgLeft, spacing: 3)
        button.isUserInteractionEnabled = false
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setViewSnp()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setViewSnp() {
        contentView.backgroundColor = .white
        contentView.cornerRadius(kScaleWidth(12))
        contentView.clipsToBounds = true

        contentView.addSubview(coverImage)
        contentView.addSubview(countryImage)
        contentView.addSubview(nameLabel)
        contentView.addSubview(tagImage)
        contentView.addSubview(seatView)
        contentView.addSubview(hotButton)

        coverImage.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(10))
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: kScaleWidth(92), height: kScaleWidth(92)))
        }

        countryImage.snp.makeConstraints { make in
            make.left.equalTo(coverImage.snp.right).offset(kScaleWidth(12))
            make.top.equalToSuperview().offset(kScaleWidth(14))
            make.size.equalTo(CGSize(width: kScaleWidth(24), height: kScaleWidth(18)))
        }

        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(countryImage.snp.right).offset(kScaleWidth(4))
            make.centerY.equalTo(countryImage)
            make.right.equalToSuperview().offset(-kScaleWidth(12))
        }

        tagImage.snp.makeConstraints { make in
            make.left.equalTo(coverImage.snp.right).offset(kScaleWidth(12))
            make.top.equalTo(countryImage.snp.bottom).offset(kScaleWidth(8))
            make.size.equalTo(CGSize(width: kScaleWidth(48), height: kScaleWidth(20)))
        }

        seatView.snp.makeConstraints { make in
            make.left.equalTo(coverImage.snp.right).offset(kScaleWidth(12))
            make.bottom.equalToSuperview().offset(-kScaleWidth(12))
            make.width.equalTo(kScaleWidth(128))
            make.height.equalTo(kScaleWidth(24))
        }

        hotButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-kScaleWidth(12))
            make.centerY.equalTo(seatView)
            make.height.equalTo(kScaleWidth(24))
        }
    }
}
