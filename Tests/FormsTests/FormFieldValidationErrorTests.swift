import Forms
import Validation
import XCTest

class FormFieldValidationErrorTests: TestCase {
    func testThatValidatorErrorConformsToFormFieldValidationError() {
        let validatorError = ValidatorError.failure(type: "", reason: "Invalid")
        XCTAssertEqual(validatorError.errorReasons, ["Invalid"])
    }

    func testThatErrorListConformsToFormFieldValidationError() {
        let errorList = ErrorList(["Error 1", "Error 2"])
        XCTAssertEqual(errorList.errorReasons, ["Error 1", "Error 2"])
    }
}

// MARK: Helper

extension String: FormFieldValidationError {
    public var errorReasons: [String] {
        return [self]
    }
}
