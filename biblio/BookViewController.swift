import UIKit

class BookViewController: UIViewController {

  @IBOutlet var coverImageView: UIImageView!
  @IBOutlet var titleLabel: UILabel!

  var book: [String: Any]?
  var googleBook: [String: Any]?

  override func viewWillAppear(_ animated: Bool) {
    titleLabel.text = book?["title"] as? String

    if let googleBook = googleBook {
      if
        let bookInfo = (googleBook["items"] as? [[String: Any]])?.first?["volumeInfo"] as? [String: Any],
        let imageLinks = bookInfo["imageLinks"] as? [String: Any],
        let thumbnailURLString = (imageLinks["thumbnail"] as? String)?.replacingOccurrences(of: "http://", with: "https://"),
        let thumbnailURL = URL(string: thumbnailURLString)
      {
        ImageCache.shared.image(for: thumbnailURL) { image in
          if let image = image {
            DispatchQueue.main.async { [weak self] in
              self?.coverImageView.image = image
            }
          }
        }
      }
    }
  }

  @IBAction func save(sender: UIButton) {
    if var book = self.book {
      book["googleBook"] = googleBook
      LocalBooksManager.shared.save(book)
    }
  }
}
