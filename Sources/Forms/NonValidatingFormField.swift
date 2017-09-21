import Node

public struct NonValidatingFormField<Value: NodeRepresentable> {
    public let key: String
    public let label: String?
    public let value: Value?
    
    public init(
        key: String,
        label: String? = nil,
        value: Value? = nil
    ) {
        self.key = key
        self.label = label
        self.value = value
    }
}

// MARK: FieldsetEntryRepresentable

extension NonValidatingFormField: FieldsetEntryRepresentable {
    public var node: NodeRepresentable? {
        return value
    }
    
    public var errorReasons: [String] {
        return []
    }
}
