import UIKit
class SkStaViewController: LMBaseVC {
    var dataSoure: SkillItem = SkillItem() {
        didSet {
            title = dataSoure.skillName
            switch dataSoure.status {
            case 1:
                nextbtn.image(UIImage(named: "skill_status_successNext"))
                statusImage.image(UIImage(named: "skill_success"))
                titleLab.lmtext("申请通过")
                subtitleLab.lmtext("技能申请已通过，快去接单吧~")
                case 0:
                nextbtn.image(UIImage(named: "skill_next"))
                statusImage.image(UIImage(named: "skill_apply"))
                titleLab.lmtext("审核中")
                subtitleLab.lmtext("加急处理中， 请您耐心等待~")
                case 2:
                statusImage.image(UIImage(named: "skill_faile"))
                nextbtn.image(UIImage(named: "skill_remark"))
                titleLab.lmtext("审核已驳回")
                subtitleLab.lmtext("技能未达到提交信息，被驳回")
            default:
                break
            }
        }
    }
    lazy var statusImage: UIImageView = {
        let imageV = UIImageView()
        return imageV
    }()
    lazy var titleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontM(18), textColor: .textDefaulColor)
        return lb
    }()
    lazy var subtitleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontR(12), textColor: .textTerColor)
        return lb
    }()
    lazy var nextbtn: UIButton = {
        let btn = UIButton(image: nil, target: self, action: #selector(a_nextClick))
        return btn
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        set_Subviews()
    }
    private func set_Subviews() {
        backgroundImage = nil
        view.addSubview(statusImage)
        view.addSubview(titleLab)
        view.addSubview(subtitleLab)
        view.addSubview(nextbtn)
        statusImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(kScaleWidth(40) + kNavigationHeight)
            make.size.equalTo(CGSize(width: kScaleWidth(140), height: kScaleWidth(140)))
        }
        titleLab.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(statusImage.snp.bottom).offset(kScaleWidth(20))
        }
        subtitleLab.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(statusImage.snp.bottom).offset(kScaleWidth(50))
        }
        nextbtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(statusImage.snp.bottom).offset(kScaleWidth(110))
            make.size.equalTo(CGSize(width: kScaleWidth(230), height: kScaleWidth(56)))
        }
    }
    func setDataSoure() {
    }
    @objc func a_backItemDidiClick() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func a_nextClick() {
        if dataSoure.status == 0 {
            self.navigationController?.popToViewControllerAtIndex(index: 2)
        } else if dataSoure.status == 1 {
            self.navigationController?.popToViewControllerAtIndex(index: 1)
        } else {
            let view = SkApViewController()
            view.dataSoure = dataSoure
            self.navigationController?.pushViewController(view, animated: true)
        }
    }
}
