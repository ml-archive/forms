import HTTP
import Node
import Sessions

// MARK: Session

extension Session {
    public var fieldSet: Node? {
        get {
            return data[fieldSetStorageKey]
        }
        set {
            data[fieldSetStorageKey] = newValue
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

    /// Provides access to the field set.
    public var fieldSet: Node? {
        get {
            return storage[fieldSetStorageKey] as? Node
        }
        set {
            storage[fieldSetStorageKey] = newValue
        }
    }

    /// Sets the field set on the `Response` and returns itself.
    public func setFieldSet(_ fieldSet: Node?) -> Self {
        storage[fieldSetStorageKey] = fieldSet
        return self
    }
}

private let fieldSetStorageKey = "_fieldset"
