//
//  LMHomeHotCell.swift
//  pink
//
//  Created by xfffff on 2026/7/22.
//  Copyright © 2026 pink. All rights reserved.
//

import UIKit

class LMHomeHotCell: UICollectionViewCell {
    func set_(model: RoomItem) {
        coverImage.set_Image(url: model.cover, placeholder: kPlaceholder_image)
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

    lazy var coverImage: UIImageView = {
        let imageV = UIImageView()
        imageV.contentMode = .scaleAspectFill
        imageV.clipsToBounds = true
        return imageV
    }()

    private lazy var tagImage: UIImageView = {
        let imageV = UIImageView()
        imageV.contentMode = .scaleAspectFit
        return imageV
    }()

    private lazy var hotButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "hot")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = lmFontM(12)
        button.set_ImageTitleLayout(.imgLeft, spacing: 3)
        button.isUserInteractionEnabled = false
        return button
    }()

    lazy var countryImage: UIImageView = {
        let imageV = UIImageView()
        imageV.contentMode = .scaleAspectFit
        return imageV
    }()

    lazy var nameLabel: UILabel = {
        let label = UILabel(lmfont: lmFontR(14), textColor: .textDefaulColor)
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    lazy var seatView: LMHomeSeatView = {
        let view = LMHomeSeatView()
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.shadowColor = UIColor.black.withAlphaComponent(0.14).cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = kScaleWidth(10)
        layer.shadowOffset = CGSize(width: 0, height: kScaleWidth(6))
        setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setViewSnp() {
        let stackView = UIStackView(arrangedSubviews: [countryImage, nameLabel])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = kScaleWidth(4)

        contentView.backgroundColor = .white
        contentView.cornerRadius(kScaleWidth(12))
        contentView.clipsToBounds = true
        contentView.addSubview(coverImage)
        contentView.addSubview(tagImage)
        contentView.addSubview(hotButton)
        contentView.addSubview(seatView)
        contentView.addSubview(stackView)

        coverImage.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-kScaleWidth(40))
        }

        tagImage.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(kScaleWidth(10))
            make.size.equalTo(CGSize(width: kScaleWidth(68), height: kScaleWidth(24)))
        }

        hotButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(kScaleWidth(10))
            make.right.equalToSuperview().offset(-kScaleWidth(10))
            make.height.equalTo(kScaleWidth(24))
        }

        seatView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(8))
            make.right.equalToSuperview().offset(-kScaleWidth(8))
            make.bottom.equalTo(coverImage.snp.bottom).offset(-kScaleWidth(8))
            make.height.equalTo(kScaleWidth(24))
        }

        stackView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(12))
            make.right.lessThanOrEqualToSuperview().offset(-kScaleWidth(12))
            make.bottom.equalToSuperview()
            make.height.equalTo(kScaleWidth(40))
        }

        countryImage.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: kScaleWidth(24), height: kScaleWidth(18)))
        }

    }
}
