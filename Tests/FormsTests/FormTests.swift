import Forms
import JSON
import Validation
import XCTest

class FormTests: TestCase {
    func testThatMakeFieldsetIncludesAllValues() throws {
        let userForm = UserForm(name: "Andy Weir", birthyear: 1972)
        let fieldset = try userForm.makeFieldset(inValidationMode: .all)
        XCTAssertTrue(userForm.isValid(inValidationMode: .all))
        XCTAssertEqual(
            fieldset,
            ["name": [
                "label": "Name",
                "value": "Andy Weir"
                ],
             "birthyear": [
                "label": "Year of birth",
                "value": 1972
                ]
            ]
        )
    }

    func testThatMakeFieldsetIncludesAllValuesAndErrors() throws {
        let userForm = UserForm(name: "A name that is too long", birthyear: 1879)
        let fieldset = try userForm.makeFieldset(inValidationMode: .all)

        XCTAssertFalse(userForm.isValid(inValidationMode: .all))
        XCTAssertEqual(
            fieldset,
            ["name": [
                "label": "Name",
                "value": "A name that is too long",
                "errors": ["Too long"]
                ],
             "birthyear": [
                "label": "Year of birth",
                "value": 1879,
                "errors": ["Too old"]
                ]
            ]
        )
    }
}

// Mark: Helper

struct UserForm {
    let name: FormField<String>
    let birthyear: FormField<Int>

    init(name: String? = nil, birthyear: Int? = nil) {
        self.name = FormField(
            key: "name",
            label: "Name",
            value: name) {
                if let count = $0?.count, count > 10 {
                    throw "Too long"
                }
        }
        self.birthyear = FormField(
            key: "birthyear",
            label: "Year of birth",
            value: birthyear) {
                if let year = $0, year < 1900 {
                    throw "Too old"
                }
        }
    }
}

extension UserForm: Form {
    var fields: [FieldsetEntryRepresentable & ValidationModeValidatable] {
        return [name, birthyear]
    }
}
