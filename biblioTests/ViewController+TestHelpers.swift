@testable import biblio
import UIKit

extension ViewController {

  static func fromStoryboard() -> ViewController {
    return UIStoryboard(name: "Main", bundle: Bundle(for: ViewController.self))
      .instantiateViewController(withIdentifier: "books_list") as! ViewController
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
