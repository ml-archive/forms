import Node

public protocol FieldsetRepresentable: NodeRepresentable {}

extension FieldsetRepresentable {
    public func makeFieldset(
        inValidationMode mode: ValidationMode
    ) throws -> Node {
        return try makeNode(in: ValidationContext(mode: mode))
    }
}
