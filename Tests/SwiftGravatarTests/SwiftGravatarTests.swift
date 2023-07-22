import XCTest
@testable import SwiftGravatar

final class SwiftGravatarTests: XCTestCase {
	func testParseGravatarProfileData() async throws {
		// Request JSON Profile Data
		// Docs: https://en.gravatar.com/site/implement/profiles/json/
		guard let url = URL(string: "https://en.gravatar.com/632d2f3abe7be4db174da5cb2760f0ae.json") else {
			return XCTFail("Unable to parse Gravatar URL")
		}
		let (data, _) = try await URLSession.shared.data(from: url)
		let profile = try JSONDecoder().decode(GravatarProfileData.self, from: data)

		if let entry = profile.entry.first {
			// Check Profile for personal info
			XCTAssertEqual(entry.preferredUsername, "robertomachorro")
			XCTAssertEqual(entry.profileUrl, "https://gravatar.com/robertomachorro")
			XCTAssertEqual(entry.name.formatted, "Roberto Machorro")

			// Check Profile for photos / avatars
			XCTAssertNotNil(entry.photos.first)
			XCTAssertEqual(entry.photos.first?.type, "thumbnail")

			// Check Profile for social media accounts
			XCTAssert(entry.accounts.count > 0)
		} else {
			XCTFail("No entries to test.")
		}
	}
}
