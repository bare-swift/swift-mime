# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/).

## [Unreleased]

## [0.1.0] - 2026-05-09

### Added
- `MIMEType` value type (Sendable, Equatable, Hashable) with `type`, `subtype`, and ordered `parameters`.
- `MIMEType.parse(_:) throws(MIMEError)` — RFC 9110 § 5.6.2 / § 8.3 media-type parser, including quoted-string parameter values with backslash-escaping.
- `MIMEType.serialized() -> String` — round-trip back to header form, emitting quoted-strings when a value contains tspecials.
- `MIMEType.parameter(named:)` — case-insensitive parameter lookup.
- ~50 curated IANA media types as static constants on `MIMEType` (`.applicationJSON`, `.textPlain`, `.applicationXProtobuf`, `.multipartFormData`, `.textEventStream`, `.imagePNG`, `.fontWOFF2`, `.applicationGRPCProto`, etc.).
- `MIMEError` typed-throws enum (`empty`, `missingSubtype`, `invalidToken`, `invalidParameter`, `unterminatedQuotedString`).

### Dependencies
- None at runtime. Foundation-free.

### Limitations (out of scope for v0.1)
- Full IANA registry (~2,000 entries). The v0.1 catalog is curated; full coverage would be data, not code.
- RFC 6839 structured suffix awareness beyond what the parser already handles syntactically.
- RFC 2047 MIME header word decoding (`=?utf-8?B?...?=`).
- Multipart body parsing — `swift-mime` only parses the header value, not the body.
