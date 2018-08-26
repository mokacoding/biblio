@testable import biblio
import XCTest

class URLSession_GoogleBookGetterTests: XCTestCase {

  func test_when_request_fails_calls_completion_with_received_error() {
    let error = NSError(domain: "test", code: 1, userInfo: .none)
    GoogleBooksStubs.stubBooksRequestWithFailure(error)

    let session = URLSession(configuration: .default)

    let e = expectation(description: #function)

    session.getGoogleBook(isbn: "1234") { result in
      switch result {
      case .failure(let receivedError):
        XCTAssertEqual(receivedError as NSError, error)
      case .success(let book):
        XCTFail("Expected to fail, succeeded with \(book)")
      }

      e.fulfill()
    }

    waitForExpectations(timeout: 0.1, handler: .none)
  }

  func test_when_request_succeeds_calls_completion_with_received_dictionary() {
    GoogleBooksStubs.stubBooksRequestWithSuccess()

    let session = URLSession(configuration: .default)

    let e = expectation(description: #function)

    session.getGoogleBook(isbn: "1234") { result in
      switch result {
      case .failure(let error):
        XCTFail("Expected to succeed, failed with \(error)")
      case .success(let book):
        XCTAssertEqual(book["kind"] as? String, "books#volumes")
      }

      e.fulfill()
    }

    waitForExpectations(timeout: 0.1, handler: .none)
  }
}
