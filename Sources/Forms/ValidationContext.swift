import Node

public struct ValidationContext: Context {
    public let shouldValidate: Bool

    public init(shouldValidate: Bool) {
        self.shouldValidate = shouldValidate
    }
}
