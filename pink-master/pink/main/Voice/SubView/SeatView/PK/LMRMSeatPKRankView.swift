import UIKit
enum RoomSeatPKRankAlignment {
    case left
    case right
}
extension LMRMSeatPKRankView {
    func setDataSoure(_ list: [UsInfoItem]) {
        for view in self.subviews {
            if let item = view as?RoomSeatPKRankItemView {
                if list.count > item.tag {
                    let model = list[item.tag]
                    item.usheaderView.set_Image(url: model.avatar)
                } else {
                    item.usheaderView.image = UIImage(named: "rm_seat")
                }
            }
        }
    }
    func set_CrossData(_ list: [LMtopAvatarModel]) {
        for view in self.subviews {
            if let item = view as?RoomSeatPKRankItemView {
                if list.count > item.tag {
                    let model = list[item.tag]
                    item.usheaderView.set_Image(url: model.avatar)
                } else {
                    item.usheaderView.image = UIImage(named: "rm_seat")
                }
            }
        }
    }
}
class LMRMSeatPKRankView: UIView {
    private let alignment:RoomSeatPKRankAlignment
    private var items: [UIButton] = []
    init(frame: CGRect, alignment:RoomSeatPKRankAlignment) {
        self.alignment = alignment
        super.init(frame: frame)
        self.setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
private extension LMRMSeatPKRankView {
    private func setViewSnp() {
        var tempView:RoomSeatPKRankItemView?
        for index in 0...2 {
            let item = RoomSeatPKRankItemView()
            item.usheaderView.image = UIImage(named: "rm_pk_rank_seat")
            item.tag = index
            item.isUserInteractionEnabled = true
            item.addGestureTap { [weak self] _ in
                    guard let self = self else { return }
            }
            addSubview(item)
            if alignment == .left {
                item.borderimv.image = UIImage(named: "rm_pk_rank_b_\(index + 1)")
                item.snp.makeConstraints { make in
                    if let view = tempView {
                        make.left.equalTo(view.snp.right).offset(1.0)
                    } else {
                        make.left.equalToSuperview()
                    }
                    make.centerY.equalToSuperview()
                    make.width.height.equalTo(28.0)
                }
            } else {
                item.borderimv.image = UIImage(named: "rm_pk_rank_r_\(index + 1)")
                item.snp.makeConstraints { make in
                    if let view = tempView {
                        make.right.equalTo(view.snp.left).offset(-1.0)
                    } else {
                        make.right.equalToSuperview()
                    }
                    make.centerY.equalToSuperview()
                    make.width.height.equalTo(28.0)
                }
            }
            tempView = item
        }
    }
}
extension RoomSeatPKRankItemView {
}
class RoomSeatPKRankItemView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    lazy var usheaderView: UIImageView = {
        let imv = UIImageView(image: UIImage(named: "rm_seat"))
            .contentMode(.scaleAspectFill)
            .cornerRadius(27/2)
        return imv
    }()
    lazy var borderimv: UIImageView = {
        let imv = UIImageView()
        return imv
    }()
}
private extension RoomSeatPKRankItemView {
    private func setViewSnp() {
        addSubview(usheaderView)
        addSubview(borderimv)
        borderimv.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        usheaderView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(27.0)
        }
    }
}
