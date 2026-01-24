import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxMacros

public struct UseOkResult: ExpressionMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {

        guard let argument = node.argumentList.first?.expression else {
            throw Require.Error.SyntaxError
        }

        return """
            {
                if case Result.Ok(let __runtime) =  \(argument) {
                    return __runtime
                } else {
                    print("Oh no")
                    throw Require.Error.UnexpectedResult
                }
            }()
            """
    }
}

public struct Require {
    public enum Error: Swift.Error {
        case UnexpectedResult
        case SyntaxError
    }
}

public struct RequireResult: ExpressionMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {

        guard let argument = node.argumentList.first?.expression else {
            throw Require.Error.SyntaxError
        }

        return """
            {
                if case Result.Ok(_) =  \(argument) {
                    true
                } else {
                    false
                }
            }()
            """
    }
}

public struct RequireErrorResult: ExpressionMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {

        let arguments = node.argumentList.indices
        let expected_error = node.argumentList[arguments.startIndex]
        let error_producer = node.argumentList[arguments.index(after: arguments.startIndex)]

        return """
            {
                if case Result.Error(\(expected_error)) = \(error_producer) {
                    true
                } else {
                    false
                }
            }()
            """
    }
}


@main
struct P4Macros: CompilerPlugin {
    var providingMacros: [Macro.Type] = [
        RequireResult.self, RequireErrorResult.self, UseOkResult.self,
    ]
}
