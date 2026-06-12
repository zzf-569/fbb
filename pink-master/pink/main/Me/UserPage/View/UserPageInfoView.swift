import UIKit
extension UserPageInfoView {
    func setDataSoure(_ model: UsInfoItem) {
        self.user = model
        tagView.isHidden = false
        signlb.lmtext(model.signature.isEmpty == true ? "这个人有点懒" : model.signature)
        tagView.setDataSoure(model)
        if user.photoWall.count > 0 {
            photoView.isHidden = false
            tagView.snp.remakeConstraints { make in
                make.width.equalTo(kScreenWidth)
                make.left.right.equalToSuperview()
                make.top.equalTo(photoView.snp.bottom).offset(kScaleWidth(16))
                make.bottom.equalToSuperview().offset(-kTabBarSafeHeight)
            }
            collectionView.reloadData()
        } else {
            photoView.isHidden = true
            tagView.snp.remakeConstraints { make in
                make.width.equalTo(kScreenWidth)
                make.left.right.equalToSuperview()
                make.top.equalTo(signView.snp.bottom).offset(kScaleWidth(16))
                make.bottom.equalToSuperview().offset(-kTabBarSafeHeight)
            }
        }
        if user.userId == UserShared.user?.userId {
            self.collectlb.isHidden = false
        } else {
            self.collectlb.isHidden = true
        }
        layoutSubviews()
    }
    func set_set_relation(_ model: relationModel) {
        let fans = NSMutableAttributedString(string: "\(model.liked)", attributes: [.foregroundColor: lmColorHex("#2B313D"), .font: lmFontM(20)])
        fans.append(NSAttributedString(string: "关注", attributes: [.foregroundColor: lmColorHex("#2B313DAD"), .font: lmFontF(10)]))
        self.fanslb.attributedText = fans
        let follows = NSMutableAttributedString(string: "\(model.fans)", attributes: [.foregroundColor: lmColorHex("#2B313D"), .font: lmFontM(20)] )
        follows.append(NSAttributedString(string: "粉丝", attributes: [.foregroundColor: lmColorHex("#2B313DAD"), .font: lmFontF(10)]))
        self.followlb.attributedText = follows
        let coll = NSMutableAttributedString(string: "\(model.collect)", attributes: [.foregroundColor: lmColorHex("#2B313D"), .font: lmFontM(20)] )
        coll.append(NSAttributedString(string: "收藏", attributes: [.foregroundColor: lmColorHex("#2B313DAD"), .font: lmFontF(10)] ))
        self.collectlb.attributedText = coll
    }
}
class UserPageInfoView: UIView {
    var user: UsInfoItem = UsInfoItem()
    var viewHeightChange: ((Double) -> Void)?
    weak var nestContentScrollView: UIScrollView?    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 100))
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        return scrollView
    }()
    lazy var fanslb: UILabel = {
        let lb = UILabel()
        lb.addGestureTap { [weak self] _ in
            guard let userId = self?.user.userId else {return}
            UIViewController.current?.navigationController?.pushViewController(MineFansFolllowViewController(userId: userId, type: 1), animated: true)
        }
        return lb
    }()
    lazy var followlb: UILabel = {
        let lb = UILabel()
        lb.addGestureTap { [weak self] _ in
            guard let userId = self?.user.userId else {return}
            UIViewController.current?.navigationController?.pushViewController(MineFansFolllowViewController(userId: userId, type: 2), animated: true)
        }
        return lb
    }()
    lazy var collectlb: UILabel = {
        let lb = UILabel()
        lb.addGestureTap { [weak self] _ in
            guard let userId = self?.user.userId else {return}
            
            UIViewController.current?.navigationController?.pushViewController(MineCollectRoomViewController(), animated: true)

        }
        return lb
    }()
    lazy var iconImg: UIImageView = {
        let image = UIImageView(image: UIImage(named: "user_dh_icon"))
        return image
    }()
    lazy var signTips: UILabel = {
        let lb = UILabel(lmfont: lmFontM(14), textColor: .textDefaulColor)
            .lmtext("TA的签名")
        return lb
    }()
    lazy var signView: UIView = {
        let view = UIView()
            .backgroundColor(.clear)
            .cornerRadius(8)
        return view
    }()
    lazy var signlb: UILabel = {
        let lb = UILabel(lmfont: lmFontR(14), textColor: lmColorHex("#2B313DAD"))
            .numberOfLines(0)
        return lb
    }()
    lazy var photoView: UIView = {
        let view = UIView()
            .backgroundColor(.clear)
            .cornerRadius(8)
        return view
    }()
    lazy var photoiconImg: UIImageView = {
        let image = UIImageView(image: UIImage(named: "user_dh_icon"))
        return image
    }()
    lazy var photoTips: UILabel = {
        let lb = UILabel(lmfont: lmFontM(14), textColor: .textDefaulColor)
            .lmtext("TA的照片")
        return lb
    }()
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UserPagePhotoCell.self, forCellWithReuseIdentifier: "UserPagePhotoCell")
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return collectionView
    }()
    lazy var tagView: UserInfoTageInfoView = {
        let view = UserInfoTageInfoView()
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViewSnp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setViewSnp() {
        backgroundColor(lmColorHex("#F3F3F5FF"))
        addSubview(scrollView)
        scrollView.addSubview(fanslb)
        scrollView.addSubview(followlb)
        scrollView.addSubview(collectlb)
        scrollView.addSubview(iconImg)
        scrollView.addSubview(signTips)
        scrollView.addSubview(signView)
        scrollView.addSubview(signlb)
        scrollView.addSubview(photoView)
        photoView.addSubview(photoiconImg)
        photoView.addSubview(photoTips)
        photoView.addSubview(collectionView)
        scrollView.addSubview(tagView)
        scrollView.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(kScreenWidth)
        }
        fanslb.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(20))
            make.top.equalToSuperview().offset(kScaleWidth(12))
        }
        followlb.snp.makeConstraints { make in
            make.left.equalTo(fanslb.snp.right).offset(kScaleWidth(16))
            make.top.equalToSuperview().offset(kScaleWidth(12))
        }
        collectlb.snp.makeConstraints { make in
            make.left.equalTo(followlb.snp.right).offset(kScaleWidth(16))
            make.top.equalToSuperview().offset(kScaleWidth(12))
        }
        iconImg.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(20))
            make.top.equalTo(fanslb.snp.bottom).offset(12)
        }
        signTips.snp.makeConstraints { make in
            make.left.equalTo(iconImg.snp.right).offset(kScaleWidth(4))
            make.top.equalTo(fanslb.snp.bottom).offset(12)
            make.height.equalTo(24.0)
        }
        signView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(kScaleWidth(20))
            make.top.equalTo(signTips.snp.bottom).offset(kScaleWidth(8))
            make.bottom.equalTo(signlb.snp.bottom).offset(kScaleWidth(12))
        }
        signlb.snp.makeConstraints { make in
            make.left.right.top.equalTo(signView).inset(kScaleWidth(12))
        }
        photoView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.width.equalTo(kScreenWidth - 40)
            make.top.equalTo(signView.snp.bottom).offset(16)
            make.height.equalTo(kScaleWidth(182))
        }
        photoiconImg.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(kScaleWidth(0))
            make.top.equalToSuperview().offset(12)
        }
        photoTips.snp.makeConstraints { make in
            make.left.equalTo(iconImg.snp.right).offset(kScaleWidth(4))
            make.top.equalToSuperview().offset(12)
            make.height.equalTo(24.0)
        }
        collectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.width.equalTo(kScreenWidth)
            make.top.equalToSuperview().offset(kScaleWidth(46))
            make.height.equalTo(kScaleWidth(120))
        }
        tagView.snp.makeConstraints { make in
            make.width.equalTo(kScreenWidth)
            make.left.right.equalToSuperview()
            make.top.equalTo(photoView.snp.bottom).offset(kScaleWidth(16))
            make.bottom.equalToSuperview().offset(-10)
        }
    }
}
extension UserPageInfoView: UICollectionViewDataSource & UICollectionViewDelegateFlowLayout & UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        user.photoWall.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: kScaleWidth(90), height: kScaleWidth(120))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        kScaleWidth(8)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserPagePhotoCell", for: indexPath) as! UserPagePhotoCell
        cell.setDataSoure(user.photoWall[indexPath.row])
        return cell
    }
}
extension UserPageInfoView: JXPagingViewListViewDelegate, UIScrollViewDelegate {
    func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> Void) {
        listViewDidScrollCallback = callback
    }
    func listView() -> UIView { self }
    func listScrollView() -> UIScrollView { scrollView }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        listViewDidScrollCallback?(scrollView)
    }
}
