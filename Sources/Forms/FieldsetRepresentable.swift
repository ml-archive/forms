import Node

public protocol FieldsetRepresentable: NodeRepresentable {}

extension FieldsetRepresentable {
    public func makeFieldset(
        withValidation shouldValidate: Bool = true
    ) throws -> Node {
        let context = ValidationContext(shouldValidate: shouldValidate)
        return try makeNode(in: context)
    }
}
