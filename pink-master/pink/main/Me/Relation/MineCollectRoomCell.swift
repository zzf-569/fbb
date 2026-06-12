//
//  MineCollectRoomCell.swift
//  lime
//
//  Created by xf on 2025/9/23.
//

import UIKit
protocol MineCollectRoomCellDelegate: NSObjectProtocol {
    func dg_editBtnClick(model: CollectRoomModel)
}
extension MineCollectRoomCell {
    
    func setEdit(edit: Bool) {
        if edit == true{
            editBtn.isHidden = false
            bgImageView.snp.updateConstraints { make in
                make.left.equalToSuperview().offset(kScaleWidth(64))
            }
        }else {
            editBtn.isHidden = true
            
            bgImageView.snp.updateConstraints { make in
                make.left.equalToSuperview().offset(kScaleWidth(0))
            }
        }
    }
}

class MineCollectRoomCell: LMBaseTableViewCell {
    
    // MARK: 构造属性
    weak var delegate: MineCollectRoomCellDelegate?
    var model: CollectRoomModel = CollectRoomModel() {
        didSet{
            self.titleLabel.text = model.name
    //        self.tagImageView.image = UIImage(named: "home_songTag")
            self.coverImageView.set_Image(url: model.image)
            self.idLabel.text = "ID: \(model.bizId)"
        }
    }
    private lazy var bgImageView: UIImageView = {
        let imageView = UIImageView()
            .backgroundColor(.white)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(lmfont: lmFontM(16), textColor: lmColorHex("#1C1C29"))
        label.numberOfLines = 1
        return label
    }()
    
 
    
    private lazy var coverImageView: UIImageView = {
        let imageView = UIImageView(image: kPlaceholder_image)
            .contentMode(.scaleAspectFill)
            .cornerRadius(kScaleWidth(8))
        return imageView
    }()
    
    private lazy var idLabel: UILabel = {
        let label = UILabel(lmfont: lmFontM(12), textColor: lmColorHex("#1C1C298F"))
        label.numberOfLines = 1
        return label
    }()
    
    lazy var editBtn: UIButton = {
        let imageV = UIButton(image: UIImage(named: "mine_deleCell"), target: self, action: #selector(act_editBtnClick))
        imageV.isHidden = true
        return imageV
    }()
    
    lazy var moreBtn: UIButton = {
        let button = UIButton(image: UIImage(named: "fans_more"))
        return button
    }()
    // MARK: 声明构造器
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUISubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 配置子视图
    private func setUISubViews() {
        contentView.addSubview(bgImageView)
        bgImageView.addSubview(titleLabel)
        bgImageView.addSubview(idLabel)
        bgImageView.addSubview(coverImageView)
        bgImageView.addSubview(moreBtn)

        contentView.addSubview(editBtn)

        editBtn.snp.makeConstraints { make in
            make.right.equalTo(bgImageView.snp.left).offset(-kScaleWidth(22))
            make.centerY.equalTo(bgImageView)
            make.size.equalTo(CGSize(width: kScaleWidth(24), height: kScaleWidth(24)))
        }

        bgImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(kScaleWidth(0))
            make.top.equalToSuperview().offset(kScaleWidth(0))
            make.width.equalTo(kScreenWidth )
            make.height.equalTo(kScaleWidth(80))
        }
        
        
        
        coverImageView.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(kScaleWidth(12.0))
            make.size.equalTo(CGSize(width: kScaleWidth(56), height: kScaleWidth(56)))
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(coverImageView.snp.right).offset(kScaleWidth(12))
            make.top.equalToSuperview().offset(kScaleWidth(12))
            make.height.equalTo(kScaleWidth(24))
        }
        
        idLabel.snp.makeConstraints { make in
            make.left.equalTo(coverImageView.snp.right).offset(kScaleWidth(12))
            make.top.equalTo(titleLabel.snp.bottom).offset(kScaleWidth(4))
            make.height.equalTo(kScaleWidth(20))
        }
        
        moreBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: kScaleWidth(28), height: kScaleWidth(28)))
        }
        
        let line = UIView().backgroundColor(lmColorHex("#1C1C2914"))
        contentView.addSubview(line)
        line.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(kScaleWidth(20))
            make.bottom.equalToSuperview().offset(-1)
            make.height.equalTo(1)
            
        }
        
        
    }
 
    @objc func act_editBtnClick() {
        delegate? .dg_editBtnClick(model: model)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
