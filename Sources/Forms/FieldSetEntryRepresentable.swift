import Node

public protocol FieldSetEntryRepresentable {
    var key: String { get }
    var label: String? { get }
    var node: NodeRepresentable? { get }
    var errorReasons: [String] { get }
}

extension FieldSetEntryRepresentable {
    
    /// Creates FieldSetEntry value from FormField with given key
    public func makeFieldSetEntry() -> FieldSetEntry {
        return FieldSetEntry(
            key: key,
            label: label,
            value: node,
            errors: errorReasons
        )
    }
}
