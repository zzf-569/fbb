//
//  LMHomeSeatView.swift
//  pink
//
//  Created by xfffff on 2026/7/22.
//  Copyright © 2026 pink. All rights reserved.
//

import UIKit

class LMHomeSeatView: UIView {

    var model: [String] = [] {
        didSet{
            moreLabel.text = model.count > 4 ? "+\(model.count - 4)" : nil
            moreLabel.isHidden = model.count <= 4
            collectionView.reloadData()
        }
    }

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.width, height: self.height), collectionViewLayout: layout)
        collectionView.register(LMHomeUserCell.self, forCellWithReuseIdentifier: "LMHomeUserCell")
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()

    private lazy var moreLabel: UILabel = {
        let label = UILabel(lmfont: lmFontM(11), textColor: .white)
        label.textAlignment = .center
        label.backgroundColor = UIColor.black.withAlphaComponent(0.22)
        label.layer.borderColor = UIColor.white.cgColor
        label.set_Border(radius: kScaleWidth(12), borderWidth: 1)
        label.isHidden = true
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configUI() {
        addSubview(collectionView)
        addSubview(moreLabel)
        collectionView.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(-kScaleWidth(32))
        }
        moreLabel.snp.makeConstraints { make in
            make.top.bottom.right.equalToSuperview()
            make.width.equalTo(kScaleWidth(30))
        }
    }

}


extension LMHomeSeatView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        min(model.count, 4)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: kScaleWidth(24), height: kScaleWidth(24))
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        kScaleWidth(-6)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LMHomeUserCell", for: indexPath) as! LMHomeUserCell
        cell.coverImage.set_Image(url: model[indexPath.item], placeholder: kPlaceholder_avatar)
        return cell
    }
}


class LMHomeUserCell: UICollectionViewCell {

    lazy var coverImage: UIImageView = {
        let imageV = UIImageView()
        imageV.layer.borderColor = UIColor.white.cgColor
        imageV.set_Border(radius: kScaleWidth(10), borderWidth: 1)
        return imageV
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setViewSnp() {
        contentView.addSubview(coverImage)
        coverImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
