import Node
import Validation

/// Represents a field for an HTML form
public struct FormField<Input: Validatable> where Input: NodeRepresentable {
    public let key: String
    public let label: String?
    public let value: Input?
    public let validate: (Input?) throws -> Void

    public init(
        key: String,
        label: String? = nil,
        value: Input? = nil,
        validate: @escaping (Input?) throws -> Void
    ) {
        self.key = key
        self.label = label
        self.value = value
        self.validate = validate
    }
}

extension FormField {
    public init<V: Validator>(
        key: String,
        label: String? = nil,
        value: Input? = nil,
        validator: V
    ) where V.Input == Optional<Input> {
        self.init(
            key: key,
            label: label,
            value: value,
            validate: validator.validate
        )
    }
}

// MARK: FieldsetEntryRepresentable

extension FormField: FieldsetEntryRepresentable {
    public var node: NodeRepresentable? {
        return value
    }
    
    public var errorReasons: [String] {
        do {
            try validate(value)
            return []
        } catch let error as FormFieldValidationError {
            return error.errorReasons
        } catch {
            return ["An unknown error occurred during validation."]
        }
    }
}
