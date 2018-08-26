@testable import biblio
import OHHTTPStubs
import XCTest

class ViewControllerHighLevelTests: XCTestCase {

  override func tearDown() {
    OHHTTPStubs.removeAllStubs()
    super.tearDown()
  }

  func test_books_view_controller_loads_list() {
    let viewController = ViewController.fromStoryboard()

    NYTimesBooksStubs.stubNYTimesRequestWithSuccess()
    GoogleBooksStubs.stubBooksRequestWithSuccess()
    GoogleBooksStubs.stubImageRequestWithSuccess()

    _ = viewController.view

    _ = self.expectation(for: ViewController.moreThanOneVisibleCell(), evaluatedWith: viewController, handler: .none)

    waitForExpectations(timeout: 1, handler: .none)

    guard let firstCell = viewController.cell(atRow: 0) else {
      return XCTFail("Could not get first cell")
    }

    XCTAssertEqual(firstCell.titleLabel.text, NYTimesBooksStubs.firstBookFromJSONTitle)
    XCTAssertEqual(firstCell.descriptionLabel.text, NYTimesBooksStubs.firstBookFromJSONDescription)

    guard let secondCell = viewController.cell(atRow: 1)  else {
      return XCTFail("Could not get second cell")
    }

    XCTAssertEqual(secondCell.titleLabel.text, NYTimesBooksStubs.secondBookFromJSONTitle)
    XCTAssertEqual(secondCell.descriptionLabel.text, NYTimesBooksStubs.secondBookFromJSONDescription)

    _ = expectation(for: BookTableViewCell.imageIsLoaded(), evaluatedWith: firstCell, handler: .none)
    _ = expectation(for: BookTableViewCell.imageIsLoaded(), evaluatedWith: secondCell, handler: .none)
    waitForExpectations(timeout: 1, handler: .none)
  }

  func test_books_view_controller_loads_list_with_image_if_book_is_in_cache() {
    let viewController = ViewController.fromStoryboard(
      cache: [URL(string: "https://www.googleapis.com/books/v1/volumes?q=isbn:9780062872746&key=\(Secrets.googleBooksKey)")!: GoogleBooksStubs.fixtureJSON]
    )

    NYTimesBooksStubs.stubNYTimesRequestWithSuccess()
    GoogleBooksStubs.stubBooksRequestWithFailure()
    GoogleBooksStubs.stubImageRequestWithSuccess()

    _ = viewController.view

    _ = self.expectation(for: ViewController.moreThanOneVisibleCell(), evaluatedWith: viewController, handler: .none)

    waitForExpectations(timeout: 1, handler: .none)

    guard let firstCell = viewController.cell(atRow: 0) else {
      return XCTFail("Could not get first cell")
    }

    XCTAssertEqual(firstCell.titleLabel.text, NYTimesBooksStubs.firstBookFromJSONTitle)
    XCTAssertEqual(firstCell.descriptionLabel.text, NYTimesBooksStubs.firstBookFromJSONDescription)

    _ = expectation(for: BookTableViewCell.imageIsLoaded(), evaluatedWith: firstCell, handler: .none)
    waitForExpectations(timeout: 1, handler: .none)
  }

  func test_books_view_controller_shows_error_label_if_google_book_not_found() {
    let viewController = ViewController.fromStoryboard()

    NYTimesBooksStubs.stubNYTimesRequestWithSuccess()
    GoogleBooksStubs.stubBooksRequestWithFailure()
    // Only stub the book request with failure, the image request should not be fired
    GoogleBooksStubs.stubImageRequestWithSuccess()

    _ = viewController.view

    waitForBooksListLoaded(in: viewController)

    guard let cell = viewController.cell(atRow: 0) else {
      return XCTFail("Could not get first cell")
    }

    _ = expectation(for: BookTableViewCell.errorLabelIsShown(), evaluatedWith: cell, handler: .none)

    waitForExpectations(timeout: 1, handler: .none)
  }

  func test_books_view_controller_shows_error_label_if_google_book_found_but_with_no_image() {
    let viewController = ViewController.fromStoryboard()

    NYTimesBooksStubs.stubNYTimesRequestWithSuccess()
    GoogleBooksStubs.stubBooksRequestWithSuccessWithNoImages()
    // This is stubbed as a success, to ensure that the error will be shown because the image
    // request is not made, not because of a failed image requet.
    GoogleBooksStubs.stubImageRequestWithSuccess()

    _ = viewController.view

    _ = self.expectation(for: ViewController.moreThanOneVisibleCell(), evaluatedWith: viewController, handler: .none)

    waitForExpectations(timeout: 1, handler: .none)

    guard let cell = viewController.cell(atRow: 0) else {
      return XCTFail("Could not get first cell")
    }

    _ = expectation(for: BookTableViewCell.errorLabelIsShown(), evaluatedWith: cell, handler: .none)

    waitForExpectations(timeout: 1, handler: .none)
  }

  func test_books_view_controller_shows_error_label_if_google_book_found_but_image_cache_fails() {
    let viewController = ViewController.fromStoryboard(imageCache: UIImageGetterStub(image: .none))

    NYTimesBooksStubs.stubNYTimesRequestWithSuccess()
    GoogleBooksStubs.stubBooksRequestWithSuccess()
    // This is stubbed as a success, to ensure that the error will be shown because the image
    // request is not made, not because of a failed image requet.
    GoogleBooksStubs.stubImageRequestWithSuccess()

    _ = viewController.view

    _ = self.expectation(for: ViewController.moreThanOneVisibleCell(), evaluatedWith: viewController, handler: .none)

    waitForExpectations(timeout: 1, handler: .none)

    guard let cell = viewController.cell(atRow: 0) else {
      return XCTFail("Could not get first cell")
    }

    _ = expectation(for: BookTableViewCell.errorLabelIsShown(), evaluatedWith: cell, handler: .none)

    waitForExpectations(timeout: 1, handler: .none)
  }
}

extension ViewControllerHighLevelTests {

  private func waitForBooksListLoaded(in viewController: ViewController) {
    _ = self.expectation(for: ViewController.moreThanOneVisibleCell(), evaluatedWith: viewController, handler: .none)

    waitForExpectations(timeout: 1, handler: .none)
  }
}

