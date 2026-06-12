import UIKit
extension LMRMSeatPkProgressView {
    func set_Title(title: String) {
        self.steplb.text = title
    }
    func set_Progress(leftProgress: Int, rightProgress: Int) {
        var leftmins = 0.0
        let tolat: Double = Double(leftProgress + rightProgress)
        if tolat != 0 {
            leftmins = Double(leftProgress) / tolat
        }
        if leftProgress == 0, rightProgress == 0 {
            leftmins = 0.5
        }
        if leftProgress == 0, rightProgress != 0 {
            leftmins = 0.08
        }
        if leftProgress != 0, rightProgress == 0 {
            leftmins = 0.90
        }
        self.leftProgresslb.lmtext(leftProgress.toString())
        self.rightProgresslb.lmtext(rightProgress.toString())
        UIView.animate(withDuration: 0.5) {[weak self] in
            guard let self = self else {return}
            self.leftProgressView.snp.remakeConstraints { make in
                make.left.equalToSuperview().offset(0)
                make.top.equalToSuperview().offset(8)
                make.width.equalTo(self.snp.width).multipliedBy(leftmins)
                make.height.equalTo(24)
            }
        } completion: { _ in
            self.layoutIfNeeded()
        }
    }
}
class LMRMSeatPkProgressView: UIView {
    lazy var steplb: UILabel = {
        let lb = UILabel(lmfont: lmFontM(12), textColor: .white).textAlignment(.center)
        return lb
    }()
    lazy var centerImage: UIImageView = {
        let imageV = UIImageView(image: UIImage(named: "rm_pkProCenter"))
        return imageV
    }()
    lazy var pkcenterImage: UIImageView = {
        let imageV = UIImageView(image: UIImage(named: "rm_pkProPKImage"))
        return imageV
    }()
    lazy var leftProgressView: UIImageView = {
        let imageV = UIImageView(image: UIImage(named: "rm_pk_leftprogress"))
        return imageV
    }()
    lazy var rightProgressView: UIImageView = {
        let imageV = UIImageView(image: UIImage(named: "rm_pk_rightprogress"))
        return imageV
    }()
    lazy var leftProgresslb: UILabel = {
        let lb = UILabel(lmfont: lmFontR(11), textColor: .white).textAlignment(.left)
            .lmtext("0")
        return lb
    }()
    lazy var rightProgresslb: UILabel = {
        let lb = UILabel(lmfont: lmFontR(11), textColor: .white).textAlignment(.right)
            .lmtext("0")
        return lb
    }()
    var isRoomPK: Bool = false
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViewSnp()
    }
    init(isRoomPK: Bool = false) {
        super.init(frame: .zero)
        self.isRoomPK = isRoomPK
        setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setViewSnp() {
        addSubview(centerImage)
        addSubview(steplb)
        addSubview(leftProgressView)
        addSubview(leftProgresslb)
        addSubview(pkcenterImage)
        addSubview(rightProgressView)
        addSubview(rightProgresslb)
        bringSubviewToFront(leftProgresslb)
        bringSubviewToFront(rightProgresslb)
        bringSubviewToFront(pkcenterImage)
        centerImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(leftProgressView.snp.bottom)
            make.size.equalTo(CGSize(width: 120, height: 24))
        }
        steplb.snp.makeConstraints { make in
            make.centerX.equalTo(centerImage)
            make.top.equalTo(centerImage.snp.top).offset(3)
            make.height.equalTo(20)
        }
        pkcenterImage.snp.makeConstraints { make in
            make.centerX.equalTo(leftProgressView.snp.right)
            make.top.equalToSuperview()
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
        leftProgressView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(0)
            make.top.equalToSuperview().offset(8)
            make.width.equalTo(self.snp.width).multipliedBy(0.5)
            make.height.equalTo(24)
        }
        leftProgresslb.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.centerY.equalTo(leftProgressView)
        }
        rightProgressView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(0)
            make.top.equalToSuperview().offset(8)
            make.left.equalTo(leftProgressView.snp.right)
            make.height.equalTo(24)
        }
        rightProgresslb.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-12)
            make.centerY.equalTo(rightProgressView)
        }
        if self.isRoomPK {
        }
    }
}
extension LMRMSeatPkProgressView {
}
