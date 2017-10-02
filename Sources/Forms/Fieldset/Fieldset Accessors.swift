import HTTP
import Node
import Sessions

// MARK: Session

extension Session {
    public var fieldset: Node? {
        get {
            return data[fieldsetStorageKey]
        }
        set {
            data[fieldsetStorageKey] = newValue
        }
    }
}

// MARK: Request/Reponse

public protocol HasStorage: class {
    var storage: [String: Any] { get set }
}

extension Request: HasStorage {}
extension Response: HasStorage {}

extension HasStorage {

    /// Provides access to the fieldset.
    public var fieldset: Node? {
        get {
            return storage[fieldsetStorageKey] as? Node
        }
        set {
            storage[fieldsetStorageKey] = newValue
        }
    }

    /// Sets the fieldset and returns itself.
    public func setFieldset(_ fieldset: Node?) -> Self {
        storage[fieldsetStorageKey] = fieldset
        return self
    }
}

private let fieldsetStorageKey = "_fieldset"
