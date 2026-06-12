import Foundation
import UIKit
private let kEmptyDataViewTag = 99999
extension UIView {
    func confEmptyView(isEmpty: Bool, model: LMEmptyDataModel = LMEmptyDataModel()) {
        if isEmpty {
            if let subView = self.viewWithTag(kEmptyDataViewTag) {
                subView.removeFromSuperview()
            }
            let view = LMEmptyDataView(frame: self.bounds, model: model)
            view.tag = kEmptyDataViewTag
            self.addSubview(view)
        } else {
            guard let view = self.viewWithTag(kEmptyDataViewTag) else { return }
            view.removeFromSuperview()
        }
    }
    func fb_updateEmptyViewLayout() {
        guard let view = self.viewWithTag(kEmptyDataViewTag) else { return }
        view.frame = self.bounds
    }
}
struct LMEmptyDataModel {
    let offsetY: CGFloat
    let title: String
    let titleColor: UIColor
    init(title: String = "暂无数据", titleColor: UIColor = lmColorHex("#FFFFFF", alpha: 0.4), offsetY: CGFloat = 0) {
        self.title = title
        self.titleColor = titleColor
        self.offsetY = offsetY
    }
}
 private class LMEmptyDataView: UIView {
    private let model: LMEmptyDataModel
    private lazy var titleLab: UILabel = {
        let label = UILabel(lmfont: lmFontM(14), textColor: model.titleColor)
            .textAlignment(.center)
            .lmtext(model.title)
        return label
    }()
    init(frame: CGRect, model: LMEmptyDataModel) {
        self.model = model
        super.init(frame: frame)
        self.setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
     private func setViewSnp() {
         self.addSubview(titleLab)
         titleLab.snp.makeConstraints { make in
             make.left.equalToSuperview().offset(16.0)
             make.right.equalToSuperview().offset(-16.0)
             make.centerY.equalToSuperview().offset(model.offsetY)
         }
     }
}
