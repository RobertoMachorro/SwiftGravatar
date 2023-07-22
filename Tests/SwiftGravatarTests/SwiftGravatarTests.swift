import XCTest
@testable import SwiftGravatar

final class SwiftGravatarTests: XCTestCase {
	func testGetProfileAddress() {
		let myemailaddress = GravatarProfile.getProfileAddress(using: "myemailaddress@example.com")
		XCTAssertEqual(myemailaddress, "https://en.gravatar.com/0bc83cb571cd1c50ba6f3e8a78ef1346.json")
	}

	func testGetValidProfile() async throws {
		guard let profile = try await GravatarProfile.getProfile(using: "myemailaddress@example.com") else {
			return XCTFail("Unable to retrieve sample profile")
		}
		if let entry = profile.entry.first {
			// Check Profile for personal info
			XCTAssertEqual(entry.preferredUsername, "grevator")
			XCTAssertEqual(entry.profileUrl, "https://gravatar.com/grevator")

			// Check Profile for photos / avatars
			XCTAssertTrue(entry.thumbnailUrl?.count ?? 0 > 0)
			XCTAssertNotNil(entry.photos?.first)
			XCTAssertEqual(entry.photos?.first?.type, "thumbnail")

			// Check Profile for websites
			XCTAssertEqual(entry.urls?.count ?? -1, 0)
		} else {
			XCTFail("No entries to test.")
		}
	}

	func testGetInvalidProfile() async throws {
		let fakeInvalid = try await GravatarProfile.getProfile(using: "fake-invalid@example.com")
		XCTAssertNil(fakeInvalid)
	}

	func testParseGravatarProfileData() async throws {
		// Request JSON Profile Data
		// Docs: https://en.gravatar.com/site/implement/profiles/json/
		guard let url = URL(string: "https://en.gravatar.com/632d2f3abe7be4db174da5cb2760f0ae.json") else {
			return XCTFail("Unable to parse Gravatar URL")
		}
		let (data, _) = try await URLSession.shared.data(from: url)
		let profile = try JSONDecoder().decode(GravatarProfile.self, from: data)

		if let entry = profile.entry.first {
			// Check Profile for personal info
			XCTAssertEqual(entry.preferredUsername, "robertomachorro")
			XCTAssertEqual(entry.profileUrl, "https://gravatar.com/robertomachorro")
			XCTAssertNotNil(entry.name)
			XCTAssertEqual(entry.name?.formatted, "Roberto Machorro")

			// Check Profile for photos / avatars
			XCTAssertNotNil(entry.photos?.first)
			XCTAssertEqual(entry.photos?.first?.type, "thumbnail")

			// Check Profile primary contact, test BooleanString
			XCTAssertNotNil(entry.emails?.first)
			XCTAssertEqual(entry.emails?.count, 1)
			XCTAssertEqual(entry.emails?.first?.primary, .yes)

			// Check Profile for social media accounts
			XCTAssert(entry.accounts?.count ?? 0 > 0)
		} else {
			XCTFail("No entries to test.")
		}
	}
}
