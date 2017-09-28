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

extension FieldsetEntry {

    /// Returns false when the field has errors
    public var isValid: Bool {
        return errors.count == 0
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

        if
            !isValid,
            let validationContext = context as? ValidationContext,
            validationContext.shouldValidate
        {
            node["errors"] = .array(errors.map { Node.string($0) })
        }

        return node
    }
}
