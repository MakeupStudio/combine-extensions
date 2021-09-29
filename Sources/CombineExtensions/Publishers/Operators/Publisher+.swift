#if canImport(Combine)
  import Combine

  @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
  extension Publisher {
    @inlinable
    public func combinePrevious() -> AnyPublisher<(prev: Output?, next: Output), Failure> {
      scan(Optional<(Output?, Output)>.none) { ($0?.1, $1) }
        .compactMap { $0 }
        .eraseToAnyPublisher()
    }

    @inlinable
    public func combinePrevious(
      initialValue: Output
    ) -> AnyPublisher<(prev: Output, next: Output), Failure> {
      var previous: Output = initialValue
      return self.map { input in
        let output = (previous, input)
        previous = input
        return output
      }.eraseToAnyPublisher()
    }

    @inlinable
    public func eraseError() -> AnyPublisher<Output, Error> {
      self.mapError { $0 as Error }.eraseToAnyPublisher()
    }

    @inlinable
    public func replaceError(with transform: @escaping (Failure) -> Output) -> AnyPublisher<
      Output, Never
    > {
      self.catch { Just(transform($0)) }.eraseToAnyPublisher()
    }

    @inlinable
    public func ignoreError() -> AnyPublisher<Output, Never> {
      self.catch { _ in Empty() }.eraseToAnyPublisher()
    }

    @inlinable
    public func discardOutput<T>() -> AnyPublisher<T, Failure> {
      self.flatMap { _ in Empty<T, Failure>() }.eraseToAnyPublisher()
    }

    @inlinable
    public func replaceOutput<T>(with value: T) -> AnyPublisher<T, Failure> {
      self.map { _ in value }.eraseToAnyPublisher()
    }
  }
#endif
