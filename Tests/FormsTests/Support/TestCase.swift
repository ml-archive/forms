import Testing
import XCTest

//sourcery:excludeFromLinuxMain
class TestCase: XCTestCase {
    override func setUp() {
        Testing.onFail = XCTFail
    }
}
