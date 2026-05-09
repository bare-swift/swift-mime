// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

import Testing
@testable import MIME

@Suite("Catalog — IANA constants")
struct CatalogTests {
    @Test("application/json")
    func applicationJSON() {
        #expect(MIMEType.applicationJSON.type == "application")
        #expect(MIMEType.applicationJSON.subtype == "json")
        #expect(MIMEType.applicationJSON.serialized() == "application/json")
    }

    @Test("text/plain")
    func textPlain() {
        #expect(MIMEType.textPlain.serialized() == "text/plain")
    }

    @Test("application/x-protobuf")
    func applicationXProtobuf() {
        #expect(MIMEType.applicationXProtobuf.serialized() == "application/x-protobuf")
    }

    @Test("multipart/form-data")
    func multipartFormData() {
        #expect(MIMEType.multipartFormData.serialized() == "multipart/form-data")
    }

    @Test("image/svg+xml")
    func imageSVG() {
        // "+" is a token char so no quoting needed.
        #expect(MIMEType.imageSVG.serialized() == "image/svg+xml")
    }

    @Test("application/grpc+proto")
    func applicationGRPCProto() {
        #expect(MIMEType.applicationGRPCProto.serialized() == "application/grpc+proto")
    }

    @Test("text/event-stream")
    func textEventStream() {
        #expect(MIMEType.textEventStream.serialized() == "text/event-stream")
    }

    @Test("font/woff2")
    func fontWOFF2() {
        #expect(MIMEType.fontWOFF2.serialized() == "font/woff2")
    }

    @Test("catalog round-trips through parse")
    func catalogRoundTrip() throws {
        let cases: [MIMEType] = [
            .applicationJSON, .textPlain, .applicationXProtobuf,
            .multipartFormData, .imageSVG, .applicationGRPCProto,
            .textEventStream, .fontWOFF2, .applicationOctetStream,
            .applicationFormURLEncoded, .imagePNG, .videoMP4,
        ]
        for mt in cases {
            let parsed = try MIMEType.parse(mt.serialized())
            #expect(parsed == mt, "\(mt.serialized()) failed round-trip")
        }
    }
}
