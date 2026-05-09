// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 The bare-swift Project Authors.

/// Errors thrown by ``MIMEType/parse(_:)``.
public enum MIMEError: Error, Equatable, Sendable {
    /// Input was empty or contained only whitespace.
    case empty

    /// Input did not contain a "/" between type and subtype.
    case missingSubtype

    /// Type or subtype contained characters outside the RFC 9110 token set.
    case invalidToken(String)

    /// A parameter name/value pair was malformed (missing `=`, unterminated
    /// quoted-string, illegal byte in token position, etc.).
    case invalidParameter(String)

    /// A quoted-string parameter value lacked a closing quote.
    case unterminatedQuotedString
}
