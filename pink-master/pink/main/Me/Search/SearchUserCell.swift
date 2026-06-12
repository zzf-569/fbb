import UIKit
import AttributedString
extension SearchUserCell {
    func act_setConfigData(_ models: [UserModel]) {
        scrollView.act_removeAllSubViews()
        for (index, item) in models.enumerated() {
            let view = SearchUserView()
                .act_cornerRadius(6)
            if index % 2 == 0 {
                view.act_backgroundColor(lmColorHex("#FF4F7D14"))
            } else {
                view.act_backgroundColor(lmColorHex("#328BF914"))
            }
            view.model = item
            scrollView.addSubview(view)
            view.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(12 + (index * Int(kScaleWidth(128))))
                make.top.equalToSuperview()
                make.size.equalTo(CGSize(width: kScaleWidth(120), height: kScaleWidth(134)))
                if index == models.count - 1 {
                    make.right.equalToSuperview().offset(-12)
                }
            }
            view.act_addGestureTap { [weak self] _ in
                if let room = item.currentRoom {
                    RoomShared.act_enter(room.roomId)
                } else {
                    RouteService.act_pushUserMainPage(item.userId, vc: UIViewController.current)
                }
            }
        }
    }
}
class SearchUserCell: BaseCollectionViewCell {
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: self.bounds)
        scrollView.act_backgroundColor(.white)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        act_setUISubViews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
private extension SearchUserCell {
    func act_setUISubViews() {
        addSubview(scrollView)
    }
}
