import Validation

/// Validator that handles optional input and forwards validation in case of
/// of non-nil input.
public struct OptionalValidator<Input> {
    public let isOptional: Bool
    public let validate: (Input) throws -> Void
    public let errorOnNil: FormFieldValidationError

    public init(
        isOptional: Bool = false,
        errorOnNil: FormFieldValidationError = OptionalValidatorError.nilValue,
        validate: @escaping (Input) throws -> Void = { _ in }
    ) {
        self.isOptional = isOptional
        self.errorOnNil = errorOnNil
        self.validate = validate
    }
}

extension OptionalValidator {
    public init<V: Validator>(
        isOptional: Bool = false,
        errorOnNil: FormFieldValidationError = OptionalValidatorError.nilValue,
        validator: V
    ) where V.Input == Input {
        self.init(
            isOptional: isOptional,
            errorOnNil: errorOnNil,
            validate: validator.validate
        )
    }
}

extension OptionalValidator: Validator {
    public func validate(_ input: Input?) throws {
        if let input = input {
            try validate(input)
        } else if !isOptional {
            throw errorOnNil
        }
    }
}

extension Optional: Validatable {}
