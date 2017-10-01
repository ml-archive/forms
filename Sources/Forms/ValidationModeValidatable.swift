public protocol ValidationModeValidatable {
    func validate(inValidationMode mode: ValidationMode) throws
}

extension ValidationModeValidatable {
    public func isValid(inValidationMode mode: ValidationMode) -> Bool {
        do {
            try validate(inValidationMode: mode)
            return true
        } catch {
            return false
        }
    }
}
