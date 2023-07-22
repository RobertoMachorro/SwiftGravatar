import XCTest
@testable import SwiftGravatar

final class SwiftGravatarTests: XCTestCase {
	func testExample() throws {
		// XCTest Documenation
		// https://developer.apple.com/documentation/xctest

		// Defining Test Cases and Test Methods
		// https://developer.apple.com/documentation/xctest/defining_test_cases_and_test_methods
	}

	func testParseValidGravatar() async throws {
		// Request JSON Profile Data
		// Docs: https://en.gravatar.com/site/implement/profiles/json/
		guard let url = URL(string: "https://en.gravatar.com/632d2f3abe7be4db174da5cb2760f0ae.json") else {
			return XCTFail("Unable to parse Gravatar URL")
		}
		let (data, _) = try await URLSession.shared.data(from: url)
		let profile = try JSONDecoder().decode(GravatarProfile.self, from: data)
		print(profile)
	}
}
