// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 The bare-swift Project Authors.

/// Curated catalog of common IANA media types as static constants on
/// ``MIMEType``. ~50 entries covering the formats most likely to appear
/// in HTTP servers, RPC frameworks, and content-negotiation code.
///
/// Source: <https://www.iana.org/assignments/media-types/media-types.xhtml>
///
/// This is intentionally a curated subset. Full IANA coverage (~2,000+
/// entries) is data, not code, and is deferred to a future companion
/// package.
extension MIMEType {
    // MARK: - application/*

    public static let applicationJSON = MIMEType(type: "application", subtype: "json")
    public static let applicationJSONLines = MIMEType(type: "application", subtype: "jsonl")
    public static let applicationLDJSON = MIMEType(type: "application", subtype: "ld+json")
    public static let applicationXML = MIMEType(type: "application", subtype: "xml")
    public static let applicationXProtobuf = MIMEType(type: "application", subtype: "x-protobuf")
    public static let applicationProtobuf = MIMEType(type: "application", subtype: "protobuf")
    public static let applicationGRPC = MIMEType(type: "application", subtype: "grpc")
    public static let applicationGRPCProto = MIMEType(type: "application", subtype: "grpc+proto")
    public static let applicationGRPCJSON = MIMEType(type: "application", subtype: "grpc+json")
    public static let applicationOctetStream = MIMEType(type: "application", subtype: "octet-stream")
    public static let applicationFormURLEncoded = MIMEType(type: "application", subtype: "x-www-form-urlencoded")
    public static let applicationPDF = MIMEType(type: "application", subtype: "pdf")
    public static let applicationZip = MIMEType(type: "application", subtype: "zip")
    public static let applicationGzip = MIMEType(type: "application", subtype: "gzip")
    public static let applicationTar = MIMEType(type: "application", subtype: "x-tar")
    public static let applicationJavaScript = MIMEType(type: "application", subtype: "javascript")
    public static let applicationWASM = MIMEType(type: "application", subtype: "wasm")
    public static let applicationYAML = MIMEType(type: "application", subtype: "yaml")
    public static let applicationTOML = MIMEType(type: "application", subtype: "toml")
    public static let applicationCBOR = MIMEType(type: "application", subtype: "cbor")
    public static let applicationMessagePack = MIMEType(type: "application", subtype: "msgpack")
    public static let applicationProblemJSON = MIMEType(type: "application", subtype: "problem+json")

    // MARK: - text/*

    public static let textPlain = MIMEType(type: "text", subtype: "plain")
    public static let textHTML = MIMEType(type: "text", subtype: "html")
    public static let textCSS = MIMEType(type: "text", subtype: "css")
    public static let textCSV = MIMEType(type: "text", subtype: "csv")
    public static let textJavaScript = MIMEType(type: "text", subtype: "javascript")
    public static let textXML = MIMEType(type: "text", subtype: "xml")
    public static let textMarkdown = MIMEType(type: "text", subtype: "markdown")
    public static let textEventStream = MIMEType(type: "text", subtype: "event-stream")

    // MARK: - image/*

    public static let imagePNG = MIMEType(type: "image", subtype: "png")
    public static let imageJPEG = MIMEType(type: "image", subtype: "jpeg")
    public static let imageGIF = MIMEType(type: "image", subtype: "gif")
    public static let imageWebP = MIMEType(type: "image", subtype: "webp")
    public static let imageSVG = MIMEType(type: "image", subtype: "svg+xml")
    public static let imageAVIF = MIMEType(type: "image", subtype: "avif")
    public static let imageBMP = MIMEType(type: "image", subtype: "bmp")
    public static let imageICO = MIMEType(type: "image", subtype: "vnd.microsoft.icon")

    // MARK: - audio/* and video/*

    public static let audioMPEG = MIMEType(type: "audio", subtype: "mpeg")
    public static let audioOgg = MIMEType(type: "audio", subtype: "ogg")
    public static let audioWAV = MIMEType(type: "audio", subtype: "wav")
    public static let audioWebM = MIMEType(type: "audio", subtype: "webm")
    public static let videoMP4 = MIMEType(type: "video", subtype: "mp4")
    public static let videoWebM = MIMEType(type: "video", subtype: "webm")
    public static let videoOgg = MIMEType(type: "video", subtype: "ogg")

    // MARK: - multipart/* (parameters such as boundary= are added at use site)

    public static let multipartFormData = MIMEType(type: "multipart", subtype: "form-data")
    public static let multipartMixed = MIMEType(type: "multipart", subtype: "mixed")
    public static let multipartAlternative = MIMEType(type: "multipart", subtype: "alternative")
    public static let multipartByteranges = MIMEType(type: "multipart", subtype: "byteranges")

    // MARK: - font/*

    public static let fontWOFF = MIMEType(type: "font", subtype: "woff")
    public static let fontWOFF2 = MIMEType(type: "font", subtype: "woff2")
    public static let fontTTF = MIMEType(type: "font", subtype: "ttf")
    public static let fontOTF = MIMEType(type: "font", subtype: "otf")
}
