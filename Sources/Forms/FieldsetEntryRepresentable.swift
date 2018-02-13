import Node

public protocol FieldsetEntryRepresentable {
    var key: String? { get }
    var label: String? { get }
    var node: NodeRepresentable? { get }
    var errorReasons: [String] { get }
}

extension FieldsetEntryRepresentable {

    /// Creates FieldsetEntry value from FormField with given key
    public func makeFieldsetEntry() -> FieldsetEntry? {
        guard let key = key else {
            return nil
        }

        return FieldsetEntry(
            key: key,
            label: label,
            value: node,
            errors: errorReasons
        )
    }
}
