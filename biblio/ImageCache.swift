import Foundation
import UIKit

protocol UIImageGetter {

  func image(for url: URL, completion: (UIImage?) -> ())
}

class ImageCache: UIImageGetter {

  static let shared = ImageCache()

  private var cache: [URL: UIImage] = [:]

  func image(for url: URL, completion: (UIImage?) -> ()) {
    if let cachedImage = cache[url] {
      completion(cachedImage)
    } else if let imageData = try? Data(contentsOf: url) {
      let image = UIImage(data: imageData)
      cache[url] = image
      completion(image)
    } else {
      completion(.none)
    }
  }
}
