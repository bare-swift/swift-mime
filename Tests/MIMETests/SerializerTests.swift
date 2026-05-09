// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

import Testing
@testable import MIME

@Suite("Serializer")
struct SerializerTests {
    @Test("plain type/subtype")
    func plain() {
        let mt = MIMEType(type: "text", subtype: "plain")
        #expect(mt.serialized() == "text/plain")
    }

    @Test("single token-safe parameter")
    func tokenParameter() {
        let mt = MIMEType(
            type: "text", subtype: "plain",
            parameters: [.init(name: "charset", value: "utf-8")]
        )
        #expect(mt.serialized() == "text/plain;charset=utf-8")
    }

    @Test("value with space → quoted")
    func quotedValue() {
        let mt = MIMEType(
            type: "text", subtype: "plain",
            parameters: [.init(name: "title", value: "hello world")]
        )
        #expect(mt.serialized() == #"text/plain;title="hello world""#)
    }

    @Test("value with embedded \" → backslash-escaped quoted")
    func valueWithQuote() {
        let mt = MIMEType(
            type: "text", subtype: "plain",
            parameters: [.init(name: "q", value: #"he said "hi""#)]
        )
        #expect(mt.serialized() == #"text/plain;q="he said \"hi\"""#)
    }

    @Test("empty value → empty quoted-string")
    func emptyValue() {
        let mt = MIMEType(
            type: "text", subtype: "plain",
            parameters: [.init(name: "x", value: "")]
        )
        #expect(mt.serialized() == #"text/plain;x="""#)
    }

    @Test("multiple parameters preserved in order")
    func multipleParameters() {
        let mt = MIMEType(
            type: "application", subtype: "json",
            parameters: [
                .init(name: "charset", value: "utf-8"),
                .init(name: "version", value: "2"),
            ]
        )
        #expect(mt.serialized() == "application/json;charset=utf-8;version=2")
    }
}
