public struct Error: Equatable {
    public private(set) var msg: String

    public init(withMessage msg: String) {
        self.msg = msg
    }
}

public struct Nothing: CustomStringConvertible {
    public var description: String {
        return "Nothing"
    }

    public init() {}
}


public enum Result<T>: Equatable, CustomStringConvertible {
    case Ok(T)
    case Error(Error)

    public static func == (lhs: Result, rhs: Result) -> Bool {
        switch (lhs, rhs) {
        case (Ok, Ok):
            return true
        case (Error(let le), Error(let re)):
            return le.msg == re.msg
        default:
            return false
        }
    }

    public func error() -> Error? {
        if case Result.Error(let e) = self {
            return e
        }
        return nil
    }

    public var description: String {
        switch self {
            case Result.Error(let e):
                return e.msg
            case Result.Ok(let o):
                return "\(o)"
        }
    }
}

@freestanding(expression) public macro RequireOkResult<T>(_: Result<T>) -> Bool =
    #externalMacro(module: "P4Macros", type: "RequireResult")
@freestanding(expression) public macro RequireErrorResult<T>(_: Error, _: Result<T>) -> Bool =
    #externalMacro(module: "P4Macros", type: "RequireErrorResult")
@freestanding(expression) public macro UseOkResult<T>(_: Result<T>) -> T =
    #externalMacro(module: "P4Macros", type: "UseOkResult")
