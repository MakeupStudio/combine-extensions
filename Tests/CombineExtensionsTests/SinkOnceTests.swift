import XCTest
@testable import CombineExtensions
import AppKit

final class DiscardableSinkTests: XCTestCase {
  func testSinkOnce1() {
    let subject = PublishSubject<Int, Never>()
    var value = 0
    
    subject
      .sinkOnce(onValue: {
        value = $0
      })
    
    subject.send(1)
    
    XCTAssertEqual(value, 1)
    
    subject.send(2)
    
    XCTAssertEqual(value, 1)
  }
  
  func testSinkOnce2() {
    let subject = PublishSubject<Int, Never>()
    var value = 0
    
    let cancellable = subject
      .sinkOnce(onValue: {
        value = $0
      })
    
    subject.send(1)
    
    XCTAssertEqual(value, 1)
    
    subject.send(2)
    
    XCTAssertEqual(value, 1)
    
    cancellable.cancel()
  }
  
  func testSinkOnce3() {
    let subject = PublishSubject<Int, Never>()
    var value = 0
    
    subject
      .sinkOnce(onValue: {
        value = $0
      })
      .cancel()
    
    subject.send(1)
    
    XCTAssertEqual(value, 0)
  }
}
