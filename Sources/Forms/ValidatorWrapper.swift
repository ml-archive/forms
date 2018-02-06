import Validation

/// Simple wrapper that catches any error on validate and throws provided error.
public struct ValidatorWrapper<Input: Validatable> {
    fileprivate let error: Error
    fileprivate let wrappedValidate: (Input) throws -> Void

    public init<V: Validator>(
        validator: V,
        error: Error
    ) where V.Input == Input {
        self.wrappedValidate = validator.validate
        self.error = error
    }
}

extension ValidatorWrapper: Validator {
    public func validate(_ input: Input) throws {
        do {
            try wrappedValidate(input)
        } catch {
            throw self.error
        }
    }
}
