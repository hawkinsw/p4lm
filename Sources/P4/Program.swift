public class Identifier: CustomStringConvertible {
    var name: String
    var value: Value

    public init(name: String, withValue value: Value) {
        self.name = name
        self.value = value
    }

    public var description: String {
        return "\(name) = \(value)"
    }
}

public class Variable: Identifier {
    var constant: Bool

    public init(name: String, withValue value: Value, isConstant constant: Bool) {
        self.constant = constant
        super.init(name: name, withValue: value)
    }

    public override var description: String {
        return "\(super.description) \(constant ? "(constant)" : "")"
    }
}

public struct Scope: CustomStringConvertible{
    var variables: [Variable] = Array()
    public init() {}

    public var description: String {
        var result = String()
        for v in variables {
            result += "\(v)"
        }
        return result
    }
}

public struct Scopes: CustomStringConvertible {
    var scopes: [Scope] = Array()

    public init() {}

    public mutating func enter() {
        scopes.append(Scope())
    }

    public mutating func exit() {
        let _ = scopes.popLast()
    }

    public var description: String {
        var result = String()
        for s in scopes {
            result += "Scope: \(s)\n"
        }

        return result
    }
}

public struct Program: CustomStringConvertible {
    public var parsers: [P4.Parser] = Array()
    public init() {}

    public var description: String {
        return "Program"
    }
}
