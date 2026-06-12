import UIKit
protocol GiftWallPageSecCellDelegate: NSObjectProtocol {
    func dg_cellClickRward(model: IhListModel)
}
class GiftWallPageSecCell: BaseCollectionViewCell {
    var degegate: GiftWallPageSecCellDelegate?
    var userid: String = ""
    var dataSoure: IhListModel = IhListModel() {
        didSet {
            centerView.removeAllSubViews()
            bottomView.removeAllSubViews()
            namelb.lmtext(dataSoure.ihName)
            centerView.snp.updateConstraints { make in
                make.height.equalTo(getCellHeight(model: dataSoure))
            }
            if dataSoure.unlocked == true {
                reWardbtn.image(UIImage(named: "gw_reward_re"))
            } else {
                if dataSoure.canReceive == false {
                    reWardbtn.image(UIImage(named: "gw_rewardun"))
                } else {
                    reWardbtn.image(UIImage(named: "gw_reward"))
                }
            }
            for (index, item) in dataSoure.detail.ihGiftList.enumerated() {
                let view = GiftWallPageSecCenView()
                view.dataSoure = item
                centerView.addSubview(view)
                view.snp.makeConstraints { make in
                    make.left.equalToSuperview().offset(CGFloat(index%4) * kScaleWidth(85))
                    make.top.equalToSuperview().offset(CGFloat(index/4) * kScaleWidth(112))
                    make.size.equalTo(CGSize(width: kScaleWidth(79), height: kScaleWidth(104)))
                }
                view.addGestureTap { [weak self] _ in
                    let view = GiftWallDetailPopView()
                    view.setDataSoure(item)
                    view.show()
                }
            }
            if userid == UserShared.user?.userId {
                for (index, item) in dataSoure.detail.rewards.enumerated() {
                    let btn = UIButton(lmfont: lmFontR(8), titleColor: lmColorHex("#FFFFFF7A"))
                        .frame(CGRect(x: 0, y: 0, width: kScaleWidth(32), height: kScaleWidth(36)))
                    btn.kf.setImage(with: URL(string: item.dressUpIcon), for: .normal)
                    btn.setTitle(item.dressUpName, for: .normal)
                    bottomView.addSubview(btn)
                    btn.snp.makeConstraints { make in
                        make.left.equalToSuperview().offset(CGFloat(index%4) * kScaleWidth(35))
                        make.top.equalToSuperview().offset(kScaleWidth(12))
                        make.size.equalTo(CGSize(width: kScaleWidth(32), height: kScaleWidth(32)))
                    }
                }
            } else {
                tipslb.isHidden = true
                reWardbtn.isHidden = true
                bottomView.isHidden = true
            }
        }
    }
    lazy var lineViewL: UIImageView = {
        let imageV = UIImageView(image: UIImage(named: "gw_line_l"))
        return imageV
    }()
    lazy var lineViewR: UIImageView = {
        let imageV = UIImageView(image: UIImage(named: "gw_line_r"))
        return imageV
    }()
    lazy var namelb: UILabel = {
        let lb = UILabel(lmfont: lmFontM(12), textColor: .white)
            .textAlignment(.center)
        return lb
    }()
    lazy var numlb: UILabel = {
        let lb = UILabel(lmfont: lmFontM(8), textColor: .white)
            .backgroundColor(lmColorHex("#FFFFFF3D"))
            .frame(CGRect(x: 0, y: 0, width: 30, height: 16))
        lb.set_Border(radius: 8, conrners: [.topLeft, .bottomLeft])
        return lb
    }()
    lazy var centerView: UIView = {
        let view = UIView()
        return view
    }()
    lazy var tipslb: UILabel = {
        let lb = UILabel(lmfont: lmFontM(12), textColor: .white)
            .lmtext("集齐可获得")
        return lb
    }()
    lazy var bottomView: UIView = {
        let view = UIView()
        return view
    }()
    lazy var reWardbtn: UIButton = {
        let btn = UIButton(image: UIImage(named: "gw_reward"), target: self, action: #selector(rewardClick))
        return btn
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setViewSnp() {
        contentView.set_Border(radius: 8, borderWidth: 1, borderColor: lmColorHex("#FFFFFF29"))
        contentView.addSubview(lineViewL)
        contentView.addSubview(namelb)
        contentView.addSubview(centerView)
        contentView.addSubview(tipslb)
        contentView.addSubview(bottomView)
        contentView.addSubview(reWardbtn)
        lineViewL.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(kScaleWidth(55))
            make.top.equalToSuperview().offset(kScaleWidth(21))
            make.height.equalTo(kScaleWidth(6))
        }
        namelb.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(kScaleWidth(14))
            make.height.equalTo(20)
        }
        centerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(kScaleWidth(8))
            make.top.equalToSuperview().offset(kScaleWidth(48))
            make.height.equalTo(0)
        }
        bottomView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(kScaleWidth(76)))
            make.bottom.equalToSuperview().offset(0)
            make.height.equalTo(kScaleWidth(52))
            make.right.equalToSuperview().offset(-kScaleWidth(60))
        }
        reWardbtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-kScaleWidth(16))
            make.centerY.equalTo(bottomView.snp.centerY)
            make.size.equalTo(CGSize(width: kScaleWidth(52), height: kScaleWidth(20)))
        }
        tipslb.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(8))
            make.centerY.equalTo(bottomView.snp.centerY)
        }
    }
    func getCellHeight(model: IhListModel) -> Double {
        var height = 0.0
        height = CGFloat(((model.detail.ihGiftList.count - 1) / 4) + 1) * kScaleWidth(104)
        return height
    }
    @objc func rewardClick() {
        self.degegate?.dg_cellClickRward(model: dataSoure)
    }
}
