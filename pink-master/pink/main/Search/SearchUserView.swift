import UIKit
class SearchUserView: UIView {
    var dataSoure: UsInfoItem = UsInfoItem() {
        didSet {
            headImage.set_Image(url: dataSoure.avatar)
            namelb.lmtext(dataSoure.nickname)
            idlb.lmtext("ID: \(dataSoure.showUserId)")
            levingImage.isHidden = (dataSoure.currentRoom == nil)
        }
    }
    lazy var headImage: UIImageView = {
        let imageV = UIImageView()
            .cornerRadius(kScaleWidth(28))
        return imageV
    }()
    lazy var levingImage: UIImageView = {
        let imageV = UIImageView(image: UIImage(named: "search_living"))
            .isHidden(true)
        return imageV
    }()
    lazy var namelb: UILabel = {
        let lb = UILabel(lmfont: lmFontM(14), textColor: .textDefaulColor)
            .textAlignment(.center)
        return lb
    }()
    lazy var idlb: UILabel = {
        let lb = UILabel(lmfont: lmFontM(12), textColor: lmColorHex("#2B313DAD"))
            .textAlignment(.center)
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
        addSubview(headImage)
        addSubview(levingImage)
        addSubview(namelb)
        addSubview(idlb)
        headImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(kScaleWidth(12))
            make.size.equalTo(CGSize(width: kScaleWidth(56), height: kScaleWidth(56)))
        }
        levingImage.snp.makeConstraints { make in
            make.edges.equalTo(headImage)
        }
        namelb.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(headImage.snp.bottom).offset(12)
            make.height.equalTo(22)
        }
        idlb.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(headImage.snp.bottom).offset(34)
            make.height.equalTo(20)
        }
    }
}
