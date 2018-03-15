import Node

public typealias FieldType = FieldsetEntryRepresentable &
    ValidationModeValidatable

/// Types conforming to this protocol can be represented as a fieldset
public protocol Form: ValidationModeValidatable {
    var fields: [FieldType] { get }
}

extension Form {
    public func makeFieldset(
        inValidationMode mode: ValidationMode
    ) throws -> Node {
        return try fields
            .flatMap { $0.makeFieldsetEntry() }
            .makeFieldset(inValidationMode: mode)
    }
}

// MARK: ValidationModeValidatable

extension Sequence where Element: ValidationModeValidatable {

    /// Validates each field according to the validation mode.
    /// Throws on first invalid field.
    public func validate(inValidationMode mode: ValidationMode) throws {
        guard mode != .none else { return }

        try forEach { try $0.validate(inValidationMode: mode) }
    }
}

/// Helper for enabling batch validation of non-concrete `ValidationModeValidatable`s
private struct AnyValidatable: ValidationModeValidatable {
    let _validate: (ValidationMode) throws -> Void

    init(_ v: ValidationModeValidatable) {
        _validate = v.validate
    }

    func validate(inValidationMode mode: ValidationMode) throws {
        try _validate(mode)
    }
}

extension Form {
    public func validate(inValidationMode mode: ValidationMode) throws {
        try fields.map(AnyValidatable.init).validate(inValidationMode: mode)
    }
}

// MARK: Sequence extension

extension Sequence where Element == FieldsetEntry {
    public func makeFieldset(inValidationMode mode: ValidationMode) throws -> Node {
        var node = Node([:])
        let context = ValidationContext(mode: mode)
        for entry in self {
            node[entry.key] = try entry.makeNode(in: context)
        }
        return node
    }
}
