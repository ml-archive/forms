public protocol ValidationModeValidatable {
    func isValid(inValidationMode mode: ValidationMode) -> Bool
    func validate(inValidationMode mode: ValidationMode) throws
}
