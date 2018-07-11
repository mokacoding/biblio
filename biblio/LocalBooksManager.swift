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

  func delete(_ book: [String: Any]) {
    if var books = UserDefaults.standard.object(forKey: "books") as? [[String: Any]] {
      var indexToDelete = 0
      books.enumerated().forEach { (i, b) in
        if let bISBN = b["primary_isbn13"] as? String, let bookISBN = book["primary_isbn13"] as? String {
          if bISBN == bookISBN {
            indexToDelete = i
          }
        }
      }

      books.remove(at: indexToDelete)

      UserDefaults.standard.set(books, forKey: "books")
    }
  }
}
