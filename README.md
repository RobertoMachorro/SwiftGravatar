![GitHub release (latest by date)](https://img.shields.io/github/v/release/RobertoMachorro/SwiftGravatar)
[![ci](https://github.com/RobertoMachorro/SwiftGravatar/actions/workflows/ci.yml/badge.svg)](https://github.com/RobertoMachorro/SwiftGravatar/actions/workflows/ci.yml)
![GitHub](https://img.shields.io/github/license/RobertoMachorro/SwiftGravatar)
[![StandWithUkraine](https://raw.githubusercontent.com/vshymanskyy/StandWithUkraine/main/badges/StandWithUkraine.svg)](https://vshymanskyy.github.io/StandWithUkraine)

# SwiftGravatar
A Swift library for Gravatar Profile data access.

[Gravatar](https://gravatar.com) is a well known service for centralizing profiles and avatar images. This library allows applications to refer to Gravatar's data instead of reinventing the wheel.

Reach out in [Discussions](https://github.com/RobertoMachorro/SwiftGravatar/discussions) if you have any questions. Report bugs to [Issues](https://github.com/RobertoMachorro/SwiftGravatar/issues).

# Using

Add the SwiftGravatar package to your project or via Package.swift using the address:

https://github.com/RobertoMachorro/SwiftGravatar

<img width="832" alt="image" src="https://github.com/RobertoMachorro/SwiftGravatar/assets/7190436/ba170546-30f6-482b-8c0d-eb4d055e8eaa">

Fetching the profile from the server can be done many ways, the easiest is to use the convenience function *GravatarProfile.getProfile*:

```swift
import SwiftGravatar

if let profile = try await GravatarProfile.getProfile(using: "myemailaddress@example.com"), let entry = profile.entry.first {
	print(entry.preferredUsername)
	print(entry.profileUrl)

	print(entry.thumbnailUrl)
	print(entry.photos?.first?.value)
} else {
	print("We have a problem...")
}
```

Code can also be retrieved by other methods and then decoded:

```swift
guard let url = URL(string: "https://en.gravatar.com/632d2f3abe7be4db174da5cb2760f0ae.json") else {
	return XCTFail("Unable to parse Gravatar URL")
}
let (data, _) = try await URLSession.shared.data(from: url)
let profile = try JSONDecoder().decode(GravatarProfile.self, from: data)
```

An easy converter from e-mail to Gravatar URL can be accessed as follows:

```swift
let myemailaddress = GravatarProfile.getProfileAddress(using: "myemailaddress@example.com")
// "https://en.gravatar.com/0bc83cb571cd1c50ba6f3e8a78ef1346.json"
```

# Contributing

Contributions are very welcome. Fork the repo, make your changes, test with SwiftLint and Unit tests, commit and do a *pull request*.

Gravatar doesn't have an official spec of the JSON data, so there is a lot of trial and error here.
