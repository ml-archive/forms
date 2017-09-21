import HTTP

public class FieldsetMiddleware: Middleware {
    public init() {}
    
    public func respond(
        to request: Request,
        chainingTo next: Responder
    ) throws -> Response {
        let session = request.session
        
        // move fieldset from session to request
        request.fieldset = session?.fieldset
        session?.fieldset = nil
        
        let response = try next.respond(to: request)
        
        // store any new fieldset in the session for the next request
        session?.fieldset = response.fieldset
        return response
    }
}
