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
    public func isValid(inValidationMode mode: ValidationMode) -> Bool {
        guard errors.count > 0, mode != .none else {
            return true
        }

        return value == nil && mode == .nonNil
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
            let validationContext = context as? ValidationContext,
            !isValid(inValidationMode: validationContext.mode)
        {
            node["errors"] = .array(errors.map { Node.string($0) })
        }

        return node
    }
}
