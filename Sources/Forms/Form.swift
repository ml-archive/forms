import Node

public protocol FieldSetRepresentable {
    func makeFieldSet(in: Context?) throws -> Node
}

/// Types conforming to this protocol can be represented as a Field Set
public protocol Form: FieldSetRepresentable {
    var fields: [FieldSetEntryRepresentable] { get }
}

extension Form {

    /// Creates a fieldSet for use in an HTML form
    public func makeFieldSet(in context: Context? = nil) throws -> Node {
        return try fieldSetEntries.makeFieldSet(in: context)
    }

    /// Returns false if any of the FieldSetEntries is invalid; valid otherwise
    public var isValid: Bool {
        for entry in fieldSetEntries {
            if !entry.isValid {
                return false
            }
        }
        return true
    }
    
    private var fieldSetEntries: [FieldSetEntry] {
        return fields.map { $0.makeFieldSetEntry() }
    }
}

// MARK: Sequence extension

extension Sequence where Iterator.Element == FieldSetEntry {
    fileprivate func makeFieldSet(in context: Context?) throws -> Node {
        var node = Node([:])
        for entry in self {
            node[entry.key] = try entry.makeNode(in: context)
        }
        return node
    }
}
