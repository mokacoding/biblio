import UIKit

class FavouriteBooksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

  @IBOutlet var tableView: UITableView!
  @IBOutlet var emptyLabel: UILabel!

  var books: [[String: Any]]?

  override func viewDidLoad() {
    title = "Favourites"

    navigationController?.navigationBar.prefersLargeTitles = true

    tableView.dataSource = self
    tableView.delegate = self
    tableView.register(UINib(nibName: "BookTableViewCell", bundle: .none), forCellReuseIdentifier: "book-cell")
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    books = LocalBooksManager.shared.getBooks()
    if books?.count == 0 {
      tableView.isHidden = true
      emptyLabel.isHidden = false
    } else {
      tableView.isHidden = false
      emptyLabel.isHidden = true
      tableView.reloadData()
    }
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return books?.count ?? 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "book-cell", for: indexPath)
    guard let bookCell = cell as? BookTableViewCell else { return cell }

    if let bookDetails = books?[indexPath.row] {
      bookCell.titleLabel?.text = bookDetails["title"] as? String
      bookCell.descriptionLabel?.text = bookDetails["description"] as? String
      bookCell.thumbnailImageView.contentMode = .scaleAspectFit

      DispatchQueue.global().async {
        if
          let googleBook = bookDetails["googleBook"] as? [String: Any],
          let bookInfo = (googleBook["items"] as? [[String: Any]])?.first?["volumeInfo"] as? [String: Any],
              let imageLinks = bookInfo["imageLinks"] as? [String: Any],
              let thumbnailURLString = (imageLinks["thumbnail"] as? String)?.replacingOccurrences(of: "http://", with: "https://"),
              let thumbnailURL = URL(string: thumbnailURLString)
            {
              ImageCache.shared.image(for: thumbnailURL) { image in
                if let image = image {
                  DispatchQueue.main.async {
                    bookCell.thumbnailImageView.isHidden = false
                    bookCell.thumbnailImageView.image = image
                    bookCell.imageLoadingView.stopAnimating()
                    bookCell.setNeedsLayout()
                    bookCell.layoutIfNeeded()
                  }
                } else {
                  DispatchQueue.main.async {
                    bookCell.thumbnailImageView.isHidden = true
                    bookCell.imageLoadingView.stopAnimating()
                    bookCell.imageLoadFailLabel.isHidden = false
                  }
                }
              }
        } else {
          DispatchQueue.main.async {
            bookCell.thumbnailImageView.isHidden = true
            bookCell.imageLoadingView.stopAnimating()
            bookCell.imageLoadFailLabel.isHidden = false
          }
        }
      }
    }

    return cell
  }

  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    return  UISwipeActionsConfiguration(actions: [
        UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completionHandler) in
          if let book = self?.books?[indexPath.row] {
            LocalBooksManager.shared.delete(book)
            completionHandler(true)
          } else {
            completionHandler(false)
          }
        }
      ])
  }
}
