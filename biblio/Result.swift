enum Result<T> {
  case success(T)
  case failure(Error)

  init(value: T) {
    self = .success(value)
  }

  init(error: Error) {
    self = .failure(error)
  }
}
