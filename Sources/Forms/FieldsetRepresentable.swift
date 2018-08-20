import Node

public protocol FieldsetRepresentable {
    func makeFieldset(inValidationMode mode: ValidationMode) throws -> Node
}
