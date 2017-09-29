public protocol ValidationModeValidatable {
    func isValid(inValidationMode mode: ValidationMode) -> Bool
}
