import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

  @IBOutlet var tableView: UITableView!
  @IBOutlet var loadingView: UIView!

  var books: [[String: Any]] = []
  var googleBooks: [URL: [String: Any]] = [:]
  var imageCache: UIImageGetter = ImageCache.shared
  var googleBookGetter: GoogleBookGetter = URLSession.shared

  override func viewDidLoad() {
    title = "Top Books"

    navigationController?.navigationBar.prefersLargeTitles = true

    tableView.dataSource = self
    tableView.delegate = self
    tableView.register(UINib(nibName: "BookTableViewCell", bundle: .none), forCellReuseIdentifier: "book-cell")
    tableView.rowHeight = UITableViewAutomaticDimension

    loadingView.isHidden = false
    tableView.isHidden = true

    let request = URLRequest(url: URL(string: "https://api.nytimes.com/svc/books/v3/lists.json?api-key=\(Secrets.nytKey)&list=combined-print-and-e-book-nonfiction")!)
    URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
      self?.books = (try! JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any])["results"] as! [[String: Any]]

      DispatchQueue.main.async { [weak self] in
        self?.tableView.isHidden = false
        self?.loadingView.isHidden = true
        self?.tableView.reloadData()
      }
    }.resume()
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return books.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "book-cell", for: indexPath)
    guard let bookCell = cell as? BookTableViewCell else { return cell }

    guard let bookDetails = (books[indexPath.row]["book_details"] as? [[String: Any]])?.first else {
      return cell
    }

    bookCell.titleLabel?.text = bookDetails["title"] as? String
    bookCell.descriptionLabel?.text = bookDetails["description"] as? String
    bookCell.thumbnailImageView.contentMode = .scaleAspectFit

    DispatchQueue.global().async { [weak self] in
      guard
        let isbn = bookDetails["primary_isbn13"] as? String,
        let googleBookURL = URL(string: "https://www.googleapis.com/books/v1/volumes?q=isbn:\(isbn)&key=\(Secrets.googleBooksKey)")
      else { return }

      if let googleBook = self?.googleBooks[googleBookURL] {
        if let thumbnailURL = self?.getURL(fromGoogleBook: googleBook) {
          self?.tryToGetImage(fromURL: thumbnailURL, for: bookCell)
        } else {
          DispatchQueue.main.async { [weak self] in
            self?.displayImageFailThumbnail(cell: bookCell)
          }
        }
      } else {
        self?.googleBookGetter.getGoogleBook(isbn: isbn) { [weak self] result in
          switch result {
          case .success(let googleBookDict):
            self?.googleBooks[googleBookURL] = googleBookDict

            if let thumbnailURL = self?.getURL(fromGoogleBook: googleBookDict) {
              self?.tryToGetImage(fromURL: thumbnailURL, for: bookCell)
            } else {
              DispatchQueue.main.async { [weak self] in
                self?.displayImageFailThumbnail(cell: bookCell)
              }
            }
          case .failure:
            DispatchQueue.main.async { [weak self] in
              self?.displayImageFailThumbnail(cell: bookCell)
            }
          }
        }
      }
    }

    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }

  private func set(cell: BookTableViewCell, with image: UIImage) {
    cell.thumbnailImageView.isHidden = false
    cell.thumbnailImageView.image = image
    cell.imageLoadingView.stopAnimating()
    cell.setNeedsLayout()
    cell.layoutIfNeeded()
  }

  private func displayImageFailThumbnail(cell: BookTableViewCell) {
    cell.thumbnailImageView.isHidden = true
    cell.imageLoadingView.stopAnimating()
    cell.imageLoadFailLabel.isHidden = false
  }

  private func tryToGetImage(fromURL url: URL, for cell: BookTableViewCell) {
    imageCache.image(for: url) { [weak self] image in
      if let image = image {
        DispatchQueue.main.async {
          self?.set(cell: cell, with: image)
        }
      } else {
        DispatchQueue.main.async {
          self?.displayImageFailThumbnail(cell: cell)
        }
      }
    }
  }

  private func getURL(fromGoogleBook googleBook: [String: Any]) -> URL? {
    guard
      let bookInfo = (googleBook["items"] as? [[String: Any]])?.first?["volumeInfo"] as? [String: Any],
      let imageLinks = bookInfo["imageLinks"] as? [String: Any],
      let thumbnailURLString = (imageLinks["thumbnail"] as? String)?.replacingOccurrences(of: "http://", with: "https://"),
      let thumbnailURL = URL(string: thumbnailURLString)
    else {
      return .none
    }

    return thumbnailURL
  }
}
