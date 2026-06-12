import UIKit

extension LMRMMoreView {
    func setDataSoure(_ dataSource: [LMRMMoreSectionModel]) {
        self.dataSource = dataSource
        self.collectionView.reloadData()
    }
    func show() {
        self.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.bdView.y = self.height - self.bdView.height
        }
    }
    func hide() {
        UIView.animate(withDuration: 0.3) {
            self.bdView.y = self.height
        }completion: { _ in
            self.isHidden = true
        }
    }
}
class LMRMMoreView: UIView {
    private lazy var bgView: UIView = {
        let view = UIView(frame: self.bounds)
        view.addGestureTap { [weak self] _ in
            guard let self = self else { return }
            self.hide()
        }
        return view
    }()
    private lazy var bdView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: self.height, width: self.width, height: kScaleWidth(640)))
        let effec = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: effec)
        view.addSubview(blurView)
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return view
    }()
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(target: self, cellTypes: [LMRMMoreItemCell.self,LMRMMoreImageCell.self,LMRMMoreVerCell.self])
        collectionView.showsVerticalScrollIndicator = false
        collectionView.lm_registerReusableView(reusableView:LMRMMoreHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
        collectionView.lm_registerReusableView(reusableView:LMRMMoreHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter)
        return collectionView
    }()
    private var dataSource: [LMRMMoreSectionModel] = []
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
private extension LMRMMoreView {
    private func setViewSnp() {
        self.addSubview(self.bgView)
        self.addSubview(self.bdView)
        self.bdView.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(0)
            make.right.equalToSuperview().offset(0)
            make.top.equalToSuperview().offset(44)
            make.bottom.equalToSuperview().offset(-(16.0 + kTabBarSafeHeight))
        }
        layoutIfNeeded()
        bdView.set_Border(radius: 16.0, conrners: [.topLeft, .topRight])
        let lineView = UIView().backgroundColor(lmColorHex("#FFFFFF3D"))
            .cornerRadius(2)
        bdView.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(kScaleWidth(8))
            make.size.equalTo(CGSize(width: 48, height: 4))
        }
    }
}
extension LMRMMoreView: UICollectionViewDataSource & UICollectionViewDelegateFlowLayout & UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        self.dataSource.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionModel = self.dataSource[section]
        return sectionModel.dataSource.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionModel = self.dataSource[indexPath.section]
        if sectionModel.dataSource[indexPath.row].cellType == .imageItem {
            let cell = collectionView.dequeueReusableCell(cellType:LMRMMoreImageCell.self, cellForRowAt: indexPath)
            cell.setDataSoure(sectionModel.dataSource[indexPath.row])
            return cell
        }
        if sectionModel.dataSource[indexPath.row].cellType == .vertical {
            let cell = collectionView.dequeueReusableCell(cellType:LMRMMoreVerCell.self, cellForRowAt: indexPath)
            cell.setDataSoure(sectionModel.dataSource[indexPath.row], index: indexPath.row, lastIndex: indexPath.row == sectionModel.dataSource.count - 1 ? true : false)
            return cell
        }
        let cell = collectionView.dequeueReusableCell(cellType:LMRMMoreItemCell.self, cellForRowAt: indexPath)
        cell.setDataSoure(sectionModel.dataSource[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionModel = self.dataSource[indexPath.section]
        if sectionModel.dataSource[indexPath.row].cellType == .imageItem {
            return CGSize(width: 128, height: 54)
        }
        if sectionModel.dataSource[indexPath.row].cellType == .vertical {
            return CGSize(width: kScaleWidth(350), height: 54)
        }
        if sectionModel.dataSource[indexPath.row].cellType == .itemW {
            return CGSize(width: kScaleWidth(56), height: 80)
        }
        return CGSize(width: kScaleWidth(48), height: 72)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let sectionModel = self.dataSource[section]
        if sectionModel.dataSource[0].cellType == .imageItem {
            return UIEdgeInsets(top: 12, left: 16, bottom: 8, right: 16)
        }
        if sectionModel.dataSource[0].cellType == .vertical {
            return UIEdgeInsets(top: 0, left: kScaleWidth(20), bottom: 0, right: kScaleWidth(20))
        }
        if sectionModel.dataSource[0].cellType == .itemW {
            return UIEdgeInsets(top: 0, left: kScaleWidth(20), bottom: 0, right: kScaleWidth(5))
        }
        return UIEdgeInsets(top: 0, left: kScaleWidth(20), bottom: 0, right: kScaleWidth(20))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let sectionModel = self.dataSource[section]
        if sectionModel.dataSource[0].cellType == .vertical {
            return 0.0
        }
        return kScaleWidth(20)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let sectionModel = self.dataSource[section]
        if sectionModel.dataSource[0].cellType == .vertical {
            return 0.0
        }
        if sectionModel.dataSource[0].cellType == .item {
            return kScaleWidth(27)
        }
        return kScaleWidth(20)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        CGSize(width: self.width, height: 20.0)
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.lm_dequeueSupplementaryView(reusableView:LMRMMoreHeaderView.self, ofKind: UICollectionView.elementKindSectionFooter, for: indexPath)
            footer.setDataSoure("")
            return footer
        }
        return UICollectionReusableView()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let sectionModel = self.dataSource[indexPath.section]
        let item = sectionModel.dataSource[indexPath.row]
        Mediator.shared.dispatch(event: LMRMViewMethon.moreViewMethon, data: item)
        self.hide()
    }
}
