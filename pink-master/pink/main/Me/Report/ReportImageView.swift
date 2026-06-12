import UIKit
extension Reportimv {
    func setDataSoure(_ images: [UIImage]) {
        self.dataSource = images
        self.collectionView.reloadData()
    }
}
class Reportimv: UIView {
    private lazy var titleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontM(16), textColor: lmColorHex("#2B313D"))
        let attributedString = NSMutableAttributedString(string: "证据截图：", attributes: [.font: lmFontM(16), .foregroundColor: lmColorHex("#2B313D")])
        lb.attributedText = attributedString
        return lb
    }()
    private lazy var tiplb: UILabel = {
        let lb = UILabel(lmfont: lmFontF(12), textColor: lmColorHex("#2B313D66"))
            .lmtext("有利于审核人员核实")
        return lb
    }()
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(target: self, cellTypes: [ReportImageItemCell.self])
        return collectionView
    }()
    private var dataSource: [UIImage] = []
    var didHeightUpdateblock: ((Double) -> Void)?
    var didClickCellblock: ((IndexPath) -> Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
private extension Reportimv {
    private func setViewSnp() {
        addSubview(titleLab)
        addSubview(tiplb)
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16.0)
            make.right.equalToSuperview().offset(-16.0)
            make.top.equalToSuperview().offset(16.0)
            make.bottom.equalToSuperview().offset(-16.0)
        }
        DispatchQueue.main {
            let collectionViewHeight = self.collectionView.collectionViewLayout.collectionViewContentSize.height
            self.didHeightUpdateblock?(collectionViewHeight + 32.0)
        }
    }
}
extension Reportimv: UICollectionViewDataSource & UICollectionViewDelegateFlowLayout & UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if dataSource.count < 3 {
            return dataSource.count + 1
        }
        return dataSource.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(cellType: ReportImageItemCell.self, cellForRowAt: indexPath)
        if indexPath.row == self.dataSource.count {
            cell.setDataSoure(nil)
        } else {
            cell.setDataSoure(dataSource[indexPath.row])
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = 70
        return CGSize(width: itemWidth, height: itemWidth)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        16.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        16.0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        self.didClickCellblock?(indexPath)
    }
}
