// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 The bare-swift Project Authors.

/// A parsed MIME media type per RFC 9110 § 8.3 (formerly RFC 7231).
///
/// `MIMEType` carries a top-level `type` (e.g. `text`), a `subtype`
/// (e.g. `plain`), and an ordered list of `parameters`
/// (e.g. `charset=utf-8`). Both `type` and `subtype` are stored
/// lowercased; parameter *names* are lowercased while parameter
/// *values* preserve case.
///
/// Parsing entry point: ``parse(_:)``. Serialization back to header
/// form: ``serialized()``.
public struct MIMEType: Sendable, Equatable, Hashable {
    /// Top-level type, lowercased (e.g. `"text"`, `"application"`).
    public var type: String

    /// Subtype, lowercased (e.g. `"plain"`, `"json"`).
    public var subtype: String

    /// Ordered list of parameters. Names are lowercased; values keep their
    /// original case (case sensitivity is parameter-specific in RFC 9110).
    public var parameters: [Parameter]

    /// A single `name=value` parameter pair.
    public struct Parameter: Sendable, Equatable, Hashable {
        public var name: String
        public var value: String

        public init(name: String, value: String) {
            self.name = name
            self.value = value
        }
    }

    public init(type: String, subtype: String, parameters: [Parameter] = []) {
        self.type = type
        self.subtype = subtype
        self.parameters = parameters
    }

    /// Parse an HTTP `Content-Type` (or any media-type) header value.
    public static func parse(_ headerValue: String) throws(MIMEError) -> MIMEType {
        try Parser.parse(headerValue)
    }

    /// Round-trip back to header form (`type/subtype; param=value`). Values
    /// containing tspecials are emitted as quoted-strings.
    public func serialized() -> String {
        Serializer.serialize(self)
    }

    /// Look up a parameter by name (case-insensitive).
    public func parameter(named: String) -> String? {
        let lower = name(named)
        return parameters.first { $0.name == lower }?.value
    }

    private func name(_ s: String) -> String {
        var out = ""
        for scalar in s.unicodeScalars {
            if scalar.value >= 0x41 && scalar.value <= 0x5A {
                out.unicodeScalars.append(Unicode.Scalar(scalar.value + 0x20)!)
            } else {
                out.unicodeScalars.append(scalar)
            }
        }
        return out
    }
}
