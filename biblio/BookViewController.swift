import UIKit

class BookViewController: UIViewController {

  @IBOutlet var coverImageView: UIImageView!
  @IBOutlet var titleLabel: UILabel!

  var book: [String: Any]?

  override func viewWillAppear(_ animated: Bool) {
    titleLabel.text = book?["title"] as? String
  }
}
