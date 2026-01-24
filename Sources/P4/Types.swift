// The Swift Programming Language
// https://docs.swift.org/swift-book

public enum ValueType: CustomStringConvertible {
    case Boolean(Bool)

    public var description: String {
        switch self {
            case ValueType.Boolean(let b):
                return "\(b) of Boolean"
        }
    }
}

public struct Value: CustomStringConvertible {
    public var value_type: ValueType

    public init(withValue value: ValueType) {
        self.value_type = value
    }
    public var description: String {
        return "\(value_type)"
    }
}

public class Packet {
    public init() {}
}