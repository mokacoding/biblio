import UIKit

class ViewController: UIViewController, UITableViewDataSource {

  @IBOutlet var tableView: UITableView!
  @IBOutlet var loadingView: UIView!

  var books: [[String: Any]] = []

  override func viewDidLoad() {
    tableView.dataSource = self
    tableView.register(SubtitleCell.self, forCellReuseIdentifier: "book-cell")
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
    if let bookDetails = (books[indexPath.row]["book_details"] as? [[String: Any]])?.first {
      cell.textLabel?.text = bookDetails["title"] as? String
      cell.detailTextLabel?.text = bookDetails["description"] as? String
      cell.detailTextLabel?.numberOfLines = 0
    }
    return cell
  }
}
