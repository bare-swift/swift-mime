// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

import Testing
@testable import MIME

@Suite("End-to-end")
struct EndToEndTests {
    @Test("realistic Content-Type round-trips")
    func realistic() throws {
        let inputs: [(String, String)] = [
            ("text/plain", "text/plain"),
            ("text/plain; charset=utf-8", "text/plain;charset=utf-8"),
            ("APPLICATION/JSON", "application/json"),
            ("application/json; charset=UTF-8", "application/json;charset=UTF-8"),
            (#"multipart/form-data; boundary="ABC123""#, "multipart/form-data;boundary=ABC123"),
            (#"multipart/form-data; boundary="--with space--""#, #"multipart/form-data;boundary="--with space--""#),
            ("text/html;charset=utf-8;version=5", "text/html;charset=utf-8;version=5"),
        ]
        for (input, expected) in inputs {
            let parsed = try MIMEType.parse(input)
            #expect(parsed.serialized() == expected, "\(input) → \(parsed.serialized()) (want \(expected))")
        }
    }

    @Test("catalog constants are valid Content-Type values")
    func catalogValid() throws {
        let cat: [MIMEType] = [
            .applicationJSON, .applicationXML, .applicationXProtobuf,
            .applicationFormURLEncoded, .applicationGRPCProto,
            .textPlain, .textHTML, .textCSS, .textCSV, .textEventStream,
            .imagePNG, .imageJPEG, .imageWebP, .imageSVG,
            .multipartFormData, .multipartMixed,
            .audioMPEG, .videoMP4, .fontWOFF2,
        ]
        for mt in cat {
            // Each catalog entry must round-trip through the parser.
            let reparsed = try MIMEType.parse(mt.serialized())
            #expect(reparsed == mt)
        }
    }
}
