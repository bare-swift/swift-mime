// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

import Testing
@testable import MIME

@Suite("MIMEType — public types")
struct MIMETypeTests {
    @Test("Equatable / Hashable conformances")
    func conformances() {
        let a = MIMEType(type: "text", subtype: "plain")
        let b = MIMEType(type: "text", subtype: "plain")
        #expect(a == b)
        #expect(a.hashValue == b.hashValue)
    }

    @Test("parameter(named:) lookup is case-insensitive")
    func parameterLookup() {
        let mt = MIMEType(
            type: "text", subtype: "plain",
            parameters: [.init(name: "charset", value: "UTF-8")]
        )
        #expect(mt.parameter(named: "charset") == "UTF-8")
        #expect(mt.parameter(named: "Charset") == "UTF-8")
        #expect(mt.parameter(named: "CHARSET") == "UTF-8")
        #expect(mt.parameter(named: "missing") == nil)
    }
}
