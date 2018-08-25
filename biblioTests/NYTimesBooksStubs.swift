import OHHTTPStubs

class NYTimesBooksStubs {

  private static let jsonName = "nytimes_response"

  private static let booksHost = "api.nytimes.com"

  static let fixtureData: Data = {
    let bundle = Bundle(for: NYTimesBooksStubs.self)
    let url = bundle.url(forResource: jsonName, withExtension: "json")!
    return try! Data(contentsOf: url)
  }()

  static let fullResponseFromFixture: [String: Any] = {
    return try! JSONSerialization.jsonObject(with: fixtureData, options: []) as! [String: Any]
  }()

  static let jsonFromFixture: [[String: Any]] = {
    return fullResponseFromFixture["results"] as! [[String: Any]]
  }()

  static let bookDataFromJSONFixture: Data = {
    return try! JSONSerialization.data(withJSONObject: jsonFromFixture.first!, options: [])
  }()

  static let firstBookFromJSONTitle = "THE RUSSIA HOAX"

  static let firstBookFromJSONDescription = """
The Fox News analyst makes his case for why the F.B.I. investigation into collusion between the Trump campaign and Russia is without legal merit.
"""

  static let secondBookFromJSONTitle = "LIARS, LEAKERS AND LIBERALS"

  static let secondBookFromJSONDescription = """
The legal analyst and Fox News host argues in favor of President Trump.
"""

  static func stubNYTimesRequestWithSuccess() {
    stub(condition: isHost(booksHost)) { _ in
      return fixture(
        filePath: OHPathForFile("\(jsonName).json", NYTimesBooksStubs.self)!,
        headers: ["Content-Type":"application/json"]
      )
    }
  }

  static func stubNYTimesRequestWithFailure(_ error: Error = NSError(domain: "test", code: 1, userInfo: .none)) {
    stub(condition: isHost(booksHost)) { _ in
      return OHHTTPStubsResponse(error: error)
    }
  }
}
