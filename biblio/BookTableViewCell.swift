import UIKit

class BookTableViewCell: UITableViewCell {

  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var descriptionLabel: UILabel!
  @IBOutlet var thumbnailImageView: UIImageView!

  override func prepareForReuse() {
    super.prepareForReuse()

    bookCell.thumbnailImageView.image = UIImage(
      color: .gray,
      size: CGSize(width: 1, height: 1)
    )
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
