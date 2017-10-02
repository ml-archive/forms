import Node

/// Value representing an entry for a fieldset
public struct FieldsetEntry {
    public let key: String
    public let label: String?
    public let value: NodeRepresentable?
    public let errors: [String]

    public init(
        key: String,
        label: String? = nil,
        value: NodeRepresentable? = nil,
        errors: [String] = []
    ) {
        self.key = key
        self.label = label
        self.value = value
        self.errors = errors
    }
}

// MARK: NodeRepresentable

extension FieldsetEntry: NodeRepresentable {
    public func makeNode(in context: Context?) throws -> Node {
        var node = Node([:])

        if let label = label {
            node["label"] = .string(label)
        }

        if let value = value {
            node["value"] = try value.makeNode(in: context)
        }

        if shouldIncludeErrors(in: context) {
            node["errors"] = .array(errors.map { Node.string($0) })
        }

        return node
    }

    private func shouldIncludeErrors(in context: Context?) -> Bool {
        guard
            errors.count > 0,
            let mode = (context as? ValidationContext)?.mode,
            mode != .none,
            value != nil || mode == .all
        else {
            return false
        }

        return true
    }
}
