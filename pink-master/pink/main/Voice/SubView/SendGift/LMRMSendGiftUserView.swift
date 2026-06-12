import UIKit
extension LMRMSendGiftUserView {
    func set_UserInfo(_ user:LMSeatusInfoModel) {
        self.userNameLael.text = user.nickname
        self.userNameLael.isHidden = false
        self.seatCollectionView.isHidden = true
        self.allSeatbtn.isHidden = true
    }
    func set_Seats(_ list: [RoomSeatItem], isAll: Bool) {
        self.seats = list
        self.seatCollectionView.reloadData()
        self.userNameLael.isHidden = true
        self.seatCollectionView.isHidden = false
        self.allSeatbtn.isHidden = false
        self.allSeatbtn.isSelected = isAll
    }
    func updateSeats(_ list: [RoomSeatItem]) {
        self.seats = list
        self.seatCollectionView.reloadData()
    }
}
class LMRMSendGiftUserView: UIView {
    private lazy var titleLab: UILabel = {
        let lb = UILabel(lmfont: lmFontM(14), textColor: .white)
            .lmtext("送给:")
        return lb
    }()
    private lazy var userNameLael: UILabel = {
        let lb = UILabel(lmfont: lmFontM(14), textColor: .white)
        return lb
    }()
    private lazy var seatCollectionView: UICollectionView = {
        let collectionView = UICollectionView(target: self, cellTypes: [LMRMSendGiftSeatCell.self], scrollDirection: .horizontal)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    private lazy var allSeatbtn: UIButton = {
        let btn = UIButton(lmfont: lmFontM(12), titleColor: .white, target: self, action: #selector(allSeatbtnAction))
            .backgroundImage(UIImage.image(color: lmColorHex("#FFFFFF", alpha: 0.1)), .normal)
            .backgroundImage(UIImage.image(color: lmColorHex("#FF4F7DFF")), .selected)
            .lmtitle("全麦")
            .cornerRadius(28/2)
        btn.clickInterval = 0.0
        return btn
    }()
    private var seats: [RoomSeatItem] = []
    var selectedSeatblock: ((RoomSeatItem?) -> Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
private extension LMRMSendGiftUserView {
    private func setViewSnp() {
        self.addSubview(titleLab)
        self.addSubview(userNameLael)
        self.addSubview(seatCollectionView)
        self.addSubview(allSeatbtn)
        titleLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16.0)
            make.centerY.equalToSuperview()
            make.width.equalTo(32.0)
        }
        userNameLael.snp.makeConstraints { make in
            make.left.equalTo(titleLab.snp.right).offset(12.0)
            make.centerY.equalToSuperview()
        }
        seatCollectionView.snp.makeConstraints { make in
            make.left.equalTo(titleLab.snp.right).offset(12.0)
            make.centerY.equalToSuperview()
            make.height.equalTo(44.0)
            make.right.equalTo(allSeatbtn.snp.left).offset(-12.0)
        }
        allSeatbtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16.0)
            make.centerY.equalToSuperview()
            make.width.equalTo(48.0)
            make.height.equalTo(28.0)
        }
    }
    @objc func allSeatbtnAction() {
        self.selectedSeatblock?(nil)
    }
}
extension LMRMSendGiftUserView: UICollectionViewDataSource & UICollectionViewDelegateFlowLayout & UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        seats.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(cellType:LMRMSendGiftSeatCell.self, cellForRowAt: indexPath)
        cell.setDataSoure(self.seats[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 32.0, height: 44.0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        8.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        8.0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        self.selectedSeatblock?(seats[indexPath.row])
    }
}
