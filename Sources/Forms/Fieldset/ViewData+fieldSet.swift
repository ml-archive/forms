import Vapor

extension ViewData {

    /// Provides a convenient way to initialize ViewData values.
    ///
    /// Example:
    /// ```
    /// let viewData = ViewData([
    ///     .fieldset: fieldset,
    ///     .request: request,
    ///     "other": "value".
    /// ])
    /// ```
    ///
    /// - Parameters:
    ///   - dict: keys and values to add contruct the new value from.
    ///   - context: context to use when creating nodes from the values in `dict`
    /// - Throws: on errors during makeNode
    public init(
        _ dict: [ViewDataKey: NodeRepresentable],
        in context: Context = ViewContext.shared
    ) throws {
        var stringDict: [String: NodeRepresentable] = [:]
        dict.forEach { (key, value) in
            stringDict[key.rawValue] = value
        }
        try self.init(stringDict.makeNode(in: context))
    }
}

public enum ViewDataKey: RawRepresentable {
    public init?(rawValue: String) {
        self.init(string: rawValue)
    }

    public init(string: String) {
        switch string {
        case "fieldset": self = .fieldset
        case "request": self = .request
        default: self = .other(string)
        }
    }

    public var rawValue: String {
        switch self {
        case .fieldset: return "fieldset"
        case .request: return "request"
        case .other(let string): return string
        }
    }

    case request
    case fieldset
    case other(String)
}

extension ViewDataKey: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(string: value)
    }
}

extension ViewDataKey: Hashable {
    public static func == (l: ViewDataKey, r: ViewDataKey) -> Bool {
        switch (l, r) {
        case (.other(let l), .other(let r)) where l == r: fallthrough
        case (.request, .request), (.fieldset, .fieldset):
            return true
        default:
            return false
        }
    }

    public var hashValue: Int {
        return String(describing: self).hashValue
    }
}
