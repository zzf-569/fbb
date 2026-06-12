import UIKit
protocol findOrderCellDelegate: NSObjectProtocol {
    func findOrderCellNext(orderNo: String)
}
class findOrderCell: LMBaseTableViewCell {
    weak var delegate: findOrderCellDelegate?
    var dataSoure: findOrderItem = findOrderItem() {
        didSet{
            iconImage.set_Image(url: dataSoure.itemIcon)
            namelb.text = "\(dataSoure.itemName) x \(dataSoure.number.toString())"
            gameInfo.text = "需求: \(dataSoure.itemName) \(dataSoure.level)"
            remakeInfo.text = "备注: \(dataSoure.remark)"
            pricelb.text = "\(dataSoure.totalAmount)/钻石"
        }
    }
    lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor(.white)
        view.cornerRadius(16)
        return view
    }()
    lazy var iconImage: UIImageView = {
        let imageV = UIImageView()
        return imageV
    }()
    lazy var namelb: UILabel = {
        let lb = UILabel(lmfont: lmFontM(16), textColor: .textDefaulColor)
        return lb
    }()
    lazy var gameInfo: UILabel = {
        let lb = UILabel(lmfont: lmFontR(12), textColor: .textSecondColor)
        return lb
    }()
    lazy var remakeInfo: UILabel = {
        let lb = UILabel(lmfont: lmFontR(12), textColor: .textSecondColor)
        lb.numberOfLines(0)
        return lb
    }()
    lazy var pricelb: UILabel = {
        let lb = UILabel(lmfont: lmFontR(24), textColor: lmColorHex("#FF4F7D"))
        return lb
    }()
    lazy var nextbtn: UIButton = {
        let btn = UIButton(lmfont: lmFontM(12), titleColor: .textDefaulColor, backgroundColor: lmColorHex("#FFEC3B"), text: "接单")
        btn.addTarget(self, action: #selector(nextClick), for: .touchUpInside)
        btn.cornerRadius(16)
        return btn
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        set_Subviews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func set_Subviews() {
        contentView.addSubview(backView)
        backView.addSubview(iconImage)
        backView.addSubview(namelb)
        backView.addSubview(gameInfo)
        backView.addSubview(remakeInfo)
        backView.addSubview(pricelb)
        backView.addSubview(nextbtn)
        backView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalToSuperview().offset(0)
            make.bottom.equalToSuperview().offset(-20)
        }
        iconImage.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(16)
            make.size.equalTo(CGSize(width: 56, height: 56))
        }
        namelb.snp.makeConstraints { make in
            make.top.equalTo(iconImage.snp.top)
            make.left.equalTo(iconImage.snp.right).offset(8)
            make.height.equalTo(24)
        }
        gameInfo.snp.makeConstraints { make in
            make.top.equalTo(namelb.snp.bottom).offset(0)
            make.left.equalTo(iconImage.snp.right).offset(8)
            make.height.equalTo(20)
        }
        remakeInfo.snp.makeConstraints { make in
            make.top.equalTo(gameInfo.snp.bottom).offset(0)
            make.left.equalTo(iconImage.snp.right).offset(8)
            make.right.equalToSuperview().offset(-20)
        }
        pricelb.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-24)
            make.left.equalTo(iconImage.snp.right).offset(8)
        }
        nextbtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-24)
            make.size.equalTo(CGSize(width: 64, height: 32))
        }
    }
    @objc func nextClick() {
        self.delegate?.findOrderCellNext(orderNo: dataSoure.orderNo)
    }
}
