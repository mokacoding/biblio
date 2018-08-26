import Foundation

extension URLSession: GoogleBookGetter {

  func getGoogleBook(isbn: String, completion: @escaping ((Result<[String : Any]>) -> Void)) {
    guard let googleBookURL = URL(string: "https://www.googleapis.com/books/v1/volumes?q=isbn:\(isbn)&key=\(Secrets.googleBooksKey)") else {
      completion(Result(error: NSError(domain: "urlsession-google-book-getter", code: 1, userInfo: .none)))
      return
    }

    dataTask(with: googleBookURL) { data, request, error in
      if let error = error {
        completion(Result(error: error))
        return
      }

      guard let data = data else {
        completion(Result(error: NSError(domain: "urlsession-google-book-getter", code: 2, userInfo: .none)))
        return
      }

      guard
        let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) ,
        let googleBookDict = jsonObject as? [String: Any]
        else {
          completion(Result(error: NSError(domain: "urlsession-google-book-getter", code: 3, userInfo: .none)))
          return
      }

      completion(Result(value: googleBookDict))
      }.resume()
  }
}
