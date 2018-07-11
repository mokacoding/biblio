import Foundation

class LocalBooksManager {

  static let shared = LocalBooksManager()

  func save(_ book: [String: Any]) {
    if var books = UserDefaults.standard.object(forKey: "books") as? [[String: Any]] {
      books.append(book)
      UserDefaults.standard.set(books, forKey: "books")
    } else {
      UserDefaults.standard.set([book], forKey: "books")
    }
  }

  func getBooks() -> [[String: Any]]? {
    return UserDefaults.standard.object(forKey: "books") as? [[String: Any]]
  }
}
