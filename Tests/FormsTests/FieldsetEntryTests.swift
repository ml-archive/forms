import Forms
import XCTest

class FieldsetEntryTests: TestCase {
    func testThatKeyGetsSet() {
        let fieldsetEntry = FieldsetEntry(key: "key")
        XCTAssertEqual(fieldsetEntry.key, "key")
    }

    func testThatEmptyFieldsetResultsInEmptyNode() throws {
        let fieldsetEntry = FieldsetEntry(key: "key")
        try XCTAssertEqual(fieldsetEntry.makeNode(in: nil), [:])
    }

    func testThatNodeContainsAllValues() throws {
        let fieldsetEntry = FieldsetEntry(
            key: "key",
            label: "label",
            value: "value",
            errors: ["error 1", "error 2"]
        )

        try XCTAssertEqual(
            fieldsetEntry.makeNode(in: ValidationContext(mode: .all)),
            ["label": "label",
             "value": "value",
             "errors": ["error 1", "error 2"]]
        )
    }

    func testThatFieldsetEntryWithoutErrorsIsValid() {
        let fieldsetEntry = FieldsetEntry(key: "")
        XCTAssertTrue(fieldsetEntry.isValid(inValidationMode: .all))
    }

    func testThatFieldsetEntryWithErrorsIsInvalid() {
        let fieldsetEntry = FieldsetEntry(key: "", errors: [""])
        XCTAssertFalse(fieldsetEntry.isValid(inValidationMode: .all))
    }
}
