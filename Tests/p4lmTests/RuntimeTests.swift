import Foundation
import P4
import P4Macros
import SwiftTreeSitter
import Testing
import TreeSitter
import TreeSitterP4

@testable import Parser

@Test func test_simple_runtime() async throws {
    let simple_parser_declaration = """
        parser simple() {
           state start {
               true;
               transition reject;
           }
        }
        """

    let program = try #UseOkResult(Parser.Program(simple_parser_declaration))
    #expect(#RequireOkResult(P4.ParserRuntime.create(program: program.parsers[0])))
}

@Test func test_simple_runtime_no_start_state() async throws {
    let simple_parser_declaration = """
        parser simple() {
           state tart {
               true;
               transition reject;
           }
        }
        """

    let program = try #UseOkResult(Parser.Program(simple_parser_declaration))
    #expect(
        #RequireErrorResult<ParserRuntime>(
            Error(withMessage: "Could not find the start state"),
            P4.ParserRuntime.create(program: program.parsers[0])))
}

@Test func test_simple_runtime_output() async throws {
    let simple_parser_declaration = """
        parser simple() {
           state start {
               bool b = true;
               transition reject;
           }
        }
        """

    /*
    TODO: Add tests for "semantic" parsing failures. Here's an example!
    print(Parser.Program(simple_parser_declaration))
    #expect(
        #RequireErrorResult(
            Error(
                withMessage:
                    "Failed to parse a local element: <capture 1 \"state-local-elements\": <parserLocalElements range: {42, 14} childCount: 2>>"
            ), Parser.Program(simple_parser_declaration)))
    */
    let program = try #UseOkResult(Parser.Program(simple_parser_declaration))
    let runtime = try #UseOkResult(P4.ParserRuntime.create(program: program.parsers[0]))
    #expect(runtime.run(input: P4.Packet()) == P4.Result.Ok(Nothing()))
}
