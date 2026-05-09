// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 The bare-swift Project Authors.

/// Serialize a `MIMEType` back to RFC 9110 header form.
///
/// `type/subtype` is emitted as-is; each parameter is emitted as
/// `; name=value`. Values containing non-token bytes (or empty values)
/// are emitted as quoted-strings with backslash-escaping for `"` and `\`.
enum Serializer {
    static func serialize(_ mt: MIMEType) -> String {
        var out = mt.type
        out.append("/")
        out.append(mt.subtype)
        for p in mt.parameters {
            out.append(";")
            out.append(p.name)
            out.append("=")
            if needsQuoting(p.value) {
                out.append(quote(p.value))
            } else {
                out.append(p.value)
            }
        }
        return out
    }

    private static func needsQuoting(_ v: String) -> Bool {
        if v.isEmpty { return true }
        for scalar in v.unicodeScalars where !Parser.isToken(scalar) {
            return true
        }
        return false
    }

    private static func quote(_ v: String) -> String {
        var out = "\""
        for scalar in v.unicodeScalars {
            if scalar == "\"" || scalar == "\\" {
                out.append("\\")
            }
            out.unicodeScalars.append(scalar)
        }
        out.append("\"")
        return out
    }
}
