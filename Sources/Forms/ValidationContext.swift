import Node

public struct ValidationContext: Context {
    public let mode: ValidationMode

    public init(mode: ValidationMode) {
        self.mode = mode
    }
}
