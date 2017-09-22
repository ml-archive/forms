import Node

public protocol FieldsetEntryRepresentable {
    var key: String { get }
    var label: String? { get }
    var node: NodeRepresentable? { get }
    var errorReasons: [String] { get }
}

extension FieldsetEntryRepresentable {
    
    /// Creates FieldsetEntry value from FormField with given key
    public func makeFieldsetEntry(
        ignoreEmptyFields: Bool = false
    ) -> FieldsetEntry {
        let errors: [String]
        if node == nil && ignoreEmptyFields {
            errors = []
        } else {
            errors = errorReasons
        }

        return FieldsetEntry(
            key: key,
            label: label,
            value: node,
            errors: errors
        )
    }
}
