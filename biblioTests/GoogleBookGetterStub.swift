@testable import biblio
import Foundation

class GoogleBookGetterStub: GoogleBookGetter {

  private let result: Result<[String: Any]>

  init(book: [String: Any]) {
    self.result = Result(value: book)
  }

  init(error: Error) {
    self.result = Result(error: error)
  }

  func getGoogleBook(isbn: String, completion: @escaping ((Result<[String: Any]>) -> Void)) {
    completion(result)
  }

  static func returningBook() -> GoogleBookGetter {
    return GoogleBookGetterStub(book: GoogleBooksStubs.fixtureJSON)
  }

  static func returningError() -> GoogleBookGetter {
    return GoogleBookGetterStub(error: NSError(domain: "google-book-getter-stub", code: 1, userInfo: .none))
  }
}

extension GoogleBooksStubs {

  static let fixtureBook: GoogleBook = GoogleBook(thumbnailURL: URL(string: "http://books.google.com/books/content?id=2ObWDgAAQBAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api")!)
}
