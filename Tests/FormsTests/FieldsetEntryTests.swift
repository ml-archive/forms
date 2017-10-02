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
}
