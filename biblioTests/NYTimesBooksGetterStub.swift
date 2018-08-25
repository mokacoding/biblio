@testable import biblio

class NYTimesBooksGetterStub: NYTimesBooksGetter {

  private let result: Result<[NYTimesBook]>

  init(books: [NYTimesBook]) {
    self.result = Result(value: books)
  }

  init(error: Error) {
    self.result = Result(error: error)
  }

  func getBooks(completion: @escaping ((Result<[NYTimesBook]>) -> Void)) {
    completion(result)
  }

  static func returningBooks() -> NYTimesBooksGetter {
    return NYTimesBooksGetterStub(books: books)
  }
}

private let books = [
  NYTimesBook(
    title: NYTimesBooksStubs.firstBookFromJSONTitle,
    description: NYTimesBooksStubs.firstBookFromJSONDescription,
    isbn: "9780062872746"
  ),
  NYTimesBook(
    title: NYTimesBooksStubs.secondBookFromJSONTitle,
    description: NYTimesBooksStubs.secondBookFromJSONDescription,
    isbn: "9780062872747"
  ),
]
