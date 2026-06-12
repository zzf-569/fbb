import UIKit
class LMHearHeaderView: UICollectionReusableView {
    var Callbackblock: ((Int) -> Void)?
    lazy var searView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 20, y: kStatusBarHeight + 4, width: kScreenWidth - 40, height: 40)
        view.backgroundColor = .white
        view.cornerRadius(8)
        let icon = UIImageView(image: UIImage(named: "hear_sear"))
        icon.frame = CGRect(x: 12, y: 10, width: 20, height: 20)
        view.addSubview(icon)
        let lb = UILabel()
        lb.text = "搜索..."
        lb.textColor = lmColorHex("#2B313D3D")
        lb.font = lmFontR(16)
        lb.frame = CGRect(x: 40, y: 8, width: 200, height: 24)
        view.addSubview(lb)
        view.addGestureTap { [weak self] _ in
            UIViewController.current?.navigationController?.pushViewController(SearchPageViewController(), animated: true)
        }
        return view
    }()
    lazy var rankbtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "hear_rank"), for: .normal)
        btn.addTarget(self, action: #selector(rankClick), for: .touchUpInside)
        btn.frame = CGRect(x: (kScreenWidth - kScaleWidth(60)), y: kStatusBarHeight + 4, width: kScaleWidth(40), height: kScaleWidth(40))
        btn.isHidden = true
        return btn
    }()
    lazy var itemOneView: UIButton = {
        let btn = UIButton(frame: CGRect(x: kScaleWidth(20), y: kScaleWidth(72) + kNavigationBarHeight, width: kScaleWidth(172), height: kScaleWidth(56)))
        btn.setBackgroundImage(UIImage(named: "he_item_1"), for: .normal)
        btn.tag = 0
        btn.addTarget(self, action: #selector(btnClick(sender:)), for: .touchUpInside)
        return btn
    }()
    lazy var itemTwoView: UIButton = {
        let btn = UIButton(frame: CGRect(x: kScaleWidth(198), y: kScaleWidth(72) + kNavigationBarHeight, width: kScaleWidth(172), height: kScaleWidth(56)))
        btn.setImage(UIImage(named: "he_item_2"), for: .normal)
        btn.tag = 1
        btn.addTarget(self, action: #selector(btnClick(sender:)), for: .touchUpInside)
        return btn
    }()
    lazy var itemThreeView: UIButton = {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: kScaleWidth(20), y: kScaleWidth(140) + kNavigationBarHeight, width: kScaleWidth(80), height: kScaleWidth(88))
        btn.setImage(UIImage(named: "he_item_3"), for: .normal)
        btn.tag = 2
        btn.addTarget(self, action: #selector(btnClick(sender:)), for: .touchUpInside)
        return btn
    }()
    lazy var itemFourView: UIButton = {
        let btn = UIButton(frame: CGRect(x: kScaleWidth(110), y: kScaleWidth(140) + kNavigationBarHeight, width: kScaleWidth(88), height: kScaleWidth(88)))
        btn.setImage(UIImage(named: "he_item_4"), for: .normal)
        btn.tag = 3
        btn.addTarget(self, action: #selector(btnClick(sender:)), for: .touchUpInside)
        return btn
    }()
    lazy var itemFiveView: UIButton = {
        let btn = UIButton(frame: CGRect(x: kScaleWidth(200), y: kScaleWidth(140) + kNavigationBarHeight, width: kScaleWidth(88), height: kScaleWidth(88)))
        btn.setImage(UIImage(named: "he_item_5"), for: .normal)
        btn.tag = 4
        btn.addTarget(self, action: #selector(btnClick(sender:)), for: .touchUpInside)
        return btn
    }()
    lazy var itemSixView: UIButton = {
        let btn = UIButton(frame: CGRect(x: kScaleWidth(290), y: kScaleWidth(140) + kNavigationBarHeight, width: kScaleWidth(88), height: kScaleWidth(88)))
        btn.tag = 5
        btn.addTarget(self, action: #selector(btnClick(sender:)), for: .touchUpInside)
        btn.setImage(UIImage(named: "he_item_6"), for: .normal)
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
        addSubview(searView)
        addSubview(rankbtn)
        addSubview(itemOneView)
        addSubview(itemTwoView)
        addSubview(itemThreeView)
        addSubview(itemFourView)
        addSubview(itemFiveView)
        addSubview(itemSixView)
    }
    @objc func btnClick(sender: UIButton) {
        Callbackblock?(sender.tag)
    }
    @objc func rankClick() {
        UIViewController.current?.navigationController?.pushViewController(RankVC(), animated: true)
    }
}
