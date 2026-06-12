import UIKit
import AttributedString
extension SearchUserCell {
    func setDataSoure(_ models: [UsInfoItem]) {
        scrollView.removeAllSubViews()
        for (index, item) in models.enumerated() {
            let view = SearchUserView()
                .cornerRadius(6)
            if index % 2 == 0 {
                view.backgroundColor(lmColorHex("#FF4F7D14"))
            } else {
                view.backgroundColor(lmColorHex("#328BF914"))
            }
            view.dataSoure = item
            scrollView.addSubview(view)
            view.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(12 + (index * Int(kScaleWidth(128))))
                make.top.equalToSuperview()
                make.size.equalTo(CGSize(width: kScaleWidth(120), height: kScaleWidth(134)))
                if index == models.count - 1 {
                    make.right.equalToSuperview().offset(-12)
                }
            }
            view.addGestureTap { [weak self] _ in
                if let room = item.currentRoom {
                    VoiceShared.turnToRM(room.roomId)
                } else {
                    RouteService.pushUserMainPage(item.userId, vc: UIViewController.current)
                }
            }
        }
    }
}
class SearchUserCell: BaseCollectionViewCell {
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: self.bounds)
        scrollView.backgroundColor(.white)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
private extension SearchUserCell {
    func setViewSnp() {
        addSubview(scrollView)
    }
}
