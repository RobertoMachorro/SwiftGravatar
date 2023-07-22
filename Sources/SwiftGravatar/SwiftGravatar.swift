//
//  SwiftGravatar.swift
//
//
//  Created by Roberto Machorro on 7/21/23.
//

import Foundation
import Crypto

public struct GravatarProfile: Decodable {
	public let entry: [Entry]

	public struct Entry: Decodable {
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

	public struct Photo: Decodable {
		let value: String
		let type: String // WISHLIST: Build Enum with all types
	}

	public struct Name: Decodable {
		let givenName: String?
		let familyName: String?
		let formatted: String?
	}

	public struct Email: Decodable {
		let primary: BooleanString
		let value: String
	}

	public struct InstantMessenger: Decodable {
		let type: String // WISHLIST: Build Enum with all types
		let value: String
	}

	public struct Account: Decodable {
		let domain: String
		let display: String
		let url: String
		let username: String
		let verified: BooleanString
		let shortname: String
	}

	public struct Websites: Decodable {
		let value: String
		let title: String
	}

	// WORKAROUND: Gravatar sends Booleans as Strings, which bypasses decoding.
	public enum BooleanString: String, Decodable {
		case yes = "true"
		case no = "false" // swiftlint:disable:this identifier_name
	}
}

extension GravatarProfile {
	// Converts e-mail address to a Gravatar web address.
	public static func getProfileAddress(using email: String) -> String? {
		guard let emailData = email.data(using: .utf8) else {
			return nil
		}
		let emailMD5 = Insecure.MD5.hash(data: emailData).map { String(format: "%02hhx", $0) }.joined()
		return "https://en.gravatar.com/\(emailMD5).json"
	}

	// Request JSON Profile Data from Gravatar
	// Docs: https://en.gravatar.com/site/implement/profiles/json/
	public static func getProfile(using email: String) async throws -> GravatarProfile? {
		guard let address = getProfileAddress(using: email), let url = URL(string: address) else {
			return nil
		}
		do {
			let (data, _) = try await URLSession.shared.data(from: url)
			let profile = try JSONDecoder().decode(GravatarProfile.self, from: data)
			return profile
		} catch {
			// Silent fail
		}
		return nil
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
