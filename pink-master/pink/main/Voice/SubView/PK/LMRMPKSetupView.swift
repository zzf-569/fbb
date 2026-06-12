import UIKit
extension LMRMPKSetupView {
}
class LMRMPKSetupView: UIView {
    private var selectedPKTimeblock: (Int, Int) -> Void
    private var dataSource: [[LMRMPKSetupModel]] = {
        [[LMRMPKSetupModel(title: "房内PK", selected: true, time: 0),
         LMRMPKSetupModel(title: "跨房PK", selected: false, time: 1)], [LMRMPKSetupModel(title: "5分", selected: false, time: 300),
          LMRMPKSetupModel(title: "10分", selected: false, time: 600),
          LMRMPKSetupModel(title: "15分", selected: false, time: 900)]]
    }()
    var viewModel:VoiceVM?
    var isPking: Bool = false
    private var pkViewModel :LMRMPKViewModel?
    init(_ viewModel:VoiceVM, pkViewModel:LMRMPKViewModel?, block: @escaping (Int, Int) -> Void) {
        self.selectedPKTimeblock = block
        self.viewModel = viewModel
        self.pkViewModel = pkViewModel
        super.init(frame: .zero)
        self.setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(target: self, cellTypes: [LMRMPKSetupCell.self])
        collectionView.lm_registerReusableView(reusableView:LMRMMoreHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
        collectionView.lm_registerReusableView(reusableView:LMRMMoreHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter)
        return collectionView
    }()
}
private extension LMRMPKSetupView {
    private func setViewSnp() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16.0)
            make.top.equalToSuperview()
            make.right.equalToSuperview().offset(-16.0)
            make.bottom.equalToSuperview()
        }
        if pkViewModel != nil, pkViewModel?.dataSoure.status != .normal {
            dataSource[0][0].selected = true
            for (index, item) in dataSource[1].enumerated() {
                if item.time == pkViewModel?.dataSoure.pkTime {
                    dataSource[1][index].selected = true
                }
            }
            isPking = true
        }
        if viewModel?.roomItem.roomPkInfo != nil {
            dataSource[0][0].selected = false
            dataSource[0][1].selected = true
            for (index, item) in dataSource[1].enumerated() {
                if item.time == viewModel?.roomItem.roomPkInfo?.pkTime {
                    dataSource[1][index].selected = true
                }
            }
            isPking = true
        }
    }
}
extension LMRMPKSetupView: UICollectionViewDataSource & UICollectionViewDelegateFlowLayout & UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        dataSource.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let items = dataSource[section]
        return items.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let items = dataSource[indexPath.section]
        let cell = collectionView.dequeueReusableCell(cellType:LMRMPKSetupCell.self, cellForRowAt: indexPath)
        cell.setDataSoure(items[indexPath.row])
        cell.set_Nomor(isPking)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = (kScreenWidth - 16.0 * 2 - 14.0 * 2)/3
        return CGSize(width: itemWidth, height: 40.0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        14.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        14.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: self.width, height: 44.0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        CGSize(width: self.width, height: 20.0)
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let footer = collectionView.lm_dequeueSupplementaryView(reusableView:LMRMMoreHeaderView.self, ofKind: UICollectionView.elementKindSectionHeader, for: indexPath)
            if indexPath.section == 0 {
                footer.setDataSoure("模式")
            } else {
                footer.setDataSoure("时长")
            }
            return footer
        }
        return collectionView.lm_dequeueSupplementaryView(reusableView:LMRMMoreHeaderView.self, ofKind: UICollectionView.elementKindSectionFooter, for: indexPath)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isPking == true {
            return
        }
        let items = dataSource[indexPath.section]
        for (index, _) in items.enumerated() {
            if index == indexPath.row {
                dataSource[indexPath.section][index].selected = true
            } else {
                dataSource[indexPath.section][index].selected = false
            }
        }
        collectionView.reloadData()
        var type = 0
        var time = 0
        for (index, item) in dataSource[0].enumerated() {
            if item.selected == true {
                type = item.time
            }
        }
        for (index, item) in dataSource[1].enumerated() {
            if item.selected == true {
                time = item.time
            }
        }
        self.selectedPKTimeblock(type, time)
    }
}
