import Forms
import XCTest

class NonValidatingFormFieldTests: TestCase {
    func testThatAllValuesCanBeEmpty() {
        let formField = NonValidatingFormField<String>(
            key: ""
        )
        
        let fieldSetEntry = formField.makeFieldSetEntry()
        
        XCTAssertNil(fieldSetEntry.label)
        XCTAssertNil(fieldSetEntry.value)
        XCTAssertEqual(fieldSetEntry.errors.count, 0)
    }
    
    func testThatAllValuesCanBeSet() throws {
        let formField = NonValidatingFormField(
            key: "key",
            label: "Label",
            value: "value"
        )
        
        let fieldSetEntry = formField.makeFieldSetEntry()
        
        XCTAssertEqual(fieldSetEntry.key, "key")
        
        let value = try fieldSetEntry.value?.makeNode(in: nil)
        
        XCTAssertEqual(fieldSetEntry.label, "Label")
        XCTAssertEqual(value, .string("value"))
        XCTAssertEqual(fieldSetEntry.errors.count, 0)
    }
}
