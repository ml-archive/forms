import Validation

/// Error types conforming to the protocol show up in FieldSetEntries when
/// thrown during validation.
public protocol FormFieldValidationError: Error {
    var errorReasons: [String] { get }
}

extension ValidatorError: FormFieldValidationError {
    public var errorReasons: [String] {
        guard case .failure(_, let reason) = self else {
            // cannot happen since ValidatorError only has this 1 case
            return []
        }

        return [reason]
    }
}

extension ErrorList: FormFieldValidationError {
    public var errorReasons: [String] {
        return errors
            .flatMap { $0 as? FormFieldValidationError }
            .flatMap { $0.errorReasons }
    }
}
