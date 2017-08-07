import HTTP

public class FieldSetMiddleware: Middleware {
    public init() {}
    
    public func respond(
        to request: Request,
        chainingTo next: Responder
    ) throws -> Response {
        let session = request.session
        
        // move field set from session to request
        request.fieldSet = session?.fieldSet
        session?.fieldSet = nil
        
        let response = try next.respond(to: request)
        
        // store any new field set in the session for the next request
        session?.fieldSet = response.fieldSet
        return response
    }
}
