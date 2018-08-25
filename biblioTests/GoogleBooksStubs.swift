import OHHTTPStubs

class GoogleBooksStubs {

  private static let jsonName = "google_books_response"

  private static let booksHost = "www.googleapis.com"

  private static let imagesHost = "books.google.com"

  static let fixtureData: Data = {
    let bundle = Bundle(for: GoogleBooksStubs.self)
    let url = bundle.url(forResource: jsonName, withExtension: "json")!
    return try! Data(contentsOf: url)
  }()

  static let fixtureJSON =
    try! JSONSerialization.jsonObject(with: fixtureData, options: []) as! [String: Any]

  static func stubBooksRequestWithSuccess() {
    stub(condition: isHost("www.googleapis.com")) { _ in
      return fixture(
        filePath: OHPathForFile("\(jsonName).json", GoogleBooksStubs.self)!,
        headers: ["Content-Type":"application/json"]
      )
    }
  }

  static func stubBooksRequestWithSuccessWithNoImages() {
    stub(condition: isHost(booksHost)) { _ in
      return fixture(
        filePath: OHPathForFile("google_books_response_no_images.json", GoogleBooksStubs.self)!,
        headers: ["Content-Type":"application/json"]
      )
    }
  }

  static func stubBooksRequestWithFailure(_ error: Error = NSError(domain: "test", code: 1, userInfo: .none)) {
    stub(condition: isHost(booksHost)) { _ in
      return OHHTTPStubsResponse(error: error)
    }
  }

  static func stubImageRequestWithSuccess() {
    stub(condition: isHost(imagesHost)) { _ in
      return fixture(
        filePath: OHPathForFile("image.jpeg", GoogleBooksStubs.self)!,
        headers: .none
      )
    }
  }

  static func stubImageRequestWithFailure() {
    stub(condition: isHost(imagesHost)) { _ in
      return OHHTTPStubsResponse(error: NSError(domain: "test", code: 2, userInfo: .none))
    }
  }
}
