import Kingfisher
public let kPlaceholder_image = UIImage(named: "commom_placeholder")
public let kPlaceholder_avatar = UIImage(named: "commom_placeholder")
extension   UIImageView {
    func set_Image(url: String?, placeholder: UIImage? = kPlaceholder_image, completionHandler: ((Result<RetrieveImageResult, KingfisherError>) -> Void)? = nil) {
        guard let str = url else {  self.image = placeholder; return  }
        self.kf.setImage(with: URL(string: str), placeholder: placeholder, completionHandler: completionHandler)
    }
    func set_usheader(url: String?, placeholder: UIImage? = kPlaceholder_avatar, completionHandler: ((Result<RetrieveImageResult, KingfisherError>) -> Void)? = nil) {
        guard let str = url else {  self.image = placeholder; return }
        self.kf.setImage(with: URL(string: str), placeholder: placeholder, completionHandler: completionHandler)
    }
}
