protocol GoogleBookGetter {

  func getGoogleBook(isbn: String, completion: @escaping ((Result<[String: Any]>) -> Void))
}
