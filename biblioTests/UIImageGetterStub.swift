@testable import biblio
import UIKit

class UIImageGetterStub: UIImageGetter {

  private let image: UIImage?

  init(image: UIImage? = UIImageGetterStub.defaultImage) {
    self.image = image
  }

  func image(for url: URL, completion: (UIImage?) -> ()) {
    completion(image)
  }

  private static let defaultImage = UIImage(named: "image.jpeg", in: Bundle(for: UIImageGetterStub.self), compatibleWith: .none)!
}
