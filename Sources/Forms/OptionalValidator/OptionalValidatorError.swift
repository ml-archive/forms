public enum OptionalValidatorError {
    case nilValue
}

// MARK: FormFieldValidationError

extension OptionalValidatorError: FormFieldValidationError {
    public var errorReasons: [String] {
        return ["Value must not be empty."]
    }
}
