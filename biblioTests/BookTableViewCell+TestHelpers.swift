@testable import biblio
import UIKit

extension BookTableViewCell {

  static func fromNib() -> BookTableViewCell? {
    let cell = UINib(nibName: "BookTableViewCell", bundle: Bundle(for: BookTableViewCell.self))
      .instantiate(withOwner: .none, options: .none)
      .first as? BookTableViewCell

    cell?.awakeFromNib()
    cell?.layoutSubviews()

    return cell
  }

  static func imageIsLoaded() -> NSPredicate {
    return NSPredicate { object, _ in
      guard let cell = object as? BookTableViewCell else { return false }
      return cell.thumbnailImageView?.image != nil && cell.imageLoadingView?.isHidden == true
    }
  }

  static func errorLabelIsShown() -> NSPredicate {
    return NSPredicate { object, _ in
      guard let cell = object as? BookTableViewCell else { return false }
      return cell.imageLoadingView?.isHidden == true && cell.imageLoadFailLabel.isHidden == false
    }
  }
}
