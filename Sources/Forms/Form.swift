import Node

public protocol FieldsetRepresentable {
    func makeFieldset(in: Context?) throws -> Node
}

/// Types conforming to this protocol can be represented as a Fieldset
public protocol Form: FieldsetRepresentable {
    var fields: [FieldsetEntryRepresentable] { get }
}

extension Form {

    /// Creates a fieldset for use in an HTML form
    public func makeFieldset(in context: Context? = nil) throws -> Node {
        return try fieldsetEntries.makeFieldset(in: context)
    }

    /// Returns false if any of the FieldsetEntries is invalid; valid otherwise
    public var isValid: Bool {
        for entry in fieldsetEntries {
            if !entry.isValid {
                return false
            }
        }
        return true
    }
    
    private var fieldsetEntries: [FieldsetEntry] {
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
