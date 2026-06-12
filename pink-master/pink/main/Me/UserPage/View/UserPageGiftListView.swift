import UIKit
class UserPageGiftListView: UIView {
    var dataSoure: UsInfoItem = UsInfoItem()
    lazy var giftWallView: UIButton = {
        let btn = UIButton(lmfont: lmFontM(16), titleColor: .textDefaulColor)
            .lmtitle("礼物图鉴")
            .image(UIImage(named: "cm_more"))
            .backgroundColor(lmColorHex("#F8F8FAFF"))
            .cornerRadius(12)
            .frame(CGRect(x: 0, y: 0, width: kScaleWidth(350), height: kScaleWidth(56)))
        btn.set_ImageTitleLayout(.imgRight, spacing: kScaleWidth(255))
        btn.addTarget(self, action: #selector(turnToGift), for: .touchUpInside)
        return btn
    }()
    lazy var giftViewT: UIButton = {
        let btn = UIButton(lmfont: lmFontM(16), titleColor: .textDefaulColor)
            .lmtitle("典藏图鉴")
            .image(UIImage(named: "cm_more"))
            .backgroundColor(lmColorHex("#F8F8FAFF"))
            .cornerRadius(12)
            .frame(CGRect(x: 0, y: 0, width: kScaleWidth(350), height: kScaleWidth(56)))
        btn.set_ImageTitleLayout(.imgRight, spacing: kScaleWidth(255))
        btn.addTarget(self, action: #selector(turnToGift), for: .touchUpInside)
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
        addSubview(giftWallView)
        addSubview(giftViewT)
        giftWallView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(kScaleWidth(20))
            make.top.equalToSuperview().offset(kScaleWidth(12))
            make.height.equalTo(kScaleWidth(56))
        }
        giftViewT.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(kScaleWidth(20))
            make.top.equalTo(giftWallView.snp.bottom).offset(kScaleWidth(12))
            make.height.equalTo(kScaleWidth(56))
        }
    }
    @objc func turnToGift() {
        UIViewController.current?.navigationController?.pushViewController(GiftWallViewController(model: dataSoure), animated: true)
    }
}
extension UserPageGiftListView: JXPagingViewListViewDelegate {
    func listScrollView() -> UIScrollView {
        UIScrollView()
    }
    func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> Void) {
        listViewDidScrollCallback = callback
    }
    func listView() -> UIView {
        return self
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        listViewDidScrollCallback?(scrollView)
    }
}
