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

// MARK: Validation Modes

enum TestError: FormFieldValidationError {
    case failed

    var errorReasons: [String] {
        return ["failed"]
    }
}

struct ValidationModeForm: Form {
    let fieldWithInvalidValue = FormField<String>(key: "a", value: "invalid") { _ in
        throw TestError.failed
    }
    let fieldWithNilValue = FormField<String>(key: "b") { _ in
        throw TestError.failed
    }
    let fieldWithValidValue = FormField<String>(key: "c")

    var fields: [FieldsetEntryRepresentable] {
        return [fieldWithInvalidValue, fieldWithNilValue, fieldWithValidValue]
    }
}

extension FormFieldTests {
    func testValidationModes() throws {
        let form = ValidationModeForm()

        XCTAssertTrue(form.isValid(inValidationMode: .none))
        XCTAssertFalse(form.isValid(inValidationMode: .nonNil))
        XCTAssertFalse(form.isValid(inValidationMode: .all))

        let fieldset1 = try form.makeFieldset(inValidationMode: .none)
        let fieldset2 = try form.makeFieldset(inValidationMode: .nonNil)
        let fieldset3 = try form.makeFieldset(inValidationMode: .all)

        XCTAssertNil(fieldset1["a"]?["errors"]?.array)
        XCTAssertNil(fieldset1["b"]?["errors"]?.array)
        XCTAssertNil(fieldset1["c"]?["errors"]?.array)

        XCTAssertEqual(fieldset2["a"]?["errors"]?.array?.first, "failed")
        XCTAssertNil(fieldset2["b"]?["errors"]?.array)
        XCTAssertNil(fieldset2["c"]?["errors"]?.array)

        XCTAssertEqual(fieldset3["a"]?["errors"]?.array?.first, "failed")
        XCTAssertEqual(fieldset3["b"]?["errors"]?.array?.first, "failed")
        XCTAssertNil(fieldset3["c"]?["errors"]?.array)
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
