import Vapor

extension Request {
    public func createForm<T: Form>() throws -> T where T: JSONInitializable {
        guard let json = self.json else {
            throw Abort.badRequest
        }
        return try T.init(json: json)
    }
}
