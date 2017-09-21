import HTTP
import Node
import Vapor

extension ViewData {
    public init(
        fieldset: Node? = nil,
        request: Request? = nil,
        other: ViewDataRepresentable? = nil
    ) throws {
        var viewData = try other?.makeViewData() ?? ViewData([:])
        if let request = request {
            viewData["request"] = ViewData(try request.makeNode(in: nil))
        }
        if let fieldset = fieldset {
            viewData["fieldset"] = ViewData(fieldset)
        }
        self = viewData
    }
    
    public init(
        fieldset: Node? = nil,
        request: Request? = nil,
        node: NodeRepresentable
    ) throws {
        try self.init(
            fieldset: fieldset,
            request: request,
            other: ViewData(node.makeNode(in: nil))
        )
    }
}
