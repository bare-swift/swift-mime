# swift-mime

RFC 9110 media-type parser, serializer, and curated IANA catalog — Sendable, Foundation-free.

Part of the [bare-swift](https://github.com/bare-swift) ecosystem.

## Install

Add to your `Package.swift`:

```swift
.package(url: "https://github.com/bare-swift/swift-mime.git", from: "0.1.0")
```

Then depend on the `MIME` product:

```swift
.product(name: "MIME", package: "swift-mime")
```

## Usage

```swift
import MIME

let ct = try MIMEType.parse("text/plain; charset=UTF-8")
ct.type                          // "text"
ct.subtype                       // "plain"
ct.parameter(named: "charset")   // "UTF-8"
ct.serialized()                  // "text/plain;charset=UTF-8"

// Curated IANA constants
MIMEType.applicationJSON.serialized()  // "application/json"
MIMEType.multipartFormData             // .multipart/form-data
```

## Scope

`swift-mime` ships v0.1 with:

- `MIMEType` value type (Sendable, Equatable, Hashable).
- Parser per RFC 9110 § 5.6.2 / § 8.3 — token + quoted-string parameter syntax.
- Serializer that round-trips back to header form with quoted-string emission for non-token values.
- ~50 curated IANA media-type constants on `MIMEType` covering common HTTP, RPC, image, audio/video, multipart, and font formats.
- `MIMEError` typed-throws enum.

Out of scope for v0.1: the full IANA registry (~2,000 entries — that's data, not code), structured-suffix parsing (RFC 6839), MIME header decoding (RFC 2047), and multipart body parsing.

## Documentation

Full DocC documentation: <https://bare-swift.github.io/swift-mime/>

## Source

No upstream Rust crate; this is a native bare-swift package implementing the IETF spec directly.

## License

Apache 2.0 with LLVM exception. See [LICENSE](./LICENSE) and [NOTICE](./NOTICE).
