@testable import biblio
import UIKit

extension ViewController {

  static func fromStoryboard(
    cache: [URL: [String: Any]] = [:],
    imageCache: UIImageGetter = UIImageGetterStub()
  ) -> ViewController {
    let vc = UIStoryboard(name: "Main", bundle: Bundle(for: ViewController.self))
      .instantiateViewController(withIdentifier: "books_list") as! ViewController

    vc.googleBooks = cache
    vc.imageCache = imageCache

    return vc
  }

  func cell(atRow row: Int) -> BookTableViewCell? {
    return tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? BookTableViewCell
  }

  static func moreThanOneVisibleCell() -> NSPredicate {
    return NSPredicate { object, _ in
      guard let viewController = object as? ViewController else { return false }

      return viewController.tableView.visibleCells.count > 1
    }
  }
}

private let defaultURL = URL(string: "https://www.googleapis.com/books/v1/volumes?q=isbn:9780062872746&key=\(Secrets.googleBooksKey)")!
