import Forms
import Node
import Validation
import XCTest

class FormFieldTests: TestCase {
    func testThatAllValuesCanBeEmpty() {
        let formField = FormField<TestValidator<String>>(isOptional: true)

        let fieldSetEntry = formField.makeFieldSetEntry(withKey: "")

        XCTAssertNil(fieldSetEntry.label)
        XCTAssertNil(fieldSetEntry.value)
        XCTAssertEqual(fieldSetEntry.errors.count, 0)
    }

    func testThatAllValuesCanBeSet() throws {
        let formField = FormField(
            label: "Label",
            value: "value",
            validator: TestValidator<String>())

        let fieldSetEntry = formField.makeFieldSetEntry(withKey: "")

        XCTAssertEqual(fieldSetEntry.label, "Label")
        try XCTAssertEqual(fieldSetEntry.value?.makeNode(in: nil), .string("value"))
        XCTAssertEqual(fieldSetEntry.errors.count, 0)
    }

    func testThatFieldSetFromFormFieldWithValueWithOneErrorSetsError() {
        let validator = TestValidator<String>(errorReasons: ["Invalid"])

        let formField = FormField(value: "value", validator: validator)

        let fieldSetEntry = formField.makeFieldSetEntry(withKey: "")

        XCTAssertEqual(fieldSetEntry.errors, ["Invalid"])
    }

    func testThatFieldSetFromFormFieldWithValueWithTwoErrorsSetsErrors() {
        let validator = TestValidator<String>(
            errorReasons: ["Invalid", "Invalid again"]
        )

        let formField = FormField(value: "value", validator: validator)

        let fieldSetEntry = formField.makeFieldSetEntry(withKey: "")

        XCTAssertEqual(fieldSetEntry.errors, ["Invalid", "Invalid again"])
    }

    func testThatNonValidatorErrorsAreDisplayedWithGenericErrorMessage() {
        let validator = TestValidator<String>(
            error: NSError(domain: "", code: 0)
        )

        let formField = FormField(value: "value", validator: validator)

        let fieldSetEntry = formField.makeFieldSetEntry(withKey: "")

        XCTAssertEqual(
            fieldSetEntry.errors,
            ["An unknown error occurred during validation."])
    }


    func testThatNonOptionalFormFieldWithoutLabelOrValueProducesGenericError() {
        let formField = FormField<TestValidator<String>>()
        let fieldSetEntry = formField.makeFieldSetEntry(withKey: "")
        XCTAssertEqual(
            fieldSetEntry.errors,
            ["Value cannot be empty."]
        )
    }

    func testThatNonOptionalFormFieldWithLabelAndNoValueProducesErrorWithLabelInMessage() {
        let formField = FormField<TestValidator<String>>(label: "Name")
        let fieldSetEntry = formField.makeFieldSetEntry(withKey: "")
        XCTAssertEqual(
            fieldSetEntry.errors,
            ["Name cannot be empty."]
        )
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

    func validate(_ input: T) throws {
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
