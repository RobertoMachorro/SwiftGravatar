//
//  GravatarProfile.swift
//
//
//  Created by Roberto Machorro on 7/21/23.
//

import Foundation
import Crypto

struct GravatarProfile: Decodable {
	let entry: [Entry]

	struct Entry: Decodable {
		let id: String?
		let hash: String
		let requestHash: String
		let profileUrl: String?
		let preferredUsername: String?
		let thumbnailUrl: String?
		let photos: [Photo]?
		let name: Name?
		let displayName: String?
		let pronouns: String?
		let aboutMe: String?
		let currentLocation: String?
		let emails: [Email]?
		let ims: [InstantMessenger]?
		let accounts: [Account]?
		let urls: [Websites]?
	}

	struct Photo: Decodable {
		let value: String
		let type: String // WISHLIST: Build Enum with all types
	}

	struct Name: Decodable {
		let givenName: String?
		let familyName: String?
		let formatted: String?
	}

	struct Email: Decodable {
		let primary: BooleanString
		let value: String
	}

	struct InstantMessenger: Decodable {
		let type: String // WISHLIST: Build Enum with all types
		let value: String
	}

	struct Account: Decodable {
		let domain: String
		let display: String
		let url: String
		let username: String
		let verified: BooleanString
		let shortname: String
	}

	struct Websites: Decodable {
		let value: String
		let title: String
	}

	// WORKAROUND: Gravatar sends Booleans as Strings, which bypasses decoding.
	enum BooleanString: String, Decodable {
		case yes = "true"
		case no = "false" // swiftlint:disable:this identifier_name
	}
}

extension GravatarProfile {
	// Converts e-mail address to a Gravatar web address.
	static func getProfileAddress(using email: String) -> String? {
		guard let emailData = email.data(using: .utf8) else {
			return nil
		}
		let emailMD5 = Insecure.MD5.hash(data: emailData).map { String(format: "%02hhx", $0) }.joined()
		return "https://en.gravatar.com/\(emailMD5).json"
	}

	/* SWIFTNIO
	static func get(using email: String, on request: Request) -> EventLoopFuture<GravatarProfile> {
		guard let emailData = email.data(using: .utf8) else {
			return request.eventLoop.makeFailedFuture(Abort(.badRequest, reason: "Bad email for Gravatar"))
		}
		let emailMD5 = Insecure.MD5.hash(data: emailData).map { String(format: "%02hhx", $0) }.joined()
		let profileUri: URI = "https://en.gravatar.com/\(emailMD5).json"
		return request.client
			.get(profileUri)
			.flatMapThrowing { response in
				guard response.status == .ok else {
					return GravatarProfile(entry: [])
				}
				// let profile = try response.content.decode(GravatarProfile.self)
				//return profile
				return GravatarProfile(entry: [])
			}
	}
	*/
}
