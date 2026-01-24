public class ProgramExecution: CustomStringConvertible {
    public var scopes: Scopes = Scopes()

    public init() {}

    public var description: String {
        return "Runtime:\nScopes: \(scopes)"
    }
}

//public struct ParserRuntime: ProgramRuntime {
public class ParserRuntime: CustomStringConvertible {
    var execution: ParserExecution

    init(execution: ParserExecution) {
        self.execution = execution
    }

    public static func create(program: P4.Parser) -> Result<ParserRuntime> {
        // First, find the start state.
        guard let start_state = program.findStartState() else {
            return Result.Error(Error(withMessage: "Could not find the start state"))
        }
        return Result.Ok(P4.ParserRuntime(execution: P4.ParserExecution(start_state)))
    }

    public func run(input: P4.Packet) -> Result<Nothing> {
        execution.scopes.enter()
        print("Execution: \(execution)")
        while execution.state != P4.accept && execution.state != P4.reject {
            execution = execution.state.evaluate(execution: execution)
            print("Execution: \(execution)")
        }
        return .Ok(Nothing())
    }

    public var description: String {
        //return "\(super.description)\nState: \(execution?.description ?? "N/A")\nError: \(error?.description ?? "None")"
        return "Runtime:\nExecution: \(execution)"
    }
}
