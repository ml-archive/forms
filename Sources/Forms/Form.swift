import Node

/// Types conforming to this protocol can be represented as a fieldset
public protocol Form: FieldsetRepresentable, ValidationModeValidatable {
    var fields: [FieldsetEntryRepresentable & ValidationModeValidatable] { get }
}

// MARK: NodeRepresentable

extension Form {

    /// Creates a fieldset for use in an HTML form
    public func makeNode(in context: Context? = nil) throws -> Node {
        return try fields
            .map { $0.makeFieldsetEntry() }
            .makeFieldset(in: context)
    }
}

// MARK: ValidationModeValidatable

extension Form {

    /// Returns false if any of the FieldsetEntries is invalid; true otherwise
    public func isValid(inValidationMode mode: ValidationMode) -> Bool {
        guard mode != .none else { return true }

        for field in fields {
            if !field.isValid(inValidationMode: mode) {
                return false
            }
        }

        return true
    }

    /// Validates each field according to the validation mode.
    /// Throws on first invalid field.
    public func validate(inValidationMode mode: ValidationMode) throws {
        guard mode != .none else { return }

        try fields.forEach { try $0.validate(inValidationMode: mode) }
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
