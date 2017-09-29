import Node

/// Types conforming to this protocol can be represented as a fieldset
public protocol Form: FieldsetRepresentable, ValidationModeValidatable {
    var fields: [FieldsetEntryRepresentable] { get }
}

// MARK: NodeRepresentable

extension Form {

    /// Creates a fieldset for use in an HTML form
    public func makeNode(in context: Context? = nil) throws -> Node {
        return try fieldsetEntries.makeFieldset(in: context)
    }
}

// MARK: ValidationModeValidatable

extension Form {

    /// Returns false if any of the FieldsetEntries is invalid; true otherwise
    public func isValid(inValidationMode mode: ValidationMode) -> Bool {
        for entry in fieldsetEntries {
            if !entry.isValid(inValidationMode: mode) {
                return false
            }
        }
        return true
    }
}

// MARK: Helper

extension Form {
    fileprivate var fieldsetEntries: [FieldsetEntry] {
        return fields.map { $0.makeFieldsetEntry() }
    }
}

// MARK: Sequence extension

extension Sequence where Iterator.Element == FieldsetEntry {
    fileprivate func makeFieldset(in context: Context?) throws -> Node {
        var node = Node([:])
        for entry in self {
            node[entry.key] = try entry.makeNode(in: context)
        }
        return node
    }
}
