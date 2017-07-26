import Node
import Validation

/// Represents a field for an HTML form
public struct FormField<V: Validator, Output> where V.Input: NodeRepresentable {
    public let label: String?
    public let inputValue: V.Input?
    public let validator: V?
    public let isOptional: Bool

    public typealias Transform = (V.Input) -> Output?

    fileprivate let transform: Transform

    public init(
        label: String? = nil,
        value: V.Input? = nil,
        validator: V? = nil,
        isOptional: Bool = false,
        transform: @escaping Transform
    ) {
        self.label = label
        self.inputValue = value
        self.validator = validator
        self.isOptional = isOptional
        self.transform = transform
    }
}

// MARK: FormField Extensions

extension FormField where V.Input == Output {
    public init(
        label: String? = nil,
        value: V.Input? = nil,
        validator: V? = nil,
        isOptional: Bool = false
    ) {
        self.init(
            label: label,
            value: value,
            validator: validator,
            isOptional: isOptional,
            transform: { $0 }
        )
    }
}

extension FormField {
    public var outputValue: Output? {
        return inputValue.flatMap(transform)
    }

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
            isOptional: isOptional,
            transform: transform
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
