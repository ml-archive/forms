import Forms
import XCTest

class FieldSetEntryTests: TestCase {
    func testThatKeyGetsSet() {
        let fieldSetEntry = FieldSetEntry(key: "key")
        XCTAssertEqual(fieldSetEntry.key, "key")
    }

    func testThatEmptyFieldSetResultsInEmptyNode() throws {
        let fieldSetEntry = FieldSetEntry(key: "key")
        try XCTAssertEqual(fieldSetEntry.makeNode(in: nil), [:])
    }

    func testThatNodeContainsAllValues() throws {
        let fieldSetEntry = FieldSetEntry(
            key: "key",
            label: "label",
            value: "value",
            errors: ["error 1", "error 2"]
        )

        try XCTAssertEqual(
            fieldSetEntry.makeNode(in: nil),
            ["label": "label",
             "value": "value",
             "errors": ["error 1", "error 2"]]
        )
    }

    func testThatFieldSetEntryWithoutErrorsIsValid() {
        let fieldSetEntry = FieldSetEntry(key: "")
        XCTAssertTrue(fieldSetEntry.isValid)
    }

    func testThatFieldSetEntryWithErrorsIsInvalid() {
        let fieldSetEntry = FieldSetEntry(key: "", errors: [""])
        XCTAssertFalse(fieldSetEntry.isValid)
    }
}
