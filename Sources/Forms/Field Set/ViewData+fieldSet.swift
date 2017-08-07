import HTTP
import Node
import Vapor

extension ViewData {
    public init(
        fieldSet: Node? = nil,
        request: Request? = nil,
        other: ViewDataRepresentable? = nil
    ) throws {
        var viewData = try other?.makeViewData() ?? ViewData()
        if let request = request {
            viewData["request"] = ViewData(try request.makeNode(in: nil))
        }
        if let fieldSet = fieldSet {
            viewData["fieldSet"] = ViewData(fieldSet)
        }
        self = viewData
    }
}
