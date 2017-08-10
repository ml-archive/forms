import Forms
import JSON
import Validation
import XCTest

class FormTests: TestCase {
    func testThatMakeFieldSetIncludesAllValues() throws {
        let userForm = UserForm(name: "Andy Weir", birthyear: 1972)
        let fieldSet = try userForm.makeFieldSet()
        XCTAssertTrue(userForm.isValid)
        XCTAssertEqual(
            fieldSet,
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

    func testThatMakeFieldSetIncludesAllValuesAndErrors() throws {
        let userForm = UserForm(name: "A name that is too long", birthyear: 1879)
        let fieldSet = try userForm.makeFieldSet()
        XCTAssertFalse(userForm.isValid)
        XCTAssertEqual(
            fieldSet,
            ["name": [
                "label": "Name",
                "value": "A name that is too long",
                "errors": ["A name that is too long count 23 is not contained in 1...10"]
                ],
             "birthyear": [
                "label": "Year of birth",
                "value": 1879,
                "errors": ["1879 is not not contained in 1900...2017"]
                ]
            ]
        )
    }
}

// Mark: Helper

struct UserForm {
    let name: FormField<Count<String>>
    let birthyear: FormField<Compare<Int>>

    init(name: String? = nil, birthyear: Int? = nil) {
        self.name = FormField(
            key: "name",
            label: "Name",
            value: name,
            validator: .containedIn(low: 1, high: 10)
        )
        self.birthyear = FormField(
            key: "birthyear",
            label: "Year of birth",
            value: birthyear,
            validator: .containedIn(low: 1900, high: 2017)
        )
    }
}

extension UserForm: Form {
    var fields: [FieldSetEntryRepresentable] {
        return [name, birthyear]
    }
}
