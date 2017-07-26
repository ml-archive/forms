import Node
import Validation

/// Represents a field for an HTML form
public struct FormField<V: Validator> where V.Input: NodeRepresentable {
    public let label: String?
    public let inputValue: V.Input?
    public let validator: V?
    public let isOptional: Bool

    public init(
        label: String? = nil,
        value: V.Input? = nil,
        validator: V? = nil,
        isOptional: Bool = false
    ) {
        self.label = label
        self.inputValue = value
        self.validator = validator
        self.isOptional = isOptional
    }
}

// MARK: FormField Extensions

extension FormField {

    /// Creates FieldSetEntry value from FormField with given key
    public func makeFieldSetEntry(withKey key: String) -> FieldSetEntry {
        return FieldSetEntry(
            key: key,
            label: label,
            value: inputValue,
            errors: errorReasons
        )
    }

    /// Returns a copy with containing the given value
    public func settingValue(to value: V.Input?) -> FormField {
        return FormField(
            label: label,
            value: value,
            validator: validator,
            isOptional: isOptional
        )
    }
}

extension FormField {
    fileprivate var errorReasons: [String] {
        do {
            if let validator = validator, let value = inputValue {
                try validator.validate(value)
            } else if inputValue == nil, !isOptional {
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
