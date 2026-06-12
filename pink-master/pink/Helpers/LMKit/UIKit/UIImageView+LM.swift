import UIKit
public extension UIImageView {
}
public extension UIImageView {
    @discardableResult
    func image(_ image: UIImage?) -> Self {
        self.image = image
        return self
    }
    func imageName(_ imageName: String) -> Self {
        self.image = UIImage(named: imageName)
        return self
    }
    func imageURL(_ urlString: String?, placeholder: UIImage? = kPlaceholder_image) -> Self {
        self.set_Image(url: urlString, placeholder: placeholder)
        return self
    }
}
