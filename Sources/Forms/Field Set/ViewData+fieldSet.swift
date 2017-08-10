import HTTP
import Node
import Vapor

extension ViewData {
    public init(
        fieldSet: Node? = nil,
        request: Request? = nil,
        other: ViewDataRepresentable? = nil
    ) throws {
        var viewData = try other?.makeViewData() ?? ViewData([:])
        if let request = request {
            viewData["request"] = ViewData(try request.makeNode(in: nil))
        }
        if let fieldSet = fieldSet {
            // the key is not camelCased for backwards compatibility
            viewData["fieldset"] = ViewData(fieldSet)
        }
        self = viewData
    }
    
    public init(
        fieldSet: Node? = nil,
        request: Request? = nil,
        node: NodeRepresentable
    ) throws {
        try self.init(
            fieldSet: fieldSet,
            request: request,
            other: ViewData(node.makeNode(in: nil))
        )
    }
}
