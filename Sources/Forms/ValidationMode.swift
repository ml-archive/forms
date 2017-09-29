public enum ValidationMode {

    /// Ignore all error
    case none

    /// Ignore errors when value is `nil`
    case nonNil

    /// Do not ignore errors
    case all
}
