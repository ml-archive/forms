import Vapor

extension Request {
    public func createForm<T: Form>() throws -> T where T: JSONInitializable {
        let json = self.json ??
            formURLEncoded.map(JSON.init) ??
            JSON()
        return try T.init(json: json)
    }
}
