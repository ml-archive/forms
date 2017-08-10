import Forms
import Node
import Validation
import XCTest

class FormFieldTests: TestCase {
    func testThatAllValuesCanBeEmpty() {
        let formField = FormField(
            key: "",
            validator: TestValidator<String>(),
            isOptional: true
        )

        let fieldSetEntry = formField.makeFieldSetEntry()

        XCTAssertNil(fieldSetEntry.label)
        XCTAssertNil(fieldSetEntry.value)
        XCTAssertEqual(fieldSetEntry.errors.count, 0)
    }

    func testThatAllValuesCanBeSet() throws {
        let formField = FormField(
            key: "",
            label: "Label",
            value: "value",
            validator: TestValidator<String>()
        )

        let fieldSetEntry = formField.makeFieldSetEntry()
        let value = try fieldSetEntry.value?.makeNode(in: nil)

        XCTAssertEqual(fieldSetEntry.label, "Label")
        XCTAssertEqual(value, .string("value"))
        XCTAssertEqual(fieldSetEntry.errors.count, 0)
    }

    func testThatFieldSetFromFormFieldWithValueWithOneErrorSetsError() {
        let validator = TestValidator<String>(errorReasons: ["Invalid"])

        let formField = FormField(
            key: "",
            value: "value",
            validator: validator
        )

        let fieldSetEntry = formField.makeFieldSetEntry()

        XCTAssertEqual(fieldSetEntry.errors, ["Invalid"])
    }

    func testThatFieldSetFromFormFieldWithValueWithTwoErrorsSetsErrors() {
        let validator = TestValidator<String>(
            errorReasons: ["Invalid", "Invalid again"]
        )

        let formField = FormField(
            key: "",
            value: "value",
            validator: validator
        )

        let fieldSetEntry = formField.makeFieldSetEntry()

        XCTAssertEqual(fieldSetEntry.errors, ["Invalid", "Invalid again"])
    }

    func testThatNonValidatorErrorsAreDisplayedWithGenericErrorMessage() {
        let validator = TestValidator<String>(
            error: NSError(domain: "", code: 0)
        )

        let formField = FormField(
            key: "",
            value: "value",
            validator: validator
        )

        let fieldSetEntry = formField.makeFieldSetEntry()

        XCTAssertEqual(
            fieldSetEntry.errors,
            ["An unknown error occurred during validation."])
    }


    func testThatNonOptionalFormFieldWithoutLabelOrValueProducesGenericError() {
        let validator = TestValidator<String>()
        let formField = FormField(key: "", validator: validator)
        let fieldSetEntry = formField.makeFieldSetEntry()
        XCTAssertEqual(
            fieldSetEntry.errors,
            ["Value cannot be empty."]
        )
    }

    func testThatNonOptionalFormFieldWithLabelAndNoValueProducesErrorWithLabelInMessage() {
        let validator = TestValidator<String>()
        let formField = FormField<TestValidator<String>>(
            key: "",
            label: "Name",
            validator: validator
        )
        let fieldSetEntry = formField.makeFieldSetEntry()
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
