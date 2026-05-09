# ``MIME``

RFC 9110 media-type parser, serializer, and curated IANA catalog — Sendable, Foundation-free.

## Overview

`MIME` parses HTTP `Content-Type` (and any media-type) header values into a
structured ``MIMEType`` and serializes them back per RFC 9110 § 5.6.2 / § 8.3.
Top-level type and subtype are normalized to lowercase; parameter values
preserve case. Parameter values containing tspecials are emitted as
quoted-strings on serialization.

The module ships a ~50-entry catalog of common IANA media types as static
constants on ``MIMEType`` (`.applicationJSON`, `.textPlain`, `.imagePNG`, …).
Full IANA coverage is intentionally deferred — that's data, not code.

```swift
import MIME

let ct = try MIMEType.parse("text/plain; charset=UTF-8")
ct.type                          // "text"
ct.subtype                       // "plain"
ct.parameter(named: "charset")   // "UTF-8"
ct.serialized()                  // "text/plain;charset=UTF-8"

MIMEType.applicationJSON.serialized()  // "application/json"
```

## Topics

### Essentials

- ``MIMEType``
- ``MIMEError``
