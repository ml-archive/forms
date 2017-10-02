enum OptionalValidatorError {
    case nilValue
}

// MARK: FormFieldValidationError

extension OptionalValidatorError: FormFieldValidationError {
    var errorReasons: [String] {
        return ["Value should not be empty."]
    }
}
