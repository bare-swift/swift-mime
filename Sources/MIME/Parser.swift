// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 The bare-swift Project Authors.

/// RFC 9110 § 5.6.2 / § 8.3 media-type parser.
///
/// Grammar (simplified):
/// ```
/// media-type = type "/" subtype *( OWS ";" OWS parameter )
/// parameter  = parameter-name "=" parameter-value
/// token      = 1*tchar
/// quoted-string = DQUOTE *( qdtext / quoted-pair ) DQUOTE
/// ```
enum Parser {
    static func parse(_ input: String) throws(MIMEError) -> MIMEType {
        let scalars = Array(input.unicodeScalars)
        var i = skipOWS(scalars, 0)
        if i >= scalars.count { throw .empty }

        // type
        let typeStart = i
        while i < scalars.count, isToken(scalars[i]) { i += 1 }
        if i == typeStart { throw .invalidToken("") }
        let type = lowercased(scalars, from: typeStart, to: i)

        // "/"
        if i >= scalars.count || scalars[i] != "/" {
            throw .missingSubtype
        }
        i += 1

        // subtype
        let subStart = i
        while i < scalars.count, isToken(scalars[i]) { i += 1 }
        if i == subStart { throw .invalidToken(type + "/") }
        let subtype = lowercased(scalars, from: subStart, to: i)

        var params: [MIMEType.Parameter] = []
        while true {
            i = skipOWS(scalars, i)
            if i >= scalars.count { break }
            if scalars[i] != ";" {
                // Trailing junk after the type/params is not a valid media-type.
                throw .invalidParameter(String(String.UnicodeScalarView(scalars[i..<scalars.count])))
            }
            i += 1
            i = skipOWS(scalars, i)
            // Tolerate empty `;` segments (e.g. `text/plain;;charset=utf-8`).
            if i >= scalars.count { break }
            if scalars[i] == ";" { continue }

            // parameter-name
            let nameStart = i
            while i < scalars.count, isToken(scalars[i]) { i += 1 }
            if i == nameStart {
                throw .invalidParameter(String(String.UnicodeScalarView(scalars[nameStart..<scalars.count])))
            }
            let name = lowercased(scalars, from: nameStart, to: i)

            if i >= scalars.count || scalars[i] != "=" {
                throw .invalidParameter(name)
            }
            i += 1

            // parameter-value (token or quoted-string)
            let value: String
            if i < scalars.count, scalars[i] == "\"" {
                i += 1
                var v = ""
                var closed = false
                while i < scalars.count {
                    let c = scalars[i]
                    if c == "\"" {
                        closed = true
                        i += 1
                        break
                    }
                    if c == "\\" {
                        // quoted-pair: backslash + any VCHAR / WSP
                        i += 1
                        if i >= scalars.count { break }
                        v.unicodeScalars.append(scalars[i])
                        i += 1
                        continue
                    }
                    v.unicodeScalars.append(c)
                    i += 1
                }
                if !closed { throw .unterminatedQuotedString }
                value = v
            } else {
                let valStart = i
                while i < scalars.count, isToken(scalars[i]) { i += 1 }
                if i == valStart {
                    throw .invalidParameter(name)
                }
                value = String(String.UnicodeScalarView(scalars[valStart..<i]))
            }

            params.append(MIMEType.Parameter(name: name, value: value))
        }

        return MIMEType(type: type, subtype: subtype, parameters: params)
    }

    /// Per RFC 9110 § 5.6.2: token chars are
    /// "!" / "#" / "$" / "%" / "&" / "'" / "*" / "+" / "-" / "." / "^"
    /// / "_" / "`" / "|" / "~" / DIGIT / ALPHA.
    static func isToken(_ c: Unicode.Scalar) -> Bool {
        let v = c.value
        if v >= 0x30 && v <= 0x39 { return true }                  // 0-9
        if v >= 0x41 && v <= 0x5A { return true }                  // A-Z
        if v >= 0x61 && v <= 0x7A { return true }                  // a-z
        switch v {
        case 0x21, 0x23, 0x24, 0x25, 0x26, 0x27, 0x2A, 0x2B,
             0x2D, 0x2E, 0x5E, 0x5F, 0x60, 0x7C, 0x7E:
            return true
        default:
            return false
        }
    }

    /// OWS = *( SP / HTAB ).
    private static func skipOWS(_ scalars: [Unicode.Scalar], _ start: Int) -> Int {
        var i = start
        while i < scalars.count, scalars[i] == " " || scalars[i] == "\t" {
            i += 1
        }
        return i
    }

    private static func lowercased(_ scalars: [Unicode.Scalar], from: Int, to: Int) -> String {
        var s = ""
        s.reserveCapacity(to - from)
        for i in from..<to {
            let c = scalars[i]
            if c.value >= 0x41 && c.value <= 0x5A {
                s.unicodeScalars.append(Unicode.Scalar(c.value + 0x20)!)
            } else {
                s.unicodeScalars.append(c)
            }
        }
        return s
    }
}
