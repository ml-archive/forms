import Node

public protocol FieldsetRepresentable {
    func makeFieldset(in: Context?) throws -> Node
}
