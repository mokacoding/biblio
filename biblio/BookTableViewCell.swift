import UIKit

class BookTableViewCell: UITableViewCell {

  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var descriptionLabel: UILabel!
  @IBOutlet var thumbnailImageView: UIImageView!
  @IBOutlet var imageLoadingView: UIActivityIndicatorView!
  @IBOutlet var imageLoadFailLabel: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
    reset()
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    reset()
  }

  func reset() {
    thumbnailImageView.image = nil
    thumbnailImageView.isHidden = true

    imageLoadingView.isHidden = false
    imageLoadingView.startAnimating()

    imageLoadFailLabel.isHidden = true
  }
}

public extension UIImage {

  public convenience init?(color: UIColor, size: CGSize) {
    let rect = CGRect(origin: .zero, size: size)
    UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
    color.setFill()
    UIRectFill(rect)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    guard let cgImage = image?.cgImage else { return nil }
    self.init(cgImage: cgImage)
  }
}
