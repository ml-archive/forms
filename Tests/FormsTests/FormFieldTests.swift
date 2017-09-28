import Forms
import Node
import Validation
import XCTest

class FormFieldTests: TestCase {
    let testValidator = TestValidator<String?>()
    
    func testThatAllValuesCanBeEmpty() {
        let formField = FormField(
            key: "",
            validator: testValidator
        )

        let fieldsetEntry = formField.makeFieldsetEntry()

        XCTAssertNil(fieldsetEntry.label)
        XCTAssertNil(fieldsetEntry.value)
        XCTAssertEqual(fieldsetEntry.errors.count, 0)
    }

    func testThatAllValuesCanBeSet() throws {
        let formField = FormField(
            key: "key",
            label: "Label",
            value: "value",
            validator: testValidator
        )

        let fieldsetEntry = formField.makeFieldsetEntry()
        
        XCTAssertEqual(fieldsetEntry.key, "key")
        
        let value = try fieldsetEntry.value?.makeNode(in: nil)

        XCTAssertEqual(fieldsetEntry.label, "Label")
        XCTAssertEqual(value, .string("value"))
        XCTAssertEqual(fieldsetEntry.errors.count, 0)
    }

    func testThatFieldsetFromFormFieldWithValueWithOneErrorSetsError() {
        let validator = TestValidator<String?>(errorReasons: ["Invalid"])

        let formField = FormField(
            key: "",
            value: "value",
            validator: validator
        )

        let fieldsetEntry = formField.makeFieldsetEntry()

        XCTAssertEqual(fieldsetEntry.errors, ["Invalid"])
    }

    func testThatFieldsetFromFormFieldWithValueWithTwoErrorsSetsErrors() {
        let validator = TestValidator<String?>(
            errorReasons: ["Invalid", "Invalid again"]
        )

        let formField = FormField(
            key: "",
            value: "value",
            validator: validator
        )

        let fieldsetEntry = formField.makeFieldsetEntry()

        XCTAssertEqual(fieldsetEntry.errors, ["Invalid", "Invalid again"])
    }

    func testThatNonValidatorErrorsAreDisplayedWithGenericErrorMessage() {
        let validator = TestValidator<String?>(
            error: NSError(domain: "", code: 0)
        )

        let formField = FormField(
            key: "",
            value: "value",
            validator: validator
        )

        let fieldsetEntry = formField.makeFieldsetEntry()

        XCTAssertEqual(
            fieldsetEntry.errors,
            ["An unknown error occurred during validation."])
    }
}

// MARK: Helper

class TestValidator<T: Validatable>: Validator {
    let errorReasons: [String]
    let error: Error?

    init(errorReasons: [String] = []) {
        self.error = nil
        self.errorReasons = errorReasons
    }

    init(error: Error) {
        self.error = error
        self.errorReasons = []
    }

    func validate(_: T) throws {
        if let error = error {
            throw error
        }

        if errorReasons.count == 1, let errorReason = errorReasons.first {
            throw self.error(errorReason)
        }

        if errorReasons.count > 1 {
            let errors = errorReasons.map(self.error)
            throw ErrorList(errors)
        }
    }
}
