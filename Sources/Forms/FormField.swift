import Node
import Validation

/// Represents a field for an HTML form
public struct FormField<V: Validator> where V.Input: NodeRepresentable {
    public let key: String
    public let label: String?
    public let value: V.Input?
    public let validator: V
    public let isOptional: Bool

    public init(
        key: String,
        label: String? = nil,
        value: V.Input? = nil,
        validator: V,
        isOptional: Bool = false
    ) {
        self.key = key
        self.label = label
        self.value = value
        self.validator = validator
        self.isOptional = isOptional
    }
}

// MARK: FieldSetEntryRepresentable

extension FormField: FieldSetEntryRepresentable {
    public var node: NodeRepresentable? {
        return value
    }
    
    public var errorReasons: [String] {
        do {
            if let value = value {
                try validator.validate(value)
            } else if value == nil, !isOptional {
                let label = self.label ?? "Value"
                return ["\(label) cannot be empty."]
            }
            return []
        } catch let error as FormFieldValidationError {
            return error.errorReasons
        } catch {
            return ["An unknown error occurred during validation."]
        }
    }
}
