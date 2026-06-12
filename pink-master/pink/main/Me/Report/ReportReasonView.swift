import UIKit
extension ReportReasonView {
    func setDataSoure(_ list: [ReportReasonItemModel]) {
        dataSource = list
        collectionView.reloadData()
        DispatchQueue.main {
            let collectionViewHeight = self.collectionView.collectionViewLayout.collectionViewContentSize.height
            self.collectionView.snp.updateConstraints { make in
                make.height.equalTo(collectionViewHeight)
            }
            self.didHeightUpdateblock?(48.0 + collectionViewHeight + 40.0 + 120.0 + 16.0)
        }
    }
}
class ReportReasonView: UIView {
    private lazy var titleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontM(16), textColor: lmColorHex("#2B313D"))
        let attributedString = NSMutableAttributedString(string: "*", attributes: [.font: lmFontM(16), .foregroundColor: lmColorHex("#F5455C")])
        attributedString.append(NSAttributedString(string: "违规类型：", attributes: [.font: lmFontM(16), .foregroundColor: lmColorHex("#2B313D")]))
        lb.attributedText = attributedString
        return lb
    }()
    private lazy var collectionView: UICollectionView = {
        let flowLayout = LMCollectionViewAlignFlowLayout()
        flowLayout.minimumLineSpacing = 8
        flowLayout.minimumInteritemSpacing = 8
        flowLayout.alignDirection = .left
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.neverAdjustContentInset()
        collectionView.register(cellClass: ReportReasonItemCell.self)
        return collectionView
    }()
    private lazy var textlb: UILabel = {
        let lb = UILabel(lmfont: lmFontM(16), textColor: lmColorHex("#2B313D"))
        let attributedString = NSMutableAttributedString(string: "*", attributes: [.font: lmFontM(16), .foregroundColor: lmColorHex("#F5455C")])
        attributedString.append(NSAttributedString(string: "问题描述", attributes: [.font: lmFontM(16), .foregroundColor: lmColorHex("#2B313D")]))
        lb.attributedText = attributedString
        return lb
    }()
    private lazy var textView: UITextView = {
        let textView = UITextView(lmfont: lmFontF(14), textColor: lmColorHex("#2B313D"))
            .backgroundColor(.white)
            .cornerRadius(3.0)
        textView.placeholder = "请描述举报内容"
        textView.textContainerInset = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
        return textView
    }()
    private lazy var contentlb: UILabel = {
        let lb = UILabel(lmfont: lmFontF(16), textColor: lmColorHex("#2B313D"))
        return lb
    }()
    private var dataSource: [ReportReasonItemModel] = []
    var didHeightUpdateblock: ((Double) -> Void)?
    var didClickCellblock: ((IndexPath) -> Void)?
    var didReasonTextChangeblock: ((String) -> Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
private extension ReportReasonView {
    private func setViewSnp() {
        backgroundColor(.white)
        addSubview(titleLab)
        addSubview(collectionView)
        addSubview(textlb)
        addSubview(textView)
        titleLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16.0)
            make.top.equalToSuperview().offset(16.0)
            make.height.equalTo(24.0)
        }
        collectionView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(16))
            make.right.equalToSuperview().offset(-kScaleWidth(16))
            make.top.equalTo(titleLab.snp.bottom).offset(16.0)
            make.height.equalTo(0)
        }
        textlb.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16.0)
            make.top.equalTo(collectionView.snp.bottom).offset(10.0)
            make.height.equalTo(24.0)
        }
        textView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16.0)
            make.right.equalToSuperview().offset(-16.0)
            make.top.equalTo(textlb.snp.bottom).offset(10.0)
            make.height.equalTo(120.0)
            make.bottom.equalToSuperview().offset(-16.0)
        }
    }
}
extension ReportReasonView: UICollectionViewDataSource & UICollectionViewDelegateFlowLayout & UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(cellType: ReportReasonItemCell.self, cellForRowAt: indexPath)
        cell.setDataSoure(dataSource[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: kScaleWidth(72), height: kScaleWidth(24))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        8.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        8.0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        dataSource[indexPath.row].isSelected = !dataSource[indexPath.row].isSelected
        collectionView.reloadData()
        self.didClickCellblock?(indexPath)
    }
}
