import UIKit
class familyInfoView: UIView {
    var dataSoure: GuildItem = GuildItem()
    lazy var namelb: UILabel = {
        let lb = UILabel(lmfont: lmFontASHTB(24), textColor: .textDefaulColor)
        return lb
    }()
    lazy var hotlb: UILabel = {
        let lb = UILabel(lmfont: lmFontM(12), textColor: lmColorHex("#2B313D8F"))
        return lb
    }()
    lazy var notilb: UILabel = {
        let lb = UILabel(lmfont: lmFontM(14), textColor: .textDefaulColor)
            .numberOfLines(0)
        return lb
    }()
    init(model: GuildItem) {
        self.dataSoure = model
        super.init(frame: .zero)
        setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setViewSnp() {
        addSubview(namelb)
        addSubview(hotlb)
        addSubview(notilb)
        namelb.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(20))
            make.top.equalToSuperview().offset(kScaleWidth(32))
        }
        hotlb.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(20))
            make.top.equalToSuperview().offset(kScaleWidth(64))
        }
        notilb.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(kScaleWidth(20))
            make.top.equalToSuperview().offset(kScaleWidth(116))
        }
        namelb.text = dataSoure.title
        hotlb.text = "热度值: \(dataSoure.hotValue.toString())"
        notilb.text = dataSoure.notification
    }
}
extension familyInfoView: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return self
    }
}
