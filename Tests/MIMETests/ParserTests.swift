// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

import Testing
@testable import MIME

@Suite("Parser")
struct ParserTests {
    @Test("simple type/subtype")
    func simple() throws {
        let mt = try MIMEType.parse("text/plain")
        #expect(mt.type == "text")
        #expect(mt.subtype == "plain")
        #expect(mt.parameters.isEmpty)
    }

    @Test("type/subtype lowercased")
    func lowercase() throws {
        let mt = try MIMEType.parse("TEXT/Plain")
        #expect(mt.type == "text")
        #expect(mt.subtype == "plain")
    }

    @Test("single parameter, no whitespace")
    func parameterNoSpace() throws {
        let mt = try MIMEType.parse("text/plain;charset=utf-8")
        #expect(mt.parameters.count == 1)
        #expect(mt.parameters[0].name == "charset")
        #expect(mt.parameters[0].value == "utf-8")
    }

    @Test("OWS around \";\" tolerated")
    func parameterOWS() throws {
        let mt = try MIMEType.parse("text/plain ; charset=utf-8")
        #expect(mt.parameter(named: "charset") == "utf-8")
    }

    @Test("multiple parameters preserved in order")
    func multipleParameters() throws {
        let mt = try MIMEType.parse("application/json; charset=utf-8; version=2")
        #expect(mt.parameters.count == 2)
        #expect(mt.parameters[0].name == "charset")
        #expect(mt.parameters[1].name == "version")
        #expect(mt.parameter(named: "version") == "2")
    }

    @Test("parameter name lowercased; value preserves case")
    func parameterCase() throws {
        let mt = try MIMEType.parse("text/plain; CharSet=UTF-8")
        #expect(mt.parameters[0].name == "charset")
        #expect(mt.parameters[0].value == "UTF-8")
    }

    @Test("quoted-string parameter value")
    func quotedString() throws {
        let mt = try MIMEType.parse(#"multipart/form-data; boundary="ABC123""#)
        #expect(mt.parameter(named: "boundary") == "ABC123")
    }

    @Test("quoted-string with embedded space")
    func quotedStringWithSpace() throws {
        let mt = try MIMEType.parse(#"text/plain; title="hello world""#)
        #expect(mt.parameter(named: "title") == "hello world")
    }

    @Test("quoted-string with backslash-escaped quote")
    func quotedStringEscape() throws {
        let mt = try MIMEType.parse(#"text/plain; q="he said \"hi\"""#)
        #expect(mt.parameter(named: "q") == #"he said "hi""#)
    }

    @Test("leading and trailing OWS")
    func surroundingOWS() throws {
        let mt = try MIMEType.parse("  text/html  ")
        #expect(mt.type == "text")
        #expect(mt.subtype == "html")
    }

    @Test("empty input throws .empty")
    func emptyInput() {
        #expect(throws: MIMEError.empty) {
            try MIMEType.parse("")
        }
        #expect(throws: MIMEError.empty) {
            try MIMEType.parse("   ")
        }
    }

    @Test("missing slash throws .missingSubtype")
    func missingSlash() {
        #expect(throws: MIMEError.missingSubtype) {
            try MIMEType.parse("text")
        }
    }

    @Test("non-token char in type throws .invalidToken")
    func invalidTypeStart() {
        // '/' in first position → empty type → invalidToken("")
        #expect(throws: MIMEError.invalidToken("")) {
            try MIMEType.parse("/plain")
        }
    }

    @Test("missing subtype throws .invalidToken")
    func missingSubtype() {
        #expect(throws: MIMEError.invalidToken("text/")) {
            try MIMEType.parse("text/")
        }
    }

    @Test("parameter without '=' throws .invalidParameter")
    func parameterMissingEquals() {
        #expect(throws: MIMEError.invalidParameter("charset")) {
            try MIMEType.parse("text/plain; charset")
        }
    }

    @Test("unterminated quoted-string throws")
    func unterminatedQuotedString() {
        #expect(throws: MIMEError.unterminatedQuotedString) {
            try MIMEType.parse(#"text/plain; q="open"#)
        }
    }

    @Test("empty parameter value (without quotes) throws")
    func emptyParameterValue() {
        #expect(throws: MIMEError.invalidParameter("charset")) {
            try MIMEType.parse("text/plain; charset=")
        }
    }

    @Test("tolerates empty ; segments")
    func emptySemicolonSegments() throws {
        let mt = try MIMEType.parse("text/plain;;charset=utf-8")
        #expect(mt.parameters.count == 1)
        #expect(mt.parameter(named: "charset") == "utf-8")
    }
}
