#if canImport(Combine)
import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct NonScopedCancellable: Cancellable {
  @inlinable
  public init(_ cancellable: Cancellable) {
    self.init(cancellable.cancel)
  }
  
  public init(_ action: @escaping () -> Void) {
    self._action = action
  }
  
  private let _action: () -> Void
  
  public func cancel() { _action() }
}
#endif
